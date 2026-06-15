.class Lcom/netwatch/app/MainActivity$3;
.super Landroid/content/BroadcastReceiver;
.source "SourceFile"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/netwatch/app/MainActivity;->launchDeviceVpn()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/netwatch/app/MainActivity;


# direct methods
.method public constructor <init>(Lcom/netwatch/app/MainActivity;)V
    .locals 0

    iput-object p1, p0, Lcom/netwatch/app/MainActivity$3;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method

.method public static synthetic a(Lcom/netwatch/app/MainActivity$3;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity$3;->lambda$onReceive$0()V

    return-void
.end method

.method public static synthetic b(Lcom/netwatch/app/MainActivity$3;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity$3;->lambda$onReceive$1()V

    return-void
.end method

.method private synthetic lambda$onReceive$0()V
    .locals 0

    iget-object p0, p0, Lcom/netwatch/app/MainActivity$3;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-static {p0}, Lcom/netwatch/app/MainActivity;->e0(Lcom/netwatch/app/MainActivity;)V

    return-void
.end method

.method private synthetic lambda$onReceive$1()V
    .locals 0

    iget-object p0, p0, Lcom/netwatch/app/MainActivity$3;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-static {p0}, Lcom/netwatch/app/MainActivity;->e0(Lcom/netwatch/app/MainActivity;)V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 11

    const-string p1, "protocol"

    invoke-virtual {p2, p1}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    const-string v0, "host"

    invoke-virtual {p2, v0}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "ipPort"

    invoke-virtual {p2, v1}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string v1, "app"

    invoke-virtual {p2, v1}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "timestamp"

    invoke-virtual {p2, v2}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    if-nez v4, :cond_0

    return-void

    :cond_0
    if-eqz p1, :cond_1

    :goto_0
    move-object v5, p1

    goto :goto_1

    :cond_1
    const-string p1, "?"

    goto :goto_0

    :goto_1
    if-eqz v1, :cond_2

    move-object v7, v1

    goto :goto_2

    :cond_2
    const-string p1, ""

    move-object v7, p1

    :goto_2
    if-eqz p2, :cond_3

    move-object v6, p2

    goto :goto_3

    :cond_3
    const-string p1, ""

    move-object v6, p1

    :goto_3
    const/4 p1, 0x0

    if-eqz v0, :cond_4

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result p2

    if-nez p2, :cond_4

    move-object v3, v0

    goto :goto_4

    :cond_4
    const-string p2, ":"

    invoke-virtual {v4, p2}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p2

    aget-object p2, p2, p1

    move-object v3, p2

    :goto_4
    iget-object p2, p0, Lcom/netwatch/app/MainActivity$3;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-static {p2}, Lcom/netwatch/app/MainActivity;->Y(Lcom/netwatch/app/MainActivity;)Ljava/util/ArrayList;

    move-result-object p2

    monitor-enter p2

    const/4 v1, 0x1

    if-eqz v0, :cond_6

    :try_start_0
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_6

    iget-object v2, p0, Lcom/netwatch/app/MainActivity$3;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-static {v2}, Lcom/netwatch/app/MainActivity;->Y(Lcom/netwatch/app/MainActivity;)Ljava/util/ArrayList;

    move-result-object v2

    invoke-virtual {v2}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_5
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v8

    if-eqz v8, :cond_6

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v8

    check-cast v8, [Ljava/lang/String;

    const/4 v9, 0x2

    aget-object v9, v8, v9

    invoke-virtual {v9, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_5

    aget-object v9, v8, v1

    const-string v10, ":"

    invoke-virtual {v4, v10}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v10

    aget-object v10, v10, p1

    invoke-virtual {v9, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_5

    aput-object v0, v8, v1

    iget-object v0, p0, Lcom/netwatch/app/MainActivity$3;->this$0:Lcom/netwatch/app/MainActivity;

    new-instance v1, Lcom/netwatch/app/w;

    invoke-direct {v1, p0, p1}, Lcom/netwatch/app/w;-><init>(Lcom/netwatch/app/MainActivity$3;I)V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    monitor-exit p2

    return-void

    :catchall_0
    move-exception p0

    goto :goto_5

    :cond_6
    iget-object p1, p0, Lcom/netwatch/app/MainActivity$3;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-static {p1}, Lcom/netwatch/app/MainActivity;->Y(Lcom/netwatch/app/MainActivity;)Ljava/util/ArrayList;

    move-result-object p1

    move-object v2, v3

    filled-new-array/range {v2 .. v7}, [Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    monitor-exit p2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    iget-object p1, p0, Lcom/netwatch/app/MainActivity$3;->this$0:Lcom/netwatch/app/MainActivity;

    new-instance p2, Lcom/netwatch/app/w;

    invoke-direct {p2, p0, v1}, Lcom/netwatch/app/w;-><init>(Lcom/netwatch/app/MainActivity$3;I)V

    invoke-virtual {p1, p2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void

    :goto_5
    :try_start_1
    monitor-exit p2
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method
