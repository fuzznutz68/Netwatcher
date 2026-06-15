.class public abstract Landroidx/lifecycle/LifecycleCoroutineScope;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ls/w;


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public abstract synthetic getCoroutineContext()Le/j;
.end method

.method public abstract getLifecycle$lifecycle_common()Landroidx/lifecycle/Lifecycle;
.end method

.method public final launchWhenCreated(Ll/p;)Ls/r0;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ll/p;",
            ")",
            "Ls/r0;"
        }
    .end annotation

    new-instance v0, Landroidx/lifecycle/LifecycleCoroutineScope$launchWhenCreated$1;

    const/4 v1, 0x0

    invoke-direct {v0, p0, p1, v1}, Landroidx/lifecycle/LifecycleCoroutineScope$launchWhenCreated$1;-><init>(Landroidx/lifecycle/LifecycleCoroutineScope;Ll/p;Le/e;)V

    const/4 p1, 0x3

    invoke-static {p0, v1, v0, p1}, Lkotlinx/coroutines/scheduling/h;->g(Ls/w;Lt/c;Ll/p;I)Ls/f1;

    move-result-object p0

    return-object p0
.end method

.method public final launchWhenResumed(Ll/p;)Ls/r0;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ll/p;",
            ")",
            "Ls/r0;"
        }
    .end annotation

    new-instance v0, Landroidx/lifecycle/LifecycleCoroutineScope$launchWhenResumed$1;

    const/4 v1, 0x0

    invoke-direct {v0, p0, p1, v1}, Landroidx/lifecycle/LifecycleCoroutineScope$launchWhenResumed$1;-><init>(Landroidx/lifecycle/LifecycleCoroutineScope;Ll/p;Le/e;)V

    const/4 p1, 0x3

    invoke-static {p0, v1, v0, p1}, Lkotlinx/coroutines/scheduling/h;->g(Ls/w;Lt/c;Ll/p;I)Ls/f1;

    move-result-object p0

    return-object p0
.end method

.method public final launchWhenStarted(Ll/p;)Ls/r0;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ll/p;",
            ")",
            "Ls/r0;"
        }
    .end annotation

    new-instance v0, Landroidx/lifecycle/LifecycleCoroutineScope$launchWhenStarted$1;

    const/4 v1, 0x0

    invoke-direct {v0, p0, p1, v1}, Landroidx/lifecycle/LifecycleCoroutineScope$launchWhenStarted$1;-><init>(Landroidx/lifecycle/LifecycleCoroutineScope;Ll/p;Le/e;)V

    const/4 p1, 0x3

    invoke-static {p0, v1, v0, p1}, Lkotlinx/coroutines/scheduling/h;->g(Ls/w;Lt/c;Ll/p;I)Ls/f1;

    move-result-object p0

    return-object p0
.end method
