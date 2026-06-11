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

    private View   tab1, tab2;
    private Button tabDomainBtn, tabTrafficBtn;

    // Tab 1
    private EditText     domainInput;
    private Button       lookupBtn;
    private LinearLayout resultsContainer;
    private TextView     statusText;

    // Tab 2
    private EditText     targetDomainInput;
    private Button       startVpnBtn, stopVpnBtn;
    private LinearLayout trafficLogContainer;
    private ScrollView   trafficScrollView;
    private TextView     vpnStatusText;

    private final ExecutorService executor    = Executors.newCachedThreadPool();
    private final Handler         mainHandler = new Handler(Looper.getMainLooper());
    private BroadcastReceiver     trafficReceiver;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        tabDomainBtn  = findViewById(R.id.tabDomainBtn);
        tabTrafficBtn = findViewById(R.id.tabTrafficBtn);
        tab1          = findViewById(R.id.tab1);
        tab2          = findViewById(R.id.tab2);

        domainInput      = findViewById(R.id.domainInput);
        lookupBtn        = findViewById(R.id.lookupBtn);
        resultsContainer = findViewById(R.id.resultsContainer);
        statusText       = findViewById(R.id.statusText);

        targetDomainInput   = findViewById(R.id.targetDomainInput);
        startVpnBtn         = findViewById(R.id.startVpnBtn);
        stopVpnBtn          = findViewById(R.id.stopVpnBtn);
        trafficLogContainer = findViewById(R.id.trafficLogContainer);
        trafficScrollView   = findViewById(R.id.trafficScrollView);
        vpnStatusText       = findViewById(R.id.vpnStatusText);

        tabDomainBtn.setSelected(true);
        tabDomainBtn.setOnClickListener(v -> switchTab(0));
        tabTrafficBtn.setOnClickListener(v -> switchTab(1));

        lookupBtn.setOnClickListener(v -> performLookup());
        domainInput.setOnEditorActionListener((v, action, event) -> { performLookup(); return true; });

        startVpnBtn.setOnClickListener(v -> startMonitoring());
        stopVpnBtn.setOnClickListener(v -> stopMonitoring());

        trafficReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                addTrafficRow(
                    intent.getStringExtra("direction"),
                    intent.getStringExtra("protocol"),
                    intent.getStringExtra("host"),
                    intent.getStringExtra("ipPort"),
                    intent.getIntExtra("bytes", 0),
                    intent.getStringExtra("timestamp")
                );
            }
        };
        IntentFilter filter = new IntentFilter(NetWatchVpnService.TRAFFIC_ACTION);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(trafficReceiver, filter, Context.RECEIVER_NOT_EXPORTED);
        } else {
            registerReceiver(trafficReceiver, filter);
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS)
                    != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(new String[]{android.Manifest.permission.POST_NOTIFICATIONS},
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

    // ── Domain Intel ──────────────────────────────────────────────────────────

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

    /**
     * Builds a focused domain report showing:
     *   1. Main domain + all IPs (v4 + v6) + CNAME
     *   2. Subdomains with their IPs
     *   3. Hidden / shared-host domains (PTR / reverse lookup)
     *   4. TLS info (issuer, validity)
     *   5. HTTP reachability
     */
    private void buildReport(String domain, String intelJson, String probeJson) {
        try {
            JSONObject intel = intelJson != null ? new JSONObject(intelJson) : null;
            JSONObject probe = probeJson != null ? new JSONObject(probeJson) : null;

            // ── Error guard ──────────────────────────────────────────────────
            if (intel != null && intel.has("error") && !intel.has("ipv4")) {
                addCard("❌ API Error", intel.optString("error"), "#EF9A9A");
                return;
            }

            // ── 1. Main Domain Card ──────────────────────────────────────────
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

                // Append TXT verification records if available from probe
                if (sb.length() > 0)
                    addCard("🌐  " + domain, sb.toString().trim(), "#A5D6A7");
            }

            // ── 2. Subdomains ────────────────────────────────────────────────
            if (intel != null) {
                JSONArray subs = intel.optJSONArray("subdomains");
                if (subs != null && subs.length() > 0) {
                    addSubdomainsCard(subs);
                } else {
                    addCard("🌿  Subdomains", "None discovered", "#546E7A");
                }
            }

            // ── 3. Hidden / Shared-Host Domains ─────────────────────────────
            if (intel != null) {
                JSONArray shared = intel.optJSONArray("sharedHostDomains");
                if (shared != null && shared.length() > 0) {
                    StringBuilder sb = new StringBuilder();
                    for (int i = 0; i < shared.length(); i++)
                        sb.append("▸  ").append(shared.optString(i)).append("\n");
                    addCard("🕵️  Hidden / Shared-Host Domains  (" + shared.length() + ")",
                            sb.toString().trim(), "#FFCC80");
                } else {
                    addCard("🕵️  Hidden / Shared-Host Domains", "None found on this IP", "#546E7A");
                }
            }

            // ── 4. TLS Certificate ───────────────────────────────────────────
            if (probe != null) {
                JSONObject tls = probe.optJSONObject("tlsInfo");
                if (tls != null) {
                    StringBuilder sb = new StringBuilder();
                    String issuer = tls.optString("issuer", "");
                    if (!issuer.isEmpty()) sb.append("Issuer:  ").append(issuer).append("\n");
                    String notBefore = tls.optString("notBefore", "");
                    String notAfter  = tls.optString("notAfter", "");
                    if (!notBefore.isEmpty()) sb.append("Valid From:  ").append(notBefore).append("\n");
                    if (!notAfter.isEmpty())  sb.append("Expires:     ").append(notAfter).append("\n");
                    JSONArray dnsNames = tls.optJSONArray("dnsNames");
                    if (dnsNames != null && dnsNames.length() > 0) {
                        sb.append("SANs (").append(dnsNames.length()).append(" entries):\n");
                        int show = Math.min(dnsNames.length(), 6);
                        for (int i = 0; i < show; i++)
                            sb.append("  ").append(dnsNames.optString(i)).append("\n");
                        if (dnsNames.length() > 6)
                            sb.append("  … +").append(dnsNames.length() - 6).append(" more");
                    }
                    if (sb.length() > 0)
                        addCard("🔒  TLS Certificate", sb.toString().trim(), "#80CBC4");
                }
            }

            // ── 5. HTTP/HTTPS Reachability ───────────────────────────────────
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

                // Subdomain name row
                TextView nameView = new TextView(this);
                nameView.setText("▸  " + name);
                nameView.setTextSize(14);
                nameView.setTextColor(Color.parseColor("#80DEEA"));
                nameView.setTypeface(Typeface.MONOSPACE);
                nameView.setPadding(0, dp(4), 0, 0);
                card.addView(nameView);

                // IPs row (filtered — only real IPs, skip CNAME chains)
                if (ips != null && ips.length() > 0) {
                    StringBuilder ipSb = new StringBuilder();
                    for (int j = 0; j < ips.length(); j++) {
                        String ip = ips.optString(j);
                        // Only show entries that look like IPs (contain digits and dots, no spaces)
                        if (ip.matches("\\d+\\.\\d+\\.\\d+\\.\\d+")) {
                            if (ipSb.length() > 0) ipSb.append("  |  ");
                            ipSb.append(ip);
                        }
                    }
                    if (ipSb.length() > 0) {
                        TextView ipView = new TextView(this);
                        ipView.setText("   " + ipSb.toString());
                        ipView.setTextSize(12);
                        ipView.setTextColor(Color.parseColor("#90A4AE"));
                        ipView.setTypeface(Typeface.MONOSPACE);
                        card.addView(ipView);
                    }
                }

                // Divider between entries
                if (i < subs.length() - 1) {
                    View div = new View(this);
                    LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                            LinearLayout.LayoutParams.MATCH_PARENT, 1);
                    lp.topMargin    = dp(4);
                    lp.bottomMargin = dp(2);
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
        if (requestCode == VPN_REQUEST_CODE && resultCode == RESULT_OK) {
            launchVpnService(targetDomainInput.getText().toString().trim());
        } else if (requestCode == VPN_REQUEST_CODE) {
            showToast("VPN permission denied");
        }
    }

    private void launchVpnService(String domain) {
        trafficLogContainer.removeAllViews();
        startVpnBtn.setEnabled(false);
        stopVpnBtn.setEnabled(true);
        vpnStatusText.setText("🟢  Monitoring: " + domain);
        vpnStatusText.setTextColor(Color.parseColor("#66BB6A"));

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
        info.setLayoutParams(new LinearLayout.LayoutParams(
                0, LinearLayout.LayoutParams.WRAP_CONTENT, 1));

        TextView hostView = new TextView(this);
        hostView.setText(protocol + "  " + (host == null || host.isEmpty() ? ipPort : host));
        hostView.setTextSize(13);
        hostView.setTextColor(Color.parseColor("#E3F2FD"));
        hostView.setTypeface(Typeface.MONOSPACE);
        info.addView(hostView);

        TextView metaView = new TextView(this);
        metaView.setText((ipPort != null ? ipPort : "") + "  •  " + bytes + " B  •  " + timestamp);
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
