package com.netwatch.app;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Intent;
import android.net.VpnService;
import android.os.Build;
import android.os.ParcelFileDescriptor;
import android.util.Log;
import androidx.constraintlayout.core.widgets.analyzer.BasicMeasure;
import androidx.core.internal.view.SupportMenu;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.DatagramPacket;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.DatagramChannel;
import java.nio.channels.SocketChannel;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/* loaded from: classes.dex */
public class NetWatchVpnService extends VpnService {
    public static final String ACTION_STOP = "com.netwatch.app.STOP_VPN";
    private static final String CHANNEL_ID = "netwatch_vpn";
    private static final int MTU = 1500;
    private static final int NOTIF_ID = 42;
    private static final String TAG = "NetWatchVPN";
    public static final String TRAFFIC_ACTION = "com.netwatch.app.DEVICE_TRAFFIC";
    private ExecutorService dnsExecutor;
    private ExecutorService ioPool;
    private ParcelFileDescriptor vpnInterface;
    private volatile boolean running = false;
    private final ConcurrentHashMap<String, String> dnsCache = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<String, Long> seenKeys = new ConcurrentHashMap<>();

    private Notification buildNotification() {
        return new Notification.Builder(this, CHANNEL_ID).setContentTitle("📶 NetWatch Device Monitor").setContentText("Monitoring all device connections").setSmallIcon(android.R.drawable.ic_menu_compass).build();
    }

    private static byte[] buildUdpReply(String str, int i2, String str2, int i3, byte[] bArr, int i4) {
        int i5 = i4 + 28;
        try {
            byte[] bArr2 = new byte[i5];
            bArr2[0] = 69;
            bArr2[1] = 0;
            bArr2[2] = (byte) (i5 >> 8);
            bArr2[3] = (byte) i5;
            bArr2[4] = 0;
            bArr2[5] = 0;
            bArr2[6] = 64;
            bArr2[7] = 0;
            bArr2[8] = 64;
            bArr2[9] = 17;
            byte[] address = InetAddress.getByName(str).getAddress();
            byte[] address2 = InetAddress.getByName(str2).getAddress();
            System.arraycopy(address, 0, bArr2, 12, 4);
            System.arraycopy(address2, 0, bArr2, 16, 4);
            int ipChecksum = ipChecksum(bArr2, 0, 20);
            bArr2[10] = (byte) (ipChecksum >> 8);
            bArr2[11] = (byte) ipChecksum;
            bArr2[20] = (byte) (i2 >> 8);
            bArr2[21] = (byte) i2;
            bArr2[22] = (byte) (i3 >> 8);
            bArr2[23] = (byte) i3;
            int i6 = i4 + 8;
            bArr2[24] = (byte) (i6 >> 8);
            bArr2[25] = (byte) i6;
            bArr2[26] = 0;
            bArr2[27] = 0;
            System.arraycopy(bArr, 0, bArr2, 28, i4);
            return bArr2;
        } catch (Exception unused) {
            return null;
        }
    }

    private void createNotificationChannel() {
        ((NotificationManager) getSystemService("notification")).createNotificationChannel(new NotificationChannel(CHANNEL_ID, "NetWatch VPN", 2));
    }

    private void emit(String str, String str2, String str3, int i2) {
        String format = new SimpleDateFormat("HH:mm:ss", Locale.US).format(new Date());
        Intent intent = new Intent("com.netwatch.app.DEVICE_TRAFFIC");
        intent.putExtra("protocol", str);
        intent.putExtra("host", str2);
        intent.putExtra("ipPort", str3 + ":" + i2);
        intent.putExtra(TrafficMonitorService.EXTRA_TIMESTAMP, format);
        intent.putExtra("app", "");
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
        StringBuilder j2 = androidx.activity.result.a.j("EMIT ", str, " ");
        if (str2.isEmpty()) {
            str2 = str3;
        }
        j2.append(str2);
        j2.append(":");
        j2.append(i2);
        Log.d(TAG, j2.toString());
    }

    private static byte[] extractUdpPayload(byte[] bArr, int i2, int i3) {
        int i4 = i2 + 8;
        if (i3 <= i4) {
            return null;
        }
        int i5 = i3 - i4;
        byte[] bArr2 = new byte[i5];
        System.arraycopy(bArr, i4, bArr2, 0, i5);
        return bArr2;
    }

    /* renamed from: forwardTcp */
    public void lambda$handleIPv4$0(byte[] bArr, int i2, String str, int i3, String str2, int i4, FileOutputStream fileOutputStream) {
        int i5 = (bArr[0] & 15) * 4;
        int i6 = (((bArr[i5 + 12] >> 4) & 15) * 4) + i5;
        int i7 = i2 - i6;
        byte b2 = bArr[i5 + 13];
        if (i7 <= 0) {
            try {
                fileOutputStream.write(bArr, 0, i2);
                return;
            } catch (Exception unused) {
                return;
            }
        }
        try {
            SocketChannel open = SocketChannel.open();
            protect(open.socket());
            open.socket().setSoTimeout(5000);
            open.connect(new InetSocketAddress(InetAddress.getByName(str2), i4));
            open.write(ByteBuffer.wrap(bArr, i6, i7));
            open.close();
        } catch (Exception e2) {
            Log.d(TAG, "TCP fwd error: " + e2.getMessage());
        }
    }

    /* renamed from: forwardUdp */
    public void lambda$handleIPv4$1(byte[] bArr, String str, int i2, String str2, int i3, FileOutputStream fileOutputStream, byte[] bArr2, int i4) {
        try {
            DatagramChannel open = DatagramChannel.open();
            protect(open.socket());
            open.socket().setSoTimeout(2000);
            open.send(ByteBuffer.wrap(bArr), new InetSocketAddress(InetAddress.getByName(str2), i3));
            ByteBuffer allocate = ByteBuffer.allocate(MTU);
            try {
                open.socket().setSoTimeout(2000);
                DatagramPacket datagramPacket = new DatagramPacket(allocate.array(), allocate.capacity());
                open.socket().receive(datagramPacket);
                byte[] buildUdpReply = buildUdpReply(str2, i3, str, i2, datagramPacket.getData(), datagramPacket.getLength());
                if (buildUdpReply != null) {
                    synchronized (fileOutputStream) {
                        fileOutputStream.write(buildUdpReply);
                    }
                }
            } catch (Exception unused) {
            }
            open.close();
        } catch (Exception e2) {
            Log.d(TAG, "UDP fwd error: " + e2.getMessage());
        }
    }

    private void handleIPv4(final byte[] bArr, final int i2, final FileOutputStream fileOutputStream) {
        final int i3 = (bArr[0] & 15) * 4;
        int i4 = bArr[9] & 255;
        if (i2 < i3 + 4) {
            fileOutputStream.write(bArr, 0, i2);
            return;
        }
        final String ipv4 = ipv4(bArr, 12);
        final String ipv42 = ipv4(bArr, 16);
        final int u16 = u16(bArr, i3);
        final int u162 = u16(bArr, i3 + 2);
        if (i4 != 6 && i4 != 17) {
            fileOutputStream.write(bArr, 0, i2);
            return;
        }
        if (ipv42.startsWith("127.") || ipv42.startsWith("224.") || ipv42.startsWith("239.") || ipv42.startsWith("255.") || ipv42.equals("0.0.0.0") || u162 == 0) {
            fileOutputStream.write(bArr, 0, i2);
            return;
        }
        String str = i4 == 6 ? "TCP" : "UDP";
        String str2 = str + ipv42 + ":" + u162;
        long currentTimeMillis = System.currentTimeMillis();
        Long l2 = this.seenKeys.get(str2);
        if (l2 == null || currentTimeMillis - l2.longValue() > 30000) {
            this.seenKeys.put(str2, Long.valueOf(currentTimeMillis));
            reportConnection(str, ipv42, u162);
        }
        if (i4 == 6) {
            this.ioPool.execute(new Runnable() { // from class: com.netwatch.app.x
                @Override // java.lang.Runnable
                public final void run() {
                    NetWatchVpnService.this.lambda$handleIPv4$0(bArr, i2, ipv4, u16, ipv42, u162, fileOutputStream);
                }
            });
            return;
        }
        final byte[] extractUdpPayload = extractUdpPayload(bArr, i3, i2);
        if (extractUdpPayload != null) {
            this.ioPool.execute(new Runnable() { // from class: com.netwatch.app.y
                @Override // java.lang.Runnable
                public final void run() {
                    NetWatchVpnService.this.lambda$handleIPv4$1(extractUdpPayload, ipv4, u16, ipv42, u162, fileOutputStream, bArr, i3);
                }
            });
        } else {
            fileOutputStream.write(bArr, 0, i2);
        }
    }

    private static int ipChecksum(byte[] bArr, int i2, int i3) {
        int i4 = 0;
        for (int i5 = i2; i5 < i2 + i3; i5 += 2) {
            i4 += ((bArr[i5] & 255) << 8) | (bArr[i5 + 1] & 255);
        }
        while (true) {
            int i6 = i4 >> 16;
            if (i6 == 0) {
                return (~i4) & SupportMenu.USER_MASK;
            }
            i4 = (65535 & i4) + i6;
        }
    }

    private static String ipv4(byte[] bArr, int i2) {
        return (bArr[i2] & 255) + "." + (bArr[i2 + 1] & 255) + "." + (bArr[i2 + 2] & 255) + "." + (bArr[i2 + 3] & 255);
    }

    public /* synthetic */ void lambda$reportConnection$2(String str, String str2, int i2) {
        try {
            String hostName = InetAddress.getByName(str).getHostName();
            this.dnsCache.put(str, hostName);
            if (hostName.equals(str)) {
                return;
            }
            emit(str2, hostName, str, i2);
        } catch (Exception unused) {
            this.dnsCache.put(str, str);
        }
    }

    private void reportConnection(String str, String str2, int i2) {
        String str3 = this.dnsCache.get(str2);
        emit(str, (str3 == null || str3.equals(str2)) ? "" : str3, str2, i2);
        if (str3 == null) {
            this.dnsExecutor.submit(new c(this, str2, str, i2));
        }
    }

    public void runVpn() {
        ParcelFileDescriptor parcelFileDescriptor;
        ParcelFileDescriptor establish;
        int read;
        try {
            try {
                try {
                    VpnService.Builder builder = new VpnService.Builder(this);
                    builder.setMtu(MTU);
                    builder.addAddress("10.99.0.1", 24);
                    builder.addRoute("0.0.0.0", 0);
                    builder.addDnsServer("8.8.8.8");
                    builder.addDnsServer("1.1.1.1");
                    builder.setSession("NetWatch");
                    builder.addDisallowedApplication(getPackageName());
                    establish = builder.establish();
                    this.vpnInterface = establish;
                } catch (Exception unused) {
                    return;
                }
            } catch (Exception e2) {
                if (this.running) {
                    Log.e(TAG, "VPN loop error", e2);
                }
                parcelFileDescriptor = this.vpnInterface;
                if (parcelFileDescriptor == null) {
                    return;
                }
            }
            if (establish == null) {
                Log.e(TAG, "establish() returned null — permission denied?");
                try {
                    ParcelFileDescriptor parcelFileDescriptor2 = this.vpnInterface;
                    if (parcelFileDescriptor2 != null) {
                        parcelFileDescriptor2.close();
                        return;
                    }
                    return;
                } catch (Exception unused2) {
                    return;
                }
            }
            Log.i(TAG, "VPN established");
            this.running = true;
            FileInputStream fileInputStream = new FileInputStream(this.vpnInterface.getFileDescriptor());
            FileOutputStream fileOutputStream = new FileOutputStream(this.vpnInterface.getFileDescriptor());
            byte[] bArr = new byte[1600];
            while (this.running && (read = fileInputStream.read(bArr)) >= 0) {
                if (read >= 20) {
                    byte[] bArr2 = new byte[read];
                    System.arraycopy(bArr, 0, bArr2, 0, read);
                    if (((bArr2[0] >> 4) & 15) == 4) {
                        handleIPv4(bArr2, read, fileOutputStream);
                    } else {
                        fileOutputStream.write(bArr2, 0, read);
                    }
                }
            }
            parcelFileDescriptor = this.vpnInterface;
            if (parcelFileDescriptor == null) {
                return;
            }
            parcelFileDescriptor.close();
        } finally {
            this.running = false;
            try {
                ParcelFileDescriptor parcelFileDescriptor3 = this.vpnInterface;
                if (parcelFileDescriptor3 != null) {
                    parcelFileDescriptor3.close();
                }
            } catch (Exception unused3) {
            }
        }
    }

    private static int u16(byte[] bArr, int i2) {
        return (bArr[i2 + 1] & 255) | ((bArr[i2] & 255) << 8);
    }

    @Override // android.app.Service
    public void onDestroy() {
        this.running = false;
        ExecutorService executorService = this.ioPool;
        if (executorService != null) {
            executorService.shutdownNow();
        }
        ExecutorService executorService2 = this.dnsExecutor;
        if (executorService2 != null) {
            executorService2.shutdownNow();
        }
        try {
            ParcelFileDescriptor parcelFileDescriptor = this.vpnInterface;
            if (parcelFileDescriptor != null) {
                parcelFileDescriptor.close();
            }
        } catch (Exception unused) {
        }
        super.onDestroy();
    }

    @Override // android.app.Service
    public int onStartCommand(Intent intent, int i2, int i3) {
        if (intent != null && ACTION_STOP.equals(intent.getAction())) {
            stopSelf();
            return 2;
        }
        createNotificationChannel();
        Notification buildNotification = buildNotification();
        if (Build.VERSION.SDK_INT >= 34) {
            startForeground(42, buildNotification, BasicMeasure.EXACTLY);
        } else {
            startForeground(42, buildNotification);
        }
        this.ioPool = Executors.newCachedThreadPool();
        this.dnsExecutor = Executors.newFixedThreadPool(4);
        this.ioPool.execute(new v(2, this));
        return 1;
    }
}
