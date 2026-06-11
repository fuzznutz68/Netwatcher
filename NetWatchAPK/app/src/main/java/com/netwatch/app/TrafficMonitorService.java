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

import java.io.BufferedReader;
import java.io.FileReader;
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class TrafficMonitorService extends Service {

    public static final String ACTION_STOP     = "com.netwatch.app.STOP_MONITOR";
    public static final String EVENT_ACTION    = "com.netwatch.app.TRAFFIC_EVENT";

    // Extras sent in EVENT_ACTION broadcasts
    public static final String EXTRA_TX_BYTES  = "tx_bytes";
    public static final String EXTRA_RX_BYTES  = "rx_bytes";
    public static final String EXTRA_TX_RATE   = "tx_rate";   // bytes/sec since last tick
    public static final String EXTRA_RX_RATE   = "rx_rate";
    public static final String EXTRA_HOSTS     = "hosts";     // newline-separated resolved hosts
    public static final String EXTRA_TIMESTAMP = "timestamp";

    private static final String CHANNEL_ID = "netwatch_monitor";
    private static final int    NOTIF_ID   = 43;
    private static final long   POLL_MS    = 1000L;

    private int     targetUid  = -1;
    private String  targetName = "";
    private boolean running    = false;

    private long lastTx = TrafficStats.UNSUPPORTED;
    private long lastRx = TrafficStats.UNSUPPORTED;

    private final Handler          handler     = new Handler(Looper.getMainLooper());
    private final ExecutorService  dnsExec     = Executors.newFixedThreadPool(4);
    private final ConcurrentHashMap<String, String> dnsCache = new ConcurrentHashMap<>();

    // Track which IPs we've already resolved so we don't redo them
    private final Set<String> seenIps = Collections.synchronizedSet(new HashSet<>());

    private final Runnable pollRunnable = new Runnable() {
        @Override
        public void run() {
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
            targetName = intent.getStringExtra("target_name");
            if (targetName == null) targetName = "";
        }

        createChannel();
        Notification n = buildNotification();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(NOTIF_ID, n, ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC);
        } else {
            startForeground(NOTIF_ID, n);
        }

        lastTx  = TrafficStats.UNSUPPORTED;
        lastRx  = TrafficStats.UNSUPPORTED;
        running = true;
        handler.post(pollRunnable);
        return START_STICKY;
    }

    private void poll() {
        long tx, rx;
        if (targetUid == -1) {
            // Whole device
            tx = TrafficStats.getTotalTxBytes();
            rx = TrafficStats.getTotalRxBytes();
        } else {
            tx = TrafficStats.getUidTxBytes(targetUid);
            rx = TrafficStats.getUidRxBytes(targetUid);
        }

        long txRate = 0, rxRate = 0;
        if (lastTx != TrafficStats.UNSUPPORTED && tx != TrafficStats.UNSUPPORTED) {
            txRate = Math.max(0, tx - lastTx);
            rxRate = Math.max(0, rx - lastRx);
        }
        lastTx = tx;
        lastRx = rx;

        // Read active connections from /proc/net/tcp (and tcp6) for this UID
        List<String> activeIps = readProcNetIps();

        // Trigger async DNS for new IPs
        for (String ip : activeIps) {
            if (!seenIps.contains(ip)) {
                seenIps.add(ip);
                final String toResolve = ip;
                dnsExec.submit(() -> {
                    try {
                        String host = InetAddress.getByName(toResolve).getHostName();
                        dnsCache.put(toResolve, host.equals(toResolve) ? toResolve : host);
                    } catch (Exception e) {
                        dnsCache.put(toResolve, toResolve);
                    }
                });
            }
        }

        // Build resolved host list from cache
        Set<String> hostSet = new HashSet<>();
        for (String ip : activeIps) {
            String host = dnsCache.get(ip);
            hostSet.add(host != null ? host : ip);
        }
        StringBuilder hostsSb = new StringBuilder();
        for (String h : hostSet) { hostsSb.append(h).append("\n"); }

        // Broadcast to UI
        Intent ev = new Intent(EVENT_ACTION);
        ev.putExtra(EXTRA_TX_BYTES,  tx == TrafficStats.UNSUPPORTED ? -1L : tx);
        ev.putExtra(EXTRA_RX_BYTES,  rx == TrafficStats.UNSUPPORTED ? -1L : rx);
        ev.putExtra(EXTRA_TX_RATE,   txRate);
        ev.putExtra(EXTRA_RX_RATE,   rxRate);
        ev.putExtra(EXTRA_HOSTS,     hostsSb.toString().trim());
        ev.putExtra(EXTRA_TIMESTAMP, System.currentTimeMillis());
        sendBroadcast(ev);
    }

    /**
     * Reads /proc/net/tcp and /proc/net/tcp6 and returns all remote IPs
     * associated with ESTABLISHED connections for targetUid (or all UIDs if -1).
     *
     * /proc/net/tcp columns (space-separated):
     *   sl  local_address  rem_address  st  tx_queue:rx_queue  tr:tm->when  retrnsmt  uid  timeout  inode ...
     *
     * Addresses are little-endian hex: AABBCCDD:PPPP
     */
    private List<String> readProcNetIps() {
        List<String> ips = new ArrayList<>();
        parseProcNetFile("/proc/net/tcp",  false, ips);
        parseProcNetFile("/proc/net/tcp6", true,  ips);
        return ips;
    }

    private void parseProcNetFile(String path, boolean isIpv6, List<String> out) {
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String line;
            boolean first = true;
            while ((line = br.readLine()) != null) {
                if (first) { first = false; continue; } // skip header
                String[] parts = line.trim().split("\\s+");
                if (parts.length < 8) continue;

                // State 01 = ESTABLISHED
                String state = parts[3];
                if (!"01".equals(state)) continue;

                // UID is column index 7
                int uid = -1;
                try { uid = Integer.parseInt(parts[7]); } catch (Exception e) { continue; }
                if (targetUid != -1 && uid != targetUid) continue;

                // Remote address is column 2:  hex_ip:hex_port (little-endian for IPv4)
                String remAddr = parts[2];
                String ip = hexToIp(remAddr, isIpv6);
                if (ip != null && !ip.isEmpty()
                        && !ip.startsWith("0.0.0.0")
                        && !ip.startsWith("127.")
                        && !ip.startsWith("10.")
                        && !ip.startsWith("192.168.")
                        && !ip.equals("::")) {
                    out.add(ip);
                }
            }
        } catch (Exception ignored) {}
    }

    /** Convert little-endian hex IP from /proc/net/tcp to dotted-decimal string */
    private static String hexToIp(String hexAddr, boolean isIpv6) {
        try {
            int colon = hexAddr.indexOf(':');
            if (colon < 0) return null;
            String hexIp = hexAddr.substring(0, colon);
            if (!isIpv6) {
                // IPv4: 8 hex chars, little-endian 32-bit
                long val = Long.parseLong(hexIp, 16);
                return (val & 0xFF) + "." + ((val >> 8) & 0xFF) + "."
                     + ((val >> 16) & 0xFF) + "." + ((val >> 24) & 0xFF);
            } else {
                // IPv6: 32 hex chars, 4×little-endian 32-bit words
                if (hexIp.length() < 32) return null;
                byte[] b = new byte[16];
                for (int w = 0; w < 4; w++) {
                    long word = Long.parseLong(hexIp.substring(w * 8, w * 8 + 8), 16);
                    b[w*4]   = (byte)(word & 0xFF);
                    b[w*4+1] = (byte)((word >> 8) & 0xFF);
                    b[w*4+2] = (byte)((word >> 16) & 0xFF);
                    b[w*4+3] = (byte)((word >> 24) & 0xFF);
                }
                return InetAddress.getByAddress(b).getHostAddress();
            }
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public void onDestroy() {
        running = false;
        handler.removeCallbacks(pollRunnable);
        dnsExec.shutdownNow();
        super.onDestroy();
    }

    @Override
    public IBinder onBind(Intent intent) { return null; }

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
