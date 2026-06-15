package com.netwatch.app;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.Typeface;
import android.net.Uri;
import android.net.VpnService;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewParent;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.PopupMenu;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.SpinnerAdapter;
import android.widget.TextView;
import android.widget.Toast;
import androidx.appcompat.widget.SwitchCompat;
import androidx.core.content.FileProvider;
import androidx.core.location.LocationRequestCompat;
import androidx.core.view.GravityCompat;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;
import androidx.vectordrawable.graphics.drawable.PathInterpolatorCompat;
import com.netwatch.app.MainActivity;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicBoolean;
import org.json.JSONArray;
import org.json.JSONObject;

/* loaded from: classes.dex */
public class MainActivity extends Activity {
    private static final LinkedHashMap<String, String[][]> CHECKER_DOMAINS;
    private static final String DOMAIN_INTEL_URL = "https://superagent-cfb25b3e.base44.app/functions/domainIntel";
    private static final int NOTIF_PERM_CODE = 1002;
    private static final String PREFS_NAME = "netwatch_prefs";
    private static final String PREF_LANG = "language";
    private static final String[][] SPEED_SERVERS = {new String[]{"🇺🇸 US East  (Linode Newark)", "http://speedtest.newark.linode.com", "linode"}, new String[]{"🇺🇸 US West  (Linode Fremont)", "http://speedtest.fremont.linode.com", "linode"}, new String[]{"🇨🇦 Canada   (Linode Toronto)", "http://speedtest.toronto.linode.com", "linode"}, new String[]{"🇬🇧 EU       (Linode London)", "http://speedtest.london.linode.com", "linode"}, new String[]{"🇩🇪 EU       (Linode Frankfurt)", "http://speedtest.frankfurt.linode.com", "linode"}, new String[]{"🇸🇬 Asia     (Linode Singapore)", "http://speedtest.singapore.linode.com", "linode"}, new String[]{"🇯🇵 Asia     (Linode Tokyo)", "http://speedtest.tokyo2.linode.com", "linode"}, new String[]{"🇺🇸 US NYC   (Ookla Armstrong)", "http://speedtest-ad-1.zoominternet.net:8080", "ookla"}, new String[]{"🇺🇸 US LA    (Ookla GeoLinks)", "http://la-ookla.geolinks.com:8080", "ookla"}, new String[]{"🇺🇸 US Chicago (Ookla Highline)", "http://stchi.highlinefast.com:8080", "ookla"}, new String[]{"🇺🇸 US Dallas (Ookla Frontier)", "http://dallas.tx.speedtest.frontier.com:8080", "ookla"}, new String[]{"🇺🇸 US Miami  (Ookla BlueStream)", "http://speedtest03.bluestreamfiber.net:8080", "ookla"}, new String[]{"🇺🇸 US Seattle (Ookla Ziply)", "http://speedtest1-sttlwawb.as20055.net:8080", "ookla"}, new String[]{"🇺🇸 US Atlanta (Ookla Point)", "http://speedtest14.point-broadband.com:8080", "ookla"}, new String[]{"🇷🇺 Russia   (MTS Moscow)", "http://speed.mts.ru", "linode"}, new String[]{"🌍 Global    (Cloudflare)", "https://speed.cloudflare.com", "cloudflare"}};
    private static final int VPN_REQUEST_CODE = 1001;
    private SwitchCompat alertSwitch;
    private ArrayAdapter<AppEntry> appAdapter;
    private Spinner appSpinner;
    private Button checkAllBtn;
    private Button checkCustomBtn;
    private LinearLayout checkResultsContainer;
    private TextView checkStatusText;
    private Button clearMonBtn;
    private TextView connectionCountText;
    private EditText customDomainInput;
    private Button deviceClearBtn;
    private TextView deviceCountText;
    private Button deviceExportBtn;
    private LinearLayout deviceHeaderRow;
    private LinearLayout deviceLogContainer;
    private BroadcastReceiver deviceReceiver;
    private ScrollView deviceScrollView;
    private TextView deviceStatusText;
    private TextView deviceTitleText;
    private Button deviceToggleBtn;
    private EditText domainInput;
    private Button exportDomainBtn;
    private Button exportTrafficBtn;
    private LinearLayout hostLogContainer;
    private ScrollView hostLogScroll;
    private TextView liveHostsLabel;
    private Button lookupBtn;
    private TextView monStatusText;
    private LinearLayout myInfoContainer;
    private TextView myInfoDescText;
    private Button myInfoRefreshBtn;
    private TextView myInfoTitleText;
    private LinearLayout resultsContainer;
    private TextView rxRateText;
    private TextView rxTotalText;
    private TextView selectAppLabel;
    private TextView speedDescText;
    private TextView speedDownText;
    private TextView speedPingText;
    private LinearLayout speedResultsContainer;
    private Button speedRunBtn;
    private Spinner speedServerSpinner;
    private TextView speedStatusText;
    private TextView speedTitleText;
    private TextView speedUpText;
    private Button startMonBtn;
    private TextView statusText;
    private Button stopCheckBtn;
    private Button stopMonBtn;
    private View tab1;
    private View tab2;
    private LinearLayout tab3;
    private View tab4;
    private ScrollView tab5;
    private View tab6;
    private Button tabCheckerBtn;
    private Button tabDeviceBtn;
    private Button tabDomainBtn;
    private Button tabMyInfoBtn;
    private Button tabSpeedBtn;
    private Button tabTrafficBtn;
    private BroadcastReceiver trafficReceiver;
    private TextView txRateText;
    private TextView txTotalText;
    private boolean deviceMonRunning = false;
    private final ArrayList<String[]> deviceLog = new ArrayList<>();
    private List<AppEntry> appList = new ArrayList();
    private AppEntry selectedApp = null;
    private boolean monitoring = false;
    private int hostCount = 0;
    private final Set<String> seenHosts = new HashSet();
    private final LinkedHashMap<String, String> trafficLogForExport = new LinkedHashMap<>();
    private String lastDomainForExport = "";
    private String lastIntelJsonForExport = "";
    private String lastProbeJsonForExport = "";
    private boolean speedRunning = false;
    private boolean alertsEnabled = true;
    private final AtomicBoolean checkRunning = new AtomicBoolean(false);
    private long lastKnownTx = -1;
    private long lastKnownRx = -1;
    private long lastKnownTxRate = 0;
    private long lastKnownRxRate = 0;
    private final Set<String> trustedDomains = Collections.synchronizedSet(new HashSet());
    private String monitoredRootDomain = "";
    private boolean isRussian = false;
    private final ExecutorService executor = Executors.newCachedThreadPool();
    private final Handler mainHandler = new Handler(Looper.getMainLooper());
    private final Map<String, TextView> checkerStatusViews = new LinkedHashMap();

    /* renamed from: com.netwatch.app.MainActivity$1 */
    /* loaded from: classes.dex */
    public class AnonymousClass1 implements AdapterView.OnItemSelectedListener {
        public /* synthetic */ void lambda$onItemSelected$0() {
            MainActivity mainActivity = MainActivity.this;
            mainActivity.launchApp(mainActivity.selectedApp.packageName);
        }

        @Override // android.widget.AdapterView.OnItemSelectedListener
        public void onItemSelected(AdapterView<?> adapterView, View view, int i2, long j2) {
            MainActivity mainActivity = MainActivity.this;
            mainActivity.selectedApp = mainActivity.appList.isEmpty() ? null : (AppEntry) MainActivity.this.appList.get(i2);
            if ("init".equals(MainActivity.this.appSpinner.getTag())) {
                MainActivity.this.appSpinner.setTag(null);
                return;
            }
            if (MainActivity.this.selectedApp == null || MainActivity.this.selectedApp.packageName.isEmpty()) {
                return;
            }
            if (MainActivity.this.monitoring) {
                MainActivity.this.stopMonitoring();
            }
            MainActivity mainActivity2 = MainActivity.this;
            mainActivity2.seedTrustedDomains(mainActivity2.selectedApp.packageName);
            MainActivity.this.startMonitoring();
            MainActivity.this.mainHandler.postDelayed(new v(0, this), 400L);
        }

        @Override // android.widget.AdapterView.OnItemSelectedListener
        public void onNothingSelected(AdapterView<?> adapterView) {
        }
    }

    /* renamed from: com.netwatch.app.MainActivity$2 */
    /* loaded from: classes.dex */
    public class AnonymousClass2 extends BroadcastReceiver {
        @Override // android.content.BroadcastReceiver
        public void onReceive(Context context, Intent intent) {
            MainActivity.this.updateStats(intent.getLongExtra(TrafficMonitorService.EXTRA_TX_BYTES, 0L), intent.getLongExtra(TrafficMonitorService.EXTRA_RX_BYTES, 0L), intent.getLongExtra(TrafficMonitorService.EXTRA_TX_RATE, 0L), intent.getLongExtra(TrafficMonitorService.EXTRA_RX_RATE, 0L), intent.getStringExtra(TrafficMonitorService.EXTRA_HOSTS));
        }
    }

    /* renamed from: com.netwatch.app.MainActivity$3 */
    /* loaded from: classes.dex */
    public class AnonymousClass3 extends BroadcastReceiver {
        public /* synthetic */ void lambda$onReceive$0() {
            MainActivity.this.refreshDeviceLog();
        }

        public /* synthetic */ void lambda$onReceive$1() {
            MainActivity.this.refreshDeviceLog();
        }

        @Override // android.content.BroadcastReceiver
        public void onReceive(Context context, Intent intent) {
            String stringExtra = intent.getStringExtra("protocol");
            String stringExtra2 = intent.getStringExtra("host");
            String stringExtra3 = intent.getStringExtra("ipPort");
            String stringExtra4 = intent.getStringExtra("app");
            String stringExtra5 = intent.getStringExtra(TrafficMonitorService.EXTRA_TIMESTAMP);
            if (stringExtra3 == null) {
                return;
            }
            if (stringExtra == null) {
                stringExtra = "?";
            }
            String str = stringExtra;
            String str2 = stringExtra4 != null ? stringExtra4 : "";
            String str3 = stringExtra5 != null ? stringExtra5 : "";
            final int i2 = 0;
            String str4 = (stringExtra2 == null || stringExtra2.isEmpty()) ? stringExtra3.split(":")[0] : stringExtra2;
            synchronized (MainActivity.this.deviceLog) {
                final int i3 = 1;
                if (stringExtra2 != null) {
                    try {
                        if (!stringExtra2.isEmpty()) {
                            Iterator it = MainActivity.this.deviceLog.iterator();
                            while (it.hasNext()) {
                                String[] strArr = (String[]) it.next();
                                if (strArr[2].equals(stringExtra3) && strArr[1].equals(stringExtra3.split(":")[0])) {
                                    strArr[1] = stringExtra2;
                                    MainActivity.this.runOnUiThread(new Runnable(this) { // from class: com.netwatch.app.w

                                        /* renamed from: c, reason: collision with root package name */
                                        public final /* synthetic */ MainActivity.AnonymousClass3 f302c;

                                        {
                                            this.f302c = this;
                                        }

                                        @Override // java.lang.Runnable
                                        public final void run() {
                                            int i4 = i2;
                                            MainActivity.AnonymousClass3 anonymousClass3 = this.f302c;
                                            switch (i4) {
                                                case 0:
                                                    anonymousClass3.lambda$onReceive$0();
                                                    return;
                                                default:
                                                    anonymousClass3.lambda$onReceive$1();
                                                    return;
                                            }
                                        }
                                    });
                                    return;
                                }
                            }
                        }
                    } catch (Throwable th) {
                        throw th;
                    }
                }
                MainActivity.this.deviceLog.add(new String[]{str4, str4, stringExtra3, str, str3, str2});
                MainActivity.this.runOnUiThread(new Runnable(this) { // from class: com.netwatch.app.w

                    /* renamed from: c, reason: collision with root package name */
                    public final /* synthetic */ MainActivity.AnonymousClass3 f302c;

                    {
                        this.f302c = this;
                    }

                    @Override // java.lang.Runnable
                    public final void run() {
                        int i4 = i3;
                        MainActivity.AnonymousClass3 anonymousClass3 = this.f302c;
                        switch (i4) {
                            case 0:
                                anonymousClass3.lambda$onReceive$0();
                                return;
                            default:
                                anonymousClass3.lambda$onReceive$1();
                                return;
                        }
                    }
                });
            }
        }
    }

    static {
        LinkedHashMap<String, String[][]> linkedHashMap = new LinkedHashMap<>();
        CHECKER_DOMAINS = linkedHashMap;
        linkedHashMap.put("🔵 Google", new String[][]{new String[]{"Google Search", "google.com"}, new String[]{"Google DNS", "8.8.8.8"}, new String[]{"Gmail", "mail.google.com"}, new String[]{"Google Drive", "drive.google.com"}, new String[]{"YouTube", "youtube.com"}, new String[]{"Google Play", "play.google.com"}, new String[]{"Google APIs", "googleapis.com"}});
        linkedHashMap.put("🟠 Microsoft", new String[][]{new String[]{"Bing", "bing.com"}, new String[]{"Outlook / Exchange", "outlook.office365.com"}, new String[]{"OneDrive", "onedrive.live.com"}, new String[]{"Teams", "teams.microsoft.com"}, new String[]{"Azure", "azure.microsoft.com"}, new String[]{"GitHub", "github.com"}, new String[]{"Microsoft CDN", "msftconnecttest.com"}});
        linkedHashMap.put("🟡 Cloudflare", new String[][]{new String[]{"Cloudflare DNS 1", "1.1.1.1"}, new String[]{"Cloudflare DNS 2", "1.0.0.1"}, new String[]{"Cloudflare Web", "cloudflare.com"}, new String[]{"WARP / DoH", "cloudflare-dns.com"}});
        linkedHashMap.put("🟣 Social & Messaging", new String[][]{new String[]{"Facebook", "facebook.com"}, new String[]{"Instagram", "instagram.com"}, new String[]{"WhatsApp", "web.whatsapp.com"}, new String[]{"Twitter / X", "x.com"}, new String[]{"Telegram", "telegram.org"}, new String[]{"LinkedIn", "linkedin.com"}, new String[]{"TikTok", "tiktok.com"}, new String[]{"Reddit", "reddit.com"}, new String[]{"Disqus", "disqus.com"}});
        linkedHashMap.put("🔴 Streaming", new String[][]{new String[]{"Netflix", "netflix.com"}, new String[]{"Spotify", "spotify.com"}, new String[]{"Twitch", "twitch.tv"}, new String[]{"Apple iCloud", "icloud.com"}});
        linkedHashMap.put("🟢 CDN / Infrastructure", new String[][]{new String[]{"Akamai", "akamai.com"}, new String[]{"Fastly", "fastly.com"}, new String[]{"Amazon AWS", "aws.amazon.com"}, new String[]{"Quad9 DNS", "9.9.9.9"}, new String[]{"OpenDNS", "208.67.222.222"}});
        linkedHashMap.put("🏦 Finance & Payments", new String[][]{new String[]{"PayPal", "paypal.com"}, new String[]{"Stripe", "stripe.com"}, new String[]{"Visa", "visa.com"}, new String[]{"Mastercard", "mastercard.com"}, new String[]{"Wise", "wise.com"}, new String[]{"Tangem", "tangem.com"}, new String[]{"Bitcoin", "bitcoin.org"}});
        linkedHashMap.put("🎮 Gaming", new String[][]{new String[]{"Xbox Live", "xbox.com"}, new String[]{"Xbox Services", "xboxlive.com"}, new String[]{"Xbox CDN", "xboxlive-ce-retail.com"}, new String[]{"Microsoft Game", "xgweb.com"}, new String[]{"PlayStation", "playstation.com"}, new String[]{"PSN Network", "psn.np.com"}, new String[]{"PS Store", "store.playstation.com"}, new String[]{"PS CDN", "dl.playstation.net"}, new String[]{"PS Auth", "auth.api.sonyentertainmentnetwork.com"}});
    }

    private void addCard(String str, String str2, String str3) {
        LinearLayout makeCardContainer = makeCardContainer();
        TextView textView = new TextView(this);
        textView.setText(str.toUpperCase());
        textView.setTextSize(11.0f);
        textView.setTextColor(Color.parseColor("#00E5FF"));
        textView.setTypeface(null, 1);
        textView.setPadding(0, 0, 0, dp(5));
        makeCardContainer.addView(textView);
        TextView textView2 = new TextView(this);
        textView2.setText(str2);
        textView2.setTextSize(14.0f);
        try {
            textView2.setTextColor(Color.parseColor(str3));
        } catch (Exception unused) {
            textView2.setTextColor(-1);
        }
        textView2.setTypeface(Typeface.MONOSPACE);
        makeCardContainer.addView(textView2);
        this.resultsContainer.addView(makeCardContainer);
    }

    private void addHostRow(final String str, final boolean z, String str2) {
        int i2 = (str.matches("\\d+\\.\\d+\\.\\d+\\.\\d+.*") || str.contains(":")) ? 1 : 0;
        boolean z2 = this.alertsEnabled && i2 == 0 && !isTrustedHost(str);
        if (z2) {
            fireAlert(str);
        }
        final LinearLayout linearLayout = new LinearLayout(this);
        linearLayout.setOrientation(0);
        linearLayout.setPadding(dp(6), dp(6), dp(6), dp(6));
        if (z2) {
            linearLayout.setBackgroundColor(Color.parseColor("#1A2A1A"));
        }
        final TextView textView = new TextView(this);
        textView.setText(z ? "●  " : "○  ");
        textView.setTextSize(13.0f);
        textView.setTextColor(Color.parseColor(z2 ? "#FF5252" : z ? "#66BB6A" : "#546E7A"));
        textView.setLayoutParams(new LinearLayout.LayoutParams(dp(26), -2));
        linearLayout.addView(textView);
        final TextView textView2 = new TextView(this);
        textView2.setText(str);
        textView2.setTextSize(i2 != 0 ? 12.0f : 14.0f);
        textView2.setTextColor(Color.parseColor(z2 ? "#FF8A80" : i2 != 0 ? "#90A4AE" : "#C8D8E8"));
        textView2.setTypeface(Typeface.MONOSPACE, i2 ^ 1);
        textView2.setLayoutParams(new LinearLayout.LayoutParams(0, -2, 1.0f));
        textView2.setEllipsize(TextUtils.TruncateAt.END);
        textView2.setSingleLine(true);
        linearLayout.addView(textView2);
        if (z2) {
            final TextView textView3 = new TextView(this);
            textView3.setText("⚠");
            textView3.setTextSize(13.0f);
            textView3.setTextColor(Color.parseColor("#FF5252"));
            textView3.setPadding(dp(4), 0, dp(4), 0);
            linearLayout.addView(textView3);
            final Button button = new Button(this);
            button.setText("✓");
            button.setTextSize(11.0f);
            button.setTextColor(-1);
            button.setPadding(dp(6), 0, dp(6), 0);
            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(dp(36), dp(28));
            layoutParams.setMargins(dp(2), 0, 0, 0);
            button.setLayoutParams(layoutParams);
            button.setBackgroundColor(Color.parseColor("#2E7D32"));
            button.setOnClickListener(new View.OnClickListener() { // from class: com.netwatch.app.f
                @Override // android.view.View.OnClickListener
                public final void onClick(View view) {
                    MainActivity.this.lambda$addHostRow$30(str, linearLayout, textView, z, textView2, textView3, button, view);
                }
            });
            linearLayout.addView(button);
        }
        TextView textView4 = new TextView(this);
        textView4.setText(str2);
        textView4.setTextSize(10.0f);
        textView4.setTextColor(Color.parseColor("#37474F"));
        textView4.setLayoutParams(new LinearLayout.LayoutParams(dp(46), -2));
        textView4.setGravity(GravityCompat.END);
        linearLayout.addView(textView4);
        View view = new View(this);
        view.setLayoutParams(new LinearLayout.LayoutParams(-1, 1));
        view.setBackgroundColor(Color.parseColor(z2 ? "#FF5252" : "#0D2137"));
        this.hostLogContainer.addView(linearLayout);
        this.hostLogContainer.addView(view);
    }

    private void addMyInfoCard(String str, String str2, String str3, String str4) {
        LinearLayout linearLayout = new LinearLayout(this);
        linearLayout.setOrientation(1);
        linearLayout.setBackgroundColor(Color.parseColor(str3));
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-1, -2);
        layoutParams.setMargins(0, 0, 0, 12);
        linearLayout.setLayoutParams(layoutParams);
        linearLayout.setPadding(28, 20, 28, 20);
        TextView textView = new TextView(this);
        textView.setText(str);
        textView.setTextColor(Color.parseColor(str4));
        textView.setTextSize(13.0f);
        textView.setTypeface(null, 1);
        textView.setPadding(0, 0, 0, 10);
        linearLayout.addView(textView);
        TextView textView2 = new TextView(this);
        textView2.setText(str2);
        textView2.setTextColor(-2039584);
        textView2.setTextSize(14.0f);
        textView2.setTypeface(Typeface.MONOSPACE);
        linearLayout.addView(textView2);
        this.myInfoContainer.addView(linearLayout);
    }

    private void addMyInfoRow(String str, String str2, String str3) {
        TextView textView = new TextView(this);
        textView.setText(str);
        textView.setTextColor(-5194043);
        textView.setTextSize(13.0f);
        textView.setPadding(12, 8, 12, 8);
        this.myInfoContainer.addView(textView);
    }

    private void addSubdomainsCard(JSONArray jSONArray) {
        LinearLayout makeCardContainer = makeCardContainer();
        TextView textView = new TextView(this);
        textView.setText("🌿  SUBDOMAINS  (" + jSONArray.length() + ")");
        textView.setTextSize(11.0f);
        textView.setTextColor(Color.parseColor("#00E5FF"));
        textView.setTypeface(null, 1);
        textView.setPadding(0, 0, 0, dp(6));
        makeCardContainer.addView(textView);
        for (int i2 = 0; i2 < jSONArray.length(); i2++) {
            try {
                JSONObject jSONObject = jSONArray.getJSONObject(i2);
                String optString = jSONObject.optString("name", "");
                JSONArray optJSONArray = jSONObject.optJSONArray("ips");
                TextView textView2 = new TextView(this);
                textView2.setText("▸  " + optString);
                textView2.setTextSize(14.0f);
                textView2.setTextColor(Color.parseColor("#80DEEA"));
                textView2.setTypeface(Typeface.MONOSPACE);
                textView2.setPadding(0, dp(4), 0, 0);
                makeCardContainer.addView(textView2);
                if (optJSONArray != null) {
                    StringBuilder sb = new StringBuilder();
                    for (int i3 = 0; i3 < optJSONArray.length(); i3++) {
                        String optString2 = optJSONArray.optString(i3);
                        if (optString2.matches("\\d+\\.\\d+\\.\\d+\\.\\d+")) {
                            if (sb.length() > 0) {
                                sb.append("  |  ");
                            }
                            sb.append(optString2);
                        }
                    }
                    if (sb.length() > 0) {
                        TextView textView3 = new TextView(this);
                        textView3.setText("   " + ((Object) sb));
                        textView3.setTextSize(12.0f);
                        textView3.setTextColor(Color.parseColor("#90A4AE"));
                        textView3.setTypeface(Typeface.MONOSPACE);
                        makeCardContainer.addView(textView3);
                    }
                }
                if (i2 < jSONArray.length() - 1) {
                    View view = new View(this);
                    LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-1, 1);
                    layoutParams.topMargin = dp(4);
                    layoutParams.bottomMargin = dp(2);
                    view.setLayoutParams(layoutParams);
                    view.setBackgroundColor(Color.parseColor("#1A3A5C"));
                    makeCardContainer.addView(view);
                }
            } catch (Exception unused) {
            }
        }
        this.resultsContainer.addView(makeCardContainer);
    }

    private void buildCheckerRows() {
        this.checkResultsContainer.removeAllViews();
        this.checkerStatusViews.clear();
        for (Map.Entry<String, String[][]> entry : CHECKER_DOMAINS.entrySet()) {
            TextView textView = new TextView(this);
            textView.setText(entry.getKey());
            textView.setTextColor(Color.parseColor("#00E5FF"));
            textView.setTextSize(12.0f);
            int i2 = 1;
            textView.setTypeface(null, 1);
            int i3 = -1;
            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-1, -2);
            layoutParams.setMargins(0, dp(10), 0, dp(4));
            textView.setLayoutParams(layoutParams);
            textView.setAllCaps(true);
            this.checkResultsContainer.addView(textView);
            String[][] value = entry.getValue();
            int length = value.length;
            int i4 = 0;
            while (i4 < length) {
                String[] strArr = value[i4];
                String str = strArr[0];
                String str2 = strArr[i2];
                LinearLayout linearLayout = new LinearLayout(this);
                linearLayout.setOrientation(0);
                linearLayout.setBackground(getDrawable(R.drawable.card_background));
                LinearLayout.LayoutParams layoutParams2 = new LinearLayout.LayoutParams(i3, -2);
                layoutParams2.setMargins(0, dp(2), 0, dp(2));
                linearLayout.setLayoutParams(layoutParams2);
                linearLayout.setPadding(dp(10), dp(8), dp(10), dp(8));
                TextView textView2 = new TextView(this);
                textView2.setText("●");
                textView2.setTextColor(Color.parseColor("#546E7A"));
                textView2.setTextSize(14.0f);
                textView2.setPadding(0, 0, dp(10), 0);
                linearLayout.addView(textView2);
                LinearLayout linearLayout2 = new LinearLayout(this);
                linearLayout2.setOrientation(i2);
                linearLayout2.setLayoutParams(new LinearLayout.LayoutParams(0, -2, 1.0f));
                TextView textView3 = new TextView(this);
                textView3.setText(str);
                textView3.setTextColor(Color.parseColor("#C8D8E8"));
                textView3.setTextSize(13.0f);
                TextView textView4 = new TextView(this);
                textView4.setText(str2);
                textView4.setTextColor(Color.parseColor("#607D8B"));
                textView4.setTextSize(11.0f);
                linearLayout2.addView(textView3);
                linearLayout2.addView(textView4);
                linearLayout.addView(linearLayout2);
                TextView textView5 = new TextView(this);
                textView5.setText("—");
                textView5.setTextColor(Color.parseColor("#546E7A"));
                textView5.setTextSize(12.0f);
                textView5.setGravity(8388629);
                linearLayout.addView(textView5);
                this.checkerStatusViews.put(str2, textView5);
                linearLayout.setTag(textView2);
                this.checkResultsContainer.addView(linearLayout);
                i4++;
                i2 = 1;
                i3 = -1;
            }
        }
    }

    private View buildDeviceRow(String str, String str2, String str3, String str4, String str5) {
        LinearLayout linearLayout = new LinearLayout(this);
        linearLayout.setOrientation(0);
        linearLayout.setPadding(dp(10), dp(8), dp(10), dp(8));
        linearLayout.setBackgroundColor(Color.parseColor(this.deviceLogContainer.getChildCount() % 2 == 0 ? "#0A0E17" : "#0D1320"));
        LinearLayout linearLayout2 = new LinearLayout(this);
        linearLayout2.setLayoutParams(new LinearLayout.LayoutParams(0, -2, 2.5f));
        linearLayout2.setOrientation(1);
        TextView textView = new TextView(this);
        textView.setText(str);
        textView.setTextSize(12.0f);
        textView.setTextColor(Color.parseColor("#E0E8F0"));
        textView.setMaxLines(1);
        TextUtils.TruncateAt truncateAt = TextUtils.TruncateAt.END;
        textView.setEllipsize(truncateAt);
        linearLayout2.addView(textView);
        if (!str.equals(str2.contains(":") ? str2.substring(0, str2.lastIndexOf(58)) : str2) && !str.equals(str2)) {
            TextView textView2 = new TextView(this);
            textView2.setText(str2);
            textView2.setTextSize(10.0f);
            textView2.setTextColor(Color.parseColor("#546E7A"));
            textView2.setMaxLines(1);
            textView2.setEllipsize(truncateAt);
            linearLayout2.addView(textView2);
        }
        if (str5 != null && !str5.isEmpty()) {
            TextView textView3 = new TextView(this);
            textView3.setText("📱 ".concat(str5));
            textView3.setTextSize(9.0f);
            textView3.setTextColor(Color.parseColor("#546E7A"));
            textView3.setMaxLines(1);
            textView3.setEllipsize(truncateAt);
            linearLayout2.addView(textView3);
        }
        linearLayout.addView(linearLayout2);
        String substring = str2.contains(":") ? str2.substring(str2.lastIndexOf(58) + 1) : "?";
        TextView textView4 = new TextView(this);
        textView4.setLayoutParams(new LinearLayout.LayoutParams(dp(46), -2));
        textView4.setText(substring);
        textView4.setTextSize(11.0f);
        textView4.setTextColor(Color.parseColor("#FFD740"));
        linearLayout.addView(textView4);
        TextView textView5 = new TextView(this);
        textView5.setLayoutParams(new LinearLayout.LayoutParams(dp(38), -2));
        textView5.setText(str3);
        textView5.setTextSize(11.0f);
        textView5.setTextColor(Color.parseColor("TCP".equals(str3) ? "#00E5FF" : "#B39DDB"));
        linearLayout.addView(textView5);
        TextView textView6 = new TextView(this);
        textView6.setLayoutParams(new LinearLayout.LayoutParams(dp(52), -2));
        textView6.setText(str4);
        textView6.setTextSize(10.0f);
        textView6.setTextColor(Color.parseColor("#37474F"));
        linearLayout.addView(textView6);
        return linearLayout;
    }

    private void buildReport(final String str, String str2, String str3) {
        JSONObject jSONObject;
        if (str2 != null) {
            try {
                jSONObject = new JSONObject(str2);
            } catch (Exception e2) {
                addCard("⚠  Parse Error", e2.getMessage(), "#EF9A9A");
                return;
            }
        } else {
            jSONObject = null;
        }
        if (str3 != null) {
            new JSONObject(str3);
        }
        if (jSONObject != null && jSONObject.has("error") && !jSONObject.has("ipv4")) {
            addCard("❌ Error", jSONObject.optString("error"), "#EF9A9A");
            return;
        }
        if (jSONObject != null) {
            JSONArray optJSONArray = jSONObject.optJSONArray("ipv4");
            JSONArray optJSONArray2 = jSONObject.optJSONArray("ipv6");
            final String optString = jSONObject.optString("cname", "");
            final ArrayList arrayList = new ArrayList();
            if (optJSONArray != null) {
                for (int i2 = 0; i2 < optJSONArray.length(); i2++) {
                    arrayList.add(optJSONArray.optString(i2));
                }
            }
            final ArrayList arrayList2 = new ArrayList();
            if (optJSONArray2 != null) {
                for (int i3 = 0; i3 < optJSONArray2.length(); i3++) {
                    arrayList2.add(optJSONArray2.optString(i3));
                }
            }
            this.executor.execute(new Runnable() { // from class: com.netwatch.app.q
                @Override // java.lang.Runnable
                public final void run() {
                    MainActivity.this.lambda$buildReport$35(arrayList, arrayList2, optString, str);
                }
            });
        }
        if (jSONObject != null) {
            JSONArray optJSONArray3 = jSONObject.optJSONArray("subdomains");
            if (optJSONArray3 == null || optJSONArray3.length() <= 0) {
                addCard("🌿  Subdomains", "None discovered", "#546E7A");
            } else {
                addSubdomainsCard(optJSONArray3);
            }
        }
        if (jSONObject != null) {
            JSONArray optJSONArray4 = jSONObject.optJSONArray("sharedHostDomains");
            if (optJSONArray4 == null || optJSONArray4.length() <= 0) {
                addCard("🕵️  Shared-Host", "None found", "#546E7A");
                return;
            }
            StringBuilder sb = new StringBuilder();
            for (int i4 = 0; i4 < optJSONArray4.length(); i4++) {
                sb.append("▸  ");
                sb.append(optJSONArray4.optString(i4));
                sb.append("\n");
            }
            addCard("🕵️  Shared-Host (" + optJSONArray4.length() + ")", sb.toString().trim(), "#FFCC80");
        }
    }

    private void checkCustomDomain() {
        final TextView textView;
        final TextView textView2;
        String trim = this.customDomainInput.getText().toString().trim();
        if (trim.isEmpty()) {
            showToast(this.isRussian ? "Введите домен или IP" : "Enter a domain or IP first");
            return;
        }
        final String replaceFirst = trim.replaceFirst("^https?://", "").replaceFirst("/.*$", "");
        InputMethodManager inputMethodManager = (InputMethodManager) getSystemService("input_method");
        if (inputMethodManager != null) {
            inputMethodManager.hideSoftInputFromWindow(this.customDomainInput.getWindowToken(), 0);
        }
        LinearLayout linearLayout = (LinearLayout) this.checkResultsContainer.findViewWithTag("custom_" + replaceFirst);
        if (linearLayout != null) {
            textView2 = (TextView) linearLayout.getTag();
            textView = (TextView) linearLayout.getChildAt(linearLayout.getChildCount() - 1);
            textView2.setTextColor(Color.parseColor("#FFC107"));
            textView.setText("…");
            textView.setTextColor(Color.parseColor("#90A4AE"));
        } else {
            if (this.checkResultsContainer.findViewWithTag("custom_header") == null) {
                TextView textView3 = new TextView(this);
                textView3.setTag("custom_header");
                textView3.setText("🔎  Custom Checks");
                textView3.setTextColor(Color.parseColor("#00E5FF"));
                textView3.setTextSize(12.0f);
                textView3.setTypeface(null, 1);
                textView3.setAllCaps(true);
                LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-1, -2);
                layoutParams.setMargins(0, dp(10), 0, dp(4));
                textView3.setLayoutParams(layoutParams);
                this.checkResultsContainer.addView(textView3, 0);
            }
            LinearLayout linearLayout2 = new LinearLayout(this);
            linearLayout2.setOrientation(0);
            linearLayout2.setBackground(getDrawable(R.drawable.card_background));
            linearLayout2.setTag("custom_" + replaceFirst);
            LinearLayout.LayoutParams layoutParams2 = new LinearLayout.LayoutParams(-1, -2);
            layoutParams2.setMargins(0, dp(2), 0, dp(2));
            linearLayout2.setLayoutParams(layoutParams2);
            linearLayout2.setPadding(dp(10), dp(8), dp(10), dp(8));
            TextView textView4 = new TextView(this);
            textView4.setText("●");
            textView4.setTextColor(Color.parseColor("#FFC107"));
            textView4.setTextSize(14.0f);
            textView4.setPadding(0, 0, dp(10), 0);
            linearLayout2.setTag(textView4);
            linearLayout2.addView(textView4);
            LinearLayout linearLayout3 = new LinearLayout(this);
            linearLayout3.setOrientation(1);
            linearLayout3.setLayoutParams(new LinearLayout.LayoutParams(0, -2, 1.0f));
            TextView textView5 = new TextView(this);
            textView5.setText(replaceFirst);
            textView5.setTextColor(Color.parseColor("#C8D8E8"));
            textView5.setTextSize(13.0f);
            TextView textView6 = new TextView(this);
            textView6.setText(replaceFirst.matches("\\d+\\.\\d+\\.\\d+\\.\\d+") ? "IP Address" : "Domain");
            textView6.setTextColor(Color.parseColor("#607D8B"));
            textView6.setTextSize(11.0f);
            linearLayout3.addView(textView5);
            linearLayout3.addView(textView6);
            linearLayout2.addView(linearLayout3);
            TextView textView7 = new TextView(this);
            textView7.setText("…");
            textView7.setTextColor(Color.parseColor("#90A4AE"));
            textView7.setTextSize(12.0f);
            textView7.setGravity(8388629);
            linearLayout2.addView(textView7);
            this.checkResultsContainer.addView(linearLayout2, 1);
            textView = textView7;
            textView2 = textView4;
        }
        TextView textView8 = this.checkStatusText;
        StringBuilder sb = new StringBuilder();
        sb.append(this.isRussian ? "Проверка " : "Checking ");
        sb.append(replaceFirst);
        sb.append("…");
        textView8.setText(sb.toString());
        this.checkStatusText.setTextColor(Color.parseColor("#00E5FF"));
        this.executor.execute(new Runnable() { // from class: com.netwatch.app.n
            @Override // java.lang.Runnable
            public final void run() {
                MainActivity.this.lambda$checkCustomDomain$44(replaceFirst, textView, textView2);
            }
        });
    }

    private void clearLog() {
        this.hostLogContainer.removeAllViews();
        this.hostCount = 0;
        this.seenHosts.clear();
        this.trafficLogForExport.clear();
        this.connectionCountText.setText("");
        this.txTotalText.setText("TX  —");
        this.rxTotalText.setText("RX  —");
        this.txRateText.setText("↑ 0 B/s");
        this.rxRateText.setText("↓ 0 B/s");
    }

    private String csv(String str) {
        if (str == null) {
            return "\"\"";
        }
        return "\"" + str.replace("\"", "\"\"") + "\"";
    }

    private int dp(int i2) {
        return (int) (i2 * getResources().getDisplayMetrics().density);
    }

    /* JADX DEBUG: Another duplicated slice has different insns count: {[]}, finally: {[INVOKE, MOVE_EXCEPTION, INVOKE, MOVE_EXCEPTION] complete} */
    private void exportDeviceCsv() {
        try {
            File file = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS), "NetWatch");
            if (!file.exists()) {
                file.mkdirs();
            }
            String str = "device_traffic_" + new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(new Date()) + ".csv";
            PrintWriter printWriter = new PrintWriter(new OutputStreamWriter(new FileOutputStream(new File(file, str)), "UTF-8"));
            try {
                printWriter.println("Domain/IP,IP:Port,Protocol,Timestamp,App");
                synchronized (this.deviceLog) {
                    try {
                        Iterator<String[]> it = this.deviceLog.iterator();
                        while (it.hasNext()) {
                            String[] next = it.next();
                            printWriter.println(csv(next[0]) + "," + csv(next[2]) + "," + csv(next[3]) + "," + csv(next[4]) + "," + csv(next.length > 5 ? next[5] : ""));
                        }
                    } finally {
                    }
                }
                printWriter.close();
                StringBuilder sb = new StringBuilder();
                sb.append(this.isRussian ? "Сохранено: " : "Saved: ");
                sb.append(str);
                Toast.makeText(this, sb.toString(), 1).show();
            } finally {
            }
        } catch (Exception e2) {
            StringBuilder sb2 = new StringBuilder();
            sb2.append(this.isRussian ? "Ошибка экспорта: " : "Export failed: ");
            sb2.append(e2.getMessage());
            Toast.makeText(this, sb2.toString(), 1).show();
        }
    }

    private void exportDomainIntel() {
        if (this.lastDomainForExport.isEmpty()) {
            showToast(this.isRussian ? "Сначала выполните сканирование" : "Run a scan first");
            return;
        }
        String format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(new Date());
        StringBuilder sb = new StringBuilder("field,value\n");
        sb.append(csv("report_type"));
        sb.append(",");
        sb.append(csv("NetWatch Domain Intelligence"));
        sb.append("\n");
        sb.append(csv("generated"));
        sb.append(",");
        sb.append(csv(format));
        sb.append("\n");
        sb.append(csv("domain"));
        sb.append(",");
        sb.append(csv(this.lastDomainForExport));
        sb.append("\n\n");
        try {
            if (!this.lastIntelJsonForExport.isEmpty()) {
                JSONObject jSONObject = new JSONObject(this.lastIntelJsonForExport);
                JSONArray optJSONArray = jSONObject.optJSONArray("ipv4");
                if (optJSONArray != null && optJSONArray.length() > 0) {
                    sb.append("record_type,value\n");
                    for (int i2 = 0; i2 < optJSONArray.length(); i2++) {
                        sb.append(csv("ipv4"));
                        sb.append(",");
                        sb.append(csv(optJSONArray.optString(i2)));
                        sb.append("\n");
                    }
                    sb.append("\n");
                }
                JSONArray optJSONArray2 = jSONObject.optJSONArray("ipv6");
                if (optJSONArray2 != null && optJSONArray2.length() > 0) {
                    sb.append("record_type,value\n");
                    for (int i3 = 0; i3 < optJSONArray2.length(); i3++) {
                        sb.append(csv("ipv6"));
                        sb.append(",");
                        sb.append(csv(optJSONArray2.optString(i3)));
                        sb.append("\n");
                    }
                    sb.append("\n");
                }
                String optString = jSONObject.optString("cname", "");
                if (!optString.isEmpty() && !optString.equals("null")) {
                    sb.append("record_type,value\n");
                    sb.append(csv("cname"));
                    sb.append(",");
                    sb.append(csv(optString));
                    sb.append("\n\n");
                }
                JSONArray optJSONArray3 = jSONObject.optJSONArray("subdomains");
                if (optJSONArray3 != null && optJSONArray3.length() > 0) {
                    sb.append("subdomain,ip\n");
                    for (int i4 = 0; i4 < optJSONArray3.length(); i4++) {
                        JSONObject jSONObject2 = optJSONArray3.getJSONObject(i4);
                        String optString2 = jSONObject2.optString("name", "");
                        JSONArray optJSONArray4 = jSONObject2.optJSONArray("ips");
                        String optString3 = (optJSONArray4 == null || optJSONArray4.length() <= 0) ? "" : optJSONArray4.optString(0);
                        sb.append(csv(optString2));
                        sb.append(",");
                        sb.append(csv(optString3));
                        sb.append("\n");
                    }
                    sb.append("\n");
                }
                JSONArray optJSONArray5 = jSONObject.optJSONArray("sharedHostDomains");
                if (optJSONArray5 != null && optJSONArray5.length() > 0) {
                    sb.append("shared_host_domain\n");
                    for (int i5 = 0; i5 < optJSONArray5.length(); i5++) {
                        sb.append(csv(optJSONArray5.optString(i5)));
                        sb.append("\n");
                    }
                    sb.append("\n");
                }
            }
        } catch (Exception e2) {
            sb.append(csv("error"));
            sb.append(",");
            sb.append(csv(e2.getMessage()));
            sb.append("\n");
        }
        shareCsv("NetWatch_" + this.lastDomainForExport + "_" + format.replace(" ", "_").replace(":", "") + ".csv", sb.toString());
    }

    private void exportTrafficLog() {
        if (this.trafficLogForExport.isEmpty()) {
            showToast(this.isRussian ? "Нет данных трафика для экспорта" : "No traffic data to export");
            return;
        }
        String format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(new Date());
        AppEntry appEntry = this.selectedApp;
        String str = appEntry != null ? appEntry.label : "Device";
        StringBuilder sb = new StringBuilder("timestamp,host_or_ip\n");
        for (Map.Entry<String, String> entry : this.trafficLogForExport.entrySet()) {
            sb.append(csv(entry.getValue()));
            sb.append(",");
            sb.append(csv(entry.getKey()));
            sb.append("\n");
        }
        shareCsv("NetWatch_Traffic_" + str.replaceAll("[^a-zA-Z0-9]", "_") + "_" + format.replace(" ", "_").replace(":", "") + ".csv", sb.toString());
    }

    private static String extractRootDomain(String str) {
        int lastIndexOf = str.lastIndexOf("  ");
        if (lastIndexOf >= 0) {
            str = str.substring(lastIndexOf + 2).trim();
        }
        String[] split = str.split("\\.");
        if (split.length < 2) {
            return str;
        }
        return split[split.length - 2] + "." + split[split.length - 1];
    }

    private void fireAlert(String str) {
        try {
            Vibrator vibrator = (Vibrator) getSystemService("vibrator");
            if (vibrator != null && vibrator.hasVibrator()) {
                vibrator.vibrate(VibrationEffect.createWaveform(new long[]{0, 120, 80, 180}, -1));
            }
        } catch (Exception unused) {
        }
        try {
            NotificationManager notificationManager = (NotificationManager) getSystemService("notification");
            NotificationChannel notificationChannel = new NotificationChannel("netwatch_alerts", "NetWatch Alerts", 4);
            notificationChannel.enableVibration(false);
            notificationManager.createNotificationChannel(notificationChannel);
            int lastIndexOf = str.lastIndexOf("  ");
            if (lastIndexOf >= 0) {
                str = str.substring(lastIndexOf + 2).trim();
            }
            notificationManager.notify((int) System.currentTimeMillis(), new Notification.Builder(this, "netwatch_alerts").setSmallIcon(android.R.drawable.ic_dialog_alert).setContentTitle("⚠ Unknown Connection Detected").setContentText(str).setAutoCancel(true).build());
        } catch (Exception unused2) {
        }
    }

    private static String formatBytes(long j2) {
        if (j2 < 0) {
            return "—";
        }
        if (j2 >= 1024) {
            return j2 < 1048576 ? String.format(Locale.US, "%.1f KB", Double.valueOf(j2 / 1024.0d)) : j2 < 1073741824 ? String.format(Locale.US, "%.2f MB", Double.valueOf(j2 / 1048576.0d)) : String.format(Locale.US, "%.2f GB", Double.valueOf(j2 / 1.073741824E9d));
        }
        return j2 + " B";
    }

    private static boolean isGlobalCdn(String str) {
        String[] strArr = {"google.com", "googleapis.com", "gstatic.com", "akamai.net", "akamaized.net", "cloudflare.com", "cloudflare.net", "fastly.net", "amazonaws.com", "cloudfront.net", "msedge.net", "microsoft.com", "apple.com", "icloud.com", "fbcdn.net", "twimg.com", "akamaitechnologies.com", "akamaiedge.net", "awsstatic.com", "mzstatic.com", "googlevideo.com", "googleusercontent.com", "android.com", "msftconnecttest.com"};
        for (int i2 = 0; i2 < 24; i2++) {
            if (str.equals(strArr[i2])) {
                return true;
            }
        }
        return false;
    }

    private boolean isTrustedHost(String str) {
        if (str == null || str.isEmpty()) {
            return true;
        }
        String lowerCase = str.toLowerCase();
        int lastIndexOf = lowerCase.lastIndexOf("  ");
        if (lastIndexOf >= 0) {
            lowerCase = lowerCase.substring(lastIndexOf + 2).trim();
        }
        for (String str2 : this.trustedDomains) {
            if (!lowerCase.equals(str2)) {
                if (lowerCase.endsWith("." + str2)) {
                }
            }
            return true;
        }
        return false;
    }

    public /* synthetic */ void lambda$addHostRow$30(String str, LinearLayout linearLayout, TextView textView, boolean z, TextView textView2, TextView textView3, Button button, View view) {
        String extractRootDomain = extractRootDomain(str);
        this.trustedDomains.add(extractRootDomain);
        this.trustedDomains.add(str);
        linearLayout.setBackgroundColor(0);
        textView.setTextColor(Color.parseColor(z ? "#66BB6A" : "#546E7A"));
        textView2.setTextColor(Color.parseColor("#C8D8E8"));
        textView3.setVisibility(8);
        button.setVisibility(8);
        showToast(androidx.activity.result.a.m(this.isRussian ? "✓ Доверенный: " : "✓ Trusted: ", extractRootDomain));
    }

    public /* synthetic */ void lambda$buildReport$34(String str, String str2) {
        if (str.length() > 0) {
            addCard(androidx.activity.result.a.m("🌐  ", str2), str, "#A5D6A7");
        }
    }

    public /* synthetic */ void lambda$buildReport$35(List list, List list2, String str, String str2) {
        byte[] readAllBytes;
        String str3;
        String str4;
        StringBuilder sb = new StringBuilder();
        Iterator it = list.iterator();
        while (it.hasNext()) {
            String str5 = (String) it.next();
            sb.append("IPv4:  ");
            sb.append(str5);
            try {
                HttpURLConnection httpURLConnection = (HttpURLConnection) new URL("https://ipinfo.io/" + str5 + "/json").openConnection();
                httpURLConnection.setRequestProperty("Accept", "application/json");
                httpURLConnection.setConnectTimeout(5000);
                httpURLConnection.setReadTimeout(5000);
                readAllBytes = httpURLConnection.getInputStream().readAllBytes();
                JSONObject jSONObject = new JSONObject(new String(readAllBytes, "UTF-8").trim());
                httpURLConnection.disconnect();
                String optString = jSONObject.optString("country", "");
                String optString2 = jSONObject.optString("city", "");
                String optString3 = jSONObject.optString("org", "");
                try {
                    str3 = new Locale("", optString).getDisplayCountry();
                } catch (Exception unused) {
                    str3 = optString;
                }
                if (optString.length() == 2) {
                    str4 = new String(Character.toChars(optString.charAt(0) - 3675)) + new String(Character.toChars(optString.charAt(1) - 3675));
                } else {
                    str4 = "";
                }
                if (!str3.isEmpty()) {
                    sb.append("  ");
                    sb.append(str4);
                    sb.append(" ");
                    sb.append(str3);
                }
                if (!optString2.isEmpty()) {
                    sb.append(", ");
                    sb.append(optString2);
                }
                if (!optString3.isEmpty()) {
                    sb.append("\n       ");
                    sb.append(optString3);
                }
            } catch (Exception unused2) {
            }
            sb.append("\n");
        }
        Iterator it2 = list2.iterator();
        while (it2.hasNext()) {
            String str6 = (String) it2.next();
            sb.append("IPv6:  ");
            sb.append(str6);
            sb.append("\n");
        }
        if (!str.isEmpty() && !str.equals("null")) {
            sb.append("CNAME: ");
            sb.append(str);
        }
        this.mainHandler.post(new g(this, sb.toString().trim(), str2, 0));
    }

    public /* synthetic */ void lambda$checkCustomDomain$43(TextView textView, boolean z, long j2, TextView textView2, String str) {
        String str2;
        String str3;
        if (z) {
            str2 = j2 + " ms";
        } else {
            str2 = "BLOCKED";
        }
        textView.setText(str2);
        textView.setTextColor(z ? Color.parseColor("#66BB6A") : Color.parseColor("#EF5350"));
        textView2.setTextColor(z ? Color.parseColor("#66BB6A") : Color.parseColor("#EF5350"));
        TextView textView3 = this.checkStatusText;
        StringBuilder h2 = androidx.activity.result.a.h(str);
        if (z) {
            str3 = " ✅  reachable in " + j2 + " ms";
        } else {
            str3 = " 🚫  appears BLOCKED";
        }
        h2.append(str3);
        textView3.setText(h2.toString());
        this.checkStatusText.setTextColor(z ? Color.parseColor("#66BB6A") : Color.parseColor("#EF9A9A"));
        ((ScrollView) this.checkResultsContainer.getParent()).smoothScrollTo(0, 0);
    }

    public /* synthetic */ void lambda$checkCustomDomain$44(final String str, final TextView textView, final TextView textView2) {
        long[] probeHost = probeHost(str);
        final boolean z = probeHost[0] == 1;
        final long j2 = probeHost[1];
        this.mainHandler.post(new Runnable() { // from class: com.netwatch.app.m
            @Override // java.lang.Runnable
            public final void run() {
                MainActivity.this.lambda$checkCustomDomain$43(textView, z, j2, textView2, str);
            }
        });
    }

    public static /* synthetic */ int lambda$loadAppList$26(AppEntry appEntry, AppEntry appEntry2) {
        return appEntry.label.compareToIgnoreCase(appEntry2.label);
    }

    public /* synthetic */ void lambda$loadAppList$27() {
        ArrayAdapter<AppEntry> arrayAdapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, this.appList);
        this.appAdapter = arrayAdapter;
        arrayAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        this.appSpinner.setAdapter((SpinnerAdapter) this.appAdapter);
        if (this.appList.isEmpty()) {
            return;
        }
        this.selectedApp = this.appList.get(0);
    }

    public /* synthetic */ void lambda$loadAppList$28() {
        PackageManager packageManager = getPackageManager();
        List<ApplicationInfo> installedApplications = packageManager.getInstalledApplications(128);
        ArrayList arrayList = new ArrayList();
        Iterator<ApplicationInfo> it = installedApplications.iterator();
        while (true) {
            if (!it.hasNext()) {
                Collections.sort(arrayList, new com.google.android.material.color.utilities.i(1));
                this.appList = arrayList;
                this.mainHandler.post(new l(this, 0));
                return;
            }
            ApplicationInfo next = it.next();
            if (packageManager.getLaunchIntentForPackage(next.packageName) != null) {
                int i2 = next.flags;
                boolean z = (i2 & 1) != 0;
                boolean z2 = (i2 & 128) != 0;
                if (!z || z2) {
                    String str = next.packageName;
                    if (!str.startsWith("com.android.") && !str.startsWith("android.") && !str.equals("android") && !str.startsWith("com.qualcomm.") && !str.startsWith("com.mediatek.") && !str.startsWith("com.sec.android.") && !str.equals("com.google.android.gms") && !str.equals("com.google.android.gsf") && !str.equals("com.google.android.providers.media.module") && !str.startsWith("com.google.android.permissioncontroller") && !str.startsWith("com.google.android.ext.") && !str.startsWith("com.google.android.trichromelibrary")) {
                        arrayList.add(new AppEntry(packageManager.getApplicationLabel(next).toString(), next.packageName, next.uid));
                    }
                }
            }
        }
    }

    public /* synthetic */ void lambda$lookupMyInfo$36(String str, View view) {
        Intent intent = new Intent("android.intent.action.VIEW", Uri.parse(str));
        intent.addFlags(268435456);
        Intent createChooser = Intent.createChooser(intent, this.isRussian ? "Открыть в приложении карт" : "Open with maps app");
        if (intent.resolveActivity(getPackageManager()) != null) {
            startActivity(createChooser);
        } else {
            showToast(this.isRussian ? "Приложение карт не найдено" : "No maps app found");
        }
    }

    public /* synthetic */ void lambda$lookupMyInfo$37(String str, String str2, String str3, String str4, String str5, String str6, String str7, String str8, String str9, String str10, String str11, String str12) {
        this.myInfoContainer.removeAllViews();
        this.myInfoRefreshBtn.setEnabled(true);
        addMyInfoCard("🔌  Public IP Address", str, "#001020", "#00E5FF");
        if (str2 == null) {
            addMyInfoRow("Could not reach the internet. Check your connection.", "", "#0D1117");
            return;
        }
        StringBuilder sb = new StringBuilder();
        if (!str3.isEmpty()) {
            sb.append("ISP:  ");
            sb.append(str3);
        }
        if (!str4.isEmpty() && !str4.equals(str3)) {
            if (sb.length() > 0) {
                sb.append("\n");
            }
            sb.append("Org:  ");
            sb.append(str4);
        }
        if (sb.length() > 0) {
            addMyInfoCard("🏢  Provider", sb.toString(), "#001A0E", "#00FF88");
        }
        StringBuilder sb2 = new StringBuilder();
        if (!str5.isEmpty()) {
            sb2.append("City:      ");
            sb2.append(str5);
        }
        if (!str6.isEmpty()) {
            if (sb2.length() > 0) {
                sb2.append("\n");
            }
            sb2.append("ZIP:       ");
            sb2.append(str6);
        }
        if (!str7.isEmpty()) {
            if (sb2.length() > 0) {
                sb2.append("\n");
            }
            sb2.append("Region:    ");
            sb2.append(str7);
        }
        if (!str8.isEmpty()) {
            if (sb2.length() > 0) {
                sb2.append("\n");
            }
            sb2.append("Country:   ");
            sb2.append(str9);
            sb2.append("  ");
            sb2.append(str8);
        }
        if (!str10.isEmpty() && !str11.isEmpty() && !str10.equals("0.0")) {
            if (sb2.length() > 0) {
                sb2.append("\n");
            }
            sb2.append("Coords:    ");
            sb2.append(str10);
            sb2.append(", ");
            sb2.append(str11);
        }
        if (sb2.length() > 0) {
            addMyInfoCard("📍  Geolocation", sb2.toString(), "#0A0020", "#B060FF");
        }
        if (!str12.isEmpty()) {
            addMyInfoCard("🕐  Timezone", str12, "#0A1A12", "#00E5CC");
        }
        if (str10.isEmpty() || str11.isEmpty() || str10.equals("0.0")) {
            return;
        }
        Button button = new Button(this);
        button.setText(this.isRussian ? "📍  Открыть на карте" : "📍  Open in Maps");
        button.setTextColor(-1);
        button.setBackground(getResources().getDrawable(R.drawable.btn_primary));
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-1, -2);
        layoutParams.setMargins(0, 12, 0, 0);
        button.setLayoutParams(layoutParams);
        button.setOnClickListener(new com.google.android.material.snackbar.a(1, this, "geo:" + str10 + "," + str11 + "?q=" + str10 + "," + str11 + "(" + str + ")"));
        this.myInfoContainer.addView(button);
    }

    /* JADX WARN: Removed duplicated region for block: B:13:0x0142  */
    /* JADX WARN: Removed duplicated region for block: B:9:0x0140  */
    /*
        Code decompiled incorrectly, please refer to instructions dump.
    */
    public /* synthetic */ void lambda$lookupMyInfo$38() {
        String str;
        String str2;
        String str3;
        String str4;
        String str5;
        String str6;
        String str7;
        String str8;
        final String str9;
        final String str10;
        final String str11;
        final String str12;
        final String str13;
        final String str14;
        final String str15;
        final String str16;
        final String str17;
        byte[] readAllBytes;
        JSONObject jSONObject;
        String optString;
        byte[] readAllBytes2;
        try {
            HttpURLConnection httpURLConnection = (HttpURLConnection) new URL("https://api.ipify.org").openConnection();
            httpURLConnection.setConnectTimeout(5000);
            httpURLConnection.setReadTimeout(5000);
            readAllBytes2 = httpURLConnection.getInputStream().readAllBytes();
            str = new String(readAllBytes2, "UTF-8").trim();
            httpURLConnection.disconnect();
        } catch (Exception unused) {
            str = null;
        }
        final String str18 = str;
        String str19 = "";
        if (str18 != null) {
            try {
                HttpURLConnection httpURLConnection2 = (HttpURLConnection) new URL("https://ipinfo.io/" + str18 + "/json").openConnection();
                httpURLConnection2.setRequestProperty("Accept", "application/json");
                httpURLConnection2.setConnectTimeout(6000);
                httpURLConnection2.setReadTimeout(6000);
                readAllBytes = httpURLConnection2.getInputStream().readAllBytes();
                String trim = new String(readAllBytes, "UTF-8").trim();
                httpURLConnection2.disconnect();
                jSONObject = new JSONObject(trim);
                optString = jSONObject.optString("org", "");
                try {
                    str3 = jSONObject.optString("city", "");
                } catch (Exception unused2) {
                    str2 = "";
                    str3 = str2;
                    str4 = str3;
                }
            } catch (Exception unused3) {
                str2 = "";
                str3 = str2;
                str4 = str3;
                str5 = str4;
                str6 = str5;
                str7 = str6;
                str8 = str7;
            }
            try {
                str4 = jSONObject.optString("region", "");
            } catch (Exception unused4) {
                str2 = "";
                str4 = str2;
                str5 = str4;
                str6 = str5;
                str7 = str6;
                str8 = str7;
                str19 = optString;
                str9 = str2;
                str10 = "🌐";
                str11 = str4;
                str12 = str5;
                str13 = str7;
                str14 = str8;
                str15 = str3;
                str16 = str6;
                str17 = str19;
                if (str18 != null) {
                }
                runOnUiThread(new Runnable() { // from class: com.netwatch.app.o
                    @Override // java.lang.Runnable
                    public final void run() {
                        MainActivity.this.lambda$lookupMyInfo$37(r2, str18, str17, "", str15, str16, str11, str12, str10, str14, str9, str13);
                    }
                });
            }
            try {
                str5 = jSONObject.optString("country", "");
                try {
                    str6 = jSONObject.optString("postal", "");
                } catch (Exception unused5) {
                    str2 = "";
                    str6 = str2;
                    str7 = str6;
                    str8 = str7;
                    str19 = optString;
                    str9 = str2;
                    str10 = "🌐";
                    str11 = str4;
                    str12 = str5;
                    str13 = str7;
                    str14 = str8;
                    str15 = str3;
                    str16 = str6;
                    str17 = str19;
                    if (str18 != null) {
                    }
                    runOnUiThread(new Runnable() { // from class: com.netwatch.app.o
                        @Override // java.lang.Runnable
                        public final void run() {
                            MainActivity.this.lambda$lookupMyInfo$37(r2, str18, str17, "", str15, str16, str11, str12, str10, str14, str9, str13);
                        }
                    });
                }
                try {
                    str7 = jSONObject.optString("timezone", "");
                    try {
                        String optString2 = jSONObject.optString("loc", "");
                        if (optString2.contains(",")) {
                            str8 = optString2.split(",")[0].trim();
                            try {
                                str2 = optString2.split(",")[1].trim();
                            } catch (Exception unused6) {
                                str2 = "";
                                str19 = optString;
                                str9 = str2;
                                str10 = "🌐";
                                str11 = str4;
                                str12 = str5;
                                str13 = str7;
                                str14 = str8;
                                str15 = str3;
                                str16 = str6;
                                str17 = str19;
                                if (str18 != null) {
                                }
                                runOnUiThread(new Runnable() { // from class: com.netwatch.app.o
                                    @Override // java.lang.Runnable
                                    public final void run() {
                                        MainActivity.this.lambda$lookupMyInfo$37(r2, str18, str17, "", str15, str16, str11, str12, str10, str14, str9, str13);
                                    }
                                });
                            }
                        } else {
                            str2 = "";
                            str8 = str2;
                        }
                        try {
                            new Locale("", str5).getDisplayCountry();
                        } catch (Exception unused7) {
                        }
                    } catch (Exception unused8) {
                        str2 = "";
                        str8 = str2;
                    }
                } catch (Exception unused9) {
                    str2 = "";
                    str7 = str2;
                    str8 = str7;
                    str19 = optString;
                    str9 = str2;
                    str10 = "🌐";
                    str11 = str4;
                    str12 = str5;
                    str13 = str7;
                    str14 = str8;
                    str15 = str3;
                    str16 = str6;
                    str17 = str19;
                    if (str18 != null) {
                    }
                    runOnUiThread(new Runnable() { // from class: com.netwatch.app.o
                        @Override // java.lang.Runnable
                        public final void run() {
                            MainActivity.this.lambda$lookupMyInfo$37(r2, str18, str17, "", str15, str16, str11, str12, str10, str14, str9, str13);
                        }
                    });
                }
                try {
                    str9 = str2;
                    str10 = str5.length() == 2 ? new String(Character.toChars(str5.charAt(0) - 3675)).concat(new String(Character.toChars(str5.charAt(1) - 3675))) : "🌐";
                    str11 = str4;
                    str12 = str5;
                    str13 = str7;
                    str14 = str8;
                    str15 = str3;
                    str16 = str6;
                    str17 = optString;
                } catch (Exception unused10) {
                    str19 = optString;
                    str9 = str2;
                    str10 = "🌐";
                    str11 = str4;
                    str12 = str5;
                    str13 = str7;
                    str14 = str8;
                    str15 = str3;
                    str16 = str6;
                    str17 = str19;
                    if (str18 != null) {
                    }
                    runOnUiThread(new Runnable() { // from class: com.netwatch.app.o
                        @Override // java.lang.Runnable
                        public final void run() {
                            MainActivity.this.lambda$lookupMyInfo$37(r2, str18, str17, "", str15, str16, str11, str12, str10, str14, str9, str13);
                        }
                    });
                }
            } catch (Exception unused11) {
                str2 = "";
                str5 = str2;
                str6 = str5;
                str7 = str6;
                str8 = str7;
                str19 = optString;
                str9 = str2;
                str10 = "🌐";
                str11 = str4;
                str12 = str5;
                str13 = str7;
                str14 = str8;
                str15 = str3;
                str16 = str6;
                str17 = str19;
                if (str18 != null) {
                }
                runOnUiThread(new Runnable() { // from class: com.netwatch.app.o
                    @Override // java.lang.Runnable
                    public final void run() {
                        MainActivity.this.lambda$lookupMyInfo$37(r2, str18, str17, "", str15, str16, str11, str12, str10, str14, str9, str13);
                    }
                });
            }
        } else {
            str17 = "";
            str15 = str17;
            str16 = str15;
            str11 = str16;
            str12 = str11;
            str14 = str12;
            str9 = str14;
            str13 = str9;
            str10 = "🌐";
        }
        final String str20 = str18 != null ? str18 : "Unable to determine";
        runOnUiThread(new Runnable() { // from class: com.netwatch.app.o
            @Override // java.lang.Runnable
            public final void run() {
                MainActivity.this.lambda$lookupMyInfo$37(str20, str18, str17, "", str15, str16, str11, str12, str10, str14, str9, str13);
            }
        });
    }

    public /* synthetic */ void lambda$onCreate$0(View view) {
        switchTab(0);
    }

    public /* synthetic */ void lambda$onCreate$1(View view) {
        switchTab(1);
    }

    public /* synthetic */ void lambda$onCreate$10(View view) {
        switchTab(4);
    }

    public /* synthetic */ void lambda$onCreate$11(View view) {
        switchTab(5);
    }

    public /* synthetic */ void lambda$onCreate$12(View view) {
        if (this.deviceMonRunning) {
            stopDeviceMonitor();
        } else {
            startDeviceMonitor();
        }
    }

    public /* synthetic */ void lambda$onCreate$13(View view) {
        this.deviceLog.clear();
        this.deviceLogContainer.removeAllViews();
        this.deviceCountText.setText("0 connections");
        this.deviceExportBtn.setVisibility(8);
        this.deviceClearBtn.setVisibility(8);
        this.deviceHeaderRow.setVisibility(8);
    }

    public /* synthetic */ void lambda$onCreate$14(View view) {
        exportDeviceCsv();
    }

    public /* synthetic */ void lambda$onCreate$15(View view) {
        exportTrafficLog();
    }

    public /* synthetic */ void lambda$onCreate$16(SharedPreferences sharedPreferences, CompoundButton compoundButton, boolean z) {
        this.alertsEnabled = z;
        sharedPreferences.edit().putBoolean("alerts_enabled", z).apply();
    }

    public /* synthetic */ void lambda$onCreate$17(View view) {
        startDomainCheck();
    }

    public /* synthetic */ void lambda$onCreate$18(View view) {
        stopDomainCheck();
    }

    public /* synthetic */ void lambda$onCreate$19(View view) {
        checkCustomDomain();
    }

    public /* synthetic */ void lambda$onCreate$2(View view) {
        switchTab(2);
    }

    public /* synthetic */ boolean lambda$onCreate$20(TextView textView, int i2, KeyEvent keyEvent) {
        checkCustomDomain();
        return true;
    }

    public /* synthetic */ void lambda$onCreate$21(View view) {
        startMonitoring();
    }

    public /* synthetic */ void lambda$onCreate$22(View view) {
        stopMonitoring();
    }

    public /* synthetic */ void lambda$onCreate$23(View view) {
        clearLog();
    }

    public /* synthetic */ void lambda$onCreate$3(View view) {
        switchTab(3);
    }

    public /* synthetic */ void lambda$onCreate$5(View view) {
        performLookup();
    }

    public /* synthetic */ boolean lambda$onCreate$6(TextView textView, int i2, KeyEvent keyEvent) {
        performLookup();
        return true;
    }

    public /* synthetic */ void lambda$onCreate$7(View view) {
        exportDomainIntel();
    }

    public /* synthetic */ void lambda$onCreate$8(View view) {
        lookupMyInfo();
    }

    public /* synthetic */ void lambda$onCreate$9(View view) {
        if (this.speedRunning) {
            return;
        }
        runSpeedTest();
    }

    public /* synthetic */ void lambda$performLookup$32(String str, String str2) {
        this.lookupBtn.setEnabled(true);
        if (str == null) {
            this.statusText.setText(this.isRussian ? "❌  Ошибка сети" : "❌  Network error");
            return;
        }
        this.statusText.setText(androidx.activity.result.a.m(this.isRussian ? "✅  Сканирование завершено: " : "✅  Scan complete for ", str2));
        this.lastDomainForExport = str2;
        this.lastIntelJsonForExport = str;
        this.lastProbeJsonForExport = "";
        buildReport(str2, str, null);
    }

    public /* synthetic */ void lambda$performLookup$33(String str) {
        this.mainHandler.post(new g(this, postJson(DOMAIN_INTEL_URL, androidx.activity.result.a.f("{\"domain\":\"", str, "\"}")), str, 1));
    }

    public /* synthetic */ void lambda$refreshDeviceLog$47() {
        this.deviceScrollView.smoothScrollTo(0, 0);
    }

    public /* synthetic */ void lambda$runSpeedTest$45(String str, long j2, double d2, double d3) {
        String str2;
        this.speedRunning = false;
        this.speedRunBtn.setEnabled(true);
        this.speedStatusText.setText(androidx.activity.result.a.m(this.isRussian ? "✅ Тест завершён — " : "✅ Test complete — ", str));
        TextView textView = this.speedPingText;
        if (j2 >= 0) {
            str2 = j2 + " ms";
        } else {
            str2 = this.isRussian ? "недоступен" : "unreachable";
        }
        textView.setText(str2);
        String str3 = "N/A";
        this.speedDownText.setText(d2 >= 0.0d ? String.format(Locale.US, "%.2f Mbps", Double.valueOf(d2)) : this.isRussian ? "нет данных" : "N/A");
        TextView textView2 = this.speedUpText;
        if (d3 >= 0.0d) {
            str3 = String.format(Locale.US, "%.2f Mbps", Double.valueOf(d3));
        } else if (this.isRussian) {
            str3 = "нет данных";
        }
        textView2.setText(str3);
        this.speedPingText.setTextColor(j2 < 0 ? Color.parseColor("#546E7A") : j2 < 50 ? Color.parseColor("#00FF88") : j2 < 150 ? Color.parseColor("#FFD740") : Color.parseColor("#EF9A9A"));
        this.speedDownText.setTextColor(d2 < 0.0d ? Color.parseColor("#546E7A") : d2 >= 50.0d ? Color.parseColor("#00FF88") : d2 >= 10.0d ? Color.parseColor("#FFD740") : Color.parseColor("#EF9A9A"));
        this.speedUpText.setTextColor(d3 < 0.0d ? Color.parseColor("#546E7A") : d3 >= 20.0d ? Color.parseColor("#00FF88") : d3 >= 5.0d ? Color.parseColor("#FFD740") : Color.parseColor("#EF9A9A"));
        this.speedResultsContainer.setVisibility(0);
    }

    /* JADX DEBUG: Another duplicated slice has different insns count: {[]}, finally: {[THROW, INVOKE, MOVE_EXCEPTION, THROW, INVOKE, MOVE_EXCEPTION, THROW, IF] complete} */
    /* JADX DEBUG: Finally have unexpected throw blocks count: 2, expect 1 */
    /* JADX DEBUG: Finally have unexpected throw blocks count: 3, expect 1 */
    /* JADX WARN: Removed duplicated region for block: B:58:0x0147 A[Catch: Exception -> 0x0159, TRY_ENTER, TryCatch #4 {Exception -> 0x0159, blocks: (B:58:0x0147, B:59:0x0182, B:62:0x01c0, B:87:0x01f7, B:86:0x01f4, B:90:0x015f, B:91:0x0171, B:81:0x01ee, B:61:0x01ba), top: B:56:0x0145, inners: #0, #6 }] */
    /* JADX WARN: Removed duplicated region for block: B:89:0x015d  */
    /*
        Code decompiled incorrectly, please refer to instructions dump.
    */
    public /* synthetic */ void lambda$runSpeedTest$46(String str, boolean z, boolean z2, final String str2) {
        long j2;
        double d2;
        double d3;
        String str3;
        String str4;
        try {
            URL url = new URL(str);
            String host = url.getHost();
            int port = url.getPort() > 0 ? url.getPort() : str.startsWith("https") ? 443 : 80;
            j2 = LocationRequestCompat.PASSIVE_INTERVAL;
            for (int i2 = 0; i2 < 3; i2++) {
                long currentTimeMillis = System.currentTimeMillis();
                Socket socket = new Socket();
                try {
                    socket.connect(new InetSocketAddress(host, port), PathInterpolatorCompat.MAX_NUM_POINTS);
                    socket.close();
                    j2 = Math.min(j2, System.currentTimeMillis() - currentTimeMillis);
                    Thread.sleep(100L);
                } catch (Throwable th) {
                    try {
                        socket.close();
                        throw th;
                    } catch (Throwable th2) {
                        th.addSuppressed(th2);
                        throw th;
                    }
                }
            }
        } catch (Exception unused) {
            j2 = -1;
        }
        final long j3 = j2;
        try {
            if (z) {
                str4 = str + "/__down?bytes=10485760";
            } else if (z2) {
                str4 = str + "/download?size=10485760";
            } else {
                str4 = str + "/garbage.php?ckSize=10";
            }
            HttpURLConnection httpURLConnection = (HttpURLConnection) new URL(str4).openConnection();
            httpURLConnection.setInstanceFollowRedirects(false);
            httpURLConnection.setConnectTimeout(8000);
            httpURLConnection.setReadTimeout(25000);
            httpURLConnection.setRequestProperty("User-Agent", "NetWatch/1.4.8");
            httpURLConnection.connect();
            if (httpURLConnection.getResponseCode() != 200) {
                throw new IOException("HTTP " + httpURLConnection.getResponseCode());
            }
            long currentTimeMillis2 = System.currentTimeMillis();
            byte[] bArr = new byte[65536];
            InputStream inputStream = httpURLConnection.getInputStream();
            long j4 = 0;
            do {
                try {
                    int read = inputStream.read(bArr);
                    if (read == -1) {
                        break;
                    } else {
                        j4 += read;
                    }
                } finally {
                }
            } while (j4 < 10485760);
            long j5 = j4;
            inputStream.close();
            long currentTimeMillis3 = System.currentTimeMillis() - currentTimeMillis2;
            d2 = (currentTimeMillis3 <= 0 || j5 <= 0) ? -1.0d : ((j5 * 8.0d) / (currentTimeMillis3 / 1000.0d)) / 1000000.0d;
            try {
                httpURLConnection.disconnect();
            } catch (Exception unused2) {
                try {
                    if (!z) {
                    }
                    HttpURLConnection httpURLConnection2 = (HttpURLConnection) new URL(str3).openConnection();
                    httpURLConnection2.setInstanceFollowRedirects(false);
                    httpURLConnection2.setRequestMethod("POST");
                    httpURLConnection2.setDoOutput(true);
                    httpURLConnection2.setConnectTimeout(8000);
                    httpURLConnection2.setReadTimeout(25000);
                    httpURLConnection2.setRequestProperty("Content-Type", "application/octet-stream");
                    httpURLConnection2.setRequestProperty("User-Agent", "NetWatch/1.4.8");
                    byte[] bArr2 = new byte[4194304];
                    long currentTimeMillis4 = System.currentTimeMillis();
                    OutputStream outputStream = httpURLConnection2.getOutputStream();
                } catch (Exception unused3) {
                    d3 = -1.0d;
                    final double d4 = d3;
                    final double d5 = d2;
                    this.mainHandler.post(new Runnable() { // from class: com.netwatch.app.s
                        @Override // java.lang.Runnable
                        public final void run() {
                            MainActivity.this.lambda$runSpeedTest$45(str2, j3, d5, d4);
                        }
                    });
                }
                try {
                    outputStream.write(bArr2);
                    outputStream.flush();
                    outputStream.close();
                    int responseCode = httpURLConnection2.getResponseCode();
                    long currentTimeMillis5 = System.currentTimeMillis() - currentTimeMillis4;
                    if (currentTimeMillis5 > 0) {
                    }
                    try {
                        httpURLConnection2.disconnect();
                    } catch (Exception unused4) {
                    }
                    final double d42 = d3;
                    final double d52 = d2;
                    this.mainHandler.post(new Runnable() { // from class: com.netwatch.app.s
                        @Override // java.lang.Runnable
                        public final void run() {
                            MainActivity.this.lambda$runSpeedTest$45(str2, j3, d52, d42);
                        }
                    });
                } finally {
                }
            }
        } catch (Exception unused5) {
            d2 = -1.0d;
            if (!z) {
                str3 = str + "/__up";
            } else if (z2) {
                str3 = str + "/upload";
            } else {
                str3 = str + "/empty.php";
            }
            HttpURLConnection httpURLConnection22 = (HttpURLConnection) new URL(str3).openConnection();
            httpURLConnection22.setInstanceFollowRedirects(false);
            httpURLConnection22.setRequestMethod("POST");
            httpURLConnection22.setDoOutput(true);
            httpURLConnection22.setConnectTimeout(8000);
            httpURLConnection22.setReadTimeout(25000);
            httpURLConnection22.setRequestProperty("Content-Type", "application/octet-stream");
            httpURLConnection22.setRequestProperty("User-Agent", "NetWatch/1.4.8");
            byte[] bArr22 = new byte[4194304];
            long currentTimeMillis42 = System.currentTimeMillis();
            OutputStream outputStream2 = httpURLConnection22.getOutputStream();
            outputStream2.write(bArr22);
            outputStream2.flush();
            outputStream2.close();
            int responseCode2 = httpURLConnection22.getResponseCode();
            long currentTimeMillis52 = System.currentTimeMillis() - currentTimeMillis42;
            d3 = (currentTimeMillis52 > 0 || responseCode2 >= 500) ? -1.0d : ((4194304 * 8.0d) / (currentTimeMillis52 / 1000.0d)) / 1000000.0d;
            httpURLConnection22.disconnect();
            final double d422 = d3;
            final double d522 = d2;
            this.mainHandler.post(new Runnable() { // from class: com.netwatch.app.s
                @Override // java.lang.Runnable
                public final void run() {
                    MainActivity.this.lambda$runSpeedTest$45(str2, j3, d522, d422);
                }
            });
        }
    }

    public static /* synthetic */ boolean lambda$seedTrustedDomains$31(String str) {
        return !isGlobalCdn(str);
    }

    public /* synthetic */ void lambda$showLanguageDialog$25(DialogInterface dialogInterface, int i2) {
        boolean z = i2 == 1;
        if (z != this.isRussian) {
            this.isRussian = z;
            getSharedPreferences(PREFS_NAME, 0).edit().putString(PREF_LANG, this.isRussian ? "ru" : "en").apply();
            refreshTabLabels();
            refreshUiStrings();
        }
        dialogInterface.dismiss();
        Toast.makeText(this, this.isRussian ? "Язык изменён на Русский" : "Language set to English", 0).show();
    }

    public /* synthetic */ boolean lambda$showMainMenu$24(MenuItem menuItem) {
        String str;
        int itemId = menuItem.getItemId();
        if (itemId == R.id.menu_instructions_domain) {
            if (this.isRussian) {
                showInfoDialog("🔍 Domain Intel — Справка", "Введите доменное имя и нажмите Поиск.\n\nРезультаты включают:\n  • IP-адреса (A-записи)\n  • Обнаруженные поддомены\n  • Информация WHOIS\n  • Geo-IP локация сервера\n\nНажмите Экспорт для сохранения результатов в CSV.");
            } else {
                showInfoDialog("🔍 Domain Intel — Help", "Enter any domain name and tap Lookup.\n\nResults include:\n  • IP Addresses (A records)\n  • Subdomains detected\n  • WHOIS registration info\n  • Geo-IP location of the server\n\nTap Export to save results as a CSV file.");
            }
            return true;
        }
        if (itemId == R.id.menu_instructions_traffic) {
            if (this.isRussian) {
                showInfoDialog("📡 Монитор трафика — Справка", "Мониторинг сетевых соединений для любого приложения или всего устройства.\n\nКак использовать:\n  1. Выберите приложение из списка (или «Всё устройство»)\n  2. Нажмите Старт — выбранное приложение запустится автоматически\n  3. NetWatch фиксирует все исходящие соединения в реальном времени\n\nВозможности:\n  • Geo-IP поиск для каждого соединения\n  • Обнаружение смежных доменов (CDN, поддомены)\n  • Вибрация при соединении с неизвестным доменом\n  • Экспорт лога соединений в формате RFC 4180 CSV");
            } else {
                showInfoDialog("📡 Traffic Monitor — Help", "Monitor live network connections for any installed app.\n\nHow to use:\n  1. Select an app from the dropdown\n  2. Tap Start — the selected app launches automatically\n  3. NetWatch captures all outbound connections in real-time\n\nFeatures:\n  • Geo-IP lookup for every connection\n  • Companion domain detection (CDNs, subdomains)\n  • Vibration alert for unknown/unlisted domains\n  • Export connection log as RFC 4180 CSV");
            }
            return true;
        }
        if (itemId == R.id.menu_instructions_checker) {
            if (this.isRussian) {
                showInfoDialog("✅ Проверка доменов — Справка", "Быстрая проверка доступности известных сервисных доменов.\n\nКатегории:\n  • Microsoft, Google, Apple, Cloudflare\n  • Социальные сети и мессенджеры\n  • Финансы и платежи\n  • Игры (Xbox, PlayStation)\n\nСтатус каждого домена:\n  🟢 Доступен  |  🔴 Заблокирован / Недоступен\n\nНажмите «Проверить всё» для запуска всех тестов.\nИспользуйте поле ввода вверху для проверки любого домена вручную.");
            } else {
                showInfoDialog("✅ Domain Checker — Help", "Quickly verify connectivity to well-known service domains.\n\nCategories include:\n  • Microsoft, Google, Apple, Cloudflare\n  • Social & Messaging\n  • Finance & Payments\n  • Gaming (Xbox, PlayStation)\n\nEach domain shows a live status:\n  🟢 Reachable  |  🔴 Blocked / Unreachable\n\nTap Check All to run all tests at once.\nUse the custom input at the top to test any domain manually.");
            }
            return true;
        }
        if (itemId == R.id.menu_instructions_myinfo) {
            if (this.isRussian) {
                showInfoDialog("🌐 Мои данные — Справка", "Отображает актуальную информацию о вашем сетевом подключении.\n\nПоказываемые данные:\n  • Публичный IP-адрес\n  • Провайдер / Сеть\n  • Город, регион, страна\n  • GPS-координаты (нажмите для выбора приложения карт)\n  • Часовой пояс\n\nДанные получены от ipinfo.io.\nНажмите Обновить для актуализации информации.");
            } else {
                showInfoDialog("🌐 My Info — Help", "Displays live information about your current network connection.\n\nShown details:\n  • Public IP Address\n  • ISP / Network Provider\n  • City, Region, Country\n  • GPS Coordinates (tap to open in your preferred maps app)\n  • Timezone\n\nData is fetched from ipinfo.io.\nTap Refresh to update at any time.");
            }
            return true;
        }
        if (itemId == R.id.menu_instructions_speed) {
            if (this.isRussian) {
                showInfoDialog("⚡ Тест скорости — Справка", "Измеряет скорость вашего интернет-соединения.\n\nКак пользоваться:\n  1. Выберите сервер из списка\n  2. Нажмите Запустить тест\n  3. Дождитесь результатов\n\nРезультаты:\n  • Пинг — задержка (зелёный < 50мс)\n  • Загрузка — скорость входящего трафика\n  • Отдача — скорость исходящего трафика\n\nСерверы: США, Канада, Европа, Азия, Россия.");
            } else {
                showInfoDialog("⚡ Speed Test — Help", "Measures your internet connection speed.\n\nHow to use:\n  1. Select a server from the dropdown\n  2. Tap Run Speed Test\n  3. Wait for results\n\nResults explained:\n  • Ping — latency in ms (green < 50ms)\n  • Download — incoming data speed\n  • Upload — outgoing data speed\n\nServer providers:\n  • Ookla — 7 US cities (NYC, LA, Chicago,\n    Dallas, Miami, Seattle, Atlanta)\n  • Linode/Akamai — US, Canada, EU, Asia\n  • MTS — Russia (Moscow)\n  • Cloudflare — Global\n\n16 servers total.");
            }
            return true;
        }
        if (itemId == R.id.menu_language) {
            showLanguageDialog();
            return true;
        }
        if (itemId != R.id.menu_about) {
            return false;
        }
        try {
            str = getPackageManager().getPackageInfo(getPackageName(), 0).versionName;
        } catch (Exception unused) {
            str = "1.4.5";
        }
        if (this.isRussian) {
            showInfoDialog("ℹ️ О программе NetWatch", androidx.activity.result.a.f("◈ NETWATCH\nВерсия ", str, "\n\nПрофессиональный инструмент сетевой разведки для Android.\n\nВозможности:\n  • Анализ доменов и WHOIS-запросы\n  • Мониторинг трафика приложений в реальном времени\n  • Проверка доступности доменов\n  • Актуальная информация о сети и Geo-IP\n  • Тест скорости интернета\n\nСоздано с ❤️ с помощью Base44 Superagent."));
        } else {
            showInfoDialog("ℹ️ About NetWatch", androidx.activity.result.a.f("◈ NETWATCH\nVersion ", str, "\n\nA professional-grade network intelligence tool for Android.\n\nFeatures:\n  • Domain Intelligence & WHOIS lookup\n  • Real-time per-app traffic monitoring\n  • Domain reachability checker\n  • Live network & geo-IP info\n  • Internet speed test\n\nBuilt with ❤️ using Base44 Superagent."));
        }
        return true;
    }

    public /* synthetic */ void lambda$startDomainCheck$39(int i2, List list, String str) {
        TextView textView = this.checkStatusText;
        StringBuilder sb = new StringBuilder();
        sb.append(this.isRussian ? "Проверка " : "Checking ");
        sb.append(i2);
        sb.append("/");
        sb.append(list.size());
        sb.append(" — ");
        sb.append(str);
        textView.setText(sb.toString());
    }

    public /* synthetic */ void lambda$startDomainCheck$40(String str, boolean z, long j2) {
        String str2;
        TextView textView = this.checkerStatusViews.get(str);
        if (textView == null) {
            return;
        }
        if (z) {
            str2 = j2 + " ms";
        } else {
            str2 = "BLOCKED";
        }
        textView.setText(str2);
        textView.setTextColor(z ? Color.parseColor("#66BB6A") : Color.parseColor("#EF5350"));
        ViewParent parent = textView.getParent();
        if (parent instanceof LinearLayout) {
            Object tag = ((LinearLayout) parent).getTag();
            if (tag instanceof TextView) {
                ((TextView) tag).setTextColor(z ? Color.parseColor("#66BB6A") : Color.parseColor("#EF5350"));
            }
        }
    }

    public /* synthetic */ void lambda$startDomainCheck$41(int i2, List list, int i3, int i4) {
        StringBuilder sb;
        String str;
        StringBuilder sb2;
        String str2;
        this.checkRunning.set(false);
        this.checkAllBtn.setEnabled(true);
        this.stopCheckBtn.setEnabled(false);
        if (i2 == list.size()) {
            TextView textView = this.checkStatusText;
            if (this.isRussian) {
                sb2 = new StringBuilder("Готово — ✅ ");
                sb2.append(i3);
                sb2.append(" доступно   🚫 ");
                sb2.append(i4);
                str2 = " заблокировано";
            } else {
                sb2 = new StringBuilder("Done — ✅ ");
                sb2.append(i3);
                sb2.append(" reachable   🚫 ");
                sb2.append(i4);
                str2 = " blocked";
            }
            sb2.append(str2);
            textView.setText(sb2.toString());
        } else {
            TextView textView2 = this.checkStatusText;
            if (this.isRussian) {
                sb = new StringBuilder("Остановлено — ✅ ");
                sb.append(i3);
                sb.append("  🚫 ");
                sb.append(i4);
                sb.append(" (из ");
                sb.append(i2);
                str = " проверено)";
            } else {
                sb = new StringBuilder("Stopped — ✅ ");
                sb.append(i3);
                sb.append("  🚫 ");
                sb.append(i4);
                sb.append(" (of ");
                sb.append(i2);
                str = " checked)";
            }
            sb.append(str);
            textView2.setText(sb.toString());
        }
        this.checkStatusText.setTextColor(Color.parseColor(i4 > 0 ? "#EF9A9A" : "#66BB6A"));
    }

    public /* synthetic */ void lambda$startDomainCheck$42(final List list) {
        Iterator it = list.iterator();
        final int i2 = 0;
        final int i3 = 0;
        final int i4 = 0;
        while (it.hasNext()) {
            String[] strArr = (String[]) it.next();
            if (!this.checkRunning.get()) {
                break;
            }
            String str = strArr[0];
            final String str2 = strArr[1];
            i2++;
            this.mainHandler.post(new c(this, i2, list, str2));
            long[] probeHost = probeHost(str2);
            final boolean z = probeHost[0] == 1;
            final long j2 = probeHost[1];
            if (z) {
                i3++;
            } else {
                i4++;
            }
            this.mainHandler.post(new Runnable() { // from class: com.netwatch.app.d
                @Override // java.lang.Runnable
                public final void run() {
                    MainActivity.this.lambda$startDomainCheck$40(str2, z, j2);
                }
            });
        }
        this.mainHandler.post(new Runnable() { // from class: com.netwatch.app.e
            @Override // java.lang.Runnable
            public final void run() {
                MainActivity.this.lambda$startDomainCheck$41(i2, list, i3, i4);
            }
        });
    }

    public /* synthetic */ void lambda$updateStats$29() {
        this.hostLogScroll.fullScroll(130);
    }

    public void launchApp(String str) {
        try {
            Intent launchIntentForPackage = getPackageManager().getLaunchIntentForPackage(str);
            if (launchIntentForPackage != null) {
                launchIntentForPackage.addFlags(268435456);
                startActivity(launchIntentForPackage);
            } else {
                showToast(this.isRussian ? "Невозможно запустить — фоновый сервис" : "Can't launch — app may be a background service");
            }
        } catch (Exception e2) {
            showToast("Could not open app: " + e2.getMessage());
        }
    }

    private void launchDeviceVpn() {
        this.deviceReceiver = new AnonymousClass3();
        LocalBroadcastManager.getInstance(this).registerReceiver(this.deviceReceiver, new IntentFilter("com.netwatch.app.DEVICE_TRAFFIC"));
        startForegroundService(new Intent(this, (Class<?>) NetWatchVpnService.class));
        this.deviceMonRunning = true;
        this.deviceToggleBtn.setText(this.isRussian ? "⏹ Стоп" : "⏹ Stop");
        this.deviceToggleBtn.setBackgroundResource(R.drawable.btn_danger);
        this.deviceStatusText.setText(this.isRussian ? "● Активен" : "● Active");
        this.deviceStatusText.setTextColor(Color.parseColor("#00FF88"));
        this.deviceHeaderRow.setVisibility(0);
        this.deviceClearBtn.setVisibility(0);
    }

    private void loadAppList() {
        this.executor.execute(new l(this, 1));
    }

    private void lookupMyInfo() {
        this.myInfoContainer.removeAllViews();
        addMyInfoRow("⏳ Looking up your public IP…", "", "#0D1117");
        this.myInfoRefreshBtn.setEnabled(false);
        new Thread(new l(this, 3)).start();
    }

    private LinearLayout makeCardContainer() {
        LinearLayout linearLayout = new LinearLayout(this);
        linearLayout.setOrientation(1);
        linearLayout.setBackgroundResource(R.drawable.card_background);
        linearLayout.setPadding(dp(14), dp(12), dp(14), dp(12));
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-1, -2);
        layoutParams.bottomMargin = dp(10);
        linearLayout.setLayoutParams(layoutParams);
        return linearLayout;
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

    private void performLookup() {
        String trim = this.domainInput.getText().toString().trim();
        if (trim.isEmpty()) {
            showToast(this.isRussian ? "Введите домен" : "Enter a domain");
            return;
        }
        String trim2 = trim.replaceAll("(?i)https?://", "").replaceAll("/.*", "").toLowerCase().trim();
        this.resultsContainer.removeAllViews();
        this.statusText.setText(androidx.activity.result.a.f(this.isRussian ? "⏳  Сканирование " : "⏳  Scanning ", trim2, " …"));
        this.lookupBtn.setEnabled(false);
        this.executor.execute(new androidx.constraintlayout.motion.widget.a(4, this, trim2));
    }

    private String postJson(String str, String str2) {
        try {
            HttpURLConnection httpURLConnection = (HttpURLConnection) new URL(str).openConnection();
            httpURLConnection.setRequestMethod("POST");
            httpURLConnection.setRequestProperty("Content-Type", "application/json");
            httpURLConnection.setDoOutput(true);
            httpURLConnection.setConnectTimeout(15000);
            httpURLConnection.setReadTimeout(30000);
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

    /* JADX DEBUG: Another duplicated slice has different insns count: {[]}, finally: {[INVOKE, MOVE_EXCEPTION, INVOKE, MOVE_EXCEPTION] complete} */
    private long[] probeHost(String str) {
        long currentTimeMillis = System.currentTimeMillis();
        try {
            long j2 = 1;
            if (str.matches("\\d+\\.\\d+\\.\\d+\\.\\d+")) {
                boolean isReachable = InetAddress.getByName(str).isReachable(PathInterpolatorCompat.MAX_NUM_POINTS);
                if (!isReachable) {
                    try {
                        Socket socket = new Socket();
                        try {
                            socket.connect(new InetSocketAddress(str, 53), PathInterpolatorCompat.MAX_NUM_POINTS);
                            try {
                                socket.close();
                            } catch (Exception unused) {
                            }
                            isReachable = true;
                        } finally {
                        }
                    } catch (Exception unused2) {
                    }
                }
                long currentTimeMillis2 = System.currentTimeMillis() - currentTimeMillis;
                long[] jArr = new long[2];
                if (!isReachable) {
                    j2 = 0;
                }
                jArr[0] = j2;
                jArr[1] = currentTimeMillis2;
                return jArr;
            }
            InetAddress.getByName(str);
            HttpURLConnection httpURLConnection = (HttpURLConnection) new URL("https://" + str + "/").openConnection();
            httpURLConnection.setRequestMethod("HEAD");
            httpURLConnection.setConnectTimeout(PathInterpolatorCompat.MAX_NUM_POINTS);
            httpURLConnection.setReadTimeout(PathInterpolatorCompat.MAX_NUM_POINTS);
            httpURLConnection.setInstanceFollowRedirects(true);
            httpURLConnection.connect();
            int responseCode = httpURLConnection.getResponseCode();
            httpURLConnection.disconnect();
            long currentTimeMillis3 = System.currentTimeMillis() - currentTimeMillis;
            long[] jArr2 = new long[2];
            if (responseCode <= 0) {
                j2 = 0;
            }
            jArr2[0] = j2;
            jArr2[1] = currentTimeMillis3;
            return jArr2;
        } catch (Exception unused3) {
            return new long[]{0, System.currentTimeMillis() - currentTimeMillis};
        }
    }

    public void refreshDeviceLog() {
        int size;
        this.deviceLogContainer.removeAllViews();
        synchronized (this.deviceLog) {
            try {
                size = this.deviceLog.size();
                for (int size2 = this.deviceLog.size() - 1; size2 >= 0; size2--) {
                    String[] strArr = this.deviceLog.get(size2);
                    this.deviceLogContainer.addView(buildDeviceRow(strArr[0], strArr[2], strArr[3], strArr[4], strArr.length > 5 ? strArr[5] : ""));
                }
            } catch (Throwable th) {
                throw th;
            }
        }
        TextView textView = this.deviceCountText;
        StringBuilder sb = new StringBuilder();
        sb.append(size);
        sb.append(this.isRussian ? " соединений" : " connections");
        textView.setText(sb.toString());
        if (size > 0) {
            this.deviceExportBtn.setVisibility(0);
            this.deviceClearBtn.setVisibility(0);
        }
        this.deviceScrollView.post(new l(this, 4));
    }

    private void refreshTabLabels() {
        this.tabDomainBtn.setText(this.isRussian ? "🔍 Домены" : "🔍 Domain Intel");
        this.tabTrafficBtn.setText(this.isRussian ? "📡 Трафик" : "📡 Traffic");
        this.tabCheckerBtn.setText(this.isRussian ? "✅ Проверка" : "✅ Checker");
        this.tabMyInfoBtn.setText(this.isRussian ? "🌐 Мой IP" : "🌐 My Info");
        this.tabSpeedBtn.setText(this.isRussian ? "⚡ Скорость" : "⚡ Speed");
        Button button = this.tabDeviceBtn;
        if (button != null) {
            button.setText(this.isRussian ? "📶 Устройство" : "📶 Device");
        }
        TextView textView = this.deviceTitleText;
        if (textView != null) {
            textView.setText(this.isRussian ? "📶 Монитор устройства" : "📶 Device Monitor");
        }
    }

    private void refreshUiStrings() {
        this.domainInput.setHint(this.isRussian ? "Введите домен (напр. paypal.com)" : "Enter domain (e.g. paypal.com)");
        this.lookupBtn.setText(this.isRussian ? "СКАН" : "SCAN");
        this.statusText.setText(this.isRussian ? "Введите домен и нажмите СКАН" : "Enter a domain and tap SCAN");
        this.exportDomainBtn.setText(this.isRussian ? "⬆ Экспорт" : "⬆ Export");
        this.startMonBtn.setText(this.isRussian ? "▶  СТАРТ" : "▶  START");
        this.stopMonBtn.setText(this.isRussian ? "■  СТОП" : "■  STOP");
        this.exportTrafficBtn.setText(this.isRussian ? "⬆ Экспорт" : "⬆ Export");
        this.alertSwitch.setText(this.isRussian ? "🔔  Оповещение о неизвестных хостах" : "🔔  Alert on unknown hosts");
        this.monStatusText.setText(this.isRussian ? "⚫  Мониторинг неактивен" : "⚫  Monitoring inactive");
        this.customDomainInput.setHint(this.isRussian ? "Введите домен или IP…" : "Enter domain or IP…");
        this.checkCustomBtn.setText(this.isRussian ? "Проверить" : "Check");
        this.checkAllBtn.setText(this.isRussian ? "▶  Проверить всё" : "▶  Check All");
        this.stopCheckBtn.setText(this.isRussian ? "■  Стоп" : "■  Stop");
        this.checkStatusText.setText(this.isRussian ? "Нажмите ▶ Проверить всё для теста" : "Tap ▶ Check All to test reachability");
        this.myInfoRefreshBtn.setText(this.isRussian ? "▶  Получить данные" : "▶  Lookup My Info");
        this.speedTitleText.setText(this.isRussian ? "⚡ Тест скорости" : "⚡ Internet Speed Test");
        this.speedDescText.setText(this.isRussian ? "Измерьте скорость загрузки, выгрузки и пинг до выбранного сервера." : "Measure your download speed, upload speed, and latency to a selected server.");
        this.speedRunBtn.setText(this.isRussian ? "▶  Запустить тест" : "▶  Run Speed Test");
        this.myInfoTitleText.setText(this.isRussian ? "🌐 Моя сеть" : "🌐 My Network Info");
        this.myInfoDescText.setText(this.isRussian ? "Ваш публичный IP-адрес, провайдер и местоположение." : "Your public IP address, ISP, and location as seen from the internet.");
        this.selectAppLabel.setText(this.isRussian ? "ВЫБРАТЬ ПРИЛОЖЕНИЕ" : "SELECT APP TO MONITOR");
        this.liveHostsLabel.setText(this.isRussian ? "АКТИВНЫЕ СОЕДИНЕНИЯ" : "LIVE CONNECTION HOSTS");
    }

    private void runSpeedTest() {
        int selectedItemPosition = this.speedServerSpinner.getSelectedItemPosition();
        String[][] strArr = SPEED_SERVERS;
        String[] strArr2 = strArr[selectedItemPosition];
        final String str = strArr2[1];
        final String trim = strArr2[0].trim();
        String str2 = strArr[selectedItemPosition][2];
        final boolean equals = "cloudflare".equals(str2);
        final boolean equals2 = "ookla".equals(str2);
        this.speedRunning = true;
        this.speedRunBtn.setEnabled(false);
        this.speedStatusText.setVisibility(0);
        this.speedStatusText.setText(this.isRussian ? "⏳ Тестирование…" : "⏳ Running test…");
        this.speedPingText.setText("—");
        this.speedDownText.setText("—");
        this.speedUpText.setText("—");
        this.speedResultsContainer.setVisibility(8);
        this.executor.execute(new Runnable() { // from class: com.netwatch.app.u
            @Override // java.lang.Runnable
            public final void run() {
                MainActivity.this.lambda$runSpeedTest$46(str, equals, equals2, trim);
            }
        });
    }

    public void seedTrustedDomains(String str) {
        this.trustedDomains.removeIf(new Object());
        String packageToRootDomain = packageToRootDomain(str);
        this.monitoredRootDomain = packageToRootDomain;
        if (packageToRootDomain != null) {
            this.trustedDomains.add(packageToRootDomain);
            this.trustedDomains.add("www." + this.monitoredRootDomain);
        }
    }

    /* JADX DEBUG: Another duplicated slice has different insns count: {[]}, finally: {[INVOKE, MOVE_EXCEPTION, INVOKE, MOVE_EXCEPTION] complete} */
    private void shareCsv(String str, String str2) {
        ((ClipboardManager) getSystemService("clipboard")).setPrimaryClip(ClipData.newPlainText(str, str2));
        try {
            File file = new File(getCacheDir(), "exports");
            file.mkdirs();
            File file2 = new File(file, str);
            FileWriter fileWriter = new FileWriter(file2);
            try {
                fileWriter.write(str2);
                fileWriter.close();
                Uri uriForFile = FileProvider.getUriForFile(this, getPackageName() + ".provider", file2);
                Intent intent = new Intent("android.intent.action.SEND");
                intent.setType("text/csv");
                intent.putExtra("android.intent.extra.SUBJECT", str);
                intent.putExtra("android.intent.extra.STREAM", uriForFile);
                intent.addFlags(1);
                startActivity(Intent.createChooser(intent, this.isRussian ? "Экспорт CSV через…" : "Export CSV via…"));
            } finally {
            }
        } catch (Exception unused) {
            Intent intent2 = new Intent("android.intent.action.SEND");
            intent2.setType("text/csv");
            intent2.putExtra("android.intent.extra.SUBJECT", str);
            intent2.putExtra("android.intent.extra.TEXT", str2);
            startActivity(Intent.createChooser(intent2, this.isRussian ? "Экспорт CSV через…" : "Export CSV via…"));
        }
    }

    private void showInfoDialog(String str, String str2) {
        new AlertDialog.Builder(this).setTitle(str).setMessage(str2).setPositiveButton(this.isRussian ? "Понятно" : "Got it", (DialogInterface.OnClickListener) null).show();
    }

    private void showLanguageDialog() {
        new AlertDialog.Builder(this).setTitle(this.isRussian ? "🌍 Выберите язык" : "🌍 Select Language").setSingleChoiceItems(new String[]{"🇬🇧  English", "🇷🇺  Русский"}, this.isRussian ? 1 : 0, new DialogInterface.OnClickListener() { // from class: com.netwatch.app.t
            @Override // android.content.DialogInterface.OnClickListener
            public final void onClick(DialogInterface dialogInterface, int i2) {
                MainActivity.this.lambda$showLanguageDialog$25(dialogInterface, i2);
            }
        }).setNegativeButton(this.isRussian ? "Отмена" : "Cancel", (DialogInterface.OnClickListener) null).show();
    }

    /* JADX DEBUG: Method merged with bridge method: lambda$onCreate$4(Landroid/view/View;)V */
    /* renamed from: showMainMenu */
    public void lambda$onCreate$4(View view) {
        PopupMenu popupMenu = new PopupMenu(this, view);
        popupMenu.getMenuInflater().inflate(R.menu.main_menu, popupMenu.getMenu());
        popupMenu.getMenu().findItem(R.id.menu_language).setTitle(this.isRussian ? "🌍 Language: Русский" : "🌍 Language: English");
        popupMenu.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() { // from class: com.netwatch.app.k
            @Override // android.widget.PopupMenu.OnMenuItemClickListener
            public final boolean onMenuItemClick(MenuItem menuItem) {
                boolean lambda$showMainMenu$24;
                lambda$showMainMenu$24 = MainActivity.this.lambda$showMainMenu$24(menuItem);
                return lambda$showMainMenu$24;
            }
        });
        popupMenu.show();
    }

    private void showToast(String str) {
        Toast.makeText(this, str, 0).show();
    }

    private void startDeviceMonitor() {
        Intent prepare = VpnService.prepare(this);
        if (prepare != null) {
            startActivityForResult(prepare, 1001);
        } else {
            launchDeviceVpn();
        }
    }

    private void startDomainCheck() {
        if (this.checkRunning.get()) {
            return;
        }
        this.checkRunning.set(true);
        this.checkAllBtn.setEnabled(false);
        this.stopCheckBtn.setEnabled(true);
        this.checkStatusText.setTextColor(Color.parseColor("#00E5FF"));
        for (Map.Entry<String, TextView> entry : this.checkerStatusViews.entrySet()) {
            entry.getValue().setText("…");
            entry.getValue().setTextColor(Color.parseColor("#90A4AE"));
            ViewParent parent = entry.getValue().getParent();
            if (parent instanceof LinearLayout) {
                Object tag = ((LinearLayout) parent).getTag();
                if (tag instanceof TextView) {
                    ((TextView) tag).setTextColor(Color.parseColor("#546E7A"));
                }
            }
        }
        ArrayList arrayList = new ArrayList();
        for (String[][] strArr : CHECKER_DOMAINS.values()) {
            for (String[] strArr2 : strArr) {
                arrayList.add(strArr2);
            }
        }
        this.executor.execute(new androidx.constraintlayout.motion.widget.a(5, this, arrayList));
    }

    public void startMonitoring() {
        if (this.selectedApp == null) {
            showToast(this.isRussian ? "Сначала выберите приложение" : "Select an app first");
            return;
        }
        clearLog();
        this.monitoring = true;
        this.startMonBtn.setEnabled(false);
        this.stopMonBtn.setEnabled(true);
        this.appSpinner.setEnabled(false);
        TextView textView = this.monStatusText;
        StringBuilder sb = new StringBuilder();
        sb.append(this.isRussian ? "🟢  Мониторинг: " : "🟢  Monitoring: ");
        sb.append(this.selectedApp.label);
        textView.setText(sb.toString());
        this.monStatusText.setTextColor(Color.parseColor("#66BB6A"));
        Intent intent = new Intent(this, (Class<?>) TrafficMonitorService.class);
        intent.putExtra("target_uid", this.selectedApp.uid);
        intent.putExtra("target_pkg", this.selectedApp.packageName);
        intent.putExtra("target_name", this.selectedApp.label);
        startForegroundService(intent);
    }

    private void stopDeviceMonitor() {
        if (this.deviceReceiver != null) {
            try {
                LocalBroadcastManager.getInstance(this).unregisterReceiver(this.deviceReceiver);
            } catch (Exception unused) {
            }
            this.deviceReceiver = null;
        }
        Intent intent = new Intent(this, (Class<?>) NetWatchVpnService.class);
        intent.setAction(NetWatchVpnService.ACTION_STOP);
        startService(intent);
        this.deviceMonRunning = false;
        this.deviceToggleBtn.setText(this.isRussian ? "▶  Старт" : "▶  Start");
        this.deviceToggleBtn.setBackgroundResource(R.drawable.btn_primary);
        this.deviceStatusText.setText(this.isRussian ? "Остановлен" : "Stopped");
        this.deviceStatusText.setTextColor(Color.parseColor("#546E7A"));
        if (this.deviceLog.isEmpty()) {
            return;
        }
        this.deviceExportBtn.setVisibility(0);
    }

    private void stopDomainCheck() {
        this.checkRunning.set(false);
        this.stopCheckBtn.setEnabled(false);
    }

    public void stopMonitoring() {
        this.monitoring = false;
        this.startMonBtn.setEnabled(true);
        this.stopMonBtn.setEnabled(false);
        this.appSpinner.setEnabled(true);
        this.monStatusText.setText(this.isRussian ? "⚫  Мониторинг остановлен" : "⚫  Monitoring stopped");
        this.monStatusText.setTextColor(Color.parseColor("#78909C"));
        Intent intent = new Intent(this, (Class<?>) TrafficMonitorService.class);
        intent.setAction(TrafficMonitorService.ACTION_STOP);
        startService(intent);
    }

    private void switchTab(int i2) {
        this.tab1.setVisibility(i2 == 0 ? 0 : 8);
        this.tab2.setVisibility(i2 == 1 ? 0 : 8);
        this.tab3.setVisibility(i2 == 2 ? 0 : 8);
        this.tab4.setVisibility(i2 == 3 ? 0 : 8);
        this.tab5.setVisibility(i2 == 4 ? 0 : 8);
        this.tab6.setVisibility(i2 == 5 ? 0 : 8);
        if (i2 == 3 && this.myInfoContainer.getChildCount() == 0) {
            lookupMyInfo();
        }
        this.tabDomainBtn.setSelected(i2 == 0);
        this.tabTrafficBtn.setSelected(i2 == 1);
        this.tabCheckerBtn.setSelected(i2 == 2);
        this.tabMyInfoBtn.setSelected(i2 == 3);
        this.tabSpeedBtn.setSelected(i2 == 4);
        this.tabDeviceBtn.setSelected(i2 == 5);
        if (i2 != 1 || this.lastKnownTx < 0) {
            return;
        }
        this.txTotalText.setText("TX  " + formatBytes(this.lastKnownTx));
        this.rxTotalText.setText("RX  " + formatBytes(this.lastKnownRx));
        this.txRateText.setText("↑ " + formatBytes(this.lastKnownTxRate) + "/s");
        this.rxRateText.setText("↓ " + formatBytes(this.lastKnownRxRate) + "/s");
        this.txRateText.setTextColor(this.lastKnownTxRate > 0 ? Color.parseColor("#EF9A9A") : Color.parseColor("#546E7A"));
        this.rxRateText.setTextColor(this.lastKnownRxRate > 0 ? Color.parseColor("#66BB6A") : Color.parseColor("#546E7A"));
    }

    public void updateStats(long j2, long j3, long j4, long j5, String str) {
        this.lastKnownTx = j2;
        this.lastKnownRx = j3;
        this.lastKnownTxRate = j4;
        this.lastKnownRxRate = j5;
        TextView textView = this.txTotalText;
        StringBuilder sb = new StringBuilder("TX  ");
        sb.append(j2 < 0 ? "N/A" : formatBytes(j2));
        textView.setText(sb.toString());
        TextView textView2 = this.rxTotalText;
        StringBuilder sb2 = new StringBuilder("RX  ");
        sb2.append(j3 < 0 ? "N/A" : formatBytes(j3));
        textView2.setText(sb2.toString());
        TextView textView3 = this.txRateText;
        StringBuilder sb3 = new StringBuilder("↑ ");
        sb3.append(j2 < 0 ? "N/A" : androidx.activity.result.a.g(new StringBuilder(), formatBytes(j4), "/s"));
        textView3.setText(sb3.toString());
        TextView textView4 = this.rxRateText;
        StringBuilder sb4 = new StringBuilder("↓ ");
        sb4.append(j3 >= 0 ? androidx.activity.result.a.g(new StringBuilder(), formatBytes(j5), "/s") : "N/A");
        textView4.setText(sb4.toString());
        if (j4 > 0 || j5 > 0) {
            Color.parseColor("#66BB6A");
        } else {
            Color.parseColor("#546E7A");
        }
        this.txRateText.setTextColor(j4 > 0 ? Color.parseColor("#EF9A9A") : Color.parseColor("#546E7A"));
        this.rxRateText.setTextColor(j5 > 0 ? Color.parseColor("#66BB6A") : Color.parseColor("#546E7A"));
        if (str == null || str.isEmpty()) {
            return;
        }
        String[] split = str.split("\n");
        String format = new SimpleDateFormat("HH:mm:ss", Locale.US).format(new Date());
        for (String str2 : split) {
            String trim = str2.trim();
            if (!trim.isEmpty() && !this.seenHosts.contains(trim)) {
                this.seenHosts.add(trim);
                addHostRow(trim, j4 > 0 || j5 > 0, format);
                this.trafficLogForExport.put(trim, format);
                this.hostCount++;
            }
        }
        if (this.hostCount > 0) {
            TextView textView5 = this.connectionCountText;
            StringBuilder sb5 = new StringBuilder();
            sb5.append(this.hostCount);
            sb5.append(this.isRussian ? " уникальных хостов" : " unique hosts");
            textView5.setText(sb5.toString());
        }
        this.hostLogScroll.post(new l(this, 2));
    }

    @Override // android.app.Activity
    public void onActivityResult(int i2, int i3, Intent intent) {
        super.onActivityResult(i2, i3, intent);
        if (i2 == 1001) {
            if (i3 == -1) {
                launchDeviceVpn();
            } else {
                this.deviceStatusText.setText(this.isRussian ? "Разрешение отклонено" : "Permission denied");
            }
        }
    }

    @Override // android.app.Activity
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        setContentView(R.layout.activity_main);
        final int i2 = 0;
        this.isRussian = "ru".equals(getSharedPreferences(PREFS_NAME, 0).getString(PREF_LANG, "en"));
        this.tabDomainBtn = (Button) findViewById(R.id.tabDomainBtn);
        this.tabTrafficBtn = (Button) findViewById(R.id.tabTrafficBtn);
        this.tabCheckerBtn = (Button) findViewById(R.id.tabCheckerBtn);
        this.tabMyInfoBtn = (Button) findViewById(R.id.tabMyInfoBtn);
        this.tabSpeedBtn = (Button) findViewById(R.id.tabSpeedBtn);
        this.tab1 = findViewById(R.id.tab1);
        this.tab2 = findViewById(R.id.tab2);
        final int i3 = 1;
        this.tabDomainBtn.setSelected(true);
        refreshTabLabels();
        this.tabDomainBtn.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i4 = i2;
                MainActivity mainActivity = this.f253b;
                switch (i4) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        final int i4 = 10;
        this.tabTrafficBtn.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i4;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        final int i5 = 14;
        this.tabCheckerBtn.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i5;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        final int i6 = 15;
        this.tabMyInfoBtn.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i6;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        final int i7 = 16;
        ((TextView) findViewById(R.id.menuBtn)).setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i7;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        this.domainInput = (EditText) findViewById(R.id.domainInput);
        this.lookupBtn = (Button) findViewById(R.id.lookupBtn);
        this.resultsContainer = (LinearLayout) findViewById(R.id.resultsContainer);
        this.statusText = (TextView) findViewById(R.id.statusText);
        final int i8 = 17;
        this.lookupBtn.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i8;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        this.domainInput.setOnEditorActionListener(new TextView.OnEditorActionListener(this) { // from class: com.netwatch.app.j

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f257b;

            {
                this.f257b = this;
            }

            @Override // android.widget.TextView.OnEditorActionListener
            public final boolean onEditorAction(TextView textView, int i9, KeyEvent keyEvent) {
                boolean lambda$onCreate$20;
                boolean lambda$onCreate$6;
                int i10 = i3;
                MainActivity mainActivity = this.f257b;
                switch (i10) {
                    case 0:
                        lambda$onCreate$20 = mainActivity.lambda$onCreate$20(textView, i9, keyEvent);
                        return lambda$onCreate$20;
                    default:
                        lambda$onCreate$6 = mainActivity.lambda$onCreate$6(textView, i9, keyEvent);
                        return lambda$onCreate$6;
                }
            }
        });
        this.appSpinner = (Spinner) findViewById(R.id.appSpinner);
        this.startMonBtn = (Button) findViewById(R.id.startMonBtn);
        this.stopMonBtn = (Button) findViewById(R.id.stopMonBtn);
        this.clearMonBtn = (Button) findViewById(R.id.clearMonBtn);
        this.monStatusText = (TextView) findViewById(R.id.monStatusText);
        this.txTotalText = (TextView) findViewById(R.id.txTotalText);
        this.rxTotalText = (TextView) findViewById(R.id.rxTotalText);
        this.txRateText = (TextView) findViewById(R.id.txRateText);
        this.rxRateText = (TextView) findViewById(R.id.rxRateText);
        this.hostLogContainer = (LinearLayout) findViewById(R.id.hostLogContainer);
        this.hostLogScroll = (ScrollView) findViewById(R.id.hostLogScroll);
        this.tab3 = (LinearLayout) findViewById(R.id.tab3);
        this.tab4 = findViewById(R.id.tab4);
        this.tab5 = (ScrollView) findViewById(R.id.tab5);
        this.myInfoContainer = (LinearLayout) findViewById(R.id.myInfoContainer);
        this.myInfoRefreshBtn = (Button) findViewById(R.id.myInfoRefreshBtn);
        this.myInfoTitleText = (TextView) findViewById(R.id.myInfoTitleText);
        this.selectAppLabel = (TextView) findViewById(R.id.selectAppLabel);
        this.liveHostsLabel = (TextView) findViewById(R.id.liveHostsLabel);
        this.myInfoDescText = (TextView) findViewById(R.id.myInfoDescText);
        this.myInfoTitleText = (TextView) findViewById(R.id.myInfoTitleText);
        this.selectAppLabel = (TextView) findViewById(R.id.selectAppLabel);
        this.liveHostsLabel = (TextView) findViewById(R.id.liveHostsLabel);
        this.myInfoDescText = (TextView) findViewById(R.id.myInfoDescText);
        this.checkAllBtn = (Button) findViewById(R.id.checkAllBtn);
        this.stopCheckBtn = (Button) findViewById(R.id.stopCheckBtn);
        this.checkStatusText = (TextView) findViewById(R.id.checkStatusText);
        this.checkResultsContainer = (LinearLayout) findViewById(R.id.checkResultsContainer);
        this.customDomainInput = (EditText) findViewById(R.id.customDomainInput);
        this.checkCustomBtn = (Button) findViewById(R.id.checkCustomBtn);
        this.connectionCountText = (TextView) findViewById(R.id.connectionCountText);
        this.exportDomainBtn = (Button) findViewById(R.id.exportDomainBtn);
        this.exportTrafficBtn = (Button) findViewById(R.id.exportTrafficBtn);
        this.alertSwitch = (SwitchCompat) findViewById(R.id.alertSwitch);
        final int i9 = 18;
        this.exportDomainBtn.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i9;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        final int i10 = 19;
        this.myInfoRefreshBtn.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i10;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        this.speedTitleText = (TextView) findViewById(R.id.speedTitleText);
        this.speedDescText = (TextView) findViewById(R.id.speedDescText);
        this.speedServerSpinner = (Spinner) findViewById(R.id.speedServerSpinner);
        this.speedRunBtn = (Button) findViewById(R.id.speedRunBtn);
        this.speedStatusText = (TextView) findViewById(R.id.speedStatusText);
        this.speedPingText = (TextView) findViewById(R.id.speedPingText);
        this.speedDownText = (TextView) findViewById(R.id.speedDownText);
        this.speedUpText = (TextView) findViewById(R.id.speedUpText);
        this.speedResultsContainer = (LinearLayout) findViewById(R.id.speedResultsContainer);
        String[] strArr = new String[SPEED_SERVERS.length];
        int i11 = 0;
        while (true) {
            String[][] strArr2 = SPEED_SERVERS;
            if (i11 >= strArr2.length) {
                break;
            }
            strArr[i11] = strArr2[i11][0];
            i11++;
        }
        ArrayAdapter arrayAdapter = new ArrayAdapter(this, android.R.layout.simple_spinner_item, strArr);
        arrayAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        this.speedServerSpinner.setAdapter((SpinnerAdapter) arrayAdapter);
        final int i12 = 20;
        this.speedRunBtn.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i12;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        this.tabSpeedBtn.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i3;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        this.tab6 = findViewById(R.id.tab6);
        this.deviceToggleBtn = (Button) findViewById(R.id.deviceToggleBtn);
        this.deviceExportBtn = (Button) findViewById(R.id.deviceExportBtn);
        this.deviceClearBtn = (Button) findViewById(R.id.deviceClearBtn);
        this.deviceTitleText = (TextView) findViewById(R.id.deviceTitleText);
        this.deviceStatusText = (TextView) findViewById(R.id.deviceStatusText);
        this.deviceCountText = (TextView) findViewById(R.id.deviceCountText);
        this.deviceLogContainer = (LinearLayout) findViewById(R.id.deviceLogContainer);
        this.deviceHeaderRow = (LinearLayout) findViewById(R.id.deviceHeaderRow);
        this.deviceScrollView = (ScrollView) findViewById(R.id.deviceScrollView);
        Button button = (Button) findViewById(R.id.tabDeviceBtn);
        this.tabDeviceBtn = button;
        final int i13 = 2;
        button.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i13;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        final int i14 = 3;
        this.deviceToggleBtn.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i14;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        final int i15 = 4;
        this.deviceClearBtn.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i15;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        final int i16 = 5;
        this.deviceExportBtn.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i16;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        final int i17 = 6;
        this.exportTrafficBtn.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i17;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        final SharedPreferences sharedPreferences = getSharedPreferences(PREFS_NAME, 0);
        boolean z = sharedPreferences.getBoolean("alerts_enabled", true);
        this.alertsEnabled = z;
        this.alertSwitch.setChecked(z);
        this.alertSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() { // from class: com.netwatch.app.i
            @Override // android.widget.CompoundButton.OnCheckedChangeListener
            public final void onCheckedChanged(CompoundButton compoundButton, boolean z2) {
                MainActivity.this.lambda$onCreate$16(sharedPreferences, compoundButton, z2);
            }
        });
        refreshUiStrings();
        final int i18 = 7;
        this.checkAllBtn.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i18;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        final int i19 = 8;
        this.stopCheckBtn.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i19;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        final int i20 = 9;
        this.checkCustomBtn.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i20;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        this.customDomainInput.setOnEditorActionListener(new TextView.OnEditorActionListener(this) { // from class: com.netwatch.app.j

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f257b;

            {
                this.f257b = this;
            }

            @Override // android.widget.TextView.OnEditorActionListener
            public final boolean onEditorAction(TextView textView, int i92, KeyEvent keyEvent) {
                boolean lambda$onCreate$20;
                boolean lambda$onCreate$6;
                int i102 = i2;
                MainActivity mainActivity = this.f257b;
                switch (i102) {
                    case 0:
                        lambda$onCreate$20 = mainActivity.lambda$onCreate$20(textView, i92, keyEvent);
                        return lambda$onCreate$20;
                    default:
                        lambda$onCreate$6 = mainActivity.lambda$onCreate$6(textView, i92, keyEvent);
                        return lambda$onCreate$6;
                }
            }
        });
        buildCheckerRows();
        this.trustedDomains.addAll(Arrays.asList("google.com", "googleapis.com", "gstatic.com", "googlevideo.com", "googleusercontent.com", "akamai.net", "akamaized.net", "akamaitechnologies.com", "akamaiedge.net", "cloudflare.com", "cloudflare.net", "cdn.cloudflare.net", "fastly.net", "fastly.com", "amazon.com", "amazonaws.com", "awsstatic.com", "cloudfront.net", "microsoft.com", "azure.com", "msftconnecttest.com", "msedge.net", "apple.com", "icloud.com", "mzstatic.com", "facebook.com", "fbcdn.net", "instagram.com", "twitter.com", "twimg.com", "android.com", "android.clients.google.com"));
        final int i21 = 11;
        this.startMonBtn.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i21;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        final int i22 = 12;
        this.stopMonBtn.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i22;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        final int i23 = 13;
        this.clearMonBtn.setOnClickListener(new View.OnClickListener(this) { // from class: com.netwatch.app.h

            /* renamed from: b, reason: collision with root package name */
            public final /* synthetic */ MainActivity f253b;

            {
                this.f253b = this;
            }

            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                int i42 = i23;
                MainActivity mainActivity = this.f253b;
                switch (i42) {
                    case 0:
                        mainActivity.lambda$onCreate$0(view);
                        return;
                    case 1:
                        mainActivity.lambda$onCreate$10(view);
                        return;
                    case 2:
                        mainActivity.lambda$onCreate$11(view);
                        return;
                    case 3:
                        mainActivity.lambda$onCreate$12(view);
                        return;
                    case 4:
                        mainActivity.lambda$onCreate$13(view);
                        return;
                    case 5:
                        mainActivity.lambda$onCreate$14(view);
                        return;
                    case 6:
                        mainActivity.lambda$onCreate$15(view);
                        return;
                    case 7:
                        mainActivity.lambda$onCreate$17(view);
                        return;
                    case 8:
                        mainActivity.lambda$onCreate$18(view);
                        return;
                    case 9:
                        mainActivity.lambda$onCreate$19(view);
                        return;
                    case 10:
                        mainActivity.lambda$onCreate$1(view);
                        return;
                    case 11:
                        mainActivity.lambda$onCreate$21(view);
                        return;
                    case 12:
                        mainActivity.lambda$onCreate$22(view);
                        return;
                    case 13:
                        mainActivity.lambda$onCreate$23(view);
                        return;
                    case 14:
                        mainActivity.lambda$onCreate$2(view);
                        return;
                    case 15:
                        mainActivity.lambda$onCreate$3(view);
                        return;
                    case 16:
                        mainActivity.lambda$onCreate$4(view);
                        return;
                    case 17:
                        mainActivity.lambda$onCreate$5(view);
                        return;
                    case 18:
                        mainActivity.lambda$onCreate$7(view);
                        return;
                    case 19:
                        mainActivity.lambda$onCreate$8(view);
                        return;
                    default:
                        mainActivity.lambda$onCreate$9(view);
                        return;
                }
            }
        });
        this.appSpinner.setTag("init");
        this.appSpinner.setOnItemSelectedListener(new AnonymousClass1());
        this.trafficReceiver = new BroadcastReceiver() { // from class: com.netwatch.app.MainActivity.2
            @Override // android.content.BroadcastReceiver
            public void onReceive(Context context, Intent intent) {
                MainActivity.this.updateStats(intent.getLongExtra(TrafficMonitorService.EXTRA_TX_BYTES, 0L), intent.getLongExtra(TrafficMonitorService.EXTRA_RX_BYTES, 0L), intent.getLongExtra(TrafficMonitorService.EXTRA_TX_RATE, 0L), intent.getLongExtra(TrafficMonitorService.EXTRA_RX_RATE, 0L), intent.getStringExtra(TrafficMonitorService.EXTRA_HOSTS));
            }
        };
        IntentFilter intentFilter = new IntentFilter(TrafficMonitorService.EVENT_ACTION);
        int i24 = Build.VERSION.SDK_INT;
        if (i24 >= 33) {
            registerReceiver(this.trafficReceiver, intentFilter, 2);
        } else {
            registerReceiver(this.trafficReceiver, intentFilter);
        }
        if (i24 >= 33 && checkSelfPermission("android.permission.POST_NOTIFICATIONS") != 0) {
            requestPermissions(new String[]{"android.permission.POST_NOTIFICATIONS"}, 1002);
        }
        loadAppList();
    }

    @Override // android.app.Activity
    public void onDestroy() {
        super.onDestroy();
        try {
            unregisterReceiver(this.trafficReceiver);
        } catch (Exception unused) {
        }
        BroadcastReceiver broadcastReceiver = this.deviceReceiver;
        if (broadcastReceiver != null) {
            try {
                unregisterReceiver(broadcastReceiver);
            } catch (Exception unused2) {
            }
        }
        if (this.deviceMonRunning) {
            stopDeviceMonitor();
        }
        this.executor.shutdownNow();
    }
}
