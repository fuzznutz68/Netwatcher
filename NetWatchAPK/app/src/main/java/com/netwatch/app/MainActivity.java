package com.netwatch.app;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.Typeface;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class MainActivity extends Activity {

    private static final String DOMAIN_INTEL_URL  = "https://superagent-cfb25b3e.base44.app/functions/domainIntel";
    private static final String TRAFFIC_PROBE_URL = "https://superagent-cfb25b3e.base44.app/functions/trafficProbe";
    private static final int    NOTIF_PERM_CODE   = 1002;

    // ── Tabs ────────────────────────────────────────────────────────────────
    private View   tab1, tab2;
    private Button tabDomainBtn, tabTrafficBtn;

    // ── Tab 1 – Domain Intel ────────────────────────────────────────────────
    private EditText     domainInput;
    private Button       lookupBtn;
    private LinearLayout resultsContainer;
    private TextView     statusText;

    // ── Tab 2 – Traffic Monitor ─────────────────────────────────────────────
    private Spinner      appSpinner;
    private Button       startMonBtn, stopMonBtn, clearMonBtn;
    private TextView     monStatusText;
    private TextView     txTotalText, rxTotalText, txRateText, rxRateText;
    private LinearLayout hostLogContainer;
    private ScrollView   hostLogScroll;
    private TextView     connectionCountText;

    private List<AppEntry>       appList      = new ArrayList<>();
    private ArrayAdapter<AppEntry> appAdapter;
    private AppEntry             selectedApp  = null;
    private boolean              monitoring   = false;
    private int                  hostCount    = 0;
    private final Set<String>    seenHosts    = new HashSet<>();

    private BroadcastReceiver trafficReceiver;
    private final ExecutorService executor    = Executors.newCachedThreadPool();
    private final Handler         mainHandler = new Handler(Looper.getMainLooper());

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Tabs
        tabDomainBtn  = findViewById(R.id.tabDomainBtn);
        tabTrafficBtn = findViewById(R.id.tabTrafficBtn);
        tab1          = findViewById(R.id.tab1);
        tab2          = findViewById(R.id.tab2);
        tabDomainBtn.setSelected(true);
        tabDomainBtn.setOnClickListener(v -> switchTab(0));
        tabTrafficBtn.setOnClickListener(v -> switchTab(1));

        // Tab 1
        domainInput      = findViewById(R.id.domainInput);
        lookupBtn        = findViewById(R.id.lookupBtn);
        resultsContainer = findViewById(R.id.resultsContainer);
        statusText       = findViewById(R.id.statusText);
        lookupBtn.setOnClickListener(v -> performLookup());
        domainInput.setOnEditorActionListener((v, action, event) -> { performLookup(); return true; });

        // Tab 2
        appSpinner         = findViewById(R.id.appSpinner);
        startMonBtn        = findViewById(R.id.startMonBtn);
        stopMonBtn         = findViewById(R.id.stopMonBtn);
        clearMonBtn        = findViewById(R.id.clearMonBtn);
        monStatusText      = findViewById(R.id.monStatusText);
        txTotalText        = findViewById(R.id.txTotalText);
        rxTotalText        = findViewById(R.id.rxTotalText);
        txRateText         = findViewById(R.id.txRateText);
        rxRateText         = findViewById(R.id.rxRateText);
        hostLogContainer   = findViewById(R.id.hostLogContainer);
        hostLogScroll      = findViewById(R.id.hostLogScroll);
        connectionCountText= findViewById(R.id.connectionCountText);

        startMonBtn.setOnClickListener(v -> startMonitoring());
        stopMonBtn.setOnClickListener(v -> stopMonitoring());
        clearMonBtn.setOnClickListener(v -> clearLog());

        appSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override public void onItemSelected(AdapterView<?> p, View v, int pos, long id) {
                selectedApp = appList.isEmpty() ? null : appList.get(pos);
            }
            @Override public void onNothingSelected(AdapterView<?> p) {}
        });

        // Register broadcast receiver for traffic events
        trafficReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context ctx, Intent intent) {
                long txBytes = intent.getLongExtra(TrafficMonitorService.EXTRA_TX_BYTES, 0);
                long rxBytes = intent.getLongExtra(TrafficMonitorService.EXTRA_RX_BYTES, 0);
                long txRate  = intent.getLongExtra(TrafficMonitorService.EXTRA_TX_RATE,  0);
                long rxRate  = intent.getLongExtra(TrafficMonitorService.EXTRA_RX_RATE,  0);
                String hosts = intent.getStringExtra(TrafficMonitorService.EXTRA_HOSTS);
                updateStats(txBytes, rxBytes, txRate, rxRate, hosts);
            }
        };
        IntentFilter f = new IntentFilter(TrafficMonitorService.EVENT_ACTION);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(trafficReceiver, f, Context.RECEIVER_NOT_EXPORTED);
        } else {
            registerReceiver(trafficReceiver, f);
        }

        // Notification permission
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS)
                    != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(
                    new String[]{android.Manifest.permission.POST_NOTIFICATIONS},
                    NOTIF_PERM_CODE);
            }
        }

        // Load app list in background
        loadAppList();
    }

    // ── App List ─────────────────────────────────────────────────────────────

    private void loadAppList() {
        executor.execute(() -> {
            PackageManager pm = getPackageManager();
            List<ApplicationInfo> apps = pm.getInstalledApplications(PackageManager.GET_META_DATA);
            List<AppEntry> entries = new ArrayList<>();

            // Add "Whole Device" as first option
            entries.add(new AppEntry("📱  Whole Device", "", -1));

            for (ApplicationInfo ai : apps) {
                // Skip system apps with no internet activity (keeps list manageable)
                // Include: user apps + system apps that use INTERNET permission
                try {
                    String[] perms = pm.getPackageInfo(ai.packageName,
                            PackageManager.GET_PERMISSIONS).requestedPermissions;
                    boolean hasInternet = false;
                    if (perms != null) {
                        for (String p : perms) {
                            if ("android.permission.INTERNET".equals(p)) { hasInternet = true; break; }
                        }
                    }
                    if (!hasInternet) continue;
                } catch (Exception ignored) { continue; }

                String label = pm.getApplicationLabel(ai).toString();
                entries.add(new AppEntry(label, ai.packageName, ai.uid));
            }

            // Sort alphabetically (keep "Whole Device" first)
            if (entries.size() > 1) {
                List<AppEntry> rest = entries.subList(1, entries.size());
                Collections.sort(rest, (a, b) -> a.label.compareToIgnoreCase(b.label));
            }

            appList = entries;
            mainHandler.post(() -> {
                appAdapter = new ArrayAdapter<>(this,
                        android.R.layout.simple_spinner_item, appList);
                appAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
                appSpinner.setAdapter(appAdapter);
                if (!appList.isEmpty()) selectedApp = appList.get(0);
            });
        });
    }

    // ── Monitoring Control ───────────────────────────────────────────────────

    private void startMonitoring() {
        if (selectedApp == null) { showToast("Select an app first"); return; }

        clearLog();
        monitoring = true;
        startMonBtn.setEnabled(false);
        stopMonBtn.setEnabled(true);
        appSpinner.setEnabled(false);

        monStatusText.setText("🟢  Monitoring: " + selectedApp.label);
        monStatusText.setTextColor(Color.parseColor("#66BB6A"));

        Intent si = new Intent(this, TrafficMonitorService.class);
        si.putExtra("target_uid",  selectedApp.uid);
        si.putExtra("target_name", selectedApp.label);
        startForegroundService(si);
    }

    private void stopMonitoring() {
        monitoring = false;
        startMonBtn.setEnabled(true);
        stopMonBtn.setEnabled(false);
        appSpinner.setEnabled(true);

        monStatusText.setText("⚫  Monitoring stopped");
        monStatusText.setTextColor(Color.parseColor("#78909C"));

        Intent si = new Intent(this, TrafficMonitorService.class);
        si.setAction(TrafficMonitorService.ACTION_STOP);
        startService(si);
    }

    private void clearLog() {
        hostLogContainer.removeAllViews();
        hostCount = 0;
        seenHosts.clear();
        connectionCountText.setText("");
        txTotalText.setText("TX  —");
        rxTotalText.setText("RX  —");
        txRateText.setText("↑ 0 B/s");
        rxRateText.setText("↓ 0 B/s");
    }

    // ── Stats Update (called from broadcast) ─────────────────────────────────

    private void updateStats(long txBytes, long rxBytes, long txRate, long rxRate, String hostsRaw) {
        // Update totals
        txTotalText.setText("TX  " + formatBytes(txBytes));
        rxTotalText.setText("RX  " + formatBytes(rxBytes));
        txRateText.setText("↑ " + formatBytes(txRate) + "/s");
        rxRateText.setText("↓ " + formatBytes(rxRate) + "/s");

        // Color rate text based on activity
        int rateColor = (txRate > 0 || rxRate > 0)
                ? Color.parseColor("#66BB6A") : Color.parseColor("#546E7A");
        txRateText.setTextColor(txRate > 0 ? Color.parseColor("#EF9A9A") : Color.parseColor("#546E7A"));
        rxRateText.setTextColor(rxRate > 0 ? Color.parseColor("#66BB6A") : Color.parseColor("#546E7A"));

        // Add new hosts to the log
        if (hostsRaw != null && !hostsRaw.isEmpty()) {
            String[] hosts = hostsRaw.split("\n");
            String ts = new SimpleDateFormat("HH:mm:ss", Locale.US).format(new Date());
            for (String host : hosts) {
                host = host.trim();
                if (host.isEmpty()) continue;
                if (seenHosts.contains(host)) continue;  // deduplicate
                seenHosts.add(host);
                addHostRow(host, txRate > 0 || rxRate > 0, ts);
                hostCount++;
            }
            if (hostCount > 0)
                connectionCountText.setText(hostCount + " unique hosts");
            hostLogScroll.post(() -> hostLogScroll.fullScroll(ScrollView.FOCUS_DOWN));
        }
    }

    private void addHostRow(String host, boolean active, String ts) {
        boolean isIp = host.matches("\\d+\\.\\d+\\.\\d+\\.\\d+.*") || host.contains(":");

        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setPadding(dp(6), dp(6), dp(6), dp(6));

        // Indicator dot
        TextView dot = new TextView(this);
        dot.setText(active ? "●  " : "○  ");
        dot.setTextSize(13);
        dot.setTextColor(Color.parseColor(active ? "#66BB6A" : "#546E7A"));
        dot.setLayoutParams(new LinearLayout.LayoutParams(dp(26), LinearLayout.LayoutParams.WRAP_CONTENT));
        row.addView(dot);

        // Host name / IP
        TextView hostView = new TextView(this);
        hostView.setText(host);
        hostView.setTextSize(isIp ? 12 : 14);
        hostView.setTextColor(Color.parseColor(isIp ? "#90A4AE" : "#E3F2FD"));
        hostView.setTypeface(Typeface.MONOSPACE, isIp ? Typeface.NORMAL : Typeface.BOLD);
        hostView.setLayoutParams(new LinearLayout.LayoutParams(
                0, LinearLayout.LayoutParams.WRAP_CONTENT, 1));
        hostView.setEllipsize(TextUtils.TruncateAt.END);
        hostView.setSingleLine(true);
        row.addView(hostView);

        // Timestamp
        TextView tsView = new TextView(this);
        tsView.setText(ts);
        tsView.setTextSize(10);
        tsView.setTextColor(Color.parseColor("#37474F"));
        tsView.setLayoutParams(new LinearLayout.LayoutParams(
                dp(58), LinearLayout.LayoutParams.WRAP_CONTENT));
        tsView.setGravity(android.view.Gravity.END);
        row.addView(tsView);

        // Divider
        View div = new View(this);
        div.setLayoutParams(new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, 1));
        div.setBackgroundColor(Color.parseColor("#0D2137"));

        hostLogContainer.addView(row);
        hostLogContainer.addView(div);
    }

    // ── Domain Intel (Tab 1) ─────────────────────────────────────────────────

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
                    statusText.setText("❌  Network error");
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
                addCard("❌ Error", intel.optString("error"), "#EF9A9A"); return;
            }

            if (intel != null) {
                StringBuilder sb = new StringBuilder();
                JSONArray ipv4 = intel.optJSONArray("ipv4");
                if (ipv4 != null) for (int i=0;i<ipv4.length();i++) sb.append("IPv4:  ").append(ipv4.optString(i)).append("\n");
                JSONArray ipv6 = intel.optJSONArray("ipv6");
                if (ipv6 != null) for (int i=0;i<ipv6.length();i++) sb.append("IPv6:  ").append(ipv6.optString(i)).append("\n");
                String cname = intel.optString("cname","");
                if (!cname.isEmpty() && !cname.equals("null")) sb.append("CNAME: ").append(cname);
                if (sb.length() > 0) addCard("🌐  " + domain, sb.toString().trim(), "#A5D6A7");
            }

            if (intel != null) {
                JSONArray subs = intel.optJSONArray("subdomains");
                if (subs != null && subs.length() > 0) addSubdomainsCard(subs);
                else addCard("🌿  Subdomains", "None discovered", "#546E7A");
            }

            if (intel != null) {
                JSONArray shared = intel.optJSONArray("sharedHostDomains");
                if (shared != null && shared.length() > 0) {
                    StringBuilder sb = new StringBuilder();
                    for (int i=0;i<shared.length();i++) sb.append("▸  ").append(shared.optString(i)).append("\n");
                    addCard("🕵️  Shared-Host ("+shared.length()+")", sb.toString().trim(), "#FFCC80");
                } else addCard("🕵️  Shared-Host", "None found", "#546E7A");
            }

            if (probe != null) {
                JSONObject tls = probe.optJSONObject("tlsInfo");
                if (tls != null) {
                    StringBuilder sb = new StringBuilder();
                    String issuer = tls.optString("issuer","");
                    if (!issuer.isEmpty()) sb.append("Issuer:    ").append(issuer).append("\n");
                    sb.append("Valid:     ").append(tls.optString("notBefore","")).append("\n");
                    sb.append("Expires:   ").append(tls.optString("notAfter","")).append("\n");
                    JSONArray dnsNames = tls.optJSONArray("dnsNames");
                    if (dnsNames != null && dnsNames.length() > 0) {
                        int show = Math.min(dnsNames.length(), 6);
                        sb.append("SANs (").append(dnsNames.length()).append("):\n");
                        for (int i=0;i<show;i++) sb.append("  ").append(dnsNames.optString(i)).append("\n");
                        if (dnsNames.length()>6) sb.append("  … +").append(dnsNames.length()-6).append(" more");
                    }
                    if (sb.length() > 0) addCard("🔒  TLS Certificate", sb.toString().trim(), "#80CBC4");
                }
            }

            if (probe != null) {
                JSONObject reach = probe.optJSONObject("reachability");
                if (reach != null) {
                    JSONObject https = reach.optJSONObject("https");
                    JSONObject http  = reach.optJSONObject("http");
                    JSONObject active = https != null ? https : http;
                    if (active != null && active.optBoolean("reachable",false)) {
                        String sb = "Status:   HTTP " + active.optInt("statusCode") + "\n" +
                                "Latency:  " + active.optInt("latencyMs") + " ms\n" +
                                "Final URL: " + active.optString("finalUrl","");
                        addCard("🌍  Reachability", sb.trim(), "#90CAF9");
                    }
                }
            }

        } catch (Exception e) {
            addCard("⚠  Parse Error", e.getMessage(), "#EF9A9A");
        }
    }

    // ── Card helpers ─────────────────────────────────────────────────────────

    private void addSubdomainsCard(JSONArray subs) {
        LinearLayout card = makeCardContainer();
        TextView title = new TextView(this);
        title.setText("🌿  SUBDOMAINS  (" + subs.length() + ")");
        title.setTextSize(11); title.setTextColor(Color.parseColor("#64B5F6"));
        title.setTypeface(null, Typeface.BOLD); title.setPadding(0,0,0,dp(6));
        card.addView(title);
        try {
            for (int i=0; i<subs.length(); i++) {
                JSONObject sub = subs.getJSONObject(i);
                String name = sub.optString("name","");
                JSONArray ips = sub.optJSONArray("ips");
                TextView nameView = new TextView(this);
                nameView.setText("▸  " + name); nameView.setTextSize(14);
                nameView.setTextColor(Color.parseColor("#80DEEA"));
                nameView.setTypeface(Typeface.MONOSPACE); nameView.setPadding(0,dp(4),0,0);
                card.addView(nameView);
                if (ips != null) {
                    StringBuilder sb = new StringBuilder();
                    for (int j=0;j<ips.length();j++) {
                        String ip = ips.optString(j);
                        if (ip.matches("\\d+\\.\\d+\\.\\d+\\.\\d+")) { if(sb.length()>0) sb.append("  |  "); sb.append(ip); }
                    }
                    if (sb.length()>0) {
                        TextView ipView = new TextView(this);
                        ipView.setText("   "+sb); ipView.setTextSize(12);
                        ipView.setTextColor(Color.parseColor("#90A4AE")); ipView.setTypeface(Typeface.MONOSPACE);
                        card.addView(ipView);
                    }
                }
                if (i < subs.length()-1) {
                    View div = new View(this);
                    LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 1);
                    lp.topMargin=dp(4); lp.bottomMargin=dp(2); div.setLayoutParams(lp);
                    div.setBackgroundColor(Color.parseColor("#1A3A5C")); card.addView(div);
                }
            }
        } catch (Exception ignored) {}
        resultsContainer.addView(card);
    }

    private void addCard(String title, String value, String valueColor) {
        LinearLayout card = makeCardContainer();
        TextView t = new TextView(this);
        t.setText(title.toUpperCase()); t.setTextSize(11);
        t.setTextColor(Color.parseColor("#64B5F6")); t.setTypeface(null, Typeface.BOLD);
        t.setPadding(0,0,0,dp(5)); card.addView(t);
        TextView v = new TextView(this);
        v.setText(value); v.setTextSize(14);
        try { v.setTextColor(Color.parseColor(valueColor)); } catch(Exception e){ v.setTextColor(Color.WHITE); }
        v.setTypeface(Typeface.MONOSPACE); card.addView(v);
        resultsContainer.addView(card);
    }

    private LinearLayout makeCardContainer() {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setBackgroundResource(R.drawable.card_background);
        card.setPadding(dp(14),dp(12),dp(14),dp(12));
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        lp.bottomMargin = dp(10); card.setLayoutParams(lp);
        return card;
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private void switchTab(int index) {
        tab1.setVisibility(index == 0 ? View.VISIBLE : View.GONE);
        tab2.setVisibility(index == 1 ? View.VISIBLE : View.GONE);
        tabDomainBtn.setSelected(index == 0);
        tabTrafficBtn.setSelected(index == 1);
    }

    private static String formatBytes(long bytes) {
        if (bytes < 0)    return "—";
        if (bytes < 1024) return bytes + " B";
        if (bytes < 1024*1024) return String.format(Locale.US, "%.1f KB", bytes/1024.0);
        if (bytes < 1024*1024*1024) return String.format(Locale.US, "%.2f MB", bytes/1048576.0);
        return String.format(Locale.US, "%.2f GB", bytes/1073741824.0);
    }

    private String postJson(String urlStr, String body) {
        try {
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type","application/json");
            conn.setDoOutput(true); conn.setConnectTimeout(15000); conn.setReadTimeout(30000);
            try (OutputStream os = conn.getOutputStream()) { os.write(body.getBytes("UTF-8")); }
            int code = conn.getResponseCode();
            BufferedReader br = new BufferedReader(new InputStreamReader(
                    code>=200&&code<300 ? conn.getInputStream() : conn.getErrorStream()));
            StringBuilder sb = new StringBuilder(); String line;
            while ((line=br.readLine())!=null) sb.append(line);
            br.close(); return sb.toString();
        } catch (Exception e) { return null; }
    }

    private int dp(int val) {
        return (int)(val * getResources().getDisplayMetrics().density);
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
