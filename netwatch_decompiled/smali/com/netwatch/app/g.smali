.class public final synthetic Lcom/netwatch/app/g;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic b:I

.field public final synthetic c:Landroid/content/ContextWrapper;

.field public final synthetic d:Ljava/lang/String;

.field public final synthetic e:Ljava/lang/Object;


# direct methods
.method public synthetic constructor <init>(Landroid/content/ContextWrapper;Ljava/lang/String;Ljava/lang/Object;I)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p4, p0, Lcom/netwatch/app/g;->b:I

    iput-object p1, p0, Lcom/netwatch/app/g;->c:Landroid/content/ContextWrapper;

    iput-object p2, p0, Lcom/netwatch/app/g;->d:Ljava/lang/String;

    iput-object p3, p0, Lcom/netwatch/app/g;->e:Ljava/lang/Object;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 3

    iget v0, p0, Lcom/netwatch/app/g;->b:I

    iget-object v1, p0, Lcom/netwatch/app/g;->d:Ljava/lang/String;

    iget-object v2, p0, Lcom/netwatch/app/g;->e:Ljava/lang/Object;

    iget-object p0, p0, Lcom/netwatch/app/g;->c:Landroid/content/ContextWrapper;

    packed-switch v0, :pswitch_data_0

    check-cast p0, Lcom/netwatch/app/TrafficMonitorService;

    check-cast v2, Ljava/util/List;

    invoke-static {p0, v1, v2}, Lcom/netwatch/app/TrafficMonitorService;->e(Lcom/netwatch/app/TrafficMonitorService;Ljava/lang/String;Ljava/util/List;)V

    return-void

    :pswitch_0
    check-cast p0, Lcom/netwatch/app/MainActivity;

    check-cast v2, Ljava/lang/String;

    invoke-static {p0, v1, v2}, Lcom/netwatch/app/MainActivity;->H(Lcom/netwatch/app/MainActivity;Ljava/lang/String;Ljava/lang/String;)V

    return-void

    :pswitch_1
    check-cast p0, Lcom/netwatch/app/MainActivity;

    check-cast v2, Ljava/lang/String;

    invoke-static {p0, v1, v2}, Lcom/netwatch/app/MainActivity;->d(Lcom/netwatch/app/MainActivity;Ljava/lang/String;Ljava/lang/String;)V

    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
