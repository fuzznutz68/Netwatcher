package com.netwatch.app;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Intent;
import android.content.pm.ServiceInfo;
import android.net.VpnService;
import android.os.Build;
import android.os.ParcelFileDescriptor;
import android.util.Log;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.InetAddress;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class NetWatchVpnService extends VpnService {

    public static final String TRAFFIC_ACTION = "com.netwatch.app.TRAFFIC";
    public static final String ACTION_STOP    = "com.netwatch.app.STOP_VPN";
    private static final String TAG           = "NetWatch";
    private static final String CHANNEL_ID    = "netwatch_vpn";
    private static final int    NOTIF_ID      = 42;

    private ParcelFileDescriptor vpnInterface;
    private volatile boolean     running = false;
    private String               targetDomain = "";

    // Cache: IP → hostname (reverse DNS, non-blocking)
    private final ConcurrentHashMap<String, String> dnsCache = new ConcurrentHashMap<>();
    // Deduplicate: only broadcast each unique dst IP+port once per second
    private final LinkedHashMap<String, Long> recentKeys = new LinkedHashMap<String, Long>() {
        protected boolean removeEldestEntry(Map.Entry<String, Long> e) {
            return size() > 500;
        }
    };

    private ExecutorService executor;
    private ExecutorService dnsExecutor;

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent != null && ACTION_STOP.equals(intent.getAction())) {
            stopSelf();
            return START_NOT_STICKY;
        }
        if (intent != null) {
            targetDomain = intent.getStringExtra("target_domain");
            if (targetDomain == null) targetDomain = "";
            targetDomain = targetDomain.toLowerCase().trim();
        }

        createNotificationChannel();
        Notification notif = buildNotification();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(NOTIF_ID, notif, ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC);
        } else {
            startForeground(NOTIF_ID, notif);
        }

        dnsExecutor = Executors.newFixedThreadPool(4);
        executor    = Executors.newSingleThreadExecutor();
        executor.execute(this::runVpnLoop);
        return START_STICKY;
    }

    private void runVpnLoop() {
        try {
            // Build VPN interface — route ALL traffic through us
            Builder builder = new Builder();
            builder.setMtu(1500);
            builder.addAddress("10.99.0.1", 24);
            builder.addRoute("0.0.0.0", 0);          // capture all IPv4
            builder.addDnsServer("8.8.8.8");
            builder.addDnsServer("1.1.1.1");
            builder.setSession("NetWatch");
            // Exclude ourselves so we don't loop our own network calls
            builder.addDisallowedApplication(getPackageName());

            vpnInterface = builder.establish();
            if (vpnInterface == null) {
                Log.e(TAG, "VPN establish() returned null — permission not granted?");
                return;
            }
            Log.d(TAG, "VPN tunnel established, monitoring: " + targetDomain);

            running = true;
            FileInputStream in  = new FileInputStream(vpnInterface.getFileDescriptor());
            FileOutputStream out = new FileOutputStream(vpnInterface.getFileDescriptor());
            byte[] buf = new byte[32767];

            while (running) {
                int len = in.read(buf);
                if (len <= 0) {
                    Thread.sleep(5);
                    continue;
                }
                // Forward packet back through VPN so real internet still works
                out.write(buf, 0, len);
                // Parse asynchronously so we don't slow down forwarding
                final byte[] pkt = new byte[len];
                System.arraycopy(buf, 0, pkt, 0, len);
                parseAndReport(pkt, len);
            }

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        } catch (Exception e) {
            Log.e(TAG, "VPN loop error: " + e.getMessage(), e);
        } finally {
            closeVpn();
        }
    }

    private void parseAndReport(byte[] pkt, int len) {
        if (len < 20) return;

        int versionIHL = pkt[0] & 0xFF;
        int version    = (versionIHL >> 4) & 0xF;
        if (version != 4) return;   // skip IPv6 for now

        int ihl      = (versionIHL & 0xF) * 4;
        int protocol = pkt[9] & 0xFF;

        // Only care about TCP (6) and UDP (17)
        if (protocol != 6 && protocol != 17) return;

        String srcAddr = ipBytes(pkt, 12);
        String dstAddr = ipBytes(pkt, 16);

        if (len < ihl + 4) return;
        int srcPort = ((pkt[ihl]     & 0xFF) << 8) | (pkt[ihl + 1] & 0xFF);
        int dstPort = ((pkt[ihl + 2] & 0xFF) << 8) | (pkt[ihl + 3] & 0xFF);

        // Outbound: source is our VPN address (10.99.x.x)
        boolean isOutbound = srcAddr.startsWith("10.99.");
        String remoteIp   = isOutbound ? dstAddr : srcAddr;
        int    remotePort = isOutbound ? dstPort  : srcPort;
        String direction  = isOutbound ? "⬆" : "⬇";
        String protoName  = protocol == 6 ? "TCP" : "UDP";

        // Skip uninteresting ports (local/broadcast/multicast)
        if (remoteIp.startsWith("224.") || remoteIp.startsWith("239.")
                || remoteIp.startsWith("255.") || remoteIp.equals("0.0.0.0")) return;
        if (remotePort == 0) return;

        // Dedup — don't spam the same connection every millisecond
        String key = direction + remoteIp + ":" + remotePort;
        long now = System.currentTimeMillis();
        synchronized (recentKeys) {
            Long last = recentKeys.get(key);
            if (last != null && (now - last) < 2000) return;  // suppress same key within 2s
            recentKeys.put(key, now);
        }

        // Resolve hostname (non-blocking — use cache, dispatch DNS in background)
        String cachedHost = dnsCache.get(remoteIp);
        if (cachedHost != null) {
            emit(direction, protoName, cachedHost, remoteIp, remotePort, len);
        } else {
            // Emit immediately with raw IP, then update when DNS resolves
            emit(direction, protoName, remoteIp, remoteIp, remotePort, len);
            final String ipToResolve = remoteIp;
            dnsExecutor.submit(() -> {
                try {
                    String host = InetAddress.getByName(ipToResolve).getHostName();
                    if (!host.equals(ipToResolve)) {
                        dnsCache.put(ipToResolve, host);
                        // Re-emit with resolved name if it matches target
                        if (targetDomain.isEmpty() || host.toLowerCase().contains(targetDomain)
                                || ipToResolve.equals(dnsCache.get(targetDomain))) {
                            emit(direction, protoName, host, ipToResolve, remotePort, len);
                        }
                    } else {
                        dnsCache.put(ipToResolve, ipToResolve);
                    }
                } catch (Exception ignored) {
                    dnsCache.put(ipToResolve, ipToResolve);
                }
            });
        }
    }

    private void emit(String direction, String protocol, String host,
                      String ip, int port, int bytes) {
        // If a target domain is set, filter — show only matching entries
        if (!targetDomain.isEmpty()) {
            boolean matches = host.toLowerCase().contains(targetDomain)
                    || ip.toLowerCase().contains(targetDomain);
            if (!matches) return;
        }

        String ts = new SimpleDateFormat("HH:mm:ss", Locale.US).format(new Date());
        Intent intent = new Intent(TRAFFIC_ACTION);
        intent.putExtra("direction", direction);
        intent.putExtra("protocol",  protocol);
        intent.putExtra("host",      host.equals(ip) ? "" : host);
        intent.putExtra("ipPort",    ip + ":" + port);
        intent.putExtra("bytes",     bytes);
        intent.putExtra("timestamp", ts);
        sendBroadcast(intent);
    }

    private static String ipBytes(byte[] pkt, int offset) {
        return (pkt[offset] & 0xFF) + "." + (pkt[offset+1] & 0xFF) + "."
             + (pkt[offset+2] & 0xFF) + "." + (pkt[offset+3] & 0xFF);
    }

    private void closeVpn() {
        running = false;
        try { if (vpnInterface != null) vpnInterface.close(); } catch (Exception ignored) {}
        vpnInterface = null;
    }

    @Override
    public void onDestroy() {
        running = false;
        if (executor    != null) executor.shutdownNow();
        if (dnsExecutor != null) dnsExecutor.shutdownNow();
        closeVpn();
        super.onDestroy();
    }

    private void createNotificationChannel() {
        NotificationManager nm = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        NotificationChannel ch = new NotificationChannel(
                CHANNEL_ID, "NetWatch VPN", NotificationManager.IMPORTANCE_LOW);
        nm.createNotificationChannel(ch);
    }

    private Notification buildNotification() {
        String text = targetDomain.isEmpty() ? "Monitoring all traffic" : "Filtering: " + targetDomain;
        return new Notification.Builder(this, CHANNEL_ID)
                .setContentTitle("🔍 NetWatch Active")
                .setContentText(text)
                .setSmallIcon(android.R.drawable.ic_menu_compass)
                .build();
    }
}
