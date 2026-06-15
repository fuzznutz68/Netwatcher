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
import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.DatagramChannel;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.SocketChannel;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

public class NetWatchVpnService extends VpnService {

    public static final String TRAFFIC_ACTION = "com.netwatch.app.TRAFFIC";
    public static final String ACTION_STOP    = "com.netwatch.app.STOP_VPN";
    private static final String TAG           = "NetWatch";
    private static final String CHANNEL_ID    = "netwatch_vpn";
    private static final int    NOTIF_ID      = 42;

    private ParcelFileDescriptor vpnInterface;
    private volatile boolean     running = false;
    private String               targetDomain = "";

    // Cache: IP → hostname
    private final ConcurrentHashMap<String, String> dnsCache = new ConcurrentHashMap<>();
    // Dedup: only log same IP:port once per 3s
    private final LinkedHashMap<String, Long> recentKeys = new LinkedHashMap<String, Long>() {
        protected boolean removeEldestEntry(Map.Entry<String, Long> e) { return size() > 500; }
    };

    private ExecutorService executor;
    private ExecutorService dnsExecutor;

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent != null && ACTION_STOP.equals(intent.getAction())) {
            running = false;
            stopSelf();
            return START_NOT_STICKY;
        }

        // Guard: don't start a second tunnel if already running
        if (running) return START_STICKY;

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
            Builder builder = new Builder();
            builder.setMtu(1500);
            builder.addAddress("10.99.0.1", 24);
            builder.addRoute("0.0.0.0", 0);
            builder.addDnsServer("8.8.8.8");
            builder.addDnsServer("1.1.1.1");
            builder.setSession("NetWatch");
            builder.addDisallowedApplication(getPackageName()); // exclude self

            vpnInterface = builder.establish();
            if (vpnInterface == null) {
                Log.e(TAG, "VPN establish() returned null — no permission?");
                return;
            }
            Log.d(TAG, "VPN tunnel established, targetDomain='" + targetDomain + "'");
            running = true;

            FileInputStream tunIn = new FileInputStream(vpnInterface.getFileDescriptor());
            byte[] buf = new byte[32767];

            while (running) {
                int len;
                try {
                    len = tunIn.read(buf);
                } catch (IOException e) {
                    if (running) Log.w(TAG, "TUN read error: " + e.getMessage());
                    break;
                }
                if (len <= 0) {
                    Thread.sleep(2);
                    continue;
                }

                // Parse and report (async — don't block read loop)
                final byte[] pkt = new byte[len];
                System.arraycopy(buf, 0, pkt, 0, len);

                // Relay packet to real internet via protected socket (keeps connectivity)
                relayPacket(pkt, len);

                // Also parse for logging
                dnsExecutor.submit(() -> parseAndReport(pkt, len));
            }

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        } catch (Exception e) {
            Log.e(TAG, "VPN loop error: " + e.getMessage(), e);
        } finally {
            closeVpn();
        }
    }

    /** Relay outbound packet to real internet using a protected socket (so it bypasses VPN). */
    private void relayPacket(byte[] pkt, int len) {
        if (len < 20) return;
        int versionIHL = pkt[0] & 0xFF;
        if ((versionIHL >> 4) != 4) return; // IPv4 only
        int ihl      = (versionIHL & 0xF) * 4;
        int protocol = pkt[9] & 0xFF;
        if (len < ihl + 4) return;

        String dstAddr = ipBytes(pkt, 16);
        int    dstPort = ((pkt[ihl + 2] & 0xFF) << 8) | (pkt[ihl + 3] & 0xFF);

        // Skip multicast / broadcast / loopback
        if (dstAddr.startsWith("10.99.") || dstAddr.startsWith("127.")
                || dstAddr.startsWith("224.") || dstAddr.startsWith("239.")
                || dstAddr.startsWith("255.") || dstAddr.equals("0.0.0.0")) return;

        try {
            if (protocol == 17) { // UDP — fire and forget
                DatagramChannel ch = DatagramChannel.open();
                protect(ch.socket());
                ch.configureBlocking(false);
                ch.connect(new InetSocketAddress(dstAddr, dstPort));
                // Send only the UDP payload (strip IP + UDP headers)
                int udpHdrLen = 8;
                int payloadOff = ihl + udpHdrLen;
                int payloadLen = len - payloadOff;
                if (payloadLen > 0) {
                    ByteBuffer bb = ByteBuffer.wrap(pkt, payloadOff, payloadLen);
                    ch.write(bb);
                }
                ch.close();
            } else if (protocol == 6) { // TCP — async connect+send
                final byte[] payload = pkt;
                final String dstA = dstAddr;
                final int    dstP = dstPort;
                final int    ihlF = ihl;
                executor.submit(() -> {
                    try {
                        SocketChannel sc = SocketChannel.open();
                        protect(sc.socket());
                        sc.configureBlocking(true);
                        sc.socket().setSoTimeout(5000);
                        sc.connect(new InetSocketAddress(dstA, dstP));
                        // Send TCP payload
                        int tcpHdrLen = ((payload[ihlF + 12] & 0xFF) >> 4) * 4;
                        int payloadOff = ihlF + tcpHdrLen;
                        int payloadLen = len - payloadOff;
                        if (payloadLen > 0) {
                            sc.write(ByteBuffer.wrap(payload, payloadOff, payloadLen));
                        }
                        sc.close();
                    } catch (Exception ignored) {}
                });
            }
        } catch (Exception ignored) {}
    }

    private void parseAndReport(byte[] pkt, int len) {
        if (len < 20) return;
        int versionIHL = pkt[0] & 0xFF;
        if ((versionIHL >> 4) != 4) return;
        int ihl      = (versionIHL & 0xF) * 4;
        int protocol = pkt[9] & 0xFF;
        if (protocol != 6 && protocol != 17) return;
        if (len < ihl + 4) return;

        String srcAddr = ipBytes(pkt, 12);
        String dstAddr = ipBytes(pkt, 16);
        int srcPort = ((pkt[ihl]     & 0xFF) << 8) | (pkt[ihl + 1] & 0xFF);
        int dstPort = ((pkt[ihl + 2] & 0xFF) << 8) | (pkt[ihl + 3] & 0xFF);

        // All packets from TUN are outbound (originated by device, src = 10.99.x.x)
        boolean isOutbound = srcAddr.startsWith("10.99.");
        String remoteIp   = isOutbound ? dstAddr : srcAddr;
        int    remotePort = isOutbound ? dstPort  : srcPort;
        String direction  = isOutbound ? "⬆" : "⬇";
        String protoName  = protocol == 6 ? "TCP" : "UDP";

        // Skip multicast / broadcast
        if (remoteIp.startsWith("224.") || remoteIp.startsWith("239.")
                || remoteIp.startsWith("255.") || remoteIp.equals("0.0.0.0")
                || remoteIp.startsWith("10.99.")) return;
        if (remotePort == 0) return;

        // Dedup
        String key = remoteIp + ":" + remotePort;
        long now = System.currentTimeMillis();
        synchronized (recentKeys) {
            Long last = recentKeys.get(key);
            if (last != null && (now - last) < 3000) return;
            recentKeys.put(key, now);
        }

        String cachedHost = dnsCache.get(remoteIp);
        if (cachedHost != null) {
            emit(direction, protoName, cachedHost, remoteIp, remotePort, len);
        } else {
            emit(direction, protoName, "", remoteIp, remotePort, len);
            final String ipToResolve = remoteIp;
            dnsExecutor.submit(() -> {
                try {
                    String host = InetAddress.getByName(ipToResolve).getHostName();
                    if (!host.equals(ipToResolve)) {
                        dnsCache.put(ipToResolve, host);
                        emit(direction, protoName, host, ipToResolve, remotePort, len);
                    } else {
                        dnsCache.put(ipToResolve, "");
                    }
                } catch (Exception e) {
                    dnsCache.put(ipToResolve, "");
                }
            });
        }
    }

    private void emit(String direction, String protocol, String host,
                      String ip, int port, int bytes) {
        if (!targetDomain.isEmpty()) {
            boolean matches = host.toLowerCase().contains(targetDomain)
                    || ip.toLowerCase().contains(targetDomain);
            if (!matches) return;
        }
        String ts = new SimpleDateFormat("HH:mm:ss", Locale.US).format(new Date());
        Intent intent = new Intent(TRAFFIC_ACTION);
        intent.putExtra("direction", direction);
        intent.putExtra("protocol",  protocol);
        intent.putExtra("host",      host);
        intent.putExtra("ipPort",    ip + ":" + port);
        intent.putExtra("bytes",     bytes);
        intent.putExtra("timestamp", ts);
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
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
        String text = targetDomain.isEmpty() ? "Monitoring all device traffic" : "Filtering: " + targetDomain;
        return new Notification.Builder(this, CHANNEL_ID)
                .setContentTitle("NetWatch")
                .setContentText(text)
                .setSmallIcon(android.R.drawable.ic_dialog_info)
                .build();
    }
}
