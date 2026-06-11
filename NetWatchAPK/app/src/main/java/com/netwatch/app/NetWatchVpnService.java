package com.netwatch.app;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Intent;
import android.content.pm.ServiceInfo;
import android.net.VpnService;
import android.os.Build;
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
    private final Set<String>    resolvedIPs  = new HashSet<>();
    private ExecutorService      executor;

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

        // Resolve target domain IPs on a background thread
        if (!targetDomain.isEmpty()) {
            final String domainToResolve = targetDomain;
            new Thread(() -> resolveTargetDomain(domainToResolve)).start();
        }

        // Start foreground — API 34+ requires foreground service type
        Notification notif = buildNotification();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) { // API 34
            startForeground(NOTIF_ID, notif, ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC);
        } else {
            startForeground(NOTIF_ID, notif);
        }

        executor = Executors.newSingleThreadExecutor();
        executor.execute(this::runVpnLoop);
        return START_STICKY;
    }

    private void resolveTargetDomain(String domain) {
        try {
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
            builder.addRoute("0.0.0.0", 0);
            builder.addDnsServer("8.8.8.8");
            builder.setSession("NetWatch");
            builder.addDisallowedApplication(getPackageName());

            vpnInterface = builder.establish();
            if (vpnInterface == null) return;

            running = true;
            FileInputStream  in  = new FileInputStream(vpnInterface.getFileDescriptor());
            FileOutputStream out = new FileOutputStream(vpnInterface.getFileDescriptor());
            ByteBuffer       pkt = ByteBuffer.allocate(32767);

            while (running) {
                pkt.clear();
                int len = in.read(pkt.array());
                if (len <= 0) { Thread.sleep(10); continue; }
                pkt.limit(len);

                byte versionIHL = pkt.get(0);
                int  version    = (versionIHL >> 4) & 0xF;
                if (version != 4) { out.write(pkt.array(), 0, len); continue; }

                int  ihl      = (versionIHL & 0xF) * 4;
                byte protocol = pkt.get(9);

                int srcIp = ((pkt.get(12) & 0xFF) << 24) | ((pkt.get(13) & 0xFF) << 16)
                          | ((pkt.get(14) & 0xFF) << 8)  |  (pkt.get(15) & 0xFF);
                int dstIp = ((pkt.get(16) & 0xFF) << 24) | ((pkt.get(17) & 0xFF) << 16)
                          | ((pkt.get(18) & 0xFF) << 8)  |  (pkt.get(19) & 0xFF);

                String srcAddr = ipToString(srcIp);
                String dstAddr = ipToString(dstIp);

                int srcPort = 0, dstPort = 0;
                if ((protocol == 6 || protocol == 17) && len > ihl + 3) {
                    srcPort = ((pkt.get(ihl)     & 0xFF) << 8) | (pkt.get(ihl + 1) & 0xFF);
                    dstPort = ((pkt.get(ihl + 2) & 0xFF) << 8) | (pkt.get(ihl + 3) & 0xFF);
                }

                String protoName  = protocol == 6 ? "TCP" : (protocol == 17 ? "UDP" : "IP");
                boolean isOutbound = srcAddr.startsWith("10.0.0.");

                String matchIp   = isOutbound ? dstAddr : srcAddr;
                int    matchPort = isOutbound ? dstPort  : srcPort;

                if (matchesTarget(matchIp, matchPort)) {
                    String direction = isOutbound ? "⬆" : "⬇";
                    String ipPort    = matchIp + ":" + matchPort;
                    broadcastTraffic(direction, protoName, "", ipPort, len);
                }

                out.write(pkt.array(), 0, len);
            }

        } catch (Exception e) {
            // VPN loop ended — expected on stop
        } finally {
            closeVpn();
        }
    }

    private boolean matchesTarget(String ip, int port) {
        if (targetDomain.isEmpty()) return true;
        if (!resolvedIPs.isEmpty())  return resolvedIPs.contains(ip);
        // Fallback when DNS hasn't resolved yet — show common web ports
        return port == 80 || port == 443 || port == 8080 || port == 8443;
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

    private static String ipToString(int ip) {
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
        NotificationChannel ch = new NotificationChannel(
                CHANNEL_ID, "NetWatch VPN", NotificationManager.IMPORTANCE_LOW);
        nm.createNotificationChannel(ch);

        return new Notification.Builder(this, CHANNEL_ID)
                .setContentTitle("NetWatch Active")
                .setContentText("Monitoring: " + targetDomain)
                .setSmallIcon(android.R.drawable.ic_menu_compass)
                .build();
    }
}
