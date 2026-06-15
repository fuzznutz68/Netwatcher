package com.netwatch.app;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.net.TrafficStats;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.util.Log;
import androidx.core.view.accessibility.AccessibilityNodeInfoCompat;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import org.json.JSONArray;
import org.json.JSONObject;

/* loaded from: classes.dex */
public class TrafficMonitorService extends Service {
    public static final String ACTION_STOP = "com.netwatch.app.STOP_MONITOR";
    private static final String CHANNEL_ID = "netwatch_monitor";
    private static final LinkedHashMap<String, String[]> COMPANION_DOMAINS;
    private static final String DOMAIN_INTEL_URL = "https://superagent-cfb25b3e.base44.app/functions/domainIntel";
    public static final String EVENT_ACTION = "com.netwatch.app.TRAFFIC_EVENT";
    public static final String EXTRA_HOSTS = "hosts";
    public static final String EXTRA_RX_BYTES = "rx_bytes";
    public static final String EXTRA_RX_RATE = "rx_rate";
    public static final String EXTRA_TIMESTAMP = "timestamp";
    public static final String EXTRA_TX_BYTES = "tx_bytes";
    public static final String EXTRA_TX_RATE = "tx_rate";
    private static final String GEO_IP_URL = "https://superagent-cfb25b3e.base44.app/functions/geoIp";
    private static final int NOTIF_ID = 43;
    private static final long POLL_MS = 1000;
    private static final String TAG = "NetWatch";
    private int targetUid = -1;
    private String targetPkg = "";
    private String targetName = "";
    private boolean running = false;
    private long lastTx = -1;
    private long lastRx = -1;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private final ExecutorService ioExec = Executors.newFixedThreadPool(6);
    private final ConcurrentHashMap<String, String> dnsCache = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<String, String> geoCache = new ConcurrentHashMap<>();
    private final Set<String> submittedIps = Collections.synchronizedSet(new HashSet());
    private final Set<String> geoSubmitted = Collections.synchronizedSet(new HashSet());
    private final Set<String> submittedDomains = Collections.synchronizedSet(new HashSet());
    private final Set<String> broadcastHosts = Collections.synchronizedSet(new HashSet());
    private final Runnable pollRunnable = new Runnable() { // from class: com.netwatch.app.TrafficMonitorService.1
        @Override // java.lang.Runnable
        public void run() {
            if (TrafficMonitorService.this.running) {
                TrafficMonitorService.this.poll();
                TrafficMonitorService.this.handler.postDelayed(this, TrafficMonitorService.POLL_MS);
            }
        }
    };

    /* renamed from: com.netwatch.app.TrafficMonitorService$1 */
    /* loaded from: classes.dex */
    public class AnonymousClass1 implements Runnable {
        @Override // java.lang.Runnable
        public void run() {
            if (TrafficMonitorService.this.running) {
                TrafficMonitorService.this.poll();
                TrafficMonitorService.this.handler.postDelayed(this, TrafficMonitorService.POLL_MS);
            }
        }
    }

    static {
        LinkedHashMap<String, String[]> linkedHashMap = new LinkedHashMap<>();
        COMPANION_DOMAINS = linkedHashMap;
        linkedHashMap.put("openai", new String[]{"openai.com", "oaiusercontent.com", "oaidatastatic.com", "chatgpt.com", "cdn.openai.com", "auth0.openai.com"});
        linkedHashMap.put("google", new String[]{"google.com", "googleapis.com", "gstatic.com", "googleusercontent.com", "googlevideo.com", "ggpht.com", "googleadservices.com"});
        linkedHashMap.put("youtube", new String[]{"youtube.com", "youtu.be", "ytimg.com", "ggpht.com", "googlevideo.com", "googleapis.com"});
        linkedHashMap.put("facebook", new String[]{"facebook.com", "fbcdn.net", "instagram.com", "whatsapp.com", "cdninstagram.com", "fb.com"});
        linkedHashMap.put("instagram", new String[]{"instagram.com", "cdninstagram.com", "fbcdn.net", "facebook.com"});
        linkedHashMap.put("whatsapp", new String[]{"whatsapp.com", "whatsapp.net", "fbcdn.net"});
        linkedHashMap.put("microsoft", new String[]{"microsoft.com", "live.com", "office.com", "office365.com", "microsoftonline.com", "azure.com", "azureedge.net", "bing.com", "msn.com", "msocdn.com", "skype.com", "teams.microsoft.com"});
        linkedHashMap.put("teams", new String[]{"teams.microsoft.com", "microsoft.com", "live.com", "skype.com", "microsoftonline.com"});
        linkedHashMap.put("twitter", new String[]{"twitter.com", "x.com", "t.co", "twimg.com", "abs.twimg.com"});
        linkedHashMap.put("tiktok", new String[]{"tiktok.com", "tiktokcdn.com", "muscdn.com", "musical.ly", "byteoversea.com", "bytecdn.com"});
        linkedHashMap.put("snapchat", new String[]{"snapchat.com", "sc-cdn.net", "snap.com", "snapkit.com"});
        linkedHashMap.put("telegram", new String[]{"telegram.org", "t.me", "telesco.pe"});
        linkedHashMap.put("netflix", new String[]{"netflix.com", "nflxvideo.net", "nflximg.net", "nflxext.com", "netflixdns.net"});
        linkedHashMap.put("spotify", new String[]{"spotify.com", "scdn.co", "spotifycdn.com", "audio-sp.spotify.com"});
        linkedHashMap.put("amazon", new String[]{"amazon.com", "amazonaws.com", "cloudfront.net", "ssl-images-amazon.com", "media-amazon.com", "primevideo.com"});
        linkedHashMap.put("apple", new String[]{"apple.com", "icloud.com", "mzstatic.com", "aaplimg.com", "cdn-apple.com", "appleid.apple.com"});
        linkedHashMap.put("reddit", new String[]{"reddit.com", "redd.it", "redditmedia.com", "redditstatic.com", "reddituploads.com"});
        linkedHashMap.put("discord", new String[]{"discord.com", "discordapp.com", "discordcdn.com", "discord.gg"});
        linkedHashMap.put("linkedin", new String[]{"linkedin.com", "licdn.com"});
        linkedHashMap.put("twitch", new String[]{"twitch.tv", "twitchapps.com", "jtvnw.net", "twitchsvc.net", "amazonaws.com"});
        linkedHashMap.put("github", new String[]{"github.com", "githubusercontent.com", "githubassets.com", "github.io"});
        linkedHashMap.put("cloudflare", new String[]{"cloudflare.com", "cloudflare-dns.com", "1.1.1.1", "1.0.0.1"});
    }

    private void broadcastIpAsHost(String str) {
        String buildHostLine = buildHostLine(this.dnsCache.getOrDefault(str, str), this.geoCache.get(str));
        ArrayList arrayList = new ArrayList();
        arrayList.add(buildHostLine);
        broadcastNewHosts(arrayList);
    }

    private void broadcastNewHosts(List<String> list) {
        ArrayList arrayList = new ArrayList();
        for (String str : list) {
            if (str != null && !str.isEmpty()) {
                String trim = str.trim();
                if (!this.broadcastHosts.contains(trim)) {
                    this.broadcastHosts.add(trim);
                    arrayList.add(trim);
                }
            }
        }
        if (arrayList.isEmpty()) {
            return;
        }
        StringBuilder sb = new StringBuilder();
        Iterator it = arrayList.iterator();
        while (it.hasNext()) {
            sb.append((String) it.next());
            sb.append("\n");
        }
        Intent intent = new Intent(EVENT_ACTION);
        intent.setPackage(getPackageName());
        long j2 = this.lastTx;
        if (j2 == -1) {
            j2 = -1;
        }
        intent.putExtra(EXTRA_TX_BYTES, j2);
        long j3 = this.lastRx;
        intent.putExtra(EXTRA_RX_BYTES, j3 != -1 ? j3 : -1L);
        intent.putExtra(EXTRA_TX_RATE, 0L);
        intent.putExtra(EXTRA_RX_RATE, 0L);
        intent.putExtra(EXTRA_HOSTS, sb.toString().trim());
        intent.putExtra(EXTRA_TIMESTAMP, System.currentTimeMillis());
        sendBroadcast(intent);
    }

    private static String buildHostLine(String str, String str2) {
        if (str2 == null || str2.isEmpty()) {
            return str;
        }
        return str2 + "  " + str;
    }

    private Notification buildNotification() {
        String str;
        if (this.targetName.isEmpty()) {
            str = "Monitoring device traffic";
        } else {
            str = "Monitoring: " + this.targetName;
        }
        return new Notification.Builder(this, CHANNEL_ID).setContentTitle("🔍 NetWatch Active").setContentText(str).setSmallIcon(android.R.drawable.ic_menu_compass).build();
    }

    private List<String> companionDomainsForOrg(String str) {
        ArrayList arrayList = new ArrayList();
        if (str != null && !str.isEmpty()) {
            String lowerCase = str.toLowerCase(Locale.US);
            for (Map.Entry<String, String[]> entry : COMPANION_DOMAINS.entrySet()) {
                if (lowerCase.contains(entry.getKey())) {
                    for (String str2 : entry.getValue()) {
                        if (!this.submittedDomains.contains(str2)) {
                            arrayList.add(str2);
                        }
                    }
                }
            }
        }
        return arrayList;
    }

    private static List<String> companionDomainsForPackage(String str) {
        ArrayList arrayList = new ArrayList();
        if (str == null) {
            return arrayList;
        }
        String lowerCase = str.toLowerCase(Locale.US);
        for (Map.Entry<String, String[]> entry : COMPANION_DOMAINS.entrySet()) {
            if (lowerCase.contains(entry.getKey())) {
                for (String str2 : entry.getValue()) {
                    arrayList.add(str2);
                }
            }
        }
        return arrayList;
    }

    private void createChannel() {
        ((NotificationManager) getSystemService("notification")).createNotificationChannel(new NotificationChannel(CHANNEL_ID, "NetWatch Monitor", 2));
    }

    private void fetchGeoInBackground(List<String> list) {
        this.ioExec.submit(new androidx.constraintlayout.motion.widget.a(6, this, list));
    }

    private static String hexToIp(String str, boolean z) {
        try {
            int indexOf = str.indexOf(58);
            if (indexOf < 0) {
                return null;
            }
            String substring = str.substring(0, indexOf);
            if (!z) {
                long parseLong = Long.parseLong(substring, 16);
                return (parseLong & 255) + "." + ((parseLong >> 8) & 255) + "." + ((parseLong >> 16) & 255) + "." + ((parseLong >> 24) & 255);
            }
            if (substring.length() < 32) {
                return null;
            }
            byte[] bArr = new byte[16];
            for (int i2 = 0; i2 < 4; i2++) {
                int i3 = i2 * 8;
                long parseLong2 = Long.parseLong(substring.substring(i3, i3 + 8), 16);
                int i4 = i2 * 4;
                bArr[i4] = (byte) (parseLong2 & 255);
                bArr[i4 + 1] = (byte) ((parseLong2 >> 8) & 255);
                bArr[i4 + 2] = (byte) ((parseLong2 >> 16) & 255);
                bArr[i4 + 3] = (byte) ((parseLong2 >> 24) & 255);
            }
            return InetAddress.getByAddress(bArr).getHostAddress();
        } catch (Exception unused) {
            return null;
        }
    }

    public /* synthetic */ void lambda$fetchGeoInBackground$3(String str) {
        try {
            for (InetAddress inetAddress : InetAddress.getAllByName(str)) {
                String hostAddress = inetAddress.getHostAddress();
                this.dnsCache.put(hostAddress, str);
                this.submittedIps.add(hostAddress);
            }
        } catch (Exception unused) {
        }
    }

    public /* synthetic */ void lambda$fetchGeoInBackground$4(List list) {
        JSONObject optJSONObject;
        try {
            StringBuilder sb = new StringBuilder("{\"ips\":[");
            for (int i2 = 0; i2 < list.size(); i2++) {
                if (i2 > 0) {
                    sb.append(",");
                }
                sb.append("\"");
                sb.append((String) list.get(i2));
                sb.append("\"");
            }
            sb.append("]}");
            String postJson = postJson(GEO_IP_URL, sb.toString());
            if (postJson == null || (optJSONObject = new JSONObject(postJson).optJSONObject("results")) == null) {
                return;
            }
            Iterator it = list.iterator();
            while (it.hasNext()) {
                String str = (String) it.next();
                JSONObject optJSONObject2 = optJSONObject.optJSONObject(str);
                if (optJSONObject2 != null) {
                    String optString = optJSONObject2.optString("flag", "🌐");
                    String optString2 = optJSONObject2.optString("city", "");
                    String optString3 = optJSONObject2.optString("countryCode", "");
                    String replaceAll = optJSONObject2.optString("org", "").replaceAll("^AS\\d+\\s+", "");
                    StringBuilder sb2 = new StringBuilder(optString);
                    sb2.append(" ");
                    if (!optString2.isEmpty()) {
                        sb2.append(optString2);
                        sb2.append(", ");
                    }
                    sb2.append(optString3);
                    if (!replaceAll.isEmpty()) {
                        sb2.append(" · ");
                        sb2.append(replaceAll);
                    }
                    this.geoCache.put(str, sb2.toString());
                    broadcastIpAsHost(str);
                    if (!replaceAll.isEmpty()) {
                        List<String> companionDomainsForOrg = companionDomainsForOrg(replaceAll);
                        if (!companionDomainsForOrg.isEmpty()) {
                            for (String str2 : companionDomainsForOrg) {
                                this.submittedDomains.add(str2);
                                this.ioExec.submit(new z(this, str2, 2));
                            }
                            broadcastNewHosts(companionDomainsForOrg);
                        }
                    }
                }
            }
        } catch (Exception e2) {
            Log.w(TAG, "fetchGeo: " + e2.getMessage());
        }
    }

    public /* synthetic */ void lambda$poll$2(String str) {
        try {
            String hostName = InetAddress.getByName(str).getHostName();
            if (hostName.equals(str)) {
                hostName = str;
            }
            this.dnsCache.put(str, hostName);
            broadcastIpAsHost(str);
        } catch (Exception unused) {
            this.dnsCache.put(str, str);
            broadcastIpAsHost(str);
        }
    }

    public /* synthetic */ void lambda$seedDomainsFromBackend$0(String str, List list) {
        try {
            for (InetAddress inetAddress : InetAddress.getAllByName(str)) {
                String hostAddress = inetAddress.getHostAddress();
                this.dnsCache.put(hostAddress, str);
                this.submittedIps.add(hostAddress);
                synchronized (list) {
                    list.add(hostAddress);
                }
            }
        } catch (Exception unused) {
        }
    }

    public /* synthetic */ void lambda$seedDomainsFromBackend$1(String str) {
        String packageToRootDomain = packageToRootDomain(str);
        if (packageToRootDomain == null) {
            return;
        }
        try {
            String postJson = postJson(DOMAIN_INTEL_URL, "{\"domain\":\"" + packageToRootDomain + "\"}");
            if (postJson == null) {
                return;
            }
            JSONObject jSONObject = new JSONObject(postJson);
            ArrayList arrayList = new ArrayList();
            arrayList.add(packageToRootDomain);
            JSONArray optJSONArray = jSONObject.optJSONArray("subdomains");
            if (optJSONArray != null) {
                for (int i2 = 0; i2 < optJSONArray.length(); i2++) {
                    JSONObject optJSONObject = optJSONArray.optJSONObject(i2);
                    if (optJSONObject != null) {
                        String optString = optJSONObject.optString("name", "");
                        if (!optString.isEmpty()) {
                            arrayList.add(optString);
                        }
                    }
                }
            }
            ArrayList arrayList2 = new ArrayList();
            Iterator it = arrayList.iterator();
            while (it.hasNext()) {
                this.ioExec.submit(new g(this, (String) it.next(), arrayList2, 2));
            }
            broadcastNewHosts(arrayList);
        } catch (Exception e2) {
            Log.w(TAG, "seedDomains: " + e2.getMessage());
        }
    }

    private static String packageToRootDomain(String str) {
        if (str == null || str.isEmpty()) {
            return null;
        }
        String[] split = str.split("\\.");
        if (split.length < 2) {
            return null;
        }
        String str2 = split[0];
        String str3 = split[1];
        if ("com".equals(str2) || "org".equals(str2) || "io".equals(str2)) {
            return androidx.activity.result.a.e(str3, ".com");
        }
        return str3 + "." + str2;
    }

    private void parseProcNetFile(String str, boolean z, List<String> list) {
        try {
            BufferedReader bufferedReader = new BufferedReader(new FileReader(str));
            boolean z2 = true;
            while (true) {
                try {
                    String readLine = bufferedReader.readLine();
                    if (readLine == null) {
                        bufferedReader.close();
                        return;
                    }
                    if (z2) {
                        z2 = false;
                    } else {
                        String[] split = readLine.trim().split("\\s+");
                        if (split.length >= 4) {
                            String str2 = split[3];
                            if ("01".equals(str2) || "06".equals(str2) || "08".equals(str2)) {
                                if (this.targetUid != -1 && split.length >= 8) {
                                    try {
                                        if (Integer.parseInt(split[7]) != this.targetUid) {
                                        }
                                    } catch (Exception unused) {
                                    }
                                }
                                String str3 = split[2];
                                String hexToIp = hexToIp(str3, z);
                                if (hexToIp != null && !hexToIp.isEmpty() && !hexToIp.startsWith("0.0.0.0") && !hexToIp.startsWith("127.") && !hexToIp.equals("::1")) {
                                    if (Integer.parseInt(str3.contains(":") ? str3.substring(str3.indexOf(58) + 1) : "0", 16) != 0) {
                                        list.add(hexToIp);
                                    }
                                }
                            }
                        }
                    }
                } finally {
                }
            }
        } catch (Exception e2) {
            StringBuilder j2 = androidx.activity.result.a.j("parseProcNet ", str, ": ");
            j2.append(e2.getMessage());
            Log.w(TAG, j2.toString());
        }
    }

    public void poll() {
        long uidTxBytes;
        long uidRxBytes;
        long j2;
        int i2 = this.targetUid;
        long j3 = 0;
        if (i2 == -1) {
            uidTxBytes = TrafficStats.getTotalTxBytes();
            uidRxBytes = TrafficStats.getTotalRxBytes();
        } else {
            uidTxBytes = TrafficStats.getUidTxBytes(i2);
            uidRxBytes = TrafficStats.getUidRxBytes(this.targetUid);
            if (uidTxBytes == -1 || uidTxBytes < 0) {
                uidTxBytes = TrafficStats.getTotalTxBytes();
                uidRxBytes = TrafficStats.getTotalRxBytes();
            }
        }
        if (uidTxBytes < 0) {
            uidTxBytes = -1;
        }
        if (uidRxBytes < 0) {
            uidRxBytes = -1;
        }
        long j4 = this.lastTx;
        if (j4 == -1 || uidTxBytes == -1 || j4 < 0 || uidTxBytes < 0) {
            j2 = 0;
        } else {
            long max = Math.max(0L, uidTxBytes - j4);
            j2 = Math.max(0L, uidRxBytes - this.lastRx);
            j3 = max;
        }
        this.lastTx = uidTxBytes;
        this.lastRx = uidRxBytes;
        List<String> readAllEstablishedIps = readAllEstablishedIps();
        ArrayList arrayList = new ArrayList();
        for (String str : readAllEstablishedIps) {
            if (!this.geoSubmitted.contains(str)) {
                arrayList.add(str);
                this.geoSubmitted.add(str);
            }
        }
        if (!arrayList.isEmpty()) {
            fetchGeoInBackground(new ArrayList(arrayList));
        }
        for (String str2 : readAllEstablishedIps) {
            if (!this.submittedIps.contains(str2)) {
                this.submittedIps.add(str2);
                this.ioExec.submit(new z(this, str2, 1));
            }
        }
        for (String str3 : readAllEstablishedIps) {
            if (this.dnsCache.containsKey(str3)) {
                broadcastIpAsHost(str3);
            }
        }
        sendStatsBroadcast(uidTxBytes, uidRxBytes, j3, j2, "");
    }

    private static String postJson(String str, String str2) {
        try {
            HttpURLConnection httpURLConnection = (HttpURLConnection) new URL(str).openConnection();
            httpURLConnection.setRequestMethod("POST");
            httpURLConnection.setRequestProperty("Content-Type", "application/json");
            httpURLConnection.setDoOutput(true);
            httpURLConnection.setConnectTimeout(10000);
            httpURLConnection.setReadTimeout(AccessibilityNodeInfoCompat.EXTRA_DATA_TEXT_CHARACTER_LOCATION_ARG_MAX_LENGTH);
            OutputStream outputStream = httpURLConnection.getOutputStream();
            try {
                outputStream.write(str2.getBytes("UTF-8"));
                outputStream.close();
                int responseCode = httpURLConnection.getResponseCode();
                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader((responseCode < 200 || responseCode >= 300) ? httpURLConnection.getErrorStream() : httpURLConnection.getInputStream()));
                StringBuilder sb = new StringBuilder();
                while (true) {
                    String readLine = bufferedReader.readLine();
                    if (readLine == null) {
                        bufferedReader.close();
                        return sb.toString();
                    }
                    sb.append(readLine);
                }
            } finally {
            }
        } catch (Exception unused) {
            return null;
        }
    }

    private List<String> readAllEstablishedIps() {
        ArrayList arrayList = new ArrayList();
        parseProcNetFile("/proc/net/tcp", false, arrayList);
        parseProcNetFile("/proc/net/tcp6", true, arrayList);
        return new ArrayList(new LinkedHashSet(arrayList));
    }

    private void seedDomainsFromBackend(String str) {
        this.ioExec.submit(new z(this, str, 0));
    }

    private void sendStatsBroadcast(long j2, long j3, long j4, long j5, String str) {
        Intent intent = new Intent(EVENT_ACTION);
        intent.setPackage(getPackageName());
        if (j2 == -1) {
            j2 = -1;
        }
        intent.putExtra(EXTRA_TX_BYTES, j2);
        if (j3 == -1) {
            j3 = -1;
        }
        intent.putExtra(EXTRA_RX_BYTES, j3);
        intent.putExtra(EXTRA_TX_RATE, j4);
        intent.putExtra(EXTRA_RX_RATE, j5);
        if (str == null) {
            str = "";
        }
        intent.putExtra(EXTRA_HOSTS, str);
        intent.putExtra(EXTRA_TIMESTAMP, System.currentTimeMillis());
        sendBroadcast(intent);
    }

    @Override // android.app.Service
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override // android.app.Service
    public void onDestroy() {
        this.running = false;
        this.handler.removeCallbacks(this.pollRunnable);
        this.ioExec.shutdownNow();
        super.onDestroy();
    }

    @Override // android.app.Service
    public int onStartCommand(Intent intent, int i2, int i3) {
        if (intent != null && ACTION_STOP.equals(intent.getAction())) {
            stopSelf();
            return 2;
        }
        if (intent != null) {
            this.targetUid = intent.getIntExtra("target_uid", -1);
            String stringExtra = intent.getStringExtra("target_pkg");
            this.targetPkg = stringExtra;
            if (stringExtra == null) {
                this.targetPkg = "";
            }
            String stringExtra2 = intent.getStringExtra("target_name");
            this.targetName = stringExtra2;
            if (stringExtra2 == null) {
                this.targetName = "";
            }
        }
        createChannel();
        Notification buildNotification = buildNotification();
        if (Build.VERSION.SDK_INT >= 34) {
            startForeground(43, buildNotification, 1);
        } else {
            startForeground(43, buildNotification);
        }
        this.dnsCache.clear();
        this.geoCache.clear();
        this.submittedIps.clear();
        this.geoSubmitted.clear();
        this.broadcastHosts.clear();
        this.submittedDomains.clear();
        this.lastTx = -1L;
        this.lastRx = -1L;
        this.running = true;
        if (!this.targetPkg.isEmpty()) {
            seedDomainsFromBackend(this.targetPkg);
        }
        this.handler.post(this.pollRunnable);
        return 1;
    }
}
