.class public final synthetic Lcom/netwatch/app/v;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic b:I

.field public final synthetic c:Ljava/lang/Object;


# direct methods
.method public synthetic constructor <init>(ILjava/lang/Object;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p1, p0, Lcom/netwatch/app/v;->b:I

    iput-object p2, p0, Lcom/netwatch/app/v;->c:Ljava/lang/Object;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 1

    iget v0, p0, Lcom/netwatch/app/v;->b:I

    iget-object p0, p0, Lcom/netwatch/app/v;->c:Ljava/lang/Object;

    packed-switch v0, :pswitch_data_0

    check-cast p0, Lcom/netwatch/app/NetWatchVpnService;

    invoke-static {p0}, Lcom/netwatch/app/NetWatchVpnService;->c(Lcom/netwatch/app/NetWatchVpnService;)V

    return-void

    :pswitch_0
    check-cast p0, Lcom/netwatch/app/DeviceMonitorService;

    invoke-static {p0}, Lcom/netwatch/app/DeviceMonitorService;->a(Lcom/netwatch/app/DeviceMonitorService;)V

    return-void

    :pswitch_1
    check-cast p0, Lcom/netwatch/app/MainActivity$1;

    invoke-static {p0}, Lcom/netwatch/app/MainActivity$1;->a(Lcom/netwatch/app/MainActivity$1;)V

    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
