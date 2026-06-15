.class Lcom/netwatch/app/TrafficMonitorService$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/netwatch/app/TrafficMonitorService;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/netwatch/app/TrafficMonitorService;


# direct methods
.method public constructor <init>(Lcom/netwatch/app/TrafficMonitorService;)V
    .locals 0

    iput-object p1, p0, Lcom/netwatch/app/TrafficMonitorService$1;->this$0:Lcom/netwatch/app/TrafficMonitorService;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    iget-object v0, p0, Lcom/netwatch/app/TrafficMonitorService$1;->this$0:Lcom/netwatch/app/TrafficMonitorService;

    invoke-static {v0}, Lcom/netwatch/app/TrafficMonitorService;->g(Lcom/netwatch/app/TrafficMonitorService;)Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    :cond_0
    iget-object v0, p0, Lcom/netwatch/app/TrafficMonitorService$1;->this$0:Lcom/netwatch/app/TrafficMonitorService;

    invoke-static {v0}, Lcom/netwatch/app/TrafficMonitorService;->h(Lcom/netwatch/app/TrafficMonitorService;)V

    iget-object v0, p0, Lcom/netwatch/app/TrafficMonitorService$1;->this$0:Lcom/netwatch/app/TrafficMonitorService;

    invoke-static {v0}, Lcom/netwatch/app/TrafficMonitorService;->f(Lcom/netwatch/app/TrafficMonitorService;)Landroid/os/Handler;

    move-result-object v0

    const-wide/16 v1, 0x3e8

    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method
