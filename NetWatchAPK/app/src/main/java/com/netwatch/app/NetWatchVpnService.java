package com.netwatch.app;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Intent;
import android.net.VpnService;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.ParcelFileDescriptor;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.InetAddress;
import java.nio.ByteBuffer;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.Locale;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class NetWatchVpnService extends VpnService {

    public static final String TRAFFIC_ACTION = "com.netwatch.app.TRAFFIC";
    public static final String ACTION_STOP     = "com.netwatch.app.STOP_VPN";
    private static final String CHANNEL_ID     = "netwatch_vpn";
    private static final int    NOTIF_ID       = 42;

    private ParcelFileDescriptor vpnInterface;
    private volatile boolean     running = false;
    private String               targetDomain = "";
    private Set<String>          resolvedIPs  = new HashSet<>();
    private ExecutorService      executor;

    private static final int[] SERVICE_PORTS = {80, 443, 8080, 8443};

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent != null && ACTION_STOP.equals(intent.getAction())) {
            stopSelf();
            return START_NOT_STICKY;
        }

        if (intent != null) {
            targetDomain = intent.getStringExtra("target_domain");
            if (targetDomain == null) targetDomain = "";
        }

        // Resolve domain IPs up front
        resolvedIPs.clear();
        if (!targetDomain.isEmpty()) {
            new Thread(() -> resolveTargetDomain(targetDomain)).start();
        }

        startForeground(NOTIF_ID, buildNotification());
        executor = Executors.newSingleThreadExecutor();
        executor.execute(this::runVpnLoop);
        return START_STICKY;
    }

    private void resolveTargetDomain(String domain) {
        try {
            // Strip wildcard
            String d = domain.startsWith("*.") ? domain.substring(2) : domain;
            InetAddress[] addrs = InetAddress.getAllByName(d);
            for (InetAddress a : addrs) resolvedIPs.add(a.getHostAddress());
        } catch (Exception ignored) {}
    }

    private void runVpnLoop() {
        try {
            Builder builder = new Builder();
            builder.setMtu(1500);
            builder.addAddress("10.0.0.2", 32);
            builder.addRoute("0.0.0.0", 0);          // capture all IPv4
            builder.addDnsServer("8.8.8.8");
            builder.setSession("NetWatch");

            // Bypass our own app so we can still reach the backend
            builder.addDisallowedApplication(getPackageName());

            vpnInterface = builder.establish();
            if (vpnInterface == null) return;

            running = true;
            FileInputStream  in  = new FileInputStream(vpnInterface.getFileDescriptor());
            FileOutputStream out = new FileOutputStream(vpnInterface.getFileDescriptor());

            ByteBuffer packet = ByteBuffer.allocate(32767);

            while (running) {
                packet.clear();
                int len = in.read(packet.array());
                if (len <= 0) { Thread.sleep(10); continue; }
                packet.limit(len);

                // Parse IP header
                byte versionIHL = packet.get(0);
                int  version    = (versionIHL >> 4) & 0xF;
                if (version != 4) { out.write(packet.array(), 0, len); continue; } // forward IPv6 as-is

                int  ihl        = (versionIHL & 0xF) * 4;
                byte protocol   = packet.get(9);
                // Source IP
                int  srcIp = ((packet.get(12) & 0xFF) << 24) | ((packet.get(13) & 0xFF) << 16)
                           | ((packet.get(14) & 0xFF) << 8)  |  (packet.get(15) & 0xFF);
                // Dest IP
                int  dstIp = ((packet.get(16) & 0xFF) << 24) | ((packet.get(17) & 0xFF) << 16)
                           | ((packet.get(18) & 0xFF) << 8)  |  (packet.get(19) & 0xFF);

                String srcAddr = ipIntToString(srcIp);
                String dstAddr = ipIntToString(dstIp);

                int dstPort = 0;
                int srcPort = 0;
                if ((protocol == 6 || protocol == 17) && len > ihl + 3) {
                    srcPort = ((packet.get(ihl)     & 0xFF) << 8) | (packet.get(ihl + 1) & 0xFF);
                    dstPort = ((packet.get(ihl + 2) & 0xFF) << 8) | (packet.get(ihl + 3) & 0xFF);
                }

                String protoName = protocol == 6 ? "TCP" : (protocol == 17 ? "UDP" : "IP");
                boolean isOutbound = srcAddr.equals("10.0.0.2");

                // Match against target domain
                boolean matches = matchesTarget(isOutbound ? dstAddr : srcAddr,
                                               isOutbound ? dstPort  : srcPort);

                if (matches) {
                    String direction = isOutbound ? "⬆" : "⬇";
                    String ipPort    = (isOutbound ? dstAddr : srcAddr) + ":" +
                                       (isOutbound ? dstPort  : srcPort);
                    broadcastTraffic(direction, protoName, "", ipPort, len);
                }

                // Forward packet transparently
                out.write(packet.array(), 0, len);
            }

        } catch (Exception e) {
            // VPN loop ended
        } finally {
            closeVpn();
        }
    }

    private boolean matchesTarget(String ip, int port) {
        if (targetDomain.isEmpty()) return true; // monitor all
        // Check by resolved IP
        if (!resolvedIPs.isEmpty()) {
            return resolvedIPs.contains(ip);
        }
        // Fallback: match by port
        for (int p : SERVICE_PORTS) if (port == p) return true;
        return false;
    }

    private void broadcastTraffic(String direction, String protocol,
                                  String host, String ipPort, int bytes) {
        String ts = new SimpleDateFormat("HH:mm:ss", Locale.US).format(new Date());
        Intent intent = new Intent(TRAFFIC_ACTION);
        intent.putExtra("direction", direction);
        intent.putExtra("protocol",  protocol);
        intent.putExtra("host",      host);
        intent.putExtra("ipPort",    ipPort);
        intent.putExtra("bytes",     bytes);
        intent.putExtra("timestamp", ts);
        sendBroadcast(intent);
    }

    private static String ipIntToString(int ip) {
        return ((ip >> 24) & 0xFF) + "." + ((ip >> 16) & 0xFF) + "."
             + ((ip >> 8)  & 0xFF) + "." + (ip & 0xFF);
    }

    private void closeVpn() {
        running = false;
        try { if (vpnInterface != null) vpnInterface.close(); } catch (Exception ignored) {}
        vpnInterface = null;
    }

    @Override
    public void onDestroy() {
        running = false;
        if (executor != null) executor.shutdownNow();
        closeVpn();
        super.onDestroy();
    }

    private Notification buildNotification() {
        NotificationManager nm = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel ch = new NotificationChannel(
                    CHANNEL_ID, "NetWatch VPN", NotificationManager.IMPORTANCE_LOW);
            nm.createNotificationChannel(ch);
        }
        Notification.Builder nb = Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
                ? new Notification.Builder(this, CHANNEL_ID)
                : new Notification.Builder(this);
        return nb.setContentTitle("NetWatch Active")
                 .setContentText("Monitoring: " + targetDomain)
                 .setSmallIcon(android.R.drawable.ic_menu_compass)
                 .build();
    }
}
