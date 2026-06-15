.class public Lcom/netwatch/app/NetWatchVpnService;
.super Landroid/net/VpnService;
.source "SourceFile"


# static fields
.field public static final ACTION_STOP:Ljava/lang/String; = "com.netwatch.app.STOP_VPN"

.field private static final CHANNEL_ID:Ljava/lang/String; = "netwatch_vpn"

.field private static final MTU:I = 0x5dc

.field private static final NOTIF_ID:I = 0x2a

.field private static final TAG:Ljava/lang/String; = "NetWatchVPN"

.field public static final TRAFFIC_ACTION:Ljava/lang/String; = "com.netwatch.app.DEVICE_TRAFFIC"


# instance fields
.field private final dnsCache:Ljava/util/concurrent/ConcurrentHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/ConcurrentHashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private dnsExecutor:Ljava/util/concurrent/ExecutorService;

.field private ioPool:Ljava/util/concurrent/ExecutorService;

.field private volatile running:Z

.field private final seenKeys:Ljava/util/concurrent/ConcurrentHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/ConcurrentHashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/Long;",
            ">;"
        }
    .end annotation
.end field

.field private vpnInterface:Landroid/os/ParcelFileDescriptor;


# direct methods
.method public constructor <init>()V
    .locals 1

    invoke-direct {p0}, Landroid/net/VpnService;-><init>()V

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/netwatch/app/NetWatchVpnService;->running:Z

    new-instance v0, Ljava/util/concurrent/ConcurrentHashMap;

    invoke-direct {v0}, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V

    iput-object v0, p0, Lcom/netwatch/app/NetWatchVpnService;->dnsCache:Ljava/util/concurrent/ConcurrentHashMap;

    new-instance v0, Ljava/util/concurrent/ConcurrentHashMap;

    invoke-direct {v0}, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V

    iput-object v0, p0, Lcom/netwatch/app/NetWatchVpnService;->seenKeys:Ljava/util/concurrent/ConcurrentHashMap;

    return-void
.end method

.method public static synthetic a(Lcom/netwatch/app/NetWatchVpnService;[BILjava/lang/String;ILjava/lang/String;ILjava/io/FileOutputStream;)V
    .locals 0

    invoke-direct/range {p0 .. p7}, Lcom/netwatch/app/NetWatchVpnService;->lambda$handleIPv4$0([BILjava/lang/String;ILjava/lang/String;ILjava/io/FileOutputStream;)V

    return-void
.end method

.method public static synthetic b(Lcom/netwatch/app/NetWatchVpnService;[BLjava/lang/String;ILjava/lang/String;ILjava/io/FileOutputStream;[BI)V
    .locals 0

    invoke-direct/range {p0 .. p8}, Lcom/netwatch/app/NetWatchVpnService;->lambda$handleIPv4$1([BLjava/lang/String;ILjava/lang/String;ILjava/io/FileOutputStream;[BI)V

    return-void
.end method

.method private buildNotification()Landroid/app/Notification;
    .locals 2

    new-instance v0, Landroid/app/Notification$Builder;

    const-string v1, "netwatch_vpn"

    invoke-direct {v0, p0, v1}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    const-string p0, "\ud83d\udcf6 NetWatch Device Monitor"

    invoke-virtual {v0, p0}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object p0

    const-string v0, "Monitoring all device connections"

    invoke-virtual {p0, v0}, Landroid/app/Notification$Builder;->setContentText(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object p0

    const v0, 0x1080039

    invoke-virtual {p0, v0}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;

    move-result-object p0

    return-object p0
.end method

.method private static buildUdpReply(Ljava/lang/String;ILjava/lang/String;I[BI)[B
    .locals 5

    add-int/lit8 v0, p5, 0x1c

    :try_start_0
    new-array v1, v0, [B

    const/16 v2, 0x45

    const/4 v3, 0x0

    aput-byte v2, v1, v3

    const/4 v2, 0x1

    aput-byte v3, v1, v2

    shr-int/lit8 v2, v0, 0x8

    int-to-byte v2, v2

    const/4 v4, 0x2

    aput-byte v2, v1, v4

    const/4 v2, 0x3

    int-to-byte v0, v0

    aput-byte v0, v1, v2

    const/4 v0, 0x4

    aput-byte v3, v1, v0

    const/4 v2, 0x5

    aput-byte v3, v1, v2

    const/4 v2, 0x6

    const/16 v4, 0x40

    aput-byte v4, v1, v2

    const/4 v2, 0x7

    aput-byte v3, v1, v2

    const/16 v2, 0x8

    aput-byte v4, v1, v2

    const/16 v2, 0x9

    const/16 v4, 0x11

    aput-byte v4, v1, v2

    invoke-static {p0}, Ljava/net/InetAddress;->getByName(Ljava/lang/String;)Ljava/net/InetAddress;

    move-result-object p0

    invoke-virtual {p0}, Ljava/net/InetAddress;->getAddress()[B

    move-result-object p0

    invoke-static {p2}, Ljava/net/InetAddress;->getByName(Ljava/lang/String;)Ljava/net/InetAddress;

    move-result-object p2

    invoke-virtual {p2}, Ljava/net/InetAddress;->getAddress()[B

    move-result-object p2

    const/16 v2, 0xc

    invoke-static {p0, v3, v1, v2, v0}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    const/16 p0, 0x10

    invoke-static {p2, v3, v1, p0, v0}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    const/16 p0, 0x14

    invoke-static {v1, v3, p0}, Lcom/netwatch/app/NetWatchVpnService;->ipChecksum([BII)I

    move-result p2

    shr-int/lit8 v0, p2, 0x8

    int-to-byte v0, v0

    const/16 v2, 0xa

    aput-byte v0, v1, v2

    const/16 v0, 0xb

    int-to-byte p2, p2

    aput-byte p2, v1, v0

    shr-int/lit8 p2, p1, 0x8

    int-to-byte p2, p2

    aput-byte p2, v1, p0

    const/16 p0, 0x15

    int-to-byte p1, p1

    aput-byte p1, v1, p0

    shr-int/lit8 p0, p3, 0x8

    int-to-byte p0, p0

    const/16 p1, 0x16

    aput-byte p0, v1, p1

    const/16 p0, 0x17

    int-to-byte p1, p3

    aput-byte p1, v1, p0

    add-int/lit8 p0, p5, 0x8

    shr-int/lit8 p1, p0, 0x8

    int-to-byte p1, p1

    const/16 p2, 0x18

    aput-byte p1, v1, p2

    const/16 p1, 0x19

    int-to-byte p0, p0

    aput-byte p0, v1, p1

    const/16 p0, 0x1a

    aput-byte v3, v1, p0

    const/16 p0, 0x1b

    aput-byte v3, v1, p0

    const/16 p0, 0x1c

    invoke-static {p4, v3, v1, p0, p5}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v1

    :catch_0
    const/4 p0, 0x0

    return-object p0
.end method

.method public static synthetic c(Lcom/netwatch/app/NetWatchVpnService;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/NetWatchVpnService;->runVpn()V

    return-void
.end method

.method private createNotificationChannel()V
    .locals 4

    const-string v0, "notification"

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/app/NotificationManager;

    new-instance v0, Landroid/app/NotificationChannel;

    const-string v1, "NetWatch VPN"

    const/4 v2, 0x2

    const-string v3, "netwatch_vpn"

    invoke-direct {v0, v3, v1, v2}, Landroid/app/NotificationChannel;-><init>(Ljava/lang/String;Ljava/lang/CharSequence;I)V

    invoke-virtual {p0, v0}, Landroid/app/NotificationManager;->createNotificationChannel(Landroid/app/NotificationChannel;)V

    return-void
.end method

.method public static synthetic d(Lcom/netwatch/app/NetWatchVpnService;Ljava/lang/String;Ljava/lang/String;I)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/netwatch/app/NetWatchVpnService;->lambda$reportConnection$2(Ljava/lang/String;Ljava/lang/String;I)V

    return-void
.end method

.method private emit(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V
    .locals 5

    new-instance v0, Ljava/text/SimpleDateFormat;

    const-string v1, "HH:mm:ss"

    sget-object v2, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-direct {v0, v1, v2}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v1, Ljava/util/Date;

    invoke-direct {v1}, Ljava/util/Date;-><init>()V

    invoke-virtual {v0, v1}, Ljava/text/DateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Landroid/content/Intent;

    const-string v2, "com.netwatch.app.DEVICE_TRAFFIC"

    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v2, "protocol"

    invoke-virtual {v1, v2, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const-string v2, "host"

    invoke-virtual {v1, v2, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, ":"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v4, "ipPort"

    invoke-virtual {v1, v4, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const-string v2, "timestamp"

    invoke-virtual {v1, v2, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const-string v0, "app"

    const-string v2, ""

    invoke-virtual {v1, v0, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    invoke-static {p0}, Landroidx/localbroadcastmanager/content/LocalBroadcastManager;->getInstance(Landroid/content/Context;)Landroidx/localbroadcastmanager/content/LocalBroadcastManager;

    move-result-object p0

    invoke-virtual {p0, v1}, Landroidx/localbroadcastmanager/content/LocalBroadcastManager;->sendBroadcast(Landroid/content/Intent;)Z

    const-string p0, "EMIT "

    const-string v0, " "

    invoke-static {p0, p1, v0}, Landroidx/activity/result/a;->j(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p2}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_0

    move-object p2, p3

    :cond_0
    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "NetWatchVPN"

    invoke-static {p1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private static extractUdpPayload([BII)[B
    .locals 2

    add-int/lit8 p1, p1, 0x8

    if-gt p2, p1, :cond_0

    const/4 p0, 0x0

    return-object p0

    :cond_0
    sub-int/2addr p2, p1

    new-array v0, p2, [B

    const/4 v1, 0x0

    invoke-static {p0, p1, v0, v1, p2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    return-object v0
.end method

.method private forwardTcp([BILjava/lang/String;ILjava/lang/String;ILjava/io/FileOutputStream;)V
    .locals 2

    const/4 p3, 0x0

    aget-byte p4, p1, p3

    and-int/lit8 p4, p4, 0xf

    mul-int/lit8 p4, p4, 0x4

    add-int/lit8 v0, p4, 0xc

    aget-byte v0, p1, v0

    shr-int/lit8 v0, v0, 0x4

    and-int/lit8 v0, v0, 0xf

    mul-int/lit8 v0, v0, 0x4

    add-int/2addr v0, p4

    sub-int v1, p2, v0

    add-int/lit8 p4, p4, 0xd

    aget-byte p4, p1, p4

    if-gtz v1, :cond_0

    :try_start_0
    invoke-virtual {p7, p1, p3, p2}, Ljava/io/FileOutputStream;->write([BII)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    return-void

    :cond_0
    :try_start_1
    invoke-static {}, Ljava/nio/channels/SocketChannel;->open()Ljava/nio/channels/SocketChannel;

    move-result-object p2

    invoke-virtual {p2}, Ljava/nio/channels/SocketChannel;->socket()Ljava/net/Socket;

    move-result-object p3

    invoke-virtual {p0, p3}, Landroid/net/VpnService;->protect(Ljava/net/Socket;)Z

    invoke-virtual {p2}, Ljava/nio/channels/SocketChannel;->socket()Ljava/net/Socket;

    move-result-object p0

    const/16 p3, 0x1388

    invoke-virtual {p0, p3}, Ljava/net/Socket;->setSoTimeout(I)V

    new-instance p0, Ljava/net/InetSocketAddress;

    invoke-static {p5}, Ljava/net/InetAddress;->getByName(Ljava/lang/String;)Ljava/net/InetAddress;

    move-result-object p3

    invoke-direct {p0, p3, p6}, Ljava/net/InetSocketAddress;-><init>(Ljava/net/InetAddress;I)V

    invoke-virtual {p2, p0}, Ljava/nio/channels/SocketChannel;->connect(Ljava/net/SocketAddress;)Z

    invoke-static {p1, v0, v1}, Ljava/nio/ByteBuffer;->wrap([BII)Ljava/nio/ByteBuffer;

    move-result-object p0

    invoke-virtual {p2, p0}, Ljava/nio/channels/SocketChannel;->write(Ljava/nio/ByteBuffer;)I

    invoke-virtual {p2}, Ljava/nio/channels/spi/AbstractInterruptibleChannel;->close()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_0

    :catch_1
    move-exception p0

    new-instance p1, Ljava/lang/StringBuilder;

    const-string p2, "TCP fwd error: "

    invoke-direct {p1, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "NetWatchVPN"

    invoke-static {p1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method

.method private forwardUdp([BLjava/lang/String;ILjava/lang/String;ILjava/io/FileOutputStream;[BI)V
    .locals 6

    :try_start_0
    invoke-static {}, Ljava/nio/channels/DatagramChannel;->open()Ljava/nio/channels/DatagramChannel;

    move-result-object p7

    invoke-virtual {p7}, Ljava/nio/channels/DatagramChannel;->socket()Ljava/net/DatagramSocket;

    move-result-object p8

    invoke-virtual {p0, p8}, Landroid/net/VpnService;->protect(Ljava/net/DatagramSocket;)Z

    invoke-virtual {p7}, Ljava/nio/channels/DatagramChannel;->socket()Ljava/net/DatagramSocket;

    move-result-object p0

    const/16 p8, 0x7d0

    invoke-virtual {p0, p8}, Ljava/net/DatagramSocket;->setSoTimeout(I)V

    invoke-static {p1}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object p0

    new-instance p1, Ljava/net/InetSocketAddress;

    invoke-static {p4}, Ljava/net/InetAddress;->getByName(Ljava/lang/String;)Ljava/net/InetAddress;

    move-result-object v0

    invoke-direct {p1, v0, p5}, Ljava/net/InetSocketAddress;-><init>(Ljava/net/InetAddress;I)V

    invoke-virtual {p7, p0, p1}, Ljava/nio/channels/DatagramChannel;->send(Ljava/nio/ByteBuffer;Ljava/net/SocketAddress;)I

    const/16 p0, 0x5dc

    invoke-static {p0}, Ljava/nio/ByteBuffer;->allocate(I)Ljava/nio/ByteBuffer;

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    :try_start_1
    invoke-virtual {p7}, Ljava/nio/channels/DatagramChannel;->socket()Ljava/net/DatagramSocket;

    move-result-object p1

    invoke-virtual {p1, p8}, Ljava/net/DatagramSocket;->setSoTimeout(I)V

    new-instance p1, Ljava/net/DatagramPacket;

    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->array()[B

    move-result-object p8

    invoke-virtual {p0}, Ljava/nio/Buffer;->capacity()I

    move-result p0

    invoke-direct {p1, p8, p0}, Ljava/net/DatagramPacket;-><init>([BI)V

    invoke-virtual {p7}, Ljava/nio/channels/DatagramChannel;->socket()Ljava/net/DatagramSocket;

    move-result-object p0

    invoke-virtual {p0, p1}, Ljava/net/DatagramSocket;->receive(Ljava/net/DatagramPacket;)V

    invoke-virtual {p1}, Ljava/net/DatagramPacket;->getData()[B

    move-result-object v4

    invoke-virtual {p1}, Ljava/net/DatagramPacket;->getLength()I

    move-result v5

    move-object v0, p4

    move v1, p5

    move-object v2, p2

    move v3, p3

    invoke-static/range {v0 .. v5}, Lcom/netwatch/app/NetWatchVpnService;->buildUdpReply(Ljava/lang/String;ILjava/lang/String;I[BI)[B

    move-result-object p0

    if-eqz p0, :cond_0

    monitor-enter p6
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    :try_start_2
    invoke-virtual {p6, p0}, Ljava/io/FileOutputStream;->write([B)V

    monitor-exit p6

    goto :goto_0

    :catchall_0
    move-exception p0

    monitor-exit p6
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    :try_start_3
    throw p0
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0

    :catch_0
    :cond_0
    :goto_0
    :try_start_4
    invoke-virtual {p7}, Ljava/nio/channels/spi/AbstractInterruptibleChannel;->close()V
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_1

    goto :goto_1

    :catch_1
    move-exception p0

    const-string p1, "NetWatchVPN"

    new-instance p2, Ljava/lang/StringBuilder;

    const-string p3, "UDP fwd error: "

    invoke-direct {p2, p3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :goto_1
    return-void
.end method

.method private handleIPv4([BILjava/io/FileOutputStream;)V
    .locals 20

    move-object/from16 v1, p0

    move-object/from16 v8, p1

    move/from16 v3, p2

    move-object/from16 v9, p3

    const/4 v0, 0x0

    aget-byte v2, v8, v0

    and-int/lit8 v2, v2, 0xf

    mul-int/lit8 v10, v2, 0x4

    const/16 v2, 0x9

    aget-byte v2, v8, v2

    and-int/lit16 v2, v2, 0xff

    add-int/lit8 v4, v10, 0x4

    if-ge v3, v4, :cond_0

    invoke-virtual {v9, v8, v0, v3}, Ljava/io/FileOutputStream;->write([BII)V

    return-void

    :cond_0
    const/16 v4, 0xc

    invoke-static {v8, v4}, Lcom/netwatch/app/NetWatchVpnService;->ipv4([BI)Ljava/lang/String;

    move-result-object v4

    const/16 v5, 0x10

    invoke-static {v8, v5}, Lcom/netwatch/app/NetWatchVpnService;->ipv4([BI)Ljava/lang/String;

    move-result-object v6

    invoke-static {v8, v10}, Lcom/netwatch/app/NetWatchVpnService;->u16([BI)I

    move-result v5

    add-int/lit8 v7, v10, 0x2

    invoke-static {v8, v7}, Lcom/netwatch/app/NetWatchVpnService;->u16([BI)I

    move-result v7

    const/4 v11, 0x6

    if-eq v2, v11, :cond_1

    const/16 v12, 0x11

    if-eq v2, v12, :cond_1

    invoke-virtual {v9, v8, v0, v3}, Ljava/io/FileOutputStream;->write([BII)V

    return-void

    :cond_1
    const-string v12, "127."

    invoke-virtual {v6, v12}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v12

    if-nez v12, :cond_8

    const-string v12, "224."

    invoke-virtual {v6, v12}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v12

    if-nez v12, :cond_8

    const-string v12, "239."

    invoke-virtual {v6, v12}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v12

    if-nez v12, :cond_8

    const-string v12, "255."

    invoke-virtual {v6, v12}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v12

    if-nez v12, :cond_8

    const-string v12, "0.0.0.0"

    invoke-virtual {v6, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v12

    if-nez v12, :cond_8

    if-nez v7, :cond_2

    goto/16 :goto_2

    :cond_2
    if-ne v2, v11, :cond_3

    const-string v12, "TCP"

    goto :goto_0

    :cond_3
    const-string v12, "UDP"

    :goto_0
    new-instance v13, Ljava/lang/StringBuilder;

    invoke-direct {v13}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v13, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v14, ":"

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v13

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v14

    iget-object v0, v1, Lcom/netwatch/app/NetWatchVpnService;->seenKeys:Ljava/util/concurrent/ConcurrentHashMap;

    invoke-virtual {v0, v13}, Ljava/util/concurrent/ConcurrentHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Long;

    if-eqz v0, :cond_4

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v16

    sub-long v16, v14, v16

    const-wide/16 v18, 0x7530

    cmp-long v0, v16, v18

    if-lez v0, :cond_5

    :cond_4
    iget-object v0, v1, Lcom/netwatch/app/NetWatchVpnService;->seenKeys:Ljava/util/concurrent/ConcurrentHashMap;

    invoke-static {v14, v15}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v14

    invoke-virtual {v0, v13, v14}, Ljava/util/concurrent/ConcurrentHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    invoke-direct {v1, v12, v6, v7}, Lcom/netwatch/app/NetWatchVpnService;->reportConnection(Ljava/lang/String;Ljava/lang/String;I)V

    :cond_5
    if-ne v2, v11, :cond_6

    iget-object v10, v1, Lcom/netwatch/app/NetWatchVpnService;->ioPool:Ljava/util/concurrent/ExecutorService;

    new-instance v11, Lcom/netwatch/app/x;

    move-object v0, v11

    move-object/from16 v1, p0

    move-object/from16 v2, p1

    move/from16 v3, p2

    move-object/from16 v8, p3

    invoke-direct/range {v0 .. v8}, Lcom/netwatch/app/x;-><init>(Lcom/netwatch/app/NetWatchVpnService;[BILjava/lang/String;ILjava/lang/String;ILjava/io/FileOutputStream;)V

    invoke-interface {v10, v11}, Ljava/util/concurrent/Executor;->execute(Ljava/lang/Runnable;)V

    goto :goto_1

    :cond_6
    invoke-static {v8, v10, v3}, Lcom/netwatch/app/NetWatchVpnService;->extractUdpPayload([BII)[B

    move-result-object v2

    if-eqz v2, :cond_7

    iget-object v11, v1, Lcom/netwatch/app/NetWatchVpnService;->ioPool:Ljava/util/concurrent/ExecutorService;

    new-instance v12, Lcom/netwatch/app/y;

    move-object v0, v12

    move-object/from16 v1, p0

    move-object v3, v4

    move v4, v5

    move-object v5, v6

    move v6, v7

    move-object/from16 v7, p3

    move-object/from16 v8, p1

    move v9, v10

    invoke-direct/range {v0 .. v9}, Lcom/netwatch/app/y;-><init>(Lcom/netwatch/app/NetWatchVpnService;[BLjava/lang/String;ILjava/lang/String;ILjava/io/FileOutputStream;[BI)V

    invoke-interface {v11, v12}, Ljava/util/concurrent/Executor;->execute(Ljava/lang/Runnable;)V

    goto :goto_1

    :cond_7
    const/4 v0, 0x0

    invoke-virtual {v9, v8, v0, v3}, Ljava/io/FileOutputStream;->write([BII)V

    :goto_1
    return-void

    :cond_8
    :goto_2
    invoke-virtual {v9, v8, v0, v3}, Ljava/io/FileOutputStream;->write([BII)V

    return-void
.end method

.method private static ipChecksum([BII)I
    .locals 4

    const/4 v0, 0x0

    move v1, p1

    :goto_0
    add-int v2, p1, p2

    if-ge v1, v2, :cond_0

    aget-byte v2, p0, v1

    and-int/lit16 v2, v2, 0xff

    shl-int/lit8 v2, v2, 0x8

    add-int/lit8 v3, v1, 0x1

    aget-byte v3, p0, v3

    and-int/lit16 v3, v3, 0xff

    or-int/2addr v2, v3

    add-int/2addr v0, v2

    add-int/lit8 v1, v1, 0x2

    goto :goto_0

    :cond_0
    :goto_1
    shr-int/lit8 p0, v0, 0x10

    const p1, 0xffff

    if-eqz p0, :cond_1

    and-int/2addr p1, v0

    add-int v0, p1, p0

    goto :goto_1

    :cond_1
    not-int p0, v0

    and-int/2addr p0, p1

    return p0
.end method

.method private static ipv4([BI)Ljava/lang/String;
    .locals 3

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    aget-byte v1, p0, p1

    and-int/lit16 v1, v1, 0xff

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, "."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v2, p1, 0x1

    aget-byte v2, p0, v2

    and-int/lit16 v2, v2, 0xff

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v2, p1, 0x2

    aget-byte v2, p0, v2

    and-int/lit16 v2, v2, 0xff

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 p1, p1, 0x3

    aget-byte p0, p0, p1

    and-int/lit16 p0, p0, 0xff

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private synthetic lambda$handleIPv4$0([BILjava/lang/String;ILjava/lang/String;ILjava/io/FileOutputStream;)V
    .locals 0

    invoke-direct/range {p0 .. p7}, Lcom/netwatch/app/NetWatchVpnService;->forwardTcp([BILjava/lang/String;ILjava/lang/String;ILjava/io/FileOutputStream;)V

    return-void
.end method

.method private synthetic lambda$handleIPv4$1([BLjava/lang/String;ILjava/lang/String;ILjava/io/FileOutputStream;[BI)V
    .locals 0

    invoke-direct/range {p0 .. p8}, Lcom/netwatch/app/NetWatchVpnService;->forwardUdp([BLjava/lang/String;ILjava/lang/String;ILjava/io/FileOutputStream;[BI)V

    return-void
.end method

.method private synthetic lambda$reportConnection$2(Ljava/lang/String;Ljava/lang/String;I)V
    .locals 2

    :try_start_0
    invoke-static {p1}, Ljava/net/InetAddress;->getByName(Ljava/lang/String;)Ljava/net/InetAddress;

    move-result-object v0

    invoke-virtual {v0}, Ljava/net/InetAddress;->getHostName()Ljava/lang/String;

    move-result-object v0

    iget-object v1, p0, Lcom/netwatch/app/NetWatchVpnService;->dnsCache:Ljava/util/concurrent/ConcurrentHashMap;

    invoke-virtual {v1, p1, v0}, Ljava/util/concurrent/ConcurrentHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_0

    invoke-direct {p0, p2, v0, p1, p3}, Lcom/netwatch/app/NetWatchVpnService;->emit(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    iget-object p0, p0, Lcom/netwatch/app/NetWatchVpnService;->dnsCache:Ljava/util/concurrent/ConcurrentHashMap;

    invoke-virtual {p0, p1, p1}, Ljava/util/concurrent/ConcurrentHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_0
    :goto_0
    return-void
.end method

.method private reportConnection(Ljava/lang/String;Ljava/lang/String;I)V
    .locals 2

    iget-object v0, p0, Lcom/netwatch/app/NetWatchVpnService;->dnsCache:Ljava/util/concurrent/ConcurrentHashMap;

    invoke-virtual {v0, p2}, Ljava/util/concurrent/ConcurrentHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    if-eqz v0, :cond_0

    invoke-virtual {v0, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_0

    move-object v1, v0

    goto :goto_0

    :cond_0
    const-string v1, ""

    :goto_0
    invoke-direct {p0, p1, v1, p2, p3}, Lcom/netwatch/app/NetWatchVpnService;->emit(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V

    if-nez v0, :cond_1

    iget-object v0, p0, Lcom/netwatch/app/NetWatchVpnService;->dnsExecutor:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/netwatch/app/c;

    invoke-direct {v1, p0, p2, p1, p3}, Lcom/netwatch/app/c;-><init>(Lcom/netwatch/app/NetWatchVpnService;Ljava/lang/String;Ljava/lang/String;I)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    :cond_1
    return-void
.end method

.method private runVpn()V
    .locals 9

    const-string v0, "NetWatchVPN"

    const/4 v1, 0x0

    :try_start_0
    new-instance v2, Landroid/net/VpnService$Builder;

    invoke-direct {v2, p0}, Landroid/net/VpnService$Builder;-><init>(Landroid/net/VpnService;)V

    const/16 v3, 0x5dc

    invoke-virtual {v2, v3}, Landroid/net/VpnService$Builder;->setMtu(I)Landroid/net/VpnService$Builder;

    const-string v3, "10.99.0.1"

    const/16 v4, 0x18

    invoke-virtual {v2, v3, v4}, Landroid/net/VpnService$Builder;->addAddress(Ljava/lang/String;I)Landroid/net/VpnService$Builder;

    const-string v3, "0.0.0.0"

    invoke-virtual {v2, v3, v1}, Landroid/net/VpnService$Builder;->addRoute(Ljava/lang/String;I)Landroid/net/VpnService$Builder;

    const-string v3, "8.8.8.8"

    invoke-virtual {v2, v3}, Landroid/net/VpnService$Builder;->addDnsServer(Ljava/lang/String;)Landroid/net/VpnService$Builder;

    const-string v3, "1.1.1.1"

    invoke-virtual {v2, v3}, Landroid/net/VpnService$Builder;->addDnsServer(Ljava/lang/String;)Landroid/net/VpnService$Builder;

    const-string v3, "NetWatch"

    invoke-virtual {v2, v3}, Landroid/net/VpnService$Builder;->setSession(Ljava/lang/String;)Landroid/net/VpnService$Builder;

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/net/VpnService$Builder;->addDisallowedApplication(Ljava/lang/String;)Landroid/net/VpnService$Builder;

    invoke-virtual {v2}, Landroid/net/VpnService$Builder;->establish()Landroid/os/ParcelFileDescriptor;

    move-result-object v2

    iput-object v2, p0, Lcom/netwatch/app/NetWatchVpnService;->vpnInterface:Landroid/os/ParcelFileDescriptor;

    if-nez v2, :cond_1

    const-string v2, "establish() returned null \u2014 permission denied?"

    invoke-static {v0, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    iput-boolean v1, p0, Lcom/netwatch/app/NetWatchVpnService;->running:Z

    :try_start_1
    iget-object p0, p0, Lcom/netwatch/app/NetWatchVpnService;->vpnInterface:Landroid/os/ParcelFileDescriptor;

    if-eqz p0, :cond_0

    invoke-virtual {p0}, Landroid/os/ParcelFileDescriptor;->close()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    :catch_0
    :cond_0
    return-void

    :catchall_0
    move-exception v0

    goto :goto_5

    :catch_1
    move-exception v2

    goto :goto_3

    :cond_1
    :try_start_2
    const-string v2, "VPN established"

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v2, 0x1

    iput-boolean v2, p0, Lcom/netwatch/app/NetWatchVpnService;->running:Z

    new-instance v2, Ljava/io/FileInputStream;

    iget-object v3, p0, Lcom/netwatch/app/NetWatchVpnService;->vpnInterface:Landroid/os/ParcelFileDescriptor;

    invoke-virtual {v3}, Landroid/os/ParcelFileDescriptor;->getFileDescriptor()Ljava/io/FileDescriptor;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/io/FileInputStream;-><init>(Ljava/io/FileDescriptor;)V

    new-instance v3, Ljava/io/FileOutputStream;

    iget-object v4, p0, Lcom/netwatch/app/NetWatchVpnService;->vpnInterface:Landroid/os/ParcelFileDescriptor;

    invoke-virtual {v4}, Landroid/os/ParcelFileDescriptor;->getFileDescriptor()Ljava/io/FileDescriptor;

    move-result-object v4

    invoke-direct {v3, v4}, Ljava/io/FileOutputStream;-><init>(Ljava/io/FileDescriptor;)V

    const/16 v4, 0x640

    new-array v4, v4, [B

    :goto_0
    iget-boolean v5, p0, Lcom/netwatch/app/NetWatchVpnService;->running:Z

    if-eqz v5, :cond_5

    invoke-virtual {v2, v4}, Ljava/io/FileInputStream;->read([B)I

    move-result v5

    if-gez v5, :cond_2

    goto :goto_1

    :cond_2
    const/16 v6, 0x14

    if-ge v5, v6, :cond_3

    goto :goto_0

    :cond_3
    new-array v6, v5, [B

    invoke-static {v4, v1, v6, v1, v5}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    aget-byte v7, v6, v1

    const/4 v8, 0x4

    shr-int/2addr v7, v8

    and-int/lit8 v7, v7, 0xf

    if-ne v7, v8, :cond_4

    invoke-direct {p0, v6, v5, v3}, Lcom/netwatch/app/NetWatchVpnService;->handleIPv4([BILjava/io/FileOutputStream;)V

    goto :goto_0

    :cond_4
    invoke-virtual {v3, v6, v1, v5}, Ljava/io/FileOutputStream;->write([BII)V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto :goto_0

    :cond_5
    :goto_1
    iput-boolean v1, p0, Lcom/netwatch/app/NetWatchVpnService;->running:Z

    :try_start_3
    iget-object p0, p0, Lcom/netwatch/app/NetWatchVpnService;->vpnInterface:Landroid/os/ParcelFileDescriptor;

    if-eqz p0, :cond_7

    :goto_2
    invoke-virtual {p0}, Landroid/os/ParcelFileDescriptor;->close()V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_2

    goto :goto_4

    :goto_3
    :try_start_4
    iget-boolean v3, p0, Lcom/netwatch/app/NetWatchVpnService;->running:Z

    if-eqz v3, :cond_6

    const-string v3, "VPN loop error"

    invoke-static {v0, v3, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    :cond_6
    iput-boolean v1, p0, Lcom/netwatch/app/NetWatchVpnService;->running:Z

    :try_start_5
    iget-object p0, p0, Lcom/netwatch/app/NetWatchVpnService;->vpnInterface:Landroid/os/ParcelFileDescriptor;
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_2

    if-eqz p0, :cond_7

    goto :goto_2

    :catch_2
    :cond_7
    :goto_4
    return-void

    :goto_5
    iput-boolean v1, p0, Lcom/netwatch/app/NetWatchVpnService;->running:Z

    :try_start_6
    iget-object p0, p0, Lcom/netwatch/app/NetWatchVpnService;->vpnInterface:Landroid/os/ParcelFileDescriptor;

    if-eqz p0, :cond_8

    invoke-virtual {p0}, Landroid/os/ParcelFileDescriptor;->close()V
    :try_end_6
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_6} :catch_3

    :catch_3
    :cond_8
    throw v0
.end method

.method private static u16([BI)I
    .locals 1

    aget-byte v0, p0, p1

    and-int/lit16 v0, v0, 0xff

    shl-int/lit8 v0, v0, 0x8

    add-int/lit8 p1, p1, 0x1

    aget-byte p0, p0, p1

    and-int/lit16 p0, p0, 0xff

    or-int/2addr p0, v0

    return p0
.end method


# virtual methods
.method public onDestroy()V
    .locals 1

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/netwatch/app/NetWatchVpnService;->running:Z

    iget-object v0, p0, Lcom/netwatch/app/NetWatchVpnService;->ioPool:Ljava/util/concurrent/ExecutorService;

    if-eqz v0, :cond_0

    invoke-interface {v0}, Ljava/util/concurrent/ExecutorService;->shutdownNow()Ljava/util/List;

    :cond_0
    iget-object v0, p0, Lcom/netwatch/app/NetWatchVpnService;->dnsExecutor:Ljava/util/concurrent/ExecutorService;

    if-eqz v0, :cond_1

    invoke-interface {v0}, Ljava/util/concurrent/ExecutorService;->shutdownNow()Ljava/util/List;

    :cond_1
    :try_start_0
    iget-object v0, p0, Lcom/netwatch/app/NetWatchVpnService;->vpnInterface:Landroid/os/ParcelFileDescriptor;

    if-eqz v0, :cond_2

    invoke-virtual {v0}, Landroid/os/ParcelFileDescriptor;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :cond_2
    invoke-super {p0}, Landroid/app/Service;->onDestroy()V

    return-void
.end method

.method public onStartCommand(Landroid/content/Intent;II)I
    .locals 3

    const/4 p2, 0x2

    const/4 p3, 0x1

    if-eqz p1, :cond_1

    const-string v0, "com.netwatch.app.STOP_VPN"

    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    const/4 p1, 0x0

    iput-boolean p1, p0, Lcom/netwatch/app/NetWatchVpnService;->running:Z

    :try_start_0
    iget-object p1, p0, Lcom/netwatch/app/NetWatchVpnService;->vpnInterface:Landroid/os/ParcelFileDescriptor;

    if-eqz p1, :cond_0

    invoke-virtual {p1}, Landroid/os/ParcelFileDescriptor;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :cond_0
    invoke-virtual {p0, p3}, Landroid/app/Service;->stopForeground(Z)V

    invoke-virtual {p0}, Landroid/app/Service;->stopSelf()V

    return p2

    :cond_1
    invoke-direct {p0}, Lcom/netwatch/app/NetWatchVpnService;->createNotificationChannel()V

    invoke-direct {p0}, Lcom/netwatch/app/NetWatchVpnService;->buildNotification()Landroid/app/Notification;

    move-result-object p1

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x22

    const/16 v2, 0x2a

    if-lt v0, v1, :cond_2

    const/high16 v0, 0x40000000    # 2.0f

    invoke-virtual {p0, v2, p1, v0}, Landroid/app/Service;->startForeground(ILandroid/app/Notification;I)V

    goto :goto_0

    :cond_2
    invoke-virtual {p0, v2, p1}, Landroid/app/Service;->startForeground(ILandroid/app/Notification;)V

    :goto_0
    invoke-static {}, Ljava/util/concurrent/Executors;->newCachedThreadPool()Ljava/util/concurrent/ExecutorService;

    move-result-object p1

    iput-object p1, p0, Lcom/netwatch/app/NetWatchVpnService;->ioPool:Ljava/util/concurrent/ExecutorService;

    const/4 p1, 0x4

    invoke-static {p1}, Ljava/util/concurrent/Executors;->newFixedThreadPool(I)Ljava/util/concurrent/ExecutorService;

    move-result-object p1

    iput-object p1, p0, Lcom/netwatch/app/NetWatchVpnService;->dnsExecutor:Ljava/util/concurrent/ExecutorService;

    iget-object p1, p0, Lcom/netwatch/app/NetWatchVpnService;->ioPool:Ljava/util/concurrent/ExecutorService;

    new-instance v0, Lcom/netwatch/app/v;

    invoke-direct {v0, p2, p0}, Lcom/netwatch/app/v;-><init>(ILjava/lang/Object;)V

    invoke-interface {p1, v0}, Ljava/util/concurrent/Executor;->execute(Ljava/lang/Runnable;)V

    return p3
.end method
