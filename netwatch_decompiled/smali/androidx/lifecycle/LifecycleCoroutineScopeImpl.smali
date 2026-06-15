.class public final Landroidx/lifecycle/LifecycleCoroutineScopeImpl;
.super Landroidx/lifecycle/LifecycleCoroutineScope;
.source "SourceFile"

# interfaces
.implements Landroidx/lifecycle/LifecycleEventObserver;


# instance fields
.field private final coroutineContext:Le/j;

.field private final lifecycle:Landroidx/lifecycle/Lifecycle;


# direct methods
.method public constructor <init>(Landroidx/lifecycle/Lifecycle;Le/j;)V
    .locals 1

    invoke-direct {p0}, Landroidx/lifecycle/LifecycleCoroutineScope;-><init>()V

    iput-object p1, p0, Landroidx/lifecycle/LifecycleCoroutineScopeImpl;->lifecycle:Landroidx/lifecycle/Lifecycle;

    iput-object p2, p0, Landroidx/lifecycle/LifecycleCoroutineScopeImpl;->coroutineContext:Le/j;

    invoke-virtual {p0}, Landroidx/lifecycle/LifecycleCoroutineScopeImpl;->getLifecycle$lifecycle_common()Landroidx/lifecycle/Lifecycle;

    move-result-object p1

    invoke-virtual {p1}, Landroidx/lifecycle/Lifecycle;->getCurrentState()Landroidx/lifecycle/Lifecycle$State;

    move-result-object p1

    sget-object p2, Landroidx/lifecycle/Lifecycle$State;->DESTROYED:Landroidx/lifecycle/Lifecycle$State;

    if-ne p1, p2, :cond_0

    invoke-virtual {p0}, Landroidx/lifecycle/LifecycleCoroutineScopeImpl;->getCoroutineContext()Le/j;

    move-result-object p0

    sget-object p1, Ls/t;->c:Ls/t;

    invoke-interface {p0, p1}, Le/j;->get(Le/i;)Le/h;

    move-result-object p0

    check-cast p0, Ls/r0;

    if-eqz p0, :cond_0

    check-cast p0, Ls/y0;

    new-instance p1, Ls/s0;

    invoke-virtual {p0}, Ls/y0;->g()Ljava/lang/String;

    move-result-object p2

    const/4 v0, 0x0

    invoke-direct {p1, p2, v0, p0}, Ls/s0;-><init>(Ljava/lang/String;Ljava/lang/Throwable;Ls/r0;)V

    invoke-virtual {p0, p1}, Ls/y0;->e(Ljava/lang/Object;)Z

    :cond_0
    return-void
.end method


# virtual methods
.method public getCoroutineContext()Le/j;
    .locals 0

    iget-object p0, p0, Landroidx/lifecycle/LifecycleCoroutineScopeImpl;->coroutineContext:Le/j;

    return-object p0
.end method

.method public getLifecycle$lifecycle_common()Landroidx/lifecycle/Lifecycle;
    .locals 0

    iget-object p0, p0, Landroidx/lifecycle/LifecycleCoroutineScopeImpl;->lifecycle:Landroidx/lifecycle/Lifecycle;

    return-object p0
.end method

.method public onStateChanged(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V
    .locals 1

    invoke-virtual {p0}, Landroidx/lifecycle/LifecycleCoroutineScopeImpl;->getLifecycle$lifecycle_common()Landroidx/lifecycle/Lifecycle;

    move-result-object p1

    invoke-virtual {p1}, Landroidx/lifecycle/Lifecycle;->getCurrentState()Landroidx/lifecycle/Lifecycle$State;

    move-result-object p1

    sget-object p2, Landroidx/lifecycle/Lifecycle$State;->DESTROYED:Landroidx/lifecycle/Lifecycle$State;

    invoke-virtual {p1, p2}, Ljava/lang/Enum;->compareTo(Ljava/lang/Enum;)I

    move-result p1

    if-gtz p1, :cond_0

    invoke-virtual {p0}, Landroidx/lifecycle/LifecycleCoroutineScopeImpl;->getLifecycle$lifecycle_common()Landroidx/lifecycle/Lifecycle;

    move-result-object p1

    invoke-virtual {p1, p0}, Landroidx/lifecycle/Lifecycle;->removeObserver(Landroidx/lifecycle/LifecycleObserver;)V

    invoke-virtual {p0}, Landroidx/lifecycle/LifecycleCoroutineScopeImpl;->getCoroutineContext()Le/j;

    move-result-object p0

    sget-object p1, Ls/t;->c:Ls/t;

    invoke-interface {p0, p1}, Le/j;->get(Le/i;)Le/h;

    move-result-object p0

    check-cast p0, Ls/r0;

    if-eqz p0, :cond_0

    check-cast p0, Ls/y0;

    new-instance p1, Ls/s0;

    invoke-virtual {p0}, Ls/y0;->g()Ljava/lang/String;

    move-result-object p2

    const/4 v0, 0x0

    invoke-direct {p1, p2, v0, p0}, Ls/s0;-><init>(Ljava/lang/String;Ljava/lang/Throwable;Ls/r0;)V

    invoke-virtual {p0, p1}, Ls/y0;->e(Ljava/lang/Object;)Z

    :cond_0
    return-void
.end method

.method public final register()V
    .locals 3

    sget-object v0, Ls/f0;->a:Lkotlinx/coroutines/scheduling/d;

    sget-object v0, Lkotlinx/coroutines/internal/l;->a:Ls/a1;

    check-cast v0, Lt/c;

    iget-object v0, v0, Lt/c;->e:Lt/c;

    new-instance v1, Landroidx/lifecycle/LifecycleCoroutineScopeImpl$register$1;

    const/4 v2, 0x0

    invoke-direct {v1, p0, v2}, Landroidx/lifecycle/LifecycleCoroutineScopeImpl$register$1;-><init>(Landroidx/lifecycle/LifecycleCoroutineScopeImpl;Le/e;)V

    const/4 v2, 0x2

    invoke-static {p0, v0, v1, v2}, Lkotlinx/coroutines/scheduling/h;->g(Ls/w;Lt/c;Ll/p;I)Ls/f1;

    return-void
.end method
