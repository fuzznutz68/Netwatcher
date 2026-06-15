.class public final synthetic Lcom/netwatch/app/j;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/widget/TextView$OnEditorActionListener;


# instance fields
.field public final synthetic a:I

.field public final synthetic b:Lcom/netwatch/app/MainActivity;


# direct methods
.method public synthetic constructor <init>(Lcom/netwatch/app/MainActivity;I)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p2, p0, Lcom/netwatch/app/j;->a:I

    iput-object p1, p0, Lcom/netwatch/app/j;->b:Lcom/netwatch/app/MainActivity;

    return-void
.end method


# virtual methods
.method public final onEditorAction(Landroid/widget/TextView;ILandroid/view/KeyEvent;)Z
    .locals 1

    iget v0, p0, Lcom/netwatch/app/j;->a:I

    iget-object p0, p0, Lcom/netwatch/app/j;->b:Lcom/netwatch/app/MainActivity;

    packed-switch v0, :pswitch_data_0

    invoke-static {p0, p1, p2, p3}, Lcom/netwatch/app/MainActivity;->b(Lcom/netwatch/app/MainActivity;Landroid/widget/TextView;ILandroid/view/KeyEvent;)Z

    move-result p0

    return p0

    :pswitch_0
    invoke-static {p0, p1, p2, p3}, Lcom/netwatch/app/MainActivity;->e(Lcom/netwatch/app/MainActivity;Landroid/widget/TextView;ILandroid/view/KeyEvent;)Z

    move-result p0

    return p0

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method
