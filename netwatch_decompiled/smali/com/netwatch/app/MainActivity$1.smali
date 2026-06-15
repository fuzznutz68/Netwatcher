.class Lcom/netwatch/app/MainActivity$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/widget/AdapterView$OnItemSelectedListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/netwatch/app/MainActivity;->onCreate(Landroid/os/Bundle;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/netwatch/app/MainActivity;


# direct methods
.method public constructor <init>(Lcom/netwatch/app/MainActivity;)V
    .locals 0

    iput-object p1, p0, Lcom/netwatch/app/MainActivity$1;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static synthetic a(Lcom/netwatch/app/MainActivity$1;)V
    .locals 0

    invoke-direct {p0}, Lcom/netwatch/app/MainActivity$1;->lambda$onItemSelected$0()V

    return-void
.end method

.method private synthetic lambda$onItemSelected$0()V
    .locals 1

    iget-object p0, p0, Lcom/netwatch/app/MainActivity$1;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-static {p0}, Lcom/netwatch/app/MainActivity;->b0(Lcom/netwatch/app/MainActivity;)Lcom/netwatch/app/AppEntry;

    move-result-object v0

    iget-object v0, v0, Lcom/netwatch/app/AppEntry;->packageName:Ljava/lang/String;

    invoke-static {p0, v0}, Lcom/netwatch/app/MainActivity;->d0(Lcom/netwatch/app/MainActivity;Ljava/lang/String;)V

    return-void
.end method


# virtual methods
.method public onItemSelected(Landroid/widget/AdapterView;Landroid/view/View;IJ)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/widget/AdapterView<",
            "*>;",
            "Landroid/view/View;",
            "IJ)V"
        }
    .end annotation

    iget-object p1, p0, Lcom/netwatch/app/MainActivity$1;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-static {p1}, Lcom/netwatch/app/MainActivity;->W(Lcom/netwatch/app/MainActivity;)Ljava/util/List;

    move-result-object p2

    invoke-interface {p2}, Ljava/util/List;->isEmpty()Z

    move-result p2

    const/4 p4, 0x0

    if-eqz p2, :cond_0

    move-object p2, p4

    goto :goto_0

    :cond_0
    iget-object p2, p0, Lcom/netwatch/app/MainActivity$1;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-static {p2}, Lcom/netwatch/app/MainActivity;->W(Lcom/netwatch/app/MainActivity;)Ljava/util/List;

    move-result-object p2

    invoke-interface {p2, p3}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/netwatch/app/AppEntry;

    :goto_0
    invoke-static {p1, p2}, Lcom/netwatch/app/MainActivity;->c0(Lcom/netwatch/app/MainActivity;Lcom/netwatch/app/AppEntry;)V

    iget-object p1, p0, Lcom/netwatch/app/MainActivity$1;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-static {p1}, Lcom/netwatch/app/MainActivity;->X(Lcom/netwatch/app/MainActivity;)Landroid/widget/Spinner;

    move-result-object p1

    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object p1

    const-string p2, "init"

    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    iget-object p0, p0, Lcom/netwatch/app/MainActivity$1;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-static {p0}, Lcom/netwatch/app/MainActivity;->X(Lcom/netwatch/app/MainActivity;)Landroid/widget/Spinner;

    move-result-object p0

    invoke-virtual {p0, p4}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    return-void

    :cond_1
    iget-object p1, p0, Lcom/netwatch/app/MainActivity$1;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-static {p1}, Lcom/netwatch/app/MainActivity;->b0(Lcom/netwatch/app/MainActivity;)Lcom/netwatch/app/AppEntry;

    move-result-object p1

    if-eqz p1, :cond_3

    iget-object p1, p0, Lcom/netwatch/app/MainActivity$1;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-static {p1}, Lcom/netwatch/app/MainActivity;->b0(Lcom/netwatch/app/MainActivity;)Lcom/netwatch/app/AppEntry;

    move-result-object p1

    iget-object p1, p1, Lcom/netwatch/app/AppEntry;->packageName:Ljava/lang/String;

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    if-nez p1, :cond_3

    iget-object p1, p0, Lcom/netwatch/app/MainActivity$1;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-static {p1}, Lcom/netwatch/app/MainActivity;->a0(Lcom/netwatch/app/MainActivity;)Z

    move-result p1

    if-eqz p1, :cond_2

    iget-object p1, p0, Lcom/netwatch/app/MainActivity$1;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-static {p1}, Lcom/netwatch/app/MainActivity;->h0(Lcom/netwatch/app/MainActivity;)V

    :cond_2
    iget-object p1, p0, Lcom/netwatch/app/MainActivity$1;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-static {p1}, Lcom/netwatch/app/MainActivity;->b0(Lcom/netwatch/app/MainActivity;)Lcom/netwatch/app/AppEntry;

    move-result-object p2

    iget-object p2, p2, Lcom/netwatch/app/AppEntry;->packageName:Ljava/lang/String;

    invoke-static {p1, p2}, Lcom/netwatch/app/MainActivity;->f0(Lcom/netwatch/app/MainActivity;Ljava/lang/String;)V

    iget-object p1, p0, Lcom/netwatch/app/MainActivity$1;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-static {p1}, Lcom/netwatch/app/MainActivity;->g0(Lcom/netwatch/app/MainActivity;)V

    iget-object p1, p0, Lcom/netwatch/app/MainActivity$1;->this$0:Lcom/netwatch/app/MainActivity;

    invoke-static {p1}, Lcom/netwatch/app/MainActivity;->Z(Lcom/netwatch/app/MainActivity;)Landroid/os/Handler;

    move-result-object p1

    new-instance p2, Lcom/netwatch/app/v;

    const/4 p3, 0x0

    invoke-direct {p2, p3, p0}, Lcom/netwatch/app/v;-><init>(ILjava/lang/Object;)V

    const-wide/16 p3, 0x190

    invoke-virtual {p1, p2, p3, p4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    :cond_3
    return-void
.end method

.method public onNothingSelected(Landroid/widget/AdapterView;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/widget/AdapterView<",
            "*>;)V"
        }
    .end annotation

    return-void
.end method
