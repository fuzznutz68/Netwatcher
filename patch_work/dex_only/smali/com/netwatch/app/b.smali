.class public final synthetic Lcom/netwatch/app/b;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic b:Lcom/netwatch/app/DeviceMonitorService;

.field public final synthetic c:Ljava/lang/String;

.field public final synthetic d:I

.field public final synthetic e:Ljava/lang/String;

.field public final synthetic f:Ljava/lang/String;


# direct methods
.method public synthetic constructor <init>(Lcom/netwatch/app/DeviceMonitorService;Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/netwatch/app/b;->b:Lcom/netwatch/app/DeviceMonitorService;

    iput-object p2, p0, Lcom/netwatch/app/b;->c:Ljava/lang/String;

    iput p3, p0, Lcom/netwatch/app/b;->d:I

    iput-object p4, p0, Lcom/netwatch/app/b;->e:Ljava/lang/String;

    iput-object p5, p0, Lcom/netwatch/app/b;->f:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 4

    iget-object v0, p0, Lcom/netwatch/app/b;->e:Ljava/lang/String;

    iget-object v1, p0, Lcom/netwatch/app/b;->f:Ljava/lang/String;

    iget-object v2, p0, Lcom/netwatch/app/b;->b:Lcom/netwatch/app/DeviceMonitorService;

    iget-object v3, p0, Lcom/netwatch/app/b;->c:Ljava/lang/String;

    iget p0, p0, Lcom/netwatch/app/b;->d:I

    invoke-static {v2, v3, p0, v0, v1}, Lcom/netwatch/app/DeviceMonitorService;->b(Lcom/netwatch/app/DeviceMonitorService;Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;)V

    return-void
.end method
