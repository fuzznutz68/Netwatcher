.class public final synthetic Landroidx/constraintlayout/motion/widget/a;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic b:I

.field public final synthetic c:Ljava/lang/Object;

.field public final synthetic d:Ljava/lang/Object;


# direct methods
.method public synthetic constructor <init>(ILjava/lang/Object;Ljava/lang/Object;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p1, p0, Landroidx/constraintlayout/motion/widget/a;->b:I

    iput-object p2, p0, Landroidx/constraintlayout/motion/widget/a;->c:Ljava/lang/Object;

    iput-object p3, p0, Landroidx/constraintlayout/motion/widget/a;->d:Ljava/lang/Object;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 2

    iget v0, p0, Landroidx/constraintlayout/motion/widget/a;->b:I

    iget-object v1, p0, Landroidx/constraintlayout/motion/widget/a;->d:Ljava/lang/Object;

    iget-object p0, p0, Landroidx/constraintlayout/motion/widget/a;->c:Ljava/lang/Object;

    packed-switch v0, :pswitch_data_0

    check-cast p0, Lcom/netwatch/app/TrafficMonitorService;

    check-cast v1, Ljava/util/List;

    invoke-static {p0, v1}, Lcom/netwatch/app/TrafficMonitorService;->a(Lcom/netwatch/app/TrafficMonitorService;Ljava/util/List;)V

    return-void

    :pswitch_0
    check-cast p0, Lcom/netwatch/app/MainActivity;

    check-cast v1, Ljava/util/List;

    invoke-static {p0, v1}, Lcom/netwatch/app/MainActivity;->c(Lcom/netwatch/app/MainActivity;Ljava/util/List;)V

    return-void

    :pswitch_1
    check-cast p0, Lcom/netwatch/app/MainActivity;

    check-cast v1, Ljava/lang/String;

    invoke-static {p0, v1}, Lcom/netwatch/app/MainActivity;->w(Lcom/netwatch/app/MainActivity;Ljava/lang/String;)V

    return-void

    :pswitch_2
    check-cast p0, Landroidx/profileinstaller/ProfileInstallerInitializer;

    check-cast v1, Landroid/content/Context;

    invoke-static {p0, v1}, Landroidx/profileinstaller/ProfileInstallerInitializer;->a(Landroidx/profileinstaller/ProfileInstallerInitializer;Landroid/content/Context;)V

    return-void

    :pswitch_3
    check-cast p0, Landroidx/lifecycle/DispatchQueue;

    check-cast v1, Ljava/lang/Runnable;

    invoke-static {p0, v1}, Landroidx/lifecycle/DispatchQueue;->a(Landroidx/lifecycle/DispatchQueue;Ljava/lang/Runnable;)V

    return-void

    :pswitch_4
    check-cast p0, Landroidx/core/content/res/ResourcesCompat$FontCallback;

    check-cast v1, Landroid/graphics/Typeface;

    invoke-static {p0, v1}, Landroidx/core/content/res/ResourcesCompat$FontCallback;->b(Landroidx/core/content/res/ResourcesCompat$FontCallback;Landroid/graphics/Typeface;)V

    return-void

    :pswitch_5
    check-cast p0, Landroidx/constraintlayout/motion/widget/ViewTransition;

    check-cast v1, [Landroid/view/View;

    invoke-static {p0, v1}, Landroidx/constraintlayout/motion/widget/ViewTransition;->a(Landroidx/constraintlayout/motion/widget/ViewTransition;[Landroid/view/View;)V

    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
