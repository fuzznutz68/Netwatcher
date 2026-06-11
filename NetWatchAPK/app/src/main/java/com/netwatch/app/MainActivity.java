package com.netwatch.app;

import android.app.Activity;
import android.content.Intent;
import android.net.VpnService;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;
import androidx.annotation.NonNull;
import com.google.android.material.tabs.TabLayout;

public class MainActivity extends Activity {

    private static final int VPN_REQUEST_CODE = 1001;
    private static final String BASE44_URL = "https://superagent-cfb25b3e.base44.app/functions";
    private static final String AUTH_TOKEN = ""; // Set after login

    private TabLayout tabLayout;
    private FrameLayout tabContent;

    // Tab 1 - Domain Intel
    private EditText domainInput;
    private Button lookupBtn;
    private LinearLayout resultsContainer;
    private TextView statusText;

    // Tab 2 - Traffic Monitor
    private EditText targetDomainInput;
    private Button startVpnBtn;
    private Button stopVpnBtn;
    private LinearLayout trafficLogContainer;
    private TextView vpnStatusText;

    private boolean vpnRunning = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        tabLayout = findViewById(R.id.tabLayout);
        tabContent = findViewById(R.id.tabContent);

        // Domain Intel tab views
        domainInput = findViewById(R.id.domainInput);
        lookupBtn = findViewById(R.id.lookupBtn);
        resultsContainer = findViewById(R.id.resultsContainer);
        statusText = findViewById(R.id.statusText);

        // Traffic Monitor tab views
        targetDomainInput = findViewById(R.id.targetDomainInput);
        startVpnBtn = findViewById(R.id.startVpnBtn);
        stopVpnBtn = findViewById(R.id.stopVpnBtn);
        trafficLogContainer = findViewById(R.id.trafficLogContainer);
        vpnStatusText = findViewById(R.id.vpnStatusText);

        setupTabs();
        setupDomainIntel();
        setupTrafficMonitor();
    }

    private void setupTabs() {
        tabLayout.addTab(tabLayout.newTab().setText("🔍 Domain Intel"));
        tabLayout.addTab(tabLayout.newTab().setText("📡 Traffic Monitor"));

        tabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                showTab(tab.getPosition());
            }
            @Override public void onTabUnselected(TabLayout.Tab tab) {}
            @Override public void onTabReselected(TabLayout.Tab tab) {}
        });

        showTab(0);
    }

    private void showTab(int position) {
        findViewById(R.id.tab1Content).setVisibility(position == 0 ? View.VISIBLE : View.GONE);
        findViewById(R.id.tab2Content).setVisibility(position == 1 ? View.VISIBLE : View.GONE);
    }

    private void setupDomainIntel() {
        lookupBtn.setOnClickListener(v -> {
            String domain = domainInput.getText().toString().trim();
            if (domain.isEmpty()) {
                Toast.makeText(this, "Please enter a domain", Toast.LENGTH_SHORT).show();
                return;
            }
            performDomainLookup(domain);
        });
    }

    private void performDomainLookup(String domain) {
        statusText.setText("🔄 Resolving domain...");
        statusText.setVisibility(View.VISIBLE);
        resultsContainer.removeAllViews();
        lookupBtn.setEnabled(false);

        new Thread(() -> {
            try {
                String jsonBody = "{\"domain\":\"" + domain + "\"}";
                java.net.URL url = new java.net.URL(BASE44_URL + "/domainIntel");
                java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
                conn.setRequestMethod("POST");
                conn.setRequestProperty("Content-Type", "application/json");
                conn.setDoOutput(true);
                conn.setConnectTimeout(15000);
                conn.setReadTimeout(30000);

                conn.getOutputStream().write(jsonBody.getBytes("UTF-8"));

                int code = conn.getResponseCode();
                java.io.InputStream is = code == 200 ? conn.getInputStream() : conn.getErrorStream();
                java.util.Scanner scanner = new java.util.Scanner(is).useDelimiter("\\A");
                String response = scanner.hasNext() ? scanner.next() : "";

                runOnUiThread(() -> {
                    lookupBtn.setEnabled(true);
                    statusText.setVisibility(View.GONE);
                    displayDomainResults(response, domain);
                });
            } catch (Exception e) {
                runOnUiThread(() -> {
                    lookupBtn.setEnabled(true);
                    statusText.setText("❌ Error: " + e.getMessage());
                });
            }
        }).start();
    }

    private void displayDomainResults(String json, String domain) {
        try {
            org.json.JSONObject data = new org.json.JSONObject(json);
            resultsContainer.removeAllViews();

            // Header Card
            addCard(resultsContainer, "🌐 Domain", domain, "#1a237e");

            // Main IP
            if (data.has("mainIp")) {
                addCard(resultsContainer, "🖥️ Primary IP", data.getString("mainIp"), "#1b5e20");
            }

            // A Records (IPv4)
            org.json.JSONObject dns = data.optJSONObject("dns");
            if (dns != null) {
                org.json.JSONArray aRecs = dns.optJSONArray("A");
                if (aRecs != null && aRecs.length() > 0) {
                    StringBuilder ips = new StringBuilder();
                    for (int i = 0; i < aRecs.length(); i++) {
                        if (i > 0) ips.append("\n");
                        ips.append("• ").append(aRecs.getJSONObject(i).getString("data"));
                    }
                    addCard(resultsContainer, "📌 IPv4 Addresses (A Records)", ips.toString(), "#0d47a1");
                }

                // AAAA Records (IPv6)
                org.json.JSONArray aaaaRecs = dns.optJSONArray("AAAA");
                if (aaaaRecs != null && aaaaRecs.length() > 0) {
                    StringBuilder ips6 = new StringBuilder();
                    for (int i = 0; i < aaaaRecs.length(); i++) {
                        if (i > 0) ips6.append("\n");
                        ips6.append("• ").append(aaaaRecs.getJSONObject(i).getString("data"));
                    }
                    addCard(resultsContainer, "🔷 IPv6 Addresses (AAAA Records)", ips6.toString(), "#1565c0");
                }

                // MX Records
                org.json.JSONArray mxRecs = dns.optJSONArray("MX");
                if (mxRecs != null && mxRecs.length() > 0) {
                    StringBuilder mx = new StringBuilder();
                    for (int i = 0; i < mxRecs.length(); i++) {
                        if (i > 0) mx.append("\n");
                        mx.append("• ").append(mxRecs.getJSONObject(i).getString("data"));
                    }
                    addCard(resultsContainer, "📧 Mail Servers (MX)", mx.toString(), "#4a148c");
                }

                // NS Records
                org.json.JSONArray nsRecs = dns.optJSONArray("NS");
                if (nsRecs != null && nsRecs.length() > 0) {
                    StringBuilder ns = new StringBuilder();
                    for (int i = 0; i < nsRecs.length(); i++) {
                        if (i > 0) ns.append("\n");
                        ns.append("• ").append(nsRecs.getJSONObject(i).getString("data"));
                    }
                    addCard(resultsContainer, "🔗 Name Servers (NS)", ns.toString(), "#880e4f");
                }

                // TXT Records
                org.json.JSONArray txtRecs = dns.optJSONArray("TXT");
                if (txtRecs != null && txtRecs.length() > 0) {
                    StringBuilder txt = new StringBuilder();
                    for (int i = 0; i < txtRecs.length(); i++) {
                        if (i > 0) txt.append("\n");
                        txt.append("• ").append(txtRecs.getJSONObject(i).getString("data"));
                    }
                    addCard(resultsContainer, "📝 TXT Records", txt.toString(), "#e65100");
                }
            }

            // Subdomains
            org.json.JSONArray subs = data.optJSONArray("subdomains");
            if (subs != null && subs.length() > 0) {
                StringBuilder subList = new StringBuilder();
                for (int i = 0; i < subs.length(); i++) {
                    if (i > 0) subList.append("\n");
                    subList.append("• ").append(subs.getString(i));
                }
                addCard(resultsContainer, "🌳 Subdomains (" + subs.length() + " found)", subList.toString(), "#004d40");
            }

            // Subdomain IPs
            org.json.JSONArray subIps = data.optJSONArray("subdomainIps");
            if (subIps != null && subIps.length() > 0) {
                StringBuilder subIpList = new StringBuilder();
                for (int i = 0; i < subIps.length(); i++) {
                    org.json.JSONObject entry = subIps.getJSONObject(i);
                    subIpList.append("• ").append(entry.getString("subdomain")).append(": ");
                    org.json.JSONArray ips = entry.optJSONArray("ips");
                    if (ips != null) {
                        for (int j = 0; j < ips.length(); j++) {
                            if (j > 0) subIpList.append(", ");
                            subIpList.append(ips.getString(j));
                        }
                    }
                    if (i < subIps.length() - 1) subIpList.append("\n");
                }
                addCard(resultsContainer, "🗺️ Subdomain IP Map", subIpList.toString(), "#006064");
            }

            // Reverse IP
            org.json.JSONArray revIp = data.optJSONArray("reverseIp");
            if (revIp != null && revIp.length() > 0) {
                StringBuilder revList = new StringBuilder();
                for (int i = 0; i < revIp.length(); i++) {
                    if (i > 0) revList.append("\n");
                    revList.append("• ").append(revIp.getString(i));
                }
                addCard(resultsContainer, "🔄 Other Domains on Same IP", revList.toString(), "#bf360c");
            }

            // Timestamp
            addCard(resultsContainer, "⏰ Scan Time", data.optString("timestamp", "—"), "#37474f");

        } catch (Exception e) {
            statusText.setText("❌ Parse error: " + e.getMessage());
            statusText.setVisibility(View.VISIBLE);
        }
    }

    private void setupTrafficMonitor() {
        stopVpnBtn.setEnabled(false);

        startVpnBtn.setOnClickListener(v -> {
            String targetDomain = targetDomainInput.getText().toString().trim();
            if (targetDomain.isEmpty()) {
                Toast.makeText(this, "Enter a domain to monitor", Toast.LENGTH_SHORT).show();
                return;
            }
            requestVpnPermission(targetDomain);
        });

        stopVpnBtn.setOnClickListener(v -> stopVpnMonitor());

        // Register for traffic log updates
        NetWatchVpnService.setLogCallback(entry -> {
            runOnUiThread(() -> addTrafficEntry(entry));
        });
    }

    private void requestVpnPermission(String targetDomain) {
        Intent intent = VpnService.prepare(this);
        if (intent != null) {
            // Need user to grant VPN permission
            targetDomainInput.setTag(targetDomain);
            startActivityForResult(intent, VPN_REQUEST_CODE);
        } else {
            // Already granted
            startVpnMonitor(targetDomain);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == VPN_REQUEST_CODE) {
            if (resultCode == RESULT_OK) {
                String domain = (String) targetDomainInput.getTag();
                if (domain != null) startVpnMonitor(domain);
            } else {
                Toast.makeText(this, "VPN permission denied. Cannot monitor traffic.", Toast.LENGTH_LONG).show();
            }
        }
    }

    private void startVpnMonitor(String targetDomain) {
        vpnRunning = true;
        vpnStatusText.setText("🟢 Monitoring: " + targetDomain);
        startVpnBtn.setEnabled(false);
        stopVpnBtn.setEnabled(true);
        trafficLogContainer.removeAllViews();

        Intent vpnIntent = new Intent(this, NetWatchVpnService.class);
        vpnIntent.putExtra("target_domain", targetDomain);
        startService(vpnIntent);

        Toast.makeText(this, "Traffic monitoring started", Toast.LENGTH_SHORT).show();
    }

    private void stopVpnMonitor() {
        vpnRunning = false;
        vpnStatusText.setText("🔴 Monitoring stopped");
        startVpnBtn.setEnabled(true);
        stopVpnBtn.setEnabled(false);

        Intent stopIntent = new Intent(this, NetWatchVpnService.class);
        stopIntent.setAction("STOP");
        startService(stopIntent);
    }

    private void addTrafficEntry(TrafficEntry entry) {
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.VERTICAL);
        row.setPadding(16, 12, 16, 12);
        row.setBackgroundResource(R.drawable.card_background);

        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        );
        params.setMargins(0, 0, 0, 8);
        row.setLayoutParams(params);

        // Direction + protocol badge
        TextView header = new TextView(this);
        String dir = entry.direction.equals("OUT") ? "⬆️ Outbound" : "⬇️ Inbound";
        String color = entry.direction.equals("OUT") ? "#e53935" : "#43a047";
        header.setText(dir + "  [" + entry.protocol + "]");
        header.setTextSize(14);
        header.setTextColor(android.graphics.Color.parseColor(color));
        header.setTypeface(null, android.graphics.Typeface.BOLD);
        row.addView(header);

        // Destination
        TextView dest = new TextView(this);
        dest.setText("🌐 " + entry.remoteHost + " (" + entry.remoteIp + ":" + entry.remotePort + ")");
        dest.setTextSize(13);
        dest.setTextColor(android.graphics.Color.parseColor("#212121"));
        row.addView(dest);

        // Data size
        TextView size = new TextView(this);
        size.setText("📦 " + formatBytes(entry.bytes) + "   ⏱ " + entry.timestamp);
        size.setTextSize(12);
        size.setTextColor(android.graphics.Color.parseColor("#757575"));
        row.addView(size);

        trafficLogContainer.addView(row, 0); // newest first

        // Keep max 100 entries
        if (trafficLogContainer.getChildCount() > 100) {
            trafficLogContainer.removeViewAt(trafficLogContainer.getChildCount() - 1);
        }
    }

    private void addCard(LinearLayout container, String title, String content, String colorHex) {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setPadding(20, 16, 20, 16);
        card.setBackgroundResource(R.drawable.card_background);

        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        );
        params.setMargins(0, 0, 0, 12);
        card.setLayoutParams(params);

        // Left color bar
        try {
            card.setBackgroundColor(android.graphics.Color.parseColor("#ffffff"));
        } catch (Exception ignored) {}

        TextView titleView = new TextView(this);
        titleView.setText(title);
        titleView.setTextSize(13);
        titleView.setTextColor(android.graphics.Color.parseColor(colorHex));
        titleView.setTypeface(null, android.graphics.Typeface.BOLD);
        titleView.setPadding(0, 0, 0, 6);
        card.addView(titleView);

        TextView contentView = new TextView(this);
        contentView.setText(content);
        contentView.setTextSize(14);
        contentView.setTextColor(android.graphics.Color.parseColor("#212121"));
        contentView.setLineSpacing(4, 1.2f);
        card.addView(contentView);

        container.addView(card);
    }

    private String formatBytes(long bytes) {
        if (bytes < 1024) return bytes + " B";
        if (bytes < 1024 * 1024) return (bytes / 1024) + " KB";
        return (bytes / (1024 * 1024)) + " MB";
    }
}
