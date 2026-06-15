.class public final synthetic Lcom/netwatch/app/z;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic b:I

.field public final synthetic c:Lcom/netwatch/app/TrafficMonitorService;

.field public final synthetic d:Ljava/lang/String;


# direct methods
.method public synthetic constructor <init>(Lcom/netwatch/app/TrafficMonitorService;Ljava/lang/String;I)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p3, p0, Lcom/netwatch/app/z;->b:I

    iput-object p1, p0, Lcom/netwatch/app/z;->c:Lcom/netwatch/app/TrafficMonitorService;

    iput-object p2, p0, Lcom/netwatch/app/z;->d:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 2

    iget v0, p0, Lcom/netwatch/app/z;->b:I

    iget-object v1, p0, Lcom/netwatch/app/z;->d:Ljava/lang/String;

    iget-object p0, p0, Lcom/netwatch/app/z;->c:Lcom/netwatch/app/TrafficMonitorService;

    packed-switch v0, :pswitch_data_0

    invoke-static {p0, v1}, Lcom/netwatch/app/TrafficMonitorService;->d(Lcom/netwatch/app/TrafficMonitorService;Ljava/lang/String;)V

    return-void

    :pswitch_0
    invoke-static {p0, v1}, Lcom/netwatch/app/TrafficMonitorService;->c(Lcom/netwatch/app/TrafficMonitorService;Ljava/lang/String;)V

    return-void

    :pswitch_1
    invoke-static {p0, v1}, Lcom/netwatch/app/TrafficMonitorService;->b(Lcom/netwatch/app/TrafficMonitorService;Ljava/lang/String;)V

    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
