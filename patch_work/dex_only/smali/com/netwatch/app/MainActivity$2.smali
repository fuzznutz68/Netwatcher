.class Lcom/netwatch/app/MainActivity$2;
.super Landroid/content/BroadcastReceiver;
.source "SourceFile"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/netwatch/app/MainActivity;->onCreate(Landroid/os/Bundle;)V
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

    iput-object p1, p0, Lcom/netwatch/app/MainActivity$2;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 12

    const-string p1, "tx_bytes"

    const-wide/16 v0, 0x0

    invoke-virtual {p2, p1, v0, v1}, Landroid/content/Intent;->getLongExtra(Ljava/lang/String;J)J

    move-result-wide v3

    const-string p1, "rx_bytes"

    invoke-virtual {p2, p1, v0, v1}, Landroid/content/Intent;->getLongExtra(Ljava/lang/String;J)J

    move-result-wide v5

    const-string p1, "tx_rate"

    invoke-virtual {p2, p1, v0, v1}, Landroid/content/Intent;->getLongExtra(Ljava/lang/String;J)J

    move-result-wide v7

    const-string p1, "rx_rate"

    invoke-virtual {p2, p1, v0, v1}, Landroid/content/Intent;->getLongExtra(Ljava/lang/String;J)J

    move-result-wide v9

    const-string p1, "hosts"

    invoke-virtual {p2, p1}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    iget-object v2, p0, Lcom/netwatch/app/MainActivity$2;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-static/range {v2 .. v11}, Lcom/netwatch/app/MainActivity;->i0(Lcom/netwatch/app/MainActivity;JJJJLjava/lang/String;)V

    return-void
.end method
