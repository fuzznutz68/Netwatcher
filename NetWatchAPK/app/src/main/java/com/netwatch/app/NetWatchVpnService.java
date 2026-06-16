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
import java.net.UnknownHostException;
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
    private static final int    MTU        = 1600;

    // Dedup: don't log same IP:port more than once per 5 seconds
    private static final long   DEDUP_MS   = 5_000L;

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
                // IPv4 tunnel address + catch-all route
                .addAddress("10.99.0.1", 24)
                .addRoute("0.0.0.0", 0)
                // IPv6 tunnel address + catch-all route
                .addAddress("fd00::1", 120)
                .addRoute("::", 0)
                .addDnsServer("8.8.8.8")
                .addDnsServer("1.1.1.1")
                .addDnsServer("2001:4860:4860::8888")  // Google IPv6 DNS
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
            Log.d(TAG, "VPN tunnel up, monitoring all traffic");

            while (running) {
                int len = in.read(buf);
                if (len < 20) continue;
                byte[] pkt = Arrays.copyOf(buf, len);

                int version = (pkt[0] >> 4) & 0x0f;
                if (version == 4) {
                    handleIPv4(pkt, len, out);
                } else if (version == 6) {
                    handleIPv6(pkt, len, out);
                } else {
                    out.write(pkt, 0, len);
                }
            }
        } catch (Exception e) {
            if (running) Log.e(TAG, "VPN loop error", e);
        } finally {
            running = false;
            closeVpn();
        }
    }

    // ── IPv4 packet handler ───────────────────────────────────────

    private void handleIPv4(byte[] pkt, int len, FileOutputStream out) {
        try {
            int ipHdrLen = (pkt[0] & 0x0f) * 4;
            if (ipHdrLen < 20 || len < ipHdrLen + 4) { out.write(pkt, 0, len); return; }

            int    proto   = pkt[9] & 0xff;
            String dstIp   = ipv4(pkt, 16);
            int    dstPort = u16(pkt, ipHdrLen + 2);

            if (shouldSkip4(dstIp, dstPort)) { out.write(pkt, 0, len); return; }

            boolean isTcp = (proto == 6);
            boolean isUdp = (proto == 17);
            if (!isTcp && !isUdp) { out.write(pkt, 0, len); return; }

            maybeReport(isTcp ? "TCP" : "UDP", dstIp, dstPort);
            out.write(pkt, 0, len);

        } catch (Exception e) {
            try { out.write(pkt, 0, len); } catch (Exception ignored) {}
        }
    }

    // ── IPv6 packet handler ───────────────────────────────────────
    // Fixed header = 40 bytes: version(4b)+TC(8b)+FL(20b) | payloadLen(16b) |
    //                          nextHdr(8b) | hopLimit(8b) | src(128b) | dst(128b)

    private void handleIPv6(byte[] pkt, int len, FileOutputStream out) {
        try {
            if (len < 44) { out.write(pkt, 0, len); return; } // 40 hdr + 4 for port

            int    proto   = pkt[6] & 0xff;  // Next Header
            String dstIp   = ipv6(pkt, 24);  // Destination address at offset 24
            int    dstPort = u16(pkt, 40 + 2); // Transport dst port at offset 42

            // Handle extension headers for TCP/UDP
            int offset = 40;
            // Walk common extension headers to find TCP/UDP
            while (proto == 0   // Hop-by-Hop
                || proto == 43  // Routing
                || proto == 44  // Fragment
                || proto == 60) // Destination Options
            {
                if (offset + 2 > len) { out.write(pkt, 0, len); return; }
                int nextProto  = pkt[offset] & 0xff;
                int hdrLen     = ((pkt[offset + 1] & 0xff) + 1) * 8;
                proto  = nextProto;
                offset += hdrLen;
                if (offset + 4 > len) { out.write(pkt, 0, len); return; }
                dstPort = u16(pkt, offset + 2);
            }

            if (shouldSkip6(dstIp, dstPort)) { out.write(pkt, 0, len); return; }

            boolean isTcp = (proto == 6);
            boolean isUdp = (proto == 17);
            if (!isTcp && !isUdp) { out.write(pkt, 0, len); return; }

            maybeReport(isTcp ? "TCP" : "UDP", dstIp, dstPort);
            out.write(pkt, 0, len);

        } catch (Exception e) {
            try { out.write(pkt, 0, len); } catch (Exception ignored) {}
        }
    }

    // ── Filters ───────────────────────────────────────────────────

    private static boolean shouldSkip4(String ip, int port) {
        return port == 0
            || ip.equals("0.0.0.0")
            || ip.startsWith("127.")
            || ip.startsWith("10.99.")   // our own VPN subnet
            || ip.startsWith("224.")
            || ip.startsWith("239.")
            || ip.startsWith("255.");
    }

    private static boolean shouldSkip6(String ip, int port) {
        return port == 0
            || ip.equals("::1")          // loopback
            || ip.startsWith("fd00:")    // our own VPN subnet
            || ip.startsWith("ff");      // multicast
    }

    // ── Dedup + report ────────────────────────────────────────────

    private void maybeReport(String proto, String ip, int port) {
        String key  = proto + ip + ":" + port;
        long   now  = System.currentTimeMillis();
        Long   last = seenKeys.get(key);
        if (last == null || now - last > DEDUP_MS) {
            seenKeys.put(key, now);
            reportConnection(proto, ip, port);
        }
    }

    // ── Reporting + async DNS ─────────────────────────────────────

    private void reportConnection(String proto, String ip, int port) {
        String cached = dnsCache.get(ip);
        if (cached == null) {
            emit(proto, "", ip, port);
            final String ipCopy = ip;
            dnsExecutor.submit(() -> {
                try {
                    InetAddress addr = InetAddress.getByName(ipCopy);
                    String host = addr.getHostName();
                    if (!host.equals(ipCopy)) {
                        dnsCache.put(ipCopy, host);
                        emit(proto, host, ipCopy, port);
                    } else {
                        dnsCache.put(ipCopy, ipCopy);
                    }
                } catch (UnknownHostException ex) {
                    dnsCache.put(ipCopy, ipCopy);
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

    private static String ipv6(byte[] b, int off) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 16; i += 2) {
            if (i > 0) sb.append(':');
            sb.append(String.format("%x", ((b[off+i] & 0xff) << 8) | (b[off+i+1] & 0xff)));
        }
        return sb.toString();
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
