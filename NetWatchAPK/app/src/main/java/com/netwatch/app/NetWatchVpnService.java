package com.netwatch.app;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Intent;
import android.net.VpnService;
import android.os.ParcelFileDescriptor;
import android.util.Log;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.Locale;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class NetWatchVpnService extends VpnService {

    public static final String ACTION_STOP = "com.netwatch.app.STOP_VPN";
    private static final String TAG        = "NetWatchVPN";
    private static final String CHANNEL_ID = "netwatch_vpn";
    private static final int    NOTIF_ID   = 42;
    private static final int    MTU        = 1500;

    private ParcelFileDescriptor vpnInterface;
    private volatile boolean     running    = false;
    private ExecutorService      ioPool;
    private ExecutorService      dnsExecutor;

    private final ConcurrentHashMap<String, Long>   seenKeys = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<String, String> dnsCache = new ConcurrentHashMap<>();

    // ── Lifecycle ────────────────────────────────────────────────

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent != null && ACTION_STOP.equals(intent.getAction())) {
            running = false;
            stopSelf();
            return START_NOT_STICKY;
        }
        createNotificationChannel();
        startForeground(NOTIF_ID, buildNotification());
        ioPool      = Executors.newCachedThreadPool();
        dnsExecutor = Executors.newFixedThreadPool(4);
        ioPool.execute(this::runVpn);
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        running = false;
        if (ioPool      != null) ioPool.shutdownNow();
        if (dnsExecutor != null) dnsExecutor.shutdownNow();
        closeVpn();
        super.onDestroy();
    }

    private void closeVpn() {
        try { if (vpnInterface != null) { vpnInterface.close(); vpnInterface = null; } }
        catch (Exception ignored) {}
    }

    // ── VPN tunnel ───────────────────────────────────────────────

    private void runVpn() {
        try {
            vpnInterface = new Builder()
                .setMtu(MTU)
                .addAddress("10.99.0.1", 24)
                .addRoute("0.0.0.0", 0)
                .addDnsServer("8.8.8.8")
                .addDnsServer("1.1.1.1")
                .setSession("NetWatch")
                .addDisallowedApplication(getPackageName())
                .establish();

            if (vpnInterface == null) {
                Log.e(TAG, "establish() returned null – VPN permission denied?");
                return;
            }

            FileInputStream  in  = new FileInputStream(vpnInterface.getFileDescriptor());
            FileOutputStream out = new FileOutputStream(vpnInterface.getFileDescriptor());
            byte[] buf = new byte[MTU];
            running = true;

            while (running) {
                int len = in.read(buf);
                if (len <= 0) continue;
                byte[] pkt = Arrays.copyOf(buf, len);
                handleIPv4(pkt, len, out);
            }
        } catch (Exception e) {
            if (running) Log.e(TAG, "VPN loop error", e);
        } finally {
            running = false;
            closeVpn();
        }
    }

    // ── Packet inspection (same logic as v2.0.6) ─────────────────

    private void handleIPv4(byte[] pkt, int len, FileOutputStream out) {
        try {
            if (len < 20) { out.write(pkt, 0, len); return; }

            int ipHdrLen = (pkt[0] & 0x0f) * 4;
            int proto    = pkt[9] & 0xff;

            if (len < ipHdrLen + 4) { out.write(pkt, 0, len); return; }

            String dstIp  = ipv4(pkt, 16);
            int    dstPort = u16(pkt, ipHdrLen + 2);

            // Skip loopback / multicast / broadcast / zero-port
            if (dstPort == 0
                    || dstIp.equals("0.0.0.0")
                    || dstIp.startsWith("127.")
                    || dstIp.startsWith("224.")
                    || dstIp.startsWith("239.")
                    || dstIp.startsWith("255.")) {
                out.write(pkt, 0, len);
                return;
            }

            boolean isTcp = (proto == 6);
            boolean isUdp = (proto == 17);

            if (!isTcp && !isUdp) { out.write(pkt, 0, len); return; }

            String protoStr = isTcp ? "TCP" : "UDP";
            String key      = protoStr + dstIp + ":" + dstPort;

            long now  = System.currentTimeMillis();
            Long last = seenKeys.get(key);
            if (last == null || now - last > 30_000L) {
                seenKeys.put(key, now);
                reportConnection(protoStr, dstIp, dstPort);
            } else {
                seenKeys.put(key, now);
            }

            // Echo packet back so device's TCP/IP stack stays happy
            out.write(pkt, 0, len);

        } catch (Exception e) {
            try { out.write(pkt, 0, len); } catch (Exception ignored) {}
            Log.d(TAG, "handleIPv4: " + e.getMessage());
        }
    }

    // ── Reporting + async DNS ─────────────────────────────────────

    private void reportConnection(String proto, String ip, int port) {
        String cached = dnsCache.get(ip);
        if (cached == null) {
            // Emit immediately with raw IP, then update with hostname when resolved
            emit(proto, "", ip, port);
            dnsExecutor.submit(() -> {
                try {
                    String host = InetAddress.getByName(ip).getHostName();
                    if (!host.equals(ip)) {
                        dnsCache.put(ip, host);
                        emit(proto, host, ip, port);
                    } else {
                        dnsCache.put(ip, ip);
                    }
                } catch (Exception ex) {
                    dnsCache.put(ip, ip);
                }
            });
        } else {
            emit(proto, cached.equals(ip) ? "" : cached, ip, port);
        }
    }

    private void emit(String proto, String host, String ip, int port) {
        String ts = new SimpleDateFormat("HH:mm:ss", Locale.US).format(new Date());
        Intent i  = new Intent("com.netwatch.app.DEVICE_TRAFFIC");
        i.putExtra("protocol",  proto);
        i.putExtra("host",      host);
        i.putExtra("ipPort",    ip + ":" + port);
        i.putExtra("app",       "");
        i.putExtra("timestamp", ts);
        LocalBroadcastManager.getInstance(this).sendBroadcast(i);
        Log.d(TAG, "EMIT " + proto + " " + (host.isEmpty() ? ip : host) + ":" + port);
    }

    // ── Helpers ───────────────────────────────────────────────────

    private static String ipv4(byte[] b, int off) {
        return (b[off] & 0xff) + "." + (b[off+1] & 0xff)
             + "." + (b[off+2] & 0xff) + "." + (b[off+3] & 0xff);
    }

    private static int u16(byte[] b, int off) {
        return ((b[off] & 0xff) << 8) | (b[off+1] & 0xff);
    }

    // ── Notification ─────────────────────────────────────────────

    private void createNotificationChannel() {
        NotificationChannel ch = new NotificationChannel(
            CHANNEL_ID, "NetWatch Device Monitor", NotificationManager.IMPORTANCE_LOW);
        ((NotificationManager) getSystemService(NOTIFICATION_SERVICE)).createNotificationChannel(ch);
    }

    private Notification buildNotification() {
        return new Notification.Builder(this, CHANNEL_ID)
            .setContentTitle("📶 NetWatch Device Monitor")
            .setContentText("Monitoring all device connections")
            .setSmallIcon(android.R.drawable.ic_menu_compass)
            .build();
    }
}
