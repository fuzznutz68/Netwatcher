package com.netwatch.app;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.net.VpnService;
import android.os.Build;
import android.os.ParcelFileDescriptor;
import android.util.Log;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.DatagramChannel;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * NetWatch VPN Service
 * Uses Android's VpnService API (no root required) to intercept device traffic.
 * Creates a local TUN interface and inspects IP packets for connections to
 * the monitored domain/IPs.
 */
public class NetWatchVpnService extends VpnService {

    private static final String TAG = "NetWatchVPN";
    private static final String CHANNEL_ID = "netwatch_vpn";
    private static final int NOTIF_ID = 100;

    private ParcelFileDescriptor vpnInterface;
    private AtomicBoolean running = new AtomicBoolean(false);
    private Thread captureThread;
    private String targetDomain;
    private String[] targetIps;

    private static LogCallback logCallback;

    public interface LogCallback {
        void onEntry(TrafficEntry entry);
    }

    public static void setLogCallback(LogCallback cb) {
        logCallback = cb;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent != null && "STOP".equals(intent.getAction())) {
            stopVpn();
            return START_NOT_STICKY;
        }

        if (intent != null) {
            targetDomain = intent.getStringExtra("target_domain");
        }

        startForeground(NOTIF_ID, buildNotification());
        startVpn();
        return START_STICKY;
    }

    private void startVpn() {
        running.set(true);

        // Resolve target domain IPs in background
        new Thread(() -> {
            if (targetDomain != null && !targetDomain.isEmpty()) {
                try {
                    InetAddress[] addrs = InetAddress.getAllByName(targetDomain);
                    targetIps = new String[addrs.length];
                    for (int i = 0; i < addrs.length; i++) {
                        targetIps[i] = addrs[i].getHostAddress();
                    }
                    Log.d(TAG, "Resolved " + targetDomain + " to " + java.util.Arrays.toString(targetIps));
                } catch (Exception e) {
                    Log.e(TAG, "DNS resolution failed: " + e.getMessage());
                    targetIps = new String[0];
                }
            }
        }).start();

        // Build VPN interface
        Builder builder = new Builder();
        builder.setMtu(1500);
        builder.addAddress("10.0.0.2", 32);
        builder.addDnsServer("1.1.1.1");
        builder.addDnsServer("8.8.8.8");
        builder.addRoute("0.0.0.0", 0); // Intercept all IPv4 traffic
        builder.setSession("NetWatch VPN");

        // Allow our own app to bypass the VPN (avoid loops)
        builder.addDisallowedApplication(getPackageName());

        try {
            vpnInterface = builder.establish();
            Log.d(TAG, "VPN interface established");
        } catch (Exception e) {
            Log.e(TAG, "Failed to establish VPN: " + e.getMessage());
            return;
        }

        // Start packet capture thread
        captureThread = new Thread(this::capturePackets, "NetWatch-Capture");
        captureThread.start();
    }

    private void capturePackets() {
        FileInputStream in = new FileInputStream(vpnInterface.getFileDescriptor());
        FileOutputStream out = new FileOutputStream(vpnInterface.getFileDescriptor());

        ByteBuffer packet = ByteBuffer.allocate(32767);
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss", Locale.US);

        while (running.get()) {
            try {
                int len = in.read(packet.array());
                if (len <= 0) continue;

                packet.limit(len);
                packet.position(0);

                // Parse IP header (IPv4)
                if (len < 20) continue;
                int version = (packet.get(0) >> 4) & 0xF;
                if (version != 4) {
                    // Forward IPv6 as-is
                    out.write(packet.array(), 0, len);
                    continue;
                }

                int protocol = packet.get(9) & 0xFF;
                String protocolName = protocol == 6 ? "TCP" : protocol == 17 ? "UDP" : "IP-" + protocol;

                // Extract source and destination IPs
                byte[] srcBytes = new byte[4];
                byte[] dstBytes = new byte[4];
                packet.position(12);
                packet.get(srcBytes);
                packet.get(dstBytes);

                String srcIp = ipBytesToString(srcBytes);
                String dstIp = ipBytesToString(dstBytes);

                int srcPort = 0, dstPort = 0;
                int ipHeaderLen = (packet.get(0) & 0xF) * 4;

                if (protocol == 6 || protocol == 17) {
                    // TCP/UDP: ports are first 4 bytes of transport header
                    if (len >= ipHeaderLen + 4) {
                        srcPort = ((packet.get(ipHeaderLen) & 0xFF) << 8) | (packet.get(ipHeaderLen + 1) & 0xFF);
                        dstPort = ((packet.get(ipHeaderLen + 2) & 0xFF) << 8) | (packet.get(ipHeaderLen + 3) & 0xFF);
                    }
                }

                // Determine if this packet is to/from our monitored domain
                boolean isOutbound = srcIp.startsWith("10.0.0.");
                String remoteIp = isOutbound ? dstIp : srcIp;
                int remotePort = isOutbound ? dstPort : srcPort;

                boolean matchesDomain = isMatchingTarget(remoteIp, remotePort);

                if (matchesDomain && logCallback != null) {
                    int dataBytes = len - ipHeaderLen - (protocol == 6 ? 20 : 8);
                    if (dataBytes < 0) dataBytes = 0;

                    TrafficEntry entry = new TrafficEntry();
                    entry.direction = isOutbound ? "OUT" : "IN";
                    entry.protocol = protocolName;
                    entry.remoteIp = remoteIp;
                    entry.remoteHost = resolveHostname(remoteIp);
                    entry.remotePort = remotePort;
                    entry.bytes = dataBytes;
                    entry.timestamp = sdf.format(new Date());

                    logCallback.onEntry(entry);
                }

                // Forward the packet through (we're transparent)
                out.write(packet.array(), 0, len);
                packet.clear();

            } catch (Exception e) {
                if (running.get()) {
                    Log.e(TAG, "Packet capture error: " + e.getMessage());
                }
            }
        }
    }

    private boolean isMatchingTarget(String ip, int port) {
        if (targetIps == null || targetIps.length == 0) {
            // If no domain specified, monitor all traffic
            return port == 80 || port == 443 || port == 8080 || port == 8443;
        }
        for (String targetIp : targetIps) {
            if (targetIp.equals(ip)) return true;
        }
        // Also check common web ports to catch domain traffic before IP resolution
        if (port == 80 || port == 443) return true;
        return false;
    }

    private String resolveHostname(String ip) {
        // Quick reverse DNS (non-blocking cache)
        if (targetDomain != null && targetIps != null) {
            for (String tIp : targetIps) {
                if (tIp.equals(ip)) return targetDomain;
            }
        }
        // Try reverse lookup
        try {
            return InetAddress.getByName(ip).getHostName();
        } catch (Exception e) {
            return ip;
        }
    }

    private String ipBytesToString(byte[] bytes) {
        return (bytes[0] & 0xFF) + "." + (bytes[1] & 0xFF) + "." +
               (bytes[2] & 0xFF) + "." + (bytes[3] & 0xFF);
    }

    private void stopVpn() {
        running.set(false);
        if (captureThread != null) captureThread.interrupt();
        try {
            if (vpnInterface != null) vpnInterface.close();
        } catch (Exception e) {
            Log.e(TAG, "Error closing VPN: " + e.getMessage());
        }
        stopForeground(true);
        stopSelf();
    }

    @Override
    public void onDestroy() {
        stopVpn();
        super.onDestroy();
    }

    private Notification buildNotification() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(
                CHANNEL_ID,
                "NetWatch VPN",
                NotificationManager.IMPORTANCE_LOW
            );
            channel.setDescription("Traffic monitoring active");
            getSystemService(NotificationManager.class).createNotificationChannel(channel);
        }

        Intent stopIntent = new Intent(this, NetWatchVpnService.class);
        stopIntent.setAction("STOP");
        PendingIntent stopPI = PendingIntent.getService(this, 0, stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

        return new Notification.Builder(this, CHANNEL_ID)
            .setContentTitle("NetWatch Active")
            .setContentText("Monitoring: " + (targetDomain != null ? targetDomain : "all traffic"))
            .setSmallIcon(android.R.drawable.ic_menu_manage)
            .addAction(android.R.drawable.ic_delete, "Stop", stopPI)
            .build();
    }
}
