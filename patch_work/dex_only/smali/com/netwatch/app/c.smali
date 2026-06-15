.class public final synthetic Lcom/netwatch/app/c;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic b:I

.field public final synthetic c:Ljava/lang/String;

.field public final synthetic d:I

.field public final synthetic e:Landroid/content/ContextWrapper;

.field public final synthetic f:Ljava/lang/Object;


# direct methods
.method public synthetic constructor <init>(Lcom/netwatch/app/MainActivity;ILjava/util/List;Ljava/lang/String;)V
    .locals 1

    .line 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    iput v0, p0, Lcom/netwatch/app/c;->b:I

    iput-object p1, p0, Lcom/netwatch/app/c;->e:Landroid/content/ContextWrapper;

    iput p2, p0, Lcom/netwatch/app/c;->d:I

    iput-object p3, p0, Lcom/netwatch/app/c;->f:Ljava/lang/Object;

    iput-object p4, p0, Lcom/netwatch/app/c;->c:Ljava/lang/String;

    return-void
.end method

.method public synthetic constructor <init>(Lcom/netwatch/app/NetWatchVpnService;Ljava/lang/String;Ljava/lang/String;I)V
    .locals 1

    .line 2
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x1

    iput v0, p0, Lcom/netwatch/app/c;->b:I

    iput-object p1, p0, Lcom/netwatch/app/c;->e:Landroid/content/ContextWrapper;

    iput-object p2, p0, Lcom/netwatch/app/c;->c:Ljava/lang/String;

    iput-object p3, p0, Lcom/netwatch/app/c;->f:Ljava/lang/Object;

    iput p4, p0, Lcom/netwatch/app/c;->d:I

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 4

    iget-object v0, p0, Lcom/netwatch/app/c;->e:Landroid/content/ContextWrapper;

    iget v1, p0, Lcom/netwatch/app/c;->b:I

    iget-object v2, p0, Lcom/netwatch/app/c;->c:Ljava/lang/String;

    iget v3, p0, Lcom/netwatch/app/c;->d:I

    iget-object p0, p0, Lcom/netwatch/app/c;->f:Ljava/lang/Object;

    packed-switch v1, :pswitch_data_0

    check-cast v0, Lcom/netwatch/app/NetWatchVpnService;

    check-cast p0, Ljava/lang/String;

    invoke-static {v0, v2, p0, v3}, Lcom/netwatch/app/NetWatchVpnService;->d(Lcom/netwatch/app/NetWatchVpnService;Ljava/lang/String;Ljava/lang/String;I)V

    return-void

    :pswitch_0
    check-cast v0, Lcom/netwatch/app/MainActivity;

    check-cast p0, Ljava/util/List;

    invoke-static {v0, v3, p0, v2}, Lcom/netwatch/app/MainActivity;->p(Lcom/netwatch/app/MainActivity;ILjava/util/List;Ljava/lang/String;)V

    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method
