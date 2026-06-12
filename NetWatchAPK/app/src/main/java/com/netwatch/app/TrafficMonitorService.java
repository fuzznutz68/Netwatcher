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
    public static final String EXTRA_HOSTS     = "hosts";       // newline-separated "flag host (city, country) [org]"
    public static final String EXTRA_TIMESTAMP = "timestamp";

    private static final String CHANNEL_ID      = "netwatch_monitor";
    private static final int    NOTIF_ID        = 43;
    private static final long   POLL_MS         = 1000L;
    private static final String DOMAIN_INTEL_URL = "https://superagent-cfb25b3e.base44.app/functions/domainIntel";
    private static final String GEO_IP_URL       = "https://superagent-cfb25b3e.base44.app/functions/geoIp";

    private int     targetUid  = -1;
    private String  targetPkg  = "";
    private String  targetName = "";
    private boolean running    = false;

    private long lastTx = TrafficStats.UNSUPPORTED;
    private long lastRx = TrafficStats.UNSUPPORTED;

    private final Handler         handler = new Handler(Looper.getMainLooper());
    private final ExecutorService ioExec  = Executors.newFixedThreadPool(6);

    // ip → hostname
    private final ConcurrentHashMap<String, String>  dnsCache    = new ConcurrentHashMap<>();
    // ip → GeoInfo string e.g. "🇺🇸 Ashburn, US · Google LLC"
    private final ConcurrentHashMap<String, String>  geoCache    = new ConcurrentHashMap<>();
    // IPs already submitted for PTR lookup
    private final Set<String> submittedIps    = Collections.synchronizedSet(new HashSet<>());
    // IPs already submitted for Geo lookup (batch pending)
    private final Set<String> geoSubmitted    = Collections.synchronizedSet(new HashSet<>());
    // Full host lines already broadcast to avoid duplicates
    private final Set<String> broadcastHosts  = Collections.synchronizedSet(new HashSet<>());

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

        dnsCache.clear(); geoCache.clear();
        submittedIps.clear(); geoSubmitted.clear(); broadcastHosts.clear();
        lastTx = TrafficStats.UNSUPPORTED;
        lastRx = TrafficStats.UNSUPPORTED;
        running = true;

        if (!targetPkg.isEmpty()) seedDomainsFromBackend(targetPkg);
        handler.post(pollRunnable);
        return START_STICKY;
    }

    // ── Domain seeding ────────────────────────────────────────────────────────

    private void seedDomainsFromBackend(String pkg) {
        ioExec.submit(() -> {
            String rootDomain = packageToRootDomain(pkg);
            if (rootDomain == null) return;
            try {
                String json = postJson(DOMAIN_INTEL_URL, "{\"domain\":\"" + rootDomain + "\"}");
                if (json == null) return;
                JSONObject obj = new JSONObject(json);
                List<String> domains = new ArrayList<>();
                domains.add(rootDomain);
                JSONArray subs = obj.optJSONArray("subdomains");
                if (subs != null) {
                    for (int i = 0; i < subs.length(); i++) {
                        JSONObject sub = subs.optJSONObject(i);
                        if (sub != null) { String name = sub.optString("name",""); if (!name.isEmpty()) domains.add(name); }
                    }
                }
                // Forward-DNS each seeded domain to populate ip→host map
                List<String> seedIps = new ArrayList<>();
                for (String d : domains) {
                    final String dom = d;
                    ioExec.submit(() -> {
                        try {
                            InetAddress[] addrs = InetAddress.getAllByName(dom);
                            for (InetAddress addr : addrs) {
                                String ip = addr.getHostAddress();
                                dnsCache.put(ip, dom);
                                submittedIps.add(ip);
                                synchronized (seedIps) { seedIps.add(ip); }
                            }
                        } catch (Exception ignored) {}
                    });
                }
                // Broadcast seeded domain names immediately (without geo yet)
                broadcastNewHosts(domains);
            } catch (Exception e) { Log.w(TAG, "seedDomains: " + e.getMessage()); }
        });
    }

    private static String packageToRootDomain(String pkg) {
        if (pkg == null || pkg.isEmpty()) return null;
        String[] parts = pkg.split("\\.");
        if (parts.length < 2) return null;
        String tld = parts[0]; String name = parts[1];
        if ("com".equals(tld) || "org".equals(tld) || "io".equals(tld)) return name + ".com";
        return name + "." + tld;
    }

    // ── Poll loop ─────────────────────────────────────────────────────────────

    private void poll() {
        // TrafficStats — prefer per-UID, fall back to device total for whole-device mode
        long tx, rx;
        if (targetUid == -1) {
            tx = TrafficStats.getTotalTxBytes();
            rx = TrafficStats.getTotalRxBytes();
        } else {
            tx = TrafficStats.getUidTxBytes(targetUid);
            rx = TrafficStats.getUidRxBytes(targetUid);
            // Some devices return UNSUPPORTED for UID stats — fall back gracefully
            if (tx == TrafficStats.UNSUPPORTED || tx < 0) {
                tx = TrafficStats.getTotalTxBytes();
                rx = TrafficStats.getTotalRxBytes();
            }
        }
        // Sanitize
        if (tx < 0) tx = TrafficStats.UNSUPPORTED;
        if (rx < 0) rx = TrafficStats.UNSUPPORTED;

        long txRate = 0, rxRate = 0;
        if (lastTx != TrafficStats.UNSUPPORTED && tx != TrafficStats.UNSUPPORTED && lastTx >= 0 && tx >= 0) {
            txRate = Math.max(0, tx - lastTx);
            rxRate = Math.max(0, rx - lastRx);
        }
        lastTx = tx; lastRx = rx;

        // Active IPs from /proc/net/tcp
        List<String> activeIps = readAllEstablishedIps();

        // Collect IPs needing geo lookup
        List<String> needGeo = new ArrayList<>();
        for (String ip : activeIps) {
            if (!geoSubmitted.contains(ip)) { needGeo.add(ip); geoSubmitted.add(ip); }
        }
        if (!needGeo.isEmpty()) fetchGeoInBackground(new ArrayList<>(needGeo));

        // PTR reverse DNS for new IPs
        for (String ip : activeIps) {
            if (!submittedIps.contains(ip)) {
                submittedIps.add(ip);
                final String toResolve = ip;
                ioExec.submit(() -> {
                    try {
                        String host = InetAddress.getByName(toResolve).getHostName();
                        String resolved = host.equals(toResolve) ? toResolve : host;
                        dnsCache.put(toResolve, resolved);
                        broadcastIpAsHost(toResolve);
                    } catch (Exception e) {
                        dnsCache.put(toResolve, toResolve);
                        broadcastIpAsHost(toResolve);
                    }
                });
            }
        }

        // Broadcast any cached IPs not yet sent
        for (String ip : activeIps) {
            if (dnsCache.containsKey(ip)) broadcastIpAsHost(ip);
        }

        // Stats-only broadcast so byte counters always update
        sendStatsBroadcast(tx, rx, txRate, rxRate, "");
    }

    /** Broadcast a single IP using the best available info (host + geo) */
    private void broadcastIpAsHost(String ip) {
        String host = dnsCache.getOrDefault(ip, ip);
        String geo  = geoCache.get(ip);  // may be null if not yet resolved
        String line = buildHostLine(host, geo);
        List<String> single = new ArrayList<>();
        single.add(line);
        broadcastNewHosts(single);
    }

    /** Assembles the display line: "🇺🇸 api.paypal.com · Ashburn, US · PayPal Inc" */
    private static String buildHostLine(String host, String geo) {
        if (geo == null || geo.isEmpty()) return host;
        return geo + "  " + host;
    }

    private void fetchGeoInBackground(final List<String> ips) {
        ioExec.submit(() -> {
            try {
                StringBuilder sb = new StringBuilder("{\"ips\":[");
                for (int i = 0; i < ips.size(); i++) {
                    if (i > 0) sb.append(",");
                    sb.append("\"").append(ips.get(i)).append("\"");
                }
                sb.append("]}");
                String resp = postJson(GEO_IP_URL, sb.toString());
                if (resp == null) return;
                JSONObject obj = new JSONObject(resp);
                JSONObject results = obj.optJSONObject("results");
                if (results == null) return;
                for (String ip : ips) {
                    JSONObject info = results.optJSONObject(ip);
                    if (info == null) continue;
                    String flag    = info.optString("flag", "🌐");
                    String city    = info.optString("city", "");
                    String country = info.optString("countryCode", "");
                    String org     = info.optString("org", "");
                    // Shorten org: strip leading "AS12345 " prefix if present
                    org = org.replaceAll("^AS\\d+\\s+", "");
                    // Build compact geo string: "🇺🇸 Ashburn US · Google LLC"
                    StringBuilder geo = new StringBuilder(flag).append(" ");
                    if (!city.isEmpty()) geo.append(city).append(", ");
                    geo.append(country);
                    if (!org.isEmpty()) geo.append(" · ").append(org);
                    geoCache.put(ip, geo.toString());
                    // Re-broadcast the updated line (with geo now filled in)
                    broadcastIpAsHost(ip);
                }
            } catch (Exception e) { Log.w(TAG, "fetchGeo: " + e.getMessage()); }
        });
    }

    /** Broadcast only host lines not yet sent */
    private void broadcastNewHosts(List<String> lines) {
        List<String> newOnes = new ArrayList<>();
        for (String h : lines) {
            if (h == null || h.isEmpty()) continue;
            // Use the host part (before any geo prefix) as dedup key
            String key = h.trim();
            if (!broadcastHosts.contains(key)) {
                broadcastHosts.add(key);
                newOnes.add(key);
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

    private void sendStatsBroadcast(long tx, long rx, long txRate, long rxRate, String hosts) {
        Intent ev = new Intent(EVENT_ACTION);
        ev.setPackage(getPackageName());
        ev.putExtra(EXTRA_TX_BYTES,  tx == TrafficStats.UNSUPPORTED ? -1L : tx);
        ev.putExtra(EXTRA_RX_BYTES,  rx == TrafficStats.UNSUPPORTED ? -1L : rx);
        ev.putExtra(EXTRA_TX_RATE,   txRate);
        ev.putExtra(EXTRA_RX_RATE,   rxRate);
        ev.putExtra(EXTRA_HOSTS,     hosts != null ? hosts : "");
        ev.putExtra(EXTRA_TIMESTAMP, System.currentTimeMillis());
        sendBroadcast(ev);
    }

    // ── /proc/net/tcp ─────────────────────────────────────────────────────────

    private List<String> readAllEstablishedIps() {
        List<String> ips = new ArrayList<>();
        parseProcNetFile("/proc/net/tcp",  false, ips);
        parseProcNetFile("/proc/net/tcp6", true,  ips);
        return new ArrayList<>(new LinkedHashSet<>(ips));
    }

    private void parseProcNetFile(String path, boolean isIpv6, List<String> out) {
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String line; boolean first = true;
            while ((line = br.readLine()) != null) {
                if (first) { first = false; continue; }
                String[] parts = line.trim().split("\\s+");
                if (parts.length < 4) continue;
                String state = parts[3];
                if (!"01".equals(state) && !"06".equals(state) && !"08".equals(state)) continue;
                if (targetUid != -1 && parts.length >= 8) {
                    try { int uid = Integer.parseInt(parts[7]); if (uid != targetUid) continue; }
                    catch (Exception ignored) {}
                }
                String remAddr = parts[2];
                String ip = hexToIp(remAddr, isIpv6);
                if (ip == null || ip.isEmpty()) continue;
                if (ip.startsWith("0.0.0.0") || ip.startsWith("127.") || ip.equals("::1")) continue;
                String portHex = remAddr.contains(":") ? remAddr.substring(remAddr.indexOf(':') + 1) : "0";
                try { if (Integer.parseInt(portHex, 16) == 0) continue; } catch (Exception ignored) {}
                out.add(ip);
            }
        } catch (Exception e) { Log.w(TAG, "parseProcNet " + path + ": " + e.getMessage()); }
    }

    private static String hexToIp(String hexAddr, boolean isIpv6) {
        try {
            int colon = hexAddr.indexOf(':');
            if (colon < 0) return null;
            String hexIp = hexAddr.substring(0, colon);
            if (!isIpv6) {
                long val = Long.parseLong(hexIp, 16);
                return ((val)&0xFF)+"."+((val>>8)&0xFF)+"."+((val>>16)&0xFF)+"."+((val>>24)&0xFF);
            } else {
                if (hexIp.length() < 32) return null;
                byte[] b = new byte[16];
                for (int w = 0; w < 4; w++) {
                    long word = Long.parseLong(hexIp.substring(w*8, w*8+8), 16);
                    b[w*4]=(byte)(word&0xFF); b[w*4+1]=(byte)((word>>8)&0xFF);
                    b[w*4+2]=(byte)((word>>16)&0xFF); b[w*4+3]=(byte)((word>>24)&0xFF);
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
            conn.setDoOutput(true); conn.setConnectTimeout(10000); conn.setReadTimeout(20000);
            try (OutputStream os = conn.getOutputStream()) { os.write(body.getBytes("UTF-8")); }
            int code = conn.getResponseCode();
            BufferedReader br = new BufferedReader(new InputStreamReader(
                    code>=200&&code<300 ? conn.getInputStream() : conn.getErrorStream()));
            StringBuilder sb = new StringBuilder(); String line;
            while ((line=br.readLine())!=null) sb.append(line);
            br.close(); return sb.toString();
        } catch (Exception e) { return null; }
    }

    // ── Lifecycle ─────────────────────────────────────────────────────────────

    @Override public void onDestroy() {
        running = false; handler.removeCallbacks(pollRunnable); ioExec.shutdownNow(); super.onDestroy();
    }
    @Override public IBinder onBind(Intent intent) { return null; }

    private void createChannel() {
        NotificationManager nm = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        NotificationChannel ch = new NotificationChannel(CHANNEL_ID, "NetWatch Monitor", NotificationManager.IMPORTANCE_LOW);
        nm.createNotificationChannel(ch);
    }

    private Notification buildNotification() {
        String text = targetName.isEmpty() ? "Monitoring device traffic" : "Monitoring: " + targetName;
        return new Notification.Builder(this, CHANNEL_ID)
                .setContentTitle("🔍 NetWatch Active").setContentText(text)
                .setSmallIcon(android.R.drawable.ic_menu_compass).build();
    }
}
