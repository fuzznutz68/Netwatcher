package com.netwatch.app;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.IBinder;
import android.app.Service;
import android.util.Log;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;
import java.io.BufferedReader;
import java.io.FileReader;
import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class DeviceMonitorService extends Service {

    public static final String ACTION_STOP    = "com.netwatch.app.STOP_DEVICE_MON";
    public static final String TRAFFIC_ACTION = "com.netwatch.app.DEVICE_TRAFFIC";

    private static final String TAG        = "NetWatchDev";
    private static final String CHANNEL_ID = "netwatch_dev";
    private static final int    NOTIF_ID   = 43;

    // How often to poll /proc/net (ms)
    private static final long   POLL_INTERVAL_MS = 1000;
    // How long to keep a seen entry before re-reporting (ms)
    private static final long   SEEN_TTL_MS      = 30_000;

    private ScheduledExecutorService scheduler;
    private ScheduledExecutorService dnsExecutor;
    private PackageManager           pm;

    // key = "ip:port", value = last-seen timestamp
    private final ConcurrentHashMap<String, Long>    seen     = new ConcurrentHashMap<>();
    // key = ip, value = resolved hostname (or ip itself if unresolved)
    private final ConcurrentHashMap<String, String>  dnsCache = new ConcurrentHashMap<>();
    // key = uid, value = app label
    private final ConcurrentHashMap<Integer, String> uidCache = new ConcurrentHashMap<>();

    // ── Lifecycle ────────────────────────────────────────────────

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent != null && ACTION_STOP.equals(intent.getAction())) {
            stopSelf();
            return START_NOT_STICKY;
        }
        pm = getPackageManager();
        createNotificationChannel();
        startForeground(NOTIF_ID, buildNotification());

        scheduler   = Executors.newSingleThreadScheduledExecutor();
        dnsExecutor = Executors.newScheduledThreadPool(4);

        scheduler.scheduleAtFixedRate(this::poll, 0, POLL_INTERVAL_MS, TimeUnit.MILLISECONDS);
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        if (scheduler   != null) scheduler.shutdownNow();
        if (dnsExecutor != null) dnsExecutor.shutdownNow();
        super.onDestroy();
    }

    @Override
    public IBinder onBind(Intent intent) { return null; }

    // ── Poll /proc/net ────────────────────────────────────────────

    private void poll() {
        try {
            long now = System.currentTimeMillis();

            // Expire old entries so connections that closed can re-appear later
            Iterator<Map.Entry<String, Long>> it = seen.entrySet().iterator();
            while (it.hasNext()) {
                if (now - it.next().getValue() > SEEN_TTL_MS) it.remove();
            }

            parseProcNetFile("/proc/net/tcp",  false, false, now);
            parseProcNetFile("/proc/net/tcp6", false, true,  now);
            parseProcNetFile("/proc/net/udp",  true,  false, now);
            parseProcNetFile("/proc/net/udp6", true,  true,  now);
        } catch (Exception e) {
            Log.d(TAG, "Poll error: " + e.getMessage());
        }
    }

    /**
     * Parse a /proc/net/{tcp,tcp6,udp,udp6} file.
     * Each data line (skip header) has fields separated by whitespace:
     *   [0] sl  [1] local_addr  [2] rem_addr  [3] state  ... [7] uid
     * local_addr and rem_addr are "HEXIP:HEXPORT" (little-endian for IPv4).
     * State 0A = TIME_WAIT, 07 = CLOSE, 09 = CLOSE_WAIT (skip for TCP).
     */
    private void parseProcNetFile(String path, boolean isUdp, boolean isIPv6, long now) {
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String line;
            boolean firstLine = true;
            while ((line = br.readLine()) != null) {
                if (firstLine) { firstLine = false; continue; } // skip header
                line = line.trim();
                if (line.isEmpty()) continue;

                String[] parts = line.split("\\s+");
                if (parts.length < 8) continue;

                String remAddr = parts[2];  // remote address field
                String state   = parts[3];  // connection state (hex)

                // Parse UID (field index 7)
                int uid = -1;
                try { uid = Integer.parseInt(parts[7]); } catch (NumberFormatException ignored) {}

                // Filter TCP states: skip TIME_WAIT(0A), CLOSE(07), CLOSE_WAIT(09)
                if (!isUdp) {
                    if ("0A".equalsIgnoreCase(state) ||
                        "07".equalsIgnoreCase(state) ||
                        "09".equalsIgnoreCase(state)) continue;
                }

                // Split "HEXIP:HEXPORT"
                int colonIdx = remAddr.indexOf(':');
                if (colonIdx < 0) continue;
                String hexIp   = remAddr.substring(0, colonIdx);
                String hexPort = remAddr.substring(colonIdx + 1);

                int port;
                try { port = Integer.parseInt(hexPort, 16); } catch (NumberFormatException e) { continue; }
                if (port == 0) continue;

                String ip = isIPv6 ? hexToIPv6(hexIp) : hexToIPv4(hexIp);
                if (ip == null) continue;

                // Skip loopback and unspecified
                if (ip.equals("0.0.0.0") || ip.equals("127.0.0.1")
                        || ip.equals("::1") || ip.equals("::")
                        || ip.startsWith("::") || ip.equals("0:0:0:0:0:0:0:0")) continue;

                String key = ip + ":" + port;
                Long lastSeen = seen.get(key);
                if (lastSeen != null) {
                    seen.put(key, now); // refresh timestamp
                    continue;          // already reported
                }

                seen.put(key, now);
                String proto    = isUdp ? "UDP" : "TCP";
                String appLabel = uid >= 0 ? getAppLabel(uid) : "";
                resolveAndEmit(ip, port, proto, appLabel);
            }
        } catch (Exception e) {
            // File may not exist on all devices (e.g. tcp6)
        }
    }

    // ── DNS resolution ────────────────────────────────────────────

    private void resolveAndEmit(String ip, int port, String proto, String appLabel) {
        String cached = dnsCache.get(ip);
        if (cached != null) {
            String host = cached.equals(ip) ? "" : cached;
            emit(ip, host, port, proto, appLabel);
        } else {
            emit(ip, "", port, proto, appLabel);
            final String ipCopy = ip;
            dnsExecutor.submit(() -> {
                try {
                    String host = InetAddress.getByName(ipCopy).getHostName();
                    if (!host.equals(ipCopy)) {
                        dnsCache.put(ipCopy, host);
                        emit(ipCopy, host, port, proto, appLabel);
                    } else {
                        dnsCache.put(ipCopy, ipCopy);
                    }
                } catch (Exception ex) {
                    dnsCache.put(ipCopy, ipCopy);
                }
            });
        }
    }

    private void emit(String ip, String host, int port, String proto, String appLabel) {
        String ts = new SimpleDateFormat("HH:mm:ss", Locale.US).format(new Date());
        Intent i  = new Intent(TRAFFIC_ACTION);
        i.putExtra("protocol",  proto);
        i.putExtra("host",      host != null ? host : "");
        i.putExtra("ipPort",    ip + ":" + port);
        i.putExtra("app",       appLabel != null ? appLabel : "");
        i.putExtra("timestamp", ts);
        LocalBroadcastManager.getInstance(this).sendBroadcast(i);
        Log.d(TAG, proto + " " + (host != null && !host.isEmpty() ? host : ip) + ":" + port
              + (appLabel != null && !appLabel.isEmpty() ? " [" + appLabel + "]" : ""));
    }

    // ── Helpers ───────────────────────────────────────────────────

    /**
     * /proc/net/tcp stores IPv4 as 8 hex chars, little-endian (byte-reversed).
     * E.g. "0101A8C0" → bytes [01,01,A8,C0] → reversed → [C0,A8,01,01] → 192.168.1.1
     */
    private static String hexToIPv4(String hex) {
        if (hex == null || hex.length() != 8) return null;
        try {
            long val = Long.parseLong(hex, 16);
            int  v   = (int) val;
            return  (v        & 0xff) + "."
                  + ((v >> 8)  & 0xff) + "."
                  + ((v >> 16) & 0xff) + "."
                  + ((v >> 24) & 0xff);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    /**
     * /proc/net/tcp6 stores IPv6 as 32 hex chars, in 4 groups of 8 (little-endian per group).
     */
    private static String hexToIPv6(String hex) {
        if (hex == null || hex.length() != 32) return null;
        try {
            // Reorder bytes within each 32-bit word (little-endian)
            StringBuilder reordered = new StringBuilder();
            for (int word = 0; word < 4; word++) {
                int off = word * 8;
                for (int byteIdx = 3; byteIdx >= 0; byteIdx--) {
                    reordered.append(hex, off + byteIdx * 2, off + byteIdx * 2 + 2);
                }
            }
            // Build 16-byte array
            byte[] bytes = hexStringToBytes(reordered.toString());
            InetAddress addr = InetAddress.getByAddress(bytes);
            return addr.getHostAddress();
        } catch (Exception e) {
            return null;
        }
    }

    private static byte[] hexStringToBytes(String s) {
        int len = s.length();
        byte[] out = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            out[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
                                + Character.digit(s.charAt(i + 1), 16));
        }
        return out;
    }

    private String getAppLabel(int uid) {
        String cached = uidCache.get(uid);
        if (cached != null) return cached;
        try {
            String[] pkgs = pm.getPackagesForUid(uid);
            if (pkgs != null && pkgs.length > 0) {
                ApplicationInfo ai = pm.getApplicationInfo(pkgs[0], 0);
                String label = pm.getApplicationLabel(ai).toString();
                uidCache.put(uid, label);
                return label;
            }
        } catch (Exception ignored) {}
        uidCache.put(uid, "");
        return "";
    }

    // ── Notification ─────────────────────────────────────────────

    private void createNotificationChannel() {
        NotificationChannel ch = new NotificationChannel(
            CHANNEL_ID, "NetWatch Device Monitor", NotificationManager.IMPORTANCE_LOW);
        ((NotificationManager) getSystemService(NOTIFICATION_SERVICE)).createNotificationChannel(ch);
    }

    private Notification buildNotification() {
        return new Notification.Builder(this, CHANNEL_ID)
            .setContentTitle("📡 NetWatch Device Monitor")
            .setContentText("Monitoring all device connections")
            .setSmallIcon(android.R.drawable.ic_menu_compass)
            .build();
    }
}
