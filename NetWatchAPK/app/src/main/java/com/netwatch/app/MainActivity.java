package com.netwatch.app;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.Typeface;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONObject;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.URL;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;
import android.view.ViewParent;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Map;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.SharedPreferences;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.widget.CompoundButton;
import androidx.appcompat.widget.SwitchCompat;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Arrays;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import android.app.AlertDialog;
import android.view.MenuItem;
import android.widget.PopupMenu;
import android.widget.TextView;
import androidx.core.view.ViewCompat;
import androidx.activity.EdgeToEdge;
import androidx.core.view.WindowInsetsCompat;
import androidx.core.graphics.Insets;

public class MainActivity extends androidx.appcompat.app.AppCompatActivity {

    private static final String DOMAIN_INTEL_URL  = "https://superagent-cfb25b3e.base44.app/functions/domainIntel";
    private static final int    NOTIF_PERM_CODE   = 1002;

    // ── Tabs ────────────────────────────────────────────────────────────────
    private View   tab1, tab2;
    private View   tab5, tab6, tab7;

    // ── Tab 7 — Network Tools ────────────────────────────────────────────────
    private static final int TOOL_PING = 0, TOOL_TRACE = 1, TOOL_PORT = 2, TOOL_DNS = 3;
    private int     toolMode = TOOL_PING;
    private boolean toolsRunning = false;
    private Process toolsProc = null;
    private Button  tabToolsBtn, toolPingBtn, toolTraceBtn, toolPortBtn, toolDnsBtn, toolsRunBtn, toolsStopBtn;
    private EditText toolsHostInput, toolsPortInput;
    private TextView toolsTitleText, toolsStatusText, toolsConsoleText;
    private android.widget.ScrollView toolsScrollView;

    // ── Speed-test server table [label, url, type] ──────────────────────────
    private static final String[][] SPEED_SERVERS = {
        {"🇺🇸 US East    (Linode Newark)",      "http://speedtest.newark.linode.com",         "linode"},
        {"🇺🇸 US West    (Linode Fremont)",      "http://speedtest.fremont.linode.com",         "linode"},
        {"🇨🇦 Canada     (Linode Toronto)",      "http://speedtest.toronto.linode.com",         "linode"},
        {"🇬🇧 EU         (Linode London)",        "http://speedtest.london.linode.com",          "linode"},
        {"🇩🇪 EU         (Linode Frankfurt)",     "http://speedtest.frankfurt.linode.com",       "linode"},
        {"🇸🇬 Asia       (Linode Singapore)",     "http://speedtest.singapore.linode.com",       "linode"},
        {"🇯🇵 Asia       (Linode Tokyo)",         "http://speedtest.tokyo2.linode.com",          "linode"},
        {"🇺🇸 US NYC     (Ookla Armstrong)",      "http://speedtest-ad-1.zoominternet.net:8080", "ookla"},
        {"🇺🇸 US LA      (Ookla GeoLinks)",       "http://la-ookla.geolinks.com:8080",           "ookla"},
        {"🇺🇸 US Chicago (Ookla Highline)",       "http://stchi.highlinefast.com:8080",          "ookla"},
        {"🇺🇸 US Dallas  (Ookla Frontier)",       "http://dallas.tx.speedtest.frontier.com:8080","ookla"},
        {"🇺🇸 US Miami   (Ookla BlueStream)",     "http://speedtest03.bluestreamfiber.net:8080", "ookla"},
        {"🇺🇸 US Seattle (Ookla Ziply)",          "http://speedtest1-sttlwawb.as20055.net:8080", "ookla"},
        {"🇺🇸 US Atlanta (Ookla Point)",          "http://speedtest14.point-broadband.com:8080", "ookla"},
        {"🇷🇺 Russia     (Selectel Moscow)",       "http://speedtest.selectel.ru",                "linode"},
        {"🇷🇺 Russia     (Yandex Internetometer)",  "https://yandex.com/internet",                 "yandex"},
        {"🌍 Global      (Cloudflare)",            "https://speed.cloudflare.com",                "cloudflare"},
    };

    private Button tabDomainBtn, tabTrafficBtn, tabCheckerBtn, tabMyInfoBtn, tabSpeedBtn, tabDeviceBtn;
    private android.widget.TextView speedDescText;

    // ── Tab 1 – Domain Intel ────────────────────────────────────────────────
    private EditText     domainInput;
    private Button       lookupBtn;
    private LinearLayout resultsContainer;
    private TextView     statusText;

    // ── Tab 2 – Traffic Monitor ─────────────────────────────────────────────
    private Spinner      appSpinner;
    private Button       startMonBtn, stopMonBtn, clearMonBtn;
    private TextView     monStatusText;
    private TextView     myInfoTitleText, myInfoDescText;
    private TextView     selectAppLabel, liveHostsLabel;
    private TextView     txTotalText, rxTotalText, txRateText, rxRateText;
    private LinearLayout hostLogContainer;
    private ScrollView   hostLogScroll;
    private TextView     connectionCountText;

    private List<AppEntry>       appList      = new ArrayList<>();
    private ArrayAdapter<AppEntry> appAdapter;
    private AppEntry             selectedApp  = null;
    private boolean              monitoring   = false;
    private int                  hostCount    = 0;
    private final Set<String>    seenHosts    = new HashSet<>();
    // Raw log data for export: host line → timestamp string
    private final LinkedHashMap<String, String> trafficLogForExport = new LinkedHashMap<>();
    // Domain Intel last result for export
    private String lastDomainForExport = "";
    private String lastIntelJsonForExport = "";
    private String lastProbeJsonForExport = "";

    private Button       exportDomainBtn, exportTrafficBtn, myInfoRefreshBtn;
    private LinearLayout myInfoContainer;
    private SwitchCompat alertSwitch;
    private boolean      alertsEnabled  = false; // off by default — user must opt in

    // --- Tab 3: Domain Checker ---
    private LinearLayout  tab3;
    private View           tab4;
    private Button        checkAllBtn, stopCheckBtn;
    private TextView      checkStatusText;
    private LinearLayout  checkResultsContainer;
    private final AtomicBoolean checkRunning = new AtomicBoolean(false);
    private EditText      customDomainInput;
    private Button        checkCustomBtn;
    // Last known stats — reapplied when tab2 becomes visible
    private long lastKnownTx = -1, lastKnownRx = -1, lastKnownTxRate = 0, lastKnownRxRate = 0;
    // Trusted domains for the current monitoring session (auto-seeded + user-approved)
    private final Set<String> trustedDomains = Collections.synchronizedSet(new HashSet<>());
    // Root domain of the currently monitored app (e.g. "paypal.com")
    private String monitoredRootDomain = "";
    private static final String PREFS_NAME = "netwatch_prefs";
    private static final String PREF_LANG   = "language";   // "en" or "ru"
    private boolean isRussian = false;
    private BroadcastReceiver trafficReceiver;
    private final ExecutorService executor    = Executors.newCachedThreadPool();
    private static final String IP_WHOIS_URL = "https://superagent-cfb25b3e.base44.app/functions/ipWhois";
    private final Handler         mainHandler = new Handler(Looper.getMainLooper());
    private long monitoringStartTime = 0L;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);


        // ── Edge-to-edge insets (Android 15+ / SDK 35) ──────────────────────
        android.view.View rootView = findViewById(android.R.id.content);
        ViewCompat.setOnApplyWindowInsetsListener(rootView, (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars()
                    | WindowInsetsCompat.Type.displayCutout());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return WindowInsetsCompat.CONSUMED;
        });

        // Language preference
        SharedPreferences prefs0 = getSharedPreferences(PREFS_NAME, MODE_PRIVATE);
        isRussian = "ru".equals(prefs0.getString(PREF_LANG, "en"));
        applyPerAppLocale(); // makes the system VPN consent dialog follow the app language

        // Tabs
        tabDomainBtn  = findViewById(R.id.tabDomainBtn);
        tabTrafficBtn = findViewById(R.id.tabTrafficBtn);
        tabCheckerBtn = findViewById(R.id.tabCheckerBtn);
        tabMyInfoBtn  = findViewById(R.id.tabMyInfoBtn);
        tab1          = findViewById(R.id.tab1);
        tab2          = findViewById(R.id.tab2);
        tabDomainBtn.setSelected(true);
        refreshTabLabels();
        tabDomainBtn.setOnClickListener(v  -> switchTab(0));
        tabTrafficBtn.setOnClickListener(v -> switchTab(1));
        tabCheckerBtn.setOnClickListener(v -> switchTab(2));
        tabMyInfoBtn.setOnClickListener(v  -> switchTab(3));
        tabSpeedBtn   = findViewById(R.id.tabSpeedBtn);
        speedDescText = findViewById(R.id.speedDescText);
        tabDeviceBtn  = findViewById(R.id.tabDeviceBtn);
        tab5          = findViewById(R.id.tab5);
        tab6          = findViewById(R.id.tab6);
        tab7          = findViewById(R.id.tab7);
        tabToolsBtn   = findViewById(R.id.tabToolsBtn);
        if (tabSpeedBtn  != null) tabSpeedBtn.setOnClickListener(v  -> switchTab(4));
        if (tabDeviceBtn != null) tabDeviceBtn.setOnClickListener(v -> switchTab(5));
        if (tabToolsBtn  != null) tabToolsBtn.setOnClickListener(v -> switchTab(6));
        initToolsTab();

        // ── Top-right menu button ────────────────────────────────────────────
        TextView menuBtn = findViewById(R.id.menuBtn);
        menuBtn.setOnClickListener(v -> showMainMenu(v));

        domainInput      = findViewById(R.id.domainInput);
        lookupBtn        = findViewById(R.id.lookupBtn);
        resultsContainer = findViewById(R.id.resultsContainer);
        statusText       = findViewById(R.id.statusText);
        lookupBtn.setOnClickListener(v -> performLookup());
        domainInput.setOnEditorActionListener((v, action, event) -> { performLookup(); return true; });

        // Tab 2
        appSpinner         = findViewById(R.id.appSpinner);
        startMonBtn        = findViewById(R.id.startMonBtn);
        stopMonBtn         = findViewById(R.id.stopMonBtn);
        clearMonBtn        = findViewById(R.id.clearMonBtn);
        monStatusText      = findViewById(R.id.monStatusText);
        txTotalText        = findViewById(R.id.txTotalText);
        rxTotalText        = findViewById(R.id.rxTotalText);
        txRateText         = findViewById(R.id.txRateText);
        rxRateText         = findViewById(R.id.rxRateText);
        hostLogContainer   = findViewById(R.id.hostLogContainer);
        hostLogScroll      = findViewById(R.id.hostLogScroll);

        // Tab 3
        tab3                = findViewById(R.id.tab3);
        tab4                = findViewById(R.id.tab4);
        myInfoContainer     = findViewById(R.id.myInfoContainer);
        myInfoRefreshBtn    = findViewById(R.id.myInfoRefreshBtn);
        myInfoTitleText    = findViewById(R.id.myInfoTitleText);
        selectAppLabel     = findViewById(R.id.selectAppLabel);
        liveHostsLabel     = findViewById(R.id.liveHostsLabel);
        myInfoDescText     = findViewById(R.id.myInfoDescText);
        myInfoTitleText    = findViewById(R.id.myInfoTitleText);
        selectAppLabel     = findViewById(R.id.selectAppLabel);
        liveHostsLabel     = findViewById(R.id.liveHostsLabel);
        myInfoDescText     = findViewById(R.id.myInfoDescText);
        checkAllBtn         = findViewById(R.id.checkAllBtn);
        stopCheckBtn        = findViewById(R.id.stopCheckBtn);
        checkStatusText     = findViewById(R.id.checkStatusText);
        checkResultsContainer = findViewById(R.id.checkResultsContainer);
        customDomainInput = findViewById(R.id.customDomainInput);
        checkCustomBtn    = findViewById(R.id.checkCustomBtn);
        connectionCountText= findViewById(R.id.connectionCountText);

        exportDomainBtn    = findViewById(R.id.exportDomainBtn);
        exportTrafficBtn   = findViewById(R.id.exportTrafficBtn);
        alertSwitch        = findViewById(R.id.alertSwitch);
        exportDomainBtn.setOnClickListener(v -> exportDomainIntel());
        myInfoRefreshBtn.setOnClickListener(v -> lookupMyInfo());
        exportTrafficBtn.setOnClickListener(v -> exportTrafficLog());

        // Restore alert toggle preference
        SharedPreferences prefs = getSharedPreferences(PREFS_NAME, MODE_PRIVATE);
        alertsEnabled = prefs.getBoolean("alerts_enabled", false); // off by default — user must opt in
        alertSwitch.setChecked(alertsEnabled);
        alertSwitch.setOnCheckedChangeListener((btn, checked) -> {
            alertsEnabled = checked;
            prefs.edit().putBoolean("alerts_enabled", checked).apply();
        });

        // Apply localized strings now that all views are initialized
        refreshUiStrings();

        checkAllBtn.setOnClickListener(v -> startDomainCheck());
        stopCheckBtn.setOnClickListener(v  -> stopDomainCheck());
        checkCustomBtn.setOnClickListener(v -> checkCustomDomain());
        customDomainInput.setOnEditorActionListener((tv, actionId, event) -> {
            checkCustomDomain();
            return true;
        });
        buildCheckerRows();

        // Seed global trusted CDN/cloud providers (never want to alert on these)
        trustedDomains.addAll(Arrays.asList(
            "google.com","googleapis.com","gstatic.com","googlevideo.com","googleusercontent.com",
            "akamai.net","akamaized.net","akamaitechnologies.com","akamaiedge.net",
            "cloudflare.com","cloudflare.net","cdn.cloudflare.net",
            "fastly.net","fastly.com",
            "amazon.com","amazonaws.com","awsstatic.com","cloudfront.net",
            "microsoft.com","azure.com","msftconnecttest.com","msedge.net",
            "apple.com","icloud.com","mzstatic.com",
            "facebook.com","fbcdn.net","instagram.com",
            "twitter.com","twimg.com",
            "android.com","android.clients.google.com"
        ));
        startMonBtn.setOnClickListener(v -> startMonitoring());
        stopMonBtn.setOnClickListener(v -> stopMonitoring());
        clearMonBtn.setOnClickListener(v -> clearLog());

        // Track whether the spinner is being set up for the first time (don't launch on init)
        appSpinner.setTag("init");
        appSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override public void onItemSelected(AdapterView<?> p, View v, int pos, long id) {
                selectedApp = appList.isEmpty() ? null : appList.get(pos);
                // Don't auto-launch on initial population of the spinner
                if ("init".equals(appSpinner.getTag())) {
                    appSpinner.setTag(null);
                    return;
                }
                // Launch the selected app and auto-start monitoring
                if (selectedApp != null && !selectedApp.packageName.isEmpty()) {
                    // If already monitoring another app, stop it first
                    if (monitoring) stopMonitoring();
                    // Seed trusted domains for the newly selected app
                    seedTrustedDomains(selectedApp.packageName);
                    // Start monitoring first so we capture traffic from the moment the app opens
                    startMonitoring();
                    // Small delay so monitoring is running before the app comes to foreground
                    mainHandler.postDelayed(() -> launchApp(selectedApp.packageName), 400);
                }
            }
            @Override public void onNothingSelected(AdapterView<?> p) {}
        });

        // Register broadcast receiver for traffic events
        trafficReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context ctx, Intent intent) {
                if (intent.getBooleanExtra(TrafficMonitorService.EXTRA_FALLBACK_NOTICE, false)) {
                    showFallbackNotice();
                    return;
                }
                long txBytes = intent.getLongExtra(TrafficMonitorService.EXTRA_TX_BYTES, 0);
                long rxBytes = intent.getLongExtra(TrafficMonitorService.EXTRA_RX_BYTES, 0);
                long txRate  = intent.getLongExtra(TrafficMonitorService.EXTRA_TX_RATE,  0);
                long rxRate  = intent.getLongExtra(TrafficMonitorService.EXTRA_RX_RATE,  0);
                String hosts = intent.getStringExtra(TrafficMonitorService.EXTRA_HOSTS);
                updateStats(txBytes, rxBytes, txRate, rxRate, hosts);
            }
        };
        IntentFilter f = new IntentFilter(TrafficMonitorService.EVENT_ACTION);
        // Must use RECEIVER_EXPORTED (or no flag pre-T) because the broadcast
        // has setPackage() applied — Android still routes it correctly.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(trafficReceiver, f, Context.RECEIVER_EXPORTED);
        } else {
            registerReceiver(trafficReceiver, f);
        }

        // Notification permission
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS)
                    != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(
                    new String[]{android.Manifest.permission.POST_NOTIFICATIONS},
                    NOTIF_PERM_CODE);
            }
        }

        // Load app list in background
        loadAppList();

    }

    // ── Launch App ──────────────────────────────────────────────────────────

    private void launchApp(String packageName) {
        try {
            PackageManager pm = getPackageManager();
            Intent launch = pm.getLaunchIntentForPackage(packageName);
            if (launch != null) {
                launch.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(launch);
            } else {
                showToast(isRussian ? "Невозможно запустить — фоновый сервис" : "Can't launch — app may be a background service");
            }
        } catch (Exception e) {
            showToast("Could not open app: " + e.getMessage());
        }
    }

    // ── App List ─────────────────────────────────────────────────────────────

    // ── Main popup menu ──────────────────────────────────────────────────────
    private void showMainMenu(android.view.View anchor) {
        PopupMenu popup = new PopupMenu(this, anchor);
        popup.getMenuInflater().inflate(R.menu.main_menu, popup.getMenu());

        // Update menu label to show current language
        popup.getMenu().findItem(R.id.menu_language)
             .setTitle(isRussian ? "🌍 Language: Русский" : "🌍 Language: English");

        popup.setOnMenuItemClickListener(item -> {
            int id = item.getItemId();
            if (id == R.id.menu_instructions_domain) {
                if (isRussian) {
                    showInfoDialog("🔍 Domain Intel — Справка",
                        "Введите доменное имя и нажмите Поиск.\n\n" +
                        "Результаты включают:\n" +
                        "  • IP-адреса (A-записи)\n" +
                        "  • Обнаруженные поддомены\n" +
                        "  • Информация WHOIS\n" +
                        "  • Geo-IP локация сервера\n\n" +
                        "Нажмите Экспорт для сохранения результатов в CSV.");
                } else {
                    showInfoDialog("🔍 Domain Intel — Help",
                        "Enter any domain name and tap Lookup.\n\n" +
                        "Results include:\n" +
                        "  • IP Addresses (A records)\n" +
                        "  • Subdomains detected\n" +
                        "  • WHOIS registration info\n" +
                        "  • Geo-IP location of the server\n\n" +
                        "Tap Export to save results as a CSV file.");
                }
                return true;
            } else if (id == R.id.menu_instructions_traffic) {
                if (isRussian) {
                    showInfoDialog("📡 Монитор трафика — Справка",
                        "Мониторинг сетевых соединений для любого приложения или всего устройства.\n\n" +
                        "Как использовать:\n" +
                        "  1. Выберите приложение из списка (или «Всё устройство»)\n" +
                        "  2. Нажмите Старт — выбранное приложение запустится автоматически\n" +
                        "  3. NetWatch фиксирует все исходящие соединения в реальном времени\n\n" +
                        "Возможности:\n" +
                        "  • Geo-IP поиск для каждого соединения\n" +
                        "  • Обнаружение смежных доменов (CDN, поддомены)\n" +
                        "  • Вибрация при соединении с неизвестным доменом\n" +
                        "  • Экспорт лога соединений в формате RFC 4180 CSV\n" +
                        "  • Мониторинг автоматически останавливается при закрытии NetWatch\n" +
                        "  • Каждая сессия автоматически сохраняется в 🕓 Историю соединений (меню)\n\n" +
                        "Нажмите на строку домена — запустит полное сканирование Domain Intel (поддомены, CDN, IP).\n" +
                        "Долгое нажатие на строку — копирует хост или IP в буфер обмена.");
                } else {
                    showInfoDialog("📡 Traffic Monitor — Help",
                        "Monitor live network connections for any installed app.\n\n" +
                        "How to use:\n" +
                        "  1. Select an app from the dropdown\n" +
                        "  2. Tap Start — the selected app launches automatically\n" +
                        "  3. NetWatch captures all outbound connections in real-time\n\n" +
                        "Features:\n" +
                        "  • Geo-IP lookup for every connection\n" +
                        "  • Companion domain detection (CDNs, subdomains)\n" +
                        "  • Vibration alert for unknown/unlisted domains\n" +
                        "  • Export connection log as RFC 4180 CSV\n" +
                        "  • Monitoring automatically stops when NetWatch itself is closed\n" +
                        "  • Every session is auto-saved to 🕓 Connection History (overflow menu)\n\n" +
                        "Tap a domain row — runs a full Domain Intel scan (subdomains, CDN, IPs).\n" +
                        "Long-press a domain row — copy hostname or IP to clipboard.");
                }
                return true;
            } else if (id == R.id.menu_instructions_checker) {
                if (isRussian) {
                    showInfoDialog("✅ Проверка доменов — Справка",
                        "Быстрая проверка доступности известных сервисных доменов.\n\n" +
                        "Категории:\n" +
                        "  • Google, Microsoft, Cloudflare\n" +
                        "  • Соцсети и мессенджеры (включая GitHub)\n" +
                        "  • Стриминг (Netflix, Hulu, Spotify, Twitch)\n" +
                        "  • Финансы и платежи\n" +
                        "  • Игры (Xbox, PlayStation)\n" +
                        "  • AI-сервисы (ChatGPT, Gemini)\n\n" +
                        "Статус каждого домена:\n" +
                        "  🟢 Доступен  |  🔴 Заблокирован / Недоступен\n\n" +
                        "Нажмите «Проверить всё» для запуска всех тестов.\n" +
                        "Используйте поле ввода вверху для проверки любого домена вручную.");
                } else {
                    showInfoDialog("✅ Domain Checker — Help",
                        "Quickly verify connectivity to well-known service domains.\n\n" +
                        "Categories include:\n" +
                        "  • Google, Microsoft, Cloudflare\n" +
                        "  • Social & Messaging (incl. GitHub)\n" +
                        "  • Streaming (Netflix, Hulu, Spotify, Twitch)\n" +
                        "  • Finance & Payments\n" +
                        "  • Gaming (Xbox, PlayStation)\n" +
                        "  • AI Services (ChatGPT, Gemini)\n\n" +
                        "Each domain shows a live status:\n" +
                        "  🟢 Reachable  |  🔴 Blocked / Unreachable\n\n" +
                        "Tap Check All to run all tests at once.\n" +
                        "Use the custom input at the top to test any domain manually.");
                }
                return true;
            } else if (id == R.id.menu_instructions_myinfo) {
                if (isRussian) {
                    showInfoDialog("🌐 Мои данные — Справка",
                        "Отображает актуальную информацию о вашем сетевом подключении.\n\n" +
                        "Показываемые данные:\n" +
                        "  • Публичный IP-адрес\n" +
                        "  • Провайдер / Сеть\n" +
                        "  • Город, регион, страна\n" +
                        "  • GPS-координаты (нажмите для выбора приложения карт)\n" +
                        "  • Часовой пояс\n\n" +
                        "Данные получены от ipinfo.io.\n" +
                        "Нажмите Обновить для актуализации информации.");
                } else {
                    showInfoDialog("🌐 My Info — Help",
                        "Displays live information about your current network connection.\n\n" +
                        "Shown details:\n" +
                        "  • Public IP Address\n" +
                        "  • ISP / Network Provider\n" +
                        "  • City, Region, Country\n" +
                        "  • GPS Coordinates (tap to open in your preferred maps app)\n" +
                        "  • Timezone\n\n" +
                        "Data is fetched from ipinfo.io.\n" +
                        "Tap Refresh to update at any time.");
                }
                return true;
            } else if (id == R.id.menu_instructions_speed) {
                if (isRussian) {
                    showInfoDialog("\u26a1 \u0422\u0435\u0441\u0442 \u0441\u043a\u043e\u0440\u043e\u0441\u0442\u0438 \u2014 \u0421\u043f\u0440\u0430\u0432\u043a\u0430",
                        "\u0418\u0437\u043c\u0435\u0440\u0435\u043d\u0438\u0435 \u0441\u043a\u043e\u0440\u043e\u0441\u0442\u0438 \u0437\u0430\u0433\u0440\u0443\u0437\u043a\u0438, \u043e\u0442\u0434\u0430\u0447\u0438 \u0438 \u0437\u0430\u0434\u0435\u0440\u0436\u043a\u0438.\n\n" +
                        "\u041a\u0430\u043a \u0438\u0441\u043f\u043e\u043b\u044c\u0437\u043e\u0432\u0430\u0442\u044c:\n" +
                        "  1. \u0412\u044b\u0431\u0435\u0440\u0438\u0442\u0435 \u0440\u0435\u0433\u0438\u043e\u043d\n" +
                        "  2. \u041d\u0430\u0436\u043c\u0438\u0442\u0435 \u00ab\u0417\u0430\u043f\u0443\u0441\u0442\u0438\u0442\u044c \u0442\u0435\u0441\u0442\u00bb\n" +
                        "  3. \u0414\u043e\u0436\u0434\u0438\u0442\u0435\u0441\u044c ~15 \u0441\u0435\u043a\u0443\u043d\u0434\n\n" +
                        "\u0420\u0435\u0437\u0443\u043b\u044c\u0442\u0430\u0442\u044b: \u0437\u0430\u0433\u0440\u0443\u0437\u043a\u0430, \u043e\u0442\u0434\u0430\u0447\u0430 (\u041c\u0431\u0438\u0442/\u0441), \u0437\u0430\u0434\u0435\u0440\u0436\u043a\u0430 (\u043c\u0441).");
                } else {
                    showInfoDialog("Speed Test \u2014 Help",
                        "Measure download speed, upload speed, and latency to public test servers.\n\n" +
                        "How to use:\n" +
                        "  1. Select a region from the dropdown\n" +
                        "  2. Tap Run Speed Test\n" +
                        "  3. Wait ~15 seconds for results\n\n" +
                        "Results: download, upload (Mbps), latency (ms).");
                }
                return true;
            } else if (id == R.id.menu_instructions_device) {
                if (isRussian) {
                    showInfoDialog("\ud83d\udcf6 \u041c\u043e\u043d\u0438\u0442\u043e\u0440 \u0443\u0441\u0442\u0440\u043e\u0439\u0441\u0442\u0432\u0430 \u2014 \u0421\u043f\u0440\u0430\u0432\u043a\u0430",
                        "\u041c\u043e\u043d\u0438\u0442\u043e\u0440\u0438\u043d\u0433 \u0432\u0441\u0435\u0433\u043e \u0442\u0440\u0430\u0444\u0438\u043a\u0430 \u0447\u0435\u0440\u0435\u0437 \u043b\u043e\u043a\u0430\u043b\u044c\u043d\u044b\u0439 VPN-\u0442\u0443\u043d\u043d\u0435\u043b\u044c.\n\n" +
                        "\u041a\u0430\u043a \u0438\u0441\u043f\u043e\u043b\u044c\u0437\u043e\u0432\u0430\u0442\u044c:\n" +
                        "  1. \u041d\u0430\u0436\u043c\u0438\u0442\u0435 \u0421\u0442\u0430\u0440\u0442 \u2014 Android \u0437\u0430\u043f\u0440\u043e\u0441\u0438\u0442 \u0440\u0430\u0437\u0440\u0435\u0448\u0435\u043d\u0438\u0435 VPN\n" +
                        "  2. \u041f\u0440\u0438\u043c\u0438\u0442\u0435 \u0437\u0430\u043f\u0440\u043e\u0441\n" +
                        "  3. \u0412\u0441\u0435 \u0441\u043e\u0435\u0434\u0438\u043d\u0435\u043d\u0438\u044f \u043e\u0442\u043e\u0431\u0440\u0430\u0436\u0430\u044e\u0442\u0441\u044f \u0432 \u0440\u0435\u0430\u043b\u044c\u043d\u043e\u043c \u0432\u0440\u0435\u043c\u0435\u043d\u0438\n\n" +
                        "\u041a\u0430\u0436\u0434\u0430\u044f \u0437\u0430\u043f\u0438\u0441\u044c: \u0445\u043e\u0441\u0442, \u043f\u0440\u043e\u0442\u043e\u043a\u043e\u043b, \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u0435, \u0432\u0440\u0435\u043c\u044f.\n" +
                        "\u042d\u043a\u0441\u043f\u043e\u0440\u0442 \u043b\u043e\u0433\u0430 \u0432 CSV, \u043a\u043d\u043e\u043f\u043a\u0430 \u0421\u0442\u043e\u043f \u0434\u043b\u044f \u043e\u0441\u0442\u0430\u043d\u043e\u0432\u043a\u0438.");
                } else {
                    showInfoDialog("Device Monitor \u2014 Help",
                        "Monitor all device network traffic using a local VPN tunnel.\n\n" +
                        "How to use:\n" +
                        "  1. Tap Start \u2014 Android will ask for VPN permission\n" +
                        "  2. Accept the prompt\n" +
                        "  3. All connections are logged in real-time\n\n" +
                        "Each entry: host/IP, protocol, app name, timestamp.\n" +
                        "Tap Export to save as CSV. Tap Stop to close the tunnel.");
                }
                return true;
            } else if (id == R.id.menu_instructions_tools) {
                if (isRussian) {
                    showInfoDialog("🛠 Сетевые инструменты — Справка",
                        "Базовые сетевые утилиты прямо в NetWatch.\n\n" +
                        "Инструменты:\n" +
                        "  • PING — проверка доступности хоста (4 пакета ICMP)\n" +
                        "  • TRACE — трассировка маршрута (до 30 прыжков, без root)\n" +
                        "  • PORT — проверка TCP-порта (открыт/закрыт)\n" +
                        "  • DNS — запросы A / AAAA / CNAME / TXT-записей\n\n" +
                        "Введите хост или IP, выберите инструмент и нажмите ПУСК.\n" +
                        "Для PORT укажите порт (или введите host:port).\n" +
                        "Кнопка СТОП прерывает выполнение.");
                } else {
                    showInfoDialog("🛠 Network Tools — Help",
                        "Basic network utilities right inside NetWatch.\n\n" +
                        "Tools:\n" +
                        "  • PING — check host reachability (4 ICMP echoes)\n" +
                        "  • TRACE — trace the route (up to 30 hops, rootless)\n" +
                        "  • PORT — check if a TCP port is open or closed\n" +
                        "  • DNS — look up A / AAAA / CNAME / TXT records\n\n" +
                        "Enter a host or IP, pick a tool, tap RUN.\n" +
                        "For PORT, enter the port (or use host:port syntax).\n" +
                        "Tap STOP to interrupt a running tool.");
                }
                return true;
            } else if (id == R.id.menu_history) {
                showConnectionHistory();
                return true;
            } else if (id == R.id.menu_language) {
                showLanguageDialog();
                return true;
            } else if (id == R.id.menu_about) {
                String versionName = "1.4.5";
                try {
                    versionName = getPackageManager().getPackageInfo(getPackageName(), 0).versionName;
                } catch (Exception ignored) {}
                if (isRussian) {
                    showInfoDialog("ℹ️ О программе NetWatch",
                        "◈ NETWATCH\n" +
                        "Версия " + versionName + "\n\n" +
                        "Профессиональный инструмент сетевой разведки для Android.\n\n" +
                        "Возможности:\n" +
                        "  • Анализ доменов и WHOIS-запросы\n" +
                        "  • Мониторинг трафика приложений в реальном времени\n" +
                        "  • Проверка доступности доменов\n" +
                        "  • Актуальная информация о сети и Geo-IP\n" +
                        "  • Тест скорости (загрузка, отдача, задержка)\n" +
                        "  • Монитор трафика устройства (VPN)\n\n" +
                        "Создано с ❤️ с помощью Base44 Superagent.");
                } else {
                    showInfoDialog("ℹ️ About NetWatch",
                        "◈ NETWATCH\n" +
                        "Version " + versionName + "\n\n" +
                        "A professional-grade network intelligence tool for Android.\n\n" +
                        "Features:\n" +
                        "  • Domain Intelligence & WHOIS lookup\n" +
                        "  • Real-time per-app traffic monitoring\n" +
                        "  • Domain reachability checker\n" +
                        "  • Live network & geo-IP info\n" +
                        "  • Speed Test (download, upload, latency)\n" +
                        "  • Device-wide traffic monitor (VPN)\n\n" +
                        "Built with ❤️ using Base44 Superagent.");
                }
                return true;
            }
            return false;
        });
        popup.show();
    }

    // ── Per-app locale (system-level) ────────────────────────────────────────
    // Registers the chosen language with Android's LocaleManager (API 33+).
    // The system VPN consent dialog ("Connection Request") localizes itself
    // to the requesting app's per-app locale, so this makes that dialog
    // follow the in-app EN/RU language setting instead of the device default.
    private void applyPerAppLocale() {
        try {
            if (android.os.Build.VERSION.SDK_INT >= 33) {
                android.app.LocaleManager lm = getSystemService(android.app.LocaleManager.class);
                if (lm != null) {
                    if (isRussian) {
                        lm.setApplicationLocales(new android.os.LocaleList(new java.util.Locale("ru")));
                    } else {
                        lm.setApplicationLocales(android.os.LocaleList.getEmptyLocaleList());
                    }
                }
            }
        } catch (Throwable ignored) {}
    }

    // ── Language picker dialog ────────────────────────────────────────────────
    private void showLanguageDialog() {
        String[] options = {"🇬🇧  English", "🇷🇺  Русский"};
        int current = isRussian ? 1 : 0;
        new AlertDialog.Builder(this)
            .setTitle(isRussian ? "🌍 Выберите язык" : "🌍 Select Language")
            .setSingleChoiceItems(options, current, (dialog, which) -> {
                boolean selectRu = (which == 1);
                if (selectRu != isRussian) {
                    isRussian = selectRu;
                    getSharedPreferences(PREFS_NAME, MODE_PRIVATE)
                        .edit()
                        .putString(PREF_LANG, isRussian ? "ru" : "en")
                        .apply();
                    applyPerAppLocale();
                    refreshTabLabels();
                    refreshUiStrings();
                }
                dialog.dismiss();
                android.widget.Toast.makeText(this,
                    isRussian ? "Язык изменён на Русский" : "Language set to English",
                    android.widget.Toast.LENGTH_SHORT).show();
            })
            .setNegativeButton(isRussian ? "Отмена" : "Cancel", null)
            .show();
    }

    // ── Refresh Tab Labels ───────────────────────────────────────────────────
    private void refreshTabLabels() {
        tabDomainBtn.setText(isRussian ? "🔍 Домены"    : "🔍 Domain Intel");
        tabTrafficBtn.setText(isRussian ? "📡 Трафик"    : "📡 Traffic");
        tabCheckerBtn.setText(isRussian ? "✅ Проверка"  : "✅ Checker");
        tabMyInfoBtn.setText(isRussian  ? "🌐 Мой IP"   : "🌐 My Info");
        if (tabSpeedBtn  != null) tabSpeedBtn.setText(isRussian ? "⚡ Скорость" : "⚡ Speed");
        if (speedDescText != null) speedDescText.setText(isRussian
            ? "Измерьте скорость загрузки, выгрузки и задержку до выбранного сервера."
            : "Measure your download speed, upload speed, and latency to a selected server.");
        if (tabDeviceBtn != null) tabDeviceBtn.setText(isRussian ? "📱 Устройство" : "📱 Device");
        if (tabToolsBtn  != null) tabToolsBtn.setText(isRussian ? "🛠 Инструменты" : "🛠 Tools");
        if (toolsTitleText != null) setToolMode(toolMode); // re-apply localized tool strings
    }

    // ── Refresh All UI Strings on Language Change ────────────────────────────
    private void refreshUiStrings() {
        // Domain Intel tab
        domainInput.setHint(isRussian ? "Введите домен (напр. paypal.com)" : "Enter domain (e.g. paypal.com)");
        lookupBtn.setText(isRussian ? "СКАН" : "SCAN");
        statusText.setText(isRussian ? "Введите домен и нажмите СКАН" : "Enter a domain and tap SCAN");
        exportDomainBtn.setText(isRussian ? "⬆ Экспорт" : "⬆ Export");
        // Traffic Monitor tab
        startMonBtn.setText(isRussian ? "▶  СТАРТ" : "▶  START");
        stopMonBtn.setText(isRussian ? "■  СТОП" : "■  STOP");
        exportTrafficBtn.setText(isRussian ? "⬆ Экспорт" : "⬆ Export");
        alertSwitch.setText(isRussian ? "🔔  Оповещение о неизвестных хостах" : "🔔  Alert on unknown hosts");
        monStatusText.setText(isRussian ? "⚫  Мониторинг неактивен" : "⚫  Monitoring inactive");
        // Domain Checker tab
        customDomainInput.setHint(isRussian ? "Введите домен или IP…" : "Enter domain or IP…");
        checkCustomBtn.setText(isRussian ? "Проверить" : "Check");
        checkAllBtn.setText(isRussian ? "▶  Проверить всё" : "▶  Check All");
        stopCheckBtn.setText(isRussian ? "■  Стоп" : "■  Stop");
        checkStatusText.setText(isRussian ? "Нажмите ▶ Проверить всё для теста" : "Tap ▶ Check All to test reachability");
        // My Info tab
        myInfoRefreshBtn.setText(isRussian ? "▶  Получить данные" : "▶  Lookup My Info");
        myInfoTitleText.setText(isRussian ? "🌐 Моя сеть" : "🌐 My Network Info");
        myInfoDescText.setText(isRussian ? "Ваш публичный IP-адрес, провайдер и местоположение." : "Your public IP address, ISP, and location as seen from the internet.");
        selectAppLabel.setText(isRussian ? "ВЫБРАТЬ ПРИЛОЖЕНИЕ" : "SELECT APP TO MONITOR");
        liveHostsLabel.setText(isRussian ? "АКТИВНЫЕ СОЕДИНЕНИЯ" : "LIVE CONNECTION HOSTS");
    }

    // ── Info / Help Dialog ───────────────────────────────────────────────────
    private void showInfoDialog(String title, String message) {
        new AlertDialog.Builder(this)
            .setTitle(title)
            .setMessage(message)
            .setPositiveButton(isRussian ? "Понятно" : "Got it", null)
            .show();
    }

    // ── Theme Toggle ─────────────────────────────────────────────────────────
    // ── Connection History ───────────────────────────────────────────────────
    private void showConnectionHistory() {
        List<HistoryManager.Session> sessions = HistoryManager.listAll(this);

        ScrollView scroll = new ScrollView(this);
        LinearLayout container = new LinearLayout(this);
        container.setOrientation(LinearLayout.VERTICAL);
        container.setPadding(dp(4), dp(4), dp(4), dp(4));
        scroll.addView(container);

        if (sessions.isEmpty()) {
            TextView empty = new TextView(this);
            empty.setText(isRussian
                ? "История пуста.\nЗапустите мониторинг трафика, чтобы сохранить сессию."
                : "No saved sessions yet.\nRun Traffic Monitor to save one automatically.");
            empty.setTextColor(Color.parseColor("#546E7A"));
            empty.setTextSize(13);
            empty.setPadding(dp(8), dp(24), dp(8), dp(24));
            container.addView(empty);
        } else {
            SimpleDateFormat fmt = new SimpleDateFormat("MMM d, HH:mm", Locale.US);
            for (HistoryManager.Session s : sessions) {
                LinearLayout card = makeCardContainer();

                TextView title = new TextView(this);
                title.setText("📱 " + s.appLabel);
                title.setTextSize(14);
                title.setTypeface(null, Typeface.BOLD);
                title.setTextColor(Color.parseColor("#00E5FF"));
                card.addView(title);

                long durationSec = Math.max(0, (s.endTime - s.startTime) / 1000);
                String duration = durationSec >= 60
                    ? (durationSec / 60) + "m " + (durationSec % 60) + "s"
                    : durationSec + "s";
                TextView meta = new TextView(this);
                meta.setText(fmt.format(new Date(s.startTime)) + "  •  " + duration + "  •  " +
                    s.connectionCount() + (isRussian ? " хостов" : " hosts"));
                meta.setTextSize(12);
                meta.setTypeface(Typeface.MONOSPACE);
                meta.setTextColor(Color.parseColor("#78909C"));
                meta.setPadding(0, dp(4), 0, 0);
                card.addView(meta);

                card.setOnClickListener(v -> showSessionDetail(s));
                container.addView(card);
            }
        }


        AlertDialog.Builder builder = new AlertDialog.Builder(this)
            .setTitle(isRussian ? "🕓 История соединений" : "🕓 Connection History")
            .setView(scroll)
            .setPositiveButton(isRussian ? "Закрыть" : "Close", null);
        if (!sessions.isEmpty()) {
            builder.setNeutralButton(isRussian ? "Очистить всё" : "Clear All", (d, w) -> {
                HistoryManager.deleteAll(this);
                showToast(isRussian ? "История очищена" : "History cleared");
            });
        }
        builder.show();
    }

    private void showSessionDetail(HistoryManager.Session s) {
        ScrollView scroll = new ScrollView(this);
        LinearLayout container = new LinearLayout(this);
        container.setOrientation(LinearLayout.VERTICAL);
        container.setPadding(dp(8), dp(8), dp(8), dp(8));
        scroll.addView(container);

        if (s.hosts.isEmpty()) {
            TextView empty = new TextView(this);
            empty.setText(isRussian ? "Нет данных" : "No data");
            empty.setTextColor(Color.parseColor("#546E7A"));
            container.addView(empty);
        } else {
            for (Map.Entry<String, String> e : s.hosts.entrySet()) {
                TextView row = new TextView(this);
                row.setText(e.getValue() + "   " + e.getKey());
                row.setTextSize(12);
                row.setTypeface(Typeface.MONOSPACE);
                row.setTextColor(Color.parseColor("#C8D8E8"));
                row.setPadding(0, dp(3), 0, dp(3));
                container.addView(row);
            }
        }


        new AlertDialog.Builder(this)
            .setTitle("📱 " + s.appLabel)
            .setView(scroll)
            .setPositiveButton(isRussian ? "Экспорт CSV" : "Export CSV", (d, w) -> exportSessionCsv(s))
            .setNegativeButton(isRussian ? "Удалить" : "Delete", (d, w) -> {
                HistoryManager.delete(this, s.id);
                showToast(isRussian ? "Сессия удалена" : "Session deleted");
            })
            .setNeutralButton(isRussian ? "Закрыть" : "Close", null)
            .show();
    }

    private void exportSessionCsv(HistoryManager.Session s) {
        StringBuilder sb = new StringBuilder();
        sb.append("timestamp,host_or_ip\n");
        for (Map.Entry<String, String> e : s.hosts.entrySet()) {
            sb.append(csv(e.getValue())).append(",").append(csv(e.getKey())).append("\n");
        }
        String ts = new SimpleDateFormat("yyyy-MM-dd_HHmmss", Locale.US).format(new Date(s.startTime));
        String filename = "NetWatch_History_" + s.appLabel.replaceAll("[^a-zA-Z0-9]", "_") + "_" + ts + ".csv";
        shareCsv(filename, sb.toString());
    }

    private void loadAppList() {
        executor.execute(() -> {
            PackageManager pm = getPackageManager();
            List<ApplicationInfo> apps = pm.getInstalledApplications(PackageManager.GET_META_DATA);
            List<AppEntry> entries = new ArrayList<>();

            for (ApplicationInfo ai : apps) {
                // Must have a launcher intent (visible in app drawer)
                Intent launchIntent = pm.getLaunchIntentForPackage(ai.packageName);
                if (launchIntent == null) continue;

                // Skip system apps — only show user-installed apps
                // FLAG_SYSTEM = pre-installed on system partition
                // If the app was updated by the user it has FLAG_UPDATED_SYSTEM_APP — include those
                boolean isSystemApp = (ai.flags & ApplicationInfo.FLAG_SYSTEM) != 0;
                boolean isUpdatedSystemApp = (ai.flags & ApplicationInfo.FLAG_UPDATED_SYSTEM_APP) != 0;
                if (isSystemApp && !isUpdatedSystemApp) continue;

                // Extra guard: skip known Android framework / chipset packages
                // NOTE: we do NOT block com.google.android.* broadly — that would hide
                // YouTube, Maps, Gmail etc. We only skip true system framework prefixes.
                String pkg = ai.packageName;
                if (pkg.startsWith("com.android.") ||
                    pkg.startsWith("android.") ||
                    pkg.equals("android") ||
                    pkg.startsWith("com.qualcomm.") ||
                    pkg.startsWith("com.mediatek.") ||
                    pkg.startsWith("com.sec.android.") ||
                    pkg.equals("com.google.android.gms") ||
                    pkg.equals("com.google.android.gsf") ||
                    pkg.equals("com.google.android.providers.media.module") ||
                    pkg.startsWith("com.google.android.permissioncontroller") ||
                    pkg.startsWith("com.google.android.ext.") ||
                    pkg.startsWith("com.google.android.trichromelibrary")) continue;

                String label = pm.getApplicationLabel(ai).toString();
                entries.add(new AppEntry(label, ai.packageName, ai.uid));
            }

            // Sort alphabetically
            Collections.sort(entries, (a, b) -> a.label.compareToIgnoreCase(b.label));

            appList = entries;
            mainHandler.post(() -> {
                appAdapter = new ThemedArrayAdapter<>(appList);
                appSpinner.setAdapter(appAdapter);
                if (!appList.isEmpty()) selectedApp = appList.get(0);
            });
        });
    }

    // ── Monitoring Control ───────────────────────────────────────────────────

    private void startMonitoring() {
        if (selectedApp == null) { showToast(isRussian ? "Сначала выберите приложение" : "Select an app first"); return; }

        clearLog();
        monitoring = true;
        monitoringStartTime = System.currentTimeMillis();
        startMonBtn.setEnabled(false);
        stopMonBtn.setEnabled(true);
        appSpinner.setEnabled(false);

        monStatusText.setText((isRussian ? "🟢  Мониторинг: " : "🟢  Monitoring: ") + selectedApp.label);
        monStatusText.setTextColor(Color.parseColor("#66BB6A"));

        // Real per-app host discovery needs the VPN capture engine (proc/net/tcp can't
        // see other apps' sockets on modern Android). Ask for VPN consent once, then start.
        pendingVpnPurpose = VPN_PURPOSE_TRAFFIC;
        android.content.Intent vpnIntent = android.net.VpnService.prepare(this);
        if (vpnIntent != null) {
            startActivityForResult(vpnIntent, VPN_REQUEST_CODE);
        } else {
            launchTrafficMonitoringInternal();
        }
    }

    private void launchTrafficMonitoringInternal() {
        trafficVpnEngineActive = true;
        ensureVpnEngineRunning();

        Intent si = new Intent(this, TrafficMonitorService.class);
        si.putExtra("target_uid",  selectedApp.uid);
        si.putExtra("target_pkg",  selectedApp.packageName);
        si.putExtra("target_name", selectedApp.label);
        startForegroundService(si);
    }

    private void stopMonitoring() {
        monitoring = false;
        startMonBtn.setEnabled(true);
        stopMonBtn.setEnabled(false);
        appSpinner.setEnabled(true);

        monStatusText.setText(isRussian ? "⚫  Мониторинг остановлен" : "⚫  Monitoring stopped");
        monStatusText.setTextColor(Color.parseColor("#78909C"));

        Intent si = new Intent(this, TrafficMonitorService.class);
        si.setAction(TrafficMonitorService.ACTION_STOP);
        startService(si);

        // Only tear down the shared VPN engine if Device Monitor isn't also relying on it.
        if (trafficVpnEngineActive) {
            trafficVpnEngineActive = false;
            if (!deviceMonRunning) {
                Intent vpnStop = new Intent(this, NetWatchVpnService.class);
                vpnStop.setAction(NetWatchVpnService.ACTION_STOP);
                startService(vpnStop);
            }
        }

        // Persist this session to Connection History (no-op if nothing was logged)
        if (!trafficLogForExport.isEmpty()) {
            HistoryManager.Session s = new HistoryManager.Session();
            s.appLabel    = selectedApp != null ? selectedApp.label : "Device";
            s.packageName = selectedApp != null ? selectedApp.packageName : "";
            s.startTime   = monitoringStartTime;
            s.endTime     = System.currentTimeMillis();
            s.txBytes     = lastKnownTx;
            s.rxBytes     = lastKnownRx;
            s.hosts.putAll(trafficLogForExport);
            HistoryManager.save(this, s);
        }
    }

    private void clearLog() {
        hostLogContainer.removeAllViews();
        hostCount = 0;
        seenHosts.clear();
        trafficLogForExport.clear();
        connectionCountText.setText("");
        txTotalText.setText("TX  —");
        rxTotalText.setText("RX  —");
        txRateText.setText("↑ 0 B/s");
        rxRateText.setText("↓ 0 B/s");
    }

    // ── Stats Update (called from broadcast) ─────────────────────────────────

    private void updateStats(long txBytes, long rxBytes, long txRate, long rxRate, String hostsRaw) {
        // Cache for tab re-entry
        lastKnownTx = txBytes; lastKnownRx = rxBytes;
        lastKnownTxRate = txRate; lastKnownRxRate = rxRate;
        // Update totals — -1 means TrafficStats.UNSUPPORTED on this device
        txTotalText.setText("TX  " + (txBytes < 0 ? "N/A" : formatBytes(txBytes)));
        rxTotalText.setText("RX  " + (rxBytes < 0 ? "N/A" : formatBytes(rxBytes)));
        txRateText.setText("↑ " + (txBytes < 0 ? "N/A" : formatBytes(txRate) + "/s"));
        rxRateText.setText("↓ " + (rxBytes < 0 ? "N/A" : formatBytes(rxRate) + "/s"));

        // Color rate text based on activity
        int rateColor = (txRate > 0 || rxRate > 0)
                ? Color.parseColor("#66BB6A") : Color.parseColor("#546E7A");
        txRateText.setTextColor(txRate > 0 ? Color.parseColor("#EF9A9A") : Color.parseColor("#546E7A"));
        rxRateText.setTextColor(rxRate > 0 ? Color.parseColor("#66BB6A") : Color.parseColor("#546E7A"));

        // Add new hosts to the log
        if (hostsRaw != null && !hostsRaw.isEmpty()) {
            String[] hosts = hostsRaw.split("\n");
            String ts = new SimpleDateFormat("HH:mm:ss", Locale.US).format(new Date());
            for (String host : hosts) {
                host = host.trim();
                if (host.isEmpty()) continue;
                if (seenHosts.contains(host)) continue;  // deduplicate
                seenHosts.add(host);
                addHostRow(host, txRate > 0 || rxRate > 0, ts);
                trafficLogForExport.put(host, ts);
                hostCount++;
            }
            if (hostCount > 0) {
                connectionCountText.setText(hostCount + (isRussian ? " уникальных хостов" : " unique hosts"));
                checkForWebViewOnlyTraffic();
            }
            hostLogScroll.post(() -> hostLogScroll.fullScroll(ScrollView.FOCUS_DOWN));
        }
    }

    /** Show a notice if the log only contains WebView/system proxy hostnames */
    private void checkForWebViewOnlyTraffic() {
        if (seenHosts.isEmpty()) return;
        boolean allSystem = true;
        for (String h : seenHosts) {
            String hl = h.toLowerCase();
            // Strip geo prefix if present
            int sp = hl.lastIndexOf("  ");
            if (sp >= 0) hl = hl.substring(sp + 2).trim();
            if (!isSystemProxyHost(hl)) { allSystem = false; break; }
        }
        if (allSystem) showWebViewNotice();
    }

    private boolean isSystemProxyHost(String h) {
        return h.contains("chromium.org") || h.contains("android.com") ||
               h.contains("android.app")  || h.contains("gvt1.com")    ||
               h.contains("gvt2.com")     || h.contains("play.google") ||
               h.contains("googleapis.com/generate_204") ||
               h.equals("connectivitycheck.gstatic.com") ||
               h.equals("clients3.google.com") ||
               h.equals("connectivitycheck.android.com");
    }

    /** Some OEM kernels hide other apps' /proc/net/tcp entries entirely from
     *  non-root apps, so per-app filtering falls back to device-wide capture.
     *  Once that happens the log is no longer scoped to the selected app, so the
     *  "unknown host" allowlist alert would just fire for every other app on the
     *  device — pure noise. Show a one-time banner and auto-mute the alert for
     *  the rest of this session (the saved preference itself is left untouched). */
    private void showFallbackNotice() {
        if (hostLogContainer.findViewWithTag("fallback_notice") != null) return;

        LinearLayout notice = new LinearLayout(this);
        notice.setTag("fallback_notice");
        notice.setOrientation(LinearLayout.VERTICAL);
        notice.setBackgroundColor(Color.parseColor("#1A2A3A"));
        notice.setPadding(dp(12), dp(10), dp(12), dp(10));
        LinearLayout.LayoutParams nlp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        nlp.setMargins(0, dp(4), 0, dp(4));
        notice.setLayoutParams(nlp);

        TextView icon = new TextView(this);
        icon.setText("ℹ️  " + (isRussian ? "Некоторые соединения скрыты" : "Some Connections Hidden"));
        icon.setTextSize(13); icon.setTextColor(Color.parseColor("#00E5FF"));
        icon.setTypeface(null, android.graphics.Typeface.BOLD);
        notice.addView(icon);

        TextView msg = new TextView(this);
        msg.setText(isRussian
            ? "Система Android не смогла подтвердить, что некоторые соединения принадлежат именно этому приложению, поэтому они скрыты — показаны только подтверждённые хосты этого приложения."
            : "Android couldn't confirm which app owned some connections, so they're hidden rather than shown — only hosts confirmed to belong to this app are listed.");
        msg.setTextSize(12); msg.setTextColor(Color.parseColor("#90A4AE"));
        msg.setPadding(0, dp(4), 0, 0);
        notice.addView(msg);

        hostLogContainer.addView(notice, 0);
    }

    private void showWebViewNotice() {
        // Only show once per monitoring session
        if (hostLogContainer.findViewWithTag("webview_notice") != null) return;

        LinearLayout notice = new LinearLayout(this);
        notice.setTag("webview_notice");
        notice.setOrientation(LinearLayout.VERTICAL);
        notice.setBackgroundColor(Color.parseColor("#1A2A3A"));
        notice.setPadding(dp(12), dp(10), dp(12), dp(10));
        LinearLayout.LayoutParams nlp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        nlp.setMargins(0, dp(4), 0, dp(4));
        notice.setLayoutParams(nlp);

        TextView icon = new TextView(this);
        icon.setText("ℹ️  " + (isRussian ? "Трафик через WebView" : "WebView Traffic Detected"));
        icon.setTextSize(13); icon.setTextColor(Color.parseColor("#00E5FF"));
        icon.setTypeface(null, android.graphics.Typeface.BOLD);
        notice.addView(icon);

        TextView msg = new TextView(this);
        msg.setText(isRussian
            ? "\u042d\u0442\u043e \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u0435 \u0438\u0441\u043f\u043e\u043b\u044c\u0437\u0443\u0435\u0442 WebView. \u0422\u0440\u0430\u0444\u0438\u043a \u0441\u043a\u0440\u044b\u0442 \u0437\u0430 \u0441\u0438\u0441\u0442\u0435\u043c\u043d\u044b\u043c \u043f\u0440\u043e\u0446\u0435\u0441\u0441\u043e\u043c Android."
            : "This app uses Android WebView for network calls. Real destination hosts are hidden behind the system process — only system domains like chromium.org or android.com are visible.");
        msg.setTextSize(12); msg.setTextColor(Color.parseColor("#90A4AE"));
        msg.setPadding(0, dp(4), 0, 0);
        notice.addView(msg);

        // Insert at the top of the log
        hostLogContainer.addView(notice, 0);
    }

    private void addHostRow(String host, boolean active, String ts) {
        boolean isIp = host.matches("\\d+\\.\\d+\\.\\d+\\.\\d+.*") || host.contains(":");
        boolean isUnknown = alertsEnabled && !isIp && !isTrustedHost(host);

        // Fire alert for unknown hosts
        if (isUnknown) fireAlert(host);

        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setPadding(dp(6), dp(6), dp(6), dp(6));
        if (isUnknown) row.setBackgroundColor(Color.parseColor("#1A2A1A")); // subtle red-green tint

        // Indicator dot
        TextView dot = new TextView(this);
        dot.setText(active ? "●  " : "○  ");
        dot.setTextSize(13);
        dot.setTextColor(Color.parseColor(isUnknown ? "#FF5252" : (active ? "#66BB6A" : "#546E7A")));
        dot.setLayoutParams(new LinearLayout.LayoutParams(dp(26), LinearLayout.LayoutParams.WRAP_CONTENT));
        row.addView(dot);

        // Host name / IP
        TextView hostView = new TextView(this);
        hostView.setText(host);
        hostView.setTextSize(isIp ? 12 : 14);
        hostView.setTextColor(Color.parseColor(isUnknown ? "#FF8A80" : (isIp ? "#90A4AE" : "#C8D8E8")));
        hostView.setTypeface(Typeface.MONOSPACE, isIp ? Typeface.NORMAL : Typeface.BOLD);
        hostView.setLayoutParams(new LinearLayout.LayoutParams(
                0, LinearLayout.LayoutParams.WRAP_CONTENT, 1));
        hostView.setEllipsize(TextUtils.TruncateAt.END);
        hostView.setSingleLine(true);
        row.addView(hostView);

        // ⚠ badge for unknown hosts
        if (isUnknown) {
            TextView badge = new TextView(this);
            badge.setText("⚠");
            badge.setTextSize(13);
            badge.setTextColor(Color.parseColor("#FF5252"));
            badge.setPadding(dp(4), 0, dp(4), 0);
            row.addView(badge);

            // ✓ Trust button — tap to mark as trusted and recolor row
            Button trustBtn = new Button(this);
            trustBtn.setText("✓");
            trustBtn.setTextSize(11);
            trustBtn.setTextColor(Color.WHITE);
            trustBtn.setPadding(dp(6), 0, dp(6), 0);
            LinearLayout.LayoutParams tbp = new LinearLayout.LayoutParams(dp(36), dp(28));
            tbp.setMargins(dp(2), 0, 0, 0);
            trustBtn.setLayoutParams(tbp);
            trustBtn.setBackgroundColor(Color.parseColor("#2E7D32"));
            trustBtn.setOnClickListener(v -> {
                // Add root of this host to trusted set
                String root = extractRootDomain(host);
                trustedDomains.add(root);
                trustedDomains.add(host);
                // Recolor this row to trusted
                row.setBackgroundColor(Color.TRANSPARENT);
                dot.setTextColor(Color.parseColor(active ? "#66BB6A" : "#546E7A"));
                hostView.setTextColor(Color.parseColor("#C8D8E8"));
                badge.setVisibility(android.view.View.GONE);
                trustBtn.setVisibility(android.view.View.GONE);
                showToast(isRussian ? "✓ Доверенный: " + root : "✓ Trusted: " + root);
            });
            row.addView(trustBtn);
        }

        // Timestamp
        TextView tsView = new TextView(this);
        tsView.setText(ts);
        tsView.setTextSize(10);
        tsView.setTextColor(Color.parseColor("#37474F"));
        tsView.setLayoutParams(new LinearLayout.LayoutParams(
                dp(46), LinearLayout.LayoutParams.WRAP_CONTENT));
        tsView.setGravity(android.view.Gravity.END);
        row.addView(tsView);

        // Divider
        View div = new View(this);
        div.setLayoutParams(new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, 1));
        div.setBackgroundColor(Color.parseColor(isUnknown ? "#FF5252" : "#0D2137"));

        // Tap row → run Domain Intel on this host
        final String hostForIntel = host;
        row.setOnClickListener(v -> showDomainIntelSheet(hostForIntel));
        row.setForeground(getResources().getDrawable(
                android.R.drawable.list_selector_background, getTheme()));

        hostLogContainer.addView(row);
        hostLogContainer.addView(div);
    }

    /** Show a modal bottom sheet with full Domain Intel for a host tapped in Traffic Monitor */
    private void showDomainIntelSheet(String rawHost) {
        // Strip geo prefix if present: e.g. "🇺🇸 Ashburn · Google  api.google.com"
        String domain = rawHost;
        int lastDouble = domain.lastIndexOf("  ");
        if (lastDouble >= 0) domain = domain.substring(lastDouble + 2).trim();
        // Strip port if present
        domain = domain.replaceAll(":\\d+$", "").trim();

        final String finalDomain = domain;

        // Build bottom sheet dialog
        android.app.Dialog dlg = new android.app.Dialog(this, android.R.style.Theme_DeviceDefault_NoActionBar);
        dlg.requestWindowFeature(android.view.Window.FEATURE_NO_TITLE);
        dlg.setContentView(R.layout.activity_main); // placeholder — we build programmatically

        // Outer container
        android.widget.FrameLayout frame = new android.widget.FrameLayout(this);
        frame.setBackgroundColor(Color.parseColor("#0A1929"));
        android.view.WindowManager.LayoutParams wlp = new android.view.WindowManager.LayoutParams();
        wlp.copyFrom(dlg.getWindow().getAttributes());
        wlp.width  = android.view.WindowManager.LayoutParams.MATCH_PARENT;
        wlp.height = android.view.WindowManager.LayoutParams.MATCH_PARENT;
        wlp.gravity = android.view.Gravity.BOTTOM;
        dlg.getWindow().setAttributes(wlp);
        dlg.getWindow().setBackgroundDrawableResource(android.R.color.transparent);

        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setBackgroundColor(Color.parseColor("#0A1929"));
        root.setPadding(dp(12), dp(12), dp(12), dp(24));

        // Header row
        LinearLayout hdr = new LinearLayout(this);
        hdr.setOrientation(LinearLayout.HORIZONTAL);
        hdr.setPadding(0, 0, 0, dp(8));
        TextView hdrTitle = new TextView(this);
        hdrTitle.setText("🔍  Domain Intel");
        hdrTitle.setTextSize(16); hdrTitle.setTextColor(Color.parseColor("#00E5FF"));
        hdrTitle.setTypeface(null, Typeface.BOLD);
        LinearLayout.LayoutParams hlp = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f);
        hdrTitle.setLayoutParams(hlp);
        hdr.addView(hdrTitle);
        Button closeBtn = new Button(this);
        closeBtn.setText("✕");
        closeBtn.setTextSize(14); closeBtn.setTextColor(Color.WHITE);
        closeBtn.setBackgroundColor(Color.parseColor("#1A3A5C"));
        LinearLayout.LayoutParams clp = new LinearLayout.LayoutParams(dp(40), dp(40));
        closeBtn.setLayoutParams(clp);
        closeBtn.setOnClickListener(v2 -> dlg.dismiss());
        hdr.addView(closeBtn);
        root.addView(hdr);

        // Domain label
        TextView domLbl = new TextView(this);
        domLbl.setText(finalDomain);
        domLbl.setTextSize(13); domLbl.setTextColor(Color.parseColor("#80DEEA"));
        domLbl.setTypeface(Typeface.MONOSPACE); domLbl.setPadding(0, 0, 0, dp(8));
        root.addView(domLbl);

        // Status / spinner
        TextView statusLbl = new TextView(this);
        statusLbl.setText("⏳  Scanning...");
        statusLbl.setTextSize(13); statusLbl.setTextColor(Color.parseColor("#90A4AE"));
        root.addView(statusLbl);

        // Scrollable results area
        ScrollView scroll = new ScrollView(this);
        LinearLayout.LayoutParams slp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, 0, 1f);
        scroll.setLayoutParams(slp);
        LinearLayout resultsBox = new LinearLayout(this);
        resultsBox.setOrientation(LinearLayout.VERTICAL);
        scroll.addView(resultsBox);
        root.addView(scroll);

        frame.addView(root);
        dlg.setContentView(frame);
        dlg.show();

        // Run intel in background
        executor.execute(() -> {
            String json = postJson(DOMAIN_INTEL_URL, "{\"domain\":\"" + finalDomain + "\"}");
            mainHandler.post(() -> {
                if (json == null) {
                    statusLbl.setText("❌  Network error"); return;
                }
                try {
                    org.json.JSONObject intel = new org.json.JSONObject(json);
                    int liveC  = intel.optInt("liveCount", 0);
                    int totalC = intel.optInt("totalDiscovered", 0);
                    String cdn = intel.optString("cdn", "");
                    String cdnSuffix = (!cdn.isEmpty() && !cdn.equals("null")) ? "  •  CDN: " + cdn : "";
                    statusLbl.setText("✅  " + liveC + " live / " + totalC + " subdomains" + cdnSuffix);
                    statusLbl.setTextColor(Color.parseColor("#66BB6A"));

                    // Root IP card
                    org.json.JSONArray ipv4 = intel.optJSONArray("ipv4");
                    if (ipv4 != null && ipv4.length() > 0) {
                        StringBuilder sb = new StringBuilder();
                        for (int i = 0; i < ipv4.length(); i++) sb.append("IPv4:  ").append(ipv4.optString(i)).append("\n");
                        String cname = intel.optString("cname", "");
                        if (!cname.isEmpty() && !cname.equals("null")) sb.append("CNAME: ").append(cname).append("\n");
                        if (!cdn.isEmpty() && !cdn.equals("null")) sb.append("CDN:   ").append(cdn);
                        addIntelCard(resultsBox, "🌐  " + finalDomain, sb.toString().trim(), "#A5D6A7");
                    }

                    // Live subdomains
                    org.json.JSONArray subs = intel.optJSONArray("subdomains");
                    if (subs != null) {
                        java.util.List<org.json.JSONObject> liveList = new java.util.ArrayList<>();
                        java.util.List<org.json.JSONObject> deadList = new java.util.ArrayList<>();
                        for (int i = 0; i < subs.length(); i++) {
                            org.json.JSONObject s = subs.getJSONObject(i);
                            if (s.optBoolean("live", false)) liveList.add(s); else deadList.add(s);
                        }
                        if (!liveList.isEmpty()) {
                            LinearLayout liveCard = makeIntelCard(resultsBox, "🟢  LIVE SUBDOMAINS / CDN (" + liveList.size() + ")", "#00E5FF");
                            for (int i = 0; i < liveList.size(); i++) {
                                addSubdomainRowToLayout(liveCard, liveList.get(i));
                                if (i < liveList.size()-1) addDivider(liveCard);
                            }
                        }
                        if (!deadList.isEmpty()) {
                            StringBuilder sb2 = new StringBuilder();
                            for (org.json.JSONObject s : deadList) sb2.append("▸  ").append(s.optString("name","")).append("\n");
                            addIntelCard(resultsBox, "⚫  UNRESOLVED (" + deadList.size() + ")", sb2.toString().trim(), "#546E7A");
                        }
                    }

                    // Shared hosts
                    org.json.JSONArray shared = intel.optJSONArray("sharedHostDomains");
                    if (shared != null && shared.length() > 0) {
                        StringBuilder sb3 = new StringBuilder();
                        for (int i = 0; i < shared.length(); i++) sb3.append("▸  ").append(shared.optString(i)).append("\n");
                        addIntelCard(resultsBox, "🕵️  SHARED HOST (" + shared.length() + ")", sb3.toString().trim(), "#FFCC80");
                    }

                } catch (Exception e) {
                    statusLbl.setText("❌  Parse error: " + e.getMessage());
                }
            });
        });
    }

    /** Add a simple text card inside the intel sheet */
    private void addIntelCard(LinearLayout parent, String title, String body, String bodyColor) {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setBackgroundResource(R.drawable.card_background);
        card.setPadding(dp(12), dp(10), dp(12), dp(10));
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        lp.bottomMargin = dp(8); card.setLayoutParams(lp);
        TextView t = new TextView(this);
        t.setText(title.toUpperCase()); t.setTextSize(11);
        t.setTextColor(Color.parseColor("#00E5FF")); t.setTypeface(null, Typeface.BOLD);
        t.setPadding(0, 0, 0, dp(4)); card.addView(t);
        TextView v = new TextView(this);
        v.setText(body); v.setTextSize(13);
        try { v.setTextColor(Color.parseColor(bodyColor)); } catch(Exception e){ v.setTextColor(Color.WHITE); }
        v.setTypeface(Typeface.MONOSPACE); card.addView(v);
        parent.addView(card);
    }

    /** Make a card with title only, returns card for adding subdomain rows */
    private LinearLayout makeIntelCard(LinearLayout parent, String title, String titleColor) {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setBackgroundResource(R.drawable.card_background);
        card.setPadding(dp(12), dp(10), dp(12), dp(10));
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        lp.bottomMargin = dp(8); card.setLayoutParams(lp);
        TextView t = new TextView(this);
        t.setText(title); t.setTextSize(11);
        try { t.setTextColor(Color.parseColor(titleColor)); } catch(Exception e){ t.setTextColor(Color.WHITE); }
        t.setTypeface(null, Typeface.BOLD); t.setPadding(0, 0, 0, dp(4)); card.addView(t);
        parent.addView(card);
        return card;
    }

    /** Subdomain row used inside the intel sheet */
    private void addSubdomainRowToLayout(LinearLayout card, org.json.JSONObject sub) {
        String name  = sub.optString("name", "");
        String cdn   = sub.optString("cdn", "");
        String cname = sub.optString("cname", "");
        org.json.JSONArray ips = sub.optJSONArray("ips");

        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setPadding(0, dp(3), 0, 0);
        TextView nameV = new TextView(this);
        nameV.setText("▸  " + name); nameV.setTextSize(12);
        nameV.setTextColor(Color.parseColor("#80DEEA")); nameV.setTypeface(Typeface.MONOSPACE);
        LinearLayout.LayoutParams nlp = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f);
        nameV.setLayoutParams(nlp); row.addView(nameV);
        if (cdn != null && !cdn.isEmpty() && !cdn.equals("null")) {
            TextView cdnV = new TextView(this);
            cdnV.setText(cdn); cdnV.setTextSize(10);
            cdnV.setTextColor(Color.parseColor("#FFB300")); cdnV.setTypeface(null, Typeface.BOLD);
            cdnV.setPadding(dp(4), 0, 0, 0); row.addView(cdnV);
        }
        card.addView(row);
        if (ips != null) {
            StringBuilder sb = new StringBuilder("   ");
            int cnt = 0;
            for (int j = 0; j < ips.length(); j++) {
                String ip = ips.optString(j);
                if (ip.matches("\\d+\\.\\d+\\.\\d+\\.\\d+")) { if(cnt>0) sb.append("  |  "); sb.append(ip); cnt++; }
            }
            if (cnt > 0) {
                TextView ipV = new TextView(this);
                ipV.setText(sb.toString()); ipV.setTextSize(11);
                ipV.setTextColor(Color.parseColor("#90A4AE")); ipV.setTypeface(Typeface.MONOSPACE);
                card.addView(ipV);
            }
        }
        if (cname != null && !cname.isEmpty() && !cname.equals("null")) {
            TextView cnV = new TextView(this);
            cnV.setText("   → " + cname); cnV.setTextSize(10);
            cnV.setTextColor(Color.parseColor("#78909C")); cnV.setTypeface(Typeface.MONOSPACE);
            card.addView(cnV);
        }
    }

    /** True if host belongs to a trusted domain */
    private boolean isTrustedHost(String host) {
        if (host == null || host.isEmpty()) return true;
        String h = host.toLowerCase();
        // Strip geo prefix if present (e.g. "🇺🇸 Ashburn, US · Google LLC  api.google.com")
        int lastSpace = h.lastIndexOf("  ");
        if (lastSpace >= 0) h = h.substring(lastSpace + 2).trim();
        for (String trusted : trustedDomains) {
            if (h.equals(trusted) || h.endsWith("." + trusted)) return true;
        }
        return false;
    }

    /** Extract root domain from a hostname (last two labels) */
    private static String extractRootDomain(String host) {
        // Strip geo prefix
        int lastSpace = host.lastIndexOf("  ");
        String h = lastSpace >= 0 ? host.substring(lastSpace + 2).trim() : host;
        String[] parts = h.split("\\.");
        if (parts.length >= 2) return parts[parts.length - 2] + "." + parts[parts.length - 1];
        return h;
    }

    /** Seed trusted domains when a new app is selected */
    private void seedTrustedDomains(String packageName) {
        // Keep global CDN list, clear app-specific ones
        trustedDomains.removeIf(d -> !isGlobalCdn(d));
        monitoredRootDomain = packageToRootDomain(packageName);
        if (monitoredRootDomain != null) {
            trustedDomains.add(monitoredRootDomain);
            trustedDomains.add("www." + monitoredRootDomain);
        }
    }

    private static boolean isGlobalCdn(String domain) {
        String[] cdns = {"google.com","googleapis.com","gstatic.com","akamai.net","akamaized.net",
            "cloudflare.com","cloudflare.net","fastly.net","amazonaws.com","cloudfront.net",
            "msedge.net","microsoft.com","apple.com","icloud.com","fbcdn.net","twimg.com",
            "akamaitechnologies.com","akamaiedge.net","awsstatic.com","mzstatic.com",
            "googlevideo.com","googleusercontent.com","android.com","msftconnecttest.com"};
        for (String cdn : cdns) if (domain.equals(cdn)) return true;
        return false;
    }

    private static String packageToRootDomain(String pkg) {
        if (pkg == null || pkg.isEmpty()) return null;
        String[] parts = pkg.split("\\.");
        if (parts.length < 2) return null;
        String tld = parts[0]; String name = parts[1];
        if ("com".equals(tld) || "org".equals(tld) || "io".equals(tld)) return name + ".com";
        return name + "." + tld;
    }

    /** Vibrate + notification for an unexpected host */
    private void fireAlert(String host) {
        // Vibrate: short double-pulse
        try {
            Vibrator v = (Vibrator) getSystemService(VIBRATOR_SERVICE);
            if (v != null && v.hasVibrator()) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    v.vibrate(VibrationEffect.createWaveform(new long[]{0, 120, 80, 180}, -1));
                } else {
                    v.vibrate(new long[]{0, 120, 80, 180}, -1);
                }
            }
        } catch (Exception ignored) {}

        // Status-bar notification
        try {
            String chanId = "netwatch_alerts";
            NotificationManager nm = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
            NotificationChannel ch = new NotificationChannel(chanId, "NetWatch Alerts", NotificationManager.IMPORTANCE_HIGH);
            ch.enableVibration(false); // we already vibrated manually
            nm.createNotificationChannel(ch);

            // Strip geo prefix for clean display
            String displayHost = host;
            int sp = host.lastIndexOf("  ");
            if (sp >= 0) displayHost = host.substring(sp + 2).trim();

            android.app.Notification notif = new android.app.Notification.Builder(this, chanId)
                    .setSmallIcon(android.R.drawable.ic_dialog_alert)
                    .setContentTitle("⚠ Unknown Connection Detected")
                    .setContentText(displayHost)
                    .setAutoCancel(true)
                    .build();

            nm.notify((int) System.currentTimeMillis(), notif);
        } catch (Exception ignored) {}
    }

    // ── Domain Intel (Tab 1) ─────────────────────────────────────────────────

    private static final String[] COMMON_TLDS = {
        ".com", ".net", ".org", ".io", ".co", ".dev", ".app", ".ai",
        ".tech", ".cloud", ".info", ".biz", ".online", ".site",
        ".store", ".xyz", ".me", ".tv", ".gg", ".sh"
    };

    private void performLookup() {
        String raw = domainInput.getText().toString().trim();
        if (raw.isEmpty()) { showToast(isRussian ? "Введите домен" : "Enter a domain"); return; }
        String clean = raw.replaceAll("(?i)https?://", "").replaceAll("/.*", "").toLowerCase().trim();

        // Smart search: if no dot, try common TLDs
        if (!clean.contains(".")) {
            discoverTlds(clean);
            return;
        }
        runDomainScan(clean);
    }

    private void runDomainScan(String domain) {
        runDomainScan(domain, false);
    }

    private void runDomainScan(String domain, boolean deep) {
        resultsContainer.removeAllViews();
        statusText.setText(isRussian
            ? (deep ? "🔬  Глубокое сканирование " + domain + " …" : "⏳  Сканирование " + domain + " …")
            : (deep ? "🔬  Deep scanning " + domain + " …" : "⏳  Scanning " + domain + " …"));
        lookupBtn.setEnabled(false);

        executor.execute(() -> {
            String payload = deep
                ? "{\"domain\":\"" + domain + "\",\"deep\":true}"
                : "{\"domain\":\"" + domain + "\"}";
            String intelJson = postJson(DOMAIN_INTEL_URL, payload);
            mainHandler.post(() -> {
                lookupBtn.setEnabled(true);
                if (intelJson == null) {
                    statusText.setText(isRussian ? "❌  Ошибка сети" : "❌  Network error");
                    return;
                }
                try {
                        org.json.JSONObject tmp = new org.json.JSONObject(intelJson);
                        int live2 = tmp.optInt("liveCount", 0);
                        int total2 = tmp.optInt("totalDiscovered", 0);
                        String cdn2 = tmp.optString("cdn","");
                        String cdnSuffix = (!cdn2.isEmpty() && !cdn2.equals("null")) ? "  •  CDN: " + cdn2 : "";
                        int crossCount = tmp.optJSONArray("crossDomains") != null ? tmp.optJSONArray("crossDomains").length() : 0;
                        String crossSuffix = crossCount > 0
                            ? (isRussian ? "  •  " + crossCount + " кросс-доменов" : "  •  " + crossCount + " cross-domains")
                            : "";
                        int pageHostCount = tmp.optJSONArray("pageHosts") != null ? tmp.optJSONArray("pageHosts").length() : 0;
                        String pageSuffix = pageHostCount > 0
                            ? (isRussian ? "  •  " + pageHostCount + " скрытых зависимостей" : "  •  " + pageHostCount + " hidden deps")
                            : "";
                        statusText.setText(isRussian
                            ? "✅  " + domain + "  •  " + live2 + " живых / " + total2 + " субдоменов" + cdnSuffix + crossSuffix + pageSuffix
                            : "✅  " + domain + "  •  " + live2 + " live / " + total2 + " subdomains" + cdnSuffix + crossSuffix + pageSuffix);
                    } catch (Exception _e) {
                        statusText.setText(isRussian ? "✅  Сканирование завершено: " + domain : "✅  Scan complete for " + domain);
                    }
                lastDomainForExport    = domain;
                lastIntelJsonForExport = intelJson != null ? intelJson : "";
                lastProbeJsonForExport = "";
                buildReport(domain, intelJson, null);
            });
        });
    }

    /** Smart TLD discovery: probe common suffixes for a bare domain name. */
    private void discoverTlds(final String baseName) {
        resultsContainer.removeAllViews();
        statusText.setText(isRussian ? "🔍  Поиск TLD для " + baseName + " …" : "🔍  Searching TLDs for " + baseName + " …");
        lookupBtn.setEnabled(false);

        // Show "probing" card
        addCard("🔍 " + (isRussian ? "Поиск доменов" : "TLD Discovery"),
                (isRussian ? "Проверка " : "Probing ") + COMMON_TLDS.length + (isRussian ? " суффиксов для " : " common suffixes for ") + baseName + "…",
                "#00E5FF");

        executor.execute(() -> {
            final java.util.List<String[]> found = java.util.Collections.synchronizedList(new java.util.ArrayList<>());
            java.util.List<Thread> threads = new java.util.ArrayList<>();

            for (final String tld : COMMON_TLDS) {
                final String candidate = baseName + tld;
                Thread t = new Thread(() -> {
                    try {
                        java.net.InetAddress addr = java.net.InetAddress.getByName(candidate);
                        if (addr != null) {
                            found.add(new String[]{candidate, addr.getHostAddress()});
                        }
                    } catch (Exception ignored) { /* doesn't resolve */ }
                });
                threads.add(t);
                t.start();
            }

            // Wait for all threads
            for (Thread t : threads) {
                try { t.join(); } catch (Exception ignored) {}
            }

            // Sort: by TLD priority order
            java.util.List<String[]> sorted = new java.util.ArrayList<>(found);
            java.util.Collections.sort(sorted, (a, b) -> {
                String aTld = a[0].substring(baseName.length());
                String bTld = b[0].substring(baseName.length());
                int aIdx = -1, bIdx = -1;
                for (int i = 0; i < COMMON_TLDS.length; i++) {
                    if (COMMON_TLDS[i].equals(aTld)) aIdx = i;
                    if (COMMON_TLDS[i].equals(bTld)) bIdx = i;
                }
                return Integer.compare(Math.max(aIdx, 0), Math.max(bIdx, 0));
            });

            mainHandler.post(() -> {
                lookupBtn.setEnabled(true);
                resultsContainer.removeAllViews();

                if (sorted.isEmpty()) {
                    statusText.setText(isRussian ? "❌  Домены не найдены для " + baseName : "❌  No domains found for " + baseName);
                    addCard("❌ " + (isRussian ? "Нет результатов" : "No Results"),
                            (isRussian ? "Ни один TLD не разрешён для " : "No TLDs resolved for ") + baseName +
                            (isRussian ? "\nВведите полный домен, например " : "\nTry entering the full domain, e.g. ") + baseName + ".com",
                            "#EF9A9A");
                    return;
                }

                statusText.setText(isRussian
                    ? "✅  Найдено " + sorted.size() + " доменов для " + baseName + " — нажмите для сканирования"
                    : "✅  Found " + sorted.size() + " domains for " + baseName + " — tap to scan");

                // Header
                TextView header = new TextView(MainActivity.this);
                header.setText("DISCOVERED DOMAINS FOR \"" + baseName.toUpperCase() + "\"");
                header.setTextColor(0xFF00E5FF);
                header.setTextSize(13);
                header.setTypeface(Typeface.MONOSPACE, Typeface.BOLD);
                header.setPadding(0, dp(4), 0, dp(8));
                resultsContainer.addView(header);

                for (final String[] entry : sorted) {
                    String domain = entry[0];
                    String ip = entry[1];

                    LinearLayout row = new LinearLayout(MainActivity.this);
                    row.setOrientation(LinearLayout.HORIZONTAL);
                    row.setBackgroundResource(R.drawable.card_background);
                    row.setPadding(dp(12), dp(10), dp(12), dp(10));
                    LinearLayout.LayoutParams rp = new LinearLayout.LayoutParams(
                            LinearLayout.LayoutParams.MATCH_PARENT,
                            LinearLayout.LayoutParams.WRAP_CONTENT);
                    rp.bottomMargin = dp(4);
                    row.setLayoutParams(rp);
                    row.setClickable(true);

                    TextView domainTv = new TextView(MainActivity.this);
                    domainTv.setText(domain);
                    domainTv.setTextColor(0xFF00E5FF);
                    domainTv.setTextSize(14);
                    domainTv.setTypeface(Typeface.MONOSPACE, Typeface.BOLD);
                    row.addView(domainTv, new LinearLayout.LayoutParams(
                            LinearLayout.LayoutParams.WRAP_CONTENT,
                            LinearLayout.LayoutParams.WRAP_CONTENT));

                    TextView ipTv = new TextView(MainActivity.this);
                    ipTv.setText("  →  " + ip);
                    ipTv.setTextColor(0xFF78909C);
                    ipTv.setTextSize(12);
                    ipTv.setTypeface(Typeface.MONOSPACE);
                    row.addView(ipTv, new LinearLayout.LayoutParams(
                            LinearLayout.LayoutParams.WRAP_CONTENT,
                            LinearLayout.LayoutParams.WRAP_CONTENT, 1));

                    TextView hintTv = new TextView(MainActivity.this);
                    hintTv.setText(isRussian ? "  [нажмите →]" : "  [tap to scan →]");
                    hintTv.setTextColor(0xFF546E7A);
                    hintTv.setTextSize(11);
                    hintTv.setTypeface(Typeface.MONOSPACE);
                    row.addView(hintTv, new LinearLayout.LayoutParams(
                            LinearLayout.LayoutParams.WRAP_CONTENT,
                            LinearLayout.LayoutParams.WRAP_CONTENT));

                    // Deep Scan button
                    TextView deepBtn = new TextView(MainActivity.this);
                    deepBtn.setText(isRussian ? "  [🔬 Глубокий поиск]" : "  [🔬 Deep Scan]");
                    deepBtn.setTextColor(0xFFFFB300);
                    deepBtn.setTextSize(11);
                    deepBtn.setTypeface(Typeface.MONOSPACE, Typeface.BOLD);
                    deepBtn.setPadding(dp(4), dp(2), dp(4), dp(2));
                    row.addView(deepBtn, new LinearLayout.LayoutParams(
                            LinearLayout.LayoutParams.WRAP_CONTENT,
                            LinearLayout.LayoutParams.WRAP_CONTENT));

                    row.setOnClickListener(v -> {
                        domainInput.setText(domain);
                        runDomainScan(domain);
                    });

                    deepBtn.setOnClickListener(v -> {
                        domainInput.setText(domain);
                        runDomainScan(domain, true);
                    });

                    resultsContainer.addView(row);
                }
            });
        });
    }

    private void buildReport(String domain, String intelJson, String probeJson) {
        try {
            JSONObject intel = intelJson != null ? new JSONObject(intelJson) : null;
            JSONObject probe = probeJson != null ? new JSONObject(probeJson) : null;

            if (intel != null && intel.has("error") && !intel.has("ipv4")) {
                addCard("❌ Error", intel.optString("error"), "#EF9A9A"); return;
            }

            if (intel != null) {
                JSONArray ipv4 = intel.optJSONArray("ipv4");
                JSONArray ipv6 = intel.optJSONArray("ipv6");
                String cname = intel.optString("cname","");

                // Build IP list for geo lookup
                java.util.List<String> allIps = new java.util.ArrayList<>();
                if (ipv4 != null) for (int i=0;i<ipv4.length();i++) allIps.add(ipv4.optString(i));

                // Geo-IP lookup for each IPv4 (run on executor, then post result)
                final String finalDomain = domain;
                final String finalCname = cname;
                final java.util.List<String> ipv6List = new java.util.ArrayList<>();
                if (ipv6 != null) for (int i=0;i<ipv6.length();i++) ipv6List.add(ipv6.optString(i));

                executor.execute(() -> {
                    StringBuilder sb = new StringBuilder();
                    for (String ip : allIps) {
                        sb.append("IPv4:  ").append(ip);
                        // Geo-IP lookup
                        try {
                            java.net.URL geoUrl = new java.net.URL("https://ipinfo.io/" + ip + "/json");
                            java.net.HttpURLConnection gc = (java.net.HttpURLConnection) geoUrl.openConnection();
                            gc.setRequestProperty("Accept", "application/json");
                            gc.setConnectTimeout(5000); gc.setReadTimeout(5000);
                            org.json.JSONObject g = new org.json.JSONObject(
                                new String(gc.getInputStream().readAllBytes(), "UTF-8").trim());
                            gc.disconnect();
                            String countryCode = g.optString("country","");
                            String cityName    = g.optString("city","");
                            String orgName     = g.optString("org","");
                            String countryFull = countryCode;
                            try { countryFull = new java.util.Locale("", countryCode).getDisplayCountry(); } catch (Exception ignored) {}
                            String flagStr = "";
                            if (countryCode.length() == 2) {
                                int f1 = 0x1F1E6 + (countryCode.charAt(0) - 'A');
                                int f2 = 0x1F1E6 + (countryCode.charAt(1) - 'A');
                                flagStr = new String(Character.toChars(f1)) + new String(Character.toChars(f2));
                            }
                            if (!countryFull.isEmpty()) sb.append("  ").append(flagStr).append(" ").append(countryFull);
                            if (!cityName.isEmpty()) sb.append(", ").append(cityName);
                            if (!orgName.isEmpty()) sb.append("\n       ").append(orgName);
                        } catch (Exception ignored) {}
                        sb.append("\n");
                    }
                    for (String ip : ipv6List) sb.append("IPv6:  ").append(ip).append("\n");
                    if (!finalCname.isEmpty() && !finalCname.equals("null")) sb.append("CNAME: ").append(finalCname);
                    String cdnVal = intel.optString("cdn","");
                    if (!cdnVal.isEmpty() && !cdnVal.equals("null")) sb.append("\nCDN:   ").append(cdnVal);
                    final String result = sb.toString().trim();
                    mainHandler.post(() -> {
                        if (result.length() > 0) addCard("🌐  " + finalDomain, result, "#A5D6A7");
                    });
                });
            }

            if (intel != null) {
                JSONArray subs = intel.optJSONArray("subdomains");
                if (subs != null && subs.length() > 0) addSubdomainsCard(subs);
                else addCard("🌿  Subdomains", "None discovered", "#546E7A");
            }

            if (intel != null) {
                JSONArray shared = intel.optJSONArray("sharedHostDomains");
                if (shared != null && shared.length() > 0) {
                    StringBuilder sb = new StringBuilder();
                    for (int i=0;i<shared.length();i++) sb.append("▸  ").append(shared.optString(i)).append("\n");
                    addCard("🕵️  Shared-Host ("+shared.length()+")", sb.toString().trim(), "#FFCC80");
                } else addCard("🕵️  Shared-Host", "None found", "#546E7A");
            }

            // Cross-domain discovery (from cert SANs + PTR)
            if (intel != null) {
                JSONArray cross = intel.optJSONArray("crossDomains");
                if (cross != null && cross.length() > 0) {
                    LinearLayout card = makeCardContainer();
                    TextView title = new TextView(MainActivity.this);
                    title.setText("🔗  CROSS-DOMAIN DISCOVERY  (" + cross.length() + ")");
                    title.setTextSize(11); title.setTextColor(Color.parseColor("#FFB300"));
                    title.setTypeface(null, Typeface.BOLD); title.setPadding(0,0,0,dp(6));
                    card.addView(title);

                    for (int i = 0; i < cross.length(); i++) {
                        JSONObject cd = cross.getJSONObject(i);
                        String cdDomain = cd.optString("domain", "");
                        JSONArray cdIps = cd.optJSONArray("ips");
                        String cdCdn = cd.optString("cdn", "");
                        boolean cdLive = cd.optBoolean("live", false);

                        LinearLayout cdRow = new LinearLayout(MainActivity.this);
                        cdRow.setOrientation(LinearLayout.HORIZONTAL);
                        cdRow.setPadding(0, dp(4), 0, 0);

                        TextView cdName = new TextView(MainActivity.this);
                        cdName.setText((cdLive ? "🟢  " : "⚫  ") + cdDomain);
                        cdName.setTextSize(13);
                        cdName.setTextColor(cdLive ? Color.parseColor("#80DEEA") : Color.parseColor("#546E7A"));
                        cdName.setTypeface(Typeface.MONOSPACE);
                        cdName.setLayoutParams(new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
                        cdRow.addView(cdName);

                        if (cdCdn != null && !cdCdn.isEmpty() && !cdCdn.equals("null")) {
                            TextView cdnBadge = new TextView(MainActivity.this);
                            cdnBadge.setText("  " + cdCdn);
                            cdnBadge.setTextSize(10);
                            cdnBadge.setTextColor(Color.parseColor("#FFB300"));
                            cdnBadge.setTypeface(null, Typeface.BOLD);
                            cdRow.addView(cdnBadge);
                        }
                        card.addView(cdRow);

                        if (cdIps != null && cdIps.length() > 0) {
                            StringBuilder ipSb = new StringBuilder("   ");
                            for (int j = 0; j < cdIps.length(); j++) {
                                if (j > 0) ipSb.append("  |  ");
                                ipSb.append(cdIps.optString(j));
                            }
                            TextView ipView = new TextView(MainActivity.this);
                            ipView.setText(ipSb.toString());
                            ipView.setTextSize(11);
                            ipView.setTextColor(Color.parseColor("#78909C"));
                            ipView.setTypeface(Typeface.MONOSPACE);
                            ipView.setPadding(0, dp(2), 0, 0);
                            card.addView(ipView);
                        }

                        // Make cross-domain tappable to scan it
                        final String cdDom = cdDomain;
                        cdRow.setClickable(true);
                        cdRow.setOnClickListener(v -> {
                            domainInput.setText(cdDom);
                            runDomainScan(cdDom, true);
                        });

                        if (i < cross.length() - 1) addDivider(card);
                    }
                    resultsContainer.addView(card);
                }
            }

            // Page-Embedded Hosts (hidden dependencies found in live page content)
            if (intel != null) {
                JSONArray pageHosts = intel.optJSONArray("pageHosts");
                if (pageHosts != null && pageHosts.length() > 0) {
                    LinearLayout card = makeCardContainer();
                    TextView title = new TextView(MainActivity.this);
                    title.setText(isRussian
                        ? "🧩  СКРЫТЫЕ ЗАВИСИМОСТИ  (" + pageHosts.length() + ")"
                        : "🧩  HIDDEN PAGE DEPENDENCIES  (" + pageHosts.length() + ")");
                    title.setTextSize(11); title.setTextColor(Color.parseColor("#69F0AE"));
                    title.setTypeface(null, Typeface.BOLD); title.setPadding(0,0,0,dp(6));
                    card.addView(title);

                    TextView subtitle = new TextView(MainActivity.this);
                    subtitle.setText(isRussian
                        ? "Внешние домены, встроенные в код сайта"
                        : "External domains embedded in the live page (scripts, forms, assets)");
                    subtitle.setTextSize(10);
                    subtitle.setTextColor(Color.parseColor("#546E7A"));
                    subtitle.setPadding(0, 0, 0, dp(6));
                    card.addView(subtitle);

                    for (int i = 0; i < pageHosts.length(); i++) {
                        JSONObject ph = pageHosts.getJSONObject(i);
                        String phDomain = ph.optString("domain", "");
                        String phSource = ph.optString("source", "inline");
                        String phCdn = ph.optString("cdn", "");
                        boolean phLive = ph.optBoolean("live", false);
                        JSONArray phIps = ph.optJSONArray("ips");

                        LinearLayout phRow = new LinearLayout(MainActivity.this);
                        phRow.setOrientation(LinearLayout.HORIZONTAL);
                        phRow.setPadding(0, dp(4), 0, 0);

                        TextView phName = new TextView(MainActivity.this);
                        phName.setText((phLive ? "🟢  " : "⚫  ") + phDomain);
                        phName.setTextSize(13);
                        phName.setTextColor(phLive ? Color.parseColor("#80DEEA") : Color.parseColor("#546E7A"));
                        phName.setTypeface(Typeface.MONOSPACE);
                        phName.setLayoutParams(new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
                        phRow.addView(phName);

                        // source badge
                        String srcLabel;
                        switch (phSource) {
                            case "script":     srcLabel = isRussian ? "  скрипт"    : "  script";     break;
                            case "iframe":     srcLabel = isRussian ? "  iframe"     : "  iframe";     break;
                            case "form":       srcLabel = isRussian ? "  форма"      : "  form";       break;
                            case "stylesheet": srcLabel = isRussian ? "  стиль"      : "  stylesheet"; break;
                            case "img":        srcLabel = isRussian ? "  картинка"   : "  image";      break;
                            default:           srcLabel = isRussian ? "  встроено"   : "  embedded";   break;
                        }
                        TextView srcBadge = new TextView(MainActivity.this);
                        srcBadge.setText(srcLabel);
                        srcBadge.setTextSize(10);
                        srcBadge.setTextColor(Color.parseColor("#69F0AE"));
                        srcBadge.setTypeface(null, Typeface.BOLD);
                        phRow.addView(srcBadge);

                        if (phCdn != null && !phCdn.isEmpty() && !phCdn.equals("null")) {
                            TextView cdnBadge = new TextView(MainActivity.this);
                            cdnBadge.setText("  " + phCdn);
                            cdnBadge.setTextSize(10);
                            cdnBadge.setTextColor(Color.parseColor("#FFB300"));
                            cdnBadge.setTypeface(null, Typeface.BOLD);
                            phRow.addView(cdnBadge);
                        }
                        card.addView(phRow);

                        if (phIps != null && phIps.length() > 0) {
                            StringBuilder ipSb = new StringBuilder("   ");
                            for (int j = 0; j < Math.min(phIps.length(), 3); j++) {
                                if (j > 0) ipSb.append("  |  ");
                                ipSb.append(phIps.optString(j));
                            }
                            if (phIps.length() > 3) ipSb.append("  |  +").append(phIps.length() - 3);
                            TextView ipView = new TextView(MainActivity.this);
                            ipView.setText(ipSb.toString());
                            ipView.setTextSize(11);
                            ipView.setTextColor(Color.parseColor("#78909C"));
                            ipView.setTypeface(Typeface.MONOSPACE);
                            ipView.setPadding(0, dp(2), 0, 0);
                            card.addView(ipView);
                        }

                        // Tappable to scan it deeper
                        final String phDom = phDomain;
                        phRow.setClickable(true);
                        phRow.setOnClickListener(v -> {
                            domainInput.setText(phDom);
                            runDomainScan(phDom, true);
                        });

                        if (i < pageHosts.length() - 1) addDivider(card);
                    }
                    resultsContainer.addView(card);
                }
            }

            // Certificate names from crt.sh
            if (intel != null) {
                JSONArray certNames = intel.optJSONArray("certNames");
                if (certNames != null && certNames.length() > 0) {
                    LinearLayout card = makeCardContainer();
                    TextView title = new TextView(MainActivity.this);
                    title.setText("📜  CERTIFICATE TRANSPARENCY  (" + certNames.length() + ")");
                    title.setTextSize(11); title.setTextColor(Color.parseColor("#CE93D8"));
                    title.setTypeface(null, Typeface.BOLD); title.setPadding(0,0,0,dp(6));
                    card.addView(title);

                    // Show first 30 cert names in a compact list
                    int showCount = Math.min(certNames.length(), 30);
                    StringBuilder sb = new StringBuilder();
                    for (int i = 0; i < showCount; i++) {
                        sb.append("▸  ").append(certNames.optString(i)).append("\n");
                    }
                    if (certNames.length() > 30) {
                        sb.append("\n  ... +").append(certNames.length() - 30).append(" more");
                    }
                    TextView certView = new TextView(MainActivity.this);
                    certView.setText(sb.toString().trim());
                    certView.setTextSize(11);
                    certView.setTextColor(Color.parseColor("#9E9E9E"));
                    certView.setTypeface(Typeface.MONOSPACE);
                    card.addView(certView);
                    resultsContainer.addView(card);
                }
            }



        } catch (Exception e) {
            addCard("⚠  Parse Error", e.getMessage(), "#EF9A9A");
        }

        // Add Deep Scan button at the bottom of results
        final String dsDomain = domain;
        LinearLayout deepCard = new LinearLayout(this);
        deepCard.setOrientation(LinearLayout.HORIZONTAL);
        deepCard.setBackgroundResource(R.drawable.card_background);
        deepCard.setPadding(dp(12), dp(10), dp(12), dp(10));
        LinearLayout.LayoutParams dlp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT);
        dlp.topMargin = dp(8);
        deepCard.setLayoutParams(dlp);
        deepCard.setClickable(true);

        TextView deepLabel = new TextView(this);
        deepLabel.setText(isRussian ? "🔬  Глубокое сканирование " + dsDomain : "🔬  Deep Scan " + dsDomain);
        deepLabel.setTextColor(0xFFFFB300);
        deepLabel.setTextSize(13);
        deepLabel.setTypeface(Typeface.MONOSPACE, Typeface.BOLD);
        deepCard.addView(deepLabel, new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT, 1));

        TextView deepHint = new TextView(this);
        deepHint.setText(isRussian ? "  [сертификаты + субдомены + PTR →]" : "  [certs + subs + PTR →]");
        deepHint.setTextColor(0xFF546E7A);
        deepHint.setTextSize(11);
        deepHint.setTypeface(Typeface.MONOSPACE);
        deepCard.addView(deepHint, new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT));

        deepCard.setOnClickListener(v -> runDomainScan(dsDomain, true));
        resultsContainer.addView(deepCard);
    }

    // ── Card helpers ─────────────────────────────────────────────────────────

    private void addSubdomainsCard(JSONArray subs) {
        // Split into live and dead
        java.util.List<JSONObject> live = new java.util.ArrayList<>();
        java.util.List<JSONObject> dead = new java.util.ArrayList<>();
        try {
            for (int i = 0; i < subs.length(); i++) {
                JSONObject sub = subs.getJSONObject(i);
                if (sub.optBoolean("live", sub.optJSONArray("ips") != null && sub.optJSONArray("ips").length() > 0))
                    live.add(sub);
                else
                    dead.add(sub);
            }
        } catch (Exception ignored) {}

        // Live subdomains card
        if (!live.isEmpty()) {
            LinearLayout card = makeCardContainer();
            TextView title = new TextView(this);
            title.setText("🟢  LIVE SUBDOMAINS / CDN  (" + live.size() + ")");
            title.setTextSize(11); title.setTextColor(Color.parseColor("#00E5FF"));
            title.setTypeface(null, Typeface.BOLD); title.setPadding(0,0,0,dp(6));
            card.addView(title);
            for (int i = 0; i < live.size(); i++) {
                addSubdomainRow(card, live.get(i));
                if (i < live.size()-1) addDivider(card);
            }
            resultsContainer.addView(card);
        }

        // Dead / unresolved subdomains card (collapsed list)
        if (!dead.isEmpty()) {
            LinearLayout card = makeCardContainer();
            TextView title = new TextView(this);
            title.setText("⚫  UNRESOLVED SUBDOMAINS  (" + dead.size() + ")");
            title.setTextSize(11); title.setTextColor(Color.parseColor("#607D8B"));
            title.setTypeface(null, Typeface.BOLD); title.setPadding(0,0,0,dp(6));
            card.addView(title);
            StringBuilder sb = new StringBuilder();
            for (JSONObject sub : dead) {
                sb.append("▸  ").append(sub.optString("name","")).append("\n");
            }
            TextView deadView = new TextView(this);
            deadView.setText(sb.toString().trim()); deadView.setTextSize(12);
            deadView.setTextColor(Color.parseColor("#546E7A")); deadView.setTypeface(Typeface.MONOSPACE);
            card.addView(deadView);
            resultsContainer.addView(card);
        }

        if (live.isEmpty() && dead.isEmpty()) {
            addCard("🌿  Subdomains", "None discovered", "#546E7A");
        }
    }

    private void addSubdomainRow(LinearLayout card, JSONObject sub) {
        String name = sub.optString("name","");
        JSONArray ips = sub.optJSONArray("ips");
        String cdn = sub.optString("cdn", "");
        String cname = sub.optString("cname", "");

        // Name line
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setPadding(0, dp(4), 0, 0);

        TextView nameView = new TextView(this);
        nameView.setText("▸  " + name);
        nameView.setTextSize(13);
        nameView.setTextColor(Color.parseColor("#80DEEA"));
        nameView.setTypeface(Typeface.MONOSPACE);
        LinearLayout.LayoutParams nlp = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f);
        nameView.setLayoutParams(nlp);
        row.addView(nameView);

        // CDN badge
        if (cdn != null && !cdn.isEmpty() && !cdn.equals("null")) {
            TextView cdnView = new TextView(this);
            cdnView.setText("  " + cdn);
            cdnView.setTextSize(10);
            cdnView.setTextColor(Color.parseColor("#FFB300"));
            cdnView.setTypeface(null, Typeface.BOLD);
            cdnView.setPadding(dp(6), dp(2), dp(6), dp(2));
            row.addView(cdnView);
        }
        card.addView(row);

        // IPs (only real IPs, not CNAME chain entries)
        if (ips != null && ips.length() > 0) {
            StringBuilder sb = new StringBuilder("   ");
            int count = 0;
            for (int j = 0; j < ips.length(); j++) {
                String ip = ips.optString(j);
                if (ip.matches("\\d+\\.\\d+\\.\\d+\\.\\d+")) {
                    if (count > 0) sb.append("  |  ");
                    sb.append(ip);
                    count++;
                }
            }
            if (count > 0) {
                TextView ipView = new TextView(this);
                ipView.setText(sb.toString()); ipView.setTextSize(11);
                ipView.setTextColor(Color.parseColor("#90A4AE")); ipView.setTypeface(Typeface.MONOSPACE);
                card.addView(ipView);
            }
        }

        // CNAME if present and different from name
        if (cname != null && !cname.isEmpty() && !cname.equals("null") && !cname.equals(name)) {
            TextView cnView = new TextView(this);
            cnView.setText("   → " + cname); cnView.setTextSize(11);
            cnView.setTextColor(Color.parseColor("#78909C")); cnView.setTypeface(Typeface.MONOSPACE);
            card.addView(cnView);
        }
    }

    private void addDivider(LinearLayout card) {
        View div = new View(this);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 1);
        lp.topMargin = dp(4); lp.bottomMargin = dp(2); div.setLayoutParams(lp);
        div.setBackgroundColor(Color.parseColor("#1A3A5C")); card.addView(div);
    }

    private void addCard(String title, String value, String valueColor) {
        LinearLayout card = makeCardContainer();
        TextView t = new TextView(this);
        t.setText(title.toUpperCase()); t.setTextSize(11);
        t.setTextColor(Color.parseColor("#00E5FF")); t.setTypeface(null, Typeface.BOLD);
        t.setPadding(0,0,0,dp(5)); card.addView(t);
        TextView v = new TextView(this);
        v.setText(value); v.setTextSize(14);
        try { v.setTextColor(Color.parseColor(valueColor)); } catch(Exception e){ v.setTextColor(Color.WHITE); }
        v.setTypeface(Typeface.MONOSPACE); card.addView(v);
        resultsContainer.addView(card);
    }

    private LinearLayout makeCardContainer() {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setBackgroundResource(R.drawable.card_background);
        card.setPadding(dp(14),dp(12),dp(14),dp(12));
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        lp.bottomMargin = dp(10); card.setLayoutParams(lp);
        return card;
    }

    // ── Export ───────────────────────────────────────────────────────────────

    /** Wrap a value for safe CSV embedding (escapes quotes, wraps in quotes). */
    private String csv(String v) {
        if (v == null) return "\"\"";
        return "\"" + v.replace("\"", "\"\"") + "\"";
    }

    private void exportDomainIntel() {
        if (lastDomainForExport.isEmpty()) { showToast(isRussian ? "Сначала выполните сканирование" : "Run a scan first"); return; }
        String ts = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", java.util.Locale.US).format(new Date());
        StringBuilder sb = new StringBuilder();

        // ── Header metadata block ──
        sb.append("field,value\n");
        sb.append(csv("report_type")).append(",").append(csv("NetWatch Domain Intelligence")).append("\n");
        sb.append(csv("generated")).append(",").append(csv(ts)).append("\n");
        sb.append(csv("domain")).append(",").append(csv(lastDomainForExport)).append("\n");
        sb.append("\n");

        try {
            if (!lastIntelJsonForExport.isEmpty()) {
                JSONObject intel = new JSONObject(lastIntelJsonForExport);

                // IPv4
                JSONArray ipv4 = intel.optJSONArray("ipv4");
                if (ipv4 != null && ipv4.length() > 0) {
                    sb.append("record_type,value\n");
                    for (int i = 0; i < ipv4.length(); i++)
                        sb.append(csv("ipv4")).append(",").append(csv(ipv4.optString(i))).append("\n");
                    sb.append("\n");
                }

                // IPv6
                JSONArray ipv6 = intel.optJSONArray("ipv6");
                if (ipv6 != null && ipv6.length() > 0) {
                    sb.append("record_type,value\n");
                    for (int i = 0; i < ipv6.length(); i++)
                        sb.append(csv("ipv6")).append(",").append(csv(ipv6.optString(i))).append("\n");
                    sb.append("\n");
                }

                // CNAME
                String cname = intel.optString("cname", "");
                if (!cname.isEmpty() && !cname.equals("null")) {
                    sb.append("record_type,value\n");
                    sb.append(csv("cname")).append(",").append(csv(cname)).append("\n\n");
                }

                // Subdomains
                JSONArray subs = intel.optJSONArray("subdomains");
                if (subs != null && subs.length() > 0) {
                    sb.append("subdomain,ip\n");
                    for (int i = 0; i < subs.length(); i++) {
                        JSONObject sub = subs.getJSONObject(i);
                        String subName = sub.optString("name", "");
                        JSONArray ips  = sub.optJSONArray("ips");
                        String ip = (ips != null && ips.length() > 0) ? ips.optString(0) : "";
                        sb.append(csv(subName)).append(",").append(csv(ip)).append("\n");
                    }
                    sb.append("\n");
                }

                // Shared-host domains
                JSONArray shared = intel.optJSONArray("sharedHostDomains");
                if (shared != null && shared.length() > 0) {
                    sb.append("shared_host_domain\n");
                    for (int i = 0; i < shared.length(); i++)
                        sb.append(csv(shared.optString(i))).append("\n");
                    sb.append("\n");
                }
            }
        } catch (Exception e) {
            sb.append(csv("error")).append(",").append(csv(e.getMessage())).append("\n");
        }

        String filename = "NetWatch_" + lastDomainForExport + "_" + ts.replace(" ", "_").replace(":", "") + ".csv";
        shareCsv(filename, sb.toString());
    }

    private void exportTrafficLog() {
        if (trafficLogForExport.isEmpty()) { showToast(isRussian ? "Нет данных трафика для экспорта" : "No traffic data to export"); return; }
        String ts = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", java.util.Locale.US).format(new Date());
        String appLabel = selectedApp != null ? selectedApp.label : "Device";
        StringBuilder sb = new StringBuilder();

        // CSV header
        sb.append("timestamp,host_or_ip\n");
        for (Map.Entry<String, String> entry : trafficLogForExport.entrySet()) {
            sb.append(csv(entry.getValue())).append(",").append(csv(entry.getKey())).append("\n");
        }

        String filename = "NetWatch_Traffic_" + appLabel.replaceAll("[^a-zA-Z0-9]", "_") + "_" + ts.replace(" ", "_").replace(":", "") + ".csv";
        shareCsv(filename, sb.toString());
    }

    private void shareCsv(String filename, String csvText) {
        // Also copy to clipboard as plain text for convenience
        android.content.ClipboardManager clipboard = (android.content.ClipboardManager) getSystemService(CLIPBOARD_SERVICE);
        android.content.ClipData clip = android.content.ClipData.newPlainText(filename, csvText);
        clipboard.setPrimaryClip(clip);

        // Write to a cache file so apps like Files / Drive / Email can attach it properly
        try {
            java.io.File cacheDir = new java.io.File(getCacheDir(), "exports");
            cacheDir.mkdirs();
            java.io.File outFile = new java.io.File(cacheDir, filename);
            try (java.io.FileWriter fw = new java.io.FileWriter(outFile)) { fw.write(csvText); }

            android.net.Uri uri = androidx.core.content.FileProvider.getUriForFile(
                this, getPackageName() + ".provider", outFile);

            Intent share = new Intent(Intent.ACTION_SEND);
            share.setType("text/csv");
            share.putExtra(Intent.EXTRA_SUBJECT, filename);
            share.putExtra(Intent.EXTRA_STREAM, uri);
            share.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            startActivity(Intent.createChooser(share, isRussian ? "Экспорт CSV через…" : "Export CSV via…"));
        } catch (Exception e) {
            // Fallback: share as plain text
            Intent share = new Intent(Intent.ACTION_SEND);
            share.setType("text/csv");
            share.putExtra(Intent.EXTRA_SUBJECT, filename);
            share.putExtra(Intent.EXTRA_TEXT, csvText);
            startActivity(Intent.createChooser(share, isRussian ? "Экспорт CSV через…" : "Export CSV via…"));
        }
    }

    // ── Tab 4 – My Network Info ──────────────────────────────────────────────

    private void lookupMyInfo() {
        myInfoContainer.removeAllViews();
        // Show a loading card
        addMyInfoRow("⏳ Looking up your public IP…", "", "#0D1117");
        myInfoRefreshBtn.setEnabled(false);

        new Thread(() -> {
            String ip = null; String isp = ""; String org = ""; String org2 = "";
            String city = ""; String region = ""; String country = ""; String flag = "🌐";
            String lat = ""; String lon = ""; String timezone = ""; String zip = "";
            try {
                // 1. Get public IP via ipify
                java.net.URL ipUrl = new java.net.URL("https://api.ipify.org");
                java.net.HttpURLConnection ipConn = (java.net.HttpURLConnection) ipUrl.openConnection();
                ipConn.setConnectTimeout(5000); ipConn.setReadTimeout(5000);
                java.io.InputStream ipIs = ipConn.getInputStream();
                ip = new String(ipIs.readAllBytes(), "UTF-8").trim();
                ipConn.disconnect();
            } catch (Exception e) { ip = null; }

            if (ip != null) {
                try {
                    // 2. Geo-IP enrichment via ipinfo.io (HTTPS, no key needed)
                    java.net.URL geoUrl = new java.net.URL("https://ipinfo.io/" + ip + "/json");
                    java.net.HttpURLConnection gc = (java.net.HttpURLConnection) geoUrl.openConnection();
                    gc.setRequestProperty("Accept", "application/json");
                    gc.setConnectTimeout(6000); gc.setReadTimeout(6000);
                    java.io.InputStream gis = gc.getInputStream();
                    String geoJson = new String(gis.readAllBytes(), "UTF-8").trim();
                    gc.disconnect();
                    org.json.JSONObject g = new org.json.JSONObject(geoJson);
                    // ipinfo.io response: ip, city, region, country, loc, org, postal, timezone
                    isp      = g.optString("org", "");      // e.g. "AS15169 Google LLC"
                    city     = g.optString("city", "");
                    region   = g.optString("region", "");
                    country  = g.optString("country", "");  // 2-letter code
                    zip      = g.optString("postal", "");
                    timezone = g.optString("timezone", "");
                    String loc = g.optString("loc", "");    // "lat,lon"
                    if (loc.contains(",")) {
                        lat = loc.split(",")[0].trim();
                        lon = loc.split(",")[1].trim();
                    }
                    // Resolve country code to full name
                    try {
                        java.util.Locale locale = new java.util.Locale("", country);
                        org2 = locale.getDisplayCountry();
                    } catch (Exception e2) { org2 = country; }
                    // Convert country code to flag emoji
                    if (country.length() == 2) {
                        int f1 = 0x1F1E6 + (country.charAt(0) - 'A');
                        int f2 = 0x1F1E6 + (country.charAt(1) - 'A');
                        flag = new String(Character.toChars(f1)) + new String(Character.toChars(f2));
                    }
                } catch (Exception ignored) {}
            }

            final String resolvedIp = ip;
            final String fIp = resolvedIp != null ? resolvedIp : "Unable to determine";
            final String fIsp = isp; final String fOrg = org; final String fOrg2 = org2;
            final String fCity = city; final String fRegion = region;
            final String fCountry = country; final String fFlag = flag;
            final String fLat = lat; final String fLon = lon;
            final String fTz = timezone; final String fZip = zip;

            runOnUiThread(() -> {
                myInfoContainer.removeAllViews();
                myInfoRefreshBtn.setEnabled(true);

                // ── Public IP card ──
                addMyInfoCard("🔌  Public IP Address", fIp, "#001020", "#00E5FF");

                if (resolvedIp == null) {
                    addMyInfoRow("Could not reach the internet. Check your connection.", "", "#0D1117");
                    return;
                }

                // ── ISP / Org card ──
                StringBuilder ispSb = new StringBuilder();
                if (!fIsp.isEmpty()) ispSb.append("ISP:  ").append(fIsp);
                if (!fOrg.isEmpty() && !fOrg.equals(fIsp)) {
                    if (ispSb.length() > 0) ispSb.append("\n");
                    ispSb.append("Org:  ").append(fOrg);
                }
                if (ispSb.length() > 0) addMyInfoCard("🏢  Provider", ispSb.toString(), "#001A0E", "#00FF88");

                // ── Location card ──
                StringBuilder locSb = new StringBuilder();
                if (!fCity.isEmpty()) locSb.append("City:      ").append(fCity);
                if (!fZip.isEmpty()) { if (locSb.length()>0) locSb.append("\n"); locSb.append("ZIP:       ").append(fZip); }
                if (!fRegion.isEmpty()) { if (locSb.length()>0) locSb.append("\n"); locSb.append("Region:    ").append(fRegion); }
                if (!fCountry.isEmpty()) { if (locSb.length()>0) locSb.append("\n"); locSb.append("Country:   ").append(fFlag).append("  ").append(fCountry); }
                if (!fLat.isEmpty() && !fLon.isEmpty() && !fLat.equals("0.0")) {
                    if (locSb.length()>0) locSb.append("\n");
                    locSb.append("Coords:    ").append(fLat).append(", ").append(fLon);
                }
                if (locSb.length() > 0) addMyInfoCard("📍  Geolocation", locSb.toString(), "#0A0020", "#B060FF");

                // ── Timezone card ──
                if (!fTz.isEmpty()) addMyInfoCard("🕐  Timezone", fTz, "#0A1A12", "#00E5CC");

                // ── Maps shortcut ──
                if (!fLat.isEmpty() && !fLon.isEmpty() && !fLat.equals("0.0")) {
                    Button mapsBtn = new Button(MainActivity.this);
                    mapsBtn.setText(isRussian ? "📍  Открыть на карте" : "📍  Open in Maps");
                    mapsBtn.setTextColor(0xFFFFFFFF);
                    mapsBtn.setBackground(getResources().getDrawable(R.drawable.btn_primary));
                    android.widget.LinearLayout.LayoutParams lp = new android.widget.LinearLayout.LayoutParams(
                        android.widget.LinearLayout.LayoutParams.MATCH_PARENT,
                        android.widget.LinearLayout.LayoutParams.WRAP_CONTENT);
                    lp.setMargins(0, 12, 0, 0);
                    mapsBtn.setLayoutParams(lp);
                    final String mapsUri = "geo:" + fLat + "," + fLon + "?q=" + fLat + "," + fLon + "(" + fIp + ")";
                    mapsBtn.setOnClickListener(v -> {
                        android.content.Intent intent = new android.content.Intent(android.content.Intent.ACTION_VIEW,
                            android.net.Uri.parse(mapsUri));
                        intent.addFlags(android.content.Intent.FLAG_ACTIVITY_NEW_TASK);
                        android.content.Intent chooser = android.content.Intent.createChooser(intent,
                            isRussian ? "Открыть в приложении карт" : "Open with maps app");
                        if (intent.resolveActivity(getPackageManager()) != null) startActivity(chooser);
                        else showToast(isRussian ? "Приложение карт не найдено" : "No maps app found");
                    });
                    myInfoContainer.addView(mapsBtn);
                }
            });
        }).start();
    }

    private void addMyInfoCard(String title, String body, String bgColor, String titleColor) {
        android.widget.LinearLayout card = new android.widget.LinearLayout(this);
        card.setOrientation(android.widget.LinearLayout.VERTICAL);
        card.setBackgroundColor(android.graphics.Color.parseColor(bgColor));
        android.widget.LinearLayout.LayoutParams lp = new android.widget.LinearLayout.LayoutParams(
            android.widget.LinearLayout.LayoutParams.MATCH_PARENT,
            android.widget.LinearLayout.LayoutParams.WRAP_CONTENT);
        lp.setMargins(0, 0, 0, 12);
        card.setLayoutParams(lp);
        card.setPadding(28, 20, 28, 20);

        android.widget.TextView tv = new android.widget.TextView(this);
        tv.setText(title);
        tv.setTextColor(android.graphics.Color.parseColor(titleColor));
        tv.setTextSize(13f);
        tv.setTypeface(null, android.graphics.Typeface.BOLD);
        tv.setPadding(0, 0, 0, 10);
        card.addView(tv);

        android.widget.TextView bv = new android.widget.TextView(this);
        bv.setText(body);
        bv.setTextColor(0xFFE0E0E0);
        bv.setTextSize(14f);
        bv.setTypeface(android.graphics.Typeface.MONOSPACE);
        card.addView(bv);

        myInfoContainer.addView(card);
    }

    private void addMyInfoRow(String text, String sub, String bgColor) {
        android.widget.TextView tv = new android.widget.TextView(this);
        tv.setText(text);
        tv.setTextColor(0xFFB0BEC5);
        tv.setTextSize(13f);
        tv.setPadding(12, 8, 12, 8);
        myInfoContainer.addView(tv);
    }

        // ── Helpers ──────────────────────────────────────────────────────────────

    // ══════════════════════════════════════════════════════════════════════════
    // TAB 7 — NETWORK TOOLS (Ping / Traceroute / Port Check / DNS Lookup)
    // ══════════════════════════════════════════════════════════════════════════

    private interface PingSink { void line(String l); }

    private void initToolsTab() {
        if (tab7 == null) return; // layout without tools tab (older layouts)
        toolsTitleText   = findViewById(R.id.toolsTitleText);
        toolsStatusText  = findViewById(R.id.toolsStatusText);
        toolPingBtn      = findViewById(R.id.toolPingBtn);
        toolTraceBtn     = findViewById(R.id.toolTraceBtn);
        toolPortBtn      = findViewById(R.id.toolPortBtn);
        toolDnsBtn       = findViewById(R.id.toolDnsBtn);
        toolsHostInput   = findViewById(R.id.toolsHostInput);
        toolsPortInput   = findViewById(R.id.toolsPortInput);
        toolsRunBtn      = findViewById(R.id.toolsRunBtn);
        toolsStopBtn     = findViewById(R.id.toolsStopBtn);
        toolsConsoleText = findViewById(R.id.toolsConsoleText);
        toolsScrollView  = findViewById(R.id.toolsScrollView);

        toolPingBtn.setOnClickListener(v  -> setToolMode(TOOL_PING));
        toolTraceBtn.setOnClickListener(v -> setToolMode(TOOL_TRACE));
        toolPortBtn.setOnClickListener(v  -> setToolMode(TOOL_PORT));
        toolDnsBtn.setOnClickListener(v   -> setToolMode(TOOL_DNS));
        toolsRunBtn.setOnClickListener(v -> runNetworkTool());
        toolsStopBtn.setOnClickListener(v -> stopNetworkTool());

        setToolMode(TOOL_PING);
        toolsConsoleText.setText("");
        toolPrint("#546e7a", "netwatch tools v2.8.0");
        toolPrint("#00e5ff", isRussian
            ? "выберите инструмент и введите хост"
            : "select a tool, enter a host, tap RUN");
    }

    private void setToolMode(int m) {
        toolMode = m;
        // Highlight the active mode button (cyan) — terminal style
        styleToolBtn(toolPingBtn,  m == TOOL_PING);
        styleToolBtn(toolTraceBtn, m == TOOL_TRACE);
        styleToolBtn(toolPortBtn,  m == TOOL_PORT);
        styleToolBtn(toolDnsBtn,   m == TOOL_DNS);
        // Port field only relevant for the PORT tool
        toolsPortInput.setVisibility(m == TOOL_PORT ? View.VISIBLE : View.GONE);
        toolsHostInput.setHint(isRussian ? "хост или IP (напр. google.com)" : "host or IP (e.g. google.com)");
        toolsPortInput.setHint(isRussian ? "порт" : "port");
        toolsTitleText.setText(isRussian ? "🛠 Сетевые инструменты" : "🛠 Network Tools");
        toolsRunBtn.setText(isRussian ? "▶  ПУСК" : "▶  RUN");
        toolsStopBtn.setText(isRussian ? "■  СТОП" : "■  STOP");
    }

    private void styleToolBtn(Button b, boolean active) {
        b.setBackgroundColor(active ? Color.parseColor("#123a4a") : Color.parseColor("#0d1117"));
        b.setTextColor(active ? Color.parseColor("#00e5ff") : Color.parseColor("#e0e8f0"));
    }

    private void runNetworkTool() {
        if (toolsRunning) return;
        String host = toolsHostInput.getText().toString().trim();
        if (host.isEmpty()) {
            showToast(isRussian ? "Введите хост или IP" : "Enter a host or IP first");
            return;
        }
        if (host.startsWith("http://"))  host = host.substring(7);
        if (host.startsWith("https://")) host = host.substring(8);
        if (host.contains("/")) host = host.substring(0, host.indexOf('/'));
        final String fHost = host;

        int port = -1;
        if (toolMode == TOOL_PORT) {
            String ps = toolsPortInput.getText().toString().trim();
            if (ps.isEmpty() && fHost.contains(":")) {           // allow "host:port" in the host field
                int ci = fHost.indexOf(':');
                ps = fHost.substring(ci + 1);
                host = fHost.substring(0, ci);
            }
            try { port = Integer.parseInt(ps); } catch (Exception e) { port = -1; }
            if (port < 1 || port > 65535) {
                showToast(isRussian ? "Неверный порт (1–65535)" : "Invalid port (1–65535)");
                return;
            }
        }
        final int fPort  = port;
        final String hostFinal = (toolMode == TOOL_PORT && host != fHost) ? host : fHost;

        toolsRunning = true;
        toolsRunBtn.setEnabled(false);
        toolsStopBtn.setVisibility(View.VISIBLE);
        toolsStatusText.setText(isRussian ? "⏳ Выполняется…" : "⏳ Running…");
        toolsConsoleText.setText("");

        final int mode = toolMode;
        executor.execute(() -> {
            try {
                if      (mode == TOOL_PING)  toolPing(hostFinal);
                else if (mode == TOOL_TRACE) toolTraceroute(hostFinal);
                else if (mode == TOOL_PORT)  toolPortCheck(hostFinal, fPort);
                else                         toolDnsLookup(hostFinal);
            } catch (Exception e) {
                toolPrint("#ef9a9a", "error: " + e.getMessage());
            }
            mainHandler.post(() -> {
                toolsRunning = false;
                toolsProc = null;
                toolsRunBtn.setEnabled(true);
                toolsStopBtn.setVisibility(View.GONE);
                toolsStatusText.setText(isRussian ? "⚫ Готово" : "⚫ Done");
            });
        });
    }

    private void stopNetworkTool() {
        toolsRunning = false;
        if (toolsProc != null) { toolsProc.destroy(); toolsProc = null; }
        toolPrint("#ffd740", isRussian ? "^ остановлено пользователем" : "^ stopped by user");
        toolsStatusText.setText(isRussian ? "⚫ Остановлено" : "⚫ Stopped");
    }

    /** Runs the system (toybox) ping binary, feeding every output line to sink.
     *  Returns the process exit code, or -1 if the process could not start. */
    private int runPingCapture(String host, int count, int ttl, PingSink sink) {
        try {
            java.util.List<String> cmd = new java.util.ArrayList<>();
            cmd.add("ping");
            if (ttl > 0) { cmd.add("-t"); cmd.add(String.valueOf(ttl)); }
            cmd.add("-c"); cmd.add(String.valueOf(count));
            cmd.add("-W"); cmd.add("2");
            cmd.add(host);
            ProcessBuilder pb = new ProcessBuilder(cmd);
            pb.redirectErrorStream(true);
            toolsProc = pb.start();
            java.io.BufferedReader r = new java.io.BufferedReader(
                new java.io.InputStreamReader(toolsProc.getInputStream()));
            String l;
            while (toolsRunning && (l = r.readLine()) != null) {
                if (sink != null) sink.line(l);
            }
            int rc;
            try { rc = toolsProc.waitFor(); } catch (InterruptedException ie) { rc = -1; }
            toolsProc = null;
            return rc;
        } catch (Exception e) {
            toolsProc = null;
            return -1;
        }
    }

    private void toolPing(String host) {
        toolPrint("#00e5ff", "$ ping -c 4 " + host);
        final boolean[] gotReply = {false};
        runPingCapture(host, 4, 0, l -> {
            if (l.trim().isEmpty()) return;
            if (l.contains("bytes from")) { gotReply[0] = true; toolPrint("#00ff88", l); }
            else if (l.contains("packet loss") || l.contains("rtt") || l.contains("min/avg/max"))
                toolPrint("#00e5ff", l);
            else if (l.startsWith("PING")) toolPrint("#546e7a", l);
            else toolPrint("#e0e8f0", l);
        });
        if (!gotReply[0])
            toolPrint("#ef9a9a", isRussian ? "— ответов не получено (хост недоступен?)" : "— no replies (host unreachable?)");
    }

    private void toolTraceroute(String host) {
        toolPrint("#00e5ff", "$ traceroute " + host);
        toolPrint("#546e7a", isRussian ? "  (через ping с ростом TTL — без root)" : "  (via ping with increasing TTL — rootless)");
        boolean reached = false;
        for (int ttl = 1; ttl <= 30 && toolsRunning && !reached; ttl++) {
            final java.util.List<String> lines = new java.util.ArrayList<>();
            runPingCapture(host, 1, ttl, lines::add);
            String hopIp = null, timeMs = null, reason = null;
            for (String l : lines) {
                if (l.contains("bytes from")) {                       // destination answered
                    int s = l.indexOf("bytes from ") + 11;
                    int e = l.indexOf(' ', s);
                    int c = l.indexOf(':', s);
                    int end = (e == -1) ? c : (c == -1 ? e : Math.min(e, c));
                    hopIp = l.substring(s, end == -1 ? l.length() : end);
                    int t = l.indexOf("time=");
                    if (t != -1) timeMs = l.substring(t + 5).split(" ")[0];
                    reached = true;
                    break;
                } else if (l.startsWith("From ")) {                   // TTL exceeded / unreachable
                    String[] tok = l.split("\\s+");
                    if (tok.length >= 2) {
                        hopIp = tok[1].endsWith(":") ? tok[1].substring(0, tok[1].length() - 1) : tok[1];
                        if (l.contains("Time to live exceeded"))   reason = "TTL exceeded";
                        else if (l.contains("Unreachable"))         reason = "unreachable";
                    }
                }
            }
            if (reached) {
                toolPrint("#00ff88", String.format(Locale.US, "%2d  %-40s %s ms", ttl, hopIp, timeMs == null ? "?" : timeMs));
                toolPrint("#00e5ff", isRussian ? "  ✅ цель достигнута" : "  ✅ destination reached");
            } else if (hopIp != null) {
                toolPrint("#e0e8f0", String.format(Locale.US, "%2d  %-40s %s", ttl, hopIp, reason == null ? "" : reason));
            } else {
                toolPrint("#546e7a", String.format(Locale.US, "%2d  * * *", ttl));
            }
        }
        if (!reached && toolsRunning)
            toolPrint("#ef9a9a", isRussian ? "  — цель не достигнута за 30 прыжков" : "  — no response within 30 hops");
    }

    private void toolPortCheck(String host, int port) {
        toolPrint("#00e5ff", "$ nc -zv " + host + " " + port);
        try {
            java.net.InetAddress addr = java.net.InetAddress.getByName(host);
            toolPrint("#546e7a", "resolved: " + addr.getHostAddress());
            long t0 = System.currentTimeMillis();
            java.net.Socket s = new java.net.Socket();
            try {
                s.connect(new java.net.InetSocketAddress(addr, port), 3000);
                long ms = System.currentTimeMillis() - t0;
                toolPrint("#00ff88", "OPEN   " + host + ":" + port + "  (" + ms + " ms)");
            } finally { s.close(); }
        } catch (java.net.SocketTimeoutException ste) {
            toolPrint("#ef9a9a", "CLOSED " + host + ":" + port + "  (timeout)");
        } catch (java.io.IOException ioe) {
            toolPrint("#ef9a9a", "CLOSED " + host + ":" + port + "  (" + ioe.getMessage() + ")");
        }
    }

    private void toolDnsLookup(String host) {
        toolPrint("#00e5ff", "$ dig " + host + " A AAAA CNAME TXT");
        String[][] typeMap = { {"A","1"}, {"AAAA","28"}, {"CNAME","5"}, {"TXT","16"} };
        boolean any = false;
        for (String[] t : typeMap) {
            if (!toolsRunning) break;
            try {
                java.net.URL u = new java.net.URL("https://dns.google/resolve?name=" +
                    java.net.URLEncoder.encode(host, "UTF-8") + "&type=" + t[0]);
                java.net.HttpURLConnection c = (java.net.HttpURLConnection) u.openConnection();
                c.setConnectTimeout(5000);
                c.setReadTimeout(8000);
                c.setRequestProperty("User-Agent", "Mozilla/5.0");
                if (c.getResponseCode() == 200) {
                    java.io.ByteArrayOutputStream bos = new java.io.ByteArrayOutputStream();
                    byte[] b = new byte[4096]; int n;
                    java.io.InputStream is = c.getInputStream();
                    while ((n = is.read(b)) != -1) bos.write(b, 0, n);
                    is.close();
                    org.json.JSONObject r = new org.json.JSONObject(bos.toString("UTF-8"));
                    org.json.JSONArray ans = r.optJSONArray("Answer");
                    if (ans != null && ans.length() > 0) {
                        for (int i = 0; i < ans.length(); i++) {
                            org.json.JSONObject a = ans.getJSONObject(i);
                            if (String.valueOf(a.optInt("type", 0)).equals(t[1]) || t[0].equals("TXT")) {
                                toolPrint("#00ff88", String.format(Locale.US, "%-6s %s", t[0], a.optString("data", "")));
                                any = true;
                            }
                        }
                    }
                }
                c.disconnect();
            } catch (Exception e) {
                toolPrint("#ef9a9a", t[0] + " lookup failed: " + e.getMessage());
            }
        }
        if (!any && toolsRunning)
            toolPrint("#ffd740", isRussian ? "записи не найдены" : "no records found");
    }

    /** Appends one colored line to the tools console (thread-safe). */
    private void toolPrint(final String color, final String text) {
        mainHandler.post(() -> {
            if (toolsConsoleText == null) return;
            android.text.SpannableString ss = new android.text.SpannableString(text + "\n");
            ss.setSpan(new android.text.style.ForegroundColorSpan(Color.parseColor(color)), 0, ss.length(), 0);
            toolsConsoleText.append(ss);
            if (toolsScrollView != null)
                toolsScrollView.post(() -> toolsScrollView.fullScroll(android.view.View.FOCUS_DOWN));
        });
    }

    private void switchTab(int index) {
        tab1.setVisibility(index == 0 ? View.VISIBLE : View.GONE);
        tab2.setVisibility(index == 1 ? View.VISIBLE : View.GONE);
        tab3.setVisibility(index == 2 ? View.VISIBLE : View.GONE);
        tab4.setVisibility(index == 3 ? View.VISIBLE : View.GONE);
        if (tab5 != null) tab5.setVisibility(index == 4 ? View.VISIBLE : View.GONE);
        if (tab6 != null) tab6.setVisibility(index == 5 ? View.VISIBLE : View.GONE);
        if (tab7 != null) tab7.setVisibility(index == 6 ? View.VISIBLE : View.GONE);
        if (index == 3 && myInfoContainer.getChildCount() == 0) lookupMyInfo();
        if (index == 4) initSpeedTab();
        if (index == 5) initDeviceTab();
        tabDomainBtn.setSelected(index == 0);
        tabTrafficBtn.setSelected(index == 1);
        tabCheckerBtn.setSelected(index == 2);
        if (tabSpeedBtn != null)  tabSpeedBtn.setSelected(index == 4);
        if (tabDeviceBtn != null) tabDeviceBtn.setSelected(index == 5);
        if (tabToolsBtn != null)  tabToolsBtn.setSelected(index == 6);
        // Re-apply last known stats so TX/RX panels are never blank on tab entry
        if (index == 1 && lastKnownTx >= 0) {
            txTotalText.setText("TX  " + formatBytes(lastKnownTx));
            rxTotalText.setText("RX  " + formatBytes(lastKnownRx));
            txRateText.setText("↑ " + formatBytes(lastKnownTxRate) + "/s");
            rxRateText.setText("↓ " + formatBytes(lastKnownRxRate) + "/s");
            txRateText.setTextColor(lastKnownTxRate > 0 ? Color.parseColor("#EF9A9A") : Color.parseColor("#546E7A"));
            rxRateText.setTextColor(lastKnownRxRate > 0 ? Color.parseColor("#66BB6A") : Color.parseColor("#546E7A"));
        }
    }

    private static String formatBytes(long bytes) {
        if (bytes < 0)    return "—";
        if (bytes < 1024) return bytes + " B";
        if (bytes < 1024*1024) return String.format(Locale.US, "%.1f KB", bytes/1024.0);
        if (bytes < 1024*1024*1024) return String.format(Locale.US, "%.2f MB", bytes/1048576.0);
        return String.format(Locale.US, "%.2f GB", bytes/1073741824.0);
    }

    private String postJson(String urlStr, String body) {
        try {
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type","application/json");
            conn.setDoOutput(true); conn.setConnectTimeout(15000); conn.setReadTimeout(30000);
            try (OutputStream os = conn.getOutputStream()) { os.write(body.getBytes("UTF-8")); }
            int code = conn.getResponseCode();
            BufferedReader br = new BufferedReader(new InputStreamReader(
                    code>=200&&code<300 ? conn.getInputStream() : conn.getErrorStream()));
            StringBuilder sb = new StringBuilder(); String line;
            while ((line=br.readLine())!=null) sb.append(line);
            br.close(); return sb.toString();
        } catch (Exception e) { return null; }
    }

    private int dp(int val) {
        return (int)(val * getResources().getDisplayMetrics().density);
    }

    private void showToast(String msg) {
        Toast.makeText(this, msg, Toast.LENGTH_SHORT).show();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        try { unregisterReceiver(trafficReceiver); } catch (Exception ignored) {}
        executor.shutdownNow();
    }

    // ─────────────────────────────────────────────────────────────
    // TAB 3 — Domain Checker
    // ─────────────────────────────────────────────────────────────

    // Ordered map: category -> list of {label, host}
    private static final LinkedHashMap<String, String[][]> CHECKER_DOMAINS = new LinkedHashMap<>();
    static {
        CHECKER_DOMAINS.put("🔵 Google", new String[][]{
            {"Google Search",     "google.com"},
            {"Google DNS",        "8.8.8.8"},
            {"Gmail",             "mail.google.com"},
            {"Google Drive",      "drive.google.com"},
            {"YouTube",           "youtube.com"},
            {"Google Play",       "play.google.com"},
            {"Google APIs",       "googleapis.com"},
        });
        CHECKER_DOMAINS.put("🟠 Microsoft", new String[][]{
            {"Bing",              "bing.com"},
            {"Outlook / Exchange","outlook.office365.com"},
            {"OneDrive",          "onedrive.live.com"},
            {"Teams",             "teams.microsoft.com"},
            {"Azure",             "azure.microsoft.com"},
            {"Microsoft CDN",     "msftconnecttest.com"},
        });
        CHECKER_DOMAINS.put("🟡 Cloudflare", new String[][]{
            {"Cloudflare DNS 1",  "1.1.1.1"},
            {"Cloudflare DNS 2",  "1.0.0.1"},
            {"Cloudflare Web",    "cloudflare.com"},
            {"WARP / DoH",        "cloudflare-dns.com"},
        });
        CHECKER_DOMAINS.put("🟣 Social & Messaging", new String[][]{
            {"Facebook",          "facebook.com"},
            {"Instagram",         "instagram.com"},
            {"WhatsApp",          "web.whatsapp.com"},
            {"Twitter / X",       "x.com"},
            {"Telegram",          "telegram.org"},
            {"LinkedIn",          "linkedin.com"},
            {"TikTok",            "tiktok.com"},
            {"Reddit",            "reddit.com"},
            {"GitHub",            "github.com"},
            {"Disqus",            "disqus.com"},
        });
        CHECKER_DOMAINS.put("🔴 Streaming", new String[][]{
            {"Netflix",           "netflix.com"},
            {"Hulu",              "hulu.com"},
            {"Spotify",           "spotify.com"},
            {"Twitch",            "twitch.tv"},
            {"Apple iCloud",      "icloud.com"},
        });
        CHECKER_DOMAINS.put("🟢 CDN / Infrastructure", new String[][]{
            {"Akamai",            "akamai.com"},
            {"Fastly",            "fastly.com"},
            {"Amazon AWS",        "aws.amazon.com"},
            {"Quad9 DNS",         "9.9.9.9"},
            {"OpenDNS",           "208.67.222.222"},
        });
        CHECKER_DOMAINS.put("🏦 Finance & Payments", new String[][]{
            {"PayPal",            "paypal.com"},
            {"Stripe",            "stripe.com"},
            {"Visa",              "visa.com"},
            {"Mastercard",        "mastercard.com"},
            {"Wise",              "wise.com"},
            {"Tangem",            "tangem.com"},
            {"Bitcoin",           "bitcoin.org"},
        });
        CHECKER_DOMAINS.put("🎮 Gaming", new String[][]{
            {"Xbox Live",         "xbox.com"},
            {"Xbox Services",     "xboxlive.com"},
            {"Xbox CDN",          "xboxlive-ce-retail.com"},
            {"Microsoft Game",    "xgweb.com"},
            {"PlayStation",       "playstation.com"},
            {"PSN Network",       "psn.np.com"},
            {"PS Store",          "store.playstation.com"},
            {"PS CDN",            "dl.playstation.net"},
            {"PS Auth",           "auth.api.sonyentertainmentnetwork.com"},
        });
        CHECKER_DOMAINS.put("🤖 AI Services", new String[][]{
            {"ChatGPT",           "chatgpt.com"},
            {"OpenAI API",        "api.openai.com"},
            {"OpenAI CDN",        "openaicom-api-bdcpf8c6d2e9atf6.z01.azurefd.net"},
            {"Gemini",            "gemini.google.com"},
            {"Google AI API",     "generativelanguage.googleapis.com"},
            {"Google AI Studio",  "aistudio.google.com"},
        });
    }

    // Map host -> status TextView (populated by buildCheckerRows)
    private final Map<String, TextView> checkerStatusViews = new LinkedHashMap<>();

    private void buildCheckerRows() {
        checkResultsContainer.removeAllViews();
        checkerStatusViews.clear();

        for (Map.Entry<String, String[][]> cat : CHECKER_DOMAINS.entrySet()) {
            // Category header
            TextView header = new TextView(this);
            header.setText(cat.getKey());
            header.setTextColor(Color.parseColor("#00E5FF"));
            header.setTextSize(12f);
            header.setTypeface(null, Typeface.BOLD);
            LinearLayout.LayoutParams hp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
            hp.setMargins(0, dp(10), 0, dp(4));
            header.setLayoutParams(hp);
            header.setAllCaps(true);
            checkResultsContainer.addView(header);

            for (String[] entry : cat.getValue()) {
                String label = entry[0];
                String host  = entry[1];

                LinearLayout row = new LinearLayout(this);
                row.setOrientation(LinearLayout.HORIZONTAL);
                row.setBackground(getDrawable(R.drawable.card_background));
                LinearLayout.LayoutParams rp = new LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                rp.setMargins(0, dp(2), 0, dp(2));
                row.setLayoutParams(rp);
                row.setPadding(dp(10), dp(8), dp(10), dp(8));

                // Status dot
                TextView dot = new TextView(this);
                dot.setText("●");
                dot.setTextColor(Color.parseColor("#546E7A"));
                dot.setTextSize(14f);
                dot.setPadding(0, 0, dp(10), 0);
                row.addView(dot);

                // Label + host
                LinearLayout info = new LinearLayout(this);
                info.setOrientation(LinearLayout.VERTICAL);
                info.setLayoutParams(new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
                TextView labelView = new TextView(this);
                labelView.setText(label);
                labelView.setTextColor(Color.parseColor("#C8D8E8"));
                labelView.setTextSize(13f);
                TextView hostView = new TextView(this);
                hostView.setText(host);
                hostView.setTextColor(Color.parseColor("#607D8B"));
                hostView.setTextSize(11f);
                info.addView(labelView);
                info.addView(hostView);
                row.addView(info);

                // Latency / status text
                TextView status = new TextView(this);
                status.setText("—");
                status.setTextColor(Color.parseColor("#546E7A"));
                status.setTextSize(12f);
                status.setGravity(android.view.Gravity.END | android.view.Gravity.CENTER_VERTICAL);
                row.addView(status);

                checkerStatusViews.put(host, status);
                // Store dot view using tag so we can color it
                row.setTag(dot);
                checkResultsContainer.addView(row);
            }
        }
    }

    private void startDomainCheck() {
        if (checkRunning.get()) return;
        checkRunning.set(true);
        checkAllBtn.setEnabled(false);
        stopCheckBtn.setEnabled(true);
        checkStatusText.setTextColor(Color.parseColor("#00E5FF"));

        // Reset all to pending
        for (Map.Entry<String, TextView> e : checkerStatusViews.entrySet()) {
            e.getValue().setText("…");
            e.getValue().setTextColor(Color.parseColor("#90A4AE"));
            // Reset dot
            ViewParent vp = e.getValue().getParent();
            if (vp instanceof LinearLayout) {
                Object tag = ((LinearLayout)vp).getTag();
                if (tag instanceof TextView) ((TextView)tag).setTextColor(Color.parseColor("#546E7A"));
            }
        }

        final List<String[]> allEntries = new ArrayList<>();
        for (String[][] entries : CHECKER_DOMAINS.values())
            for (String[] e : entries) allEntries.add(e);

        executor.execute(() -> {
            int done = 0, reachable = 0, blocked = 0;
            for (String[] entry : allEntries) {
                if (!checkRunning.get()) break;
                String label = entry[0];
                String host  = entry[1];
                done++;
                final int fdone = done;
                mainHandler.post(() ->
                    checkStatusText.setText((isRussian ? "Проверка " : "Checking ") + fdone + "/" + allEntries.size() + " — " + host));

                long[] result = probeHost(host);
                // result[0] = 1 reachable / 0 blocked, result[1] = latency ms
                boolean ok = result[0] == 1;
                long ms     = result[1];
                if (ok) reachable++; else blocked++;

                mainHandler.post(() -> {
                    TextView sv = checkerStatusViews.get(host);
                    if (sv == null) return;
                    sv.setText(ok ? ms + " ms" : "BLOCKED");
                    sv.setTextColor(ok ? Color.parseColor("#66BB6A") : Color.parseColor("#EF5350"));
                    ViewParent vp = sv.getParent();
                    if (vp instanceof LinearLayout) {
                        Object tag = ((LinearLayout)vp).getTag();
                        if (tag instanceof TextView)
                            ((TextView)tag).setTextColor(ok ? Color.parseColor("#66BB6A") : Color.parseColor("#EF5350"));
                    }
                });
            }

            final int fr = reachable, fb = blocked, fd = done;
            mainHandler.post(() -> {
                checkRunning.set(false);
                checkAllBtn.setEnabled(true);
                stopCheckBtn.setEnabled(false);
                if (fd == allEntries.size()) {
                    checkStatusText.setText(isRussian ? "Готово — ✅ " + fr + " доступно   🚫 " + fb + " заблокировано" : "Done — ✅ " + fr + " reachable   🚫 " + fb + " blocked");
                } else {
                    checkStatusText.setText(isRussian ? "Остановлено — ✅ " + fr + "  🚫 " + fb + " (из " + fd + " проверено)" : "Stopped — ✅ " + fr + "  🚫 " + fb + " (of " + fd + " checked)");
                }
                checkStatusText.setTextColor(fb > 0 ? Color.parseColor("#EF9A9A") : Color.parseColor("#66BB6A"));
            });
        });
    }

    private void stopDomainCheck() {
        checkRunning.set(false);
        stopCheckBtn.setEnabled(false);
    }

    /** Returns [reachable(1/0), latencyMs] */
    private long[] probeHost(String host) {
        long start = System.currentTimeMillis();
        try {
            // First try HTTP(S) for named hosts, ICMP-style connect for IPs
            boolean isIp = host.matches("\\d+\\.\\d+\\.\\d+\\.\\d+");
            if (isIp) {
                InetAddress addr = InetAddress.getByName(host);
                boolean reached = addr.isReachable(3000);
                if (!reached) {
                    // Fallback: TCP connect to port 53 (DNS) for IP addresses
                    try (java.net.Socket sock = new java.net.Socket()) {
                        sock.connect(new java.net.InetSocketAddress(host, 53), 3000);
                        reached = true;
                    } catch (Exception ignored2) {}
                }
                long ms = System.currentTimeMillis() - start;
                return new long[]{reached ? 1 : 0, ms};
            } else {
                // DNS resolve first
                InetAddress.getByName(host); // throws if blocked/unresolvable
                // Then HTTP HEAD
                URL url = new URL("https://" + host + "/");
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("HEAD");
                conn.setConnectTimeout(3000);
                conn.setReadTimeout(3000);
                conn.setInstanceFollowRedirects(true);
                conn.connect();
                int code = conn.getResponseCode();
                conn.disconnect();
                long ms = System.currentTimeMillis() - start;
                // Any HTTP response (including 4xx/5xx) means the host is reachable
                return new long[]{(code > 0) ? 1 : 0, ms};
            }
        } catch (Exception e) {
            long ms = System.currentTimeMillis() - start;
            return new long[]{0, ms};
        }
    }


    // ─────────────────────────────────────────────────────────────
    // Custom domain / IP check
    // ─────────────────────────────────────────────────────────────
    private void checkCustomDomain() {
        String raw = customDomainInput.getText().toString().trim();
        if (raw.isEmpty()) { showToast(isRussian ? "Введите домен или IP" : "Enter a domain or IP first"); return; }
        // Strip protocol prefix if pasted in
        raw = raw.replaceFirst("^https?://", "").replaceFirst("/.*$", "");
        final String host = raw;

        // Dismiss keyboard
        android.view.inputmethod.InputMethodManager imm =
            (android.view.inputmethod.InputMethodManager) getSystemService(INPUT_METHOD_SERVICE);
        if (imm != null) imm.hideSoftInputFromWindow(customDomainInput.getWindowToken(), 0);

        // Add a result row at the top of the results container (or update existing)
        LinearLayout existingRow = (LinearLayout) checkResultsContainer.findViewWithTag("custom_" + host);
        TextView statusView;
        TextView dotView;

        if (existingRow != null) {
            dotView    = (TextView) existingRow.getTag();
            statusView = (TextView) existingRow.getChildAt(existingRow.getChildCount() - 1);
            dotView.setTextColor(Color.parseColor("#FFC107"));
            statusView.setText("…");
            statusView.setTextColor(Color.parseColor("#90A4AE"));
        } else {
            // Section header (only once for custom entries)
            if (checkResultsContainer.findViewWithTag("custom_header") == null) {
                TextView header = new TextView(this);
                header.setTag("custom_header");
                header.setText("🔎  Custom Checks");
                header.setTextColor(Color.parseColor("#00E5FF"));
                header.setTextSize(12f);
                header.setTypeface(null, android.graphics.Typeface.BOLD);
                header.setAllCaps(true);
                LinearLayout.LayoutParams hp = new LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                hp.setMargins(0, dp(10), 0, dp(4));
                header.setLayoutParams(hp);
                checkResultsContainer.addView(header, 0);
            }

            LinearLayout row = new LinearLayout(this);
            row.setOrientation(LinearLayout.HORIZONTAL);
            row.setBackground(getDrawable(R.drawable.card_background));
            row.setTag("custom_" + host);
            LinearLayout.LayoutParams rp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
            rp.setMargins(0, dp(2), 0, dp(2));
            row.setLayoutParams(rp);
            row.setPadding(dp(10), dp(8), dp(10), dp(8));

            dotView = new TextView(this);
            dotView.setText("●");
            dotView.setTextColor(Color.parseColor("#FFC107")); // amber = in progress
            dotView.setTextSize(14f);
            dotView.setPadding(0, 0, dp(10), 0);
            row.setTag(dotView);
            row.addView(dotView);

            LinearLayout info = new LinearLayout(this);
            info.setOrientation(LinearLayout.VERTICAL);
            info.setLayoutParams(new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
            TextView labelView = new TextView(this);
            labelView.setText(host);
            labelView.setTextColor(Color.parseColor("#C8D8E8"));
            labelView.setTextSize(13f);
            TextView typeView = new TextView(this);
            typeView.setText(host.matches("\\d+\\.\\d+\\.\\d+\\.\\d+") ? "IP Address" : "Domain");
            typeView.setTextColor(Color.parseColor("#607D8B"));
            typeView.setTextSize(11f);
            info.addView(labelView);
            info.addView(typeView);
            row.addView(info);

            statusView = new TextView(this);
            statusView.setText("…");
            statusView.setTextColor(Color.parseColor("#90A4AE"));
            statusView.setTextSize(12f);
            statusView.setGravity(android.view.Gravity.END | android.view.Gravity.CENTER_VERTICAL);
            row.addView(statusView);

            // Insert just after the custom_header
            int insertIdx = 1;
            checkResultsContainer.addView(row, insertIdx);
        }

        final TextView fStatus = statusView;
        final TextView fDot    = dotView;

        checkStatusText.setText((isRussian ? "Проверка " : "Checking ") + host + "…");
        checkStatusText.setTextColor(Color.parseColor("#00E5FF"));

        executor.execute(() -> {
            long[] result = probeHost(host);
            boolean ok = result[0] == 1;
            long ms     = result[1];
            mainHandler.post(() -> {
                fStatus.setText(ok ? ms + " ms" : "BLOCKED");
                fStatus.setTextColor(ok ? Color.parseColor("#66BB6A") : Color.parseColor("#EF5350"));
                fDot.setTextColor(ok ? Color.parseColor("#66BB6A") : Color.parseColor("#EF5350"));
                checkStatusText.setText(host + (ok ? " ✅  reachable in " + ms + " ms" : " 🚫  appears BLOCKED"));
                checkStatusText.setTextColor(ok ? Color.parseColor("#66BB6A") : Color.parseColor("#EF9A9A"));
                // Scroll to top so user sees the result
                ScrollView sv = (ScrollView) checkResultsContainer.getParent();
                sv.smoothScrollTo(0, 0);
            });
        });
    }


    // ─────────────────────────────────────────────────────────────────────────
    // TAB 5 — Speed Test
    // ─────────────────────────────────────────────────────────────────────────
    private boolean speedTabInitialized = false;
    private boolean speedRunning = false;
    private Spinner speedServerSpinner;
    private TextView speedStatusText, speedPingText, speedDownText, speedUpText;
    private android.widget.LinearLayout speedResultsContainer;
    private Button speedRunBtn;

    private void initSpeedTab() {
        if (speedTabInitialized) return;
        speedTabInitialized = true;

        speedServerSpinner    = findViewById(R.id.speedServerSpinner);
        speedStatusText       = findViewById(R.id.speedStatusText);
        speedPingText         = findViewById(R.id.speedPingText);
        speedDownText         = findViewById(R.id.speedDownText);
        speedUpText           = findViewById(R.id.speedUpText);
        speedResultsContainer = findViewById(R.id.speedResultsContainer);
        speedRunBtn           = findViewById(R.id.speedRunBtn);

        // Populate spinner with server labels
        String[] labels = new String[SPEED_SERVERS.length];
        for (int i = 0; i < SPEED_SERVERS.length; i++) labels[i] = SPEED_SERVERS[i][0];
        ThemedArrayAdapter<String> adapter = new ThemedArrayAdapter<>(labels);
        speedServerSpinner.setAdapter(adapter);

        speedRunBtn.setOnClickListener(v -> {
            if (speedRunning) return;
            runSpeedTest();
        });
    }

    private void runSpeedTest() {
        int idx        = speedServerSpinner.getSelectedItemPosition();
        String url     = SPEED_SERVERS[idx][1];
        String type    = SPEED_SERVERS[idx][2];
        String label   = SPEED_SERVERS[idx][0].trim();
        boolean isCf   = "cloudflare".equals(type);
        boolean isOkla = "ookla".equals(type);
        boolean isYx   = "yandex".equals(type);

        speedRunning = true;
        speedRunBtn.setEnabled(false);
        speedStatusText.setVisibility(android.view.View.VISIBLE);
        speedStatusText.setText(isRussian ? "⏳ Тестирование…" : "⏳ Running test…");
        speedPingText.setText("—");
        speedDownText.setText("—");
        speedUpText.setText("—");
        speedResultsContainer.setVisibility(android.view.View.GONE);

        executor.execute(() -> {
            // ── Yandex Internetometer: resolve dynamic probe URLs ────────
            // Yandex's probes live on rotating CDN hosts; the app fetches a
            // fresh probe config from the internetometer API first.
            String yxProbeDl = null, yxProbeUl = null;
            if (isYx) {
                try {
                    String api = url + "/api/v0/get-probes?nocache=" + System.currentTimeMillis() + "&from=internetometr";
                    java.net.HttpURLConnection pc = (java.net.HttpURLConnection) new java.net.URL(api).openConnection();
                    pc.setConnectTimeout(5000);
                    pc.setReadTimeout(8000);
                    pc.setRequestProperty("User-Agent", "Mozilla/5.0");
                    if (pc.getResponseCode() == 200) {
                        java.io.ByteArrayOutputStream bos = new java.io.ByteArrayOutputStream();
                        byte[] pb = new byte[8192]; int pn;
                        java.io.InputStream pis = pc.getInputStream();
                        while ((pn = pis.read(pb)) != -1) bos.write(pb, 0, pn);
                        pis.close();
                        org.json.JSONObject cfg = new org.json.JSONObject(bos.toString("UTF-8"));
                        org.json.JSONArray dl = cfg.getJSONObject("download").getJSONArray("probes");
                        for (int i = 0; i < dl.length() && yxProbeDl == null; i++) {
                            String u2 = dl.getJSONObject(i).optString("url", "");
                            if (u2.contains("/probes/50mb")) yxProbeDl = u2;
                        }
                        if (yxProbeDl == null && dl.length() > 0)
                            yxProbeDl = dl.getJSONObject(0).optString("url", "");
                        org.json.JSONArray up = cfg.getJSONObject("upload").getJSONArray("probes");
                        if (up.length() > 0) yxProbeUl = up.getJSONObject(0).optString("url", "");
                    }
                    pc.disconnect();
                } catch (Exception ignored) { }
            }

            // ── Latency ──────────────────────────────────────────────────
            long latMs = Long.MAX_VALUE;
            try {
                // For Yandex, measure latency to the actual CDN probe host
                java.net.URL u = new java.net.URL(yxProbeDl != null ? yxProbeDl : url);
                String host = u.getHost();
                int port = u.getPort() > 0 ? u.getPort() : url.startsWith("https") ? 443 : 80;
                for (int i = 0; i < 3; i++) {
                    long t0 = System.currentTimeMillis();
                    java.net.Socket s = new java.net.Socket();
                    try {
                        s.connect(new java.net.InetSocketAddress(host, port), 1000);
                        s.close();
                        latMs = Math.min(latMs, System.currentTimeMillis() - t0);
                        Thread.sleep(100);
                    } catch (Exception e) { s.close(); }
                }
            } catch (Exception e) { latMs = -1; }
            final long finalLat = latMs == Long.MAX_VALUE ? -1 : latMs;

            // ── Download ─────────────────────────────────────────────────
            mainHandler.post(() -> speedStatusText.setText(isRussian ? "⬇ Загрузка…" : "⬇ Downloading…"));
            double dlMbps = -1;
            try {
                String dlUrl;
                if (isYx)        dlUrl = yxProbeDl; // dynamic 50MB probe URL
                else if (isCf)   dlUrl = url + "/__down?bytes=10485760";
                else if (isOkla) dlUrl = url + "/download?size=10485760";
                else             dlUrl = url + "/garbage.php?ckSize=10";

                java.net.HttpURLConnection c = (java.net.HttpURLConnection) new java.net.URL(dlUrl).openConnection();
                c.setInstanceFollowRedirects(false);
                c.setConnectTimeout(8000);
                c.setReadTimeout(25000);
                c.setRequestProperty("User-Agent", "NetWatch/2.0.3");
                c.connect();
                if (c.getResponseCode() == 200) {
                    long t0 = System.currentTimeMillis();
                    byte[] buf = new byte[65536];
                    java.io.InputStream is = c.getInputStream();
                    long total = 0;
                    int n;
                    while ((n = is.read(buf)) != -1 && total < 10485760) total += n;
                    is.close();
                    long elapsed = System.currentTimeMillis() - t0;
                    if (elapsed > 0 && total > 0)
                        dlMbps = (total * 8.0) / (elapsed / 1000.0) / 1_000_000.0;
                }
                c.disconnect();
            } catch (Exception e) { /* download error */ }

            // ── Upload ───────────────────────────────────────────────────
            mainHandler.post(() -> speedStatusText.setText(isRussian ? "⬆ Отдача…" : "⬆ Uploading…"));
            double ulMbps = -1;
            try {
                String ulUrl;
                if (isYx)        ulUrl = yxProbeUl; // dynamic upload probe URL
                else if (isCf)   ulUrl = url + "/__up";
                else if (isOkla) ulUrl = url + "/upload";
                else             ulUrl = url + "/empty.php";

                byte[] payload = new byte[4 * 1024 * 1024];
                java.net.HttpURLConnection c = (java.net.HttpURLConnection) new java.net.URL(ulUrl).openConnection();
                c.setInstanceFollowRedirects(false);
                c.setRequestMethod("POST");
                c.setDoOutput(true);
                c.setConnectTimeout(8000);
                c.setReadTimeout(25000);
                c.setRequestProperty("Content-Type", "application/octet-stream");
                c.setRequestProperty("User-Agent", "NetWatch/2.0.3");
                long t0 = System.currentTimeMillis();
                java.io.OutputStream os = c.getOutputStream();
                os.write(payload);
                os.flush();
                os.close();
                int rc = c.getResponseCode();
                long elapsed = System.currentTimeMillis() - t0;
                if (elapsed > 0 && rc < 500)
                    ulMbps = (payload.length * 8.0) / (elapsed / 1000.0) / 1_000_000.0;
                c.disconnect();
            } catch (Exception e) { /* upload error */ }

            final double finalDl = dlMbps;
            final double finalUl = ulMbps;
            final boolean yxFail = isYx && (yxProbeDl == null || yxProbeUl == null);

            mainHandler.post(() -> {
                speedRunning = false;
                speedRunBtn.setEnabled(true);
                speedStatusText.setText(yxFail
                    ? (isRussian ? "⚠ Не удалось получить тестовые серверы Яндекса" : "⚠ Could not resolve Yandex probe servers")
                    : (isRussian ? "✅ Тест завершён — " : "✅ Test complete — ") + label);
                speedPingText.setText(finalLat >= 0 ? finalLat + " ms" : (isRussian ? "недоступен" : "unreachable"));
                speedDownText.setText(finalDl >= 0 ? String.format(java.util.Locale.US, "%.2f Mbps", finalDl) : (isRussian ? "нет данных" : "N/A"));
                speedUpText.setText(finalUl >= 0 ? String.format(java.util.Locale.US, "%.2f Mbps", finalUl) : (isRussian ? "нет данных" : "N/A"));

                speedPingText.setTextColor(android.graphics.Color.parseColor(
                    finalLat < 0 ? "#546E7A" : finalLat < 50 ? "#00FF88" : finalLat < 150 ? "#FFD740" : "#EF9A9A"));
                speedDownText.setTextColor(android.graphics.Color.parseColor(
                    finalDl < 0 ? "#546E7A" : finalDl >= 50 ? "#00FF88" : finalDl >= 10 ? "#FFD740" : "#EF9A9A"));
                speedUpText.setTextColor(android.graphics.Color.parseColor(
                    finalUl < 0 ? "#546E7A" : finalUl >= 20 ? "#00FF88" : finalUl >= 5 ? "#FFD740" : "#EF9A9A"));
                speedResultsContainer.setVisibility(android.view.View.VISIBLE);
            });
        });
    }

    // TAB 6 — Device Monitor (VPN-based whole-device traffic)
    // ─────────────────────────────────────────────────────────────────────────
    private boolean deviceTabInitialized = false;
    private boolean deviceMonRunning = false;
    private final java.util.List<String[]> deviceLog = new java.util.ArrayList<>();
    private android.content.BroadcastReceiver deviceReceiver;
    private static final int VPN_REQUEST_CODE = 1001;
    // device-tab views (set in initDeviceTab)
    private Button deviceToggleBtn;
    private Button deviceClearBtn;
    private Button deviceExportBtn;
    private TextView deviceStatusText;
    private TextView deviceCountText;
    private android.widget.LinearLayout deviceHeaderRow;
    private android.widget.LinearLayout deviceLogContainer;
    private android.widget.ScrollView deviceScrollView;

    private void initDeviceTab() {
        if (deviceTabInitialized) return;
        deviceTabInitialized = true;

        deviceToggleBtn  = findViewById(R.id.deviceToggleBtn);
        deviceClearBtn   = findViewById(R.id.deviceClearBtn);
        deviceExportBtn  = findViewById(R.id.deviceExportBtn);
        deviceStatusText = findViewById(R.id.deviceStatusText);
        deviceCountText  = findViewById(R.id.deviceCountText);
        deviceHeaderRow  = findViewById(R.id.deviceHeaderRow);
        deviceLogContainer = findViewById(R.id.deviceLogContainer);
        deviceScrollView = findViewById(R.id.deviceScrollView);

        deviceToggleBtn.setOnClickListener(v -> {
            if (deviceMonRunning) stopDeviceMonitor();
            else startDeviceMonitor();
        });

        deviceClearBtn.setOnClickListener(v -> {
            deviceLog.clear();
            deviceLogContainer.removeAllViews();
            deviceCountText.setText("0 connections");
            deviceExportBtn.setVisibility(android.view.View.GONE);
            deviceClearBtn.setVisibility(android.view.View.GONE);
            deviceHeaderRow.setVisibility(android.view.View.GONE);
        });

        deviceExportBtn.setOnClickListener(v -> exportDeviceLog());
    }

    private void startDeviceMonitor() {
        pendingVpnPurpose = VPN_PURPOSE_DEVICE;
        android.content.Intent vpnIntent = android.net.VpnService.prepare(this);
        if (vpnIntent != null) {
            startActivityForResult(vpnIntent, VPN_REQUEST_CODE);
            return;
        }
        launchDeviceVpn();
    }

    // 0=none, 1=Device Monitor tab, 2=Traffic Monitor tab (per-app, VPN-backed host discovery)
    private static final int VPN_PURPOSE_DEVICE  = 1;
    private static final int VPN_PURPOSE_TRAFFIC = 2;
    private int pendingVpnPurpose = 0;
    private boolean trafficVpnEngineActive = false; // NetWatchVpnService started specifically for Traffic Monitor

    @Override
    protected void onActivityResult(int requestCode, int resultCode, android.content.Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == VPN_REQUEST_CODE) {
            int purpose = pendingVpnPurpose;
            pendingVpnPurpose = 0;
            if (resultCode == RESULT_OK) {
                if (purpose == VPN_PURPOSE_DEVICE) {
                    launchDeviceVpn();
                } else if (purpose == VPN_PURPOSE_TRAFFIC) {
                    launchTrafficMonitoringInternal();
                }
            } else if (purpose == VPN_PURPOSE_TRAFFIC) {
                // User declined VPN permission — Traffic Monitor can't discover real hosts
                // without it, but stats-only monitoring still runs.
                showToast(isRussian
                    ? "Разрешение VPN отклонено — обнаружение хостов недоступно, статистика трафика продолжается"
                    : "VPN permission declined — host discovery unavailable, traffic stats still active");
                launchTrafficMonitoringInternal();
            }
        }
    }

    /** Ensures the shared VPN capture engine is running (harmless no-op if Device
     *  Monitor already has it up) so Traffic Monitor gets real per-app host discovery. */
    private void ensureVpnEngineRunning() {
        android.content.Intent svc = new android.content.Intent(this, NetWatchVpnService.class);
        svc.setAction("START");
        startForegroundService(svc);
    }

    private void launchDeviceVpn() {
        // Register LocalBroadcast receiver for traffic events from the VPN service
        deviceReceiver = new android.content.BroadcastReceiver() {
            @Override
            public void onReceive(android.content.Context ctx, android.content.Intent intent) {
                String protocol  = intent.getStringExtra("protocol");
                String host      = intent.getStringExtra("host");
                String ipPort    = intent.getStringExtra("ipPort");
                String appLabel  = intent.getStringExtra("app");
                String timestamp = intent.getStringExtra("timestamp");
                if (ipPort == null) return;
                protocol  = protocol  != null ? protocol  : "?";
                appLabel  = appLabel  != null ? appLabel  : "";
                timestamp = timestamp != null ? timestamp : "";

                String rawIp  = ipPort.contains(":") ? ipPort.split(":")[0] : ipPort;
                String display = (host != null && !host.isEmpty() && !host.equals(rawIp)) ? host : rawIp;

                synchronized (deviceLog) {
                    // Update existing row if DNS just resolved
                    if (host != null && !host.isEmpty() && !host.equals(rawIp)) {
                        for (String[] e : deviceLog) {
                            if (e[2].equals(ipPort)) {
                                e[0] = host; e[1] = host;
                                runOnUiThread(() -> refreshDeviceLog());
                                return;
                            }
                        }
                    }
                    // [displayName, hostname, ipPort, proto, timestamp, appLabel]
                    deviceLog.add(new String[]{display, display, ipPort, protocol, timestamp, appLabel});
                }
                runOnUiThread(() -> refreshDeviceLog());
            }
        };

        androidx.localbroadcastmanager.content.LocalBroadcastManager.getInstance(this)
            .registerReceiver(deviceReceiver,
                new android.content.IntentFilter("com.netwatch.app.DEVICE_TRAFFIC"));

        // Start VPN-based device monitor service
        android.content.Intent svc = new android.content.Intent(this, NetWatchVpnService.class);
        svc.setAction("START");
        startForegroundService(svc);

        deviceMonRunning = true;
        if (deviceToggleBtn != null) {
            deviceToggleBtn.setText(isRussian ? "⏹  СТОП" : "⏹  STOP");
            deviceToggleBtn.setBackgroundResource(R.drawable.btn_device_stop);
        }
        if (deviceStatusText != null) {
            deviceStatusText.setText(isRussian ? "● Активен" : "● Active");
            deviceStatusText.setTextColor(android.graphics.Color.parseColor("#00FF88"));
        }
        if (deviceHeaderRow != null) deviceHeaderRow.setVisibility(android.view.View.VISIBLE);
        if (deviceClearBtn  != null) deviceClearBtn.setVisibility(android.view.View.VISIBLE);
    }

    private void stopDeviceMonitor() {
        if (deviceReceiver != null) {
            try {
                androidx.localbroadcastmanager.content.LocalBroadcastManager.getInstance(this)
                    .unregisterReceiver(deviceReceiver);
            } catch (Exception ignored) {}
            deviceReceiver = null;
        }

        deviceMonRunning = false;

        // Only tear down the shared VPN engine if Traffic Monitor isn't also relying on it.
        if (!trafficVpnEngineActive) {
            android.content.Intent svc = new android.content.Intent(this, NetWatchVpnService.class);
            svc.setAction(NetWatchVpnService.ACTION_STOP);
            startService(svc);
        }
        if (deviceToggleBtn != null) {
            deviceToggleBtn.setText(isRussian ? "▶  СТАРТ" : "▶  START");
            deviceToggleBtn.setBackgroundResource(R.drawable.btn_device_start);
        }
        if (deviceStatusText != null) {
            deviceStatusText.setText(isRussian ? "Остановлен" : "Stopped");
            deviceStatusText.setTextColor(android.graphics.Color.parseColor("#546E7A"));
        }
        if (!deviceLog.isEmpty() && deviceExportBtn != null) {
            deviceExportBtn.setVisibility(android.view.View.VISIBLE);
        }
    }

    private void refreshDeviceLog() {
        if (deviceLogContainer == null) return;
        deviceLogContainer.removeAllViews();
        synchronized (deviceLog) {
            for (String[] e : deviceLog) {
                deviceLogContainer.addView(buildDeviceRow(e[0], e[2], e[3], e[4], e[5]));
            }
            if (deviceCountText != null)
                deviceCountText.setText(deviceLog.size() + " connection" + (deviceLog.size() == 1 ? "" : "s"));
        }
        if (deviceScrollView != null)
            deviceScrollView.post(() -> deviceScrollView.fullScroll(android.view.View.FOCUS_DOWN));
    }

    private android.view.View buildDeviceRow(String display, String ipPort, String proto, String ts, String appLabel) {
        android.widget.LinearLayout row = new android.widget.LinearLayout(this);
        row.setOrientation(android.widget.LinearLayout.VERTICAL);
        row.setPadding(8, 6, 8, 6);
        row.setBackgroundColor(android.graphics.Color.parseColor(
            deviceLogContainer.getChildCount() % 2 == 0 ? "#0A0E17" : "#0D1320"));

        // Line 1: app + protocol + timestamp
        android.widget.TextView header = new android.widget.TextView(this);
        header.setText((appLabel.isEmpty() ? "" : "[" + appLabel + "]  ") + proto + "  " + ts);
        header.setTextColor(android.graphics.Color.parseColor("#8899AA"));
        header.setTextSize(10);
        header.setTypeface(android.graphics.Typeface.MONOSPACE);

        // Line 2: resolved hostname or IP:port (cyan = resolved, white = raw IP)
        String rawIp = ipPort.contains(":") ? ipPort.split(":")[0] : ipPort;
        boolean resolved = !display.equals(rawIp);
        android.widget.TextView hostView = new android.widget.TextView(this);
        hostView.setText(resolved ? display : ipPort);
        hostView.setTextColor(android.graphics.Color.parseColor(resolved ? "#00E5FF" : "#FFFFFF"));
        hostView.setTextSize(13);
        hostView.setTypeface(android.graphics.Typeface.MONOSPACE);

        row.addView(header);
        row.addView(hostView);

        // Line 3: raw IP:port in yellow — only when hostname was resolved
        if (resolved) {
            android.widget.TextView ipView = new android.widget.TextView(this);
            ipView.setText(ipPort);
            ipView.setTextColor(android.graphics.Color.parseColor("#FFD600"));
            ipView.setTextSize(11);
            ipView.setTypeface(android.graphics.Typeface.MONOSPACE);
            row.addView(ipView);
        }

        // Divider
        android.view.View div = new android.view.View(this);
        div.setLayoutParams(new android.widget.LinearLayout.LayoutParams(
            android.view.ViewGroup.LayoutParams.MATCH_PARENT, 1));
        div.setBackgroundColor(android.graphics.Color.parseColor("#1C2333"));
        row.addView(div);

        // Long-press: Copy IP / Copy Hostname / WHOIS
        final String bareIp = rawIp;
        final String hostName = display;
        row.setOnLongClickListener(v -> {
            android.widget.PopupMenu pm2 = new android.widget.PopupMenu(this, v);
            pm2.getMenu().add(0, 0, 0, "📋 Copy IP");
            if (!hostName.equals(bareIp)) pm2.getMenu().add(0, 1, 1, "📋 Copy Hostname");
            pm2.getMenu().add(0, 2, 2, "🔍 IP WHOIS Lookup");
            pm2.setOnMenuItemClickListener(item -> {
                android.content.ClipboardManager cm =
                    (android.content.ClipboardManager) getSystemService(CLIPBOARD_SERVICE);
                switch (item.getItemId()) {
                    case 0:
                        cm.setPrimaryClip(android.content.ClipData.newPlainText("IP", bareIp));
                        android.widget.Toast.makeText(this, "IP copied", android.widget.Toast.LENGTH_SHORT).show();
                        return true;
                    case 1:
                        cm.setPrimaryClip(android.content.ClipData.newPlainText("Hostname", hostName));
                        android.widget.Toast.makeText(this, "Hostname copied", android.widget.Toast.LENGTH_SHORT).show();
                        return true;
                    case 2:
                        showIpWhois(bareIp, hostName);
                        return true;
                }
                return false;
            });
            pm2.show();
            return true;
        });

        return row;
    }

    private void showIpWhois(String ip, String hostname) {
        String title = hostname != null && !hostname.isEmpty() && !hostname.equals(ip)
            ? "WHOIS: " + hostname : "WHOIS: " + ip;
        android.widget.Toast.makeText(this, "Looking up " + ip + "...",
            android.widget.Toast.LENGTH_SHORT).show();
        executor.execute(() -> {
            try {
                java.net.URL url = new java.net.URL(IP_WHOIS_URL + "?ip=" + ip);
                java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
                conn.setConnectTimeout(8000);
                conn.setReadTimeout(8000);
                java.io.BufferedReader br = new java.io.BufferedReader(
                    new java.io.InputStreamReader(conn.getInputStream()));
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
                br.close();
                org.json.JSONObject j = new org.json.JSONObject(sb.toString());
                StringBuilder msg = new StringBuilder();
                if (j.has("org"))      msg.append("Org:     ").append(j.getString("org")).append("\n");
                if (j.has("asn"))      msg.append("ASN:     ").append(j.getString("asn"));
                if (j.has("asnName"))  msg.append(" (").append(j.getString("asnName")).append(")");
                if (j.has("asn"))      msg.append("\n");
                if (j.has("cidr"))     msg.append("CIDR:    ").append(j.getString("cidr")).append("\n");
                if (j.has("country"))  msg.append("Country: ").append(j.getString("country")).append("\n");
                if (j.has("netName"))  msg.append("Net:     ").append(j.getString("netName")).append("\n");
                if (j.has("abuse"))    msg.append("Abuse:   ").append(j.getString("abuse")).append("\n");
                if (msg.length() == 0) msg.append("No data returned.");
                final String result = msg.toString().trim();
                final String dlgTitle = title;
                runOnUiThread(() -> showInfoDialog(dlgTitle, result));
            } catch (Exception ex) {
                runOnUiThread(() -> android.widget.Toast.makeText(this,
                    "WHOIS failed: " + ex.getMessage(), android.widget.Toast.LENGTH_LONG).show());
            }
        });
    }

    private void exportDeviceLog() {
        try {
            java.io.File dir = new java.io.File(getExternalFilesDir(null), "NetWatch");
            if (!dir.exists()) dir.mkdirs();
            java.io.File file = new java.io.File(dir, "device_log_" +
                new java.text.SimpleDateFormat("yyyyMMdd_HHmmss",
                    java.util.Locale.US).format(new java.util.Date()) + ".csv");
            java.io.PrintWriter pw = new java.io.PrintWriter(new java.io.FileWriter(file));
            pw.println("timestamp,app,host,ip_port,protocol");
            synchronized (deviceLog) {
                for (String[] e : deviceLog)
                    pw.println(csv(e[4]) + "," + csv(e[5]) + "," + csv(e[0]) + "," + csv(e[2]) + "," + csv(e[3]));
            }
            pw.close();
            android.net.Uri uri = androidx.core.content.FileProvider.getUriForFile(
                this, getPackageName() + ".provider", file);
            android.content.Intent share = new android.content.Intent(android.content.Intent.ACTION_SEND);
            share.setType("text/csv");
            share.putExtra(android.content.Intent.EXTRA_STREAM, uri);
            share.addFlags(android.content.Intent.FLAG_GRANT_READ_URI_PERMISSION);
            startActivity(android.content.Intent.createChooser(share, isRussian ? "Экспорт журнала…" : "Export Device Log"));
        } catch (Exception e) {
            android.widget.Toast.makeText(this, "Export failed: " + e.getMessage(),
                android.widget.Toast.LENGTH_LONG).show();
        }
    }

    // ── Spinner Adapter ───────────────────────────────────────────────────────
    // Spinners (App picker, Speed Test server) use the platform's built-in
    // simple_spinner_item layout, whose default text color can be low-contrast
    // against our dark terminal UI. This adapter force-tints both the collapsed
    // selected-item view and the dropdown rows to the app's fixed light text color.
    private class ThemedArrayAdapter<T> extends ArrayAdapter<T> {
        ThemedArrayAdapter(java.util.List<T> items) {
            super(MainActivity.this, android.R.layout.simple_spinner_item, items);
            setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        }
        ThemedArrayAdapter(T[] items) {
            super(MainActivity.this, android.R.layout.simple_spinner_item, items);
            setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        }
        private void tint(View v) {
            if (v instanceof TextView) ((TextView) v).setTextColor(Color.parseColor("#E0E8F0"));
        }
        @Override public View getView(int position, View convertView, android.view.ViewGroup parent) {
            View v = super.getView(position, convertView, parent);
            tint(v);
            return v;
        }
        @Override public View getDropDownView(int position, View convertView, android.view.ViewGroup parent) {
            View v = super.getDropDownView(position, convertView, parent);
            tint(v);
            return v;
        }
    }
}