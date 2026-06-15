package com.netwatch.app;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.IBinder;
import android.util.Log;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;
import java.io.BufferedReader;
import java.io.FileReader;
import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.function.Predicate;

/* loaded from: classes.dex */
public class DeviceMonitorService extends Service {
    public static final String ACTION_STOP = "com.netwatch.app.STOP_DEVICE_MON";
    private static final String CHANNEL_ID = "netwatch_dev";
    private static final int NOTIF_ID = 43;
    private static final String TAG = "NetWatchDev";
    public static final String TRAFFIC_ACTION = "com.netwatch.app.DEVICE_TRAFFIC";
    private ScheduledExecutorService dnsExecutor;
    private PackageManager pm;
    private ScheduledExecutorService scheduler;
    private final ConcurrentHashMap<String, Long> seen = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<Integer, String> uidCache = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<String, String> dnsCache = new ConcurrentHashMap<>();

    private Notification buildNotification() {
        return new Notification.Builder(this, CHANNEL_ID).setContentTitle("📶 NetWatch Device Monitor").setContentText("Monitoring all device connections").setSmallIcon(android.R.drawable.ic_menu_compass).build();
    }

    private void createNotificationChannel() {
        ((NotificationManager) getSystemService("notification")).createNotificationChannel(new NotificationChannel(CHANNEL_ID, "NetWatch Device Monitor", 2));
    }

    private void emit(String str, String str2, int i2, String str3, String str4) {
        String format = new SimpleDateFormat("HH:mm:ss", Locale.US).format(new Date());
        Intent intent = new Intent("com.netwatch.app.DEVICE_TRAFFIC");
        intent.putExtra("host", str);
        intent.putExtra("ipPort", str2 + ":" + i2);
        intent.putExtra("protocol", str3);
        intent.putExtra("app", str4);
        intent.putExtra(TrafficMonitorService.EXTRA_TIMESTAMP, format);
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
        StringBuilder j2 = new StringBuilder("EMIT ").append(str3).append(" ");
        if (str.isEmpty()) {
            str = str2;
        }
        j2.append(str);
        j2.append(":");
        j2.append(i2);
        j2.append(str4.isEmpty() ? "" : (" [" + str4 + "]"));
        Log.d(TAG, j2.toString());
    }

    private String getAppLabel(int i2) {
        String str = this.uidCache.get(Integer.valueOf(i2));
        if (str != null) {
            return str;
        }
        try {
            String[] packagesForUid = this.pm.getPackagesForUid(i2);
            if (packagesForUid != null && packagesForUid.length > 0) {
                String charSequence = this.pm.getApplicationLabel(this.pm.getApplicationInfo(packagesForUid[0], 0)).toString();
                this.uidCache.put(Integer.valueOf(i2), charSequence);
                return charSequence;
            }
        } catch (Exception unused) {
        }
        this.uidCache.put(Integer.valueOf(i2), "");
        return "";
    }

    private static byte[] hexStringToBytes(String str) {
        int length = str.length();
        byte[] bArr = new byte[length / 2];
        for (int i2 = 0; i2 < length; i2 += 2) {
            bArr[i2 / 2] = (byte) (Character.digit(str.charAt(i2 + 1), 16) + (Character.digit(str.charAt(i2), 16) << 4));
        }
        return bArr;
    }

    private static String hexToIPv4(String str) {
        if (str != null && str.length() == 8) {
            try {
                int parseLong = (int) Long.parseLong(str, 16);
                return (parseLong & 255) + "." + ((parseLong >> 8) & 255) + "." + ((parseLong >> 16) & 255) + "." + ((parseLong >> 24) & 255);
            } catch (NumberFormatException unused) {
            }
        }
        return null;
    }

    private static String hexToIPv6(String str) {
        if (str != null && str.length() == 32) {
            try {
                StringBuilder sb = new StringBuilder();
                for (int i2 = 0; i2 < 4; i2++) {
                    int i3 = i2 * 8;
                    for (int i4 = 3; i4 >= 0; i4--) {
                        int i5 = (i4 * 2) + i3;
                        sb.append((CharSequence) str, i5, i5 + 2);
                    }
                }
                StringBuilder sb2 = new StringBuilder();
                for (int i6 = 0; i6 < 8; i6++) {
                    int i7 = i6 * 4;
                    sb2.append((CharSequence) sb, i7, i7 + 4);
                }
                return InetAddress.getByAddress(hexStringToBytes(sb.toString())).getHostAddress();
            } catch (Exception unused) {
            }
        }
        return null;
    }

    public static /* synthetic */ boolean lambda$poll$0(long j2, Map.Entry entry) {
        return j2 - ((Long) entry.getValue()).longValue() > 15000;
    }

    public /* synthetic */ void lambda$resolveAndEmit$1(String str, int i2, String str2, String str3) {
        try {
            String hostName = InetAddress.getByName(str).getHostName();
            if (hostName.equals(str)) {
                this.dnsCache.put(str, str);
            } else {
                this.dnsCache.put(str, hostName);
                emit(hostName, str, i2, str2, str3);
            }
        } catch (Exception unused) {
            this.dnsCache.put(str, str);
        }
    }

    private void parseProcNetFile(String str, boolean z, boolean z2, long j2) {
        int i2;
        try {
            BufferedReader bufferedReader = new BufferedReader(new FileReader(str));
            boolean z3 = true;
            while (true) {
                try {
                    String readLine = bufferedReader.readLine();
                    if (readLine == null) {
                        bufferedReader.close();
                        return;
                    }
                    if (z3) {
                        z3 = false;
                    } else {
                        String trim = readLine.trim();
                        if (!trim.isEmpty()) {
                            String[] split = trim.split("\\s+");
                            if (split.length >= 8) {
                                String str2 = split[2];
                                String str3 = split[3];
                                try {
                                    i2 = Integer.parseInt(split[7]);
                                } catch (NumberFormatException unused) {
                                    i2 = -1;
                                }
                                if (z || !"0A".equalsIgnoreCase(str3)) {
                                    if (z || (!"07".equalsIgnoreCase(str3) && !"09".equalsIgnoreCase(str3))) {
                                        int indexOf = str2.indexOf(58);
                                        if (indexOf >= 0) {
                                            String substring = str2.substring(0, indexOf);
                                            try {
                                                int parseInt = Integer.parseInt(str2.substring(indexOf + 1), 16);
                                                if (parseInt != 0) {
                                                    String hexToIPv6 = z2 ? hexToIPv6(substring) : hexToIPv4(substring);
                                                    if (hexToIPv6 != null && !hexToIPv6.equals("0.0.0.0") && !hexToIPv6.equals("127.0.0.1") && !hexToIPv6.startsWith("::") && !hexToIPv6.equals("0:0:0:0:0:0:0:0")) {
                                                        String str4 = hexToIPv6 + ":" + parseInt;
                                                        if (this.seen.get(str4) == null) {
                                                            this.seen.put(str4, Long.valueOf(j2));
                                                            resolveAndEmit(hexToIPv6, parseInt, z ? "UDP" : "TCP", i2 >= 0 ? getAppLabel(i2) : "", j2);
                                                        } else {
                                                            this.seen.put(str4, Long.valueOf(j2));
                                                        }
                                                    }
                                                }
                                            } catch (NumberFormatException unused2) {
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                } finally {
                }
            }
        } catch (Exception unused3) {
        }
    }

    public void poll() {
        try {
            final long currentTimeMillis = System.currentTimeMillis();
            this.seen.entrySet().removeIf(new Predicate() { // from class: com.netwatch.app.a
                @Override // java.util.function.Predicate
                public final boolean test(Object obj) {
                    boolean lambda$poll$0;
                    lambda$poll$0 = DeviceMonitorService.lambda$poll$0(currentTimeMillis, (Map.Entry) obj);
                    return lambda$poll$0;
                }
            });
            parseProcNetFile("/proc/net/tcp", false, false, currentTimeMillis);
            parseProcNetFile("/proc/net/tcp6", false, true, currentTimeMillis);
            parseProcNetFile("/proc/net/udp", true, false, currentTimeMillis);
            parseProcNetFile("/proc/net/udp6", true, true, currentTimeMillis);
        } catch (Exception e2) {
            Log.e(TAG, "Poll error: " + e2.getMessage());
        }
    }

    private void resolveAndEmit(final String str, final int i2, final String str2, final String str3, long j2) {
        String str4 = this.dnsCache.get(str);
        if (str4 == null) {
            emit("", str, i2, str2, str3);
            this.dnsExecutor.submit(new Runnable() { // from class: com.netwatch.app.b
                @Override // java.lang.Runnable
                public final void run() {
                    DeviceMonitorService.this.lambda$resolveAndEmit$1(str, i2, str2, str3);
                }
            });
        } else {
            if (str4.equals(str)) {
                str4 = "";
            }
            emit(str4, str, i2, str2, str3);
        }
    }

    @Override // android.app.Service
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override // android.app.Service
    public void onDestroy() {
        ScheduledExecutorService scheduledExecutorService = this.scheduler;
        if (scheduledExecutorService != null) {
            scheduledExecutorService.shutdownNow();
        }
        ScheduledExecutorService scheduledExecutorService2 = this.dnsExecutor;
        if (scheduledExecutorService2 != null) {
            scheduledExecutorService2.shutdownNow();
        }
        super.onDestroy();
    }

    @Override // android.app.Service
    public int onStartCommand(Intent intent, int i2, int i3) {
        if (intent != null && ACTION_STOP.equals(intent.getAction())) {
            stopSelf();
            return 2;
        }
        this.pm = getPackageManager();
        createNotificationChannel();
        startForeground(43, buildNotification());
        this.dnsExecutor = Executors.newScheduledThreadPool(3);
        ScheduledExecutorService newSingleThreadScheduledExecutor = Executors.newSingleThreadScheduledExecutor();
        this.scheduler = newSingleThreadScheduledExecutor;
        newSingleThreadScheduledExecutor.scheduleWithFixedDelay(this::poll, 0L, 750L, TimeUnit.MILLISECONDS);
        return 1;
    }
}
