.class public final synthetic Lcom/netwatch/app/w;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic b:I

.field public final synthetic c:Lcom/netwatch/app/MainActivity$3;


# direct methods
.method public synthetic constructor <init>(Lcom/netwatch/app/MainActivity$3;I)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p2, p0, Lcom/netwatch/app/w;->b:I

    iput-object p1, p0, Lcom/netwatch/app/w;->c:Lcom/netwatch/app/MainActivity$3;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 1

    iget v0, p0, Lcom/netwatch/app/w;->b:I

    iget-object p0, p0, Lcom/netwatch/app/w;->c:Lcom/netwatch/app/MainActivity$3;

    packed-switch v0, :pswitch_data_0

    invoke-static {p0}, Lcom/netwatch/app/MainActivity$3;->b(Lcom/netwatch/app/MainActivity$3;)V

    return-void

    :pswitch_0
    invoke-static {p0}, Lcom/netwatch/app/MainActivity$3;->a(Lcom/netwatch/app/MainActivity$3;)V

    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method
