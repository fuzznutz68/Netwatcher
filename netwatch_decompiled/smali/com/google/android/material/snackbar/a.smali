.class public final synthetic Lcom/google/android/material/snackbar/a;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/view/View$OnClickListener;


# instance fields
.field public final synthetic a:I

.field public final synthetic b:Ljava/lang/Object;

.field public final synthetic c:Ljava/lang/Object;


# direct methods
.method public synthetic constructor <init>(ILjava/lang/Object;Ljava/lang/Object;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p1, p0, Lcom/google/android/material/snackbar/a;->a:I

    iput-object p2, p0, Lcom/google/android/material/snackbar/a;->b:Ljava/lang/Object;

    iput-object p3, p0, Lcom/google/android/material/snackbar/a;->c:Ljava/lang/Object;

    return-void
.end method


# virtual methods
.method public final onClick(Landroid/view/View;)V
    .locals 2

    iget v0, p0, Lcom/google/android/material/snackbar/a;->a:I

    iget-object v1, p0, Lcom/google/android/material/snackbar/a;->c:Ljava/lang/Object;

    iget-object p0, p0, Lcom/google/android/material/snackbar/a;->b:Ljava/lang/Object;

    packed-switch v0, :pswitch_data_0

    check-cast p0, Lcom/netwatch/app/MainActivity;

    check-cast v1, Ljava/lang/String;

    invoke-static {p0, v1, p1}, Lcom/netwatch/app/MainActivity;->k(Lcom/netwatch/app/MainActivity;Ljava/lang/String;Landroid/view/View;)V

    return-void

    :pswitch_0
    check-cast p0, Lcom/google/android/material/snackbar/Snackbar;

    check-cast v1, Landroid/view/View$OnClickListener;

    invoke-static {p0, v1, p1}, Lcom/google/android/material/snackbar/Snackbar;->a(Lcom/google/android/material/snackbar/Snackbar;Landroid/view/View$OnClickListener;Landroid/view/View;)V

    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method
