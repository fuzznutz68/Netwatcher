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
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.URL;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;
import android.view.ViewParent;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Map;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.SharedPreferences;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.widget.CompoundButton;
import androidx.appcompat.widget.SwitchCompat;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Arrays;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class MainActivity extends Activity {

    private static final String DOMAIN_INTEL_URL  = "https://superagent-cfb25b3e.base44.app/functions/domainIntel";
    private static final int    NOTIF_PERM_CODE   = 1002;

    // ── Tabs ────────────────────────────────────────────────────────────────
    private View   tab1, tab2;
    private Button tabDomainBtn, tabTrafficBtn, tabCheckerBtn, tabMyInfoBtn;

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
    // Raw log data for export: host line → timestamp string
    private final LinkedHashMap<String, String> trafficLogForExport = new LinkedHashMap<>();
    // Domain Intel last result for export
    private String lastDomainForExport = "";
    private String lastIntelJsonForExport = "";
    private String lastProbeJsonForExport = "";

    private Button       exportDomainBtn, exportTrafficBtn, myInfoRefreshBtn;
    private LinearLayout myInfoContainer;
    private SwitchCompat alertSwitch;
    private boolean      alertsEnabled  = true;

    // --- Tab 3: Domain Checker ---
    private LinearLayout  tab3;
    private View           tab4;
    private Button        checkAllBtn, stopCheckBtn;
    private TextView      checkStatusText;
    private LinearLayout  checkResultsContainer;
    private final AtomicBoolean checkRunning = new AtomicBoolean(false);
    private EditText      customDomainInput;
    private Button        checkCustomBtn;
    // Last known stats — reapplied when tab2 becomes visible
    private long lastKnownTx = -1, lastKnownRx = -1, lastKnownTxRate = 0, lastKnownRxRate = 0;
    // Trusted domains for the current monitoring session (auto-seeded + user-approved)
    private final Set<String> trustedDomains = Collections.synchronizedSet(new HashSet<>());
    // Root domain of the currently monitored app (e.g. "paypal.com")
    private String monitoredRootDomain = "";
    private static final String PREFS_NAME = "netwatch_prefs";
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
        tabCheckerBtn = findViewById(R.id.tabCheckerBtn);
        tabMyInfoBtn  = findViewById(R.id.tabMyInfoBtn);
        tab1          = findViewById(R.id.tab1);
        tab2          = findViewById(R.id.tab2);
        tabDomainBtn.setSelected(true);
        tabDomainBtn.setOnClickListener(v  -> switchTab(0));
        tabTrafficBtn.setOnClickListener(v -> switchTab(1));
        tabCheckerBtn.setOnClickListener(v -> switchTab(2));
        tabMyInfoBtn.setOnClickListener(v  -> switchTab(3));

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

        // Tab 3
        tab3                = findViewById(R.id.tab3);
        tab4                = findViewById(R.id.tab4);
        myInfoContainer     = findViewById(R.id.myInfoContainer);
        myInfoRefreshBtn    = findViewById(R.id.myInfoRefreshBtn);
        checkAllBtn         = findViewById(R.id.checkAllBtn);
        stopCheckBtn        = findViewById(R.id.stopCheckBtn);
        checkStatusText     = findViewById(R.id.checkStatusText);
        checkResultsContainer = findViewById(R.id.checkResultsContainer);
        customDomainInput = findViewById(R.id.customDomainInput);
        checkCustomBtn    = findViewById(R.id.checkCustomBtn);
        connectionCountText= findViewById(R.id.connectionCountText);

        exportDomainBtn    = findViewById(R.id.exportDomainBtn);
        exportTrafficBtn   = findViewById(R.id.exportTrafficBtn);
        alertSwitch        = findViewById(R.id.alertSwitch);
        exportDomainBtn.setOnClickListener(v -> exportDomainIntel());
        myInfoRefreshBtn.setOnClickListener(v -> lookupMyInfo());
        exportTrafficBtn.setOnClickListener(v -> exportTrafficLog());

        // Restore alert toggle preference
        SharedPreferences prefs = getSharedPreferences(PREFS_NAME, MODE_PRIVATE);
        alertsEnabled = prefs.getBoolean("alerts_enabled", true);
        alertSwitch.setChecked(alertsEnabled);
        alertSwitch.setOnCheckedChangeListener((btn, checked) -> {
            alertsEnabled = checked;
            prefs.edit().putBoolean("alerts_enabled", checked).apply();
        });

        checkAllBtn.setOnClickListener(v -> startDomainCheck());
        stopCheckBtn.setOnClickListener(v  -> stopDomainCheck());
        checkCustomBtn.setOnClickListener(v -> checkCustomDomain());
        customDomainInput.setOnEditorActionListener((tv, actionId, event) -> {
            checkCustomDomain();
            return true;
        });
        buildCheckerRows();

        // Seed global trusted CDN/cloud providers (never want to alert on these)
        trustedDomains.addAll(Arrays.asList(
            "google.com","googleapis.com","gstatic.com","googlevideo.com","googleusercontent.com",
            "akamai.net","akamaized.net","akamaitechnologies.com","akamaiedge.net",
            "cloudflare.com","cloudflare.net","cdn.cloudflare.net",
            "fastly.net","fastly.com",
            "amazon.com","amazonaws.com","awsstatic.com","cloudfront.net",
            "microsoft.com","azure.com","msftconnecttest.com","msedge.net",
            "apple.com","icloud.com","mzstatic.com",
            "facebook.com","fbcdn.net","instagram.com",
            "twitter.com","twimg.com",
            "android.com","android.clients.google.com"
        ));
        startMonBtn.setOnClickListener(v -> startMonitoring());
        stopMonBtn.setOnClickListener(v -> stopMonitoring());
        clearMonBtn.setOnClickListener(v -> clearLog());

        // Track whether the spinner is being set up for the first time (don't launch on init)
        appSpinner.setTag("init");
        appSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override public void onItemSelected(AdapterView<?> p, View v, int pos, long id) {
                selectedApp = appList.isEmpty() ? null : appList.get(pos);
                // Don't auto-launch on initial population of the spinner
                if ("init".equals(appSpinner.getTag())) {
                    appSpinner.setTag(null);
                    return;
                }
                // Launch the selected app (skip "Whole Device") and auto-start monitoring
                if (selectedApp != null && !selectedApp.packageName.isEmpty()) {
                    // If already monitoring another app, stop it first
                    if (monitoring) stopMonitoring();
                    // Seed trusted domains for the newly selected app
                    seedTrustedDomains(selectedApp.packageName);
                    // Start monitoring first so we capture traffic from the moment the app opens
                    startMonitoring();
                    // Small delay so monitoring is running before the app comes to foreground
                    mainHandler.postDelayed(() -> launchApp(selectedApp.packageName), 400);
                } else if (selectedApp != null && selectedApp.uid == -1) {
                    // "Whole Device" — just start monitoring, no app to launch
                    trustedDomains.clear(); monitoredRootDomain = "";
                    if (!monitoring) startMonitoring();
                }
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
        // Must use RECEIVER_EXPORTED (or no flag pre-T) because the broadcast
        // has setPackage() applied — Android still routes it correctly.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(trafficReceiver, f, Context.RECEIVER_EXPORTED);
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

    // ── Launch App ──────────────────────────────────────────────────────────

    private void launchApp(String packageName) {
        try {
            PackageManager pm = getPackageManager();
            Intent launch = pm.getLaunchIntentForPackage(packageName);
            if (launch != null) {
                launch.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(launch);
            } else {
                showToast("Can't launch — app may be a background service");
            }
        } catch (Exception e) {
            showToast("Could not open app: " + e.getMessage());
        }
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
                // Only show apps that have a launcher icon (appear in the app drawer).
                // This filters out background services, daemons, and Android internals.
                Intent launchIntent = pm.getLaunchIntentForPackage(ai.packageName);
                if (launchIntent == null) continue;

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
        si.putExtra("target_pkg",  selectedApp.packageName);
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
        trafficLogForExport.clear();
        connectionCountText.setText("");
        txTotalText.setText("TX  —");
        rxTotalText.setText("RX  —");
        txRateText.setText("↑ 0 B/s");
        rxRateText.setText("↓ 0 B/s");
    }

    // ── Stats Update (called from broadcast) ─────────────────────────────────

    private void updateStats(long txBytes, long rxBytes, long txRate, long rxRate, String hostsRaw) {
        // Cache for tab re-entry
        lastKnownTx = txBytes; lastKnownRx = rxBytes;
        lastKnownTxRate = txRate; lastKnownRxRate = rxRate;
        // Update totals — -1 means TrafficStats.UNSUPPORTED on this device
        txTotalText.setText("TX  " + (txBytes < 0 ? "N/A" : formatBytes(txBytes)));
        rxTotalText.setText("RX  " + (rxBytes < 0 ? "N/A" : formatBytes(rxBytes)));
        txRateText.setText("↑ " + (txBytes < 0 ? "N/A" : formatBytes(txRate) + "/s"));
        rxRateText.setText("↓ " + (rxBytes < 0 ? "N/A" : formatBytes(rxRate) + "/s"));

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
                trafficLogForExport.put(host, ts);
                hostCount++;
            }
            if (hostCount > 0)
                connectionCountText.setText(hostCount + " unique hosts");
            hostLogScroll.post(() -> hostLogScroll.fullScroll(ScrollView.FOCUS_DOWN));
        }
    }

    private void addHostRow(String host, boolean active, String ts) {
        boolean isIp = host.matches("\\d+\\.\\d+\\.\\d+\\.\\d+.*") || host.contains(":");
        boolean isUnknown = alertsEnabled && !isIp && !isTrustedHost(host);

        // Fire alert for unknown hosts
        if (isUnknown) fireAlert(host);

        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setPadding(dp(6), dp(6), dp(6), dp(6));
        if (isUnknown) row.setBackgroundColor(Color.parseColor("#1A2A1A")); // subtle red-green tint

        // Indicator dot
        TextView dot = new TextView(this);
        dot.setText(active ? "●  " : "○  ");
        dot.setTextSize(13);
        dot.setTextColor(Color.parseColor(isUnknown ? "#FF5252" : (active ? "#66BB6A" : "#546E7A")));
        dot.setLayoutParams(new LinearLayout.LayoutParams(dp(26), LinearLayout.LayoutParams.WRAP_CONTENT));
        row.addView(dot);

        // Host name / IP
        TextView hostView = new TextView(this);
        hostView.setText(host);
        hostView.setTextSize(isIp ? 12 : 14);
        hostView.setTextColor(Color.parseColor(isUnknown ? "#FF8A80" : (isIp ? "#90A4AE" : "#E3F2FD")));
        hostView.setTypeface(Typeface.MONOSPACE, isIp ? Typeface.NORMAL : Typeface.BOLD);
        hostView.setLayoutParams(new LinearLayout.LayoutParams(
                0, LinearLayout.LayoutParams.WRAP_CONTENT, 1));
        hostView.setEllipsize(TextUtils.TruncateAt.END);
        hostView.setSingleLine(true);
        row.addView(hostView);

        // ⚠ badge for unknown hosts
        if (isUnknown) {
            TextView badge = new TextView(this);
            badge.setText("⚠");
            badge.setTextSize(13);
            badge.setTextColor(Color.parseColor("#FF5252"));
            badge.setPadding(dp(4), 0, dp(4), 0);
            row.addView(badge);

            // ✓ Trust button — tap to mark as trusted and recolor row
            Button trustBtn = new Button(this);
            trustBtn.setText("✓");
            trustBtn.setTextSize(11);
            trustBtn.setTextColor(Color.WHITE);
            trustBtn.setPadding(dp(6), 0, dp(6), 0);
            LinearLayout.LayoutParams tbp = new LinearLayout.LayoutParams(dp(36), dp(28));
            tbp.setMargins(dp(2), 0, 0, 0);
            trustBtn.setLayoutParams(tbp);
            trustBtn.setBackgroundColor(Color.parseColor("#2E7D32"));
            trustBtn.setOnClickListener(v -> {
                // Add root of this host to trusted set
                String root = extractRootDomain(host);
                trustedDomains.add(root);
                trustedDomains.add(host);
                // Recolor this row to trusted
                row.setBackgroundColor(Color.TRANSPARENT);
                dot.setTextColor(Color.parseColor(active ? "#66BB6A" : "#546E7A"));
                hostView.setTextColor(Color.parseColor("#E3F2FD"));
                badge.setVisibility(android.view.View.GONE);
                trustBtn.setVisibility(android.view.View.GONE);
                showToast("✓ Trusted: " + root);
            });
            row.addView(trustBtn);
        }

        // Timestamp
        TextView tsView = new TextView(this);
        tsView.setText(ts);
        tsView.setTextSize(10);
        tsView.setTextColor(Color.parseColor("#37474F"));
        tsView.setLayoutParams(new LinearLayout.LayoutParams(
                dp(46), LinearLayout.LayoutParams.WRAP_CONTENT));
        tsView.setGravity(android.view.Gravity.END);
        row.addView(tsView);

        // Divider
        View div = new View(this);
        div.setLayoutParams(new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, 1));
        div.setBackgroundColor(Color.parseColor(isUnknown ? "#FF5252" : "#0D2137"));

        hostLogContainer.addView(row);
        hostLogContainer.addView(div);
    }

    /** True if host belongs to a trusted domain */
    private boolean isTrustedHost(String host) {
        if (host == null || host.isEmpty()) return true;
        String h = host.toLowerCase();
        // Strip geo prefix if present (e.g. "🇺🇸 Ashburn, US · Google LLC  api.google.com")
        int lastSpace = h.lastIndexOf("  ");
        if (lastSpace >= 0) h = h.substring(lastSpace + 2).trim();
        for (String trusted : trustedDomains) {
            if (h.equals(trusted) || h.endsWith("." + trusted)) return true;
        }
        return false;
    }

    /** Extract root domain from a hostname (last two labels) */
    private static String extractRootDomain(String host) {
        // Strip geo prefix
        int lastSpace = host.lastIndexOf("  ");
        String h = lastSpace >= 0 ? host.substring(lastSpace + 2).trim() : host;
        String[] parts = h.split("\\.");
        if (parts.length >= 2) return parts[parts.length - 2] + "." + parts[parts.length - 1];
        return h;
    }

    /** Seed trusted domains when a new app is selected */
    private void seedTrustedDomains(String packageName) {
        // Keep global CDN list, clear app-specific ones
        trustedDomains.removeIf(d -> !isGlobalCdn(d));
        monitoredRootDomain = packageToRootDomain(packageName);
        if (monitoredRootDomain != null) {
            trustedDomains.add(monitoredRootDomain);
            trustedDomains.add("www." + monitoredRootDomain);
        }
    }

    private static boolean isGlobalCdn(String domain) {
        String[] cdns = {"google.com","googleapis.com","gstatic.com","akamai.net","akamaized.net",
            "cloudflare.com","cloudflare.net","fastly.net","amazonaws.com","cloudfront.net",
            "msedge.net","microsoft.com","apple.com","icloud.com","fbcdn.net","twimg.com",
            "akamaitechnologies.com","akamaiedge.net","awsstatic.com","mzstatic.com",
            "googlevideo.com","googleusercontent.com","android.com","msftconnecttest.com"};
        for (String cdn : cdns) if (domain.equals(cdn)) return true;
        return false;
    }

    private static String packageToRootDomain(String pkg) {
        if (pkg == null || pkg.isEmpty()) return null;
        String[] parts = pkg.split("\\.");
        if (parts.length < 2) return null;
        String tld = parts[0]; String name = parts[1];
        if ("com".equals(tld) || "org".equals(tld) || "io".equals(tld)) return name + ".com";
        return name + "." + tld;
    }

    /** Vibrate + notification for an unexpected host */
    private void fireAlert(String host) {
        // Vibrate: short double-pulse
        try {
            Vibrator v = (Vibrator) getSystemService(VIBRATOR_SERVICE);
            if (v != null && v.hasVibrator()) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    v.vibrate(VibrationEffect.createWaveform(new long[]{0, 120, 80, 180}, -1));
                } else {
                    v.vibrate(new long[]{0, 120, 80, 180}, -1);
                }
            }
        } catch (Exception ignored) {}

        // Status-bar notification
        try {
            String chanId = "netwatch_alerts";
            NotificationManager nm = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
            NotificationChannel ch = new NotificationChannel(chanId, "NetWatch Alerts", NotificationManager.IMPORTANCE_HIGH);
            ch.enableVibration(false); // we already vibrated manually
            nm.createNotificationChannel(ch);

            // Strip geo prefix for clean display
            String displayHost = host;
            int sp = host.lastIndexOf("  ");
            if (sp >= 0) displayHost = host.substring(sp + 2).trim();

            android.app.Notification notif = new android.app.Notification.Builder(this, chanId)
                    .setSmallIcon(android.R.drawable.ic_dialog_alert)
                    .setContentTitle("⚠ Unknown Connection Detected")
                    .setContentText(displayHost)
                    .setAutoCancel(true)
                    .build();

            nm.notify((int) System.currentTimeMillis(), notif);
        } catch (Exception ignored) {}
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
            mainHandler.post(() -> {
                lookupBtn.setEnabled(true);
                if (intelJson == null) {
                    statusText.setText("❌  Network error");
                    return;
                }
                statusText.setText("✅  Scan complete for " + domain);
                lastDomainForExport    = domain;
                lastIntelJsonForExport = intelJson != null ? intelJson : "";
                lastProbeJsonForExport = "";
                buildReport(domain, intelJson, null);
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

    // ── Export ───────────────────────────────────────────────────────────────

    /** Wrap a value for safe CSV embedding (escapes quotes, wraps in quotes). */
    private String csv(String v) {
        if (v == null) return "\"\"";
        return "\"" + v.replace("\"", "\"\"") + "\"";
    }

    private void exportDomainIntel() {
        if (lastDomainForExport.isEmpty()) { showToast("Run a scan first"); return; }
        String ts = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", java.util.Locale.US).format(new Date());
        StringBuilder sb = new StringBuilder();

        // ── Header metadata block ──
        sb.append("field,value\n");
        sb.append(csv("report_type")).append(",").append(csv("NetWatch Domain Intelligence")).append("\n");
        sb.append(csv("generated")).append(",").append(csv(ts)).append("\n");
        sb.append(csv("domain")).append(",").append(csv(lastDomainForExport)).append("\n");
        sb.append("\n");

        try {
            if (!lastIntelJsonForExport.isEmpty()) {
                JSONObject intel = new JSONObject(lastIntelJsonForExport);

                // IPv4
                JSONArray ipv4 = intel.optJSONArray("ipv4");
                if (ipv4 != null && ipv4.length() > 0) {
                    sb.append("record_type,value\n");
                    for (int i = 0; i < ipv4.length(); i++)
                        sb.append(csv("ipv4")).append(",").append(csv(ipv4.optString(i))).append("\n");
                    sb.append("\n");
                }

                // IPv6
                JSONArray ipv6 = intel.optJSONArray("ipv6");
                if (ipv6 != null && ipv6.length() > 0) {
                    sb.append("record_type,value\n");
                    for (int i = 0; i < ipv6.length(); i++)
                        sb.append(csv("ipv6")).append(",").append(csv(ipv6.optString(i))).append("\n");
                    sb.append("\n");
                }

                // CNAME
                String cname = intel.optString("cname", "");
                if (!cname.isEmpty() && !cname.equals("null")) {
                    sb.append("record_type,value\n");
                    sb.append(csv("cname")).append(",").append(csv(cname)).append("\n\n");
                }

                // Subdomains
                JSONArray subs = intel.optJSONArray("subdomains");
                if (subs != null && subs.length() > 0) {
                    sb.append("subdomain,ip\n");
                    for (int i = 0; i < subs.length(); i++) {
                        JSONObject sub = subs.getJSONObject(i);
                        String subName = sub.optString("name", "");
                        JSONArray ips  = sub.optJSONArray("ips");
                        String ip = (ips != null && ips.length() > 0) ? ips.optString(0) : "";
                        sb.append(csv(subName)).append(",").append(csv(ip)).append("\n");
                    }
                    sb.append("\n");
                }

                // Shared-host domains
                JSONArray shared = intel.optJSONArray("sharedHostDomains");
                if (shared != null && shared.length() > 0) {
                    sb.append("shared_host_domain\n");
                    for (int i = 0; i < shared.length(); i++)
                        sb.append(csv(shared.optString(i))).append("\n");
                    sb.append("\n");
                }
            }
        } catch (Exception e) {
            sb.append(csv("error")).append(",").append(csv(e.getMessage())).append("\n");
        }

        String filename = "NetWatch_" + lastDomainForExport + "_" + ts.replace(" ", "_").replace(":", "") + ".csv";
        shareCsv(filename, sb.toString());
    }

    private void exportTrafficLog() {
        if (trafficLogForExport.isEmpty()) { showToast("No traffic data to export"); return; }
        String ts = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", java.util.Locale.US).format(new Date());
        String appLabel = selectedApp != null ? selectedApp.label : "Device";
        StringBuilder sb = new StringBuilder();

        // CSV header
        sb.append("timestamp,host_or_ip\n");
        for (Map.Entry<String, String> entry : trafficLogForExport.entrySet()) {
            sb.append(csv(entry.getValue())).append(",").append(csv(entry.getKey())).append("\n");
        }

        String filename = "NetWatch_Traffic_" + appLabel.replaceAll("[^a-zA-Z0-9]", "_") + "_" + ts.replace(" ", "_").replace(":", "") + ".csv";
        shareCsv(filename, sb.toString());
    }

    private void shareCsv(String filename, String csvText) {
        // Also copy to clipboard as plain text for convenience
        android.content.ClipboardManager clipboard = (android.content.ClipboardManager) getSystemService(CLIPBOARD_SERVICE);
        android.content.ClipData clip = android.content.ClipData.newPlainText(filename, csvText);
        clipboard.setPrimaryClip(clip);

        // Write to a cache file so apps like Files / Drive / Email can attach it properly
        try {
            java.io.File cacheDir = new java.io.File(getCacheDir(), "exports");
            cacheDir.mkdirs();
            java.io.File outFile = new java.io.File(cacheDir, filename);
            try (java.io.FileWriter fw = new java.io.FileWriter(outFile)) { fw.write(csvText); }

            android.net.Uri uri = androidx.core.content.FileProvider.getUriForFile(
                this, getPackageName() + ".provider", outFile);

            Intent share = new Intent(Intent.ACTION_SEND);
            share.setType("text/csv");
            share.putExtra(Intent.EXTRA_SUBJECT, filename);
            share.putExtra(Intent.EXTRA_STREAM, uri);
            share.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            startActivity(Intent.createChooser(share, "Export CSV via…"));
        } catch (Exception e) {
            // Fallback: share as plain text
            Intent share = new Intent(Intent.ACTION_SEND);
            share.setType("text/csv");
            share.putExtra(Intent.EXTRA_SUBJECT, filename);
            share.putExtra(Intent.EXTRA_TEXT, csvText);
            startActivity(Intent.createChooser(share, "Export CSV via…"));
        }
    }

    // ── Tab 4 – My Network Info ──────────────────────────────────────────────

    private void lookupMyInfo() {
        myInfoContainer.removeAllViews();
        // Show a loading card
        addMyInfoRow("⏳ Looking up your public IP…", "", "#1E2A3A");
        myInfoRefreshBtn.setEnabled(false);

        new Thread(() -> {
            String ip = null; String isp = ""; String org = ""; String org2 = "";
            String city = ""; String region = ""; String country = ""; String flag = "🌐";
            String lat = ""; String lon = ""; String timezone = ""; String zip = "";
            try {
                // 1. Get public IP via ipify
                java.net.URL ipUrl = new java.net.URL("https://api.ipify.org");
                java.net.HttpURLConnection ipConn = (java.net.HttpURLConnection) ipUrl.openConnection();
                ipConn.setConnectTimeout(5000); ipConn.setReadTimeout(5000);
                java.io.InputStream ipIs = ipConn.getInputStream();
                ip = new String(ipIs.readAllBytes(), "UTF-8").trim();
                ipConn.disconnect();
            } catch (Exception e) { ip = null; }

            if (ip != null) {
                try {
                    // 2. Geo-IP enrichment via ipinfo.io (HTTPS, no key needed)
                    java.net.URL geoUrl = new java.net.URL("https://ipinfo.io/" + ip + "/json");
                    java.net.HttpURLConnection gc = (java.net.HttpURLConnection) geoUrl.openConnection();
                    gc.setRequestProperty("Accept", "application/json");
                    gc.setConnectTimeout(6000); gc.setReadTimeout(6000);
                    java.io.InputStream gis = gc.getInputStream();
                    String geoJson = new String(gis.readAllBytes(), "UTF-8").trim();
                    gc.disconnect();
                    org.json.JSONObject g = new org.json.JSONObject(geoJson);
                    // ipinfo.io response: ip, city, region, country, loc, org, postal, timezone
                    isp      = g.optString("org", "");      // e.g. "AS15169 Google LLC"
                    city     = g.optString("city", "");
                    region   = g.optString("region", "");
                    country  = g.optString("country", "");  // 2-letter code
                    zip      = g.optString("postal", "");
                    timezone = g.optString("timezone", "");
                    String loc = g.optString("loc", "");    // "lat,lon"
                    if (loc.contains(",")) {
                        lat = loc.split(",")[0].trim();
                        lon = loc.split(",")[1].trim();
                    }
                    // Resolve country code to full name
                    try {
                        java.util.Locale locale = new java.util.Locale("", country);
                        org2 = locale.getDisplayCountry();
                    } catch (Exception e2) { org2 = country; }
                    // Convert country code to flag emoji
                    if (country.length() == 2) {
                        int f1 = 0x1F1E6 + (country.charAt(0) - 'A');
                        int f2 = 0x1F1E6 + (country.charAt(1) - 'A');
                        flag = new String(Character.toChars(f1)) + new String(Character.toChars(f2));
                    }
                } catch (Exception ignored) {}
            }

            final String resolvedIp = ip;
            final String fIp = resolvedIp != null ? resolvedIp : "Unable to determine";
            final String fIsp = isp; final String fOrg = org; final String fOrg2 = org2;
            final String fCity = city; final String fRegion = region;
            final String fCountry = country; final String fFlag = flag;
            final String fLat = lat; final String fLon = lon;
            final String fTz = timezone; final String fZip = zip;

            runOnUiThread(() -> {
                myInfoContainer.removeAllViews();
                myInfoRefreshBtn.setEnabled(true);

                // ── Public IP card ──
                addMyInfoCard("🔌  Public IP Address", fIp, "#1A237E", "#7986CB");

                if (resolvedIp == null) {
                    addMyInfoRow("Could not reach the internet. Check your connection.", "", "#1E2A3A");
                    return;
                }

                // ── ISP / Org card ──
                StringBuilder ispSb = new StringBuilder();
                if (!fIsp.isEmpty()) ispSb.append("ISP:  ").append(fIsp);
                if (!fOrg.isEmpty() && !fOrg.equals(fIsp)) {
                    if (ispSb.length() > 0) ispSb.append("\n");
                    ispSb.append("Org:  ").append(fOrg);
                }
                if (ispSb.length() > 0) addMyInfoCard("🏢  Provider", ispSb.toString(), "#1B5E20", "#81C784");

                // ── Location card ──
                StringBuilder locSb = new StringBuilder();
                if (!fCity.isEmpty()) locSb.append("City:      ").append(fCity);
                if (!fZip.isEmpty()) { if (locSb.length()>0) locSb.append("\n"); locSb.append("ZIP:       ").append(fZip); }
                if (!fRegion.isEmpty()) { if (locSb.length()>0) locSb.append("\n"); locSb.append("Region:    ").append(fRegion); }
                if (!fCountry.isEmpty()) { if (locSb.length()>0) locSb.append("\n"); locSb.append("Country:   ").append(fFlag).append("  ").append(fCountry); }
                if (!fLat.isEmpty() && !fLon.isEmpty() && !fLat.equals("0.0")) {
                    if (locSb.length()>0) locSb.append("\n");
                    locSb.append("Coords:    ").append(fLat).append(", ").append(fLon);
                }
                if (locSb.length() > 0) addMyInfoCard("📍  Geolocation", locSb.toString(), "#4A148C", "#CE93D8");

                // ── Timezone card ──
                if (!fTz.isEmpty()) addMyInfoCard("🕐  Timezone", fTz, "#1A3A2A", "#80CBC4");

                // ── Maps shortcut ──
                if (!fLat.isEmpty() && !fLon.isEmpty() && !fLat.equals("0.0")) {
                    Button mapsBtn = new Button(MainActivity.this);
                    mapsBtn.setText("📍  Open in Maps");
                    mapsBtn.setTextColor(0xFFFFFFFF);
                    mapsBtn.setBackground(getResources().getDrawable(R.drawable.btn_primary));
                    android.widget.LinearLayout.LayoutParams lp = new android.widget.LinearLayout.LayoutParams(
                        android.widget.LinearLayout.LayoutParams.MATCH_PARENT,
                        android.widget.LinearLayout.LayoutParams.WRAP_CONTENT);
                    lp.setMargins(0, 12, 0, 0);
                    mapsBtn.setLayoutParams(lp);
                    final String mapsUri = "geo:" + fLat + "," + fLon + "?q=" + fLat + "," + fLon + "(" + fIp + ")";
                    mapsBtn.setOnClickListener(v -> {
                        android.content.Intent intent = new android.content.Intent(android.content.Intent.ACTION_VIEW,
                            android.net.Uri.parse(mapsUri));
                        if (intent.resolveActivity(getPackageManager()) != null) startActivity(intent);
                        else showToast("No maps app found");
                    });
                    myInfoContainer.addView(mapsBtn);
                }
            });
        }).start();
    }

    private void addMyInfoCard(String title, String body, String bgColor, String titleColor) {
        android.widget.LinearLayout card = new android.widget.LinearLayout(this);
        card.setOrientation(android.widget.LinearLayout.VERTICAL);
        card.setBackgroundColor(android.graphics.Color.parseColor(bgColor));
        android.widget.LinearLayout.LayoutParams lp = new android.widget.LinearLayout.LayoutParams(
            android.widget.LinearLayout.LayoutParams.MATCH_PARENT,
            android.widget.LinearLayout.LayoutParams.WRAP_CONTENT);
        lp.setMargins(0, 0, 0, 12);
        card.setLayoutParams(lp);
        card.setPadding(28, 20, 28, 20);

        android.widget.TextView tv = new android.widget.TextView(this);
        tv.setText(title);
        tv.setTextColor(android.graphics.Color.parseColor(titleColor));
        tv.setTextSize(13f);
        tv.setTypeface(null, android.graphics.Typeface.BOLD);
        tv.setPadding(0, 0, 0, 10);
        card.addView(tv);

        android.widget.TextView bv = new android.widget.TextView(this);
        bv.setText(body);
        bv.setTextColor(0xFFE0E0E0);
        bv.setTextSize(14f);
        bv.setTypeface(android.graphics.Typeface.MONOSPACE);
        card.addView(bv);

        myInfoContainer.addView(card);
    }

    private void addMyInfoRow(String text, String sub, String bgColor) {
        android.widget.TextView tv = new android.widget.TextView(this);
        tv.setText(text);
        tv.setTextColor(0xFFB0BEC5);
        tv.setTextSize(13f);
        tv.setPadding(12, 8, 12, 8);
        myInfoContainer.addView(tv);
    }

        // ── Helpers ──────────────────────────────────────────────────────────────

    private void switchTab(int index) {
        tab1.setVisibility(index == 0 ? View.VISIBLE : View.GONE);
        tab2.setVisibility(index == 1 ? View.VISIBLE : View.GONE);
        tab3.setVisibility(index == 2 ? View.VISIBLE : View.GONE);
        tab4.setVisibility(index == 3 ? View.VISIBLE : View.GONE);
        if (index == 3 && myInfoContainer.getChildCount() == 0) lookupMyInfo();
        tabDomainBtn.setSelected(index == 0);
        tabTrafficBtn.setSelected(index == 1);
        tabCheckerBtn.setSelected(index == 2);
        // Re-apply last known stats so TX/RX panels are never blank on tab entry
        if (index == 1 && lastKnownTx >= 0) {
            txTotalText.setText("TX  " + formatBytes(lastKnownTx));
            rxTotalText.setText("RX  " + formatBytes(lastKnownRx));
            txRateText.setText("↑ " + formatBytes(lastKnownTxRate) + "/s");
            rxRateText.setText("↓ " + formatBytes(lastKnownRxRate) + "/s");
            txRateText.setTextColor(lastKnownTxRate > 0 ? Color.parseColor("#EF9A9A") : Color.parseColor("#546E7A"));
            rxRateText.setTextColor(lastKnownRxRate > 0 ? Color.parseColor("#66BB6A") : Color.parseColor("#546E7A"));
        }
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

    // ─────────────────────────────────────────────────────────────
    // TAB 3 — Domain Checker
    // ─────────────────────────────────────────────────────────────

    // Ordered map: category -> list of {label, host}
    private static final LinkedHashMap<String, String[][]> CHECKER_DOMAINS = new LinkedHashMap<>();
    static {
        CHECKER_DOMAINS.put("🔵 Google", new String[][]{
            {"Google Search",     "google.com"},
            {"Google DNS",        "8.8.8.8"},
            {"Gmail",             "mail.google.com"},
            {"Google Drive",      "drive.google.com"},
            {"YouTube",           "youtube.com"},
            {"Google Play",       "play.google.com"},
            {"Google APIs",       "googleapis.com"},
        });
        CHECKER_DOMAINS.put("🟠 Microsoft", new String[][]{
            {"Bing",              "bing.com"},
            {"Outlook / Exchange","outlook.office365.com"},
            {"OneDrive",          "onedrive.live.com"},
            {"Teams",             "teams.microsoft.com"},
            {"Azure",             "azure.microsoft.com"},
            {"GitHub",            "github.com"},
            {"Microsoft CDN",     "msftconnecttest.com"},
        });
        CHECKER_DOMAINS.put("🟡 Cloudflare", new String[][]{
            {"Cloudflare DNS 1",  "1.1.1.1"},
            {"Cloudflare DNS 2",  "1.0.0.1"},
            {"Cloudflare Web",    "cloudflare.com"},
            {"WARP / DoH",        "cloudflare-dns.com"},
        });
        CHECKER_DOMAINS.put("🟣 Social & Messaging", new String[][]{
            {"Facebook",          "facebook.com"},
            {"Instagram",         "instagram.com"},
            {"WhatsApp",          "web.whatsapp.com"},
            {"Twitter / X",       "x.com"},
            {"Telegram",          "telegram.org"},
            {"LinkedIn",          "linkedin.com"},
            {"TikTok",            "tiktok.com"},
            {"Reddit",            "reddit.com"},
            {"Disqus",            "disqus.com"},
        });
        CHECKER_DOMAINS.put("🔴 Streaming", new String[][]{
            {"Netflix",           "netflix.com"},
            {"Spotify",           "spotify.com"},
            {"Twitch",            "twitch.tv"},
            {"Apple iCloud",      "icloud.com"},
        });
        CHECKER_DOMAINS.put("🟢 CDN / Infrastructure", new String[][]{
            {"Akamai",            "akamai.com"},
            {"Fastly",            "fastly.com"},
            {"Amazon AWS",        "aws.amazon.com"},
            {"Quad9 DNS",         "9.9.9.9"},
            {"OpenDNS",           "208.67.222.222"},
        });
        CHECKER_DOMAINS.put("🏦 Finance & Payments", new String[][]{
            {"PayPal",            "paypal.com"},
            {"Stripe",            "stripe.com"},
            {"Visa",              "visa.com"},
            {"Mastercard",        "mastercard.com"},
        });
        CHECKER_DOMAINS.put("🎮 Gaming", new String[][]{
            {"Xbox Live",         "xbox.com"},
            {"Xbox Services",     "xboxlive.com"},
            {"Xbox CDN",          "xboxlive-ce-retail.com"},
            {"Microsoft Game",    "xgweb.com"},
            {"PlayStation",       "playstation.com"},
            {"PSN Network",       "psn.np.com"},
            {"PS Store",          "store.playstation.com"},
            {"PS CDN",            "dl.playstation.net"},
            {"PS Auth",           "auth.api.sonyentertainmentnetwork.com"},
        });
    }

    // Map host -> status TextView (populated by buildCheckerRows)
    private final Map<String, TextView> checkerStatusViews = new LinkedHashMap<>();

    private void buildCheckerRows() {
        checkResultsContainer.removeAllViews();
        checkerStatusViews.clear();

        for (Map.Entry<String, String[][]> cat : CHECKER_DOMAINS.entrySet()) {
            // Category header
            TextView header = new TextView(this);
            header.setText(cat.getKey());
            header.setTextColor(Color.parseColor("#64B5F6"));
            header.setTextSize(12f);
            header.setTypeface(null, Typeface.BOLD);
            LinearLayout.LayoutParams hp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
            hp.setMargins(0, dp(10), 0, dp(4));
            header.setLayoutParams(hp);
            header.setAllCaps(true);
            checkResultsContainer.addView(header);

            for (String[] entry : cat.getValue()) {
                String label = entry[0];
                String host  = entry[1];

                LinearLayout row = new LinearLayout(this);
                row.setOrientation(LinearLayout.HORIZONTAL);
                row.setBackground(getDrawable(R.drawable.card_background));
                LinearLayout.LayoutParams rp = new LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                rp.setMargins(0, dp(2), 0, dp(2));
                row.setLayoutParams(rp);
                row.setPadding(dp(10), dp(8), dp(10), dp(8));

                // Status dot
                TextView dot = new TextView(this);
                dot.setText("●");
                dot.setTextColor(Color.parseColor("#546E7A"));
                dot.setTextSize(14f);
                dot.setPadding(0, 0, dp(10), 0);
                row.addView(dot);

                // Label + host
                LinearLayout info = new LinearLayout(this);
                info.setOrientation(LinearLayout.VERTICAL);
                info.setLayoutParams(new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
                TextView labelView = new TextView(this);
                labelView.setText(label);
                labelView.setTextColor(Color.parseColor("#E3F2FD"));
                labelView.setTextSize(13f);
                TextView hostView = new TextView(this);
                hostView.setText(host);
                hostView.setTextColor(Color.parseColor("#607D8B"));
                hostView.setTextSize(11f);
                info.addView(labelView);
                info.addView(hostView);
                row.addView(info);

                // Latency / status text
                TextView status = new TextView(this);
                status.setText("—");
                status.setTextColor(Color.parseColor("#546E7A"));
                status.setTextSize(12f);
                status.setGravity(android.view.Gravity.END | android.view.Gravity.CENTER_VERTICAL);
                row.addView(status);

                checkerStatusViews.put(host, status);
                // Store dot view using tag so we can color it
                row.setTag(dot);
                checkResultsContainer.addView(row);
            }
        }
    }

    private void startDomainCheck() {
        if (checkRunning.get()) return;
        checkRunning.set(true);
        checkAllBtn.setEnabled(false);
        stopCheckBtn.setEnabled(true);
        checkStatusText.setTextColor(Color.parseColor("#64B5F6"));

        // Reset all to pending
        for (Map.Entry<String, TextView> e : checkerStatusViews.entrySet()) {
            e.getValue().setText("…");
            e.getValue().setTextColor(Color.parseColor("#90A4AE"));
            // Reset dot
            ViewParent vp = e.getValue().getParent();
            if (vp instanceof LinearLayout) {
                Object tag = ((LinearLayout)vp).getTag();
                if (tag instanceof TextView) ((TextView)tag).setTextColor(Color.parseColor("#546E7A"));
            }
        }

        final List<String[]> allEntries = new ArrayList<>();
        for (String[][] entries : CHECKER_DOMAINS.values())
            for (String[] e : entries) allEntries.add(e);

        executor.execute(() -> {
            int done = 0, reachable = 0, blocked = 0;
            for (String[] entry : allEntries) {
                if (!checkRunning.get()) break;
                String label = entry[0];
                String host  = entry[1];
                done++;
                final int fdone = done;
                mainHandler.post(() ->
                    checkStatusText.setText("Checking " + fdone + "/" + allEntries.size() + " — " + host));

                long[] result = probeHost(host);
                // result[0] = 1 reachable / 0 blocked, result[1] = latency ms
                boolean ok = result[0] == 1;
                long ms     = result[1];
                if (ok) reachable++; else blocked++;

                mainHandler.post(() -> {
                    TextView sv = checkerStatusViews.get(host);
                    if (sv == null) return;
                    sv.setText(ok ? ms + " ms" : "BLOCKED");
                    sv.setTextColor(ok ? Color.parseColor("#66BB6A") : Color.parseColor("#EF5350"));
                    ViewParent vp = sv.getParent();
                    if (vp instanceof LinearLayout) {
                        Object tag = ((LinearLayout)vp).getTag();
                        if (tag instanceof TextView)
                            ((TextView)tag).setTextColor(ok ? Color.parseColor("#66BB6A") : Color.parseColor("#EF5350"));
                    }
                });
            }

            final int fr = reachable, fb = blocked, fd = done;
            mainHandler.post(() -> {
                checkRunning.set(false);
                checkAllBtn.setEnabled(true);
                stopCheckBtn.setEnabled(false);
                if (fd == allEntries.size()) {
                    checkStatusText.setText("Done — ✅ " + fr + " reachable   🚫 " + fb + " blocked");
                } else {
                    checkStatusText.setText("Stopped — ✅ " + fr + "  🚫 " + fb + " (of " + fd + " checked)");
                }
                checkStatusText.setTextColor(fb > 0 ? Color.parseColor("#EF9A9A") : Color.parseColor("#66BB6A"));
            });
        });
    }

    private void stopDomainCheck() {
        checkRunning.set(false);
        stopCheckBtn.setEnabled(false);
    }

    /** Returns [reachable(1/0), latencyMs] */
    private long[] probeHost(String host) {
        long start = System.currentTimeMillis();
        try {
            // First try HTTP(S) for named hosts, ICMP-style connect for IPs
            boolean isIp = host.matches("\\d+\\.\\d+\\.\\d+\\.\\d+");
            if (isIp) {
                InetAddress addr = InetAddress.getByName(host);
                boolean reached = addr.isReachable(3000);
                if (!reached) {
                    // Fallback: TCP connect to port 53 (DNS) for IP addresses
                    try (java.net.Socket sock = new java.net.Socket()) {
                        sock.connect(new java.net.InetSocketAddress(host, 53), 3000);
                        reached = true;
                    } catch (Exception ignored2) {}
                }
                long ms = System.currentTimeMillis() - start;
                return new long[]{reached ? 1 : 0, ms};
            } else {
                // DNS resolve first
                InetAddress.getByName(host); // throws if blocked/unresolvable
                // Then HTTP HEAD
                URL url = new URL("https://" + host + "/");
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("HEAD");
                conn.setConnectTimeout(3000);
                conn.setReadTimeout(3000);
                conn.setInstanceFollowRedirects(true);
                conn.connect();
                int code = conn.getResponseCode();
                conn.disconnect();
                long ms = System.currentTimeMillis() - start;
                // Any HTTP response (including 4xx/5xx) means the host is reachable
                return new long[]{(code > 0) ? 1 : 0, ms};
            }
        } catch (Exception e) {
            long ms = System.currentTimeMillis() - start;
            return new long[]{0, ms};
        }
    }


    // ─────────────────────────────────────────────────────────────
    // Custom domain / IP check
    // ─────────────────────────────────────────────────────────────
    private void checkCustomDomain() {
        String raw = customDomainInput.getText().toString().trim();
        if (raw.isEmpty()) { showToast("Enter a domain or IP first"); return; }
        // Strip protocol prefix if pasted in
        raw = raw.replaceFirst("^https?://", "").replaceFirst("/.*$", "");
        final String host = raw;

        // Dismiss keyboard
        android.view.inputmethod.InputMethodManager imm =
            (android.view.inputmethod.InputMethodManager) getSystemService(INPUT_METHOD_SERVICE);
        if (imm != null) imm.hideSoftInputFromWindow(customDomainInput.getWindowToken(), 0);

        // Add a result row at the top of the results container (or update existing)
        LinearLayout existingRow = (LinearLayout) checkResultsContainer.findViewWithTag("custom_" + host);
        TextView statusView;
        TextView dotView;

        if (existingRow != null) {
            dotView    = (TextView) existingRow.getTag();
            statusView = (TextView) existingRow.getChildAt(existingRow.getChildCount() - 1);
            dotView.setTextColor(Color.parseColor("#FFC107"));
            statusView.setText("…");
            statusView.setTextColor(Color.parseColor("#90A4AE"));
        } else {
            // Section header (only once for custom entries)
            if (checkResultsContainer.findViewWithTag("custom_header") == null) {
                TextView header = new TextView(this);
                header.setTag("custom_header");
                header.setText("🔎  Custom Checks");
                header.setTextColor(Color.parseColor("#64B5F6"));
                header.setTextSize(12f);
                header.setTypeface(null, android.graphics.Typeface.BOLD);
                header.setAllCaps(true);
                LinearLayout.LayoutParams hp = new LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                hp.setMargins(0, dp(10), 0, dp(4));
                header.setLayoutParams(hp);
                checkResultsContainer.addView(header, 0);
            }

            LinearLayout row = new LinearLayout(this);
            row.setOrientation(LinearLayout.HORIZONTAL);
            row.setBackground(getDrawable(R.drawable.card_background));
            row.setTag("custom_" + host);
            LinearLayout.LayoutParams rp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
            rp.setMargins(0, dp(2), 0, dp(2));
            row.setLayoutParams(rp);
            row.setPadding(dp(10), dp(8), dp(10), dp(8));

            dotView = new TextView(this);
            dotView.setText("●");
            dotView.setTextColor(Color.parseColor("#FFC107")); // amber = in progress
            dotView.setTextSize(14f);
            dotView.setPadding(0, 0, dp(10), 0);
            row.setTag(dotView);
            row.addView(dotView);

            LinearLayout info = new LinearLayout(this);
            info.setOrientation(LinearLayout.VERTICAL);
            info.setLayoutParams(new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
            TextView labelView = new TextView(this);
            labelView.setText(host);
            labelView.setTextColor(Color.parseColor("#E3F2FD"));
            labelView.setTextSize(13f);
            TextView typeView = new TextView(this);
            typeView.setText(host.matches("\\d+\\.\\d+\\.\\d+\\.\\d+") ? "IP Address" : "Domain");
            typeView.setTextColor(Color.parseColor("#607D8B"));
            typeView.setTextSize(11f);
            info.addView(labelView);
            info.addView(typeView);
            row.addView(info);

            statusView = new TextView(this);
            statusView.setText("…");
            statusView.setTextColor(Color.parseColor("#90A4AE"));
            statusView.setTextSize(12f);
            statusView.setGravity(android.view.Gravity.END | android.view.Gravity.CENTER_VERTICAL);
            row.addView(statusView);

            // Insert just after the custom_header
            int insertIdx = 1;
            checkResultsContainer.addView(row, insertIdx);
        }

        final TextView fStatus = statusView;
        final TextView fDot    = dotView;

        checkStatusText.setText("Checking " + host + "…");
        checkStatusText.setTextColor(Color.parseColor("#64B5F6"));

        executor.execute(() -> {
            long[] result = probeHost(host);
            boolean ok = result[0] == 1;
            long ms     = result[1];
            mainHandler.post(() -> {
                fStatus.setText(ok ? ms + " ms" : "BLOCKED");
                fStatus.setTextColor(ok ? Color.parseColor("#66BB6A") : Color.parseColor("#EF5350"));
                fDot.setTextColor(ok ? Color.parseColor("#66BB6A") : Color.parseColor("#EF5350"));
                checkStatusText.setText(host + (ok ? " ✅  reachable in " + ms + " ms" : " 🚫  appears BLOCKED"));
                checkStatusText.setTextColor(ok ? Color.parseColor("#66BB6A") : Color.parseColor("#EF9A9A"));
                // Scroll to top so user sees the result
                ScrollView sv = (ScrollView) checkResultsContainer.getParent();
                sv.smoothScrollTo(0, 0);
            });
        });
    }

}