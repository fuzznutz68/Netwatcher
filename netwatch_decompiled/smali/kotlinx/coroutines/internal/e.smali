.class public final Lkotlinx/coroutines/internal/e;
.super Ls/s;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;
.implements Ls/b0;


# instance fields
.field public final b:Ls/s;

.field public final c:I

.field public final d:Lkotlinx/coroutines/internal/h;

.field public final e:Ljava/lang/Object;

.field private volatile runningWorkers:I


# direct methods
.method public constructor <init>(Ls/s;I)V
    .locals 0

    invoke-direct {p0}, Ls/s;-><init>()V

    iput-object p1, p0, Lkotlinx/coroutines/internal/e;->b:Ls/s;

    iput p2, p0, Lkotlinx/coroutines/internal/e;->c:I

    instance-of p2, p1, Ls/b0;

    if-eqz p2, :cond_0

    check-cast p1, Ls/b0;

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    :goto_0
    if-nez p1, :cond_1

    sget p1, Ls/a0;->a:I

    :cond_1
    new-instance p1, Lkotlinx/coroutines/internal/h;

    invoke-direct {p1}, Lkotlinx/coroutines/internal/h;-><init>()V

    iput-object p1, p0, Lkotlinx/coroutines/internal/e;->d:Lkotlinx/coroutines/internal/h;

    new-instance p1, Ljava/lang/Object;

    invoke-direct {p1}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lkotlinx/coroutines/internal/e;->e:Ljava/lang/Object;

    return-void
.end method


# virtual methods
.method public final b()Z
    .locals 3

    iget-object v0, p0, Lkotlinx/coroutines/internal/e;->e:Ljava/lang/Object;

    monitor-enter v0

    :try_start_0
    iget v1, p0, Lkotlinx/coroutines/internal/e;->runningWorkers:I

    iget v2, p0, Lkotlinx/coroutines/internal/e;->c:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-lt v1, v2, :cond_0

    monitor-exit v0

    const/4 p0, 0x0

    return p0

    :cond_0
    :try_start_1
    iget v1, p0, Lkotlinx/coroutines/internal/e;->runningWorkers:I

    const/4 v2, 0x1

    add-int/2addr v1, v2

    iput v1, p0, Lkotlinx/coroutines/internal/e;->runningWorkers:I
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    monitor-exit v0

    return v2

    :catchall_0
    move-exception p0

    monitor-exit v0

    throw p0
.end method

.method public final dispatch(Le/j;Ljava/lang/Runnable;)V
    .locals 0

    iget-object p1, p0, Lkotlinx/coroutines/internal/e;->d:Lkotlinx/coroutines/internal/h;

    invoke-virtual {p1, p2}, Lkotlinx/coroutines/internal/h;->a(Ljava/lang/Object;)Z

    iget p1, p0, Lkotlinx/coroutines/internal/e;->runningWorkers:I

    iget p2, p0, Lkotlinx/coroutines/internal/e;->c:I

    if-lt p1, p2, :cond_0

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Lkotlinx/coroutines/internal/e;->b()Z

    move-result p1

    if-eqz p1, :cond_1

    iget-object p1, p0, Lkotlinx/coroutines/internal/e;->b:Ls/s;

    invoke-virtual {p1, p0, p0}, Ls/s;->dispatch(Le/j;Ljava/lang/Runnable;)V

    :cond_1
    :goto_0
    return-void
.end method

.method public final dispatchYield(Le/j;Ljava/lang/Runnable;)V
    .locals 0

    iget-object p1, p0, Lkotlinx/coroutines/internal/e;->d:Lkotlinx/coroutines/internal/h;

    invoke-virtual {p1, p2}, Lkotlinx/coroutines/internal/h;->a(Ljava/lang/Object;)Z

    iget p1, p0, Lkotlinx/coroutines/internal/e;->runningWorkers:I

    iget p2, p0, Lkotlinx/coroutines/internal/e;->c:I

    if-lt p1, p2, :cond_0

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Lkotlinx/coroutines/internal/e;->b()Z

    move-result p1

    if-eqz p1, :cond_1

    iget-object p1, p0, Lkotlinx/coroutines/internal/e;->b:Ls/s;

    invoke-virtual {p1, p0, p0}, Ls/s;->dispatchYield(Le/j;Ljava/lang/Runnable;)V

    :cond_1
    :goto_0
    return-void
.end method

.method public final limitedParallelism(I)Ls/s;
    .locals 1

    invoke-static {p1}, Lkotlinx/coroutines/scheduling/h;->b(I)V

    iget v0, p0, Lkotlinx/coroutines/internal/e;->c:I

    if-lt p1, v0, :cond_0

    return-object p0

    :cond_0
    invoke-super {p0, p1}, Ls/s;->limitedParallelism(I)Ls/s;

    move-result-object p0

    return-object p0
.end method

.method public final run()V
    .locals 4

    const/4 v0, 0x0

    :goto_0
    move v1, v0

    :cond_0
    iget-object v2, p0, Lkotlinx/coroutines/internal/e;->d:Lkotlinx/coroutines/internal/h;

    invoke-virtual {v2}, Lkotlinx/coroutines/internal/h;->d()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Runnable;

    if-eqz v2, :cond_1

    :try_start_0
    invoke-interface {v2}, Ljava/lang/Runnable;->run()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_1

    :catchall_0
    move-exception v2

    sget-object v3, Le/k;->b:Le/k;

    invoke-static {v3, v2}, Lkotlinx/coroutines/scheduling/h;->d(Le/j;Ljava/lang/Throwable;)V

    :goto_1
    add-int/lit8 v1, v1, 0x1

    const/16 v2, 0x10

    if-lt v1, v2, :cond_0

    iget-object v2, p0, Lkotlinx/coroutines/internal/e;->b:Ls/s;

    invoke-virtual {v2, p0}, Ls/s;->isDispatchNeeded(Le/j;)Z

    move-result v2

    if-eqz v2, :cond_0

    iget-object v0, p0, Lkotlinx/coroutines/internal/e;->b:Ls/s;

    invoke-virtual {v0, p0, p0}, Ls/s;->dispatch(Le/j;Ljava/lang/Runnable;)V

    return-void

    :cond_1
    iget-object v1, p0, Lkotlinx/coroutines/internal/e;->e:Ljava/lang/Object;

    monitor-enter v1

    :try_start_1
    iget v2, p0, Lkotlinx/coroutines/internal/e;->runningWorkers:I

    add-int/lit8 v2, v2, -0x1

    iput v2, p0, Lkotlinx/coroutines/internal/e;->runningWorkers:I

    iget-object v2, p0, Lkotlinx/coroutines/internal/e;->d:Lkotlinx/coroutines/internal/h;

    invoke-virtual {v2}, Lkotlinx/coroutines/internal/h;->c()I

    move-result v2
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    if-nez v2, :cond_2

    monitor-exit v1

    return-void

    :cond_2
    :try_start_2
    iget v2, p0, Lkotlinx/coroutines/internal/e;->runningWorkers:I

    add-int/lit8 v2, v2, 0x1

    iput v2, p0, Lkotlinx/coroutines/internal/e;->runningWorkers:I
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    monitor-exit v1

    goto :goto_0

    :catchall_1
    move-exception p0

    monitor-exit v1

    throw p0
.end method
