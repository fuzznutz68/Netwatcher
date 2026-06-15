.class public final synthetic Lcom/netwatch/app/l;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic b:I

.field public final synthetic c:Lcom/netwatch/app/MainActivity;


# direct methods
.method public synthetic constructor <init>(Lcom/netwatch/app/MainActivity;I)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p2, p0, Lcom/netwatch/app/l;->b:I

    iput-object p1, p0, Lcom/netwatch/app/l;->c:Lcom/netwatch/app/MainActivity;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 1

    iget v0, p0, Lcom/netwatch/app/l;->b:I

    iget-object p0, p0, Lcom/netwatch/app/l;->c:Lcom/netwatch/app/MainActivity;

    packed-switch v0, :pswitch_data_0

    invoke-static {p0}, Lcom/netwatch/app/MainActivity;->i(Lcom/netwatch/app/MainActivity;)V

    return-void

    :pswitch_0
    invoke-static {p0}, Lcom/netwatch/app/MainActivity;->r(Lcom/netwatch/app/MainActivity;)V

    return-void

    :pswitch_1
    invoke-static {p0}, Lcom/netwatch/app/MainActivity;->V(Lcom/netwatch/app/MainActivity;)V

    return-void

    :pswitch_2
    invoke-static {p0}, Lcom/netwatch/app/MainActivity;->I(Lcom/netwatch/app/MainActivity;)V

    return-void

    :pswitch_3
    invoke-static {p0}, Lcom/netwatch/app/MainActivity;->P(Lcom/netwatch/app/MainActivity;)V

    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
