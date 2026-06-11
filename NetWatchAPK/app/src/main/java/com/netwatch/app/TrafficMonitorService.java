package com.netwatch.app;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.content.pm.ServiceInfo;
import android.net.TrafficStats;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class TrafficMonitorService extends Service {

    private static final String TAG = "NetWatch";

    public static final String ACTION_STOP    = "com.netwatch.app.STOP_MONITOR";
    public static final String EVENT_ACTION   = "com.netwatch.app.TRAFFIC_EVENT";

    public static final String EXTRA_TX_BYTES  = "tx_bytes";
    public static final String EXTRA_RX_BYTES  = "rx_bytes";
    public static final String EXTRA_TX_RATE   = "tx_rate";
    public static final String EXTRA_RX_RATE   = "rx_rate";
    public static final String EXTRA_HOSTS     = "hosts";
    public static final String EXTRA_TIMESTAMP = "timestamp";

    private static final String CHANNEL_ID  = "netwatch_monitor";
    private static final int    NOTIF_ID    = 43;
    private static final long   POLL_MS     = 1000L;

    private static final String DOMAIN_INTEL_URL = "https://superagent-cfb25b3e.base44.app/functions/domainIntel";

    private int     targetUid  = -1;
    private String  targetPkg  = "";
    private String  targetName = "";
    private boolean running    = false;

    private long lastTx = TrafficStats.UNSUPPORTED;
    private long lastRx = TrafficStats.UNSUPPORTED;

    private final Handler         handler  = new Handler(Looper.getMainLooper());
    private final ExecutorService ioExec   = Executors.newFixedThreadPool(6);

    // IP → hostname cache (populated by reverse DNS lookups)
    private final ConcurrentHashMap<String, String> dnsCache  = new ConcurrentHashMap<>();
    // IPs we've already submitted for reverse-DNS (avoid duplicate jobs)
    private final Set<String> submittedIps = Collections.synchronizedSet(new HashSet<>());
    // Hosts we've already broadcast so we only send new ones
    private final Set<String> broadcastHosts = Collections.synchronizedSet(new HashSet<>());
    // Known domains seeded from the backend intel for this app's package name
    private final List<String> seededDomains = new ArrayList<>();

    private final Runnable pollRunnable = new Runnable() {
        @Override public void run() {
            if (!running) return;
            poll();
            handler.postDelayed(this, POLL_MS);
        }
    };

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent != null && ACTION_STOP.equals(intent.getAction())) {
            stopSelf();
            return START_NOT_STICKY;
        }

        if (intent != null) {
            targetUid  = intent.getIntExtra("target_uid", -1);
            targetPkg  = intent.getStringExtra("target_pkg");  if (targetPkg  == null) targetPkg  = "";
            targetName = intent.getStringExtra("target_name"); if (targetName == null) targetName = "";
        }

        createChannel();
        Notification n = buildNotification();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(NOTIF_ID, n, ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC);
        } else {
            startForeground(NOTIF_ID, n);
        }

        dnsCache.clear();
        submittedIps.clear();
        broadcastHosts.clear();
        seededDomains.clear();
        lastTx = TrafficStats.UNSUPPORTED;
        lastRx = TrafficStats.UNSUPPORTED;
        running = true;

        // Seed known domains from backend in background
        if (!targetPkg.isEmpty()) {
            seedDomainsFromBackend(targetPkg);
        }

        handler.post(pollRunnable);
        return START_STICKY;
    }

    // ── Seed domains from domainIntel backend ────────────────────────────────
    // Derives a likely root domain from the package name (e.g. com.paypal.android → paypal.com)
    // then fetches subdomains to pre-populate the display before connections are even seen.

    private void seedDomainsFromBackend(String pkg) {
        ioExec.submit(() -> {
            String rootDomain = packageToRootDomain(pkg);
            if (rootDomain == null) return;
            Log.d(TAG, "Seeding domains for " + rootDomain);
            try {
                String json = postJson(DOMAIN_INTEL_URL, "{\"domain\":\"" + rootDomain + "\"}");
                if (json == null) return;
                JSONObject obj = new JSONObject(json);

                List<String> domains = new ArrayList<>();
                domains.add(rootDomain);

                // Add subdomains
                JSONArray subs = obj.optJSONArray("subdomains");
                if (subs != null) {
                    for (int i = 0; i < subs.length(); i++) {
                        JSONObject sub = subs.optJSONObject(i);
                        if (sub != null) {
                            String name = sub.optString("name", "");
                            if (!name.isEmpty()) domains.add(name);
                        }
                    }
                }

                synchronized (seededDomains) { seededDomains.addAll(domains); }

                // Broadcast these as "known domains" immediately
                broadcastNewHosts(domains, true);

                // Kick off forward DNS on each seeded domain so we have IP→host mappings ready
                for (String d : domains) {
                    final String dom = d;
                    ioExec.submit(() -> {
                        try {
                            InetAddress[] addrs = InetAddress.getAllByName(dom);
                            for (InetAddress addr : addrs) {
                                String ip = addr.getHostAddress();
                                dnsCache.put(ip, dom);
                                submittedIps.add(ip);
                            }
                        } catch (Exception ignored) {}
                    });
                }

            } catch (Exception e) {
                Log.w(TAG, "seedDomains failed: " + e.getMessage());
            }
        });
    }

    /** Converts a package name to a likely root domain.
     *  com.paypal.android    → paypal.com
     *  com.google.android.gm → google.com
     *  net.netflix.mediaclient → netflix.net  (tries .com first)
     */
    private static String packageToRootDomain(String pkg) {
        if (pkg == null || pkg.isEmpty()) return null;
        String[] parts = pkg.split("\\.");
        if (parts.length < 2) return null;
        // Strip common prefixes
        String tld  = parts[0]; // com / net / org / io / de / …
        String name = parts[1]; // company name
        // Always try .com first as it's most common
        if ("com".equals(tld) || "org".equals(tld) || "io".equals(tld)) {
            return name + ".com";
        }
        return name + "." + tld;
    }

    // ── Main poll loop ────────────────────────────────────────────────────────

    private void poll() {
        // 1. TrafficStats byte counters
        long tx, rx;
        if (targetUid == -1) {
            tx = TrafficStats.getTotalTxBytes();
            rx = TrafficStats.getTotalRxBytes();
        } else {
            tx = TrafficStats.getUidTxBytes(targetUid);
            rx = TrafficStats.getUidRxBytes(targetUid);
        }

        long txRate = 0, rxRate = 0;
        if (lastTx != TrafficStats.UNSUPPORTED && tx != TrafficStats.UNSUPPORTED
                && lastTx >= 0 && tx >= 0) {
            txRate = Math.max(0, tx - lastTx);
            rxRate = Math.max(0, rx - lastRx);
        }
        lastTx = tx;
        lastRx = rx;

        // 2. Read /proc/net/tcp for ALL established connections (no UID filter —
        //    modern Android restricts per-UID reads but usually allows reading all rows)
        List<String> activeIps = readAllEstablishedIps();
        Log.d(TAG, "poll: activeIps=" + activeIps.size() + " txRate=" + txRate + " rxRate=" + rxRate);

        // 3. Submit reverse-DNS jobs for any new IPs
        for (String ip : activeIps) {
            if (!submittedIps.contains(ip)) {
                submittedIps.add(ip);
                final String toResolve = ip;
                ioExec.submit(() -> {
                    try {
                        // getHostName() does a PTR lookup
                        String host = InetAddress.getByName(toResolve).getHostName();
                        String resolved = host.equals(toResolve) ? toResolve : host;
                        dnsCache.put(toResolve, resolved);
                        Log.d(TAG, "PTR " + toResolve + " → " + resolved);
                        // Broadcast this host immediately once resolved
                        List<String> single = new ArrayList<>();
                        single.add(resolved);
                        broadcastNewHosts(single, false);
                    } catch (Exception e) {
                        dnsCache.put(toResolve, toResolve);
                    }
                });
            }
        }

        // 4. Also broadcast any IPs already in cache that haven't been sent yet
        List<String> resolved = new ArrayList<>();
        for (String ip : activeIps) {
            String host = dnsCache.get(ip);
            if (host != null) resolved.add(host);
            else              resolved.add(ip);  // send raw IP while waiting for PTR
        }
        broadcastNewHosts(resolved, false);

        // 5. Always send a stats-only broadcast (even if no new hosts) so the byte counters update
        sendStatsBroadcast(tx, rx, txRate, rxRate, null);
    }

    /** Send ONLY the byte-counter stats (no host data) */
    private void sendStatsBroadcast(long tx, long rx, long txRate, long rxRate, String hosts) {
        Intent ev = new Intent(EVENT_ACTION);
        ev.setPackage(getPackageName());   // explicit package → RECEIVER_NOT_EXPORTED works
        ev.putExtra(EXTRA_TX_BYTES,  tx == TrafficStats.UNSUPPORTED ? -1L : tx);
        ev.putExtra(EXTRA_RX_BYTES,  rx == TrafficStats.UNSUPPORTED ? -1L : rx);
        ev.putExtra(EXTRA_TX_RATE,   txRate);
        ev.putExtra(EXTRA_RX_RATE,   rxRate);
        ev.putExtra(EXTRA_HOSTS,     hosts != null ? hosts : "");
        ev.putExtra(EXTRA_TIMESTAMP, System.currentTimeMillis());
        sendBroadcast(ev);
    }

    /** Broadcast only hosts that haven't been sent before */
    private void broadcastNewHosts(List<String> hosts, boolean isSeeded) {
        List<String> newOnes = new ArrayList<>();
        for (String h : hosts) {
            if (h == null || h.isEmpty()) continue;
            if (!broadcastHosts.contains(h)) {
                broadcastHosts.add(h);
                newOnes.add(h);
            }
        }
        if (newOnes.isEmpty()) return;

        StringBuilder sb = new StringBuilder();
        for (String h : newOnes) sb.append(h).append("\n");

        Intent ev = new Intent(EVENT_ACTION);
        ev.setPackage(getPackageName());
        ev.putExtra(EXTRA_TX_BYTES,  lastTx == TrafficStats.UNSUPPORTED ? -1L : lastTx);
        ev.putExtra(EXTRA_RX_BYTES,  lastRx == TrafficStats.UNSUPPORTED ? -1L : lastRx);
        ev.putExtra(EXTRA_TX_RATE,   0L);
        ev.putExtra(EXTRA_RX_RATE,   0L);
        ev.putExtra(EXTRA_HOSTS,     sb.toString().trim());
        ev.putExtra(EXTRA_TIMESTAMP, System.currentTimeMillis());
        sendBroadcast(ev);
    }

    // ── /proc/net/tcp reader ─────────────────────────────────────────────────
    // Read ALL established connections without UID filtering.
    // Android 10+ restricts per-UID cross-process reads, but reading all rows
    // (then filtering by UID if possible) is still permitted on most devices.

    private List<String> readAllEstablishedIps() {
        List<String> ips = new ArrayList<>();
        parseProcNetFile("/proc/net/tcp",  false, ips);
        parseProcNetFile("/proc/net/tcp6", true,  ips);
        // Remove duplicates while preserving order
        return new ArrayList<>(new LinkedHashSet<>(ips));
    }

    private void parseProcNetFile(String path, boolean isIpv6, List<String> out) {
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String line;
            boolean first = true;
            while ((line = br.readLine()) != null) {
                if (first) { first = false; continue; } // skip header
                String[] parts = line.trim().split("\\s+");
                if (parts.length < 4) continue;

                // State: 01 = ESTABLISHED, 06 = TIME_WAIT, 08 = CLOSE_WAIT
                String state = parts[3];
                if (!"01".equals(state) && !"06".equals(state) && !"08".equals(state)) continue;

                // If we have UID info (col 7) and are filtering a specific app, apply it
                if (targetUid != -1 && parts.length >= 8) {
                    try {
                        int uid = Integer.parseInt(parts[7]);
                        if (uid != targetUid) continue;
                    } catch (Exception ignored) {
                        // UID column missing or unreadable — include the row anyway
                    }
                }

                // Remote address is column 2: hex_ip:hex_port
                String remAddr = parts[2];
                String ip = hexToIp(remAddr, isIpv6);
                if (ip == null || ip.isEmpty()) continue;
                // Filter loopback & link-local but KEEP RFC1918 (mobile networks use them)
                if (ip.startsWith("0.0.0.0") || ip.startsWith("127.") || ip.equals("::1")) continue;
                // Filter remote port 0 (means no connection)
                String portHex = remAddr.contains(":") ? remAddr.substring(remAddr.indexOf(':') + 1) : "0";
                int port = Integer.parseInt(portHex, 16);
                if (port == 0) continue;

                out.add(ip);
            }
        } catch (Exception e) {
            Log.w(TAG, "parseProcNet " + path + ": " + e.getMessage());
        }
    }

    private static String hexToIp(String hexAddr, boolean isIpv6) {
        try {
            int colon = hexAddr.indexOf(':');
            if (colon < 0) return null;
            String hexIp = hexAddr.substring(0, colon);
            if (!isIpv6) {
                // IPv4 in /proc/net/tcp is little-endian 32-bit hex
                long val = Long.parseLong(hexIp, 16);
                return ((val      ) & 0xFF) + "." +
                       ((val >>  8) & 0xFF) + "." +
                       ((val >> 16) & 0xFF) + "." +
                       ((val >> 24) & 0xFF);
            } else {
                if (hexIp.length() < 32) return null;
                byte[] b = new byte[16];
                for (int w = 0; w < 4; w++) {
                    long word = Long.parseLong(hexIp.substring(w * 8, w * 8 + 8), 16);
                    b[w*4]   = (byte)( word        & 0xFF);
                    b[w*4+1] = (byte)((word >>  8) & 0xFF);
                    b[w*4+2] = (byte)((word >> 16) & 0xFF);
                    b[w*4+3] = (byte)((word >> 24) & 0xFF);
                }
                return InetAddress.getByAddress(b).getHostAddress();
            }
        } catch (Exception e) { return null; }
    }

    // ── HTTP helper ───────────────────────────────────────────────────────────

    private static String postJson(String urlStr, String body) {
        try {
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(20000);
            try (OutputStream os = conn.getOutputStream()) {
                os.write(body.getBytes("UTF-8"));
            }
            int code = conn.getResponseCode();
            BufferedReader br = new BufferedReader(new InputStreamReader(
                    code >= 200 && code < 300 ? conn.getInputStream() : conn.getErrorStream()));
            StringBuilder sb = new StringBuilder(); String line;
            while ((line = br.readLine()) != null) sb.append(line);
            br.close();
            return sb.toString();
        } catch (Exception e) { return null; }
    }

    // ── Lifecycle ─────────────────────────────────────────────────────────────

    @Override
    public void onDestroy() {
        running = false;
        handler.removeCallbacks(pollRunnable);
        ioExec.shutdownNow();
        super.onDestroy();
    }

    @Override public IBinder onBind(Intent intent) { return null; }

    private void createChannel() {
        NotificationManager nm = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        NotificationChannel ch = new NotificationChannel(
                CHANNEL_ID, "NetWatch Monitor", NotificationManager.IMPORTANCE_LOW);
        nm.createNotificationChannel(ch);
    }

    private Notification buildNotification() {
        String text = targetName.isEmpty() ? "Monitoring device traffic" : "Monitoring: " + targetName;
        return new Notification.Builder(this, CHANNEL_ID)
                .setContentTitle("🔍 NetWatch Active")
                .setContentText(text)
                .setSmallIcon(android.R.drawable.ic_menu_compass)
                .build();
    }
}
