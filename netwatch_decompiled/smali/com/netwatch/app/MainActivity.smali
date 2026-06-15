.class public Lcom/netwatch/app/MainActivity;
.super Landroid/app/Activity;
.source "SourceFile"


# static fields
.field private static final CHECKER_DOMAINS:Ljava/util/LinkedHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/LinkedHashMap<",
            "Ljava/lang/String;",
            "[[",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private static final DOMAIN_INTEL_URL:Ljava/lang/String; = "https://superagent-cfb25b3e.base44.app/functions/domainIntel"

.field private static final NOTIF_PERM_CODE:I = 0x3ea

.field private static final PREFS_NAME:Ljava/lang/String; = "netwatch_prefs"

.field private static final PREF_LANG:Ljava/lang/String; = "language"

.field private static final SPEED_SERVERS:[[Ljava/lang/String;

.field private static final VPN_REQUEST_CODE:I = 0x3e9


# instance fields
.field private alertSwitch:Landroidx/appcompat/widget/SwitchCompat;

.field private alertsEnabled:Z

.field private appAdapter:Landroid/widget/ArrayAdapter;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/widget/ArrayAdapter<",
            "Lcom/netwatch/app/AppEntry;",
            ">;"
        }
    .end annotation
.end field

.field private appList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/netwatch/app/AppEntry;",
            ">;"
        }
    .end annotation
.end field

.field private appSpinner:Landroid/widget/Spinner;

.field private checkAllBtn:Landroid/widget/Button;

.field private checkCustomBtn:Landroid/widget/Button;

.field private checkResultsContainer:Landroid/widget/LinearLayout;

.field private final checkRunning:Ljava/util/concurrent/atomic/AtomicBoolean;

.field private checkStatusText:Landroid/widget/TextView;

.field private final checkerStatusViews:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Landroid/widget/TextView;",
            ">;"
        }
    .end annotation
.end field

.field private clearMonBtn:Landroid/widget/Button;

.field private connectionCountText:Landroid/widget/TextView;

.field private customDomainInput:Landroid/widget/EditText;

.field private deviceClearBtn:Landroid/widget/Button;

.field private deviceCountText:Landroid/widget/TextView;

.field private deviceExportBtn:Landroid/widget/Button;

.field private deviceHeaderRow:Landroid/widget/LinearLayout;

.field private final deviceLog:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "[",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private deviceLogContainer:Landroid/widget/LinearLayout;

.field private deviceMonRunning:Z

.field private deviceReceiver:Landroid/content/BroadcastReceiver;

.field private deviceScrollView:Landroid/widget/ScrollView;

.field private deviceStatusText:Landroid/widget/TextView;

.field private deviceTitleText:Landroid/widget/TextView;

.field private deviceToggleBtn:Landroid/widget/Button;

.field private domainInput:Landroid/widget/EditText;

.field private final executor:Ljava/util/concurrent/ExecutorService;

.field private exportDomainBtn:Landroid/widget/Button;

.field private exportTrafficBtn:Landroid/widget/Button;

.field private hostCount:I

.field private hostLogContainer:Landroid/widget/LinearLayout;

.field private hostLogScroll:Landroid/widget/ScrollView;

.field private isRussian:Z

.field private lastDomainForExport:Ljava/lang/String;

.field private lastIntelJsonForExport:Ljava/lang/String;

.field private lastKnownRx:J

.field private lastKnownRxRate:J

.field private lastKnownTx:J

.field private lastKnownTxRate:J

.field private lastProbeJsonForExport:Ljava/lang/String;

.field private liveHostsLabel:Landroid/widget/TextView;

.field private lookupBtn:Landroid/widget/Button;

.field private final mainHandler:Landroid/os/Handler;

.field private monStatusText:Landroid/widget/TextView;

.field private monitoredRootDomain:Ljava/lang/String;

.field private monitoring:Z

.field private myInfoContainer:Landroid/widget/LinearLayout;

.field private myInfoDescText:Landroid/widget/TextView;

.field private myInfoRefreshBtn:Landroid/widget/Button;

.field private myInfoTitleText:Landroid/widget/TextView;

.field private resultsContainer:Landroid/widget/LinearLayout;

.field private rxRateText:Landroid/widget/TextView;

.field private rxTotalText:Landroid/widget/TextView;

.field private final seenHosts:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private selectAppLabel:Landroid/widget/TextView;

.field private selectedApp:Lcom/netwatch/app/AppEntry;

.field private speedDescText:Landroid/widget/TextView;

.field private speedDownText:Landroid/widget/TextView;

.field private speedPingText:Landroid/widget/TextView;

.field private speedResultsContainer:Landroid/widget/LinearLayout;

.field private speedRunBtn:Landroid/widget/Button;

.field private speedRunning:Z

.field private speedServerSpinner:Landroid/widget/Spinner;

.field private speedStatusText:Landroid/widget/TextView;

.field private speedTitleText:Landroid/widget/TextView;

.field private speedUpText:Landroid/widget/TextView;

.field private startMonBtn:Landroid/widget/Button;

.field private statusText:Landroid/widget/TextView;

.field private stopCheckBtn:Landroid/widget/Button;

.field private stopMonBtn:Landroid/widget/Button;

.field private tab1:Landroid/view/View;

.field private tab2:Landroid/view/View;

.field private tab3:Landroid/widget/LinearLayout;

.field private tab4:Landroid/view/View;

.field private tab5:Landroid/widget/ScrollView;

.field private tab6:Landroid/view/View;

.field private tabCheckerBtn:Landroid/widget/Button;

.field private tabDeviceBtn:Landroid/widget/Button;

.field private tabDomainBtn:Landroid/widget/Button;

.field private tabMyInfoBtn:Landroid/widget/Button;

.field private tabSpeedBtn:Landroid/widget/Button;

.field private tabTrafficBtn:Landroid/widget/Button;

.field private final trafficLogForExport:Ljava/util/LinkedHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/LinkedHashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private trafficReceiver:Landroid/content/BroadcastReceiver;

.field private final trustedDomains:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private txRateText:Landroid/widget/TextView;

.field private txTotalText:Landroid/widget/TextView;


# direct methods
.method static constructor <clinit>()V
    .locals 15

    const/16 v0, 0x10

    new-array v0, v0, [[Ljava/lang/String;

    const-string v1, "\ud83c\uddfa\ud83c\uddf8 US East  (Linode Newark)"

    const-string v2, "http://speedtest.newark.linode.com"

    const-string v3, "linode"

    filled-new-array {v1, v2, v3}, [Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    aput-object v1, v0, v2

    const-string v1, "\ud83c\uddfa\ud83c\uddf8 US West  (Linode Fremont)"

    const-string v4, "http://speedtest.fremont.linode.com"

    filled-new-array {v1, v4, v3}, [Ljava/lang/String;

    move-result-object v1

    const/4 v4, 0x1

    aput-object v1, v0, v4

    const-string v1, "\ud83c\udde8\ud83c\udde6 Canada   (Linode Toronto)"

    const-string v5, "http://speedtest.toronto.linode.com"

    filled-new-array {v1, v5, v3}, [Ljava/lang/String;

    move-result-object v1

    const/4 v5, 0x2

    aput-object v1, v0, v5

    const-string v1, "\ud83c\uddec\ud83c\udde7 EU       (Linode London)"

    const-string v6, "http://speedtest.london.linode.com"

    filled-new-array {v1, v6, v3}, [Ljava/lang/String;

    move-result-object v1

    const/4 v6, 0x3

    aput-object v1, v0, v6

    const-string v1, "\ud83c\udde9\ud83c\uddea EU       (Linode Frankfurt)"

    const-string v7, "http://speedtest.frankfurt.linode.com"

    filled-new-array {v1, v7, v3}, [Ljava/lang/String;

    move-result-object v1

    const/4 v7, 0x4

    aput-object v1, v0, v7

    const-string v1, "\ud83c\uddf8\ud83c\uddec Asia     (Linode Singapore)"

    const-string v8, "http://speedtest.singapore.linode.com"

    filled-new-array {v1, v8, v3}, [Ljava/lang/String;

    move-result-object v1

    const/4 v8, 0x5

    aput-object v1, v0, v8

    const-string v1, "\ud83c\uddef\ud83c\uddf5 Asia     (Linode Tokyo)"

    const-string v9, "http://speedtest.tokyo2.linode.com"

    filled-new-array {v1, v9, v3}, [Ljava/lang/String;

    move-result-object v1

    const/4 v9, 0x6

    aput-object v1, v0, v9

    const-string v1, "\ud83c\uddfa\ud83c\uddf8 US NYC   (Ookla Armstrong)"

    const-string v10, "http://speedtest-ad-1.zoominternet.net:8080"

    const-string v11, "ookla"

    filled-new-array {v1, v10, v11}, [Ljava/lang/String;

    move-result-object v1

    const/4 v10, 0x7

    aput-object v1, v0, v10

    const-string v1, "\ud83c\uddfa\ud83c\uddf8 US LA    (Ookla GeoLinks)"

    const-string v12, "http://la-ookla.geolinks.com:8080"

    filled-new-array {v1, v12, v11}, [Ljava/lang/String;

    move-result-object v1

    const/16 v12, 0x8

    aput-object v1, v0, v12

    const-string v1, "\ud83c\uddfa\ud83c\uddf8 US Chicago (Ookla Highline)"

    const-string v13, "http://stchi.highlinefast.com:8080"

    filled-new-array {v1, v13, v11}, [Ljava/lang/String;

    move-result-object v1

    const/16 v13, 0x9

    aput-object v1, v0, v13

    const-string v1, "\ud83c\uddfa\ud83c\uddf8 US Dallas (Ookla Frontier)"

    const-string v14, "http://dallas.tx.speedtest.frontier.com:8080"

    filled-new-array {v1, v14, v11}, [Ljava/lang/String;

    move-result-object v1

    const/16 v14, 0xa

    aput-object v1, v0, v14

    const-string v1, "\ud83c\uddfa\ud83c\uddf8 US Miami  (Ookla BlueStream)"

    const-string v14, "http://speedtest03.bluestreamfiber.net:8080"

    filled-new-array {v1, v14, v11}, [Ljava/lang/String;

    move-result-object v1

    const/16 v14, 0xb

    aput-object v1, v0, v14

    const-string v1, "\ud83c\uddfa\ud83c\uddf8 US Seattle (Ookla Ziply)"

    const-string v14, "http://speedtest1-sttlwawb.as20055.net:8080"

    filled-new-array {v1, v14, v11}, [Ljava/lang/String;

    move-result-object v1

    const/16 v14, 0xc

    aput-object v1, v0, v14

    const-string v1, "\ud83c\uddfa\ud83c\uddf8 US Atlanta (Ookla Point)"

    const-string v14, "http://speedtest14.point-broadband.com:8080"

    filled-new-array {v1, v14, v11}, [Ljava/lang/String;

    move-result-object v1

    const/16 v11, 0xd

    aput-object v1, v0, v11

    const-string v1, "\ud83c\uddf7\ud83c\uddfa Russia   (MTS Moscow)"

    const-string v11, "http://speed.mts.ru"

    filled-new-array {v1, v11, v3}, [Ljava/lang/String;

    move-result-object v1

    const/16 v3, 0xe

    aput-object v1, v0, v3

    const-string v1, "https://speed.cloudflare.com"

    const-string v3, "cloudflare"

    const-string v11, "\ud83c\udf0d Global    (Cloudflare)"

    filled-new-array {v11, v1, v3}, [Ljava/lang/String;

    move-result-object v1

    const/16 v3, 0xf

    aput-object v1, v0, v3

    sput-object v0, Lcom/netwatch/app/MainActivity;->SPEED_SERVERS:[[Ljava/lang/String;

    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    sput-object v0, Lcom/netwatch/app/MainActivity;->CHECKER_DOMAINS:Ljava/util/LinkedHashMap;

    new-array v1, v10, [[Ljava/lang/String;

    const-string v3, "Google Search"

    const-string v11, "google.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v2

    const-string v3, "Google DNS"

    const-string v11, "8.8.8.8"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v4

    const-string v3, "Gmail"

    const-string v11, "mail.google.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v5

    const-string v3, "Google Drive"

    const-string v11, "drive.google.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v6

    const-string v3, "YouTube"

    const-string v11, "youtube.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v7

    const-string v3, "Google Play"

    const-string v11, "play.google.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v8

    const-string v3, "Google APIs"

    const-string v11, "googleapis.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v9

    const-string v3, "\ud83d\udd35 Google"

    invoke-virtual {v0, v3, v1}, Ljava/util/AbstractMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    new-array v1, v10, [[Ljava/lang/String;

    const-string v3, "Bing"

    const-string v11, "bing.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v2

    const-string v3, "Outlook / Exchange"

    const-string v11, "outlook.office365.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v4

    const-string v3, "OneDrive"

    const-string v11, "onedrive.live.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v5

    const-string v3, "Teams"

    const-string v11, "teams.microsoft.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v6

    const-string v3, "Azure"

    const-string v11, "azure.microsoft.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v7

    const-string v3, "GitHub"

    const-string v11, "github.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v8

    const-string v3, "Microsoft CDN"

    const-string v11, "msftconnecttest.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v9

    const-string v3, "\ud83d\udfe0 Microsoft"

    invoke-virtual {v0, v3, v1}, Ljava/util/AbstractMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    new-array v1, v7, [[Ljava/lang/String;

    const-string v3, "Cloudflare DNS 1"

    const-string v11, "1.1.1.1"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v2

    const-string v3, "Cloudflare DNS 2"

    const-string v11, "1.0.0.1"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v4

    const-string v3, "Cloudflare Web"

    const-string v11, "cloudflare.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v5

    const-string v3, "WARP / DoH"

    const-string v11, "cloudflare-dns.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v6

    const-string v3, "\ud83d\udfe1 Cloudflare"

    invoke-virtual {v0, v3, v1}, Ljava/util/AbstractMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    new-array v1, v13, [[Ljava/lang/String;

    const-string v3, "Facebook"

    const-string v11, "facebook.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v2

    const-string v3, "Instagram"

    const-string v11, "instagram.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v4

    const-string v3, "WhatsApp"

    const-string v11, "web.whatsapp.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v5

    const-string v3, "Twitter / X"

    const-string v11, "x.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v6

    const-string v3, "Telegram"

    const-string v11, "telegram.org"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v7

    const-string v3, "LinkedIn"

    const-string v11, "linkedin.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v8

    const-string v3, "TikTok"

    const-string v11, "tiktok.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v9

    const-string v3, "Reddit"

    const-string v11, "reddit.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v10

    const-string v3, "Disqus"

    const-string v11, "disqus.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v12

    const-string v3, "\ud83d\udfe3 Social & Messaging"

    invoke-virtual {v0, v3, v1}, Ljava/util/AbstractMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    new-array v1, v7, [[Ljava/lang/String;

    const-string v3, "Netflix"

    const-string v11, "netflix.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v2

    const-string v3, "Spotify"

    const-string v11, "spotify.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v4

    const-string v3, "Twitch"

    const-string v11, "twitch.tv"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v5

    const-string v3, "Apple iCloud"

    const-string v11, "icloud.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v6

    const-string v3, "\ud83d\udd34 Streaming"

    invoke-virtual {v0, v3, v1}, Ljava/util/AbstractMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    new-array v1, v8, [[Ljava/lang/String;

    const-string v3, "Akamai"

    const-string v11, "akamai.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v2

    const-string v3, "Fastly"

    const-string v11, "fastly.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v4

    const-string v3, "Amazon AWS"

    const-string v11, "aws.amazon.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v5

    const-string v3, "Quad9 DNS"

    const-string v11, "9.9.9.9"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v6

    const-string v3, "OpenDNS"

    const-string v11, "208.67.222.222"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v7

    const-string v3, "\ud83d\udfe2 CDN / Infrastructure"

    invoke-virtual {v0, v3, v1}, Ljava/util/AbstractMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    new-array v1, v10, [[Ljava/lang/String;

    const-string v3, "PayPal"

    const-string v11, "paypal.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v2

    const-string v3, "Stripe"

    const-string v11, "stripe.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v4

    const-string v3, "Visa"

    const-string v11, "visa.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v5

    const-string v3, "Mastercard"

    const-string v11, "mastercard.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v6

    const-string v3, "Wise"

    const-string v11, "wise.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v7

    const-string v3, "Tangem"

    const-string v11, "tangem.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v8

    const-string v3, "Bitcoin"

    const-string v11, "bitcoin.org"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v9

    const-string v3, "\ud83c\udfe6 Finance & Payments"

    invoke-virtual {v0, v3, v1}, Ljava/util/AbstractMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    new-array v1, v13, [[Ljava/lang/String;

    const-string v3, "Xbox Live"

    const-string v11, "xbox.com"

    filled-new-array {v3, v11}, [Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v2

    const-string v2, "Xbox Services"

    const-string v3, "xboxlive.com"

    filled-new-array {v2, v3}, [Ljava/lang/String;

    move-result-object v2

    aput-object v2, v1, v4

    const-string v2, "Xbox CDN"

    const-string v3, "xboxlive-ce-retail.com"

    filled-new-array {v2, v3}, [Ljava/lang/String;

    move-result-object v2

    aput-object v2, v1, v5

    const-string v2, "Microsoft Game"

    const-string v3, "xgweb.com"

    filled-new-array {v2, v3}, [Ljava/lang/String;

    move-result-object v2

    aput-object v2, v1, v6

    const-string v2, "PlayStation"

    const-string v3, "playstation.com"

    filled-new-array {v2, v3}, [Ljava/lang/String;

    move-result-object v2

    aput-object v2, v1, v7

    const-string v2, "PSN Network"

    const-string v3, "psn.np.com"

    filled-new-array {v2, v3}, [Ljava/lang/String;

    move-result-object v2

    aput-object v2, v1, v8

    const-string v2, "PS Store"

    const-string v3, "store.playstation.com"

    filled-new-array {v2, v3}, [Ljava/lang/String;

    move-result-object v2

    aput-object v2, v1, v9

    const-string v2, "PS CDN"

    const-string v3, "dl.playstation.net"

    filled-new-array {v2, v3}, [Ljava/lang/String;

    move-result-object v2

    aput-object v2, v1, v10

    const-string v2, "PS Auth"

    const-string v3, "auth.api.sonyentertainmentnetwork.com"

    filled-new-array {v2, v3}, [Ljava/lang/String;

    move-result-object v2

    aput-object v2, v1, v12

    const-string v2, "\ud83c\udfae Gaming"

    invoke-virtual {v0, v2, v1}, Ljava/util/AbstractMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method public constructor <init>()V
    .locals 4

    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/netwatch/app/MainActivity;->deviceMonRunning:Z

    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p0, Lcom/netwatch/app/MainActivity;->deviceLog:Ljava/util/ArrayList;

    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p0, Lcom/netwatch/app/MainActivity;->appList:Ljava/util/List;

    const/4 v1, 0x0

    iput-object v1, p0, Lcom/netwatch/app/MainActivity;->selectedApp:Lcom/netwatch/app/AppEntry;

    iput-boolean v0, p0, Lcom/netwatch/app/MainActivity;->monitoring:Z

    iput v0, p0, Lcom/netwatch/app/MainActivity;->hostCount:I

    new-instance v1, Ljava/util/HashSet;

    invoke-direct {v1}, Ljava/util/HashSet;-><init>()V

    iput-object v1, p0, Lcom/netwatch/app/MainActivity;->seenHosts:Ljava/util/Set;

    new-instance v1, Ljava/util/LinkedHashMap;

    invoke-direct {v1}, Ljava/util/LinkedHashMap;-><init>()V

    iput-object v1, p0, Lcom/netwatch/app/MainActivity;->trafficLogForExport:Ljava/util/LinkedHashMap;

    const-string v1, ""

    iput-object v1, p0, Lcom/netwatch/app/MainActivity;->lastDomainForExport:Ljava/lang/String;

    iput-object v1, p0, Lcom/netwatch/app/MainActivity;->lastIntelJsonForExport:Ljava/lang/String;

    iput-object v1, p0, Lcom/netwatch/app/MainActivity;->lastProbeJsonForExport:Ljava/lang/String;

    iput-boolean v0, p0, Lcom/netwatch/app/MainActivity;->speedRunning:Z

    const/4 v2, 0x1

    iput-boolean v2, p0, Lcom/netwatch/app/MainActivity;->alertsEnabled:Z

    new-instance v2, Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-direct {v2, v0}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V

    iput-object v2, p0, Lcom/netwatch/app/MainActivity;->checkRunning:Ljava/util/concurrent/atomic/AtomicBoolean;

    const-wide/16 v2, -0x1

    iput-wide v2, p0, Lcom/netwatch/app/MainActivity;->lastKnownTx:J

    iput-wide v2, p0, Lcom/netwatch/app/MainActivity;->lastKnownRx:J

    const-wide/16 v2, 0x0

    iput-wide v2, p0, Lcom/netwatch/app/MainActivity;->lastKnownTxRate:J

    iput-wide v2, p0, Lcom/netwatch/app/MainActivity;->lastKnownRxRate:J

    new-instance v2, Ljava/util/HashSet;

    invoke-direct {v2}, Ljava/util/HashSet;-><init>()V

    invoke-static {v2}, Ljava/util/Collections;->synchronizedSet(Ljava/util/Set;)Ljava/util/Set;

    move-result-object v2

    iput-object v2, p0, Lcom/netwatch/app/MainActivity;->trustedDomains:Ljava/util/Set;

    iput-object v1, p0, Lcom/netwatch/app/MainActivity;->monitoredRootDomain:Ljava/lang/String;

    iput-boolean v0, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    invoke-static {}, Ljava/util/concurrent/Executors;->newCachedThreadPool()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    iput-object v0, p0, Lcom/netwatch/app/MainActivity;->executor:Ljava/util/concurrent/ExecutorService;

    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/netwatch/app/MainActivity;->mainHandler:Landroid/os/Handler;

    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    iput-object v0, p0, Lcom/netwatch/app/MainActivity;->checkerStatusViews:Ljava/util/Map;

    return-void
.end method

.method public static synthetic A(Lcom/netwatch/app/MainActivity;Ljava/lang/String;ZJ)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/netwatch/app/MainActivity;->lambda$startDomainCheck$40(Ljava/lang/String;ZJ)V

    return-void
.end method

.method public static synthetic B(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$0(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic C(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$23(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic D(Lcom/netwatch/app/MainActivity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    invoke-direct/range {p0 .. p12}, Lcom/netwatch/app/MainActivity;->lambda$lookupMyInfo$37(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic E(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$14(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic F(Lcom/netwatch/app/MainActivity;Landroid/view/MenuItem;)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$showMainMenu$24(Landroid/view/MenuItem;)Z

    move-result p0

    return p0
.end method

.method public static synthetic G(Lcom/netwatch/app/MainActivity;Landroid/content/DialogInterface;I)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/netwatch/app/MainActivity;->lambda$showLanguageDialog$25(Landroid/content/DialogInterface;I)V

    return-void
.end method

.method public static synthetic H(Lcom/netwatch/app/MainActivity;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/netwatch/app/MainActivity;->lambda$performLookup$32(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic I(Lcom/netwatch/app/MainActivity;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->lambda$loadAppList$28()V

    return-void
.end method

.method public static synthetic J(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$1(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic K(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$5(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic L(Lcom/netwatch/app/MainActivity;Ljava/lang/String;ZZLjava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/netwatch/app/MainActivity;->lambda$runSpeedTest$46(Ljava/lang/String;ZZLjava/lang/String;)V

    return-void
.end method

.method public static synthetic M(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$13(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic N(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$22(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic O(Lcom/netwatch/app/MainActivity;Landroid/content/SharedPreferences;Landroid/widget/CompoundButton;Z)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$16(Landroid/content/SharedPreferences;Landroid/widget/CompoundButton;Z)V

    return-void
.end method

.method public static synthetic P(Lcom/netwatch/app/MainActivity;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->lambda$loadAppList$27()V

    return-void
.end method

.method public static synthetic Q(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$4(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic R(Lcom/netwatch/app/MainActivity;ILjava/util/List;II)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/netwatch/app/MainActivity;->lambda$startDomainCheck$41(ILjava/util/List;II)V

    return-void
.end method

.method public static synthetic S(Lcom/netwatch/app/MainActivity;Ljava/lang/String;Landroid/widget/LinearLayout;Landroid/widget/TextView;ZLandroid/widget/TextView;Landroid/widget/TextView;Landroid/widget/Button;Landroid/view/View;)V
    .locals 0

    invoke-direct/range {p0 .. p8}, Lcom/netwatch/app/MainActivity;->lambda$addHostRow$30(Ljava/lang/String;Landroid/widget/LinearLayout;Landroid/widget/TextView;ZLandroid/widget/TextView;Landroid/widget/TextView;Landroid/widget/Button;Landroid/view/View;)V

    return-void
.end method

.method public static synthetic T(Lcom/netwatch/app/MainActivity;Ljava/lang/String;Landroid/widget/TextView;Landroid/widget/TextView;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/netwatch/app/MainActivity;->lambda$checkCustomDomain$44(Ljava/lang/String;Landroid/widget/TextView;Landroid/widget/TextView;)V

    return-void
.end method

.method public static synthetic U(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$12(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic V(Lcom/netwatch/app/MainActivity;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->lambda$updateStats$29()V

    return-void
.end method

.method public static bridge synthetic W(Lcom/netwatch/app/MainActivity;)Ljava/util/List;
    .locals 0

    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->appList:Ljava/util/List;

    return-object p0
.end method

.method public static bridge synthetic X(Lcom/netwatch/app/MainActivity;)Landroid/widget/Spinner;
    .locals 0

    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->appSpinner:Landroid/widget/Spinner;

    return-object p0
.end method

.method public static bridge synthetic Y(Lcom/netwatch/app/MainActivity;)Ljava/util/ArrayList;
    .locals 0

    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->deviceLog:Ljava/util/ArrayList;

    return-object p0
.end method

.method public static bridge synthetic Z(Lcom/netwatch/app/MainActivity;)Landroid/os/Handler;
    .locals 0

    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->mainHandler:Landroid/os/Handler;

    return-object p0
.end method

.method public static synthetic a(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$9(Landroid/view/View;)V

    return-void
.end method

.method public static bridge synthetic a0(Lcom/netwatch/app/MainActivity;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/netwatch/app/MainActivity;->monitoring:Z

    return p0
.end method

.method private addCard(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 3

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->makeCardContainer()Landroid/widget/LinearLayout;

    move-result-object v0

    new-instance v1, Landroid/widget/TextView;

    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {p1}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 p1, 0x41300000    # 11.0f

    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setTextSize(F)V

    const-string p1, "#00E5FF"

    invoke-static {p1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p1

    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 p1, 0x0

    const/4 v2, 0x1

    invoke-virtual {v1, p1, v2}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;I)V

    const/4 p1, 0x5

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result p1

    const/4 v2, 0x0

    invoke-virtual {v1, v2, v2, v2, p1}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance p1, Landroid/widget/TextView;

    invoke-direct {p1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 p2, 0x41600000    # 14.0f

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setTextSize(F)V

    :try_start_0
    invoke-static {p3}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p2

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setTextColor(I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    const/4 p2, -0x1

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setTextColor(I)V

    :goto_0
    sget-object p2, Landroid/graphics/Typeface;->MONOSPACE:Landroid/graphics/Typeface;

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    invoke-virtual {v0, p1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->resultsContainer:Landroid/widget/LinearLayout;

    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    return-void
.end method

.method private addHostRow(Ljava/lang/String;ZLjava/lang/String;)V
    .locals 16

    move-object/from16 v9, p0

    move-object/from16 v2, p1

    const-string v0, "\\d+\\.\\d+\\.\\d+\\.\\d+.*"

    invoke-virtual {v2, v0}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v0

    const/4 v10, 0x1

    const/4 v1, 0x0

    if-nez v0, :cond_1

    const-string v0, ":"

    invoke-virtual {v2, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    move v0, v1

    goto :goto_1

    :cond_1
    :goto_0
    move v0, v10

    :goto_1
    iget-boolean v3, v9, Lcom/netwatch/app/MainActivity;->alertsEnabled:Z

    if-eqz v3, :cond_2

    if-nez v0, :cond_2

    invoke-direct/range {p0 .. p1}, Lcom/netwatch/app/MainActivity;->isTrustedHost(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_2

    move v11, v10

    goto :goto_2

    :cond_2
    move v11, v1

    :goto_2
    if-eqz v11, :cond_3

    invoke-direct/range {p0 .. p1}, Lcom/netwatch/app/MainActivity;->fireAlert(Ljava/lang/String;)V

    :cond_3
    new-instance v12, Landroid/widget/LinearLayout;

    invoke-direct {v12, v9}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    invoke-virtual {v12, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/4 v3, 0x6

    invoke-direct {v9, v3}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v4

    invoke-direct {v9, v3}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v5

    invoke-direct {v9, v3}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v6

    invoke-direct {v9, v3}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v7

    invoke-virtual {v12, v4, v5, v6, v7}, Landroid/view/View;->setPadding(IIII)V

    if-eqz v11, :cond_4

    const-string v4, "#1A2A1A"

    invoke-static {v4}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v4

    invoke-virtual {v12, v4}, Landroid/view/View;->setBackgroundColor(I)V

    :cond_4
    new-instance v4, Landroid/widget/TextView;

    invoke-direct {v4, v9}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    if-eqz p2, :cond_5

    const-string v5, "\u25cf  "

    goto :goto_3

    :cond_5
    const-string v5, "\u25cb  "

    :goto_3
    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v5, 0x41500000    # 13.0f

    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setTextSize(F)V

    const-string v13, "#FF5252"

    if-eqz v11, :cond_6

    move-object v6, v13

    goto :goto_4

    :cond_6
    if-eqz p2, :cond_7

    const-string v6, "#66BB6A"

    goto :goto_4

    :cond_7
    const-string v6, "#546E7A"

    :goto_4
    invoke-static {v6}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v6

    invoke-virtual {v4, v6}, Landroid/widget/TextView;->setTextColor(I)V

    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v7, 0x1a

    invoke-direct {v9, v7}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v7

    const/4 v14, -0x2

    invoke-direct {v6, v7, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v4, v6}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v12, v4}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v6, Landroid/widget/TextView;

    invoke-direct {v6, v9}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v6, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    if-eqz v0, :cond_8

    const/high16 v7, 0x41400000    # 12.0f

    goto :goto_5

    :cond_8
    const/high16 v7, 0x41600000    # 14.0f

    :goto_5
    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setTextSize(F)V

    if-eqz v11, :cond_9

    const-string v7, "#FF8A80"

    goto :goto_6

    :cond_9
    if-eqz v0, :cond_a

    const-string v7, "#90A4AE"

    goto :goto_6

    :cond_a
    const-string v7, "#C8D8E8"

    :goto_6
    invoke-static {v7}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v7

    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setTextColor(I)V

    sget-object v7, Landroid/graphics/Typeface;->MONOSPACE:Landroid/graphics/Typeface;

    xor-int/2addr v0, v10

    invoke-virtual {v6, v7, v0}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;I)V

    new-instance v0, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v0, v1, v14, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v6, v0}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    sget-object v0, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;

    invoke-virtual {v6, v0}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V

    invoke-virtual {v6, v10}, Landroid/widget/TextView;->setSingleLine(Z)V

    invoke-virtual {v12, v6}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    const/4 v15, -0x1

    if-eqz v11, :cond_b

    new-instance v7, Landroid/widget/TextView;

    invoke-direct {v7, v9}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v0, "\u26a0"

    invoke-virtual {v7, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-virtual {v7, v5}, Landroid/widget/TextView;->setTextSize(F)V

    invoke-static {v13}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v0

    invoke-virtual {v7, v0}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v0, 0x4

    invoke-direct {v9, v0}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v5

    invoke-direct {v9, v0}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v0

    invoke-virtual {v7, v5, v1, v0, v1}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v12, v7}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v8, Landroid/widget/Button;

    invoke-direct {v8, v9}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v0, "\u2713"

    invoke-virtual {v8, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v0, 0x41300000    # 11.0f

    invoke-virtual {v8, v0}, Landroid/widget/TextView;->setTextSize(F)V

    invoke-virtual {v8, v15}, Landroid/widget/TextView;->setTextColor(I)V

    invoke-direct {v9, v3}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v0

    invoke-direct {v9, v3}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v3

    invoke-virtual {v8, v0, v1, v3, v1}, Landroid/view/View;->setPadding(IIII)V

    new-instance v0, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v3, 0x24

    invoke-direct {v9, v3}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v3

    const/16 v5, 0x1c

    invoke-direct {v9, v5}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v5

    invoke-direct {v0, v3, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/4 v3, 0x2

    invoke-direct {v9, v3}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v3

    invoke-virtual {v0, v3, v1, v1, v1}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    invoke-virtual {v8, v0}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    const-string v0, "#2E7D32"

    invoke-static {v0}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v0

    invoke-virtual {v8, v0}, Landroid/view/View;->setBackgroundColor(I)V

    new-instance v5, Lcom/netwatch/app/f;

    move-object v0, v5

    move-object/from16 v1, p0

    move-object/from16 v2, p1

    move-object v3, v12

    move-object v10, v5

    move/from16 v5, p2

    move-object/from16 p1, v8

    invoke-direct/range {v0 .. v8}, Lcom/netwatch/app/f;-><init>(Lcom/netwatch/app/MainActivity;Ljava/lang/String;Landroid/widget/LinearLayout;Landroid/widget/TextView;ZLandroid/widget/TextView;Landroid/widget/TextView;Landroid/widget/Button;)V

    move-object/from16 v0, p1

    invoke-virtual {v0, v10}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-virtual {v12, v0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    :cond_b
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, v9}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    move-object/from16 v1, p3

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v1, 0x41200000    # 10.0f

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextSize(F)V

    const-string v1, "#37474F"

    invoke-static {v1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v2, 0x2e

    invoke-direct {v9, v2}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v2

    invoke-direct {v1, v2, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    const v1, 0x800005

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setGravity(I)V

    invoke-virtual {v12, v0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v0, Landroid/view/View;

    invoke-direct {v0, v9}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v2, 0x1

    invoke-direct {v1, v15, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    if-eqz v11, :cond_c

    goto :goto_7

    :cond_c
    const-string v13, "#0D2137"

    :goto_7
    invoke-static {v13}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/view/View;->setBackgroundColor(I)V

    iget-object v1, v9, Lcom/netwatch/app/MainActivity;->hostLogContainer:Landroid/widget/LinearLayout;

    invoke-virtual {v1, v12}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    iget-object v1, v9, Lcom/netwatch/app/MainActivity;->hostLogContainer:Landroid/widget/LinearLayout;

    invoke-virtual {v1, v0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    return-void
.end method

.method private addMyInfoCard(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 4

    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    invoke-static {p3}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p3

    invoke-virtual {v0, p3}, Landroid/view/View;->setBackgroundColor(I)V

    new-instance p3, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v2, -0x1

    const/4 v3, -0x2

    invoke-direct {p3, v2, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/16 v2, 0xc

    const/4 v3, 0x0

    invoke-virtual {p3, v3, v3, v3, v2}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    invoke-virtual {v0, p3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    const/16 p3, 0x1c

    const/16 v2, 0x14

    invoke-virtual {v0, p3, v2, p3, v2}, Landroid/view/View;->setPadding(IIII)V

    new-instance p3, Landroid/widget/TextView;

    invoke-direct {p3, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {p3, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {p4}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p1

    invoke-virtual {p3, p1}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 p1, 0x41500000    # 13.0f

    invoke-virtual {p3, p1}, Landroid/widget/TextView;->setTextSize(F)V

    const/4 p1, 0x0

    invoke-virtual {p3, p1, v1}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;I)V

    const/16 p1, 0xa

    invoke-virtual {p3, v3, v3, v3, p1}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v0, p3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance p1, Landroid/widget/TextView;

    invoke-direct {p1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const p2, -0x1f1f20

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 p2, 0x41600000    # 14.0f

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setTextSize(F)V

    sget-object p2, Landroid/graphics/Typeface;->MONOSPACE:Landroid/graphics/Typeface;

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    invoke-virtual {v0, p1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->myInfoContainer:Landroid/widget/LinearLayout;

    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    return-void
.end method

.method private addMyInfoRow(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    new-instance p2, Landroid/widget/TextView;

    invoke-direct {p2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {p2, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const p1, -0x4f413b

    invoke-virtual {p2, p1}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 p1, 0x41500000    # 13.0f

    invoke-virtual {p2, p1}, Landroid/widget/TextView;->setTextSize(F)V

    const/16 p1, 0xc

    const/16 p3, 0x8

    invoke-virtual {p2, p1, p3, p1, p3}, Landroid/widget/TextView;->setPadding(IIII)V

    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->myInfoContainer:Landroid/widget/LinearLayout;

    invoke-virtual {p0, p2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    return-void
.end method

.method private addSubdomainsCard(Lorg/json/JSONArray;)V
    .locals 10

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->makeCardContainer()Landroid/widget/LinearLayout;

    move-result-object v0

    new-instance v1, Landroid/widget/TextView;

    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "\ud83c\udf3f  SUBDOMAINS  ("

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1}, Lorg/json/JSONArray;->length()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, ")"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v2, 0x41300000    # 11.0f

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextSize(F)V

    const-string v2, "#00E5FF"

    invoke-static {v2}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v2

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v2, 0x0

    const/4 v3, 0x1

    invoke-virtual {v1, v2, v3}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;I)V

    const/4 v2, 0x6

    invoke-direct {p0, v2}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v2

    const/4 v4, 0x0

    invoke-virtual {v1, v4, v4, v4, v2}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    move v1, v4

    :goto_0
    :try_start_0
    invoke-virtual {p1}, Lorg/json/JSONArray;->length()I

    move-result v2

    if-ge v1, v2, :cond_5

    invoke-virtual {p1, v1}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v2

    const-string v5, "name"

    const-string v6, ""

    invoke-virtual {v2, v5, v6}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    const-string v6, "ips"

    invoke-virtual {v2, v6}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v2

    new-instance v6, Landroid/widget/TextView;

    invoke-direct {v6, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "\u25b8  "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v6, v5}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v5, 0x41600000    # 14.0f

    invoke-virtual {v6, v5}, Landroid/widget/TextView;->setTextSize(F)V

    const-string v5, "#80DEEA"

    invoke-static {v5}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v5

    invoke-virtual {v6, v5}, Landroid/widget/TextView;->setTextColor(I)V

    sget-object v5, Landroid/graphics/Typeface;->MONOSPACE:Landroid/graphics/Typeface;

    invoke-virtual {v6, v5}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    const/4 v5, 0x4

    invoke-direct {p0, v5}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v7

    invoke-virtual {v6, v4, v7, v4, v4}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v0, v6}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    if-eqz v2, :cond_3

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    move v7, v4

    :goto_1
    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v8

    if-ge v7, v8, :cond_2

    invoke-virtual {v2, v7}, Lorg/json/JSONArray;->optString(I)Ljava/lang/String;

    move-result-object v8

    const-string v9, "\\d+\\.\\d+\\.\\d+\\.\\d+"

    invoke-virtual {v8, v9}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v9

    if-eqz v9, :cond_1

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->length()I

    move-result v9

    if-lez v9, :cond_0

    const-string v9, "  |  "

    invoke-virtual {v6, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_0
    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_1
    add-int/lit8 v7, v7, 0x1

    goto :goto_1

    :cond_2
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->length()I

    move-result v2

    if-lez v2, :cond_3

    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "   "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v2, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v6, 0x41400000    # 12.0f

    invoke-virtual {v2, v6}, Landroid/widget/TextView;->setTextSize(F)V

    const-string v6, "#90A4AE"

    invoke-static {v6}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v6

    invoke-virtual {v2, v6}, Landroid/widget/TextView;->setTextColor(I)V

    sget-object v6, Landroid/graphics/Typeface;->MONOSPACE:Landroid/graphics/Typeface;

    invoke-virtual {v2, v6}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    :cond_3
    invoke-virtual {p1}, Lorg/json/JSONArray;->length()I

    move-result v2

    sub-int/2addr v2, v3

    if-ge v1, v2, :cond_4

    new-instance v2, Landroid/view/View;

    invoke-direct {v2, p0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v7, -0x1

    invoke-direct {v6, v7, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-direct {p0, v5}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v5

    iput v5, v6, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    const/4 v5, 0x2

    invoke-direct {p0, v5}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v5

    iput v5, v6, Landroid/widget/LinearLayout$LayoutParams;->bottomMargin:I

    invoke-virtual {v2, v6}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    const-string v5, "#1A3A5C"

    invoke-static {v5}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v5

    invoke-virtual {v2, v5}, Landroid/view/View;->setBackgroundColor(I)V

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :cond_4
    add-int/lit8 v1, v1, 0x1

    goto/16 :goto_0

    :catch_0
    :cond_5
    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->resultsContainer:Landroid/widget/LinearLayout;

    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic b(Lcom/netwatch/app/MainActivity;Landroid/widget/TextView;ILandroid/view/KeyEvent;)Z
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$6(Landroid/widget/TextView;ILandroid/view/KeyEvent;)Z

    move-result p0

    return p0
.end method

.method public static bridge synthetic b0(Lcom/netwatch/app/MainActivity;)Lcom/netwatch/app/AppEntry;
    .locals 0

    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->selectedApp:Lcom/netwatch/app/AppEntry;

    return-object p0
.end method

.method private buildCheckerRows()V
    .locals 16

    move-object/from16 v0, p0

    iget-object v1, v0, Lcom/netwatch/app/MainActivity;->checkResultsContainer:Landroid/widget/LinearLayout;

    invoke-virtual {v1}, Landroid/view/ViewGroup;->removeAllViews()V

    iget-object v1, v0, Lcom/netwatch/app/MainActivity;->checkerStatusViews:Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->clear()V

    sget-object v1, Lcom/netwatch/app/MainActivity;->CHECKER_DOMAINS:Ljava/util/LinkedHashMap;

    invoke-virtual {v1}, Ljava/util/LinkedHashMap;->entrySet()Ljava/util/Set;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/util/Map$Entry;

    new-instance v3, Landroid/widget/TextView;

    invoke-direct {v3, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-interface {v2}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/CharSequence;

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const-string v4, "#00E5FF"

    invoke-static {v4}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v4

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v4, 0x41400000    # 12.0f

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextSize(F)V

    const/4 v5, 0x0

    const/4 v6, 0x1

    invoke-virtual {v3, v5, v6}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;I)V

    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v7, -0x1

    const/4 v8, -0x2

    invoke-direct {v5, v7, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/16 v9, 0xa

    invoke-direct {v0, v9}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v10

    const/4 v11, 0x4

    invoke-direct {v0, v11}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v11

    const/4 v12, 0x0

    invoke-virtual {v5, v12, v10, v12, v11}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    invoke-virtual {v3, v5}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v3, v6}, Landroid/widget/TextView;->setAllCaps(Z)V

    iget-object v5, v0, Lcom/netwatch/app/MainActivity;->checkResultsContainer:Landroid/widget/LinearLayout;

    invoke-virtual {v5, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    invoke-interface {v2}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, [[Ljava/lang/String;

    array-length v3, v2

    move v5, v12

    :goto_0
    if-ge v5, v3, :cond_0

    aget-object v10, v2, v5

    aget-object v11, v10, v12

    aget-object v10, v10, v6

    new-instance v13, Landroid/widget/LinearLayout;

    invoke-direct {v13, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    invoke-virtual {v13, v12}, Landroid/widget/LinearLayout;->setOrientation(I)V

    sget v14, Lcom/netwatch/app/R$drawable;->card_background:I

    invoke-virtual {v0, v14}, Landroid/content/Context;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v14

    invoke-virtual {v13, v14}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    new-instance v14, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v14, v7, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/4 v15, 0x2

    invoke-direct {v0, v15}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v7

    invoke-direct {v0, v15}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v15

    invoke-virtual {v14, v12, v7, v12, v15}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    invoke-virtual {v13, v14}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-direct {v0, v9}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v7

    const/16 v14, 0x8

    invoke-direct {v0, v14}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v15

    invoke-direct {v0, v9}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v4

    invoke-direct {v0, v14}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v14

    invoke-virtual {v13, v7, v15, v4, v14}, Landroid/view/View;->setPadding(IIII)V

    new-instance v4, Landroid/widget/TextView;

    invoke-direct {v4, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v7, "\u25cf"

    invoke-virtual {v4, v7}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const-string v7, "#546E7A"

    invoke-static {v7}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v14

    invoke-virtual {v4, v14}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v14, 0x41600000    # 14.0f

    invoke-virtual {v4, v14}, Landroid/widget/TextView;->setTextSize(F)V

    invoke-direct {v0, v9}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v14

    invoke-virtual {v4, v12, v12, v14, v12}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v13, v4}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v14, Landroid/widget/LinearLayout;

    invoke-direct {v14, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    invoke-virtual {v14, v6}, Landroid/widget/LinearLayout;->setOrientation(I)V

    new-instance v15, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v6, 0x3f800000    # 1.0f

    invoke-direct {v15, v12, v8, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v14, v15}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v6, Landroid/widget/TextView;

    invoke-direct {v6, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v6, v11}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const-string v11, "#C8D8E8"

    invoke-static {v11}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v11

    invoke-virtual {v6, v11}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v11, 0x41500000    # 13.0f

    invoke-virtual {v6, v11}, Landroid/widget/TextView;->setTextSize(F)V

    new-instance v11, Landroid/widget/TextView;

    invoke-direct {v11, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v11, v10}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const-string v15, "#607D8B"

    invoke-static {v15}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v15

    invoke-virtual {v11, v15}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v15, 0x41300000    # 11.0f

    invoke-virtual {v11, v15}, Landroid/widget/TextView;->setTextSize(F)V

    invoke-virtual {v14, v6}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    invoke-virtual {v14, v11}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    invoke-virtual {v13, v14}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v6, Landroid/widget/TextView;

    invoke-direct {v6, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v11, "\u2014"

    invoke-virtual {v6, v11}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {v7}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v7

    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v7, 0x41400000    # 12.0f

    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setTextSize(F)V

    const v11, 0x800015

    invoke-virtual {v6, v11}, Landroid/widget/TextView;->setGravity(I)V

    invoke-virtual {v13, v6}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    iget-object v11, v0, Lcom/netwatch/app/MainActivity;->checkerStatusViews:Ljava/util/Map;

    invoke-interface {v11, v10, v6}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    invoke-virtual {v13, v4}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    iget-object v4, v0, Lcom/netwatch/app/MainActivity;->checkResultsContainer:Landroid/widget/LinearLayout;

    invoke-virtual {v4, v13}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    add-int/lit8 v5, v5, 0x1

    move v4, v7

    const/4 v6, 0x1

    const/4 v7, -0x1

    goto/16 :goto_0

    :cond_1
    return-void
.end method

.method private buildDeviceRow(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/view/View;
    .locals 8

    new-instance p5, Landroid/widget/LinearLayout;

    invoke-direct {p5, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v0, 0x0

    invoke-virtual {p5, v0}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v1, 0xa

    invoke-direct {p0, v1}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v2

    const/16 v3, 0x8

    invoke-direct {p0, v3}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v4

    invoke-direct {p0, v1}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v1

    invoke-direct {p0, v3}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v3

    invoke-virtual {p5, v2, v4, v1, v3}, Landroid/view/View;->setPadding(IIII)V

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->deviceLogContainer:Landroid/widget/LinearLayout;

    invoke-virtual {v1}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    rem-int/lit8 v1, v1, 0x2

    if-nez v1, :cond_0

    const-string v1, "#0A0E17"

    goto :goto_0

    :cond_0
    const-string v1, "#0D1320"

    :goto_0
    invoke-static {v1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v1

    invoke-virtual {p5, v1}, Landroid/view/View;->setBackgroundColor(I)V

    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v3, 0x3f800000    # 1.0f

    const/4 v4, -0x2

    invoke-direct {v2, v0, v4, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v1, v2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const-string v3, ":"

    invoke-virtual {p2, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v5

    const/16 v6, 0x3a

    if-eqz v5, :cond_1

    invoke-virtual {p2, v6}, Ljava/lang/String;->lastIndexOf(I)I

    move-result v5

    invoke-virtual {p2, v0, v5}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    goto :goto_1

    :cond_1
    move-object v5, p2

    :goto_1
    invoke-virtual {p2, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_2

    invoke-virtual {p2, v6}, Ljava/lang/String;->lastIndexOf(I)I

    move-result v3

    add-int/2addr v3, v2

    invoke-virtual {p2, v3}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v3

    goto :goto_2

    :cond_2
    const-string v3, "?"

    :goto_2
    invoke-virtual {p1, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-nez v6, :cond_3

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-nez p2, :cond_3

    move v0, v2

    :cond_3
    new-instance p2, Landroid/widget/TextView;

    invoke-direct {p2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    if-eqz v0, :cond_4

    goto :goto_3

    :cond_4
    move-object p1, v5

    :goto_3
    invoke-virtual {p2, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 p1, 0x41400000    # 12.0f

    invoke-virtual {p2, p1}, Landroid/widget/TextView;->setTextSize(F)V

    const-string p1, "#00E5FF"

    if-eqz v0, :cond_5

    move-object v0, p1

    goto :goto_4

    :cond_5
    const-string v0, "#E0E8F0"

    :goto_4
    invoke-static {v0}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v0

    invoke-virtual {p2, v0}, Landroid/widget/TextView;->setTextColor(I)V

    invoke-virtual {p2, v2}, Landroid/widget/TextView;->setMaxLines(I)V

    sget-object v0, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;

    invoke-virtual {p2, v0}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V

    sget-object v6, Landroid/graphics/Typeface;->MONOSPACE:Landroid/graphics/Typeface;

    invoke-virtual {p2, v6}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    invoke-virtual {v1, p2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance p2, Landroid/widget/TextView;

    invoke-direct {p2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, "  :"

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v3, 0x41200000    # 10.0f

    invoke-virtual {p2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    const-string v5, "#FFD740"

    invoke-static {v5}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v5

    invoke-virtual {p2, v5}, Landroid/widget/TextView;->setTextColor(I)V

    invoke-virtual {p2, v2}, Landroid/widget/TextView;->setMaxLines(I)V

    invoke-virtual {p2, v0}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V

    invoke-virtual {p2, v6}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    invoke-virtual {v1, p2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    invoke-virtual {p5, v1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance p2, Landroid/widget/LinearLayout;

    invoke-direct {p2, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    new-instance v0, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v1, 0x48

    invoke-direct {p0, v1}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v1

    invoke-direct {v0, v1, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p2, v0}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {p2, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const v0, 0x800005

    invoke-virtual {p2, v0}, Landroid/widget/LinearLayout;->setGravity(I)V

    new-instance v1, Landroid/widget/TextView;

    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v1, p3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v2, 0x41300000    # 11.0f

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextSize(F)V

    const-string v2, "TCP"

    invoke-virtual {v2, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p3

    if-eqz p3, :cond_6

    goto :goto_5

    :cond_6
    const-string p1, "#B39DDB"

    :goto_5
    invoke-static {p1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p1

    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setTextColor(I)V

    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setGravity(I)V

    invoke-virtual {p2, v1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance p1, Landroid/widget/TextView;

    invoke-direct {p1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {p1, p4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-virtual {p1, v3}, Landroid/widget/TextView;->setTextSize(F)V

    const-string p0, "#37474F"

    invoke-static {p0}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p0

    invoke-virtual {p1, p0}, Landroid/widget/TextView;->setTextColor(I)V

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setGravity(I)V

    invoke-virtual {p2, p1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    invoke-virtual {p5, p2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    return-object p5
.end method

.method private buildReport(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 11

    const-string v0, "error"

    const-string v1, "#EF9A9A"

    if-eqz p2, :cond_0

    :try_start_0
    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2, p2}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    goto :goto_0

    :catch_0
    move-exception p1

    goto/16 :goto_5

    :cond_0
    const/4 v2, 0x0

    :goto_0
    if-eqz p3, :cond_1

    new-instance p2, Lorg/json/JSONObject;

    invoke-direct {p2, p3}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :cond_1
    const-string p2, "ipv4"

    if-eqz v2, :cond_2

    :try_start_1
    invoke-virtual {v2, v0}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result p3

    if-eqz p3, :cond_2

    invoke-virtual {v2, p2}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result p3

    if-nez p3, :cond_2

    const-string p1, "\u274c Error"

    invoke-virtual {v2, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    invoke-direct {p0, p1, p2, v1}, Lcom/netwatch/app/MainActivity;->addCard(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void

    :cond_2
    const/4 p3, 0x0

    if-eqz v2, :cond_5

    invoke-virtual {v2, p2}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object p2

    const-string v0, "ipv6"

    invoke-virtual {v2, v0}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v0

    const-string v3, "cname"

    const-string v4, ""

    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    new-instance v7, Ljava/util/ArrayList;

    invoke-direct {v7}, Ljava/util/ArrayList;-><init>()V

    if-eqz p2, :cond_3

    move v3, p3

    :goto_1
    invoke-virtual {p2}, Lorg/json/JSONArray;->length()I

    move-result v4

    if-ge v3, v4, :cond_3

    invoke-virtual {p2, v3}, Lorg/json/JSONArray;->optString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v7, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    :cond_3
    new-instance v8, Ljava/util/ArrayList;

    invoke-direct {v8}, Ljava/util/ArrayList;-><init>()V

    if-eqz v0, :cond_4

    move p2, p3

    :goto_2
    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v3

    if-ge p2, v3, :cond_4

    invoke-virtual {v0, p2}, Lorg/json/JSONArray;->optString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v8, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 p2, p2, 0x1

    goto :goto_2

    :cond_4
    iget-object p2, p0, Lcom/netwatch/app/MainActivity;->executor:Ljava/util/concurrent/ExecutorService;

    new-instance v0, Lcom/netwatch/app/q;

    move-object v5, v0

    move-object v6, p0

    move-object v10, p1

    invoke-direct/range {v5 .. v10}, Lcom/netwatch/app/q;-><init>(Lcom/netwatch/app/MainActivity;Ljava/util/ArrayList;Ljava/util/ArrayList;Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {p2, v0}, Ljava/util/concurrent/Executor;->execute(Ljava/lang/Runnable;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    :cond_5
    const-string p1, "#546E7A"

    if-eqz v2, :cond_7

    :try_start_2
    const-string p2, "subdomains"

    invoke-virtual {v2, p2}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object p2

    if-eqz p2, :cond_6

    invoke-virtual {p2}, Lorg/json/JSONArray;->length()I

    move-result v0

    if-lez v0, :cond_6

    invoke-direct {p0, p2}, Lcom/netwatch/app/MainActivity;->addSubdomainsCard(Lorg/json/JSONArray;)V

    goto :goto_3

    :cond_6
    const-string p2, "\ud83c\udf3f  Subdomains"

    const-string v0, "None discovered"

    invoke-direct {p0, p2, v0, p1}, Lcom/netwatch/app/MainActivity;->addCard(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_7
    :goto_3
    if-eqz v2, :cond_a

    const-string p2, "sharedHostDomains"

    invoke-virtual {v2, p2}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object p2

    if-eqz p2, :cond_9

    invoke-virtual {p2}, Lorg/json/JSONArray;->length()I

    move-result v0

    if-lez v0, :cond_9

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    :goto_4
    invoke-virtual {p2}, Lorg/json/JSONArray;->length()I

    move-result v0

    if-ge p3, v0, :cond_8

    const-string v0, "\u25b8  "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p3}, Lorg/json/JSONArray;->optString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "\n"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 p3, p3, 0x1

    goto :goto_4

    :cond_8
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "\ud83d\udd75\ufe0f  Shared-Host ("

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Lorg/json/JSONArray;->length()I

    move-result p2

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, ")"

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    const-string p3, "#FFCC80"

    invoke-direct {p0, p2, p1, p3}, Lcom/netwatch/app/MainActivity;->addCard(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_6

    :cond_9
    const-string p2, "\ud83d\udd75\ufe0f  Shared-Host"

    const-string p3, "None found"

    invoke-direct {p0, p2, p3, p1}, Lcom/netwatch/app/MainActivity;->addCard(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    goto :goto_6

    :goto_5
    const-string p2, "\u26a0  Parse Error"

    invoke-virtual {p1}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p2, p1, v1}, Lcom/netwatch/app/MainActivity;->addCard(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_a
    :goto_6
    return-void
.end method

.method public static synthetic c(Lcom/netwatch/app/MainActivity;Ljava/util/List;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$startDomainCheck$42(Ljava/util/List;)V

    return-void
.end method

.method public static bridge synthetic c0(Lcom/netwatch/app/MainActivity;Lcom/netwatch/app/AppEntry;)V
    .locals 0

    iput-object p1, p0, Lcom/netwatch/app/MainActivity;->selectedApp:Lcom/netwatch/app/AppEntry;

    return-void
.end method

.method private checkCustomDomain()V
    .locals 16

    move-object/from16 v0, p0

    iget-object v1, v0, Lcom/netwatch/app/MainActivity;->customDomainInput:Landroid/widget/EditText;

    invoke-virtual {v1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_1

    iget-boolean v1, v0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_0

    const-string v1, "\u0412\u0432\u0435\u0434\u0438\u0442\u0435 \u0434\u043e\u043c\u0435\u043d \u0438\u043b\u0438 IP"

    goto :goto_0

    :cond_0
    const-string v1, "Enter a domain or IP first"

    :goto_0
    invoke-direct {v0, v1}, Lcom/netwatch/app/MainActivity;->showToast(Ljava/lang/String;)V

    return-void

    :cond_1
    const-string v2, "^https?://"

    const-string v3, ""

    invoke-virtual {v1, v2, v3}, Ljava/lang/String;->replaceFirst(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "/.*$"

    invoke-virtual {v1, v2, v3}, Ljava/lang/String;->replaceFirst(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "input_method"

    invoke-virtual {v0, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/view/inputmethod/InputMethodManager;

    const/4 v3, 0x0

    if-eqz v2, :cond_2

    iget-object v4, v0, Lcom/netwatch/app/MainActivity;->customDomainInput:Landroid/widget/EditText;

    invoke-virtual {v4}, Landroid/view/View;->getWindowToken()Landroid/os/IBinder;

    move-result-object v4

    invoke-virtual {v2, v4, v3}, Landroid/view/inputmethod/InputMethodManager;->hideSoftInputFromWindow(Landroid/os/IBinder;I)Z

    :cond_2
    iget-object v2, v0, Lcom/netwatch/app/MainActivity;->checkResultsContainer:Landroid/widget/LinearLayout;

    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, "custom_"

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v4}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/widget/LinearLayout;

    const-string v4, "#00E5FF"

    const-string v6, "#90A4AE"

    const-string v7, "#FFC107"

    const-string v8, "\u2026"

    const/4 v9, 0x1

    if-eqz v2, :cond_3

    invoke-virtual {v2}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    invoke-virtual {v2}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v5

    sub-int/2addr v5, v9

    invoke-virtual {v2, v5}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/widget/TextView;

    invoke-static {v7}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v5

    invoke-virtual {v3, v5}, Landroid/widget/TextView;->setTextColor(I)V

    invoke-virtual {v2, v8}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {v6}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v5

    invoke-virtual {v2, v5}, Landroid/widget/TextView;->setTextColor(I)V

    goto/16 :goto_2

    :cond_3
    iget-object v2, v0, Lcom/netwatch/app/MainActivity;->checkResultsContainer:Landroid/widget/LinearLayout;

    const-string v10, "custom_header"

    invoke-virtual {v2, v10}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v2

    const/4 v11, -0x1

    const/high16 v12, 0x41400000    # 12.0f

    const/4 v13, -0x2

    const/16 v14, 0xa

    if-nez v2, :cond_4

    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v2, v10}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    const-string v10, "\ud83d\udd0e  Custom Checks"

    invoke-virtual {v2, v10}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {v4}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v10

    invoke-virtual {v2, v10}, Landroid/widget/TextView;->setTextColor(I)V

    invoke-virtual {v2, v12}, Landroid/widget/TextView;->setTextSize(F)V

    const/4 v10, 0x0

    invoke-virtual {v2, v10, v9}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;I)V

    invoke-virtual {v2, v9}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v10, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v10, v11, v13}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-direct {v0, v14}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v15

    const/4 v12, 0x4

    invoke-direct {v0, v12}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v12

    invoke-virtual {v10, v3, v15, v3, v12}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    invoke-virtual {v2, v10}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    iget-object v10, v0, Lcom/netwatch/app/MainActivity;->checkResultsContainer:Landroid/widget/LinearLayout;

    invoke-virtual {v10, v2, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;I)V

    :cond_4
    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    sget v10, Lcom/netwatch/app/R$drawable;->card_background:I

    invoke-virtual {v0, v10}, Landroid/content/Context;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v10

    invoke-virtual {v2, v10}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v10, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v2, v5}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v5, v11, v13}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/4 v10, 0x2

    invoke-direct {v0, v10}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v11

    invoke-direct {v0, v10}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v10

    invoke-virtual {v5, v3, v11, v3, v10}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    invoke-virtual {v2, v5}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-direct {v0, v14}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v5

    const/16 v10, 0x8

    invoke-direct {v0, v10}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v11

    invoke-direct {v0, v14}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v12

    invoke-direct {v0, v10}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v10

    invoke-virtual {v2, v5, v11, v12, v10}, Landroid/view/View;->setPadding(IIII)V

    new-instance v5, Landroid/widget/TextView;

    invoke-direct {v5, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v10, "\u25cf"

    invoke-virtual {v5, v10}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {v7}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v7

    invoke-virtual {v5, v7}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v7, 0x41600000    # 14.0f

    invoke-virtual {v5, v7}, Landroid/widget/TextView;->setTextSize(F)V

    invoke-direct {v0, v14}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v7

    invoke-virtual {v5, v3, v3, v7, v3}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v2, v5}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    invoke-virtual {v2, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v7, Landroid/widget/LinearLayout;

    invoke-direct {v7, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    invoke-virtual {v7, v9}, Landroid/widget/LinearLayout;->setOrientation(I)V

    new-instance v10, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v11, 0x3f800000    # 1.0f

    invoke-direct {v10, v3, v13, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v7, v10}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v3, Landroid/widget/TextView;

    invoke-direct {v3, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v3, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const-string v10, "#C8D8E8"

    invoke-static {v10}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v10

    invoke-virtual {v3, v10}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v10, 0x41500000    # 13.0f

    invoke-virtual {v3, v10}, Landroid/widget/TextView;->setTextSize(F)V

    new-instance v10, Landroid/widget/TextView;

    invoke-direct {v10, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v11, "\\d+\\.\\d+\\.\\d+\\.\\d+"

    invoke-virtual {v1, v11}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v11

    if-eqz v11, :cond_5

    const-string v11, "IP Address"

    goto :goto_1

    :cond_5
    const-string v11, "Domain"

    :goto_1
    invoke-virtual {v10, v11}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const-string v11, "#607D8B"

    invoke-static {v11}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v11

    invoke-virtual {v10, v11}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v11, 0x41300000    # 11.0f

    invoke-virtual {v10, v11}, Landroid/widget/TextView;->setTextSize(F)V

    invoke-virtual {v7, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    invoke-virtual {v7, v10}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    invoke-virtual {v2, v7}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v3, Landroid/widget/TextView;

    invoke-direct {v3, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v3, v8}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {v6}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v6

    invoke-virtual {v3, v6}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v6, 0x41400000    # 12.0f

    invoke-virtual {v3, v6}, Landroid/widget/TextView;->setTextSize(F)V

    const v6, 0x800015

    invoke-virtual {v3, v6}, Landroid/widget/TextView;->setGravity(I)V

    invoke-virtual {v2, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    iget-object v6, v0, Lcom/netwatch/app/MainActivity;->checkResultsContainer:Landroid/widget/LinearLayout;

    invoke-virtual {v6, v2, v9}, Landroid/view/ViewGroup;->addView(Landroid/view/View;I)V

    move-object v2, v3

    move-object v3, v5

    :goto_2
    iget-object v5, v0, Lcom/netwatch/app/MainActivity;->checkStatusText:Landroid/widget/TextView;

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    iget-boolean v7, v0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v7, :cond_6

    const-string v7, "\u041f\u0440\u043e\u0432\u0435\u0440\u043a\u0430 "

    goto :goto_3

    :cond_6
    const-string v7, "Checking "

    :goto_3
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v5, v0, Lcom/netwatch/app/MainActivity;->checkStatusText:Landroid/widget/TextView;

    invoke-static {v4}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v4

    invoke-virtual {v5, v4}, Landroid/widget/TextView;->setTextColor(I)V

    iget-object v4, v0, Lcom/netwatch/app/MainActivity;->executor:Ljava/util/concurrent/ExecutorService;

    new-instance v5, Lcom/netwatch/app/n;

    invoke-direct {v5, v0, v1, v2, v3}, Lcom/netwatch/app/n;-><init>(Lcom/netwatch/app/MainActivity;Ljava/lang/String;Landroid/widget/TextView;Landroid/widget/TextView;)V

    invoke-interface {v4, v5}, Ljava/util/concurrent/Executor;->execute(Ljava/lang/Runnable;)V

    return-void
.end method

.method private clearLog()V
    .locals 2

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->hostLogContainer:Landroid/widget/LinearLayout;

    invoke-virtual {v0}, Landroid/view/ViewGroup;->removeAllViews()V

    const/4 v0, 0x0

    iput v0, p0, Lcom/netwatch/app/MainActivity;->hostCount:I

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->seenHosts:Ljava/util/Set;

    invoke-interface {v0}, Ljava/util/Set;->clear()V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->trafficLogForExport:Ljava/util/LinkedHashMap;

    invoke-virtual {v0}, Ljava/util/LinkedHashMap;->clear()V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->connectionCountText:Landroid/widget/TextView;

    const-string v1, ""

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->txTotalText:Landroid/widget/TextView;

    const-string v1, "TX  \u2014"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->rxTotalText:Landroid/widget/TextView;

    const-string v1, "RX  \u2014"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->txRateText:Landroid/widget/TextView;

    const-string v1, "\u2191 0 B/s"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->rxRateText:Landroid/widget/TextView;

    const-string v0, "\u2193 0 B/s"

    invoke-virtual {p0, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method

.method private csv(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    const-string p0, "\"\""

    if-nez p1, :cond_0

    return-object p0

    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\""

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, v1, p0}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic d(Lcom/netwatch/app/MainActivity;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/netwatch/app/MainActivity;->lambda$buildReport$34(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static bridge synthetic d0(Lcom/netwatch/app/MainActivity;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->launchApp(Ljava/lang/String;)V

    return-void
.end method

.method private dp(I)I
    .locals 0

    int-to-float p1, p1

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    mul-float/2addr p1, p0

    float-to-int p0, p1

    return p0
.end method

.method public static synthetic e(Lcom/netwatch/app/MainActivity;Landroid/widget/TextView;ILandroid/view/KeyEvent;)Z
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$20(Landroid/widget/TextView;ILandroid/view/KeyEvent;)Z

    move-result p0

    return p0
.end method

.method public static bridge synthetic e0(Lcom/netwatch/app/MainActivity;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->refreshDeviceLog()V

    return-void
.end method

.method private exportDeviceCsv()V
    .locals 9

    const-string v0, "device_traffic_"

    const/4 v1, 0x1

    :try_start_0
    new-instance v2, Ljava/io/File;

    sget-object v3, Landroid/os/Environment;->DIRECTORY_DOWNLOADS:Ljava/lang/String;

    invoke-static {v3}, Landroid/os/Environment;->getExternalStoragePublicDirectory(Ljava/lang/String;)Ljava/io/File;

    move-result-object v3

    const-string v4, "NetWatch"

    invoke-direct {v2, v3, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v3

    if-nez v3, :cond_0

    invoke-virtual {v2}, Ljava/io/File;->mkdirs()Z

    goto :goto_0

    :catch_0
    move-exception v0

    goto/16 :goto_6

    :cond_0
    :goto_0
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    new-instance v0, Ljava/text/SimpleDateFormat;

    const-string v4, "yyyyMMdd_HHmmss"

    sget-object v5, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-direct {v0, v4, v5}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v4, Ljava/util/Date;

    invoke-direct {v4}, Ljava/util/Date;-><init>()V

    invoke-virtual {v0, v4}, Ljava/text/DateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ".csv"

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    new-instance v3, Ljava/io/File;

    invoke-direct {v3, v2, v0}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    new-instance v2, Ljava/io/PrintWriter;

    new-instance v4, Ljava/io/OutputStreamWriter;

    new-instance v5, Ljava/io/FileOutputStream;

    invoke-direct {v5, v3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    const-string v3, "UTF-8"

    invoke-direct {v4, v5, v3}, Ljava/io/OutputStreamWriter;-><init>(Ljava/io/OutputStream;Ljava/lang/String;)V

    invoke-direct {v2, v4}, Ljava/io/PrintWriter;-><init>(Ljava/io/Writer;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :try_start_1
    const-string v3, "Domain/IP,IP:Port,Protocol,Timestamp,App"

    invoke-virtual {v2, v3}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    iget-object v3, p0, Lcom/netwatch/app/MainActivity;->deviceLog:Ljava/util/ArrayList;

    monitor-enter v3
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    :try_start_2
    iget-object v4, p0, Lcom/netwatch/app/MainActivity;->deviceLog:Ljava/util/ArrayList;

    invoke-virtual {v4}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :goto_1
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_2

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, [Ljava/lang/String;

    array-length v6, v5

    const/4 v7, 0x5

    if-le v6, v7, :cond_1

    aget-object v6, v5, v7

    goto :goto_2

    :catchall_0
    move-exception v0

    goto/16 :goto_4

    :cond_1
    const-string v6, ""

    :goto_2
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v8, 0x0

    aget-object v8, v5, v8

    invoke-direct {p0, v8}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, ","

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v8, 0x2

    aget-object v8, v5, v8

    invoke-direct {p0, v8}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, ","

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v8, 0x3

    aget-object v8, v5, v8

    invoke-direct {p0, v8}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, ","

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v8, 0x4

    aget-object v5, v5, v8

    invoke-direct {p0, v5}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, ","

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0, v6}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v2, v5}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_1

    :cond_2
    monitor-exit v3
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    :try_start_3
    invoke-virtual {v2}, Ljava/io/PrintWriter;->close()V

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    iget-boolean v3, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v3, :cond_3

    const-string v3, "\u0421\u043e\u0445\u0440\u0430\u043d\u0435\u043d\u043e: "

    goto :goto_3

    :cond_3
    const-string v3, "Saved: "

    :goto_3
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0

    goto :goto_8

    :goto_4
    :try_start_4
    monitor-exit v3
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    :try_start_5
    throw v0
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_1

    :catchall_1
    move-exception v0

    :try_start_6
    invoke-virtual {v2}, Ljava/io/PrintWriter;->close()V
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_2

    goto :goto_5

    :catchall_2
    move-exception v2

    :try_start_7
    invoke-virtual {v0, v2}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_5
    throw v0
    :try_end_7
    .catch Ljava/lang/Exception; {:try_start_7 .. :try_end_7} :catch_0

    :goto_6
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    iget-boolean v3, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v3, :cond_4

    const-string v3, "\u041e\u0448\u0438\u0431\u043a\u0430 \u044d\u043a\u0441\u043f\u043e\u0440\u0442\u0430: "

    goto :goto_7

    :cond_4
    const-string v3, "Export failed: "

    :goto_7
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    :goto_8
    return-void
.end method

.method private exportDomainIntel()V
    .locals 15

    const-string v0, "cname"

    const-string v1, "ipv6"

    const-string v2, "ipv4"

    const-string v3, ""

    iget-object v4, p0, Lcom/netwatch/app/MainActivity;->lastDomainForExport:Ljava/lang/String;

    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_1

    iget-boolean v0, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v0, :cond_0

    const-string v0, "\u0421\u043d\u0430\u0447\u0430\u043b\u0430 \u0432\u044b\u043f\u043e\u043b\u043d\u0438\u0442\u0435 \u0441\u043a\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0438\u0435"

    goto :goto_0

    :cond_0
    const-string v0, "Run a scan first"

    :goto_0
    invoke-direct {p0, v0}, Lcom/netwatch/app/MainActivity;->showToast(Ljava/lang/String;)V

    return-void

    :cond_1
    new-instance v4, Ljava/text/SimpleDateFormat;

    const-string v5, "yyyy-MM-dd HH:mm:ss"

    sget-object v6, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-direct {v4, v5, v6}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v5, Ljava/util/Date;

    invoke-direct {v5}, Ljava/util/Date;-><init>()V

    invoke-virtual {v4, v5}, Ljava/text/DateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v4

    new-instance v5, Ljava/lang/StringBuilder;

    const-string v6, "field,value\n"

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v6, "report_type"

    invoke-direct {p0, v6}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, ","

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, "NetWatch Domain Intelligence"

    invoke-direct {p0, v7}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, "\n"

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, "generated"

    invoke-direct {p0, v8}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0, v4}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, "domain"

    invoke-direct {p0, v8}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v8, p0, Lcom/netwatch/app/MainActivity;->lastDomainForExport:Ljava/lang/String;

    invoke-direct {p0, v8}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, "\n\n"

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :try_start_0
    iget-object v9, p0, Lcom/netwatch/app/MainActivity;->lastIntelJsonForExport:Ljava/lang/String;

    invoke-virtual {v9}, Ljava/lang/String;->isEmpty()Z

    move-result v9

    if-nez v9, :cond_b

    new-instance v9, Lorg/json/JSONObject;

    iget-object v10, p0, Lcom/netwatch/app/MainActivity;->lastIntelJsonForExport:Ljava/lang/String;

    invoke-direct {v9, v10}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    invoke-virtual {v9, v2}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v10
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    const-string v11, "record_type,value\n"

    const/4 v12, 0x0

    if-eqz v10, :cond_3

    :try_start_1
    invoke-virtual {v10}, Lorg/json/JSONArray;->length()I

    move-result v13

    if-lez v13, :cond_3

    invoke-virtual {v5, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move v13, v12

    :goto_1
    invoke-virtual {v10}, Lorg/json/JSONArray;->length()I

    move-result v14

    if-ge v13, v14, :cond_2

    invoke-direct {p0, v2}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v14

    invoke-virtual {v5, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v13}, Lorg/json/JSONArray;->optString(I)Ljava/lang/String;

    move-result-object v14

    invoke-direct {p0, v14}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v14

    invoke-virtual {v5, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v13, v13, 0x1

    goto :goto_1

    :catch_0
    move-exception v0

    goto/16 :goto_6

    :cond_2
    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_3
    invoke-virtual {v9, v1}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v2

    if-eqz v2, :cond_5

    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v10

    if-lez v10, :cond_5

    invoke-virtual {v5, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move v10, v12

    :goto_2
    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v13

    if-ge v10, v13, :cond_4

    invoke-direct {p0, v1}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v13

    invoke-virtual {v5, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v10}, Lorg/json/JSONArray;->optString(I)Ljava/lang/String;

    move-result-object v13

    invoke-direct {p0, v13}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v13

    invoke-virtual {v5, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v10, v10, 0x1

    goto :goto_2

    :cond_4
    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_5
    invoke-virtual {v9, v0, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_6

    const-string v2, "null"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_6

    invoke-virtual {v5, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0, v0}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0, v1}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_6
    const-string v0, "subdomains"

    invoke-virtual {v9, v0}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v0

    if-eqz v0, :cond_9

    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v1

    if-lez v1, :cond_9

    const-string v1, "subdomain,ip\n"

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move v1, v12

    :goto_3
    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v2

    if-ge v1, v2, :cond_8

    invoke-virtual {v0, v1}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v2

    const-string v8, "name"

    invoke-virtual {v2, v8, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    const-string v10, "ips"

    invoke-virtual {v2, v10}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v2

    if-eqz v2, :cond_7

    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v10

    if-lez v10, :cond_7

    invoke-virtual {v2, v12}, Lorg/json/JSONArray;->optString(I)Ljava/lang/String;

    move-result-object v2

    goto :goto_4

    :cond_7
    move-object v2, v3

    :goto_4
    invoke-direct {p0, v8}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0, v2}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v1, v1, 0x1

    goto :goto_3

    :cond_8
    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_9
    const-string v0, "sharedHostDomains"

    invoke-virtual {v9, v0}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v0

    if-eqz v0, :cond_b

    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v1

    if-lez v1, :cond_b

    const-string v1, "shared_host_domain\n"

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :goto_5
    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v1

    if-ge v12, v1, :cond_a

    invoke-virtual {v0, v12}, Lorg/json/JSONArray;->optString(I)Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v12, v12, 0x1

    goto :goto_5

    :cond_a
    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_7

    :goto_6
    const-string v1, "error"

    invoke-direct {p0, v1}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_b
    :goto_7
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "NetWatch_"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->lastDomainForExport:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "_"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " "

    invoke-virtual {v4, v2, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v1

    const-string v2, ":"

    invoke-virtual {v1, v2, v3}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ".csv"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v0, v1}, Lcom/netwatch/app/MainActivity;->shareCsv(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method private exportTrafficLog()V
    .locals 6

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->trafficLogForExport:Ljava/util/LinkedHashMap;

    invoke-virtual {v0}, Ljava/util/AbstractMap;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1

    iget-boolean v0, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v0, :cond_0

    const-string v0, "\u041d\u0435\u0442 \u0434\u0430\u043d\u043d\u044b\u0445 \u0442\u0440\u0430\u0444\u0438\u043a\u0430 \u0434\u043b\u044f \u044d\u043a\u0441\u043f\u043e\u0440\u0442\u0430"

    goto :goto_0

    :cond_0
    const-string v0, "No traffic data to export"

    :goto_0
    invoke-direct {p0, v0}, Lcom/netwatch/app/MainActivity;->showToast(Ljava/lang/String;)V

    return-void

    :cond_1
    new-instance v0, Ljava/text/SimpleDateFormat;

    const-string v1, "yyyy-MM-dd HH:mm:ss"

    sget-object v2, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-direct {v0, v1, v2}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v1, Ljava/util/Date;

    invoke-direct {v1}, Ljava/util/Date;-><init>()V

    invoke-virtual {v0, v1}, Ljava/text/DateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->selectedApp:Lcom/netwatch/app/AppEntry;

    if-eqz v1, :cond_2

    iget-object v1, v1, Lcom/netwatch/app/AppEntry;->label:Ljava/lang/String;

    goto :goto_1

    :cond_2
    const-string v1, "Device"

    :goto_1
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "timestamp,host_or_ip\n"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v3, p0, Lcom/netwatch/app/MainActivity;->trafficLogForExport:Ljava/util/LinkedHashMap;

    invoke-virtual {v3}, Ljava/util/LinkedHashMap;->entrySet()Ljava/util/Set;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_2
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_3

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/util/Map$Entry;

    invoke-interface {v4}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/String;

    invoke-direct {p0, v5}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, ","

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {v4}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    invoke-direct {p0, v4}, Lcom/netwatch/app/MainActivity;->csv(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "\n"

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_2

    :cond_3
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "NetWatch_Traffic_"

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v4, "[^a-zA-Z0-9]"

    const-string v5, "_"

    invoke-virtual {v1, v4, v5}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " "

    invoke-virtual {v0, v1, v5}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v0

    const-string v1, ":"

    const-string v4, ""

    invoke-virtual {v0, v1, v4}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ".csv"

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v0, v1}, Lcom/netwatch/app/MainActivity;->shareCsv(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method private static extractRootDomain(Ljava/lang/String;)Ljava/lang/String;
    .locals 3

    const-string v0, "  "

    invoke-virtual {p0, v0}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I

    move-result v0

    const/4 v1, 0x2

    if-ltz v0, :cond_0

    add-int/2addr v0, v1

    invoke-virtual {p0, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    :cond_0
    const-string v0, "\\."

    invoke-virtual {p0, v0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    array-length v2, v0

    if-lt v2, v1, :cond_1

    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    array-length v2, v0

    sub-int/2addr v2, v1

    aget-object v1, v0, v2

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "."

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v1, v0

    add-int/lit8 v1, v1, -0x1

    aget-object v0, v0, v1

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    :cond_1
    return-object p0
.end method

.method public static synthetic f(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$8(Landroid/view/View;)V

    return-void
.end method

.method public static bridge synthetic f0(Lcom/netwatch/app/MainActivity;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->seedTrustedDomains(Ljava/lang/String;)V

    return-void
.end method

.method private fireAlert(Ljava/lang/String;)V
    .locals 5

    const/4 v0, 0x4

    :try_start_0
    const-string v1, "vibrator"

    invoke-virtual {p0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/os/Vibrator;

    if-eqz v1, :cond_0

    invoke-virtual {v1}, Landroid/os/Vibrator;->hasVibrator()Z

    move-result v2

    if-eqz v2, :cond_0

    new-array v2, v0, [J

    fill-array-data v2, :array_0

    const/4 v3, -0x1

    invoke-static {v2, v3}, Landroid/os/VibrationEffect;->createWaveform([JI)Landroid/os/VibrationEffect;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/os/Vibrator;->vibrate(Landroid/os/VibrationEffect;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :cond_0
    :try_start_1
    const-string v1, "netwatch_alerts"

    const-string v2, "notification"

    invoke-virtual {p0, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/app/NotificationManager;

    new-instance v3, Landroid/app/NotificationChannel;

    const-string v4, "NetWatch Alerts"

    invoke-direct {v3, v1, v4, v0}, Landroid/app/NotificationChannel;-><init>(Ljava/lang/String;Ljava/lang/CharSequence;I)V

    const/4 v0, 0x0

    invoke-virtual {v3, v0}, Landroid/app/NotificationChannel;->enableVibration(Z)V

    invoke-virtual {v2, v3}, Landroid/app/NotificationManager;->createNotificationChannel(Landroid/app/NotificationChannel;)V

    const-string v0, "  "

    invoke-virtual {p1, v0}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I

    move-result v0

    if-ltz v0, :cond_1

    add-int/lit8 v0, v0, 0x2

    invoke-virtual {p1, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    :cond_1
    new-instance v0, Landroid/app/Notification$Builder;

    invoke-direct {v0, p0, v1}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    const p0, 0x1080027

    invoke-virtual {v0, p0}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;

    move-result-object p0

    const-string v0, "\u26a0 Unknown Connection Detected"

    invoke-virtual {p0, v0}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/app/Notification$Builder;->setContentText(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object p0

    const/4 p1, 0x1

    invoke-virtual {p0, p1}, Landroid/app/Notification$Builder;->setAutoCancel(Z)Landroid/app/Notification$Builder;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;

    move-result-object p0

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    long-to-int p1, v0

    invoke-virtual {v2, p1, p0}, Landroid/app/NotificationManager;->notify(ILandroid/app/Notification;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    :catch_1
    return-void

    :array_0
    .array-data 8
        0x0
        0x78
        0x50
        0xb4
    .end array-data
.end method

.method private static formatBytes(J)Ljava/lang/String;
    .locals 3

    const-wide/16 v0, 0x0

    cmp-long v0, p0, v0

    if-gez v0, :cond_0

    const-string p0, "\u2014"

    return-object p0

    :cond_0
    const-wide/16 v0, 0x400

    cmp-long v0, p0, v0

    if-gez v0, :cond_1

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p0, p1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p0, " B"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_1
    const-wide/32 v0, 0x100000

    cmp-long v0, p0, v0

    if-gez v0, :cond_2

    sget-object v0, Ljava/util/Locale;->US:Ljava/util/Locale;

    long-to-double p0, p0

    const-wide/high16 v1, 0x4090000000000000L    # 1024.0

    div-double/2addr p0, v1

    invoke-static {p0, p1}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object p0

    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object p0

    const-string p1, "%.1f KB"

    invoke-static {v0, p1, p0}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_2
    const-wide/32 v0, 0x40000000

    cmp-long v0, p0, v0

    if-gez v0, :cond_3

    sget-object v0, Ljava/util/Locale;->US:Ljava/util/Locale;

    long-to-double p0, p0

    const-wide/high16 v1, 0x4130000000000000L    # 1048576.0

    div-double/2addr p0, v1

    invoke-static {p0, p1}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object p0

    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object p0

    const-string p1, "%.2f MB"

    invoke-static {v0, p1, p0}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_3
    sget-object v0, Ljava/util/Locale;->US:Ljava/util/Locale;

    long-to-double p0, p0

    const-wide/high16 v1, 0x41d0000000000000L    # 1.073741824E9

    div-double/2addr p0, v1

    invoke-static {p0, p1}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object p0

    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object p0

    const-string p1, "%.2f GB"

    invoke-static {v0, p1, p0}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic g(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$18(Landroid/view/View;)V

    return-void
.end method

.method public static bridge synthetic g0(Lcom/netwatch/app/MainActivity;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->startMonitoring()V

    return-void
.end method

.method public static synthetic h(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$21(Landroid/view/View;)V

    return-void
.end method

.method public static bridge synthetic h0(Lcom/netwatch/app/MainActivity;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->stopMonitoring()V

    return-void
.end method

.method public static synthetic i(Lcom/netwatch/app/MainActivity;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->lambda$refreshDeviceLog$47()V

    return-void
.end method

.method public static bridge synthetic i0(Lcom/netwatch/app/MainActivity;JJJJLjava/lang/String;)V
    .locals 0

    invoke-direct/range {p0 .. p9}, Lcom/netwatch/app/MainActivity;->updateStats(JJJJLjava/lang/String;)V

    return-void
.end method

.method private static isGlobalCdn(Ljava/lang/String;)Z
    .locals 24

    const-string v0, "google.com"

    const-string v1, "googleapis.com"

    const-string v2, "gstatic.com"

    const-string v3, "akamai.net"

    const-string v4, "akamaized.net"

    const-string v5, "cloudflare.com"

    const-string v6, "cloudflare.net"

    const-string v7, "fastly.net"

    const-string v8, "amazonaws.com"

    const-string v9, "cloudfront.net"

    const-string v10, "msedge.net"

    const-string v11, "microsoft.com"

    const-string v12, "apple.com"

    const-string v13, "icloud.com"

    const-string v14, "fbcdn.net"

    const-string v15, "twimg.com"

    const-string v16, "akamaitechnologies.com"

    const-string v17, "akamaiedge.net"

    const-string v18, "awsstatic.com"

    const-string v19, "mzstatic.com"

    const-string v20, "googlevideo.com"

    const-string v21, "googleusercontent.com"

    const-string v22, "android.com"

    const-string v23, "msftconnecttest.com"

    filled-new-array/range {v0 .. v23}, [Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    const/16 v3, 0x18

    if-ge v2, v3, :cond_1

    aget-object v3, v0, v2

    move-object/from16 v4, p0

    invoke-virtual {v4, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_0

    const/4 v0, 0x1

    return v0

    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_1
    return v1
.end method

.method private isTrustedHost(Ljava/lang/String;)Z
    .locals 4

    const/4 v0, 0x1

    if-eqz p1, :cond_5

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    goto :goto_0

    :cond_0
    invoke-virtual {p1}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p1

    const-string v1, "  "

    invoke-virtual {p1, v1}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I

    move-result v1

    if-ltz v1, :cond_1

    add-int/lit8 v1, v1, 0x2

    invoke-virtual {p1, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    :cond_1
    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->trustedDomains:Ljava/util/Set;

    invoke-interface {p0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_2
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_4

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_3

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "."

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_2

    :cond_3
    return v0

    :cond_4
    const/4 p0, 0x0

    return p0

    :cond_5
    :goto_0
    return v0
.end method

.method public static synthetic j(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$10(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic k(Lcom/netwatch/app/MainActivity;Ljava/lang/String;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/netwatch/app/MainActivity;->lambda$lookupMyInfo$36(Ljava/lang/String;Landroid/view/View;)V

    return-void
.end method

.method public static synthetic l(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$2(Landroid/view/View;)V

    return-void
.end method

.method private synthetic lambda$addHostRow$30(Ljava/lang/String;Landroid/widget/LinearLayout;Landroid/widget/TextView;ZLandroid/widget/TextView;Landroid/widget/TextView;Landroid/widget/Button;Landroid/view/View;)V
    .locals 1

    invoke-static {p1}, Lcom/netwatch/app/MainActivity;->extractRootDomain(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p8

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->trustedDomains:Ljava/util/Set;

    invoke-interface {v0, p8}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->trustedDomains:Ljava/util/Set;

    invoke-interface {v0, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const/4 p1, 0x0

    invoke-virtual {p2, p1}, Landroid/view/View;->setBackgroundColor(I)V

    if-eqz p4, :cond_0

    const-string p1, "#66BB6A"

    goto :goto_0

    :cond_0
    const-string p1, "#546E7A"

    :goto_0
    invoke-static {p1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p1

    invoke-virtual {p3, p1}, Landroid/widget/TextView;->setTextColor(I)V

    const-string p1, "#C8D8E8"

    invoke-static {p1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p1

    invoke-virtual {p5, p1}, Landroid/widget/TextView;->setTextColor(I)V

    const/16 p1, 0x8

    invoke-virtual {p6, p1}, Landroid/view/View;->setVisibility(I)V

    invoke-virtual {p7, p1}, Landroid/view/View;->setVisibility(I)V

    iget-boolean p1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p1, :cond_1

    const-string p1, "\u2713 \u0414\u043e\u0432\u0435\u0440\u0435\u043d\u043d\u044b\u0439: "

    :goto_1
    invoke-static {p1, p8}, Landroidx/activity/result/a;->m(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    goto :goto_2

    :cond_1
    const-string p1, "\u2713 Trusted: "

    goto :goto_1

    :goto_2
    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->showToast(Ljava/lang/String;)V

    return-void
.end method

.method private synthetic lambda$buildReport$34(Ljava/lang/String;Ljava/lang/String;)V
    .locals 1

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    if-lez v0, :cond_0

    const-string v0, "\ud83c\udf10  "

    invoke-static {v0, p2}, Landroidx/activity/result/a;->m(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    const-string v0, "#A5D6A7"

    invoke-direct {p0, p2, p1, v0}, Lcom/netwatch/app/MainActivity;->addCard(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_0
    return-void
.end method

.method private synthetic lambda$buildReport$35(Ljava/util/List;Ljava/util/List;Ljava/lang/String;Ljava/lang/String;)V
    .locals 10

    const-string v0, ""

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    const-string v3, "\n"

    const/4 v4, 0x0

    if-eqz v2, :cond_4

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    const-string v5, "IPv4:  "

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :try_start_0
    new-instance v5, Ljava/net/URL;

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "https://ipinfo.io/"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "/json"

    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v5, v2}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v5}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v2

    check-cast v2, Ljava/net/HttpURLConnection;

    const-string v5, "Accept"

    const-string v6, "application/json"

    invoke-virtual {v2, v5, v6}, Ljava/net/URLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    const/16 v5, 0x1388

    invoke-virtual {v2, v5}, Ljava/net/URLConnection;->setConnectTimeout(I)V

    invoke-virtual {v2, v5}, Ljava/net/URLConnection;->setReadTimeout(I)V

    new-instance v5, Lorg/json/JSONObject;

    new-instance v6, Ljava/lang/String;

    invoke-virtual {v2}, Ljava/net/URLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v7

    invoke-static {v7}, La/a;->v(Ljava/io/InputStream;)[B

    move-result-object v7

    const-string v8, "UTF-8"

    invoke-direct {v6, v7, v8}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    invoke-virtual {v6}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v6

    invoke-direct {v5, v6}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->disconnect()V

    const-string v2, "country"

    invoke-virtual {v5, v2, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const-string v6, "city"

    invoke-virtual {v5, v6, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    const-string v7, "org"

    invoke-virtual {v5, v7, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    :try_start_1
    new-instance v7, Ljava/util/Locale;

    invoke-direct {v7, v0, v2}, Ljava/util/Locale;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v7}, Ljava/util/Locale;->getDisplayCountry()Ljava/lang/String;

    move-result-object v7
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_1

    :catch_0
    move-object v7, v2

    :goto_1
    :try_start_2
    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v8

    const/4 v9, 0x2

    if-ne v8, v9, :cond_0

    invoke-virtual {v2, v4}, Ljava/lang/String;->charAt(I)C

    move-result v4

    const v8, -0x1f1a5

    sub-int/2addr v4, v8

    const/4 v9, 0x1

    invoke-virtual {v2, v9}, Ljava/lang/String;->charAt(I)C

    move-result v2

    sub-int/2addr v2, v8

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    new-instance v9, Ljava/lang/String;

    invoke-static {v4}, Ljava/lang/Character;->toChars(I)[C

    move-result-object v4

    invoke-direct {v9, v4}, Ljava/lang/String;-><init>([C)V

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-instance v4, Ljava/lang/String;

    invoke-static {v2}, Ljava/lang/Character;->toChars(I)[C

    move-result-object v2

    invoke-direct {v4, v2}, Ljava/lang/String;-><init>([C)V

    invoke-virtual {v8, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    goto :goto_2

    :cond_0
    move-object v2, v0

    :goto_2
    invoke-virtual {v7}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-nez v4, :cond_1

    const-string v4, "  "

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_1
    invoke-virtual {v6}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_2

    const-string v2, ", "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_2
    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_3

    const-string v2, "\n       "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    :catch_1
    :cond_3
    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto/16 :goto_0

    :cond_4
    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_3
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result p2

    if-eqz p2, :cond_5

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Ljava/lang/String;

    const-string v0, "IPv6:  "

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_3

    :cond_5
    invoke-virtual {p3}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    if-nez p1, :cond_6

    const-string p1, "null"

    invoke-virtual {p3, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_6

    const-string p1, "CNAME: "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_6
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    iget-object p2, p0, Lcom/netwatch/app/MainActivity;->mainHandler:Landroid/os/Handler;

    new-instance p3, Lcom/netwatch/app/g;

    invoke-direct {p3, p0, p1, p4, v4}, Lcom/netwatch/app/g;-><init>(Landroid/content/ContextWrapper;Ljava/lang/String;Ljava/lang/Object;I)V

    invoke-virtual {p2, p3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private synthetic lambda$checkCustomDomain$43(Landroid/widget/TextView;ZJLandroid/widget/TextView;Ljava/lang/String;)V
    .locals 4

    const-string v0, " ms"

    if-eqz p2, :cond_0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p3, p4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    goto :goto_0

    :cond_0
    const-string v1, "BLOCKED"

    :goto_0
    invoke-virtual {p1, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const-string v1, "#EF5350"

    const-string v2, "#66BB6A"

    if-eqz p2, :cond_1

    invoke-static {v2}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v3

    goto :goto_1

    :cond_1
    invoke-static {v1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v3

    :goto_1
    invoke-virtual {p1, v3}, Landroid/widget/TextView;->setTextColor(I)V

    if-eqz p2, :cond_2

    invoke-static {v2}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p1

    goto :goto_2

    :cond_2
    invoke-static {v1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p1

    :goto_2
    invoke-virtual {p5, p1}, Landroid/widget/TextView;->setTextColor(I)V

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->checkStatusText:Landroid/widget/TextView;

    invoke-static {p6}, Landroidx/activity/result/a;->h(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p5

    if-eqz p2, :cond_3

    new-instance p6, Ljava/lang/StringBuilder;

    const-string v1, " \u2705  reachable in "

    invoke-direct {p6, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p6, p3, p4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    goto :goto_3

    :cond_3
    const-string p3, " \ud83d\udeab  appears BLOCKED"

    :goto_3
    invoke-virtual {p5, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p1, p3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->checkStatusText:Landroid/widget/TextView;

    if-eqz p2, :cond_4

    invoke-static {v2}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p2

    goto :goto_4

    :cond_4
    const-string p2, "#EF9A9A"

    invoke-static {p2}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p2

    :goto_4
    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setTextColor(I)V

    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->checkResultsContainer:Landroid/widget/LinearLayout;

    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    check-cast p0, Landroid/widget/ScrollView;

    const/4 p1, 0x0

    invoke-virtual {p0, p1, p1}, Landroid/widget/ScrollView;->smoothScrollTo(II)V

    return-void
.end method

.method private synthetic lambda$checkCustomDomain$44(Ljava/lang/String;Landroid/widget/TextView;Landroid/widget/TextView;)V
    .locals 12

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->probeHost(Ljava/lang/String;)[J

    move-result-object v0

    const/4 v1, 0x0

    aget-wide v2, v0, v1

    const-wide/16 v4, 0x1

    cmp-long v2, v2, v4

    const/4 v3, 0x1

    if-nez v2, :cond_0

    move v7, v3

    goto :goto_0

    :cond_0
    move v7, v1

    :goto_0
    aget-wide v8, v0, v3

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->mainHandler:Landroid/os/Handler;

    new-instance v1, Lcom/netwatch/app/m;

    move-object v4, v1

    move-object v5, p0

    move-object v6, p2

    move-object v10, p3

    move-object v11, p1

    invoke-direct/range {v4 .. v11}, Lcom/netwatch/app/m;-><init>(Lcom/netwatch/app/MainActivity;Landroid/widget/TextView;ZJLandroid/widget/TextView;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private static synthetic lambda$loadAppList$26(Lcom/netwatch/app/AppEntry;Lcom/netwatch/app/AppEntry;)I
    .locals 0

    iget-object p0, p0, Lcom/netwatch/app/AppEntry;->label:Ljava/lang/String;

    iget-object p1, p1, Lcom/netwatch/app/AppEntry;->label:Ljava/lang/String;

    invoke-virtual {p0, p1}, Ljava/lang/String;->compareToIgnoreCase(Ljava/lang/String;)I

    move-result p0

    return p0
.end method

.method private synthetic lambda$loadAppList$27()V
    .locals 3

    new-instance v0, Landroid/widget/ArrayAdapter;

    const v1, 0x1090008

    iget-object v2, p0, Lcom/netwatch/app/MainActivity;->appList:Ljava/util/List;

    invoke-direct {v0, p0, v1, v2}, Landroid/widget/ArrayAdapter;-><init>(Landroid/content/Context;ILjava/util/List;)V

    iput-object v0, p0, Lcom/netwatch/app/MainActivity;->appAdapter:Landroid/widget/ArrayAdapter;

    const v1, 0x1090009

    invoke-virtual {v0, v1}, Landroid/widget/ArrayAdapter;->setDropDownViewResource(I)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->appSpinner:Landroid/widget/Spinner;

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->appAdapter:Landroid/widget/ArrayAdapter;

    invoke-virtual {v0, v1}, Landroid/widget/Spinner;->setAdapter(Landroid/widget/SpinnerAdapter;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->appList:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->appList:Ljava/util/List;

    const/4 v1, 0x0

    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/netwatch/app/AppEntry;

    iput-object v0, p0, Lcom/netwatch/app/MainActivity;->selectedApp:Lcom/netwatch/app/AppEntry;

    :cond_0
    return-void
.end method

.method private synthetic lambda$loadAppList$28()V
    .locals 8

    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    const/16 v1, 0x80

    invoke-virtual {v0, v1}, Landroid/content/pm/PackageManager;->getInstalledApplications(I)Ljava/util/List;

    move-result-object v1

    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_0
    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    const/4 v4, 0x0

    const/4 v5, 0x1

    if-eqz v3, :cond_6

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/content/pm/ApplicationInfo;

    iget-object v6, v3, Landroid/content/pm/ApplicationInfo;->packageName:Ljava/lang/String;

    invoke-virtual {v0, v6}, Landroid/content/pm/PackageManager;->getLaunchIntentForPackage(Ljava/lang/String;)Landroid/content/Intent;

    move-result-object v6

    if-nez v6, :cond_1

    goto :goto_0

    :cond_1
    iget v6, v3, Landroid/content/pm/ApplicationInfo;->flags:I

    and-int/lit8 v7, v6, 0x1

    if-eqz v7, :cond_2

    move v7, v5

    goto :goto_1

    :cond_2
    move v7, v4

    :goto_1
    and-int/lit16 v6, v6, 0x80

    if-eqz v6, :cond_3

    move v4, v5

    :cond_3
    if-eqz v7, :cond_4

    if-nez v4, :cond_4

    goto :goto_0

    :cond_4
    iget-object v4, v3, Landroid/content/pm/ApplicationInfo;->packageName:Ljava/lang/String;

    const-string v5, "com.android."

    invoke-virtual {v4, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_0

    const-string v5, "android."

    invoke-virtual {v4, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_0

    const-string v5, "android"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_0

    const-string v5, "com.qualcomm."

    invoke-virtual {v4, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_0

    const-string v5, "com.mediatek."

    invoke-virtual {v4, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_0

    const-string v5, "com.sec.android."

    invoke-virtual {v4, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_0

    const-string v5, "com.google.android.gms"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_0

    const-string v5, "com.google.android.gsf"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_0

    const-string v5, "com.google.android.providers.media.module"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_0

    const-string v5, "com.google.android.permissioncontroller"

    invoke-virtual {v4, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_0

    const-string v5, "com.google.android.ext."

    invoke-virtual {v4, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_0

    const-string v5, "com.google.android.trichromelibrary"

    invoke-virtual {v4, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_5

    goto/16 :goto_0

    :cond_5
    invoke-virtual {v0, v3}, Landroid/content/pm/PackageManager;->getApplicationLabel(Landroid/content/pm/ApplicationInfo;)Ljava/lang/CharSequence;

    move-result-object v4

    invoke-interface {v4}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v4

    new-instance v5, Lcom/netwatch/app/AppEntry;

    iget-object v6, v3, Landroid/content/pm/ApplicationInfo;->packageName:Ljava/lang/String;

    iget v3, v3, Landroid/content/pm/ApplicationInfo;->uid:I

    invoke-direct {v5, v4, v6, v3}, Lcom/netwatch/app/AppEntry;-><init>(Ljava/lang/String;Ljava/lang/String;I)V

    invoke-virtual {v2, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto/16 :goto_0

    :cond_6
    new-instance v0, Lcom/google/android/material/color/utilities/i;

    invoke-direct {v0, v5}, Lcom/google/android/material/color/utilities/i;-><init>(I)V

    invoke-static {v2, v0}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    iput-object v2, p0, Lcom/netwatch/app/MainActivity;->appList:Ljava/util/List;

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->mainHandler:Landroid/os/Handler;

    new-instance v1, Lcom/netwatch/app/l;

    invoke-direct {v1, p0, v4}, Lcom/netwatch/app/l;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private synthetic lambda$lookupMyInfo$36(Ljava/lang/String;Landroid/view/View;)V
    .locals 1

    new-instance p2, Landroid/content/Intent;

    const-string v0, "android.intent.action.VIEW"

    invoke-static {p1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    invoke-direct {p2, v0, p1}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    const/high16 p1, 0x10000000

    invoke-virtual {p2, p1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    iget-boolean p1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p1, :cond_0

    const-string p1, "\u041e\u0442\u043a\u0440\u044b\u0442\u044c \u0432 \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u0438 \u043a\u0430\u0440\u0442"

    goto :goto_0

    :cond_0
    const-string p1, "Open with maps app"

    :goto_0
    invoke-static {p2, p1}, Landroid/content/Intent;->createChooser(Landroid/content/Intent;Ljava/lang/CharSequence;)Landroid/content/Intent;

    move-result-object p1

    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    invoke-virtual {p2, v0}, Landroid/content/Intent;->resolveActivity(Landroid/content/pm/PackageManager;)Landroid/content/ComponentName;

    move-result-object p2

    if-eqz p2, :cond_1

    invoke-virtual {p0, p1}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    goto :goto_2

    :cond_1
    iget-boolean p1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p1, :cond_2

    const-string p1, "\u041f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u0435 \u043a\u0430\u0440\u0442 \u043d\u0435 \u043d\u0430\u0439\u0434\u0435\u043d\u043e"

    goto :goto_1

    :cond_2
    const-string p1, "No maps app found"

    :goto_1
    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->showToast(Ljava/lang/String;)V

    :goto_2
    return-void
.end method

.method private synthetic lambda$lookupMyInfo$37(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 10

    move-object v0, p0

    move-object v1, p1

    move-object v2, p3

    move-object v3, p4

    move-object/from16 v4, p10

    move-object/from16 v5, p11

    iget-object v6, v0, Lcom/netwatch/app/MainActivity;->myInfoContainer:Landroid/widget/LinearLayout;

    invoke-virtual {v6}, Landroid/view/ViewGroup;->removeAllViews()V

    iget-object v6, v0, Lcom/netwatch/app/MainActivity;->myInfoRefreshBtn:Landroid/widget/Button;

    const/4 v7, 0x1

    invoke-virtual {v6, v7}, Landroid/view/View;->setEnabled(Z)V

    const-string v6, "#001020"

    const-string v8, "#00E5FF"

    const-string v9, "\ud83d\udd0c  Public IP Address"

    invoke-direct {p0, v9, p1, v6, v8}, Lcom/netwatch/app/MainActivity;->addMyInfoCard(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    if-nez p2, :cond_0

    const-string v1, ""

    const-string v2, "#0D1117"

    const-string v3, "Could not reach the internet. Check your connection."

    invoke-direct {p0, v3, v1, v2}, Lcom/netwatch/app/MainActivity;->addMyInfoRow(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void

    :cond_0
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p3}, Ljava/lang/String;->isEmpty()Z

    move-result v8

    if-nez v8, :cond_1

    const-string v8, "ISP:  "

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_1
    invoke-virtual {p4}, Ljava/lang/String;->isEmpty()Z

    move-result v8

    const-string v9, "\n"

    if-nez v8, :cond_3

    invoke-virtual {p4, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_3

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->length()I

    move-result v2

    if-lez v2, :cond_2

    invoke-virtual {v6, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_2
    const-string v2, "Org:  "

    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_3
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->length()I

    move-result v2

    if-lez v2, :cond_4

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "#001A0E"

    const-string v6, "#00FF88"

    const-string v8, "\ud83c\udfe2  Provider"

    invoke-direct {p0, v8, v2, v3, v6}, Lcom/netwatch/app/MainActivity;->addMyInfoCard(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_4
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p5}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_5

    const-string v3, "City:      "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-object v3, p5

    invoke-virtual {v2, p5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_5
    invoke-virtual/range {p6 .. p6}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_7

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I

    move-result v3

    if-lez v3, :cond_6

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_6
    const-string v3, "ZIP:       "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-object/from16 v3, p6

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_7
    invoke-virtual/range {p7 .. p7}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_9

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I

    move-result v3

    if-lez v3, :cond_8

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_8
    const-string v3, "Region:    "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-object/from16 v3, p7

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_9
    invoke-virtual/range {p8 .. p8}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_b

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I

    move-result v3

    if-lez v3, :cond_a

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_a
    const-string v3, "Country:   "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-object/from16 v3, p9

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "  "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-object/from16 v3, p8

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_b
    invoke-virtual/range {p10 .. p10}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    const-string v6, "0.0"

    if-nez v3, :cond_d

    invoke-virtual/range {p11 .. p11}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_d

    invoke-virtual {v4, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_d

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I

    move-result v3

    if-lez v3, :cond_c

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_c
    const-string v3, "Coords:    "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, ", "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_d
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I

    move-result v3

    if-lez v3, :cond_e

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "#0A0020"

    const-string v8, "#B060FF"

    const-string v9, "\ud83d\udccd  Geolocation"

    invoke-direct {p0, v9, v2, v3, v8}, Lcom/netwatch/app/MainActivity;->addMyInfoCard(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_e
    invoke-virtual/range {p12 .. p12}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_f

    const-string v2, "#0A1A12"

    const-string v3, "#00E5CC"

    const-string v8, "\ud83d\udd50  Timezone"

    move-object/from16 v9, p12

    invoke-direct {p0, v8, v9, v2, v3}, Lcom/netwatch/app/MainActivity;->addMyInfoCard(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_f
    invoke-virtual/range {p10 .. p10}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_11

    invoke-virtual/range {p11 .. p11}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_11

    invoke-virtual {v4, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_11

    new-instance v2, Landroid/widget/Button;

    invoke-direct {v2, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    iget-boolean v3, v0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v3, :cond_10

    const-string v3, "\ud83d\udccd  \u041e\u0442\u043a\u0440\u044b\u0442\u044c \u043d\u0430 \u043a\u0430\u0440\u0442\u0435"

    goto :goto_0

    :cond_10
    const-string v3, "\ud83d\udccd  Open in Maps"

    :goto_0
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 v3, -0x1

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v6

    sget v8, Lcom/netwatch/app/R$drawable;->btn_primary:I

    invoke-virtual {v6, v8}, Landroid/content/res/Resources;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v6

    invoke-virtual {v2, v6}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v8, -0x2

    invoke-direct {v6, v3, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/16 v3, 0xc

    const/4 v8, 0x0

    invoke-virtual {v6, v8, v3, v8, v8}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    invoke-virtual {v2, v6}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v3, Ljava/lang/StringBuilder;

    const-string v6, "geo:"

    invoke-direct {v3, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, ","

    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, "?q="

    invoke-virtual {v3, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "("

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ")"

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    new-instance v3, Lcom/google/android/material/snackbar/a;

    invoke-direct {v3, v7, p0, v1}, Lcom/google/android/material/snackbar/a;-><init>(ILjava/lang/Object;Ljava/lang/Object;)V

    invoke-virtual {v2, v3}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v0, v0, Lcom/netwatch/app/MainActivity;->myInfoContainer:Landroid/widget/LinearLayout;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    :cond_11
    return-void
.end method

.method private synthetic lambda$lookupMyInfo$38()V
    .locals 18

    const-string v0, "UTF-8"

    const-string v1, ","

    const-string v2, "https://ipinfo.io/"

    :try_start_0
    new-instance v3, Ljava/net/URL;

    const-string v4, "https://api.ipify.org"

    invoke-direct {v3, v4}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v3

    check-cast v3, Ljava/net/HttpURLConnection;

    const/16 v4, 0x1388

    invoke-virtual {v3, v4}, Ljava/net/URLConnection;->setConnectTimeout(I)V

    invoke-virtual {v3, v4}, Ljava/net/URLConnection;->setReadTimeout(I)V

    invoke-virtual {v3}, Ljava/net/URLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v4

    new-instance v5, Ljava/lang/String;

    invoke-static {v4}, La/a;->v(Ljava/io/InputStream;)[B

    move-result-object v4

    invoke-direct {v5, v4, v0}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    invoke-virtual {v5}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :goto_0
    move-object v8, v4

    goto :goto_1

    :catch_0
    const/4 v4, 0x0

    goto :goto_0

    :goto_1
    const-string v3, ""

    const-string v4, "\ud83c\udf10"

    if-eqz v8, :cond_2

    :try_start_1
    new-instance v5, Ljava/net/URL;

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "/json"

    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v5, v2}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v5}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v2

    check-cast v2, Ljava/net/HttpURLConnection;

    const-string v5, "Accept"

    const-string v6, "application/json"

    invoke-virtual {v2, v5, v6}, Ljava/net/URLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    const/16 v5, 0x1770

    invoke-virtual {v2, v5}, Ljava/net/URLConnection;->setConnectTimeout(I)V

    invoke-virtual {v2, v5}, Ljava/net/URLConnection;->setReadTimeout(I)V

    invoke-virtual {v2}, Ljava/net/URLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v5

    new-instance v6, Ljava/lang/String;

    invoke-static {v5}, La/a;->v(Ljava/io/InputStream;)[B

    move-result-object v5

    invoke-direct {v6, v5, v0}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    invoke-virtual {v6}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->disconnect()V

    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2, v0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v0, "org"

    invoke-virtual {v2, v0, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_a

    :try_start_2
    const-string v5, "city"

    invoke-virtual {v2, v5, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_9

    :try_start_3
    const-string v6, "region"

    invoke-virtual {v2, v6, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_8

    :try_start_4
    const-string v7, "country"

    invoke-virtual {v2, v7, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_7

    :try_start_5
    const-string v9, "postal"

    invoke-virtual {v2, v9, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_6

    :try_start_6
    const-string v10, "timezone"

    invoke-virtual {v2, v10, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10
    :try_end_6
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_6} :catch_5

    :try_start_7
    const-string v11, "loc"

    invoke-virtual {v2, v11, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v11

    const/4 v12, 0x1

    const/4 v13, 0x0

    if-eqz v11, :cond_0

    invoke-virtual {v2, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v11

    aget-object v11, v11, v13

    invoke-virtual {v11}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v11
    :try_end_7
    .catch Ljava/lang/Exception; {:try_start_7 .. :try_end_7} :catch_3

    :try_start_8
    invoke-virtual {v2, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    aget-object v1, v1, v12

    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1
    :try_end_8
    .catch Ljava/lang/Exception; {:try_start_8 .. :try_end_8} :catch_1

    goto :goto_3

    :catch_1
    move-object v1, v3

    :catch_2
    :goto_2
    move-object v3, v0

    goto/16 :goto_8

    :catch_3
    move-object v1, v3

    move-object v11, v1

    goto :goto_2

    :cond_0
    move-object v1, v3

    move-object v11, v1

    :goto_3
    :try_start_9
    new-instance v2, Ljava/util/Locale;

    invoke-direct {v2, v3, v7}, Ljava/util/Locale;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/util/Locale;->getDisplayCountry()Ljava/lang/String;
    :try_end_9
    .catch Ljava/lang/Exception; {:try_start_9 .. :try_end_9} :catch_4

    :catch_4
    :try_start_a
    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v2

    const/4 v3, 0x2

    if-ne v2, v3, :cond_1

    invoke-virtual {v7, v13}, Ljava/lang/String;->charAt(I)C

    move-result v2

    const v3, -0x1f1a5

    sub-int/2addr v2, v3

    invoke-virtual {v7, v12}, Ljava/lang/String;->charAt(I)C

    move-result v12

    sub-int/2addr v12, v3

    new-instance v3, Ljava/lang/String;

    invoke-static {v2}, Ljava/lang/Character;->toChars(I)[C

    move-result-object v2

    invoke-direct {v3, v2}, Ljava/lang/String;-><init>([C)V

    new-instance v2, Ljava/lang/String;

    invoke-static {v12}, Ljava/lang/Character;->toChars(I)[C

    move-result-object v12

    invoke-direct {v2, v12}, Ljava/lang/String;-><init>([C)V

    invoke-virtual {v3, v2}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4
    :try_end_a
    .catch Ljava/lang/Exception; {:try_start_a .. :try_end_a} :catch_2

    :cond_1
    move-object/from16 v16, v1

    move-object v14, v4

    move-object v12, v6

    move-object v13, v7

    move-object/from16 v17, v10

    move-object v15, v11

    move-object v10, v5

    move-object v11, v9

    move-object v9, v0

    goto/16 :goto_9

    :catch_5
    move-object v1, v3

    move-object v10, v1

    :goto_4
    move-object v11, v10

    goto :goto_2

    :catch_6
    move-object v1, v3

    move-object v9, v1

    :goto_5
    move-object v10, v9

    goto :goto_4

    :catch_7
    move-object v1, v3

    move-object v7, v1

    :goto_6
    move-object v9, v7

    goto :goto_5

    :catch_8
    move-object v1, v3

    move-object v6, v1

    :goto_7
    move-object v7, v6

    goto :goto_6

    :catch_9
    move-object v1, v3

    move-object v5, v1

    move-object v6, v5

    goto :goto_7

    :catch_a
    move-object v1, v3

    move-object v5, v1

    move-object v6, v5

    move-object v7, v6

    move-object v9, v7

    move-object v10, v9

    move-object v11, v10

    :goto_8
    move-object/from16 v16, v1

    move-object v14, v4

    move-object v12, v6

    move-object v13, v7

    move-object/from16 v17, v10

    move-object v15, v11

    move-object v10, v5

    move-object v11, v9

    move-object v9, v3

    goto :goto_9

    :cond_2
    move-object v9, v3

    move-object v10, v9

    move-object v11, v10

    move-object v12, v11

    move-object v13, v12

    move-object v15, v13

    move-object/from16 v16, v15

    move-object/from16 v17, v16

    move-object v14, v4

    :goto_9
    if-eqz v8, :cond_3

    move-object v7, v8

    goto :goto_a

    :cond_3
    const-string v0, "Unable to determine"

    move-object v7, v0

    :goto_a
    new-instance v0, Lcom/netwatch/app/o;

    move-object v5, v0

    move-object/from16 v6, p0

    invoke-direct/range {v5 .. v17}, Lcom/netwatch/app/o;-><init>(Lcom/netwatch/app/MainActivity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    move-object/from16 v1, p0

    invoke-virtual {v1, v0}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method

.method private synthetic lambda$onCreate$0(Landroid/view/View;)V
    .locals 0

    const/4 p1, 0x0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->switchTab(I)V

    return-void
.end method

.method private synthetic lambda$onCreate$1(Landroid/view/View;)V
    .locals 0

    const/4 p1, 0x1

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->switchTab(I)V

    return-void
.end method

.method private synthetic lambda$onCreate$10(Landroid/view/View;)V
    .locals 0

    const/4 p1, 0x4

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->switchTab(I)V

    return-void
.end method

.method private synthetic lambda$onCreate$11(Landroid/view/View;)V
    .locals 0

    const/4 p1, 0x5

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->switchTab(I)V

    return-void
.end method

.method private synthetic lambda$onCreate$12(Landroid/view/View;)V
    .locals 0

    iget-boolean p1, p0, Lcom/netwatch/app/MainActivity;->deviceMonRunning:Z

    if-eqz p1, :cond_0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->stopDeviceMonitor()V

    goto :goto_0

    :cond_0
    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->startDeviceMonitor()V

    :goto_0
    return-void
.end method

.method private synthetic lambda$onCreate$13(Landroid/view/View;)V
    .locals 1

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->deviceLog:Ljava/util/ArrayList;

    invoke-virtual {p1}, Ljava/util/ArrayList;->clear()V

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->deviceLogContainer:Landroid/widget/LinearLayout;

    invoke-virtual {p1}, Landroid/view/ViewGroup;->removeAllViews()V

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->deviceCountText:Landroid/widget/TextView;

    const-string v0, "0 connections"

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->deviceExportBtn:Landroid/widget/Button;

    const/16 v0, 0x8

    invoke-virtual {p1, v0}, Landroid/view/View;->setVisibility(I)V

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->deviceClearBtn:Landroid/widget/Button;

    invoke-virtual {p1, v0}, Landroid/view/View;->setVisibility(I)V

    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->deviceHeaderRow:Landroid/widget/LinearLayout;

    invoke-virtual {p0, v0}, Landroid/view/View;->setVisibility(I)V

    return-void
.end method

.method private synthetic lambda$onCreate$14(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->exportDeviceCsv()V

    return-void
.end method

.method private synthetic lambda$onCreate$15(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->exportTrafficLog()V

    return-void
.end method

.method private synthetic lambda$onCreate$16(Landroid/content/SharedPreferences;Landroid/widget/CompoundButton;Z)V
    .locals 0

    iput-boolean p3, p0, Lcom/netwatch/app/MainActivity;->alertsEnabled:Z

    invoke-interface {p1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string p1, "alerts_enabled"

    invoke-interface {p0, p1, p3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    return-void
.end method

.method private synthetic lambda$onCreate$17(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->startDomainCheck()V

    return-void
.end method

.method private synthetic lambda$onCreate$18(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->stopDomainCheck()V

    return-void
.end method

.method private synthetic lambda$onCreate$19(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->checkCustomDomain()V

    return-void
.end method

.method private synthetic lambda$onCreate$2(Landroid/view/View;)V
    .locals 0

    const/4 p1, 0x2

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->switchTab(I)V

    return-void
.end method

.method private synthetic lambda$onCreate$20(Landroid/widget/TextView;ILandroid/view/KeyEvent;)Z
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->checkCustomDomain()V

    const/4 p0, 0x1

    return p0
.end method

.method private synthetic lambda$onCreate$21(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->startMonitoring()V

    return-void
.end method

.method private synthetic lambda$onCreate$22(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->stopMonitoring()V

    return-void
.end method

.method private synthetic lambda$onCreate$23(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->clearLog()V

    return-void
.end method

.method private synthetic lambda$onCreate$3(Landroid/view/View;)V
    .locals 0

    const/4 p1, 0x3

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->switchTab(I)V

    return-void
.end method

.method private synthetic lambda$onCreate$4(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->showMainMenu(Landroid/view/View;)V

    return-void
.end method

.method private synthetic lambda$onCreate$5(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->performLookup()V

    return-void
.end method

.method private synthetic lambda$onCreate$6(Landroid/widget/TextView;ILandroid/view/KeyEvent;)Z
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->performLookup()V

    const/4 p0, 0x1

    return p0
.end method

.method private synthetic lambda$onCreate$7(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->exportDomainIntel()V

    return-void
.end method

.method private synthetic lambda$onCreate$8(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->lookupMyInfo()V

    return-void
.end method

.method private synthetic lambda$onCreate$9(Landroid/view/View;)V
    .locals 0

    iget-boolean p1, p0, Lcom/netwatch/app/MainActivity;->speedRunning:Z

    if-nez p1, :cond_0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->runSpeedTest()V

    :cond_0
    return-void
.end method

.method private synthetic lambda$performLookup$32(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->lookupBtn:Landroid/widget/Button;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/view/View;->setEnabled(Z)V

    if-nez p1, :cond_1

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->statusText:Landroid/widget/TextView;

    iget-boolean p0, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p0, :cond_0

    const-string p0, "\u274c  \u041e\u0448\u0438\u0431\u043a\u0430 \u0441\u0435\u0442\u0438"

    goto :goto_0

    :cond_0
    const-string p0, "\u274c  Network error"

    :goto_0
    invoke-virtual {p1, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void

    :cond_1
    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->statusText:Landroid/widget/TextView;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_2

    const-string v1, "\u2705  \u0421\u043a\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0438\u0435 \u0437\u0430\u0432\u0435\u0440\u0448\u0435\u043d\u043e: "

    :goto_1
    invoke-static {v1, p2}, Landroidx/activity/result/a;->m(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    goto :goto_2

    :cond_2
    const-string v1, "\u2705  Scan complete for "

    goto :goto_1

    :goto_2
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iput-object p2, p0, Lcom/netwatch/app/MainActivity;->lastDomainForExport:Ljava/lang/String;

    iput-object p1, p0, Lcom/netwatch/app/MainActivity;->lastIntelJsonForExport:Ljava/lang/String;

    const-string v0, ""

    iput-object v0, p0, Lcom/netwatch/app/MainActivity;->lastProbeJsonForExport:Ljava/lang/String;

    const/4 v0, 0x0

    invoke-direct {p0, p2, p1, v0}, Lcom/netwatch/app/MainActivity;->buildReport(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method private synthetic lambda$performLookup$33(Ljava/lang/String;)V
    .locals 4

    const-string v0, "{\"domain\":\""

    const-string v1, "\"}"

    invoke-static {v0, p1, v1}, Landroidx/activity/result/a;->f(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "https://superagent-cfb25b3e.base44.app/functions/domainIntel"

    invoke-direct {p0, v1, v0}, Lcom/netwatch/app/MainActivity;->postJson(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->mainHandler:Landroid/os/Handler;

    new-instance v2, Lcom/netwatch/app/g;

    const/4 v3, 0x1

    invoke-direct {v2, p0, v0, p1, v3}, Lcom/netwatch/app/g;-><init>(Landroid/content/ContextWrapper;Ljava/lang/String;Ljava/lang/Object;I)V

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private synthetic lambda$refreshDeviceLog$47()V
    .locals 1

    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->deviceScrollView:Landroid/widget/ScrollView;

    const/4 v0, 0x0

    invoke-virtual {p0, v0, v0}, Landroid/widget/ScrollView;->smoothScrollTo(II)V

    return-void
.end method

.method private synthetic lambda$runSpeedTest$45(Ljava/lang/String;JDD)V
    .locals 14

    move-object v0, p0

    move-object v1, p1

    move-wide/from16 v2, p2

    const/4 v4, 0x0

    iput-boolean v4, v0, Lcom/netwatch/app/MainActivity;->speedRunning:Z

    iget-object v5, v0, Lcom/netwatch/app/MainActivity;->speedRunBtn:Landroid/widget/Button;

    const/4 v6, 0x1

    invoke-virtual {v5, v6}, Landroid/view/View;->setEnabled(Z)V

    iget-object v5, v0, Lcom/netwatch/app/MainActivity;->speedStatusText:Landroid/widget/TextView;

    iget-boolean v6, v0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v6, :cond_0

    const-string v6, "\u2705 \u0422\u0435\u0441\u0442 \u0437\u0430\u0432\u0435\u0440\u0448\u0451\u043d \u2014 "

    :goto_0
    invoke-static {v6, p1}, Landroidx/activity/result/a;->m(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    goto :goto_1

    :cond_0
    const-string v6, "\u2705 Test complete \u2014 "

    goto :goto_0

    :goto_1
    invoke-virtual {v5, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v1, v0, Lcom/netwatch/app/MainActivity;->speedPingText:Landroid/widget/TextView;

    const-wide/16 v5, 0x0

    cmp-long v5, v2, v5

    if-ltz v5, :cond_1

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v7, " ms"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    goto :goto_2

    :cond_1
    iget-boolean v6, v0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v6, :cond_2

    const-string v6, "\u043d\u0435\u0434\u043e\u0441\u0442\u0443\u043f\u0435\u043d"

    goto :goto_2

    :cond_2
    const-string v6, "unreachable"

    :goto_2
    invoke-virtual {v1, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v1, v0, Lcom/netwatch/app/MainActivity;->speedDownText:Landroid/widget/TextView;

    const-wide/16 v6, 0x0

    cmpl-double v8, p4, v6

    const-string v9, "N/A"

    const-string v10, "\u043d\u0435\u0442 \u0434\u0430\u043d\u043d\u044b\u0445"

    const-string v11, "%.2f Mbps"

    if-ltz v8, :cond_3

    sget-object v8, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-static/range {p4 .. p5}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v12

    filled-new-array {v12}, [Ljava/lang/Object;

    move-result-object v12

    invoke-static {v8, v11, v12}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v8

    goto :goto_3

    :cond_3
    iget-boolean v8, v0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v8, :cond_4

    move-object v8, v10

    goto :goto_3

    :cond_4
    move-object v8, v9

    :goto_3
    invoke-virtual {v1, v8}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v1, v0, Lcom/netwatch/app/MainActivity;->speedUpText:Landroid/widget/TextView;

    cmpl-double v8, p6, v6

    if-ltz v8, :cond_5

    sget-object v8, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-static/range {p6 .. p7}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v9

    filled-new-array {v9}, [Ljava/lang/Object;

    move-result-object v9

    invoke-static {v8, v11, v9}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v9

    goto :goto_4

    :cond_5
    iget-boolean v8, v0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v8, :cond_6

    move-object v9, v10

    :cond_6
    :goto_4
    invoke-virtual {v1, v9}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v1, v0, Lcom/netwatch/app/MainActivity;->speedPingText:Landroid/widget/TextView;

    const-string v8, "#EF9A9A"

    const-string v9, "#FFD740"

    const-string v10, "#00FF88"

    const-string v11, "#546E7A"

    if-gez v5, :cond_7

    invoke-static {v11}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v2

    goto :goto_5

    :cond_7
    const-wide/16 v12, 0x32

    cmp-long v5, v2, v12

    if-gez v5, :cond_8

    invoke-static {v10}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v2

    goto :goto_5

    :cond_8
    const-wide/16 v12, 0x96

    cmp-long v2, v2, v12

    if-gez v2, :cond_9

    invoke-static {v9}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v2

    goto :goto_5

    :cond_9
    invoke-static {v8}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v2

    :goto_5
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextColor(I)V

    iget-object v1, v0, Lcom/netwatch/app/MainActivity;->speedDownText:Landroid/widget/TextView;

    cmpg-double v2, p4, v6

    if-gez v2, :cond_a

    invoke-static {v11}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v2

    goto :goto_6

    :cond_a
    const-wide/high16 v2, 0x4049000000000000L    # 50.0

    cmpl-double v2, p4, v2

    if-ltz v2, :cond_b

    invoke-static {v10}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v2

    goto :goto_6

    :cond_b
    const-wide/high16 v2, 0x4024000000000000L    # 10.0

    cmpl-double v2, p4, v2

    if-ltz v2, :cond_c

    invoke-static {v9}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v2

    goto :goto_6

    :cond_c
    invoke-static {v8}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v2

    :goto_6
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextColor(I)V

    iget-object v1, v0, Lcom/netwatch/app/MainActivity;->speedUpText:Landroid/widget/TextView;

    cmpg-double v2, p6, v6

    if-gez v2, :cond_d

    invoke-static {v11}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v2

    goto :goto_7

    :cond_d
    const-wide/high16 v2, 0x4034000000000000L    # 20.0

    cmpl-double v2, p6, v2

    if-ltz v2, :cond_e

    invoke-static {v10}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v2

    goto :goto_7

    :cond_e
    const-wide/high16 v2, 0x4014000000000000L    # 5.0

    cmpl-double v2, p6, v2

    if-ltz v2, :cond_f

    invoke-static {v9}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v2

    goto :goto_7

    :cond_f
    invoke-static {v8}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v2

    :goto_7
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextColor(I)V

    iget-object v0, v0, Lcom/netwatch/app/MainActivity;->speedResultsContainer:Landroid/widget/LinearLayout;

    invoke-virtual {v0, v4}, Landroid/view/View;->setVisibility(I)V

    return-void
.end method

.method private synthetic lambda$runSpeedTest$46(Ljava/lang/String;ZZLjava/lang/String;)V
    .locals 23

    move-object/from16 v1, p1

    const/4 v2, 0x0

    :try_start_0
    new-instance v0, Ljava/net/URL;

    invoke-direct {v0, v1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/net/URL;->getHost()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0}, Ljava/net/URL;->getPort()I

    move-result v4

    if-lez v4, :cond_0

    invoke-virtual {v0}, Ljava/net/URL;->getPort()I

    move-result v0

    goto :goto_0

    :cond_0
    const-string v0, "https"

    invoke-virtual {v1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    const/16 v0, 0x1bb

    goto :goto_0

    :cond_1
    const/16 v0, 0x50

    :goto_0
    const-wide v4, 0x7fffffffffffffffL

    move v6, v2

    :goto_1
    const/4 v7, 0x3

    if-ge v6, v7, :cond_2

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v7

    new-instance v9, Ljava/net/Socket;

    invoke-direct {v9}, Ljava/net/Socket;-><init>()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :try_start_1
    new-instance v10, Ljava/net/InetSocketAddress;

    invoke-direct {v10, v3, v0}, Ljava/net/InetSocketAddress;-><init>(Ljava/lang/String;I)V

    const/16 v11, 0xbb8

    invoke-virtual {v9, v10, v11}, Ljava/net/Socket;->connect(Ljava/net/SocketAddress;I)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :try_start_2
    invoke-virtual {v9}, Ljava/net/Socket;->close()V

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v9

    sub-long/2addr v9, v7

    invoke-static {v4, v5, v9, v10}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v4

    const-wide/16 v7, 0x64

    invoke-static {v7, v8}, Ljava/lang/Thread;->sleep(J)V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    add-int/lit8 v6, v6, 0x1

    goto :goto_1

    :catchall_0
    move-exception v0

    move-object v3, v0

    :try_start_3
    invoke-virtual {v9}, Ljava/net/Socket;->close()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    goto :goto_2

    :catchall_1
    move-exception v0

    move-object v4, v0

    :try_start_4
    invoke-virtual {v3, v4}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_2
    throw v3
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_0

    :cond_2
    :goto_3
    move-wide v9, v4

    goto :goto_4

    :catch_0
    const-wide/16 v4, -0x1

    goto :goto_3

    :goto_4
    const-wide v5, 0x408f400000000000L    # 1000.0

    const-wide/high16 v7, 0x4020000000000000L    # 8.0

    const-string v11, "NetWatch/1.4.8"

    const-string v12, "User-Agent"

    const/16 v13, 0x61a8

    const/16 v14, 0x1f40

    const-wide/16 v17, 0x0

    if-eqz p2, :cond_3

    :try_start_5
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v15, "/__down?bytes=10485760"

    invoke-virtual {v0, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_5

    :catch_1
    const-wide/high16 v2, -0x4010000000000000L    # -1.0

    goto/16 :goto_a

    :cond_3
    if-eqz p3, :cond_4

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v15, "/download?size=10485760"

    invoke-virtual {v0, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_5

    :cond_4
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v15, "/garbage.php?ckSize=10"

    invoke-virtual {v0, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_5
    new-instance v15, Ljava/net/URL;

    invoke-direct {v15, v0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v15}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v0

    check-cast v0, Ljava/net/HttpURLConnection;

    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setInstanceFollowRedirects(Z)V

    invoke-virtual {v0, v14}, Ljava/net/URLConnection;->setConnectTimeout(I)V

    invoke-virtual {v0, v13}, Ljava/net/URLConnection;->setReadTimeout(I)V

    invoke-virtual {v0, v12, v11}, Ljava/net/URLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/net/URLConnection;->connect()V

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v15

    const/16 v13, 0xc8

    if-ne v15, v13, :cond_9

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v19

    const/high16 v13, 0x10000

    new-array v13, v13, [B

    invoke-virtual {v0}, Ljava/net/URLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v15
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_1

    move-wide/from16 v21, v17

    :goto_6
    :try_start_6
    invoke-virtual {v15, v13}, Ljava/io/InputStream;->read([B)I

    move-result v14
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_2

    const/4 v2, -0x1

    if-eq v14, v2, :cond_5

    int-to-long v3, v14

    add-long v21, v21, v3

    const-wide/32 v2, 0xa00000

    cmp-long v2, v21, v2

    if-ltz v2, :cond_6

    :cond_5
    move-wide/from16 v2, v21

    goto :goto_7

    :cond_6
    const/4 v2, 0x0

    goto :goto_6

    :goto_7
    :try_start_7
    invoke-virtual {v15}, Ljava/io/InputStream;->close()V

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v13
    :try_end_7
    .catch Ljava/lang/Exception; {:try_start_7 .. :try_end_7} :catch_1

    sub-long v13, v13, v19

    cmp-long v4, v13, v17

    if-lez v4, :cond_7

    cmp-long v4, v2, v17

    if-lez v4, :cond_7

    long-to-double v2, v2

    mul-double/2addr v2, v7

    long-to-double v13, v13

    div-double/2addr v13, v5

    div-double/2addr v2, v13

    const-wide v13, 0x412e848000000000L    # 1000000.0

    div-double/2addr v2, v13

    goto :goto_8

    :cond_7
    const-wide/high16 v2, -0x4010000000000000L    # -1.0

    :goto_8
    :try_start_8
    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->disconnect()V
    :try_end_8
    .catch Ljava/lang/Exception; {:try_start_8 .. :try_end_8} :catch_2

    goto :goto_a

    :catchall_2
    move-exception v0

    move-object v2, v0

    if-eqz v15, :cond_8

    :try_start_9
    invoke-virtual {v15}, Ljava/io/InputStream;->close()V
    :try_end_9
    .catchall {:try_start_9 .. :try_end_9} :catchall_3

    goto :goto_9

    :catchall_3
    move-exception v0

    move-object v3, v0

    :try_start_a
    invoke-virtual {v2, v3}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_8
    :goto_9
    throw v2

    :cond_9
    new-instance v2, Ljava/io/IOException;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "HTTP "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v2, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v2
    :try_end_a
    .catch Ljava/lang/Exception; {:try_start_a .. :try_end_a} :catch_1

    :catch_2
    :goto_a
    if-eqz p2, :cond_a

    :try_start_b
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "/__up"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_b

    :catch_3
    const-wide/high16 v15, -0x4010000000000000L    # -1.0

    goto/16 :goto_d

    :cond_a
    if-eqz p3, :cond_b

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "/upload"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_b

    :cond_b
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "/empty.php"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_b
    new-instance v1, Ljava/net/URL;

    invoke-direct {v1, v0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v0

    check-cast v0, Ljava/net/HttpURLConnection;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/net/HttpURLConnection;->setInstanceFollowRedirects(Z)V

    const-string v1, "POST"

    invoke-virtual {v0, v1}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Ljava/net/URLConnection;->setDoOutput(Z)V

    const/16 v1, 0x1f40

    invoke-virtual {v0, v1}, Ljava/net/URLConnection;->setConnectTimeout(I)V

    const/16 v1, 0x61a8

    invoke-virtual {v0, v1}, Ljava/net/URLConnection;->setReadTimeout(I)V

    const-string v1, "Content-Type"

    const-string v4, "application/octet-stream"

    invoke-virtual {v0, v1, v4}, Ljava/net/URLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v0, v12, v11}, Ljava/net/URLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    const/high16 v1, 0x400000

    new-array v4, v1, [B

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v11

    invoke-virtual {v0}, Ljava/net/URLConnection;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v13
    :try_end_b
    .catch Ljava/lang/Exception; {:try_start_b .. :try_end_b} :catch_3

    :try_start_c
    invoke-virtual {v13, v4}, Ljava/io/OutputStream;->write([B)V

    invoke-virtual {v13}, Ljava/io/OutputStream;->flush()V
    :try_end_c
    .catchall {:try_start_c .. :try_end_c} :catchall_4

    :try_start_d
    invoke-virtual {v13}, Ljava/io/OutputStream;->close()V

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v4

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v13
    :try_end_d
    .catch Ljava/lang/Exception; {:try_start_d .. :try_end_d} :catch_3

    sub-long/2addr v13, v11

    cmp-long v11, v13, v17

    if-lez v11, :cond_c

    const/16 v11, 0x1f4

    if-ge v4, v11, :cond_c

    int-to-double v11, v1

    mul-double/2addr v11, v7

    long-to-double v7, v13

    div-double/2addr v7, v5

    div-double/2addr v11, v7

    const-wide v4, 0x412e848000000000L    # 1000000.0

    div-double v15, v11, v4

    goto :goto_c

    :cond_c
    const-wide/high16 v15, -0x4010000000000000L    # -1.0

    :goto_c
    :try_start_e
    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->disconnect()V
    :try_end_e
    .catch Ljava/lang/Exception; {:try_start_e .. :try_end_e} :catch_4

    :catch_4
    :goto_d
    move-object/from16 v1, p0

    move-wide v13, v15

    goto :goto_f

    :catchall_4
    move-exception v0

    move-object v1, v0

    if-eqz v13, :cond_d

    :try_start_f
    invoke-virtual {v13}, Ljava/io/OutputStream;->close()V
    :try_end_f
    .catchall {:try_start_f .. :try_end_f} :catchall_5

    goto :goto_e

    :catchall_5
    move-exception v0

    move-object v4, v0

    :try_start_10
    invoke-virtual {v1, v4}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_d
    :goto_e
    throw v1
    :try_end_10
    .catch Ljava/lang/Exception; {:try_start_10 .. :try_end_10} :catch_3

    :goto_f
    iget-object v0, v1, Lcom/netwatch/app/MainActivity;->mainHandler:Landroid/os/Handler;

    new-instance v4, Lcom/netwatch/app/s;

    move-object v6, v4

    move-object/from16 v7, p0

    move-object/from16 v8, p4

    move-wide v11, v2

    invoke-direct/range {v6 .. v14}, Lcom/netwatch/app/s;-><init>(Lcom/netwatch/app/MainActivity;Ljava/lang/String;JDD)V

    invoke-virtual {v0, v4}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private static synthetic lambda$seedTrustedDomains$31(Ljava/lang/String;)Z
    .locals 0

    invoke-static {p0}, Lcom/netwatch/app/MainActivity;->isGlobalCdn(Ljava/lang/String;)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0
.end method

.method private synthetic lambda$showLanguageDialog$25(Landroid/content/DialogInterface;I)V
    .locals 3

    const/4 v0, 0x0

    const/4 v1, 0x1

    if-ne p2, v1, :cond_0

    goto :goto_0

    :cond_0
    move v1, v0

    :goto_0
    iget-boolean p2, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eq v1, p2, :cond_2

    iput-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    const-string p2, "netwatch_prefs"

    invoke-virtual {p0, p2, v0}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p2

    invoke-interface {p2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_1

    const-string v1, "ru"

    goto :goto_1

    :cond_1
    const-string v1, "en"

    :goto_1
    const-string v2, "language"

    invoke-interface {p2, v2, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    invoke-interface {p2}, Landroid/content/SharedPreferences$Editor;->apply()V

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->refreshTabLabels()V

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->refreshUiStrings()V

    :cond_2
    invoke-interface {p1}, Landroid/content/DialogInterface;->dismiss()V

    iget-boolean p1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p1, :cond_3

    const-string p1, "\u042f\u0437\u044b\u043a \u0438\u0437\u043c\u0435\u043d\u0451\u043d \u043d\u0430 \u0420\u0443\u0441\u0441\u043a\u0438\u0439"

    goto :goto_2

    :cond_3
    const-string p1, "Language set to English"

    :goto_2
    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method private synthetic lambda$showMainMenu$24(Landroid/view/MenuItem;)Z
    .locals 3

    invoke-interface {p1}, Landroid/view/MenuItem;->getItemId()I

    move-result p1

    sget v0, Lcom/netwatch/app/R$id;->menu_instructions_domain:I

    const/4 v1, 0x1

    if-ne p1, v0, :cond_1

    iget-boolean p1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p1, :cond_0

    const-string p1, "\ud83d\udd0d Domain Intel \u2014 \u0421\u043f\u0440\u0430\u0432\u043a\u0430"

    const-string v0, "\u0412\u0432\u0435\u0434\u0438\u0442\u0435 \u0434\u043e\u043c\u0435\u043d\u043d\u043e\u0435 \u0438\u043c\u044f \u0438 \u043d\u0430\u0436\u043c\u0438\u0442\u0435 \u041f\u043e\u0438\u0441\u043a.\n\n\u0420\u0435\u0437\u0443\u043b\u044c\u0442\u0430\u0442\u044b \u0432\u043a\u043b\u044e\u0447\u0430\u044e\u0442:\n  \u2022 IP-\u0430\u0434\u0440\u0435\u0441\u0430 (A-\u0437\u0430\u043f\u0438\u0441\u0438)\n  \u2022 \u041e\u0431\u043d\u0430\u0440\u0443\u0436\u0435\u043d\u043d\u044b\u0435 \u043f\u043e\u0434\u0434\u043e\u043c\u0435\u043d\u044b\n  \u2022 \u0418\u043d\u0444\u043e\u0440\u043c\u0430\u0446\u0438\u044f WHOIS\n  \u2022 Geo-IP \u043b\u043e\u043a\u0430\u0446\u0438\u044f \u0441\u0435\u0440\u0432\u0435\u0440\u0430\n\n\u041d\u0430\u0436\u043c\u0438\u0442\u0435 \u042d\u043a\u0441\u043f\u043e\u0440\u0442 \u0434\u043b\u044f \u0441\u043e\u0445\u0440\u0430\u043d\u0435\u043d\u0438\u044f \u0440\u0435\u0437\u0443\u043b\u044c\u0442\u0430\u0442\u043e\u0432 \u0432 CSV."

    invoke-direct {p0, p1, v0}, Lcom/netwatch/app/MainActivity;->showInfoDialog(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    :cond_0
    const-string p1, "\ud83d\udd0d Domain Intel \u2014 Help"

    const-string v0, "Enter any domain name and tap Lookup.\n\nResults include:\n  \u2022 IP Addresses (A records)\n  \u2022 Subdomains detected\n  \u2022 WHOIS registration info\n  \u2022 Geo-IP location of the server\n\nTap Export to save results as a CSV file."

    invoke-direct {p0, p1, v0}, Lcom/netwatch/app/MainActivity;->showInfoDialog(Ljava/lang/String;Ljava/lang/String;)V

    :goto_0
    return v1

    :cond_1
    sget v0, Lcom/netwatch/app/R$id;->menu_instructions_traffic:I

    if-ne p1, v0, :cond_3

    iget-boolean p1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p1, :cond_2

    const-string p1, "\ud83d\udce1 \u041c\u043e\u043d\u0438\u0442\u043e\u0440 \u0442\u0440\u0430\u0444\u0438\u043a\u0430 \u2014 \u0421\u043f\u0440\u0430\u0432\u043a\u0430"

    const-string v0, "\u041c\u043e\u043d\u0438\u0442\u043e\u0440\u0438\u043d\u0433 \u0441\u0435\u0442\u0435\u0432\u044b\u0445 \u0441\u043e\u0435\u0434\u0438\u043d\u0435\u043d\u0438\u0439 \u0434\u043b\u044f \u043b\u044e\u0431\u043e\u0433\u043e \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u044f \u0438\u043b\u0438 \u0432\u0441\u0435\u0433\u043e \u0443\u0441\u0442\u0440\u043e\u0439\u0441\u0442\u0432\u0430.\n\n\u041a\u0430\u043a \u0438\u0441\u043f\u043e\u043b\u044c\u0437\u043e\u0432\u0430\u0442\u044c:\n  1. \u0412\u044b\u0431\u0435\u0440\u0438\u0442\u0435 \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u0435 \u0438\u0437 \u0441\u043f\u0438\u0441\u043a\u0430 (\u0438\u043b\u0438 \u00ab\u0412\u0441\u0451 \u0443\u0441\u0442\u0440\u043e\u0439\u0441\u0442\u0432\u043e\u00bb)\n  2. \u041d\u0430\u0436\u043c\u0438\u0442\u0435 \u0421\u0442\u0430\u0440\u0442 \u2014 \u0432\u044b\u0431\u0440\u0430\u043d\u043d\u043e\u0435 \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u0435 \u0437\u0430\u043f\u0443\u0441\u0442\u0438\u0442\u0441\u044f \u0430\u0432\u0442\u043e\u043c\u0430\u0442\u0438\u0447\u0435\u0441\u043a\u0438\n  3. NetWatch \u0444\u0438\u043a\u0441\u0438\u0440\u0443\u0435\u0442 \u0432\u0441\u0435 \u0438\u0441\u0445\u043e\u0434\u044f\u0449\u0438\u0435 \u0441\u043e\u0435\u0434\u0438\u043d\u0435\u043d\u0438\u044f \u0432 \u0440\u0435\u0430\u043b\u044c\u043d\u043e\u043c \u0432\u0440\u0435\u043c\u0435\u043d\u0438\n\n\u0412\u043e\u0437\u043c\u043e\u0436\u043d\u043e\u0441\u0442\u0438:\n  \u2022 Geo-IP \u043f\u043e\u0438\u0441\u043a \u0434\u043b\u044f \u043a\u0430\u0436\u0434\u043e\u0433\u043e \u0441\u043e\u0435\u0434\u0438\u043d\u0435\u043d\u0438\u044f\n  \u2022 \u041e\u0431\u043d\u0430\u0440\u0443\u0436\u0435\u043d\u0438\u0435 \u0441\u043c\u0435\u0436\u043d\u044b\u0445 \u0434\u043e\u043c\u0435\u043d\u043e\u0432 (CDN, \u043f\u043e\u0434\u0434\u043e\u043c\u0435\u043d\u044b)\n  \u2022 \u0412\u0438\u0431\u0440\u0430\u0446\u0438\u044f \u043f\u0440\u0438 \u0441\u043e\u0435\u0434\u0438\u043d\u0435\u043d\u0438\u0438 \u0441 \u043d\u0435\u0438\u0437\u0432\u0435\u0441\u0442\u043d\u044b\u043c \u0434\u043e\u043c\u0435\u043d\u043e\u043c\n  \u2022 \u042d\u043a\u0441\u043f\u043e\u0440\u0442 \u043b\u043e\u0433\u0430 \u0441\u043e\u0435\u0434\u0438\u043d\u0435\u043d\u0438\u0439 \u0432 \u0444\u043e\u0440\u043c\u0430\u0442\u0435 RFC 4180 CSV"

    invoke-direct {p0, p1, v0}, Lcom/netwatch/app/MainActivity;->showInfoDialog(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_1

    :cond_2
    const-string p1, "\ud83d\udce1 Traffic Monitor \u2014 Help"

    const-string v0, "Monitor live network connections for any installed app.\n\nHow to use:\n  1. Select an app from the dropdown\n  2. Tap Start \u2014 the selected app launches automatically\n  3. NetWatch captures all outbound connections in real-time\n\nFeatures:\n  \u2022 Geo-IP lookup for every connection\n  \u2022 Companion domain detection (CDNs, subdomains)\n  \u2022 Vibration alert for unknown/unlisted domains\n  \u2022 Export connection log as RFC 4180 CSV"

    invoke-direct {p0, p1, v0}, Lcom/netwatch/app/MainActivity;->showInfoDialog(Ljava/lang/String;Ljava/lang/String;)V

    :goto_1
    return v1

    :cond_3
    sget v0, Lcom/netwatch/app/R$id;->menu_instructions_checker:I

    if-ne p1, v0, :cond_5

    iget-boolean p1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p1, :cond_4

    const-string p1, "\u2705 \u041f\u0440\u043e\u0432\u0435\u0440\u043a\u0430 \u0434\u043e\u043c\u0435\u043d\u043e\u0432 \u2014 \u0421\u043f\u0440\u0430\u0432\u043a\u0430"

    const-string v0, "\u0411\u044b\u0441\u0442\u0440\u0430\u044f \u043f\u0440\u043e\u0432\u0435\u0440\u043a\u0430 \u0434\u043e\u0441\u0442\u0443\u043f\u043d\u043e\u0441\u0442\u0438 \u0438\u0437\u0432\u0435\u0441\u0442\u043d\u044b\u0445 \u0441\u0435\u0440\u0432\u0438\u0441\u043d\u044b\u0445 \u0434\u043e\u043c\u0435\u043d\u043e\u0432.\n\n\u041a\u0430\u0442\u0435\u0433\u043e\u0440\u0438\u0438:\n  \u2022 Microsoft, Google, Apple, Cloudflare\n  \u2022 \u0421\u043e\u0446\u0438\u0430\u043b\u044c\u043d\u044b\u0435 \u0441\u0435\u0442\u0438 \u0438 \u043c\u0435\u0441\u0441\u0435\u043d\u0434\u0436\u0435\u0440\u044b\n  \u2022 \u0424\u0438\u043d\u0430\u043d\u0441\u044b \u0438 \u043f\u043b\u0430\u0442\u0435\u0436\u0438\n  \u2022 \u0418\u0433\u0440\u044b (Xbox, PlayStation)\n\n\u0421\u0442\u0430\u0442\u0443\u0441 \u043a\u0430\u0436\u0434\u043e\u0433\u043e \u0434\u043e\u043c\u0435\u043d\u0430:\n  \ud83d\udfe2 \u0414\u043e\u0441\u0442\u0443\u043f\u0435\u043d  |  \ud83d\udd34 \u0417\u0430\u0431\u043b\u043e\u043a\u0438\u0440\u043e\u0432\u0430\u043d / \u041d\u0435\u0434\u043e\u0441\u0442\u0443\u043f\u0435\u043d\n\n\u041d\u0430\u0436\u043c\u0438\u0442\u0435 \u00ab\u041f\u0440\u043e\u0432\u0435\u0440\u0438\u0442\u044c \u0432\u0441\u0451\u00bb \u0434\u043b\u044f \u0437\u0430\u043f\u0443\u0441\u043a\u0430 \u0432\u0441\u0435\u0445 \u0442\u0435\u0441\u0442\u043e\u0432.\n\u0418\u0441\u043f\u043e\u043b\u044c\u0437\u0443\u0439\u0442\u0435 \u043f\u043e\u043b\u0435 \u0432\u0432\u043e\u0434\u0430 \u0432\u0432\u0435\u0440\u0445\u0443 \u0434\u043b\u044f \u043f\u0440\u043e\u0432\u0435\u0440\u043a\u0438 \u043b\u044e\u0431\u043e\u0433\u043e \u0434\u043e\u043c\u0435\u043d\u0430 \u0432\u0440\u0443\u0447\u043d\u0443\u044e."

    invoke-direct {p0, p1, v0}, Lcom/netwatch/app/MainActivity;->showInfoDialog(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_2

    :cond_4
    const-string p1, "\u2705 Domain Checker \u2014 Help"

    const-string v0, "Quickly verify connectivity to well-known service domains.\n\nCategories include:\n  \u2022 Microsoft, Google, Apple, Cloudflare\n  \u2022 Social & Messaging\n  \u2022 Finance & Payments\n  \u2022 Gaming (Xbox, PlayStation)\n\nEach domain shows a live status:\n  \ud83d\udfe2 Reachable  |  \ud83d\udd34 Blocked / Unreachable\n\nTap Check All to run all tests at once.\nUse the custom input at the top to test any domain manually."

    invoke-direct {p0, p1, v0}, Lcom/netwatch/app/MainActivity;->showInfoDialog(Ljava/lang/String;Ljava/lang/String;)V

    :goto_2
    return v1

    :cond_5
    sget v0, Lcom/netwatch/app/R$id;->menu_instructions_myinfo:I

    if-ne p1, v0, :cond_7

    iget-boolean p1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p1, :cond_6

    const-string p1, "\ud83c\udf10 \u041c\u043e\u0438 \u0434\u0430\u043d\u043d\u044b\u0435 \u2014 \u0421\u043f\u0440\u0430\u0432\u043a\u0430"

    const-string v0, "\u041e\u0442\u043e\u0431\u0440\u0430\u0436\u0430\u0435\u0442 \u0430\u043a\u0442\u0443\u0430\u043b\u044c\u043d\u0443\u044e \u0438\u043d\u0444\u043e\u0440\u043c\u0430\u0446\u0438\u044e \u043e \u0432\u0430\u0448\u0435\u043c \u0441\u0435\u0442\u0435\u0432\u043e\u043c \u043f\u043e\u0434\u043a\u043b\u044e\u0447\u0435\u043d\u0438\u0438.\n\n\u041f\u043e\u043a\u0430\u0437\u044b\u0432\u0430\u0435\u043c\u044b\u0435 \u0434\u0430\u043d\u043d\u044b\u0435:\n  \u2022 \u041f\u0443\u0431\u043b\u0438\u0447\u043d\u044b\u0439 IP-\u0430\u0434\u0440\u0435\u0441\n  \u2022 \u041f\u0440\u043e\u0432\u0430\u0439\u0434\u0435\u0440 / \u0421\u0435\u0442\u044c\n  \u2022 \u0413\u043e\u0440\u043e\u0434, \u0440\u0435\u0433\u0438\u043e\u043d, \u0441\u0442\u0440\u0430\u043d\u0430\n  \u2022 GPS-\u043a\u043e\u043e\u0440\u0434\u0438\u043d\u0430\u0442\u044b (\u043d\u0430\u0436\u043c\u0438\u0442\u0435 \u0434\u043b\u044f \u0432\u044b\u0431\u043e\u0440\u0430 \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u044f \u043a\u0430\u0440\u0442)\n  \u2022 \u0427\u0430\u0441\u043e\u0432\u043e\u0439 \u043f\u043e\u044f\u0441\n\n\u0414\u0430\u043d\u043d\u044b\u0435 \u043f\u043e\u043b\u0443\u0447\u0435\u043d\u044b \u043e\u0442 ipinfo.io.\n\u041d\u0430\u0436\u043c\u0438\u0442\u0435 \u041e\u0431\u043d\u043e\u0432\u0438\u0442\u044c \u0434\u043b\u044f \u0430\u043a\u0442\u0443\u0430\u043b\u0438\u0437\u0430\u0446\u0438\u0438 \u0438\u043d\u0444\u043e\u0440\u043c\u0430\u0446\u0438\u0438."

    invoke-direct {p0, p1, v0}, Lcom/netwatch/app/MainActivity;->showInfoDialog(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_3

    :cond_6
    const-string p1, "\ud83c\udf10 My Info \u2014 Help"

    const-string v0, "Displays live information about your current network connection.\n\nShown details:\n  \u2022 Public IP Address\n  \u2022 ISP / Network Provider\n  \u2022 City, Region, Country\n  \u2022 GPS Coordinates (tap to open in your preferred maps app)\n  \u2022 Timezone\n\nData is fetched from ipinfo.io.\nTap Refresh to update at any time."

    invoke-direct {p0, p1, v0}, Lcom/netwatch/app/MainActivity;->showInfoDialog(Ljava/lang/String;Ljava/lang/String;)V

    :goto_3
    return v1

    :cond_7
    sget v0, Lcom/netwatch/app/R$id;->menu_instructions_speed:I

    if-ne p1, v0, :cond_9

    iget-boolean p1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p1, :cond_8

    const-string p1, "\u26a1 \u0422\u0435\u0441\u0442 \u0441\u043a\u043e\u0440\u043e\u0441\u0442\u0438 \u2014 \u0421\u043f\u0440\u0430\u0432\u043a\u0430"

    const-string v0, "\u0418\u0437\u043c\u0435\u0440\u044f\u0435\u0442 \u0441\u043a\u043e\u0440\u043e\u0441\u0442\u044c \u0432\u0430\u0448\u0435\u0433\u043e \u0438\u043d\u0442\u0435\u0440\u043d\u0435\u0442-\u0441\u043e\u0435\u0434\u0438\u043d\u0435\u043d\u0438\u044f.\n\n\u041a\u0430\u043a \u043f\u043e\u043b\u044c\u0437\u043e\u0432\u0430\u0442\u044c\u0441\u044f:\n  1. \u0412\u044b\u0431\u0435\u0440\u0438\u0442\u0435 \u0441\u0435\u0440\u0432\u0435\u0440 \u0438\u0437 \u0441\u043f\u0438\u0441\u043a\u0430\n  2. \u041d\u0430\u0436\u043c\u0438\u0442\u0435 \u0417\u0430\u043f\u0443\u0441\u0442\u0438\u0442\u044c \u0442\u0435\u0441\u0442\n  3. \u0414\u043e\u0436\u0434\u0438\u0442\u0435\u0441\u044c \u0440\u0435\u0437\u0443\u043b\u044c\u0442\u0430\u0442\u043e\u0432\n\n\u0420\u0435\u0437\u0443\u043b\u044c\u0442\u0430\u0442\u044b:\n  \u2022 \u041f\u0438\u043d\u0433 \u2014 \u0437\u0430\u0434\u0435\u0440\u0436\u043a\u0430 (\u0437\u0435\u043b\u0451\u043d\u044b\u0439 < 50\u043c\u0441)\n  \u2022 \u0417\u0430\u0433\u0440\u0443\u0437\u043a\u0430 \u2014 \u0441\u043a\u043e\u0440\u043e\u0441\u0442\u044c \u0432\u0445\u043e\u0434\u044f\u0449\u0435\u0433\u043e \u0442\u0440\u0430\u0444\u0438\u043a\u0430\n  \u2022 \u041e\u0442\u0434\u0430\u0447\u0430 \u2014 \u0441\u043a\u043e\u0440\u043e\u0441\u0442\u044c \u0438\u0441\u0445\u043e\u0434\u044f\u0449\u0435\u0433\u043e \u0442\u0440\u0430\u0444\u0438\u043a\u0430\n\n\u0421\u0435\u0440\u0432\u0435\u0440\u044b: \u0421\u0428\u0410, \u041a\u0430\u043d\u0430\u0434\u0430, \u0415\u0432\u0440\u043e\u043f\u0430, \u0410\u0437\u0438\u044f, \u0420\u043e\u0441\u0441\u0438\u044f."

    invoke-direct {p0, p1, v0}, Lcom/netwatch/app/MainActivity;->showInfoDialog(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_4

    :cond_8
    const-string p1, "\u26a1 Speed Test \u2014 Help"

    const-string v0, "Measures your internet connection speed.\n\nHow to use:\n  1. Select a server from the dropdown\n  2. Tap Run Speed Test\n  3. Wait for results\n\nResults explained:\n  \u2022 Ping \u2014 latency in ms (green < 50ms)\n  \u2022 Download \u2014 incoming data speed\n  \u2022 Upload \u2014 outgoing data speed\n\nServer providers:\n  \u2022 Ookla \u2014 7 US cities (NYC, LA, Chicago,\n    Dallas, Miami, Seattle, Atlanta)\n  \u2022 Linode/Akamai \u2014 US, Canada, EU, Asia\n  \u2022 MTS \u2014 Russia (Moscow)\n  \u2022 Cloudflare \u2014 Global\n\n16 servers total."

    invoke-direct {p0, p1, v0}, Lcom/netwatch/app/MainActivity;->showInfoDialog(Ljava/lang/String;Ljava/lang/String;)V

    :goto_4
    return v1

    :cond_9
    sget v0, Lcom/netwatch/app/R$id;->menu_language:I

    if-ne p1, v0, :cond_a

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->showLanguageDialog()V

    return v1

    :cond_a
    sget v0, Lcom/netwatch/app/R$id;->menu_about:I

    const/4 v2, 0x0

    if-ne p1, v0, :cond_c

    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object p1

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0, v2}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object p1

    iget-object p1, p1, Landroid/content/pm/PackageInfo;->versionName:Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_5

    :catch_0
    const-string p1, "1.4.5"

    :goto_5
    iget-boolean v0, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v0, :cond_b

    const-string v0, "\u25c8 NETWATCH\n\u0412\u0435\u0440\u0441\u0438\u044f "

    const-string v2, "\n\n\u041f\u0440\u043e\u0444\u0435\u0441\u0441\u0438\u043e\u043d\u0430\u043b\u044c\u043d\u044b\u0439 \u0438\u043d\u0441\u0442\u0440\u0443\u043c\u0435\u043d\u0442 \u0441\u0435\u0442\u0435\u0432\u043e\u0439 \u0440\u0430\u0437\u0432\u0435\u0434\u043a\u0438 \u0434\u043b\u044f Android.\n\n\u0412\u043e\u0437\u043c\u043e\u0436\u043d\u043e\u0441\u0442\u0438:\n  \u2022 \u0410\u043d\u0430\u043b\u0438\u0437 \u0434\u043e\u043c\u0435\u043d\u043e\u0432 \u0438 WHOIS-\u0437\u0430\u043f\u0440\u043e\u0441\u044b\n  \u2022 \u041c\u043e\u043d\u0438\u0442\u043e\u0440\u0438\u043d\u0433 \u0442\u0440\u0430\u0444\u0438\u043a\u0430 \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u0439 \u0432 \u0440\u0435\u0430\u043b\u044c\u043d\u043e\u043c \u0432\u0440\u0435\u043c\u0435\u043d\u0438\n  \u2022 \u041f\u0440\u043e\u0432\u0435\u0440\u043a\u0430 \u0434\u043e\u0441\u0442\u0443\u043f\u043d\u043e\u0441\u0442\u0438 \u0434\u043e\u043c\u0435\u043d\u043e\u0432\n  \u2022 \u0410\u043a\u0442\u0443\u0430\u043b\u044c\u043d\u0430\u044f \u0438\u043d\u0444\u043e\u0440\u043c\u0430\u0446\u0438\u044f \u043e \u0441\u0435\u0442\u0438 \u0438 Geo-IP\n  \u2022 \u0422\u0435\u0441\u0442 \u0441\u043a\u043e\u0440\u043e\u0441\u0442\u0438 \u0438\u043d\u0442\u0435\u0440\u043d\u0435\u0442\u0430\n\n\u0421\u043e\u0437\u0434\u0430\u043d\u043e \u0441 \u2764\ufe0f \u0441 \u043f\u043e\u043c\u043e\u0449\u044c\u044e Base44 Superagent."

    invoke-static {v0, p1, v2}, Landroidx/activity/result/a;->f(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    const-string v0, "\u2139\ufe0f \u041e \u043f\u0440\u043e\u0433\u0440\u0430\u043c\u043c\u0435 NetWatch"

    invoke-direct {p0, v0, p1}, Lcom/netwatch/app/MainActivity;->showInfoDialog(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_6

    :cond_b
    const-string v0, "\u25c8 NETWATCH\nVersion "

    const-string v2, "\n\nA professional-grade network intelligence tool for Android.\n\nFeatures:\n  \u2022 Domain Intelligence & WHOIS lookup\n  \u2022 Real-time per-app traffic monitoring\n  \u2022 Domain reachability checker\n  \u2022 Live network & geo-IP info\n  \u2022 Internet speed test\n\nBuilt with \u2764\ufe0f using Base44 Superagent."

    invoke-static {v0, p1, v2}, Landroidx/activity/result/a;->f(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    const-string v0, "\u2139\ufe0f About NetWatch"

    invoke-direct {p0, v0, p1}, Lcom/netwatch/app/MainActivity;->showInfoDialog(Ljava/lang/String;Ljava/lang/String;)V

    :goto_6
    return v1

    :cond_c
    return v2
.end method

.method private synthetic lambda$startDomainCheck$39(ILjava/util/List;Ljava/lang/String;)V
    .locals 2

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->checkStatusText:Landroid/widget/TextView;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-boolean p0, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p0, :cond_0

    const-string p0, "\u041f\u0440\u043e\u0432\u0435\u0440\u043a\u0430 "

    goto :goto_0

    :cond_0
    const-string p0, "Checking "

    :goto_0
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "/"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u2014 "

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method

.method private synthetic lambda$startDomainCheck$40(Ljava/lang/String;ZJ)V
    .locals 0

    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->checkerStatusViews:Ljava/util/Map;

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/widget/TextView;

    if-nez p0, :cond_0

    return-void

    :cond_0
    if-eqz p2, :cond_1

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, p3, p4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p3, " ms"

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    goto :goto_0

    :cond_1
    const-string p1, "BLOCKED"

    :goto_0
    invoke-virtual {p0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const-string p1, "#EF5350"

    const-string p3, "#66BB6A"

    if-eqz p2, :cond_2

    invoke-static {p3}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p4

    goto :goto_1

    :cond_2
    invoke-static {p1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p4

    :goto_1
    invoke-virtual {p0, p4}, Landroid/widget/TextView;->setTextColor(I)V

    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    instance-of p4, p0, Landroid/widget/LinearLayout;

    if-eqz p4, :cond_4

    check-cast p0, Landroid/widget/LinearLayout;

    invoke-virtual {p0}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object p0

    instance-of p4, p0, Landroid/widget/TextView;

    if-eqz p4, :cond_4

    check-cast p0, Landroid/widget/TextView;

    if-eqz p2, :cond_3

    invoke-static {p3}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p1

    goto :goto_2

    :cond_3
    invoke-static {p1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p1

    :goto_2
    invoke-virtual {p0, p1}, Landroid/widget/TextView;->setTextColor(I)V

    :cond_4
    return-void
.end method

.method private synthetic lambda$startDomainCheck$41(ILjava/util/List;II)V
    .locals 3

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->checkRunning:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->checkAllBtn:Landroid/widget/Button;

    const/4 v2, 0x1

    invoke-virtual {v0, v2}, Landroid/view/View;->setEnabled(Z)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->stopCheckBtn:Landroid/widget/Button;

    invoke-virtual {v0, v1}, Landroid/view/View;->setEnabled(Z)V

    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result p2

    if-ne p1, p2, :cond_1

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->checkStatusText:Landroid/widget/TextView;

    iget-boolean p2, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p2, :cond_0

    new-instance p2, Ljava/lang/StringBuilder;

    const-string v0, "\u0413\u043e\u0442\u043e\u0432\u043e \u2014 \u2705 "

    invoke-direct {p2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p3, " \u0434\u043e\u0441\u0442\u0443\u043f\u043d\u043e   \ud83d\udeab "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p3, " \u0437\u0430\u0431\u043b\u043e\u043a\u0438\u0440\u043e\u0432\u0430\u043d\u043e"

    :goto_0
    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    goto :goto_1

    :cond_0
    new-instance p2, Ljava/lang/StringBuilder;

    const-string v0, "Done \u2014 \u2705 "

    invoke-direct {p2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p3, " reachable   \ud83d\udeab "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p3, " blocked"

    goto :goto_0

    :goto_1
    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_4

    :cond_1
    iget-object p2, p0, Lcom/netwatch/app/MainActivity;->checkStatusText:Landroid/widget/TextView;

    iget-boolean v0, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    const-string v1, "  \ud83d\udeab "

    if-eqz v0, :cond_2

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v2, "\u041e\u0441\u0442\u0430\u043d\u043e\u0432\u043b\u0435\u043d\u043e \u2014 \u2705 "

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p3, " (\u0438\u0437 "

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " \u043f\u0440\u043e\u0432\u0435\u0440\u0435\u043d\u043e)"

    :goto_2
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    goto :goto_3

    :cond_2
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v2, "Stopped \u2014 \u2705 "

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p3, " (of "

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " checked)"

    goto :goto_2

    :goto_3
    invoke-virtual {p2, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :goto_4
    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->checkStatusText:Landroid/widget/TextView;

    if-lez p4, :cond_3

    const-string p1, "#EF9A9A"

    :goto_5
    invoke-static {p1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p1

    goto :goto_6

    :cond_3
    const-string p1, "#66BB6A"

    goto :goto_5

    :goto_6
    invoke-virtual {p0, p1}, Landroid/widget/TextView;->setTextColor(I)V

    return-void
.end method

.method private synthetic lambda$startDomainCheck$42(Ljava/util/List;)V
    .locals 14

    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    const/4 v1, 0x0

    move v4, v1

    move v6, v4

    move v7, v6

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_3

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, [Ljava/lang/String;

    iget-object v3, p0, Lcom/netwatch/app/MainActivity;->checkRunning:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v3}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v3

    if-nez v3, :cond_0

    goto :goto_3

    :cond_0
    aget-object v3, v2, v1

    const/4 v3, 0x1

    aget-object v10, v2, v3

    add-int/lit8 v4, v4, 0x1

    iget-object v2, p0, Lcom/netwatch/app/MainActivity;->mainHandler:Landroid/os/Handler;

    new-instance v5, Lcom/netwatch/app/c;

    invoke-direct {v5, p0, v4, p1, v10}, Lcom/netwatch/app/c;-><init>(Lcom/netwatch/app/MainActivity;ILjava/util/List;Ljava/lang/String;)V

    invoke-virtual {v2, v5}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    invoke-direct {p0, v10}, Lcom/netwatch/app/MainActivity;->probeHost(Ljava/lang/String;)[J

    move-result-object v2

    aget-wide v8, v2, v1

    const-wide/16 v11, 0x1

    cmp-long v5, v8, v11

    if-nez v5, :cond_1

    move v11, v3

    goto :goto_1

    :cond_1
    move v11, v1

    :goto_1
    aget-wide v12, v2, v3

    if-eqz v11, :cond_2

    add-int/lit8 v6, v6, 0x1

    goto :goto_2

    :cond_2
    add-int/lit8 v7, v7, 0x1

    :goto_2
    iget-object v2, p0, Lcom/netwatch/app/MainActivity;->mainHandler:Landroid/os/Handler;

    new-instance v3, Lcom/netwatch/app/d;

    move-object v8, v3

    move-object v9, p0

    invoke-direct/range {v8 .. v13}, Lcom/netwatch/app/d;-><init>(Lcom/netwatch/app/MainActivity;Ljava/lang/String;ZJ)V

    invoke-virtual {v2, v3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    goto :goto_0

    :cond_3
    :goto_3
    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->mainHandler:Landroid/os/Handler;

    new-instance v1, Lcom/netwatch/app/e;

    move-object v2, v1

    move-object v3, p0

    move-object v5, p1

    invoke-direct/range {v2 .. v7}, Lcom/netwatch/app/e;-><init>(Lcom/netwatch/app/MainActivity;ILjava/util/List;II)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private synthetic lambda$updateStats$29()V
    .locals 1

    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->hostLogScroll:Landroid/widget/ScrollView;

    const/16 v0, 0x82

    invoke-virtual {p0, v0}, Landroid/widget/ScrollView;->fullScroll(I)Z

    return-void
.end method

.method private launchApp(Ljava/lang/String;)V
    .locals 2

    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    invoke-virtual {v0, p1}, Landroid/content/pm/PackageManager;->getLaunchIntentForPackage(Ljava/lang/String;)Landroid/content/Intent;

    move-result-object p1

    if-eqz p1, :cond_0

    const/high16 v0, 0x10000000

    invoke-virtual {p1, v0}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    invoke-virtual {p0, p1}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    goto :goto_2

    :catch_0
    move-exception p1

    goto :goto_1

    :cond_0
    iget-boolean p1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p1, :cond_1

    const-string p1, "\u041d\u0435\u0432\u043e\u0437\u043c\u043e\u0436\u043d\u043e \u0437\u0430\u043f\u0443\u0441\u0442\u0438\u0442\u044c \u2014 \u0444\u043e\u043d\u043e\u0432\u044b\u0439 \u0441\u0435\u0440\u0432\u0438\u0441"

    goto :goto_0

    :cond_1
    const-string p1, "Can\'t launch \u2014 app may be a background service"

    :goto_0
    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->showToast(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_2

    :goto_1
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "Could not open app: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->showToast(Ljava/lang/String;)V

    :goto_2
    return-void
.end method

.method private launchDeviceVpn()V
    .locals 4

    new-instance v0, Lcom/netwatch/app/MainActivity$3;

    invoke-direct {v0, p0}, Lcom/netwatch/app/MainActivity$3;-><init>(Lcom/netwatch/app/MainActivity;)V

    iput-object v0, p0, Lcom/netwatch/app/MainActivity;->deviceReceiver:Landroid/content/BroadcastReceiver;

    invoke-static {p0}, Landroidx/localbroadcastmanager/content/LocalBroadcastManager;->getInstance(Landroid/content/Context;)Landroidx/localbroadcastmanager/content/LocalBroadcastManager;

    move-result-object v0

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->deviceReceiver:Landroid/content/BroadcastReceiver;

    new-instance v2, Landroid/content/IntentFilter;

    const-string v3, "com.netwatch.app.DEVICE_TRAFFIC"

    invoke-direct {v2, v3}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v1, v2}, Landroidx/localbroadcastmanager/content/LocalBroadcastManager;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)V

    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/netwatch/app/NetWatchVpnService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p0, v0}, Landroid/content/Context;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/netwatch/app/MainActivity;->deviceMonRunning:Z

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->deviceToggleBtn:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_0

    const-string v1, "\u23f9 \u0421\u0442\u043e\u043f"

    goto :goto_0

    :cond_0
    const-string v1, "\u23f9 Stop"

    :goto_0
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->deviceToggleBtn:Landroid/widget/Button;

    sget v1, Lcom/netwatch/app/R$drawable;->btn_danger:I

    invoke-virtual {v0, v1}, Landroid/view/View;->setBackgroundResource(I)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->deviceStatusText:Landroid/widget/TextView;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_1

    const-string v1, "\u25cf \u0410\u043a\u0442\u0438\u0432\u0435\u043d"

    goto :goto_1

    :cond_1
    const-string v1, "\u25cf Active"

    :goto_1
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->deviceStatusText:Landroid/widget/TextView;

    const-string v1, "#00FF88"

    invoke-static {v1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->deviceHeaderRow:Landroid/widget/LinearLayout;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->deviceClearBtn:Landroid/widget/Button;

    invoke-virtual {p0, v1}, Landroid/view/View;->setVisibility(I)V

    return-void
.end method

.method private loadAppList()V
    .locals 3

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->executor:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/netwatch/app/l;

    const/4 v2, 0x1

    invoke-direct {v1, p0, v2}, Lcom/netwatch/app/l;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/Executor;->execute(Ljava/lang/Runnable;)V

    return-void
.end method

.method private lookupMyInfo()V
    .locals 3

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->myInfoContainer:Landroid/widget/LinearLayout;

    invoke-virtual {v0}, Landroid/view/ViewGroup;->removeAllViews()V

    const-string v0, ""

    const-string v1, "#0D1117"

    const-string v2, "\u23f3 Looking up your public IP\u2026"

    invoke-direct {p0, v2, v0, v1}, Lcom/netwatch/app/MainActivity;->addMyInfoRow(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->myInfoRefreshBtn:Landroid/widget/Button;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/View;->setEnabled(Z)V

    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/netwatch/app/l;

    const/4 v2, 0x3

    invoke-direct {v1, p0, v2}, Lcom/netwatch/app/l;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method public static synthetic m(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$7(Landroid/view/View;)V

    return-void
.end method

.method private makeCardContainer()Landroid/widget/LinearLayout;
    .locals 5

    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    sget v1, Lcom/netwatch/app/R$drawable;->card_background:I

    invoke-virtual {v0, v1}, Landroid/view/View;->setBackgroundResource(I)V

    const/16 v1, 0xe

    invoke-direct {p0, v1}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v2

    const/16 v3, 0xc

    invoke-direct {p0, v3}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v4

    invoke-direct {p0, v1}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v1

    invoke-direct {p0, v3}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result v3

    invoke-virtual {v0, v2, v4, v1, v3}, Landroid/view/View;->setPadding(IIII)V

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v2, -0x1

    const/4 v3, -0x2

    invoke-direct {v1, v2, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/16 v2, 0xa

    invoke-direct {p0, v2}, Lcom/netwatch/app/MainActivity;->dp(I)I

    move-result p0

    iput p0, v1, Landroid/widget/LinearLayout$LayoutParams;->bottomMargin:I

    invoke-virtual {v0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    return-object v0
.end method

.method public static synthetic n(Lcom/netwatch/app/MainActivity;Landroid/widget/TextView;ZJLandroid/widget/TextView;Ljava/lang/String;)V
    .locals 0

    invoke-direct/range {p0 .. p6}, Lcom/netwatch/app/MainActivity;->lambda$checkCustomDomain$43(Landroid/widget/TextView;ZJLandroid/widget/TextView;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic o(Ljava/lang/String;)Z
    .locals 0

    invoke-static {p0}, Lcom/netwatch/app/MainActivity;->lambda$seedTrustedDomains$31(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public static synthetic p(Lcom/netwatch/app/MainActivity;ILjava/util/List;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/netwatch/app/MainActivity;->lambda$startDomainCheck$39(ILjava/util/List;Ljava/lang/String;)V

    return-void
.end method

.method private static packageToRootDomain(Ljava/lang/String;)Ljava/lang/String;
    .locals 3

    const/4 v0, 0x0

    if-eqz p0, :cond_4

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    goto :goto_1

    :cond_0
    const-string v1, "\\."

    invoke-virtual {p0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    array-length v1, p0

    const/4 v2, 0x2

    if-ge v1, v2, :cond_1

    return-object v0

    :cond_1
    const/4 v0, 0x0

    aget-object v0, p0, v0

    const/4 v1, 0x1

    aget-object p0, p0, v1

    const-string v1, "com"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_3

    const-string v1, "org"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_3

    const-string v1, "io"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    goto :goto_0

    :cond_2
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "."

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_3
    :goto_0
    const-string v0, ".com"

    invoke-static {p0, v0}, Landroidx/activity/result/a;->e(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_4
    :goto_1
    return-object v0
.end method

.method private performLookup()V
    .locals 4

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->domainInput:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_1

    iget-boolean v0, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v0, :cond_0

    const-string v0, "\u0412\u0432\u0435\u0434\u0438\u0442\u0435 \u0434\u043e\u043c\u0435\u043d"

    goto :goto_0

    :cond_0
    const-string v0, "Enter a domain"

    :goto_0
    invoke-direct {p0, v0}, Lcom/netwatch/app/MainActivity;->showToast(Ljava/lang/String;)V

    return-void

    :cond_1
    const-string v1, "(?i)https?://"

    const-string v2, ""

    invoke-virtual {v0, v1, v2}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "/.*"

    invoke-virtual {v0, v1, v2}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->resultsContainer:Landroid/widget/LinearLayout;

    invoke-virtual {v1}, Landroid/view/ViewGroup;->removeAllViews()V

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->statusText:Landroid/widget/TextView;

    iget-boolean v2, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    const-string v3, " \u2026"

    if-eqz v2, :cond_2

    const-string v2, "\u23f3  \u0421\u043a\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0438\u0435 "

    :goto_1
    invoke-static {v2, v0, v3}, Landroidx/activity/result/a;->f(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    goto :goto_2

    :cond_2
    const-string v2, "\u23f3  Scanning "

    goto :goto_1

    :goto_2
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->lookupBtn:Landroid/widget/Button;

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/view/View;->setEnabled(Z)V

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->executor:Ljava/util/concurrent/ExecutorService;

    new-instance v2, Landroidx/constraintlayout/motion/widget/a;

    const/4 v3, 0x4

    invoke-direct {v2, v3, p0, v0}, Landroidx/constraintlayout/motion/widget/a;-><init>(ILjava/lang/Object;Ljava/lang/Object;)V

    invoke-interface {v1, v2}, Ljava/util/concurrent/Executor;->execute(Ljava/lang/Runnable;)V

    return-void
.end method

.method private postJson(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    :try_start_0
    new-instance p0, Ljava/net/URL;

    invoke-direct {p0, p1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object p0

    check-cast p0, Ljava/net/HttpURLConnection;

    const-string p1, "POST"

    invoke-virtual {p0, p1}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    const-string p1, "Content-Type"

    const-string v0, "application/json"

    invoke-virtual {p0, p1, v0}, Ljava/net/URLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    const/4 p1, 0x1

    invoke-virtual {p0, p1}, Ljava/net/URLConnection;->setDoOutput(Z)V

    const/16 p1, 0x3a98

    invoke-virtual {p0, p1}, Ljava/net/URLConnection;->setConnectTimeout(I)V

    const/16 p1, 0x7530

    invoke-virtual {p0, p1}, Ljava/net/URLConnection;->setReadTimeout(I)V

    invoke-virtual {p0}, Ljava/net/URLConnection;->getOutputStream()Ljava/io/OutputStream;

    move-result-object p1
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :try_start_1
    const-string v0, "UTF-8"

    invoke-virtual {p2, v0}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/OutputStream;->write([B)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :try_start_2
    invoke-virtual {p1}, Ljava/io/OutputStream;->close()V

    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result p1

    new-instance p2, Ljava/io/BufferedReader;

    new-instance v0, Ljava/io/InputStreamReader;

    const/16 v1, 0xc8

    if-lt p1, v1, :cond_0

    const/16 v1, 0x12c

    if-ge p1, v1, :cond_0

    invoke-virtual {p0}, Ljava/net/URLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object p0

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getErrorStream()Ljava/io/InputStream;

    move-result-object p0

    :goto_0
    invoke-direct {v0, p0}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V

    invoke-direct {p2, v0}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    :goto_1
    invoke-virtual {p2}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object p1

    if-eqz p1, :cond_1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_1

    :cond_1
    invoke-virtual {p2}, Ljava/io/BufferedReader;->close()V

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    return-object p0

    :catchall_0
    move-exception p0

    if-eqz p1, :cond_2

    :try_start_3
    invoke-virtual {p1}, Ljava/io/OutputStream;->close()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    goto :goto_2

    :catchall_1
    move-exception p1

    :try_start_4
    invoke-virtual {p0, p1}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_2
    :goto_2
    throw p0
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_0

    :catch_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private probeHost(Ljava/lang/String;)[J
    .locals 13

    const-string p0, "https://"

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    const-wide/16 v2, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x2

    const/4 v6, 0x1

    :try_start_0
    const-string v7, "\\d+\\.\\d+\\.\\d+\\.\\d+"

    invoke-virtual {p1, v7}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v7

    const-wide/16 v8, 0x1

    const/16 v10, 0xbb8

    if-eqz v7, :cond_2

    invoke-static {p1}, Ljava/net/InetAddress;->getByName(Ljava/lang/String;)Ljava/net/InetAddress;

    move-result-object p0

    invoke-virtual {p0, v10}, Ljava/net/InetAddress;->isReachable(I)Z

    move-result p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_2

    if-nez p0, :cond_0

    :try_start_1
    new-instance v7, Ljava/net/Socket;

    invoke-direct {v7}, Ljava/net/Socket;-><init>()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    :try_start_2
    new-instance v11, Ljava/net/InetSocketAddress;

    const/16 v12, 0x35

    invoke-direct {v11, p1, v12}, Ljava/net/InetSocketAddress;-><init>(Ljava/lang/String;I)V

    invoke-virtual {v7, v11, v10}, Ljava/net/Socket;->connect(Ljava/net/SocketAddress;I)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    :try_start_3
    invoke-virtual {v7}, Ljava/net/Socket;->close()V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0

    :catch_0
    move p0, v6

    goto :goto_1

    :catchall_0
    move-exception p1

    :try_start_4
    invoke-virtual {v7}, Ljava/net/Socket;->close()V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    goto :goto_0

    :catchall_1
    move-exception v7

    :try_start_5
    invoke-virtual {p1, v7}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_0
    throw p1
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_1

    :catch_1
    :cond_0
    :goto_1
    :try_start_6
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v10

    sub-long/2addr v10, v0

    new-array p1, v5, [J

    if-eqz p0, :cond_1

    goto :goto_2

    :cond_1
    move-wide v8, v2

    :goto_2
    aput-wide v8, p1, v4

    aput-wide v10, p1, v6

    return-object p1

    :cond_2
    invoke-static {p1}, Ljava/net/InetAddress;->getByName(Ljava/lang/String;)Ljava/net/InetAddress;

    new-instance v7, Ljava/net/URL;

    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v11, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "/"

    invoke-virtual {v11, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v7, p0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v7}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object p0

    check-cast p0, Ljava/net/HttpURLConnection;

    const-string p1, "HEAD"

    invoke-virtual {p0, p1}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    invoke-virtual {p0, v10}, Ljava/net/URLConnection;->setConnectTimeout(I)V

    invoke-virtual {p0, v10}, Ljava/net/URLConnection;->setReadTimeout(I)V

    invoke-virtual {p0, v6}, Ljava/net/HttpURLConnection;->setInstanceFollowRedirects(Z)V

    invoke-virtual {p0}, Ljava/net/URLConnection;->connect()V

    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result p1

    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->disconnect()V

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v10

    sub-long/2addr v10, v0

    new-array p0, v5, [J

    if-lez p1, :cond_3

    goto :goto_3

    :cond_3
    move-wide v8, v2

    :goto_3
    aput-wide v8, p0, v4

    aput-wide v10, p0, v6
    :try_end_6
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_6} :catch_2

    return-object p0

    :catch_2
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide p0

    sub-long/2addr p0, v0

    new-array v0, v5, [J

    aput-wide v2, v0, v4

    aput-wide p0, v0, v6

    return-object v0
.end method

.method public static synthetic q(Lcom/netwatch/app/MainActivity;Ljava/util/List;Ljava/util/List;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/netwatch/app/MainActivity;->lambda$buildReport$35(Ljava/util/List;Ljava/util/List;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic r(Lcom/netwatch/app/MainActivity;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->lambda$lookupMyInfo$38()V

    return-void
.end method

.method private refreshDeviceLog()V
    .locals 13

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->deviceLogContainer:Landroid/widget/LinearLayout;

    invoke-virtual {v0}, Landroid/view/ViewGroup;->removeAllViews()V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->deviceLog:Ljava/util/ArrayList;

    monitor-enter v0

    :try_start_0
    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->deviceLog:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    iget-object v2, p0, Lcom/netwatch/app/MainActivity;->deviceLog:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v2

    add-int/lit8 v2, v2, -0x1

    :goto_0
    const/4 v3, 0x4

    const/4 v4, 0x0

    if-ltz v2, :cond_1

    iget-object v5, p0, Lcom/netwatch/app/MainActivity;->deviceLog:Ljava/util/ArrayList;

    invoke-virtual {v5, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, [Ljava/lang/String;

    array-length v6, v5

    const/4 v7, 0x5

    if-le v6, v7, :cond_0

    aget-object v6, v5, v7

    :goto_1
    move-object v12, v6

    goto :goto_2

    :catchall_0
    move-exception p0

    goto :goto_4

    :cond_0
    const-string v6, ""

    goto :goto_1

    :goto_2
    iget-object v6, p0, Lcom/netwatch/app/MainActivity;->deviceLogContainer:Landroid/widget/LinearLayout;

    aget-object v8, v5, v4

    const/4 v4, 0x2

    aget-object v9, v5, v4

    const/4 v4, 0x3

    aget-object v10, v5, v4

    aget-object v11, v5, v3

    move-object v7, p0

    invoke-direct/range {v7 .. v12}, Lcom/netwatch/app/MainActivity;->buildDeviceRow(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/view/View;

    move-result-object v3

    invoke-virtual {v6, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    add-int/lit8 v2, v2, -0x1

    goto :goto_0

    :cond_1
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->deviceCountText:Landroid/widget/TextView;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    iget-boolean v5, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v5, :cond_2

    const-string v5, " \u0441\u043e\u0435\u0434\u0438\u043d\u0435\u043d\u0438\u0439"

    goto :goto_3

    :cond_2
    const-string v5, " connections"

    :goto_3
    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    if-lez v1, :cond_3

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->deviceExportBtn:Landroid/widget/Button;

    invoke-virtual {v0, v4}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->deviceClearBtn:Landroid/widget/Button;

    invoke-virtual {v0, v4}, Landroid/view/View;->setVisibility(I)V

    :cond_3
    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->deviceScrollView:Landroid/widget/ScrollView;

    new-instance v1, Lcom/netwatch/app/l;

    invoke-direct {v1, p0, v3}, Lcom/netwatch/app/l;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v0, v1}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    return-void

    :goto_4
    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method private refreshTabLabels()V
    .locals 2

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->tabDomainBtn:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_0

    const-string v1, "\ud83d\udd0d \u0414\u043e\u043c\u0435\u043d\u044b"

    goto :goto_0

    :cond_0
    const-string v1, "\ud83d\udd0d Domain Intel"

    :goto_0
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->tabTrafficBtn:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_1

    const-string v1, "\ud83d\udce1 \u0422\u0440\u0430\u0444\u0438\u043a"

    goto :goto_1

    :cond_1
    const-string v1, "\ud83d\udce1 Traffic"

    :goto_1
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->tabCheckerBtn:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_2

    const-string v1, "\u2705 \u041f\u0440\u043e\u0432\u0435\u0440\u043a\u0430"

    goto :goto_2

    :cond_2
    const-string v1, "\u2705 Checker"

    :goto_2
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->tabMyInfoBtn:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_3

    const-string v1, "\ud83c\udf10 \u041c\u043e\u0439 IP"

    goto :goto_3

    :cond_3
    const-string v1, "\ud83c\udf10 My Info"

    :goto_3
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->tabSpeedBtn:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_4

    const-string v1, "\u26a1 \u0421\u043a\u043e\u0440\u043e\u0441\u0442\u044c"

    goto :goto_4

    :cond_4
    const-string v1, "\u26a1 Speed"

    :goto_4
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->tabDeviceBtn:Landroid/widget/Button;

    if-eqz v0, :cond_6

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_5

    const-string v1, "\ud83d\udcf6 \u0423\u0441\u0442\u0440\u043e\u0439\u0441\u0442\u0432\u043e"

    goto :goto_5

    :cond_5
    const-string v1, "\ud83d\udcf6 Device"

    :goto_5
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_6
    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->deviceTitleText:Landroid/widget/TextView;

    if-eqz v0, :cond_8

    iget-boolean p0, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p0, :cond_7

    const-string p0, "\ud83d\udcf6 \u041c\u043e\u043d\u0438\u0442\u043e\u0440 \u0443\u0441\u0442\u0440\u043e\u0439\u0441\u0442\u0432\u0430"

    goto :goto_6

    :cond_7
    const-string p0, "\ud83d\udcf6 Device Monitor"

    :goto_6
    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_8
    return-void
.end method

.method private refreshUiStrings()V
    .locals 4

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->domainInput:Landroid/widget/EditText;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_0

    const-string v1, "\u0412\u0432\u0435\u0434\u0438\u0442\u0435 \u0434\u043e\u043c\u0435\u043d (\u043d\u0430\u043f\u0440. paypal.com)"

    goto :goto_0

    :cond_0
    const-string v1, "Enter domain (e.g. paypal.com)"

    :goto_0
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setHint(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->lookupBtn:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_1

    const-string v1, "\u0421\u041a\u0410\u041d"

    goto :goto_1

    :cond_1
    const-string v1, "SCAN"

    :goto_1
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->statusText:Landroid/widget/TextView;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_2

    const-string v1, "\u0412\u0432\u0435\u0434\u0438\u0442\u0435 \u0434\u043e\u043c\u0435\u043d \u0438 \u043d\u0430\u0436\u043c\u0438\u0442\u0435 \u0421\u041a\u0410\u041d"

    goto :goto_2

    :cond_2
    const-string v1, "Enter a domain and tap SCAN"

    :goto_2
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->exportDomainBtn:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    const-string v2, "\u2b06 Export"

    const-string v3, "\u2b06 \u042d\u043a\u0441\u043f\u043e\u0440\u0442"

    if-eqz v1, :cond_3

    move-object v1, v3

    goto :goto_3

    :cond_3
    move-object v1, v2

    :goto_3
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->startMonBtn:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_4

    const-string v1, "\u25b6  \u0421\u0422\u0410\u0420\u0422"

    goto :goto_4

    :cond_4
    const-string v1, "\u25b6  START"

    :goto_4
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->stopMonBtn:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_5

    const-string v1, "\u25a0  \u0421\u0422\u041e\u041f"

    goto :goto_5

    :cond_5
    const-string v1, "\u25a0  STOP"

    :goto_5
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->exportTrafficBtn:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_6

    move-object v2, v3

    :cond_6
    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->alertSwitch:Landroidx/appcompat/widget/SwitchCompat;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_7

    const-string v1, "\ud83d\udd14  \u041e\u043f\u043e\u0432\u0435\u0449\u0435\u043d\u0438\u0435 \u043e \u043d\u0435\u0438\u0437\u0432\u0435\u0441\u0442\u043d\u044b\u0445 \u0445\u043e\u0441\u0442\u0430\u0445"

    goto :goto_6

    :cond_7
    const-string v1, "\ud83d\udd14  Alert on unknown hosts"

    :goto_6
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->monStatusText:Landroid/widget/TextView;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_8

    const-string v1, "\u26ab  \u041c\u043e\u043d\u0438\u0442\u043e\u0440\u0438\u043d\u0433 \u043d\u0435\u0430\u043a\u0442\u0438\u0432\u0435\u043d"

    goto :goto_7

    :cond_8
    const-string v1, "\u26ab  Monitoring inactive"

    :goto_7
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->customDomainInput:Landroid/widget/EditText;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_9

    const-string v1, "\u0412\u0432\u0435\u0434\u0438\u0442\u0435 \u0434\u043e\u043c\u0435\u043d \u0438\u043b\u0438 IP\u2026"

    goto :goto_8

    :cond_9
    const-string v1, "Enter domain or IP\u2026"

    :goto_8
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setHint(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->checkCustomBtn:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_a

    const-string v1, "\u041f\u0440\u043e\u0432\u0435\u0440\u0438\u0442\u044c"

    goto :goto_9

    :cond_a
    const-string v1, "Check"

    :goto_9
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->checkAllBtn:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_b

    const-string v1, "\u25b6  \u041f\u0440\u043e\u0432\u0435\u0440\u0438\u0442\u044c \u0432\u0441\u0451"

    goto :goto_a

    :cond_b
    const-string v1, "\u25b6  Check All"

    :goto_a
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->stopCheckBtn:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_c

    const-string v1, "\u25a0  \u0421\u0442\u043e\u043f"

    goto :goto_b

    :cond_c
    const-string v1, "\u25a0  Stop"

    :goto_b
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->checkStatusText:Landroid/widget/TextView;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_d

    const-string v1, "\u041d\u0430\u0436\u043c\u0438\u0442\u0435 \u25b6 \u041f\u0440\u043e\u0432\u0435\u0440\u0438\u0442\u044c \u0432\u0441\u0451 \u0434\u043b\u044f \u0442\u0435\u0441\u0442\u0430"

    goto :goto_c

    :cond_d
    const-string v1, "Tap \u25b6 Check All to test reachability"

    :goto_c
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->myInfoRefreshBtn:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_e

    const-string v1, "\u25b6  \u041f\u043e\u043b\u0443\u0447\u0438\u0442\u044c \u0434\u0430\u043d\u043d\u044b\u0435"

    goto :goto_d

    :cond_e
    const-string v1, "\u25b6  Lookup My Info"

    :goto_d
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->speedTitleText:Landroid/widget/TextView;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_f

    const-string v1, "\u26a1 \u0422\u0435\u0441\u0442 \u0441\u043a\u043e\u0440\u043e\u0441\u0442\u0438"

    goto :goto_e

    :cond_f
    const-string v1, "\u26a1 Internet Speed Test"

    :goto_e
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->speedDescText:Landroid/widget/TextView;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_10

    const-string v1, "\u0418\u0437\u043c\u0435\u0440\u044c\u0442\u0435 \u0441\u043a\u043e\u0440\u043e\u0441\u0442\u044c \u0437\u0430\u0433\u0440\u0443\u0437\u043a\u0438, \u0432\u044b\u0433\u0440\u0443\u0437\u043a\u0438 \u0438 \u043f\u0438\u043d\u0433 \u0434\u043e \u0432\u044b\u0431\u0440\u0430\u043d\u043d\u043e\u0433\u043e \u0441\u0435\u0440\u0432\u0435\u0440\u0430."

    goto :goto_f

    :cond_10
    const-string v1, "Measure your download speed, upload speed, and latency to a selected server."

    :goto_f
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->speedRunBtn:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_11

    const-string v1, "\u25b6  \u0417\u0430\u043f\u0443\u0441\u0442\u0438\u0442\u044c \u0442\u0435\u0441\u0442"

    goto :goto_10

    :cond_11
    const-string v1, "\u25b6  Run Speed Test"

    :goto_10
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->myInfoTitleText:Landroid/widget/TextView;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_12

    const-string v1, "\ud83c\udf10 \u041c\u043e\u044f \u0441\u0435\u0442\u044c"

    goto :goto_11

    :cond_12
    const-string v1, "\ud83c\udf10 My Network Info"

    :goto_11
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->myInfoDescText:Landroid/widget/TextView;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_13

    const-string v1, "\u0412\u0430\u0448 \u043f\u0443\u0431\u043b\u0438\u0447\u043d\u044b\u0439 IP-\u0430\u0434\u0440\u0435\u0441, \u043f\u0440\u043e\u0432\u0430\u0439\u0434\u0435\u0440 \u0438 \u043c\u0435\u0441\u0442\u043e\u043f\u043e\u043b\u043e\u0436\u0435\u043d\u0438\u0435."

    goto :goto_12

    :cond_13
    const-string v1, "Your public IP address, ISP, and location as seen from the internet."

    :goto_12
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->selectAppLabel:Landroid/widget/TextView;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_14

    const-string v1, "\u0412\u042b\u0411\u0420\u0410\u0422\u042c \u041f\u0420\u0418\u041b\u041e\u0416\u0415\u041d\u0418\u0415"

    goto :goto_13

    :cond_14
    const-string v1, "SELECT APP TO MONITOR"

    :goto_13
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->liveHostsLabel:Landroid/widget/TextView;

    iget-boolean p0, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p0, :cond_15

    const-string p0, "\u0410\u041a\u0422\u0418\u0412\u041d\u042b\u0415 \u0421\u041e\u0415\u0414\u0418\u041d\u0415\u041d\u0418\u042f"

    goto :goto_14

    :cond_15
    const-string p0, "LIVE CONNECTION HOSTS"

    :goto_14
    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method

.method private runSpeedTest()V
    .locals 10

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->speedServerSpinner:Landroid/widget/Spinner;

    invoke-virtual {v0}, Landroid/widget/AdapterView;->getSelectedItemPosition()I

    move-result v0

    sget-object v1, Lcom/netwatch/app/MainActivity;->SPEED_SERVERS:[[Ljava/lang/String;

    aget-object v2, v1, v0

    const/4 v3, 0x1

    aget-object v6, v2, v3

    const/4 v4, 0x0

    aget-object v2, v2, v4

    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v9

    aget-object v0, v1, v0

    const/4 v1, 0x2

    aget-object v0, v0, v1

    const-string v1, "cloudflare"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    const-string v1, "ookla"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    iput-boolean v3, p0, Lcom/netwatch/app/MainActivity;->speedRunning:Z

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->speedRunBtn:Landroid/widget/Button;

    invoke-virtual {v0, v4}, Landroid/view/View;->setEnabled(Z)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->speedStatusText:Landroid/widget/TextView;

    invoke-virtual {v0, v4}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->speedStatusText:Landroid/widget/TextView;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_0

    const-string v1, "\u23f3 \u0422\u0435\u0441\u0442\u0438\u0440\u043e\u0432\u0430\u043d\u0438\u0435\u2026"

    goto :goto_0

    :cond_0
    const-string v1, "\u23f3 Running test\u2026"

    :goto_0
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->speedPingText:Landroid/widget/TextView;

    const-string v1, "\u2014"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->speedDownText:Landroid/widget/TextView;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->speedUpText:Landroid/widget/TextView;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->speedResultsContainer:Landroid/widget/LinearLayout;

    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->executor:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/netwatch/app/u;

    move-object v4, v1

    move-object v5, p0

    invoke-direct/range {v4 .. v9}, Lcom/netwatch/app/u;-><init>(Lcom/netwatch/app/MainActivity;Ljava/lang/String;ZZLjava/lang/String;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/Executor;->execute(Ljava/lang/Runnable;)V

    return-void
.end method

.method public static synthetic s(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$17(Landroid/view/View;)V

    return-void
.end method

.method private seedTrustedDomains(Ljava/lang/String;)V
    .locals 2

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->trustedDomains:Ljava/util/Set;

    new-instance v1, Lcom/netwatch/app/p;

    invoke-direct {v1}, Ljava/lang/Object;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/Collection;->removeIf(Ljava/util/function/Predicate;)Z

    invoke-static {p1}, Lcom/netwatch/app/MainActivity;->packageToRootDomain(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/netwatch/app/MainActivity;->monitoredRootDomain:Ljava/lang/String;

    if-eqz p1, :cond_0

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->trustedDomains:Ljava/util/Set;

    invoke-interface {v0, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->trustedDomains:Ljava/util/Set;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "www."

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->monitoredRootDomain:Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-interface {p1, p0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    :cond_0
    return-void
.end method

.method private shareCsv(Ljava/lang/String;Ljava/lang/String;)V
    .locals 8

    const-string v0, "Export CSV via\u2026"

    const-string v1, "\u042d\u043a\u0441\u043f\u043e\u0440\u0442 CSV \u0447\u0435\u0440\u0435\u0437\u2026"

    const-string v2, "android.intent.extra.SUBJECT"

    const-string v3, "text/csv"

    const-string v4, "android.intent.action.SEND"

    const-string v5, "clipboard"

    invoke-virtual {p0, v5}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/content/ClipboardManager;

    invoke-static {p1, p2}, Landroid/content/ClipData;->newPlainText(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Landroid/content/ClipData;

    move-result-object v6

    invoke-virtual {v5, v6}, Landroid/content/ClipboardManager;->setPrimaryClip(Landroid/content/ClipData;)V

    :try_start_0
    new-instance v5, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object v6

    const-string v7, "exports"

    invoke-direct {v5, v6, v7}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v5}, Ljava/io/File;->mkdirs()Z

    new-instance v6, Ljava/io/File;

    invoke-direct {v6, v5, p1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    new-instance v5, Ljava/io/FileWriter;

    invoke-direct {v5, v6}, Ljava/io/FileWriter;-><init>(Ljava/io/File;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :try_start_1
    invoke-virtual {v5, p2}, Ljava/io/Writer;->write(Ljava/lang/String;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :try_start_2
    invoke-virtual {v5}, Ljava/io/Writer;->close()V

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, ".provider"

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {p0, v5, v6}, Landroidx/core/content/FileProvider;->getUriForFile(Landroid/content/Context;Ljava/lang/String;Ljava/io/File;)Landroid/net/Uri;

    move-result-object v5

    new-instance v6, Landroid/content/Intent;

    invoke-direct {v6, v4}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    invoke-virtual {v6, v3}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;

    invoke-virtual {v6, v2, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const-string v7, "android.intent.extra.STREAM"

    invoke-virtual {v6, v7, v5}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;

    const/4 v5, 0x1

    invoke-virtual {v6, v5}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    iget-boolean v5, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v5, :cond_0

    move-object v5, v1

    goto :goto_0

    :cond_0
    move-object v5, v0

    :goto_0
    invoke-static {v6, v5}, Landroid/content/Intent;->createChooser(Landroid/content/Intent;Ljava/lang/CharSequence;)Landroid/content/Intent;

    move-result-object v5

    invoke-virtual {p0, v5}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    goto :goto_2

    :catchall_0
    move-exception v6

    :try_start_3
    invoke-virtual {v5}, Ljava/io/Writer;->close()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    goto :goto_1

    :catchall_1
    move-exception v5

    :try_start_4
    invoke-virtual {v6, v5}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_1
    throw v6
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_0

    :catch_0
    new-instance v5, Landroid/content/Intent;

    invoke-direct {v5, v4}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    invoke-virtual {v5, v3}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;

    invoke-virtual {v5, v2, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const-string p1, "android.intent.extra.TEXT"

    invoke-virtual {v5, p1, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    iget-boolean p1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p1, :cond_1

    move-object v0, v1

    :cond_1
    invoke-static {v5, v0}, Landroid/content/Intent;->createChooser(Landroid/content/Intent;Ljava/lang/CharSequence;)Landroid/content/Intent;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    :goto_2
    return-void
.end method

.method private showInfoDialog(Ljava/lang/String;Ljava/lang/String;)V
    .locals 1

    new-instance v0, Landroid/app/AlertDialog$Builder;

    invoke-direct {v0, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0, p1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    invoke-virtual {p1, p2}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    iget-boolean p0, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p0, :cond_0

    const-string p0, "\u041f\u043e\u043d\u044f\u0442\u043d\u043e"

    goto :goto_0

    :cond_0
    const-string p0, "Got it"

    :goto_0
    const/4 p2, 0x0

    invoke-virtual {p1, p0, p2}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    return-void
.end method

.method private showLanguageDialog()V
    .locals 4

    const-string v0, "\ud83c\uddec\ud83c\udde7  English"

    const-string v1, "\ud83c\uddf7\ud83c\uddfa  \u0420\u0443\u0441\u0441\u043a\u0438\u0439"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    new-instance v2, Landroid/app/AlertDialog$Builder;

    invoke-direct {v2, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    iget-boolean v3, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v3, :cond_0

    const-string v3, "\ud83c\udf0d \u0412\u044b\u0431\u0435\u0440\u0438\u0442\u0435 \u044f\u0437\u044b\u043a"

    goto :goto_0

    :cond_0
    const-string v3, "\ud83c\udf0d Select Language"

    :goto_0
    invoke-virtual {v2, v3}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v2

    new-instance v3, Lcom/netwatch/app/t;

    invoke-direct {v3, p0}, Lcom/netwatch/app/t;-><init>(Lcom/netwatch/app/MainActivity;)V

    invoke-virtual {v2, v0, v1, v3}, Landroid/app/AlertDialog$Builder;->setSingleChoiceItems([Ljava/lang/CharSequence;ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    iget-boolean p0, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p0, :cond_1

    const-string p0, "\u041e\u0442\u043c\u0435\u043d\u0430"

    goto :goto_1

    :cond_1
    const-string p0, "Cancel"

    :goto_1
    const/4 v1, 0x0

    invoke-virtual {v0, p0, v1}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    return-void
.end method

.method private showMainMenu(Landroid/view/View;)V
    .locals 3

    new-instance v0, Landroid/widget/PopupMenu;

    invoke-direct {v0, p0, p1}, Landroid/widget/PopupMenu;-><init>(Landroid/content/Context;Landroid/view/View;)V

    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenuInflater()Landroid/view/MenuInflater;

    move-result-object p1

    sget v1, Lcom/netwatch/app/R$menu;->main_menu:I

    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object v2

    invoke-virtual {p1, v1, v2}, Landroid/view/MenuInflater;->inflate(ILandroid/view/Menu;)V

    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    sget v1, Lcom/netwatch/app/R$id;->menu_language:I

    invoke-interface {p1, v1}, Landroid/view/Menu;->findItem(I)Landroid/view/MenuItem;

    move-result-object p1

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_0

    const-string v1, "\ud83c\udf0d Language: \u0420\u0443\u0441\u0441\u043a\u0438\u0439"

    goto :goto_0

    :cond_0
    const-string v1, "\ud83c\udf0d Language: English"

    :goto_0
    invoke-interface {p1, v1}, Landroid/view/MenuItem;->setTitle(Ljava/lang/CharSequence;)Landroid/view/MenuItem;

    new-instance p1, Lcom/netwatch/app/k;

    invoke-direct {p1, p0}, Lcom/netwatch/app/k;-><init>(Lcom/netwatch/app/MainActivity;)V

    invoke-virtual {v0, p1}, Landroid/widget/PopupMenu;->setOnMenuItemClickListener(Landroid/widget/PopupMenu$OnMenuItemClickListener;)V

    invoke-virtual {v0}, Landroid/widget/PopupMenu;->show()V

    return-void
.end method

.method private showToast(Ljava/lang/String;)V
    .locals 1

    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method private startDeviceMonitor()V
    .locals 2

    invoke-static {p0}, Landroid/net/VpnService;->prepare(Landroid/content/Context;)Landroid/content/Intent;

    move-result-object v0

    if-eqz v0, :cond_0

    const/16 v1, 0x3e9

    invoke-virtual {p0, v0, v1}, Landroid/app/Activity;->startActivityForResult(Landroid/content/Intent;I)V

    goto :goto_0

    :cond_0
    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->launchDeviceVpn()V

    :goto_0
    return-void
.end method

.method private startDomainCheck()V
    .locals 7

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->checkRunning:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    :cond_0
    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->checkRunning:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->checkAllBtn:Landroid/widget/Button;

    const/4 v2, 0x0

    invoke-virtual {v0, v2}, Landroid/view/View;->setEnabled(Z)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->stopCheckBtn:Landroid/widget/Button;

    invoke-virtual {v0, v1}, Landroid/view/View;->setEnabled(Z)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->checkStatusText:Landroid/widget/TextView;

    const-string v1, "#00E5FF"

    invoke-static {v1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->checkerStatusViews:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_1
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map$Entry;

    invoke-interface {v1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    const-string v4, "\u2026"

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-interface {v1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    const-string v4, "#90A4AE"

    invoke-static {v4}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v4

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V

    invoke-interface {v1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/widget/TextView;

    invoke-virtual {v1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    instance-of v3, v1, Landroid/widget/LinearLayout;

    if-eqz v3, :cond_1

    check-cast v1, Landroid/widget/LinearLayout;

    invoke-virtual {v1}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object v1

    instance-of v3, v1, Landroid/widget/TextView;

    if-eqz v3, :cond_1

    check-cast v1, Landroid/widget/TextView;

    const-string v3, "#546E7A"

    invoke-static {v3}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v3

    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setTextColor(I)V

    goto :goto_0

    :cond_2
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    sget-object v1, Lcom/netwatch/app/MainActivity;->CHECKER_DOMAINS:Ljava/util/LinkedHashMap;

    invoke-virtual {v1}, Ljava/util/LinkedHashMap;->values()Ljava/util/Collection;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_3
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_4

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, [[Ljava/lang/String;

    array-length v4, v3

    move v5, v2

    :goto_1
    if-ge v5, v4, :cond_3

    aget-object v6, v3, v5

    invoke-virtual {v0, v6}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v5, v5, 0x1

    goto :goto_1

    :cond_4
    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->executor:Ljava/util/concurrent/ExecutorService;

    new-instance v2, Landroidx/constraintlayout/motion/widget/a;

    const/4 v3, 0x5

    invoke-direct {v2, v3, p0, v0}, Landroidx/constraintlayout/motion/widget/a;-><init>(ILjava/lang/Object;Ljava/lang/Object;)V

    invoke-interface {v1, v2}, Ljava/util/concurrent/Executor;->execute(Ljava/lang/Runnable;)V

    return-void
.end method

.method private startMonitoring()V
    .locals 3

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->selectedApp:Lcom/netwatch/app/AppEntry;

    if-nez v0, :cond_1

    iget-boolean v0, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v0, :cond_0

    const-string v0, "\u0421\u043d\u0430\u0447\u0430\u043b\u0430 \u0432\u044b\u0431\u0435\u0440\u0438\u0442\u0435 \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u0435"

    goto :goto_0

    :cond_0
    const-string v0, "Select an app first"

    :goto_0
    invoke-direct {p0, v0}, Lcom/netwatch/app/MainActivity;->showToast(Ljava/lang/String;)V

    return-void

    :cond_1
    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->clearLog()V

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/netwatch/app/MainActivity;->monitoring:Z

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->startMonBtn:Landroid/widget/Button;

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/view/View;->setEnabled(Z)V

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->stopMonBtn:Landroid/widget/Button;

    invoke-virtual {v1, v0}, Landroid/view/View;->setEnabled(Z)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->appSpinner:Landroid/widget/Spinner;

    invoke-virtual {v0, v2}, Landroid/widget/Spinner;->setEnabled(Z)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->monStatusText:Landroid/widget/TextView;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-boolean v2, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v2, :cond_2

    const-string v2, "\ud83d\udfe2  \u041c\u043e\u043d\u0438\u0442\u043e\u0440\u0438\u043d\u0433: "

    goto :goto_1

    :cond_2
    const-string v2, "\ud83d\udfe2  Monitoring: "

    :goto_1
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/netwatch/app/MainActivity;->selectedApp:Lcom/netwatch/app/AppEntry;

    iget-object v2, v2, Lcom/netwatch/app/AppEntry;->label:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->monStatusText:Landroid/widget/TextView;

    const-string v1, "#66BB6A"

    invoke-static {v1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/netwatch/app/TrafficMonitorService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->selectedApp:Lcom/netwatch/app/AppEntry;

    iget v1, v1, Lcom/netwatch/app/AppEntry;->uid:I

    const-string v2, "target_uid"

    invoke-virtual {v0, v2, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->selectedApp:Lcom/netwatch/app/AppEntry;

    iget-object v1, v1, Lcom/netwatch/app/AppEntry;->packageName:Ljava/lang/String;

    const-string v2, "target_pkg"

    invoke-virtual {v0, v2, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->selectedApp:Lcom/netwatch/app/AppEntry;

    iget-object v1, v1, Lcom/netwatch/app/AppEntry;->label:Ljava/lang/String;

    const-string v2, "target_name"

    invoke-virtual {v0, v2, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    invoke-virtual {p0, v0}, Landroid/content/Context;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;

    return-void
.end method

.method private stopDeviceMonitor()V
    .locals 3

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->deviceReceiver:Landroid/content/BroadcastReceiver;

    if-eqz v0, :cond_0

    :try_start_0
    invoke-static {p0}, Landroidx/localbroadcastmanager/content/LocalBroadcastManager;->getInstance(Landroid/content/Context;)Landroidx/localbroadcastmanager/content/LocalBroadcastManager;

    move-result-object v0

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->deviceReceiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {v0, v1}, Landroidx/localbroadcastmanager/content/LocalBroadcastManager;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/netwatch/app/MainActivity;->deviceReceiver:Landroid/content/BroadcastReceiver;

    :cond_0
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/netwatch/app/NetWatchVpnService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v2, "com.netwatch.app.STOP_VPN"

    invoke-virtual {v0, v2}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    invoke-virtual {p0, v0}, Landroid/content/Context;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;

    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p0, v0}, Landroid/content/Context;->stopService(Landroid/content/Intent;)Z

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/netwatch/app/MainActivity;->deviceMonRunning:Z

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->deviceToggleBtn:Landroid/widget/Button;

    iget-boolean v2, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v2, :cond_1

    const-string v2, "\u25b6  \u0421\u0442\u0430\u0440\u0442"

    goto :goto_0

    :cond_1
    const-string v2, "\u25b6  Start"

    :goto_0
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->deviceToggleBtn:Landroid/widget/Button;

    sget v2, Lcom/netwatch/app/R$drawable;->btn_primary:I

    invoke-virtual {v1, v2}, Landroid/view/View;->setBackgroundResource(I)V

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->deviceStatusText:Landroid/widget/TextView;

    iget-boolean v2, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v2, :cond_2

    const-string v2, "\u041e\u0441\u0442\u0430\u043d\u043e\u0432\u043b\u0435\u043d"

    goto :goto_1

    :cond_2
    const-string v2, "Stopped"

    :goto_1
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->deviceStatusText:Landroid/widget/TextView;

    const-string v2, "#546E7A"

    invoke-static {v2}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v2

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextColor(I)V

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->deviceLog:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_3

    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->deviceExportBtn:Landroid/widget/Button;

    invoke-virtual {p0, v0}, Landroid/view/View;->setVisibility(I)V

    :cond_3
    return-void
.end method

.method private stopDomainCheck()V
    .locals 2

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->checkRunning:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->stopCheckBtn:Landroid/widget/Button;

    invoke-virtual {p0, v1}, Landroid/view/View;->setEnabled(Z)V

    return-void
.end method

.method private stopMonitoring()V
    .locals 3

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/netwatch/app/MainActivity;->monitoring:Z

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->startMonBtn:Landroid/widget/Button;

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/view/View;->setEnabled(Z)V

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->stopMonBtn:Landroid/widget/Button;

    invoke-virtual {v1, v0}, Landroid/view/View;->setEnabled(Z)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->appSpinner:Landroid/widget/Spinner;

    invoke-virtual {v0, v2}, Landroid/widget/Spinner;->setEnabled(Z)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->monStatusText:Landroid/widget/TextView;

    iget-boolean v1, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz v1, :cond_0

    const-string v1, "\u26ab  \u041c\u043e\u043d\u0438\u0442\u043e\u0440\u0438\u043d\u0433 \u043e\u0441\u0442\u0430\u043d\u043e\u0432\u043b\u0435\u043d"

    goto :goto_0

    :cond_0
    const-string v1, "\u26ab  Monitoring stopped"

    :goto_0
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->monStatusText:Landroid/widget/TextView;

    const-string v1, "#78909C"

    invoke-static {v1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/netwatch/app/TrafficMonitorService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v1, "com.netwatch.app.STOP_MONITOR"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    invoke-virtual {p0, v0}, Landroid/content/Context;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;

    return-void
.end method

.method private switchTab(I)V
    .locals 8

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->tab1:Landroid/view/View;

    const/16 v1, 0x8

    const/4 v2, 0x0

    if-nez p1, :cond_0

    move v3, v2

    goto :goto_0

    :cond_0
    move v3, v1

    :goto_0
    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->tab2:Landroid/view/View;

    const/4 v3, 0x1

    if-ne p1, v3, :cond_1

    move v4, v2

    goto :goto_1

    :cond_1
    move v4, v1

    :goto_1
    invoke-virtual {v0, v4}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->tab3:Landroid/widget/LinearLayout;

    const/4 v4, 0x2

    if-ne p1, v4, :cond_2

    move v5, v2

    goto :goto_2

    :cond_2
    move v5, v1

    :goto_2
    invoke-virtual {v0, v5}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->tab4:Landroid/view/View;

    const/4 v5, 0x3

    if-ne p1, v5, :cond_3

    move v6, v2

    goto :goto_3

    :cond_3
    move v6, v1

    :goto_3
    invoke-virtual {v0, v6}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->tab5:Landroid/widget/ScrollView;

    const/4 v6, 0x4

    if-ne p1, v6, :cond_4

    move v7, v2

    goto :goto_4

    :cond_4
    move v7, v1

    :goto_4
    invoke-virtual {v0, v7}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->tab6:Landroid/view/View;

    const/4 v7, 0x5

    if-ne p1, v7, :cond_5

    move v1, v2

    :cond_5
    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    if-ne p1, v5, :cond_6

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->myInfoContainer:Landroid/widget/LinearLayout;

    invoke-virtual {v0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v0

    if-nez v0, :cond_6

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->lookupMyInfo()V

    :cond_6
    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->tabDomainBtn:Landroid/widget/Button;

    if-nez p1, :cond_7

    move v1, v3

    goto :goto_5

    :cond_7
    move v1, v2

    :goto_5
    invoke-virtual {v0, v1}, Landroid/view/View;->setSelected(Z)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->tabTrafficBtn:Landroid/widget/Button;

    if-ne p1, v3, :cond_8

    move v1, v3

    goto :goto_6

    :cond_8
    move v1, v2

    :goto_6
    invoke-virtual {v0, v1}, Landroid/view/View;->setSelected(Z)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->tabCheckerBtn:Landroid/widget/Button;

    if-ne p1, v4, :cond_9

    move v1, v3

    goto :goto_7

    :cond_9
    move v1, v2

    :goto_7
    invoke-virtual {v0, v1}, Landroid/view/View;->setSelected(Z)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->tabMyInfoBtn:Landroid/widget/Button;

    if-ne p1, v5, :cond_a

    move v1, v3

    goto :goto_8

    :cond_a
    move v1, v2

    :goto_8
    invoke-virtual {v0, v1}, Landroid/view/View;->setSelected(Z)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->tabSpeedBtn:Landroid/widget/Button;

    if-ne p1, v6, :cond_b

    move v1, v3

    goto :goto_9

    :cond_b
    move v1, v2

    :goto_9
    invoke-virtual {v0, v1}, Landroid/view/View;->setSelected(Z)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->tabDeviceBtn:Landroid/widget/Button;

    if-ne p1, v7, :cond_c

    move v2, v3

    :cond_c
    invoke-virtual {v0, v2}, Landroid/view/View;->setSelected(Z)V

    if-ne p1, v3, :cond_f

    iget-wide v0, p0, Lcom/netwatch/app/MainActivity;->lastKnownTx:J

    const-wide/16 v2, 0x0

    cmp-long p1, v0, v2

    if-ltz p1, :cond_f

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->txTotalText:Landroid/widget/TextView;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "TX  "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-wide v4, p0, Lcom/netwatch/app/MainActivity;->lastKnownTx:J

    invoke-static {v4, v5}, Lcom/netwatch/app/MainActivity;->formatBytes(J)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->rxTotalText:Landroid/widget/TextView;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "RX  "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-wide v4, p0, Lcom/netwatch/app/MainActivity;->lastKnownRx:J

    invoke-static {v4, v5}, Lcom/netwatch/app/MainActivity;->formatBytes(J)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->txRateText:Landroid/widget/TextView;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u2191 "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-wide v4, p0, Lcom/netwatch/app/MainActivity;->lastKnownTxRate:J

    invoke-static {v4, v5}, Lcom/netwatch/app/MainActivity;->formatBytes(J)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "/s"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->rxRateText:Landroid/widget/TextView;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v4, "\u2193 "

    invoke-direct {v0, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-wide v4, p0, Lcom/netwatch/app/MainActivity;->lastKnownRxRate:J

    invoke-static {v4, v5}, Lcom/netwatch/app/MainActivity;->formatBytes(J)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->txRateText:Landroid/widget/TextView;

    iget-wide v0, p0, Lcom/netwatch/app/MainActivity;->lastKnownTxRate:J

    cmp-long v0, v0, v2

    const-string v1, "#546E7A"

    if-lez v0, :cond_d

    const-string v0, "#EF9A9A"

    invoke-static {v0}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v0

    goto :goto_a

    :cond_d
    invoke-static {v1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v0

    :goto_a
    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setTextColor(I)V

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->rxRateText:Landroid/widget/TextView;

    iget-wide v4, p0, Lcom/netwatch/app/MainActivity;->lastKnownRxRate:J

    cmp-long p0, v4, v2

    if-lez p0, :cond_e

    const-string p0, "#66BB6A"

    invoke-static {p0}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p0

    goto :goto_b

    :cond_e
    invoke-static {v1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p0

    :goto_b
    invoke-virtual {p1, p0}, Landroid/widget/TextView;->setTextColor(I)V

    :cond_f
    return-void
.end method

.method public static synthetic t(Lcom/netwatch/app/MainActivity;Ljava/lang/String;JDD)V
    .locals 0

    invoke-direct/range {p0 .. p7}, Lcom/netwatch/app/MainActivity;->lambda$runSpeedTest$45(Ljava/lang/String;JDD)V

    return-void
.end method

.method public static synthetic u(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$3(Landroid/view/View;)V

    return-void
.end method

.method private updateStats(JJJJLjava/lang/String;)V
    .locals 6

    iput-wide p1, p0, Lcom/netwatch/app/MainActivity;->lastKnownTx:J

    iput-wide p3, p0, Lcom/netwatch/app/MainActivity;->lastKnownRx:J

    iput-wide p5, p0, Lcom/netwatch/app/MainActivity;->lastKnownTxRate:J

    iput-wide p7, p0, Lcom/netwatch/app/MainActivity;->lastKnownRxRate:J

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->txTotalText:Landroid/widget/TextView;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "TX  "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-wide/16 v2, 0x0

    cmp-long v4, p1, v2

    const-string v5, "N/A"

    if-gez v4, :cond_0

    move-object p1, v5

    goto :goto_0

    :cond_0
    invoke-static {p1, p2}, Lcom/netwatch/app/MainActivity;->formatBytes(J)Ljava/lang/String;

    move-result-object p1

    :goto_0
    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->rxTotalText:Landroid/widget/TextView;

    new-instance p2, Ljava/lang/StringBuilder;

    const-string v0, "RX  "

    invoke-direct {p2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    cmp-long v0, p3, v2

    if-gez v0, :cond_1

    move-object p3, v5

    goto :goto_1

    :cond_1
    invoke-static {p3, p4}, Lcom/netwatch/app/MainActivity;->formatBytes(J)Ljava/lang/String;

    move-result-object p3

    :goto_1
    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->txRateText:Landroid/widget/TextView;

    new-instance p2, Ljava/lang/StringBuilder;

    const-string p3, "\u2191 "

    invoke-direct {p2, p3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string p3, "/s"

    if-gez v4, :cond_2

    move-object p4, v5

    goto :goto_2

    :cond_2
    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {p5, p6}, Lcom/netwatch/app/MainActivity;->formatBytes(J)Ljava/lang/String;

    move-result-object v1

    invoke-static {p4, v1, p3}, Landroidx/activity/result/a;->g(Ljava/lang/StringBuilder;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p4

    :goto_2
    invoke-virtual {p2, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->rxRateText:Landroid/widget/TextView;

    new-instance p2, Ljava/lang/StringBuilder;

    const-string p4, "\u2193 "

    invoke-direct {p2, p4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-gez v0, :cond_3

    goto :goto_3

    :cond_3
    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {p7, p8}, Lcom/netwatch/app/MainActivity;->formatBytes(J)Ljava/lang/String;

    move-result-object v0

    invoke-static {p4, v0, p3}, Landroidx/activity/result/a;->g(Ljava/lang/StringBuilder;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    :goto_3
    invoke-virtual {p2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    cmp-long p1, p5, v2

    const-string p2, "#66BB6A"

    const-string p3, "#546E7A"

    if-gtz p1, :cond_5

    cmp-long p4, p7, v2

    if-lez p4, :cond_4

    goto :goto_4

    :cond_4
    invoke-static {p3}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    goto :goto_5

    :cond_5
    :goto_4
    invoke-static {p2}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    :goto_5
    iget-object p4, p0, Lcom/netwatch/app/MainActivity;->txRateText:Landroid/widget/TextView;

    if-lez p1, :cond_6

    const-string p5, "#EF9A9A"

    invoke-static {p5}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p5

    goto :goto_6

    :cond_6
    invoke-static {p3}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p5

    :goto_6
    invoke-virtual {p4, p5}, Landroid/widget/TextView;->setTextColor(I)V

    iget-object p4, p0, Lcom/netwatch/app/MainActivity;->rxRateText:Landroid/widget/TextView;

    cmp-long p5, p7, v2

    if-lez p5, :cond_7

    invoke-static {p2}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p2

    goto :goto_7

    :cond_7
    invoke-static {p3}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p2

    :goto_7
    invoke-virtual {p4, p2}, Landroid/widget/TextView;->setTextColor(I)V

    if-eqz p9, :cond_f

    invoke-virtual {p9}, Ljava/lang/String;->isEmpty()Z

    move-result p2

    if-nez p2, :cond_f

    const-string p2, "\n"

    invoke-virtual {p9, p2}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p2

    new-instance p3, Ljava/text/SimpleDateFormat;

    const-string p4, "HH:mm:ss"

    sget-object p6, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-direct {p3, p4, p6}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance p4, Ljava/util/Date;

    invoke-direct {p4}, Ljava/util/Date;-><init>()V

    invoke-virtual {p3, p4}, Ljava/text/DateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object p3

    array-length p4, p2

    const/4 p6, 0x0

    move p7, p6

    :goto_8
    if-ge p7, p4, :cond_c

    aget-object p8, p2, p7

    invoke-virtual {p8}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p8

    invoke-virtual {p8}, Ljava/lang/String;->isEmpty()Z

    move-result p9

    if-eqz p9, :cond_8

    goto :goto_b

    :cond_8
    iget-object p9, p0, Lcom/netwatch/app/MainActivity;->seenHosts:Ljava/util/Set;

    invoke-interface {p9, p8}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result p9

    if-eqz p9, :cond_9

    goto :goto_b

    :cond_9
    iget-object p9, p0, Lcom/netwatch/app/MainActivity;->seenHosts:Ljava/util/Set;

    invoke-interface {p9, p8}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const/4 p9, 0x1

    if-gtz p1, :cond_b

    if-lez p5, :cond_a

    goto :goto_9

    :cond_a
    move v0, p6

    goto :goto_a

    :cond_b
    :goto_9
    move v0, p9

    :goto_a
    invoke-direct {p0, p8, v0, p3}, Lcom/netwatch/app/MainActivity;->addHostRow(Ljava/lang/String;ZLjava/lang/String;)V

    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->trafficLogForExport:Ljava/util/LinkedHashMap;

    invoke-virtual {v0, p8, p3}, Ljava/util/AbstractMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    iget p8, p0, Lcom/netwatch/app/MainActivity;->hostCount:I

    add-int/2addr p8, p9

    iput p8, p0, Lcom/netwatch/app/MainActivity;->hostCount:I

    :goto_b
    add-int/lit8 p7, p7, 0x1

    goto :goto_8

    :cond_c
    iget p1, p0, Lcom/netwatch/app/MainActivity;->hostCount:I

    if-lez p1, :cond_e

    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->connectionCountText:Landroid/widget/TextView;

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    iget p3, p0, Lcom/netwatch/app/MainActivity;->hostCount:I

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    iget-boolean p3, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p3, :cond_d

    const-string p3, " \u0443\u043d\u0438\u043a\u0430\u043b\u044c\u043d\u044b\u0445 \u0445\u043e\u0441\u0442\u043e\u0432"

    goto :goto_c

    :cond_d
    const-string p3, " unique hosts"

    :goto_c
    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_e
    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->hostLogScroll:Landroid/widget/ScrollView;

    new-instance p2, Lcom/netwatch/app/l;

    const/4 p3, 0x2

    invoke-direct {p2, p0, p3}, Lcom/netwatch/app/l;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {p1, p2}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    :cond_f
    return-void
.end method

.method public static synthetic v(Lcom/netwatch/app/AppEntry;Lcom/netwatch/app/AppEntry;)I
    .locals 0

    invoke-static {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$loadAppList$26(Lcom/netwatch/app/AppEntry;Lcom/netwatch/app/AppEntry;)I

    move-result p0

    return p0
.end method

.method public static synthetic w(Lcom/netwatch/app/MainActivity;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$performLookup$33(Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic x(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$15(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic y(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$11(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic z(Lcom/netwatch/app/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/netwatch/app/MainActivity;->lambda$onCreate$19(Landroid/view/View;)V

    return-void
.end method


# virtual methods
.method public onActivityResult(IILandroid/content/Intent;)V
    .locals 0

    invoke-super {p0, p1, p2, p3}, Landroid/app/Activity;->onActivityResult(IILandroid/content/Intent;)V

    const/16 p3, 0x3e9

    if-ne p1, p3, :cond_2

    const/4 p1, -0x1

    if-ne p2, p1, :cond_0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->launchDeviceVpn()V

    goto :goto_1

    :cond_0
    iget-object p1, p0, Lcom/netwatch/app/MainActivity;->deviceStatusText:Landroid/widget/TextView;

    iget-boolean p0, p0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    if-eqz p0, :cond_1

    const-string p0, "\u0420\u0430\u0437\u0440\u0435\u0448\u0435\u043d\u0438\u0435 \u043e\u0442\u043a\u043b\u043e\u043d\u0435\u043d\u043e"

    goto :goto_0

    :cond_1
    const-string p0, "Permission denied"

    :goto_0
    invoke-virtual {p1, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_2
    :goto_1
    return-void
.end method

.method public onCreate(Landroid/os/Bundle;)V
    .locals 39

    move-object/from16 v0, p0

    invoke-super/range {p0 .. p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    sget v1, Lcom/netwatch/app/R$layout;->activity_main:I

    invoke-virtual {v0, v1}, Landroid/app/Activity;->setContentView(I)V

    const-string v1, "netwatch_prefs"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v3

    const-string v4, "language"

    const-string v5, "en"

    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    const-string v4, "ru"

    invoke-virtual {v4, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    iput-boolean v3, v0, Lcom/netwatch/app/MainActivity;->isRussian:Z

    sget v3, Lcom/netwatch/app/R$id;->tabDomainBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->tabDomainBtn:Landroid/widget/Button;

    sget v3, Lcom/netwatch/app/R$id;->tabTrafficBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->tabTrafficBtn:Landroid/widget/Button;

    sget v3, Lcom/netwatch/app/R$id;->tabCheckerBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->tabCheckerBtn:Landroid/widget/Button;

    sget v3, Lcom/netwatch/app/R$id;->tabMyInfoBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->tabMyInfoBtn:Landroid/widget/Button;

    sget v3, Lcom/netwatch/app/R$id;->tabSpeedBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->tabSpeedBtn:Landroid/widget/Button;

    sget v3, Lcom/netwatch/app/R$id;->tab1:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->tab1:Landroid/view/View;

    sget v3, Lcom/netwatch/app/R$id;->tab2:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->tab2:Landroid/view/View;

    iget-object v3, v0, Lcom/netwatch/app/MainActivity;->tabDomainBtn:Landroid/widget/Button;

    const/4 v4, 0x1

    invoke-virtual {v3, v4}, Landroid/view/View;->setSelected(Z)V

    invoke-direct/range {p0 .. p0}, Lcom/netwatch/app/MainActivity;->refreshTabLabels()V

    iget-object v3, v0, Lcom/netwatch/app/MainActivity;->tabDomainBtn:Landroid/widget/Button;

    new-instance v5, Lcom/netwatch/app/h;

    invoke-direct {v5, v0, v2}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v3, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v3, v0, Lcom/netwatch/app/MainActivity;->tabTrafficBtn:Landroid/widget/Button;

    new-instance v5, Lcom/netwatch/app/h;

    const/16 v6, 0xa

    invoke-direct {v5, v0, v6}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v3, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v3, v0, Lcom/netwatch/app/MainActivity;->tabCheckerBtn:Landroid/widget/Button;

    new-instance v5, Lcom/netwatch/app/h;

    const/16 v6, 0xe

    invoke-direct {v5, v0, v6}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v3, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v3, v0, Lcom/netwatch/app/MainActivity;->tabMyInfoBtn:Landroid/widget/Button;

    new-instance v5, Lcom/netwatch/app/h;

    const/16 v6, 0xf

    invoke-direct {v5, v0, v6}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v3, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    sget v3, Lcom/netwatch/app/R$id;->menuBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    new-instance v5, Lcom/netwatch/app/h;

    const/16 v6, 0x10

    invoke-direct {v5, v0, v6}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v3, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    sget v3, Lcom/netwatch/app/R$id;->domainInput:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/EditText;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->domainInput:Landroid/widget/EditText;

    sget v3, Lcom/netwatch/app/R$id;->lookupBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->lookupBtn:Landroid/widget/Button;

    sget v3, Lcom/netwatch/app/R$id;->resultsContainer:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/LinearLayout;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->resultsContainer:Landroid/widget/LinearLayout;

    sget v3, Lcom/netwatch/app/R$id;->statusText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->statusText:Landroid/widget/TextView;

    iget-object v3, v0, Lcom/netwatch/app/MainActivity;->lookupBtn:Landroid/widget/Button;

    new-instance v5, Lcom/netwatch/app/h;

    const/16 v6, 0x11

    invoke-direct {v5, v0, v6}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v3, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v3, v0, Lcom/netwatch/app/MainActivity;->domainInput:Landroid/widget/EditText;

    new-instance v5, Lcom/netwatch/app/j;

    invoke-direct {v5, v0, v4}, Lcom/netwatch/app/j;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v3, v5}, Landroid/widget/TextView;->setOnEditorActionListener(Landroid/widget/TextView$OnEditorActionListener;)V

    sget v3, Lcom/netwatch/app/R$id;->appSpinner:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Spinner;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->appSpinner:Landroid/widget/Spinner;

    sget v3, Lcom/netwatch/app/R$id;->startMonBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->startMonBtn:Landroid/widget/Button;

    sget v3, Lcom/netwatch/app/R$id;->stopMonBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->stopMonBtn:Landroid/widget/Button;

    sget v3, Lcom/netwatch/app/R$id;->clearMonBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->clearMonBtn:Landroid/widget/Button;

    sget v3, Lcom/netwatch/app/R$id;->monStatusText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->monStatusText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->txTotalText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->txTotalText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->rxTotalText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->rxTotalText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->txRateText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->txRateText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->rxRateText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->rxRateText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->hostLogContainer:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/LinearLayout;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->hostLogContainer:Landroid/widget/LinearLayout;

    sget v3, Lcom/netwatch/app/R$id;->hostLogScroll:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/ScrollView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->hostLogScroll:Landroid/widget/ScrollView;

    sget v3, Lcom/netwatch/app/R$id;->tab3:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/LinearLayout;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->tab3:Landroid/widget/LinearLayout;

    sget v3, Lcom/netwatch/app/R$id;->tab4:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->tab4:Landroid/view/View;

    sget v3, Lcom/netwatch/app/R$id;->tab5:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/ScrollView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->tab5:Landroid/widget/ScrollView;

    sget v3, Lcom/netwatch/app/R$id;->myInfoContainer:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/LinearLayout;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->myInfoContainer:Landroid/widget/LinearLayout;

    sget v3, Lcom/netwatch/app/R$id;->myInfoRefreshBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->myInfoRefreshBtn:Landroid/widget/Button;

    sget v3, Lcom/netwatch/app/R$id;->myInfoTitleText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->myInfoTitleText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->selectAppLabel:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->selectAppLabel:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->liveHostsLabel:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->liveHostsLabel:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->myInfoDescText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->myInfoDescText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->myInfoTitleText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->myInfoTitleText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->selectAppLabel:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->selectAppLabel:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->liveHostsLabel:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->liveHostsLabel:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->myInfoDescText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->myInfoDescText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->checkAllBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->checkAllBtn:Landroid/widget/Button;

    sget v3, Lcom/netwatch/app/R$id;->stopCheckBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->stopCheckBtn:Landroid/widget/Button;

    sget v3, Lcom/netwatch/app/R$id;->checkStatusText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->checkStatusText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->checkResultsContainer:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/LinearLayout;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->checkResultsContainer:Landroid/widget/LinearLayout;

    sget v3, Lcom/netwatch/app/R$id;->customDomainInput:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/EditText;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->customDomainInput:Landroid/widget/EditText;

    sget v3, Lcom/netwatch/app/R$id;->checkCustomBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->checkCustomBtn:Landroid/widget/Button;

    sget v3, Lcom/netwatch/app/R$id;->connectionCountText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->connectionCountText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->exportDomainBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->exportDomainBtn:Landroid/widget/Button;

    sget v3, Lcom/netwatch/app/R$id;->exportTrafficBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->exportTrafficBtn:Landroid/widget/Button;

    sget v3, Lcom/netwatch/app/R$id;->alertSwitch:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroidx/appcompat/widget/SwitchCompat;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->alertSwitch:Landroidx/appcompat/widget/SwitchCompat;

    iget-object v3, v0, Lcom/netwatch/app/MainActivity;->exportDomainBtn:Landroid/widget/Button;

    new-instance v5, Lcom/netwatch/app/h;

    const/16 v6, 0x12

    invoke-direct {v5, v0, v6}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v3, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v3, v0, Lcom/netwatch/app/MainActivity;->myInfoRefreshBtn:Landroid/widget/Button;

    new-instance v5, Lcom/netwatch/app/h;

    const/16 v6, 0x13

    invoke-direct {v5, v0, v6}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v3, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    sget v3, Lcom/netwatch/app/R$id;->speedTitleText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->speedTitleText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->speedDescText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->speedDescText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->speedServerSpinner:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Spinner;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->speedServerSpinner:Landroid/widget/Spinner;

    sget v3, Lcom/netwatch/app/R$id;->speedRunBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->speedRunBtn:Landroid/widget/Button;

    sget v3, Lcom/netwatch/app/R$id;->speedStatusText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->speedStatusText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->speedPingText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->speedPingText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->speedDownText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->speedDownText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->speedUpText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->speedUpText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->speedResultsContainer:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/LinearLayout;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->speedResultsContainer:Landroid/widget/LinearLayout;

    sget-object v3, Lcom/netwatch/app/MainActivity;->SPEED_SERVERS:[[Ljava/lang/String;

    array-length v3, v3

    new-array v3, v3, [Ljava/lang/String;

    move v5, v2

    :goto_0
    sget-object v6, Lcom/netwatch/app/MainActivity;->SPEED_SERVERS:[[Ljava/lang/String;

    array-length v7, v6

    if-ge v5, v7, :cond_0

    aget-object v6, v6, v5

    aget-object v6, v6, v2

    aput-object v6, v3, v5

    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    :cond_0
    new-instance v5, Landroid/widget/ArrayAdapter;

    const v6, 0x1090008

    invoke-direct {v5, v0, v6, v3}, Landroid/widget/ArrayAdapter;-><init>(Landroid/content/Context;I[Ljava/lang/Object;)V

    const v3, 0x1090009

    invoke-virtual {v5, v3}, Landroid/widget/ArrayAdapter;->setDropDownViewResource(I)V

    iget-object v3, v0, Lcom/netwatch/app/MainActivity;->speedServerSpinner:Landroid/widget/Spinner;

    invoke-virtual {v3, v5}, Landroid/widget/Spinner;->setAdapter(Landroid/widget/SpinnerAdapter;)V

    iget-object v3, v0, Lcom/netwatch/app/MainActivity;->speedRunBtn:Landroid/widget/Button;

    new-instance v5, Lcom/netwatch/app/h;

    const/16 v6, 0x14

    invoke-direct {v5, v0, v6}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v3, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v3, v0, Lcom/netwatch/app/MainActivity;->tabSpeedBtn:Landroid/widget/Button;

    new-instance v5, Lcom/netwatch/app/h;

    invoke-direct {v5, v0, v4}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v3, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    sget v3, Lcom/netwatch/app/R$id;->tab6:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->tab6:Landroid/view/View;

    sget v3, Lcom/netwatch/app/R$id;->deviceToggleBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->deviceToggleBtn:Landroid/widget/Button;

    sget v3, Lcom/netwatch/app/R$id;->deviceExportBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->deviceExportBtn:Landroid/widget/Button;

    sget v3, Lcom/netwatch/app/R$id;->deviceClearBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->deviceClearBtn:Landroid/widget/Button;

    sget v3, Lcom/netwatch/app/R$id;->deviceTitleText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->deviceTitleText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->deviceStatusText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->deviceStatusText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->deviceCountText:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->deviceCountText:Landroid/widget/TextView;

    sget v3, Lcom/netwatch/app/R$id;->deviceLogContainer:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/LinearLayout;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->deviceLogContainer:Landroid/widget/LinearLayout;

    sget v3, Lcom/netwatch/app/R$id;->deviceHeaderRow:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/LinearLayout;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->deviceHeaderRow:Landroid/widget/LinearLayout;

    sget v3, Lcom/netwatch/app/R$id;->deviceScrollView:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/ScrollView;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->deviceScrollView:Landroid/widget/ScrollView;

    sget v3, Lcom/netwatch/app/R$id;->tabDeviceBtn:I

    invoke-virtual {v0, v3}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, v0, Lcom/netwatch/app/MainActivity;->tabDeviceBtn:Landroid/widget/Button;

    new-instance v5, Lcom/netwatch/app/h;

    const/4 v6, 0x2

    invoke-direct {v5, v0, v6}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v3, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v3, v0, Lcom/netwatch/app/MainActivity;->deviceToggleBtn:Landroid/widget/Button;

    new-instance v5, Lcom/netwatch/app/h;

    const/4 v7, 0x3

    invoke-direct {v5, v0, v7}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v3, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v3, v0, Lcom/netwatch/app/MainActivity;->deviceClearBtn:Landroid/widget/Button;

    new-instance v5, Lcom/netwatch/app/h;

    const/4 v7, 0x4

    invoke-direct {v5, v0, v7}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v3, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v3, v0, Lcom/netwatch/app/MainActivity;->deviceExportBtn:Landroid/widget/Button;

    new-instance v5, Lcom/netwatch/app/h;

    const/4 v7, 0x5

    invoke-direct {v5, v0, v7}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v3, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v3, v0, Lcom/netwatch/app/MainActivity;->exportTrafficBtn:Landroid/widget/Button;

    new-instance v5, Lcom/netwatch/app/h;

    const/4 v7, 0x6

    invoke-direct {v5, v0, v7}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v3, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    const-string v3, "alerts_enabled"

    invoke-interface {v1, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v3

    iput-boolean v3, v0, Lcom/netwatch/app/MainActivity;->alertsEnabled:Z

    iget-object v4, v0, Lcom/netwatch/app/MainActivity;->alertSwitch:Landroidx/appcompat/widget/SwitchCompat;

    invoke-virtual {v4, v3}, Landroidx/appcompat/widget/SwitchCompat;->setChecked(Z)V

    iget-object v3, v0, Lcom/netwatch/app/MainActivity;->alertSwitch:Landroidx/appcompat/widget/SwitchCompat;

    new-instance v4, Lcom/netwatch/app/i;

    invoke-direct {v4, v0, v1}, Lcom/netwatch/app/i;-><init>(Lcom/netwatch/app/MainActivity;Landroid/content/SharedPreferences;)V

    invoke-virtual {v3, v4}, Landroid/widget/CompoundButton;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    invoke-direct/range {p0 .. p0}, Lcom/netwatch/app/MainActivity;->refreshUiStrings()V

    iget-object v1, v0, Lcom/netwatch/app/MainActivity;->checkAllBtn:Landroid/widget/Button;

    new-instance v3, Lcom/netwatch/app/h;

    const/4 v4, 0x7

    invoke-direct {v3, v0, v4}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v1, v3}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v1, v0, Lcom/netwatch/app/MainActivity;->stopCheckBtn:Landroid/widget/Button;

    new-instance v3, Lcom/netwatch/app/h;

    const/16 v4, 0x8

    invoke-direct {v3, v0, v4}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v1, v3}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v1, v0, Lcom/netwatch/app/MainActivity;->checkCustomBtn:Landroid/widget/Button;

    new-instance v3, Lcom/netwatch/app/h;

    const/16 v4, 0x9

    invoke-direct {v3, v0, v4}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v1, v3}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v1, v0, Lcom/netwatch/app/MainActivity;->customDomainInput:Landroid/widget/EditText;

    new-instance v3, Lcom/netwatch/app/j;

    invoke-direct {v3, v0, v2}, Lcom/netwatch/app/j;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setOnEditorActionListener(Landroid/widget/TextView$OnEditorActionListener;)V

    invoke-direct/range {p0 .. p0}, Lcom/netwatch/app/MainActivity;->buildCheckerRows()V

    iget-object v1, v0, Lcom/netwatch/app/MainActivity;->trustedDomains:Ljava/util/Set;

    const-string v7, "google.com"

    const-string v8, "googleapis.com"

    const-string v9, "gstatic.com"

    const-string v10, "googlevideo.com"

    const-string v11, "googleusercontent.com"

    const-string v12, "akamai.net"

    const-string v13, "akamaized.net"

    const-string v14, "akamaitechnologies.com"

    const-string v15, "akamaiedge.net"

    const-string v16, "cloudflare.com"

    const-string v17, "cloudflare.net"

    const-string v18, "cdn.cloudflare.net"

    const-string v19, "fastly.net"

    const-string v20, "fastly.com"

    const-string v21, "amazon.com"

    const-string v22, "amazonaws.com"

    const-string v23, "awsstatic.com"

    const-string v24, "cloudfront.net"

    const-string v25, "microsoft.com"

    const-string v26, "azure.com"

    const-string v27, "msftconnecttest.com"

    const-string v28, "msedge.net"

    const-string v29, "apple.com"

    const-string v30, "icloud.com"

    const-string v31, "mzstatic.com"

    const-string v32, "facebook.com"

    const-string v33, "fbcdn.net"

    const-string v34, "instagram.com"

    const-string v35, "twitter.com"

    const-string v36, "twimg.com"

    const-string v37, "android.com"

    const-string v38, "android.clients.google.com"

    filled-new-array/range {v7 .. v38}, [Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/Set;->addAll(Ljava/util/Collection;)Z

    iget-object v1, v0, Lcom/netwatch/app/MainActivity;->startMonBtn:Landroid/widget/Button;

    new-instance v2, Lcom/netwatch/app/h;

    const/16 v3, 0xb

    invoke-direct {v2, v0, v3}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v1, v2}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v1, v0, Lcom/netwatch/app/MainActivity;->stopMonBtn:Landroid/widget/Button;

    new-instance v2, Lcom/netwatch/app/h;

    const/16 v3, 0xc

    invoke-direct {v2, v0, v3}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v1, v2}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v1, v0, Lcom/netwatch/app/MainActivity;->clearMonBtn:Landroid/widget/Button;

    new-instance v2, Lcom/netwatch/app/h;

    const/16 v3, 0xd

    invoke-direct {v2, v0, v3}, Lcom/netwatch/app/h;-><init>(Lcom/netwatch/app/MainActivity;I)V

    invoke-virtual {v1, v2}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v1, v0, Lcom/netwatch/app/MainActivity;->appSpinner:Landroid/widget/Spinner;

    const-string v2, "init"

    invoke-virtual {v1, v2}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    iget-object v1, v0, Lcom/netwatch/app/MainActivity;->appSpinner:Landroid/widget/Spinner;

    new-instance v2, Lcom/netwatch/app/MainActivity$1;

    invoke-direct {v2, v0}, Lcom/netwatch/app/MainActivity$1;-><init>(Lcom/netwatch/app/MainActivity;)V

    invoke-virtual {v1, v2}, Landroid/widget/AdapterView;->setOnItemSelectedListener(Landroid/widget/AdapterView$OnItemSelectedListener;)V

    new-instance v1, Lcom/netwatch/app/MainActivity$2;

    invoke-direct {v1, v0}, Lcom/netwatch/app/MainActivity$2;-><init>(Lcom/netwatch/app/MainActivity;)V

    iput-object v1, v0, Lcom/netwatch/app/MainActivity;->trafficReceiver:Landroid/content/BroadcastReceiver;

    new-instance v1, Landroid/content/IntentFilter;

    const-string v2, "com.netwatch.app.TRAFFIC_EVENT"

    invoke-direct {v1, v2}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x21

    if-lt v2, v3, :cond_1

    iget-object v4, v0, Lcom/netwatch/app/MainActivity;->trafficReceiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {v0, v4, v1, v6}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;I)Landroid/content/Intent;

    goto :goto_1

    :cond_1
    iget-object v4, v0, Lcom/netwatch/app/MainActivity;->trafficReceiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {v0, v4, v1}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    :goto_1
    if-lt v2, v3, :cond_2

    const-string v1, "android.permission.POST_NOTIFICATIONS"

    invoke-virtual {v0, v1}, Landroid/content/Context;->checkSelfPermission(Ljava/lang/String;)I

    move-result v2

    if-eqz v2, :cond_2

    filled-new-array {v1}, [Ljava/lang/String;

    move-result-object v1

    const/16 v2, 0x3ea

    invoke-virtual {v0, v1, v2}, Landroid/app/Activity;->requestPermissions([Ljava/lang/String;I)V

    :cond_2
    invoke-direct/range {p0 .. p0}, Lcom/netwatch/app/MainActivity;->loadAppList()V

    return-void
.end method

.method public onDestroy()V
    .locals 2

    invoke-super {p0}, Landroid/app/Activity;->onDestroy()V

    :try_start_0
    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->trafficReceiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {p0, v0}, Landroid/content/Context;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    iget-object v0, p0, Lcom/netwatch/app/MainActivity;->deviceReceiver:Landroid/content/BroadcastReceiver;

    if-eqz v0, :cond_0

    :try_start_1
    invoke-static {p0}, Landroidx/localbroadcastmanager/content/LocalBroadcastManager;->getInstance(Landroid/content/Context;)Landroidx/localbroadcastmanager/content/LocalBroadcastManager;

    move-result-object v0

    iget-object v1, p0, Lcom/netwatch/app/MainActivity;->deviceReceiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {v0, v1}, Landroidx/localbroadcastmanager/content/LocalBroadcastManager;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    :catch_1
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/netwatch/app/MainActivity;->deviceReceiver:Landroid/content/BroadcastReceiver;

    :cond_0
    iget-boolean v0, p0, Lcom/netwatch/app/MainActivity;->deviceMonRunning:Z

    if-eqz v0, :cond_1

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity;->stopDeviceMonitor()V

    :cond_1
    iget-object p0, p0, Lcom/netwatch/app/MainActivity;->executor:Ljava/util/concurrent/ExecutorService;

    invoke-interface {p0}, Ljava/util/concurrent/ExecutorService;->shutdownNow()Ljava/util/List;

    return-void
.end method
