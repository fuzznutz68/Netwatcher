.class public final synthetic Lcom/google/android/material/bottomappbar/a;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic b:I

.field public final synthetic c:Landroid/view/View;


# direct methods
.method public synthetic constructor <init>(Landroid/view/View;I)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p2, p0, Lcom/google/android/material/bottomappbar/a;->b:I

    iput-object p1, p0, Lcom/google/android/material/bottomappbar/a;->c:Landroid/view/View;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 1

    iget v0, p0, Lcom/google/android/material/bottomappbar/a;->b:I

    iget-object p0, p0, Lcom/google/android/material/bottomappbar/a;->c:Landroid/view/View;

    packed-switch v0, :pswitch_data_0

    invoke-static {p0}, Lcom/google/android/material/datepicker/DateSelector;->a(Landroid/view/View;)V

    return-void

    :pswitch_0
    invoke-static {p0}, Lcom/google/android/material/bottomappbar/BottomAppBar;->a(Landroid/view/View;)V

    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method
