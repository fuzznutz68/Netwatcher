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

    private static final int VPN_REQUEST_CODE = 1001;
    private static final int NOTIF_PERM_CODE  = 1002;

    private static final String DOMAIN_INTEL_URL  = "https://superagent-cfb25b3e.base44.app/functions/domainIntel";
    private static final String TRAFFIC_PROBE_URL = "https://superagent-cfb25b3e.base44.app/functions/trafficProbe";

    // Tabs
    private View   tab1, tab2;
    private Button tabDomainBtn, tabTrafficBtn;

    // Tab 1 — Domain Intel
    private EditText     domainInput;
    private Button       lookupBtn;
    private LinearLayout resultsContainer;
    private TextView     statusText;

    // Tab 2 — Traffic Monitor
    private EditText     targetDomainInput;
    private Button       startVpnBtn, stopVpnBtn, clearLogBtn;
    private LinearLayout trafficLogContainer;
    private ScrollView   trafficScrollView;
    private TextView     vpnStatusText, connectionCountText;

    private int connectionCount = 0;

    private final ExecutorService executor    = Executors.newCachedThreadPool();
    private final Handler         mainHandler = new Handler(Looper.getMainLooper());
    private BroadcastReceiver     trafficReceiver;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Tabs
        tabDomainBtn  = findViewById(R.id.tabDomainBtn);
        tabTrafficBtn = findViewById(R.id.tabTrafficBtn);
        tab1          = findViewById(R.id.tab1);
        tab2          = findViewById(R.id.tab2);

        // Tab 1
        domainInput      = findViewById(R.id.domainInput);
        lookupBtn        = findViewById(R.id.lookupBtn);
        resultsContainer = findViewById(R.id.resultsContainer);
        statusText       = findViewById(R.id.statusText);

        // Tab 2
        targetDomainInput   = findViewById(R.id.targetDomainInput);
        startVpnBtn         = findViewById(R.id.startVpnBtn);
        stopVpnBtn          = findViewById(R.id.stopVpnBtn);
        clearLogBtn         = findViewById(R.id.clearLogBtn);
        trafficLogContainer = findViewById(R.id.trafficLogContainer);
        trafficScrollView   = findViewById(R.id.trafficScrollView);
        vpnStatusText       = findViewById(R.id.vpnStatusText);
        connectionCountText = findViewById(R.id.connectionCountText);

        // Tab switching
        tabDomainBtn.setSelected(true);
        tabDomainBtn.setOnClickListener(v -> switchTab(0));
        tabTrafficBtn.setOnClickListener(v -> switchTab(1));

        // Domain Intel
        lookupBtn.setOnClickListener(v -> performLookup());
        domainInput.setOnEditorActionListener((v, action, event) -> { performLookup(); return true; });

        // Traffic Monitor
        startVpnBtn.setOnClickListener(v -> startMonitoring());
        stopVpnBtn.setOnClickListener(v -> stopMonitoring());
        clearLogBtn.setOnClickListener(v -> {
            trafficLogContainer.removeAllViews();
            connectionCount = 0;
            connectionCountText.setText("");
        });

        // Broadcast receiver for VPN traffic events
        trafficReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                mainHandler.post(() -> addTrafficRow(
                    intent.getStringExtra("direction"),
                    intent.getStringExtra("protocol"),
                    intent.getStringExtra("host"),
                    intent.getStringExtra("ipPort"),
                    intent.getIntExtra("bytes", 0),
                    intent.getStringExtra("timestamp")
                ));
            }
        };
        IntentFilter filter = new IntentFilter(NetWatchVpnService.TRAFFIC_ACTION);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(trafficReceiver, filter, Context.RECEIVER_NOT_EXPORTED);
        } else {
            registerReceiver(trafficReceiver, filter);
        }

        // Notification permission on Android 13+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS)
                    != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(
                    new String[]{android.Manifest.permission.POST_NOTIFICATIONS},
                    NOTIF_PERM_CODE);
            }
        }
    }

    private void switchTab(int index) {
        tab1.setVisibility(index == 0 ? View.VISIBLE : View.GONE);
        tab2.setVisibility(index == 1 ? View.VISIBLE : View.GONE);
        tabDomainBtn.setSelected(index == 0);
        tabTrafficBtn.setSelected(index == 1);
    }

    // ═════════════════════════════════════════════════════════════════════════
    // Domain Intel
    // ═════════════════════════════════════════════════════════════════════════

    private void performLookup() {
        String raw = domainInput.getText().toString().trim();
        if (raw.isEmpty()) { showToast("Enter a domain"); return; }
        String domain = raw.replaceAll("(?i)https?://", "").replaceAll("/.*", "").toLowerCase().trim();

        resultsContainer.removeAllViews();
        statusText.setText("⏳  Scanning " + domain + " …");
        lookupBtn.setEnabled(false);

        executor.execute(() -> {
            String intelJson = postJson(DOMAIN_INTEL_URL,  "{\"domain\":\"" + domain + "\"}");
            String probeJson = postJson(TRAFFIC_PROBE_URL, "{\"domain\":\"" + domain + "\"}");

            mainHandler.post(() -> {
                lookupBtn.setEnabled(true);
                if (intelJson == null && probeJson == null) {
                    statusText.setText("❌  Network error — check connection");
                    return;
                }
                statusText.setText("✅  Scan complete for " + domain);
                buildReport(domain, intelJson, probeJson);
            });
        });
    }

    private void buildReport(String domain, String intelJson, String probeJson) {
        try {
            JSONObject intel = intelJson != null ? new JSONObject(intelJson) : null;
            JSONObject probe = probeJson != null ? new JSONObject(probeJson) : null;

            if (intel != null && intel.has("error") && !intel.has("ipv4")) {
                addCard("❌ API Error", intel.optString("error"), "#EF9A9A");
                return;
            }

            // 1. Main Domain
            if (intel != null) {
                StringBuilder sb = new StringBuilder();
                JSONArray ipv4 = intel.optJSONArray("ipv4");
                if (ipv4 != null && ipv4.length() > 0) {
                    sb.append("IPv4:\n");
                    for (int i = 0; i < ipv4.length(); i++)
                        sb.append("  ").append(ipv4.optString(i)).append("\n");
                }
                JSONArray ipv6 = intel.optJSONArray("ipv6");
                if (ipv6 != null && ipv6.length() > 0) {
                    sb.append("IPv6:\n");
                    for (int i = 0; i < ipv6.length(); i++)
                        sb.append("  ").append(ipv6.optString(i)).append("\n");
                }
                String cname = intel.optString("cname", "");
                if (!cname.isEmpty() && !cname.equals("null"))
                    sb.append("CNAME:  ").append(cname).append("\n");
                if (sb.length() > 0)
                    addCard("🌐  " + domain, sb.toString().trim(), "#A5D6A7");
            }

            // 2. Subdomains
            if (intel != null) {
                JSONArray subs = intel.optJSONArray("subdomains");
                if (subs != null && subs.length() > 0) {
                    addSubdomainsCard(subs);
                } else {
                    addCard("🌿  Subdomains", "None discovered", "#546E7A");
                }
            }

            // 3. Hidden / Shared-Host Domains
            if (intel != null) {
                JSONArray shared = intel.optJSONArray("sharedHostDomains");
                if (shared != null && shared.length() > 0) {
                    StringBuilder sb = new StringBuilder();
                    for (int i = 0; i < shared.length(); i++)
                        sb.append("▸  ").append(shared.optString(i)).append("\n");
                    addCard("🕵️  Hidden / Shared-Host (" + shared.length() + ")",
                            sb.toString().trim(), "#FFCC80");
                } else {
                    addCard("🕵️  Hidden / Shared-Host", "None found on this IP", "#546E7A");
                }
            }

            // 4. TLS Certificate
            if (probe != null) {
                JSONObject tls = probe.optJSONObject("tlsInfo");
                if (tls != null) {
                    StringBuilder sb = new StringBuilder();
                    String issuer = tls.optString("issuer", "");
                    if (!issuer.isEmpty()) sb.append("Issuer:    ").append(issuer).append("\n");
                    String notBefore = tls.optString("notBefore", "");
                    String notAfter  = tls.optString("notAfter",  "");
                    if (!notBefore.isEmpty()) sb.append("Valid From: ").append(notBefore).append("\n");
                    if (!notAfter.isEmpty())  sb.append("Expires:    ").append(notAfter).append("\n");
                    JSONArray dnsNames = tls.optJSONArray("dnsNames");
                    if (dnsNames != null && dnsNames.length() > 0) {
                        int show = Math.min(dnsNames.length(), 6);
                        sb.append("SANs (").append(dnsNames.length()).append("):\n");
                        for (int i = 0; i < show; i++)
                            sb.append("  ").append(dnsNames.optString(i)).append("\n");
                        if (dnsNames.length() > 6)
                            sb.append("  … +").append(dnsNames.length() - 6).append(" more");
                    }
                    if (sb.length() > 0)
                        addCard("🔒  TLS Certificate", sb.toString().trim(), "#80CBC4");
                }
            }

            // 5. Reachability
            if (probe != null) {
                JSONObject reach = probe.optJSONObject("reachability");
                if (reach != null) {
                    JSONObject https = reach.optJSONObject("https");
                    JSONObject http  = reach.optJSONObject("http");
                    JSONObject active = https != null ? https : http;
                    if (active != null && active.optBoolean("reachable", false)) {
                        StringBuilder sb = new StringBuilder();
                        sb.append("Status:    HTTP ").append(active.optInt("statusCode")).append("\n");
                        sb.append("Latency:   ").append(active.optInt("latencyMs")).append(" ms\n");
                        String finalUrl = active.optString("finalUrl", "");
                        if (!finalUrl.isEmpty())
                            sb.append("Resolves → ").append(finalUrl);
                        addCard("🌍  Reachability", sb.toString().trim(), "#90CAF9");
                    }
                }
            }

        } catch (Exception e) {
            addCard("⚠  Parse Error", e.getMessage(), "#EF9A9A");
        }
    }

    // ═════════════════════════════════════════════════════════════════════════
    // Traffic Monitor
    // ═════════════════════════════════════════════════════════════════════════

    private void startMonitoring() {
        String domain = targetDomainInput.getText().toString().trim()
                .replaceAll("(?i)https?://", "").replaceAll("/.*", "").toLowerCase();

        // Clear old log
        trafficLogContainer.removeAllViews();
        connectionCount = 0;
        connectionCountText.setText("");

        Intent vpnIntent = VpnService.prepare(this);
        if (vpnIntent != null) {
            startActivityForResult(vpnIntent, VPN_REQUEST_CODE);
        } else {
            launchVpnService(domain);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == VPN_REQUEST_CODE && resultCode == RESULT_OK) {
            String domain = targetDomainInput.getText().toString().trim()
                    .replaceAll("(?i)https?://", "").replaceAll("/.*", "").toLowerCase();
            launchVpnService(domain);
        } else if (requestCode == VPN_REQUEST_CODE) {
            showToast("VPN permission denied — NetWatch needs VPN access to monitor traffic");
        }
    }

    private void launchVpnService(String domain) {
        startVpnBtn.setEnabled(false);
        stopVpnBtn.setEnabled(true);

        String statusMsg = domain.isEmpty()
                ? "🟢  Monitoring ALL traffic"
                : "🟢  Filtering:  " + domain;
        vpnStatusText.setText(statusMsg);
        vpnStatusText.setTextColor(Color.parseColor("#66BB6A"));

        // Show hint row
        addHintRow(domain.isEmpty()
                ? "Showing all connections from this device"
                : "Showing connections to/from  " + domain);

        Intent si = new Intent(this, NetWatchVpnService.class);
        si.putExtra("target_domain", domain);
        startForegroundService(si);
    }

    private void stopMonitoring() {
        startVpnBtn.setEnabled(true);
        stopVpnBtn.setEnabled(false);
        vpnStatusText.setText("⚫  Monitoring stopped");
        vpnStatusText.setTextColor(Color.parseColor("#78909C"));

        Intent si = new Intent(this, NetWatchVpnService.class);
        si.setAction(NetWatchVpnService.ACTION_STOP);
        startService(si);
    }

    private void addHintRow(String msg) {
        TextView hint = new TextView(this);
        hint.setText("ℹ  " + msg);
        hint.setTextSize(12);
        hint.setTextColor(Color.parseColor("#546E7A"));
        hint.setPadding(dp(4), dp(6), dp(4), dp(10));
        hint.setTypeface(null, Typeface.ITALIC);
        trafficLogContainer.addView(hint);
    }

    /**
     * Adds one traffic row to the log.
     * Layout:  DIR  |  HOST (bold) / ip:port  |  TIME
     */
    private void addTrafficRow(String direction, String protocol, String host,
                                String ipPort, int bytes, String timestamp) {

        boolean isOut   = "⬆".equals(direction);
        String dirColor = isOut ? "#EF9A9A" : "#A5D6A7";

        // Extract port from ipPort  (format "1.2.3.4:443")
        String port = "";
        if (ipPort != null && ipPort.contains(":")) {
            port = ipPort.substring(ipPort.lastIndexOf(':') + 1);
        }

        String displayHost = (host != null && !host.isEmpty()) ? host : (ipPort != null ? ipPort.split(":")[0] : "?");
        String rawIp       = ipPort != null ? ipPort.split(":")[0] : "";

        // Outer row
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setPadding(dp(4), dp(5), dp(4), dp(5));
        row.setLayoutParams(new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT));

        // Direction arrow
        TextView dirView = new TextView(this);
        dirView.setText(direction);
        dirView.setTextSize(15);
        dirView.setTextColor(Color.parseColor(dirColor));
        dirView.setLayoutParams(new LinearLayout.LayoutParams(dp(24), LinearLayout.LayoutParams.WRAP_CONTENT));
        row.addView(dirView);

        // Middle: host + sub-info
        LinearLayout mid = new LinearLayout(this);
        mid.setOrientation(LinearLayout.VERTICAL);
        mid.setLayoutParams(new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1));

        TextView hostView = new TextView(this);
        hostView.setText(displayHost);
        hostView.setTextSize(13);
        hostView.setTextColor(Color.parseColor("#E3F2FD"));
        hostView.setTypeface(Typeface.MONOSPACE, Typeface.BOLD);
        hostView.setSingleLine(true);
        hostView.setEllipsize(android.text.TextUtils.TruncateAt.END);
        mid.addView(hostView);

        // Show raw IP below hostname (only if hostname differs from IP)
        if (!displayHost.equals(rawIp) && !rawIp.isEmpty()) {
            TextView ipView = new TextView(this);
            ipView.setText(rawIp + "  •  " + protocol);
            ipView.setTextSize(10);
            ipView.setTextColor(Color.parseColor("#546E7A"));
            ipView.setTypeface(Typeface.MONOSPACE);
            mid.addView(ipView);
        }
        row.addView(mid);

        // Port
        TextView portView = new TextView(this);
        portView.setText(port);
        portView.setTextSize(11);
        portView.setTextColor(Color.parseColor("#64B5F6"));
        portView.setTypeface(Typeface.MONOSPACE);
        portView.setLayoutParams(new LinearLayout.LayoutParams(dp(46), LinearLayout.LayoutParams.WRAP_CONTENT));
        portView.setGravity(android.view.Gravity.END);
        row.addView(portView);

        // Timestamp
        TextView tsView = new TextView(this);
        tsView.setText(timestamp != null ? timestamp : "");
        tsView.setTextSize(10);
        tsView.setTextColor(Color.parseColor("#546E7A"));
        tsView.setLayoutParams(new LinearLayout.LayoutParams(dp(58), LinearLayout.LayoutParams.WRAP_CONTENT));
        tsView.setGravity(android.view.Gravity.END);
        row.addView(tsView);

        // Divider
        View div = new View(this);
        div.setLayoutParams(new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, 1));
        div.setBackgroundColor(Color.parseColor("#0D2137"));

        trafficLogContainer.addView(row);
        trafficLogContainer.addView(div);

        // Update counter
        connectionCount++;
        connectionCountText.setText(connectionCount + " connections");

        // Auto-scroll to bottom
        trafficScrollView.post(() -> trafficScrollView.fullScroll(ScrollView.FOCUS_DOWN));
    }

    // ═════════════════════════════════════════════════════════════════════════
    // Domain Intel Card helpers
    // ═════════════════════════════════════════════════════════════════════════

    private void addSubdomainsCard(JSONArray subs) {
        LinearLayout card = makeCardContainer();

        TextView title = new TextView(this);
        title.setText("🌿  SUBDOMAINS  (" + subs.length() + " FOUND)");
        title.setTextSize(11);
        title.setTextColor(Color.parseColor("#64B5F6"));
        title.setTypeface(null, Typeface.BOLD);
        title.setPadding(0, 0, 0, dp(6));
        card.addView(title);

        try {
            for (int i = 0; i < subs.length(); i++) {
                JSONObject sub = subs.getJSONObject(i);
                String name = sub.optString("name", "");
                JSONArray ips = sub.optJSONArray("ips");

                TextView nameView = new TextView(this);
                nameView.setText("▸  " + name);
                nameView.setTextSize(14);
                nameView.setTextColor(Color.parseColor("#80DEEA"));
                nameView.setTypeface(Typeface.MONOSPACE);
                nameView.setPadding(0, dp(4), 0, 0);
                card.addView(nameView);

                if (ips != null && ips.length() > 0) {
                    StringBuilder ipSb = new StringBuilder();
                    for (int j = 0; j < ips.length(); j++) {
                        String ip = ips.optString(j);
                        if (ip.matches("\\d+\\.\\d+\\.\\d+\\.\\d+")) {
                            if (ipSb.length() > 0) ipSb.append("  |  ");
                            ipSb.append(ip);
                        }
                    }
                    if (ipSb.length() > 0) {
                        TextView ipView = new TextView(this);
                        ipView.setText("   " + ipSb);
                        ipView.setTextSize(12);
                        ipView.setTextColor(Color.parseColor("#90A4AE"));
                        ipView.setTypeface(Typeface.MONOSPACE);
                        card.addView(ipView);
                    }
                }

                if (i < subs.length() - 1) {
                    View div = new View(this);
                    LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                            LinearLayout.LayoutParams.MATCH_PARENT, 1);
                    lp.topMargin = dp(4); lp.bottomMargin = dp(2);
                    div.setLayoutParams(lp);
                    div.setBackgroundColor(Color.parseColor("#1A3A5C"));
                    card.addView(div);
                }
            }
        } catch (Exception ignored) {}

        resultsContainer.addView(card);
    }

    private void addCard(String title, String value, String valueColor) {
        LinearLayout card = makeCardContainer();

        TextView titleView = new TextView(this);
        titleView.setText(title.toUpperCase());
        titleView.setTextSize(11);
        titleView.setTextColor(Color.parseColor("#64B5F6"));
        titleView.setTypeface(null, Typeface.BOLD);
        titleView.setPadding(0, 0, 0, dp(5));
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

    private LinearLayout makeCardContainer() {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setBackgroundResource(R.drawable.card_background);
        card.setPadding(dp(14), dp(12), dp(14), dp(12));
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        lp.bottomMargin = dp(10);
        card.setLayoutParams(lp);
        return card;
    }

    // ═════════════════════════════════════════════════════════════════════════
    // Helpers
    // ═════════════════════════════════════════════════════════════════════════

    private String postJson(String urlStr, String body) {
        try {
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(15000);
            conn.setReadTimeout(30000);
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
