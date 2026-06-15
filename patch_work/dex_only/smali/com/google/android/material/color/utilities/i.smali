.class public final synthetic Lcom/google/android/material/color/utilities/i;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/util/Comparator;


# instance fields
.field public final synthetic a:I


# direct methods
.method public synthetic constructor <init>(I)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p1, p0, Lcom/google/android/material/color/utilities/i;->a:I

    return-void
.end method


# virtual methods
.method public final compare(Ljava/lang/Object;Ljava/lang/Object;)I
    .locals 0

    iget p0, p0, Lcom/google/android/material/color/utilities/i;->a:I

    packed-switch p0, :pswitch_data_0

    check-cast p1, Lcom/netwatch/app/AppEntry;

    check-cast p2, Lcom/netwatch/app/AppEntry;

    invoke-static {p1, p2}, Lcom/netwatch/app/MainActivity;->v(Lcom/netwatch/app/AppEntry;Lcom/netwatch/app/AppEntry;)I

    move-result p0

    return p0

    :pswitch_0
    check-cast p1, Ljava/lang/Double;

    check-cast p2, Ljava/lang/Double;

    invoke-virtual {p1, p2}, Ljava/lang/Double;->compareTo(Ljava/lang/Double;)I

    move-result p0

    return p0

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method
