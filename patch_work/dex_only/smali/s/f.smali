.class public final Ls/f;
.super Ls/e0;
.source "SourceFile"

# interfaces
.implements Ls/e;
.implements Lg/d;


# static fields
.field public static final synthetic h:Ljava/util/concurrent/atomic/AtomicIntegerFieldUpdater;

.field public static final synthetic i:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;


# instance fields
.field private volatile synthetic _decision:I

.field private volatile synthetic _state:Ljava/lang/Object;

.field public final e:Le/e;

.field public final f:Le/j;

.field public g:Ls/g0;


# direct methods
.method static constructor <clinit>()V
    .locals 3

    const-string v0, "_decision"

    const-class v1, Ls/f;

    invoke-static {v1, v0}, Ljava/util/concurrent/atomic/AtomicIntegerFieldUpdater;->newUpdater(Ljava/lang/Class;Ljava/lang/String;)Ljava/util/concurrent/atomic/AtomicIntegerFieldUpdater;

    move-result-object v0

    sput-object v0, Ls/f;->h:Ljava/util/concurrent/atomic/AtomicIntegerFieldUpdater;

    const-class v0, Ljava/lang/Object;

    const-string v2, "_state"

    invoke-static {v1, v0, v2}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->newUpdater(Ljava/lang/Class;Ljava/lang/Class;Ljava/lang/String;)Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    move-result-object v0

    sput-object v0, Ls/f;->i:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    return-void
.end method

.method public constructor <init>(Le/e;)V
    .locals 1

    const/4 v0, 0x1

    invoke-direct {p0, v0}, Ls/e0;-><init>(I)V

    iput-object p1, p0, Ls/f;->e:Le/e;

    invoke-interface {p1}, Le/e;->getContext()Le/j;

    move-result-object p1

    iput-object p1, p0, Ls/f;->f:Le/j;

    const/4 p1, 0x0

    iput p1, p0, Ls/f;->_decision:I

    sget-object p1, Ls/b;->b:Ls/b;

    iput-object p1, p0, Ls/f;->_state:Ljava/lang/Object;

    return-void
.end method

.method public static p(Ljava/lang/Object;Landroidx/activity/contextaware/ContextAwareKt$withContextAvailable$2$1;)V
    .locals 3

    new-instance v0, Ljava/lang/IllegalStateException;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "It\'s prohibited to register multiple handlers, tried to register "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, ", already has "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0
.end method


# virtual methods
.method public final a(Ljava/lang/Object;Ljava/util/concurrent/CancellationException;)V
    .locals 8

    :goto_0
    iget-object p1, p0, Ls/f;->_state:Ljava/lang/Object;

    instance-of v0, p1, Ls/d1;

    if-nez v0, :cond_a

    instance-of v0, p1, Ls/m;

    if-eqz v0, :cond_0

    return-void

    :cond_0
    instance-of v0, p1, Ls/l;

    if-eqz v0, :cond_7

    move-object v0, p1

    check-cast v0, Ls/l;

    iget-object v1, v0, Ls/l;->e:Ljava/lang/Throwable;

    const/4 v2, 0x1

    if-eqz v1, :cond_1

    move v1, v2

    goto :goto_1

    :cond_1
    const/4 v1, 0x0

    :goto_1
    xor-int/2addr v1, v2

    if-eqz v1, :cond_6

    const/4 v1, 0x0

    const/16 v2, 0xf

    invoke-static {v0, v1, p2, v2}, Ls/l;->a(Ls/l;Ls/d;Ljava/util/concurrent/CancellationException;I)Ls/l;

    move-result-object v1

    sget-object v2, Ls/f;->i:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    :cond_2
    invoke-virtual {v2, p0, p1, v1}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_5

    iget-object p1, v0, Ls/l;->b:Ls/d;

    if-eqz p1, :cond_3

    invoke-virtual {p0, p1, p2}, Ls/f;->h(Ls/d;Ljava/lang/Throwable;)V

    :cond_3
    iget-object p1, v0, Ls/l;->c:Ll/l;

    if-eqz p1, :cond_4

    :try_start_0
    invoke-interface {p1, p2}, Ll/l;->invoke(Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_2

    :catchall_0
    move-exception p1

    new-instance p2, Lc/b;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "Exception in resume onCancellation handler for "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p2, v0, p1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    iget-object p0, p0, Ls/f;->f:Le/j;

    invoke-static {p0, p2}, Lkotlinx/coroutines/scheduling/h;->d(Le/j;Ljava/lang/Throwable;)V

    :cond_4
    :goto_2
    return-void

    :cond_5
    invoke-virtual {v2, p0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    if-eq v3, p1, :cond_2

    goto :goto_0

    :cond_6
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "Must be called at most once"

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_7
    sget-object v6, Ls/f;->i:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    new-instance v7, Ls/l;

    const/4 v2, 0x0

    const/4 v3, 0x0

    const/16 v5, 0xe

    move-object v0, v7

    move-object v1, p1

    move-object v4, p2

    invoke-direct/range {v0 .. v5}, Ls/l;-><init>(Ljava/lang/Object;Ls/d;Ll/l;Ljava/util/concurrent/CancellationException;I)V

    :cond_8
    invoke-virtual {v6, p0, p1, v7}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_9

    return-void

    :cond_9
    invoke-virtual {v6, p0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-eq v0, p1, :cond_8

    goto/16 :goto_0

    :cond_a
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "Not completed"

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public final b()Le/e;
    .locals 0

    iget-object p0, p0, Ls/f;->e:Le/e;

    return-object p0
.end method

.method public final c(Ljava/lang/Object;)Ljava/lang/Throwable;
    .locals 0

    invoke-super {p0, p1}, Ls/e0;->c(Ljava/lang/Object;)Ljava/lang/Throwable;

    move-result-object p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method public final d(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    instance-of p0, p1, Ls/l;

    if-eqz p0, :cond_0

    check-cast p1, Ls/l;

    iget-object p1, p1, Ls/l;->a:Ljava/lang/Object;

    :cond_0
    return-object p1
.end method

.method public final f()Ljava/lang/Object;
    .locals 0

    iget-object p0, p0, Ls/f;->_state:Ljava/lang/Object;

    return-object p0
.end method

.method public final g(Landroidx/activity/contextaware/ContextAwareKt$withContextAvailable$2$1;Ljava/lang/Throwable;)V
    .locals 2

    :try_start_0
    invoke-interface {p1, p2}, Ll/l;->invoke(Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception p1

    new-instance p2, Lc/b;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "Exception in invokeOnCancellation handler for "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p2, v0, p1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    iget-object p0, p0, Ls/f;->f:Le/j;

    invoke-static {p0, p2}, Lkotlinx/coroutines/scheduling/h;->d(Le/j;Ljava/lang/Throwable;)V

    :goto_0
    return-void
.end method

.method public final getCallerFrame()Lg/d;
    .locals 1

    iget-object p0, p0, Ls/f;->e:Le/e;

    instance-of v0, p0, Lg/d;

    if-eqz v0, :cond_0

    check-cast p0, Lg/d;

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method public final getContext()Le/j;
    .locals 0

    iget-object p0, p0, Ls/f;->f:Le/j;

    return-object p0
.end method

.method public final h(Ls/d;Ljava/lang/Throwable;)V
    .locals 2

    :try_start_0
    check-cast p1, Ls/p0;

    iget-object p1, p1, Ls/p0;->b:Ll/l;

    invoke-interface {p1, p2}, Ll/l;->invoke(Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception p1

    new-instance p2, Lc/b;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "Exception in invokeOnCancellation handler for "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p2, v0, p1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    iget-object p0, p0, Ls/f;->f:Le/j;

    invoke-static {p0, p2}, Lkotlinx/coroutines/scheduling/h;->d(Le/j;Ljava/lang/Throwable;)V

    :goto_0
    return-void
.end method

.method public final i(Ljava/lang/Throwable;)V
    .locals 5

    :goto_0
    iget-object v0, p0, Ls/f;->_state:Ljava/lang/Object;

    instance-of v1, v0, Ls/d1;

    if-nez v1, :cond_0

    return-void

    :cond_0
    new-instance v1, Ls/g;

    instance-of v2, v0, Ls/d;

    invoke-direct {v1, p0, p1, v2}, Ls/g;-><init>(Le/e;Ljava/lang/Throwable;Z)V

    sget-object v3, Ls/f;->i:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    :cond_1
    invoke-virtual {v3, p0, v0, v1}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_6

    if-eqz v2, :cond_2

    check-cast v0, Ls/d;

    goto :goto_1

    :cond_2
    const/4 v0, 0x0

    :goto_1
    if-eqz v0, :cond_3

    invoke-virtual {p0, v0, p1}, Ls/f;->h(Ls/d;Ljava/lang/Throwable;)V

    :cond_3
    invoke-virtual {p0}, Ls/f;->o()Z

    move-result p1

    if-nez p1, :cond_5

    iget-object p1, p0, Ls/f;->g:Ls/g0;

    if-nez p1, :cond_4

    goto :goto_2

    :cond_4
    invoke-interface {p1}, Ls/g0;->dispose()V

    sget-object p1, Ls/c1;->b:Ls/c1;

    iput-object p1, p0, Ls/f;->g:Ls/g0;

    :cond_5
    :goto_2
    iget p1, p0, Ls/e0;->d:I

    invoke-virtual {p0, p1}, Ls/f;->j(I)V

    return-void

    :cond_6
    invoke-virtual {v3, p0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    if-eq v4, v0, :cond_1

    goto :goto_0
.end method

.method public final j(I)V
    .locals 5

    :cond_0
    iget v0, p0, Ls/f;->_decision:I

    const/4 v1, 0x0

    if-eqz v0, :cond_7

    const/4 v2, 0x1

    if-ne v0, v2, :cond_6

    iget-object v0, p0, Ls/f;->e:Le/e;

    const/4 v3, 0x4

    if-ne p1, v3, :cond_1

    move v1, v2

    :cond_1
    if-nez v1, :cond_5

    instance-of v3, v0, Lkotlinx/coroutines/internal/d;

    if-eqz v3, :cond_5

    invoke-static {p1}, Lkotlinx/coroutines/scheduling/h;->f(I)Z

    move-result p1

    iget v3, p0, Ls/e0;->d:I

    invoke-static {v3}, Lkotlinx/coroutines/scheduling/h;->f(I)Z

    move-result v3

    if-ne p1, v3, :cond_5

    move-object p1, v0

    check-cast p1, Lkotlinx/coroutines/internal/d;

    iget-object p1, p1, Lkotlinx/coroutines/internal/d;->e:Ls/s;

    invoke-interface {v0}, Le/e;->getContext()Le/j;

    move-result-object v0

    invoke-virtual {p1, v0}, Ls/s;->isDispatchNeeded(Le/j;)Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-virtual {p1, v0, p0}, Ls/s;->dispatch(Le/j;Ljava/lang/Runnable;)V

    goto :goto_1

    :cond_2
    invoke-static {}, Ls/i1;->a()Ls/k0;

    move-result-object p1

    iget-wide v0, p1, Ls/k0;->b:J

    const-wide v3, 0x100000000L

    cmp-long v0, v0, v3

    if-ltz v0, :cond_3

    invoke-virtual {p1, p0}, Ls/k0;->c(Ls/e0;)V

    goto :goto_1

    :cond_3
    invoke-virtual {p1, v2}, Ls/k0;->e(Z)V

    :try_start_0
    iget-object v0, p0, Ls/f;->e:Le/e;

    invoke-static {p0, v0, v2}, Lkotlinx/coroutines/scheduling/h;->i(Ls/e0;Le/e;Z)V

    :cond_4
    invoke-virtual {p1}, Ls/k0;->f()Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez v0, :cond_4

    :goto_0
    invoke-virtual {p1}, Ls/k0;->b()V

    goto :goto_1

    :catchall_0
    move-exception v0

    const/4 v1, 0x0

    :try_start_1
    invoke-virtual {p0, v0, v1}, Ls/e0;->e(Ljava/lang/Throwable;Ljava/lang/Throwable;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    goto :goto_0

    :catchall_1
    move-exception p0

    invoke-virtual {p1}, Ls/k0;->b()V

    throw p0

    :cond_5
    invoke-static {p0, v0, v1}, Lkotlinx/coroutines/scheduling/h;->i(Ls/e0;Le/e;Z)V

    :goto_1
    return-void

    :cond_6
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "Already resumed"

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_7
    sget-object v0, Ls/f;->h:Ljava/util/concurrent/atomic/AtomicIntegerFieldUpdater;

    const/4 v2, 0x2

    invoke-virtual {v0, p0, v1, v2}, Ljava/util/concurrent/atomic/AtomicIntegerFieldUpdater;->compareAndSet(Ljava/lang/Object;II)Z

    move-result v0

    if-eqz v0, :cond_0

    return-void
.end method

.method public final k()Ljava/lang/Object;
    .locals 6

    invoke-virtual {p0}, Ls/f;->o()Z

    move-result v0

    :cond_0
    iget v1, p0, Ls/f;->_decision:I

    sget-object v2, Ls/c1;->b:Ls/c1;

    const/4 v3, 0x0

    if-eqz v1, :cond_9

    const/4 v4, 0x2

    if-ne v1, v4, :cond_8

    if-eqz v0, :cond_4

    iget-object v0, p0, Ls/f;->e:Le/e;

    instance-of v1, v0, Lkotlinx/coroutines/internal/d;

    if-eqz v1, :cond_1

    move-object v3, v0

    check-cast v3, Lkotlinx/coroutines/internal/d;

    :cond_1
    if-eqz v3, :cond_4

    invoke-virtual {v3, p0}, Lkotlinx/coroutines/internal/d;->j(Ls/e;)Ljava/lang/Throwable;

    move-result-object v0

    if-nez v0, :cond_2

    goto :goto_1

    :cond_2
    iget-object v1, p0, Ls/f;->g:Ls/g0;

    if-nez v1, :cond_3

    goto :goto_0

    :cond_3
    invoke-interface {v1}, Ls/g0;->dispose()V

    iput-object v2, p0, Ls/f;->g:Ls/g0;

    :goto_0
    invoke-virtual {p0, v0}, Ls/f;->i(Ljava/lang/Throwable;)V

    :cond_4
    :goto_1
    iget-object v0, p0, Ls/f;->_state:Ljava/lang/Object;

    instance-of v1, v0, Ls/m;

    if-nez v1, :cond_7

    iget v1, p0, Ls/e0;->d:I

    invoke-static {v1}, Lkotlinx/coroutines/scheduling/h;->f(I)Z

    move-result v1

    if-eqz v1, :cond_6

    iget-object v1, p0, Ls/f;->f:Le/j;

    sget-object v2, Ls/t;->c:Ls/t;

    invoke-interface {v1, v2}, Le/j;->get(Le/i;)Le/h;

    move-result-object v1

    check-cast v1, Ls/r0;

    if-eqz v1, :cond_6

    invoke-interface {v1}, Ls/r0;->a()Z

    move-result v2

    if-eqz v2, :cond_5

    goto :goto_2

    :cond_5
    check-cast v1, Ls/y0;

    invoke-virtual {v1}, Ls/y0;->l()Ljava/util/concurrent/CancellationException;

    move-result-object v1

    invoke-virtual {p0, v0, v1}, Ls/f;->a(Ljava/lang/Object;Ljava/util/concurrent/CancellationException;)V

    throw v1

    :cond_6
    :goto_2
    invoke-virtual {p0, v0}, Ls/f;->d(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    return-object p0

    :cond_7
    check-cast v0, Ls/m;

    iget-object p0, v0, Ls/m;->a:Ljava/lang/Throwable;

    throw p0

    :cond_8
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string v0, "Already suspended"

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_9
    sget-object v1, Ls/f;->h:Ljava/util/concurrent/atomic/AtomicIntegerFieldUpdater;

    const/4 v4, 0x1

    const/4 v5, 0x0

    invoke-virtual {v1, p0, v5, v4}, Ljava/util/concurrent/atomic/AtomicIntegerFieldUpdater;->compareAndSet(Ljava/lang/Object;II)Z

    move-result v1

    if-eqz v1, :cond_0

    iget-object v1, p0, Ls/f;->g:Ls/g0;

    if-nez v1, :cond_a

    invoke-virtual {p0}, Ls/f;->m()Ls/g0;

    :cond_a
    if-eqz v0, :cond_e

    iget-object v0, p0, Ls/f;->e:Le/e;

    instance-of v1, v0, Lkotlinx/coroutines/internal/d;

    if-eqz v1, :cond_b

    move-object v3, v0

    check-cast v3, Lkotlinx/coroutines/internal/d;

    :cond_b
    if-eqz v3, :cond_e

    invoke-virtual {v3, p0}, Lkotlinx/coroutines/internal/d;->j(Ls/e;)Ljava/lang/Throwable;

    move-result-object v0

    if-nez v0, :cond_c

    goto :goto_4

    :cond_c
    iget-object v1, p0, Ls/f;->g:Ls/g0;

    if-nez v1, :cond_d

    goto :goto_3

    :cond_d
    invoke-interface {v1}, Ls/g0;->dispose()V

    iput-object v2, p0, Ls/f;->g:Ls/g0;

    :goto_3
    invoke-virtual {p0, v0}, Ls/f;->i(Ljava/lang/Throwable;)V

    :cond_e
    :goto_4
    sget-object p0, Lf/a;->b:Lf/a;

    return-object p0
.end method

.method public final l()V
    .locals 2

    invoke-virtual {p0}, Ls/f;->m()Ls/g0;

    move-result-object v0

    if-nez v0, :cond_0

    return-void

    :cond_0
    iget-object v1, p0, Ls/f;->_state:Ljava/lang/Object;

    instance-of v1, v1, Ls/d1;

    xor-int/lit8 v1, v1, 0x1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ls/g0;->dispose()V

    sget-object v0, Ls/c1;->b:Ls/c1;

    iput-object v0, p0, Ls/f;->g:Ls/g0;

    :cond_1
    return-void
.end method

.method public final m()Ls/g0;
    .locals 4

    sget-object v0, Ls/t;->c:Ls/t;

    iget-object v1, p0, Ls/f;->f:Le/j;

    invoke-interface {v1, v0}, Le/j;->get(Le/i;)Le/h;

    move-result-object v0

    check-cast v0, Ls/r0;

    if-nez v0, :cond_0

    const/4 p0, 0x0

    return-object p0

    :cond_0
    new-instance v1, Ls/h;

    invoke-direct {v1, p0}, Ls/h;-><init>(Ls/f;)V

    const/4 v2, 0x2

    const/4 v3, 0x1

    invoke-static {v0, v3, v1, v2}, Lkotlinx/coroutines/scheduling/h;->e(Ls/r0;ZLs/u0;I)Ls/g0;

    move-result-object v0

    iput-object v0, p0, Ls/f;->g:Ls/g0;

    return-object v0
.end method

.method public final n(Landroidx/activity/contextaware/ContextAwareKt$withContextAvailable$2$1;)V
    .locals 9

    instance-of v0, p1, Ls/d;

    if-eqz v0, :cond_0

    move-object v0, p1

    check-cast v0, Ls/d;

    goto :goto_0

    :cond_0
    new-instance v0, Ls/p0;

    invoke-direct {v0, p1}, Ls/p0;-><init>(Landroidx/activity/contextaware/ContextAwareKt$withContextAvailable$2$1;)V

    :goto_0
    iget-object v7, p0, Ls/f;->_state:Ljava/lang/Object;

    instance-of v1, v7, Ls/b;

    if-eqz v1, :cond_3

    sget-object v1, Ls/f;->i:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    :cond_1
    invoke-virtual {v1, p0, v7, v0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_2

    return-void

    :cond_2
    invoke-virtual {v1, p0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-eq v2, v7, :cond_1

    goto :goto_0

    :cond_3
    instance-of v1, v7, Ls/d;

    const/4 v2, 0x0

    if-nez v1, :cond_10

    instance-of v1, v7, Ls/m;

    if-eqz v1, :cond_8

    move-object v0, v7

    check-cast v0, Ls/m;

    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 v3, 0x1

    sget-object v4, Ls/m;->b:Ljava/util/concurrent/atomic/AtomicIntegerFieldUpdater;

    const/4 v5, 0x0

    invoke-virtual {v4, v0, v5, v3}, Ljava/util/concurrent/atomic/AtomicIntegerFieldUpdater;->compareAndSet(Ljava/lang/Object;II)Z

    move-result v3

    if-eqz v3, :cond_7

    instance-of v3, v7, Ls/g;

    if-eqz v3, :cond_6

    if-eqz v1, :cond_4

    goto :goto_1

    :cond_4
    move-object v0, v2

    :goto_1
    if-eqz v0, :cond_5

    iget-object v2, v0, Ls/m;->a:Ljava/lang/Throwable;

    :cond_5
    invoke-virtual {p0, p1, v2}, Ls/f;->g(Landroidx/activity/contextaware/ContextAwareKt$withContextAvailable$2$1;Ljava/lang/Throwable;)V

    :cond_6
    return-void

    :cond_7
    invoke-static {v7, p1}, Ls/f;->p(Ljava/lang/Object;Landroidx/activity/contextaware/ContextAwareKt$withContextAvailable$2$1;)V

    throw v2

    :cond_8
    instance-of v1, v7, Ls/l;

    if-eqz v1, :cond_d

    move-object v1, v7

    check-cast v1, Ls/l;

    iget-object v3, v1, Ls/l;->b:Ls/d;

    if-nez v3, :cond_c

    iget-object v3, v1, Ls/l;->e:Ljava/lang/Throwable;

    if-eqz v3, :cond_9

    invoke-virtual {p0, p1, v3}, Ls/f;->g(Landroidx/activity/contextaware/ContextAwareKt$withContextAvailable$2$1;Ljava/lang/Throwable;)V

    return-void

    :cond_9
    const/16 v3, 0x1d

    invoke-static {v1, v0, v2, v3}, Ls/l;->a(Ls/l;Ls/d;Ljava/util/concurrent/CancellationException;I)Ls/l;

    move-result-object v1

    sget-object v3, Ls/f;->i:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    :cond_a
    invoke-virtual {v3, p0, v7, v1}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_b

    return-void

    :cond_b
    invoke-virtual {v3, p0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-eq v2, v7, :cond_a

    goto :goto_0

    :cond_c
    invoke-static {v7, p1}, Ls/f;->p(Ljava/lang/Object;Landroidx/activity/contextaware/ContextAwareKt$withContextAvailable$2$1;)V

    throw v2

    :cond_d
    new-instance v8, Ls/l;

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/16 v6, 0x1c

    move-object v1, v8

    move-object v2, v7

    move-object v3, v0

    invoke-direct/range {v1 .. v6}, Ls/l;-><init>(Ljava/lang/Object;Ls/d;Ll/l;Ljava/util/concurrent/CancellationException;I)V

    sget-object v1, Ls/f;->i:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    :cond_e
    invoke-virtual {v1, p0, v7, v8}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_f

    return-void

    :cond_f
    invoke-virtual {v1, p0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-eq v2, v7, :cond_e

    goto/16 :goto_0

    :cond_10
    invoke-static {v7, p1}, Ls/f;->p(Ljava/lang/Object;Landroidx/activity/contextaware/ContextAwareKt$withContextAvailable$2$1;)V

    throw v2
.end method

.method public final o()Z
    .locals 2

    iget v0, p0, Ls/e0;->d:I

    const/4 v1, 0x2

    if-ne v0, v1, :cond_0

    iget-object p0, p0, Ls/f;->e:Le/e;

    check-cast p0, Lkotlinx/coroutines/internal/d;

    invoke-virtual {p0}, Lkotlinx/coroutines/internal/d;->g()Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public final resumeWith(Ljava/lang/Object;)V
    .locals 11

    invoke-static {p1}, Lc/f;->a(Ljava/lang/Object;)Ljava/lang/Throwable;

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    new-instance p1, Ls/m;

    invoke-direct {p1, v1, v0}, Ls/m;-><init>(ZLjava/lang/Throwable;)V

    :goto_0
    iget v0, p0, Ls/e0;->d:I

    const/4 v8, 0x0

    :goto_1
    iget-object v9, p0, Ls/f;->_state:Ljava/lang/Object;

    instance-of v2, v9, Ls/d1;

    if-eqz v2, :cond_9

    move-object v2, v9

    check-cast v2, Ls/d1;

    instance-of v3, p1, Ls/m;

    if-eqz v3, :cond_1

    goto :goto_4

    :cond_1
    invoke-static {v0}, Lkotlinx/coroutines/scheduling/h;->f(I)Z

    move-result v3

    if-nez v3, :cond_2

    goto :goto_4

    :cond_2
    instance-of v3, v2, Ls/d;

    if-eqz v3, :cond_4

    new-instance v10, Ls/l;

    if-eqz v3, :cond_3

    check-cast v2, Ls/d;

    :goto_2
    move-object v4, v2

    goto :goto_3

    :cond_3
    const/4 v2, 0x0

    goto :goto_2

    :goto_3
    const/4 v6, 0x0

    const/16 v7, 0x10

    move-object v2, v10

    move-object v3, p1

    move-object v5, v8

    invoke-direct/range {v2 .. v7}, Ls/l;-><init>(Ljava/lang/Object;Ls/d;Ll/l;Ljava/util/concurrent/CancellationException;I)V

    goto :goto_5

    :cond_4
    :goto_4
    move-object v10, p1

    :goto_5
    sget-object v2, Ls/f;->i:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    :cond_5
    invoke-virtual {v2, p0, v9, v10}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_8

    invoke-virtual {p0}, Ls/f;->o()Z

    move-result p1

    if-nez p1, :cond_7

    iget-object p1, p0, Ls/f;->g:Ls/g0;

    if-nez p1, :cond_6

    goto :goto_6

    :cond_6
    invoke-interface {p1}, Ls/g0;->dispose()V

    sget-object p1, Ls/c1;->b:Ls/c1;

    iput-object p1, p0, Ls/f;->g:Ls/g0;

    :cond_7
    :goto_6
    invoke-virtual {p0, v0}, Ls/f;->j(I)V

    goto :goto_7

    :cond_8
    invoke-virtual {v2, p0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    if-eq v3, v9, :cond_5

    goto :goto_1

    :cond_9
    instance-of p0, v9, Ls/g;

    if-eqz p0, :cond_a

    check-cast v9, Ls/g;

    invoke-virtual {v9}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    sget-object p0, Ls/g;->c:Ljava/util/concurrent/atomic/AtomicIntegerFieldUpdater;

    const/4 v0, 0x1

    invoke-virtual {p0, v9, v1, v0}, Ljava/util/concurrent/atomic/AtomicIntegerFieldUpdater;->compareAndSet(Ljava/lang/Object;II)Z

    move-result p0

    if-eqz p0, :cond_a

    :goto_7
    return-void

    :cond_a
    new-instance p0, Ljava/lang/IllegalStateException;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "Already resumed, but proposed with update "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public final toString()Ljava/lang/String;
    .locals 3

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "CancellableContinuation("

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Ls/f;->e:Le/e;

    invoke-static {v1}, Ls/y;->p(Le/e;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "){"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Ls/f;->_state:Ljava/lang/Object;

    instance-of v2, v1, Ls/d1;

    if-eqz v2, :cond_0

    const-string v1, "Active"

    goto :goto_0

    :cond_0
    instance-of v1, v1, Ls/g;

    if-eqz v1, :cond_1

    const-string v1, "Cancelled"

    goto :goto_0

    :cond_1
    const-string v1, "Completed"

    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "}@"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p0}, Ls/y;->h(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
