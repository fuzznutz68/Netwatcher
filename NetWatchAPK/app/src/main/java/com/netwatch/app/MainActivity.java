package com.netwatch.app;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.Typeface;
import android.net.VpnService;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class MainActivity extends Activity {

    private static final int VPN_REQUEST_CODE  = 1001;
    private static final int NOTIF_PERM_CODE   = 1002;

    private static final String DOMAIN_INTEL_URL = "https://superagent-cfb25b3e.base44.app/functions/domainIntel";
    private static final String TRAFFIC_PROBE_URL = "https://superagent-cfb25b3e.base44.app/functions/trafficProbe";

    // Tab views
    private View   tab1, tab2;
    private Button tabDomainBtn, tabTrafficBtn;

    // Tab 1 – Domain Intel
    private EditText     domainInput;
    private Button       lookupBtn;
    private LinearLayout resultsContainer;
    private TextView     statusText;

    // Tab 2 – Traffic Monitor
    private EditText     targetDomainInput;
    private Button       startVpnBtn, stopVpnBtn;
    private LinearLayout trafficLogContainer;
    private ScrollView   trafficScrollView;
    private TextView     vpnStatusText;

    private boolean           vpnRunning = false;
    private final ExecutorService executor   = Executors.newCachedThreadPool();
    private final Handler     mainHandler = new Handler(Looper.getMainLooper());

    private BroadcastReceiver trafficReceiver;

    // ── Lifecycle ─────────────────────────────────────────────────────────────

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Tab buttons & containers
        tabDomainBtn  = findViewById(R.id.tabDomainBtn);
        tabTrafficBtn = findViewById(R.id.tabTrafficBtn);
        tab1          = findViewById(R.id.tab1);
        tab2          = findViewById(R.id.tab2);

        // Domain intel views
        domainInput      = findViewById(R.id.domainInput);
        lookupBtn        = findViewById(R.id.lookupBtn);
        resultsContainer = findViewById(R.id.resultsContainer);
        statusText       = findViewById(R.id.statusText);

        // Traffic monitor views
        targetDomainInput   = findViewById(R.id.targetDomainInput);
        startVpnBtn         = findViewById(R.id.startVpnBtn);
        stopVpnBtn          = findViewById(R.id.stopVpnBtn);
        trafficLogContainer = findViewById(R.id.trafficLogContainer);
        trafficScrollView   = findViewById(R.id.trafficScrollView);
        vpnStatusText       = findViewById(R.id.vpnStatusText);

        // Tab switching
        tabDomainBtn.setSelected(true);
        tabDomainBtn.setOnClickListener(v -> switchTab(0));
        tabTrafficBtn.setOnClickListener(v -> switchTab(1));

        // Domain lookup
        lookupBtn.setOnClickListener(v -> performLookup());
        domainInput.setOnEditorActionListener((v, action, event) -> { performLookup(); return true; });

        // VPN buttons
        startVpnBtn.setOnClickListener(v -> startMonitoring());
        stopVpnBtn.setOnClickListener(v -> stopMonitoring());

        // Register traffic broadcast receiver — API 33+ requires exported flag
        trafficReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                String direction = intent.getStringExtra("direction");
                String protocol  = intent.getStringExtra("protocol");
                String host      = intent.getStringExtra("host");
                String ipPort    = intent.getStringExtra("ipPort");
                int    bytes     = intent.getIntExtra("bytes", 0);
                String timestamp = intent.getStringExtra("timestamp");
                addTrafficRow(direction, protocol, host, ipPort, bytes, timestamp);
            }
        };

        IntentFilter filter = new IntentFilter(NetWatchVpnService.TRAFFIC_ACTION);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            // Android 13+ — must specify exported flag
            registerReceiver(trafficReceiver, filter, Context.RECEIVER_NOT_EXPORTED);
        } else {
            registerReceiver(trafficReceiver, filter);
        }

        // Request POST_NOTIFICATIONS permission on Android 13+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS)
                    != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(
                        new String[]{android.Manifest.permission.POST_NOTIFICATIONS},
                        NOTIF_PERM_CODE);
            }
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        // Notification permission result — app works fine either way
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    // ── Tab navigation ────────────────────────────────────────────────────────

    private void switchTab(int index) {
        tab1.setVisibility(index == 0 ? View.VISIBLE : View.GONE);
        tab2.setVisibility(index == 1 ? View.VISIBLE : View.GONE);
        tabDomainBtn.setSelected(index == 0);
        tabTrafficBtn.setSelected(index == 1);
    }

    // ── Domain Intelligence ───────────────────────────────────────────────────

    private void performLookup() {
        String raw = domainInput.getText().toString().trim();
        if (raw.isEmpty()) { showToast("Please enter a domain"); return; }
        String domain = raw.replaceAll("https?://", "").replaceAll("/.*", "");

        resultsContainer.removeAllViews();
        statusText.setText("⏳ Scanning " + domain + "…");
        lookupBtn.setEnabled(false);

        executor.execute(() -> {
            String intelResult = postJson(DOMAIN_INTEL_URL,  "{\"domain\":\"" + domain + "\"}");
            String probeResult = postJson(TRAFFIC_PROBE_URL, "{\"domain\":\"" + domain + "\"}");

            mainHandler.post(() -> {
                lookupBtn.setEnabled(true);
                if (intelResult == null && probeResult == null) {
                    statusText.setText("❌ Network error — check connection");
                    return;
                }
                statusText.setText("✅ Scan complete for " + domain);
                buildResultCards(domain, intelResult, probeResult);
            });
        });
    }

    private void buildResultCards(String domain, String intelJson, String probeJson) {
        try {
            if (intelJson != null) {
                JSONObject intel = new JSONObject(intelJson);

                if (intel.has("ipv4") && intel.getJSONArray("ipv4").length() > 0)
                    addCard("🌐 IPv4 Addresses", formatArray(intel.getJSONArray("ipv4")), "#A5D6A7");

                if (intel.has("ipv6") && intel.getJSONArray("ipv6").length() > 0)
                    addCard("🌐 IPv6 Addresses", formatArray(intel.getJSONArray("ipv6")), "#A5D6A7");

                if (intel.has("cname") && !intel.getString("cname").isEmpty())
                    addCard("🔗 CNAME", intel.getString("cname"), "#90CAF9");

                if (intel.has("ns") && intel.getJSONArray("ns").length() > 0)
                    addCard("🗄 Name Servers", formatArray(intel.getJSONArray("ns")), "#CE93D8");

                if (intel.has("mx") && intel.getJSONArray("mx").length() > 0)
                    addCard("📬 Mail Servers (MX)", formatArray(intel.getJSONArray("mx")), "#90CAF9");

                if (intel.has("txt") && intel.getJSONArray("txt").length() > 0)
                    addCard("📝 TXT Records", formatArray(intel.getJSONArray("txt")), "#DCEDC8");

                if (intel.has("subdomains") && intel.getJSONArray("subdomains").length() > 0)
                    addSubdomainCard(intel.getJSONArray("subdomains"));

                if (intel.has("reverseIp") && intel.getJSONArray("reverseIp").length() > 0)
                    addCard("🔄 Reverse IP Lookup", formatArray(intel.getJSONArray("reverseIp")), "#90A4AE");
            }

            if (probeJson != null) {
                JSONObject probe = new JSONObject(probeJson);

                if (probe.has("tls") && !probe.isNull("tls")) {
                    JSONObject tls = probe.getJSONObject("tls");
                    StringBuilder sb = new StringBuilder();
                    if (tls.has("subject"))  sb.append("Subject:  ").append(tls.optString("subject")).append("\n");
                    if (tls.has("issuer"))   sb.append("Issuer:   ").append(tls.optString("issuer")).append("\n");
                    if (tls.has("valid_to")) sb.append("Expires:  ").append(tls.optString("valid_to")).append("\n");
                    if (tls.has("protocol")) sb.append("Protocol: ").append(tls.optString("protocol"));
                    if (sb.length() > 0) addCard("🔒 TLS Certificate", sb.toString().trim(), "#80CBC4");
                }

                if (probe.has("ports")) {
                    JSONArray ports = probe.getJSONArray("ports");
                    StringBuilder sb = new StringBuilder();
                    for (int i = 0; i < ports.length(); i++) {
                        JSONObject p = ports.getJSONObject(i);
                        String status = p.optString("status", "closed");
                        sb.append("open".equals(status) ? "🟢" : "🔴")
                          .append(" Port ").append(p.optInt("port"))
                          .append(" (").append(p.optString("service")).append(") — ").append(status).append("\n");
                    }
                    if (sb.length() > 0) addCard("🔌 Port Scan", sb.toString().trim(), "#90CAF9");
                }

                if (probe.has("http")) {
                    JSONObject http = probe.getJSONObject("http");
                    StringBuilder sb = new StringBuilder();
                    if (http.has("statusCode")) sb.append("HTTP Status:   ").append(http.optInt("statusCode")).append("\n");
                    if (http.has("server"))     sb.append("Server:        ").append(http.optString("server")).append("\n");
                    if (http.has("poweredBy"))  sb.append("Powered By:    ").append(http.optString("poweredBy")).append("\n");
                    if (http.has("finalUrl"))   sb.append("Resolved URL:  ").append(http.optString("finalUrl"));
                    if (sb.length() > 0) addCard("🌍 HTTP Response", sb.toString().trim(), "#BCAAA4");
                }

                if (probe.has("dnsLatencyMs"))
                    addCard("⚡ DNS Latency", probe.optInt("dnsLatencyMs") + " ms", "#90A4AE");
            }

        } catch (Exception e) {
            statusText.setText("⚠ Parse error: " + e.getMessage());
        }
    }

    private void addCard(String title, String value, String valueColor) {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setBackgroundResource(R.drawable.card_background);
        card.setPadding(dp(14), dp(12), dp(14), dp(12));
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        lp.bottomMargin = dp(10);
        card.setLayoutParams(lp);

        TextView titleView = new TextView(this);
        titleView.setText(title);
        titleView.setTextSize(11);
        titleView.setTextColor(Color.parseColor("#64B5F6"));
        titleView.setAllCaps(true);
        titleView.setTypeface(null, Typeface.BOLD);
        titleView.setPadding(0, 0, 0, dp(4));
        card.addView(titleView);

        TextView valueView = new TextView(this);
        valueView.setText(value);
        valueView.setTextSize(14);
        try { valueView.setTextColor(Color.parseColor(valueColor)); }
        catch (Exception e) { valueView.setTextColor(Color.WHITE); }
        valueView.setTypeface(Typeface.MONOSPACE);
        card.addView(valueView);

        resultsContainer.addView(card);
    }

    private void addSubdomainCard(JSONArray subdomains) {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setBackgroundResource(R.drawable.card_background);
        card.setPadding(dp(14), dp(12), dp(14), dp(12));
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        lp.bottomMargin = dp(10);
        card.setLayoutParams(lp);

        TextView titleView = new TextView(this);
        titleView.setText("🌿 Subdomains (" + subdomains.length() + " found)");
        titleView.setTextSize(11);
        titleView.setTextColor(Color.parseColor("#64B5F6"));
        titleView.setAllCaps(true);
        titleView.setTypeface(null, Typeface.BOLD);
        titleView.setPadding(0, 0, 0, dp(4));
        card.addView(titleView);

        try {
            for (int i = 0; i < subdomains.length(); i++) {
                JSONObject sd = subdomains.getJSONObject(i);
                LinearLayout row = new LinearLayout(this);
                row.setOrientation(LinearLayout.VERTICAL);
                row.setPadding(0, dp(4), 0, dp(4));

                TextView nameView = new TextView(this);
                nameView.setText("▸ " + sd.optString("name"));
                nameView.setTextSize(14);
                nameView.setTextColor(Color.parseColor("#80DEEA"));
                nameView.setTypeface(Typeface.MONOSPACE);
                row.addView(nameView);

                JSONArray ips = sd.optJSONArray("ips");
                if (ips != null && ips.length() > 0) {
                    TextView ipView = new TextView(this);
                    ipView.setText("  IPs: " + formatArray(ips));
                    ipView.setTextSize(12);
                    ipView.setTextColor(Color.parseColor("#90A4AE"));
                    ipView.setTypeface(Typeface.MONOSPACE);
                    row.addView(ipView);
                }
                card.addView(row);
            }
        } catch (Exception ignored) {}

        resultsContainer.addView(card);
    }

    // ── Traffic Monitor ───────────────────────────────────────────────────────

    private void startMonitoring() {
        String domain = targetDomainInput.getText().toString().trim();
        if (domain.isEmpty()) { showToast("Enter a domain to monitor"); return; }

        Intent vpnIntent = VpnService.prepare(this);
        if (vpnIntent != null) {
            startActivityForResult(vpnIntent, VPN_REQUEST_CODE);
        } else {
            launchVpnService(domain);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == VPN_REQUEST_CODE) {
            if (resultCode == RESULT_OK) {
                launchVpnService(targetDomainInput.getText().toString().trim());
            } else {
                showToast("VPN permission denied");
            }
        }
    }

    private void launchVpnService(String domain) {
        trafficLogContainer.removeAllViews();
        vpnRunning = true;
        startVpnBtn.setEnabled(false);
        stopVpnBtn.setEnabled(true);
        vpnStatusText.setText("🟢 Monitoring active — watching: " + domain);
        vpnStatusText.setTextColor(Color.parseColor("#66BB6A"));

        Intent serviceIntent = new Intent(this, NetWatchVpnService.class);
        serviceIntent.putExtra("target_domain", domain);
        startForegroundService(serviceIntent);   // API 26+ — must use startForegroundService
    }

    private void stopMonitoring() {
        vpnRunning = false;
        startVpnBtn.setEnabled(true);
        stopVpnBtn.setEnabled(false);
        vpnStatusText.setText("⚫ Monitoring stopped");
        vpnStatusText.setTextColor(Color.parseColor("#78909C"));

        Intent serviceIntent = new Intent(this, NetWatchVpnService.class);
        serviceIntent.setAction(NetWatchVpnService.ACTION_STOP);
        startService(serviceIntent);
    }

    private void addTrafficRow(String direction, String protocol, String host,
                                String ipPort, int bytes, String timestamp) {
        String dirColor = "⬆".equals(direction) ? "#EF9A9A" : "#A5D6A7";

        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setPadding(0, dp(5), 0, dp(5));

        TextView dirView = new TextView(this);
        dirView.setText(direction + " ");
        dirView.setTextSize(16);
        dirView.setTextColor(Color.parseColor(dirColor));
        row.addView(dirView);

        LinearLayout info = new LinearLayout(this);
        info.setOrientation(LinearLayout.VERTICAL);
        info.setLayoutParams(new LinearLayout.LayoutParams(0,
                LinearLayout.LayoutParams.WRAP_CONTENT, 1));

        TextView hostView = new TextView(this);
        hostView.setText(protocol + "  " + (host == null || host.isEmpty() ? ipPort : host));
        hostView.setTextSize(13);
        hostView.setTextColor(Color.parseColor("#E3F2FD"));
        hostView.setTypeface(Typeface.MONOSPACE);
        info.addView(hostView);

        TextView metaView = new TextView(this);
        metaView.setText(ipPort + "  •  " + bytes + " B  •  " + timestamp);
        metaView.setTextSize(11);
        metaView.setTextColor(Color.parseColor("#78909C"));
        info.addView(metaView);

        row.addView(info);

        View divider = new View(this);
        divider.setLayoutParams(new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, 1));
        divider.setBackgroundColor(Color.parseColor("#1E3A5F"));

        trafficLogContainer.addView(row);
        trafficLogContainer.addView(divider);

        trafficScrollView.post(() -> trafficScrollView.fullScroll(ScrollView.FOCUS_DOWN));
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private String postJson(String urlStr, String body) {
        try {
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(15000);
            conn.setReadTimeout(20000);
            try (OutputStream os = conn.getOutputStream()) {
                os.write(body.getBytes("UTF-8"));
            }
            int code = conn.getResponseCode();
            BufferedReader reader = new BufferedReader(new InputStreamReader(
                    code >= 200 && code < 300 ? conn.getInputStream() : conn.getErrorStream()));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
            reader.close();
            return sb.toString();
        } catch (Exception e) {
            return null;
        }
    }

    private String formatArray(JSONArray arr) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < arr.length(); i++) {
            if (i > 0) sb.append("\n");
            sb.append(arr.optString(i));
        }
        return sb.toString();
    }

    private int dp(int val) {
        return (int) (val * getResources().getDisplayMetrics().density);
    }

    private void showToast(String msg) {
        Toast.makeText(this, msg, Toast.LENGTH_SHORT).show();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        try { unregisterReceiver(trafficReceiver); } catch (Exception ignored) {}
        executor.shutdownNow();
    }
}
