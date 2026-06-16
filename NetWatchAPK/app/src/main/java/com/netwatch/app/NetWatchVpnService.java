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
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.UnknownHostException;
import java.nio.ByteBuffer;
import java.nio.channels.DatagramChannel;
import java.nio.channels.SocketChannel;
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
    private static final long   DEDUP_MS   = 30_000L;

    private ParcelFileDescriptor vpnInterface;
    private volatile boolean     running = false;
    private ExecutorService      ioPool;
    private ExecutorService      dnsExecutor;

    private final ConcurrentHashMap<String, Long>   seenKeys = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<String, String> dnsCache = new ConcurrentHashMap<>();

    // ── Lifecycle ─────────────────────────────────────────────────

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

    // ── VPN tunnel ────────────────────────────────────────────────

    private void runVpn() {
        try {
            vpnInterface = new Builder()
                .setMtu(MTU)
                .addAddress("10.99.0.1", 24)
                .addRoute("0.0.0.0", 0)
                .addAddress("fd00::1", 120)
                .addRoute("::", 0)
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
            Log.d(TAG, "VPN tunnel up");

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

    // ── IPv4 handler ──────────────────────────────────────────────

    private void handleIPv4(byte[] pkt, int len, FileOutputStream out) {
        try {
            int ipHdrLen = (pkt[0] & 0x0f) * 4;
            if (ipHdrLen < 20 || len < ipHdrLen + 4) { out.write(pkt, 0, len); return; }

            int    proto   = pkt[9] & 0xff;
            String srcIp   = ipv4(pkt, 12);
            String dstIp   = ipv4(pkt, 16);
            int    srcPort = u16(pkt, ipHdrLen);
            int    dstPort = u16(pkt, ipHdrLen + 2);

            if (dstPort == 0 || dstIp.equals("0.0.0.0") || dstIp.startsWith("127.")
                    || dstIp.startsWith("10.99.") || dstIp.startsWith("224.")
                    || dstIp.startsWith("239.") || dstIp.startsWith("255.")) {
                out.write(pkt, 0, len); return;
            }

            boolean isTcp = (proto == 6);
            boolean isUdp = (proto == 17);
            if (!isTcp && !isUdp) { out.write(pkt, 0, len); return; }

            String key = (isTcp ? "TCP" : "UDP") + dstIp + ":" + dstPort;
            long   now = System.currentTimeMillis();
            Long   last = seenKeys.get(key);
            if (last == null || now - last > DEDUP_MS) {
                seenKeys.put(key, now);
                reportConnection(isTcp ? "TCP" : "UDP", dstIp, dstPort);
            }

            if (isUdp) {
                // For UDP: forward via protected socket and relay response back
                final byte[] pktCopy = pkt.clone();
                final int    pktLen  = len;
                final String fDstIp  = dstIp;
                final int    fDstPort = dstPort;
                final String fSrcIp  = srcIp;
                final int    fSrcPort = srcPort;
                final int    fIpHdrLen = ipHdrLen;
                ioPool.execute(() -> forwardUdp(pktCopy, pktLen, fSrcIp, fSrcPort,
                                               fDstIp, fDstPort, fIpHdrLen, out));
            } else {
                // For TCP: forward via protected socket (fire-and-forget for logging),
                // also write packet back so kernel doesn't stall completely
                final byte[] pktCopy = pkt.clone();
                final int    pktLen  = len;
                final String fDstIp  = dstIp;
                final int    fDstPort = dstPort;
                final int    fIpHdrLen = ipHdrLen;
                ioPool.execute(() -> forwardTcp(pktCopy, pktLen, fDstIp, fDstPort, fIpHdrLen));
                out.write(pkt, 0, len);
            }
        } catch (Exception e) {
            try { out.write(pkt, 0, len); } catch (Exception ignored) {}
        }
    }

    // ── IPv6 handler ──────────────────────────────────────────────

    private void handleIPv6(byte[] pkt, int len, FileOutputStream out) {
        try {
            if (len < 44) { out.write(pkt, 0, len); return; }

            int    proto   = pkt[6] & 0xff;
            String srcIp   = ipv6(pkt, 8);
            String dstIp   = ipv6(pkt, 24);
            int    offset  = 40;

            // Walk extension headers
            while (proto == 0 || proto == 43 || proto == 44 || proto == 60) {
                if (offset + 2 > len) { out.write(pkt, 0, len); return; }
                int next   = pkt[offset] & 0xff;
                int hdrLen = ((pkt[offset + 1] & 0xff) + 1) * 8;
                proto  = next;
                offset += hdrLen;
                if (offset + 4 > len) { out.write(pkt, 0, len); return; }
            }

            int dstPort = u16(pkt, offset + 2);
            int srcPort = u16(pkt, offset);

            if (dstPort == 0 || dstIp.equals("::1") || dstIp.startsWith("fd00:")
                    || dstIp.startsWith("ff")) {
                out.write(pkt, 0, len); return;
            }

            boolean isTcp = (proto == 6);
            boolean isUdp = (proto == 17);
            if (!isTcp && !isUdp) { out.write(pkt, 0, len); return; }

            String key = (isTcp ? "TCP" : "UDP") + dstIp + ":" + dstPort;
            long   now  = System.currentTimeMillis();
            Long   last = seenKeys.get(key);
            if (last == null || now - last > DEDUP_MS) {
                seenKeys.put(key, now);
                reportConnection(isTcp ? "TCP" : "UDP", dstIp, dstPort);
            }

            out.write(pkt, 0, len);
        } catch (Exception e) {
            try { out.write(pkt, 0, len); } catch (Exception ignored) {}
        }
    }

    // ── TCP forward (protected, fire-and-forget for logging) ──────

    private void forwardTcp(byte[] pkt, int len, String dstIp, int dstPort, int ipHdrLen) {
        int tcpHdrLen = ((pkt[ipHdrLen + 12] >> 4) & 0x0f) * 4;
        int payloadOff = ipHdrLen + tcpHdrLen;
        int payloadLen = len - payloadOff;
        if (payloadLen <= 0) return; // SYN/ACK with no data - nothing to forward

        try {
            SocketChannel ch = SocketChannel.open();
            protect(ch.socket());
            ch.socket().setSoTimeout(5000);
            ch.connect(new InetSocketAddress(InetAddress.getByName(dstIp), dstPort));
            ch.write(ByteBuffer.wrap(pkt, payloadOff, payloadLen));
            ch.close();
        } catch (Exception e) {
            Log.d(TAG, "TCP fwd error: " + e.getMessage());
        }
    }

    // ── UDP forward with response relay ───────────────────────────

    private void forwardUdp(byte[] pkt, int len, String srcIp, int srcPort,
                             String dstIp, int dstPort, int ipHdrLen, FileOutputStream out) {
        int udpPayloadOff = ipHdrLen + 8;
        int udpPayloadLen = len - udpPayloadOff;
        if (udpPayloadLen <= 0) return;

        try {
            DatagramChannel ch = DatagramChannel.open();
            DatagramSocket  sock = ch.socket();
            protect(sock);
            sock.setSoTimeout(2000);

            // Send to real server
            ByteBuffer sendBuf = ByteBuffer.wrap(pkt, udpPayloadOff, udpPayloadLen);
            ch.send(sendBuf, new InetSocketAddress(InetAddress.getByName(dstIp), dstPort));

            // Wait for response and relay back via TUN
            ByteBuffer recvBuf = ByteBuffer.allocate(2000);
            sock.setSoTimeout(2000);
            DatagramPacket resp = new DatagramPacket(recvBuf.array(), recvBuf.capacity());
            sock.receive(resp);

            byte[] reply = buildUdpReply(dstIp, dstPort, srcIp, srcPort,
                                         resp.getData(), resp.getLength());
            if (reply != null) {
                synchronized (out) { out.write(reply); }
            }
            ch.close();
        } catch (Exception e) {
            Log.d(TAG, "UDP fwd error: " + e.getMessage());
        }
    }

    // ── Build a UDP reply IPv4 packet (swap src/dst) ───────────────

    private static byte[] buildUdpReply(String srcIp, int srcPort,
                                         String dstIp, int dstPort,
                                         byte[] payload, int payLen) {
        try {
            int totalLen = 28 + payLen; // 20 IP + 8 UDP + payload
            byte[] pkt = new byte[totalLen];

            // IPv4 header
            pkt[0]  = 0x45;                          // version=4, IHL=5
            pkt[1]  = 0;
            pkt[2]  = (byte)(totalLen >> 8);
            pkt[3]  = (byte)(totalLen);
            pkt[4]  = 0; pkt[5] = 0;                // identification
            pkt[6]  = 0x40;                          // don't fragment
            pkt[7]  = 0;
            pkt[8]  = 0x40;                          // TTL = 64
            pkt[9]  = 0x11;                          // protocol = UDP

            byte[] sAddr = InetAddress.getByName(srcIp).getAddress();
            byte[] dAddr = InetAddress.getByName(dstIp).getAddress();
            if (sAddr.length != 4 || dAddr.length != 4) return null;
            System.arraycopy(sAddr, 0, pkt, 12, 4);
            System.arraycopy(dAddr, 0, pkt, 16, 4);

            // IP checksum
            int cksum = ipChecksum(pkt, 0, 20);
            pkt[10] = (byte)(cksum >> 8);
            pkt[11] = (byte)(cksum);

            // UDP header
            int udpLen = 8 + payLen;
            pkt[20] = (byte)(srcPort >> 8); pkt[21] = (byte)(srcPort);
            pkt[22] = (byte)(dstPort >> 8); pkt[23] = (byte)(dstPort);
            pkt[24] = (byte)(udpLen >> 8);  pkt[25] = (byte)(udpLen);
            pkt[26] = 0; pkt[27] = 0;       // checksum (omit)

            System.arraycopy(payload, 0, pkt, 28, payLen);
            return pkt;
        } catch (Exception e) {
            return null;
        }
    }

    private static int ipChecksum(byte[] buf, int off, int len) {
        int sum = 0;
        for (int i = off; i < off + len - 1; i += 2)
            sum += ((buf[i] & 0xff) << 8) | (buf[i+1] & 0xff);
        if ((len & 1) != 0) sum += (buf[off + len - 1] & 0xff) << 8;
        while ((sum >> 16) != 0) sum = (sum & 0xffff) + (sum >> 16);
        return (~sum) & 0xffff;
    }

    // ── Async DNS + broadcast ─────────────────────────────────────

    private void reportConnection(String proto, String ip, int port) {
        String cached = dnsCache.get(ip);
        if (cached == null) {
            emit(proto, "", ip, port);
            final String ipCopy = ip;
            dnsExecutor.submit(() -> {
                try {
                    String host = InetAddress.getByName(ipCopy).getHostName();
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
        return (b[off]&0xff)+"."+( b[off+1]&0xff)+"."+( b[off+2]&0xff)+"."+( b[off+3]&0xff);
    }

    private static String ipv6(byte[] b, int off) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 16; i += 2) {
            if (i > 0) sb.append(':');
            sb.append(String.format("%x", ((b[off+i]&0xff)<<8)|(b[off+i+1]&0xff)));
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
        ((NotificationManager)getSystemService(NOTIFICATION_SERVICE)).createNotificationChannel(ch);
    }

    private Notification buildNotification() {
        return new Notification.Builder(this, CHANNEL_ID)
            .setContentTitle("📶 NetWatch Device Monitor")
            .setContentText("Monitoring all device connections")
            .setSmallIcon(android.R.drawable.ic_menu_compass)
            .build();
    }
}
