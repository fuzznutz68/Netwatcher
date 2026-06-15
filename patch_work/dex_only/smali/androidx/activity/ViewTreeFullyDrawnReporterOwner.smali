.class public final Landroidx/activity/ViewTreeFullyDrawnReporterOwner;
.super Ljava/lang/Object;
.source "SourceFile"


# direct methods
.method public static final get(Landroid/view/View;)Landroidx/activity/FullyDrawnReporterOwner;
    .locals 1

    sget-object v0, Landroidx/activity/ViewTreeFullyDrawnReporterOwner$findViewTreeFullyDrawnReporterOwner$1;->INSTANCE:Landroidx/activity/ViewTreeFullyDrawnReporterOwner$findViewTreeFullyDrawnReporterOwner$1;

    invoke-static {p0, v0}, Ld/d;->s(Ljava/lang/Object;Ll/l;)Lq/g;

    move-result-object p0

    sget-object v0, Landroidx/activity/ViewTreeFullyDrawnReporterOwner$findViewTreeFullyDrawnReporterOwner$2;->INSTANCE:Landroidx/activity/ViewTreeFullyDrawnReporterOwner$findViewTreeFullyDrawnReporterOwner$2;

    invoke-static {p0, v0}, Lq/j;->w(Lq/g;Ll/l;)Lq/d;

    move-result-object p0

    invoke-static {p0}, Lq/j;->v(Lq/d;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroidx/activity/FullyDrawnReporterOwner;

    return-object p0
.end method

.method public static final set(Landroid/view/View;Landroidx/activity/FullyDrawnReporterOwner;)V
    .locals 1

    sget v0, Landroidx/activity/R$id;->report_drawn:I

    invoke-virtual {p0, v0, p1}, Landroid/view/View;->setTag(ILjava/lang/Object;)V

    return-void
.end method
