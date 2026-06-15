.class public Ls/y0;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ls/r0;
.implements Ls/k;
.implements Ls/e1;


# static fields
.field public static final synthetic b:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;


# instance fields
.field private volatile synthetic _parentHandle:Ljava/lang/Object;

.field private volatile synthetic _state:Ljava/lang/Object;


# direct methods
.method static constructor <clinit>()V
    .locals 3

    const-class v0, Ljava/lang/Object;

    const-string v1, "_state"

    const-class v2, Ls/y0;

    invoke-static {v2, v0, v1}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->newUpdater(Ljava/lang/Class;Ljava/lang/Class;Ljava/lang/String;)Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    move-result-object v0

    sput-object v0, Ls/y0;->b:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    return-void
.end method

.method public constructor <init>(Z)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    if-eqz p1, :cond_0

    sget-object p1, Ls/y;->h:Ls/h0;

    goto :goto_0

    :cond_0
    sget-object p1, Ls/y;->g:Ls/h0;

    :goto_0
    iput-object p1, p0, Ls/y0;->_state:Ljava/lang/Object;

    const/4 p1, 0x0

    iput-object p1, p0, Ls/y0;->_parentHandle:Ljava/lang/Object;

    return-void
.end method

.method public static C(Ljava/lang/Object;)Ljava/lang/String;
    .locals 2

    instance-of v0, p0, Ls/w0;

    const-string v1, "Active"

    if-eqz v0, :cond_1

    check-cast p0, Ls/w0;

    invoke-virtual {p0}, Ls/w0;->e()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v1, "Cancelling"

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Ls/w0;->f()Z

    move-result p0

    if-eqz p0, :cond_5

    const-string v1, "Completing"

    goto :goto_0

    :cond_1
    instance-of v0, p0, Ls/n0;

    if-eqz v0, :cond_3

    check-cast p0, Ls/n0;

    invoke-interface {p0}, Ls/n0;->a()Z

    move-result p0

    if-eqz p0, :cond_2

    goto :goto_0

    :cond_2
    const-string v1, "New"

    goto :goto_0

    :cond_3
    instance-of p0, p0, Ls/m;

    if-eqz p0, :cond_4

    const-string v1, "Cancelled"

    goto :goto_0

    :cond_4
    const-string v1, "Completed"

    :cond_5
    :goto_0
    return-object v1
.end method

.method public static x(Lkotlinx/coroutines/internal/g;)Ls/j;
    .locals 1

    :goto_0
    invoke-virtual {p0}, Lkotlinx/coroutines/internal/g;->i()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Lkotlinx/coroutines/internal/g;->h()Lkotlinx/coroutines/internal/g;

    move-result-object p0

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Lkotlinx/coroutines/internal/g;->g()Lkotlinx/coroutines/internal/g;

    move-result-object p0

    invoke-virtual {p0}, Lkotlinx/coroutines/internal/g;->i()Z

    move-result v0

    if-nez v0, :cond_0

    instance-of v0, p0, Ls/j;

    if-eqz v0, :cond_1

    check-cast p0, Ls/j;

    return-object p0

    :cond_1
    instance-of v0, p0, Ls/b1;

    if-eqz v0, :cond_0

    const/4 p0, 0x0

    return-object p0
.end method


# virtual methods
.method public A()V
    .locals 0

    return-void
.end method

.method public final B(Ls/u0;)V
    .locals 3

    new-instance v0, Ls/b1;

    invoke-direct {v0}, Lkotlinx/coroutines/internal/g;-><init>()V

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    sget-object v1, Lkotlinx/coroutines/internal/g;->c:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    invoke-virtual {v1, v0, p1}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->lazySet(Ljava/lang/Object;Ljava/lang/Object;)V

    sget-object v1, Lkotlinx/coroutines/internal/g;->b:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    invoke-virtual {v1, v0, p1}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->lazySet(Ljava/lang/Object;Ljava/lang/Object;)V

    :goto_0
    invoke-virtual {p1}, Lkotlinx/coroutines/internal/g;->f()Ljava/lang/Object;

    move-result-object v2

    if-eq v2, p1, :cond_0

    goto :goto_1

    :cond_0
    invoke-virtual {v1, p1, p1, v0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_3

    invoke-virtual {v0, p1}, Lkotlinx/coroutines/internal/g;->e(Lkotlinx/coroutines/internal/g;)V

    :goto_1
    invoke-virtual {p1}, Lkotlinx/coroutines/internal/g;->g()Lkotlinx/coroutines/internal/g;

    move-result-object v2

    :cond_1
    sget-object v0, Ls/y0;->b:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    invoke-virtual {v0, p0, p1, v2}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    goto :goto_2

    :cond_2
    invoke-virtual {v0, p0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-eq v0, p1, :cond_1

    :goto_2
    return-void

    :cond_3
    invoke-virtual {v1, p1}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-eq v2, p1, :cond_0

    goto :goto_0
.end method

.method public final D(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 6

    instance-of v0, p1, Ls/n0;

    if-nez v0, :cond_0

    sget-object p0, Ls/y;->b:Lkotlinx/coroutines/internal/q;

    return-object p0

    :cond_0
    instance-of v0, p1, Ls/h0;

    if-nez v0, :cond_1

    instance-of v0, p1, Ls/u0;

    if-eqz v0, :cond_5

    :cond_1
    instance-of v0, p1, Ls/j;

    if-nez v0, :cond_5

    instance-of v0, p2, Ls/m;

    if-nez v0, :cond_5

    move-object v0, p1

    check-cast v0, Ls/n0;

    instance-of p1, p2, Ls/n0;

    if-eqz p1, :cond_2

    new-instance p1, Ls/o0;

    move-object v1, p2

    check-cast v1, Ls/n0;

    invoke-direct {p1, v1}, Ls/o0;-><init>(Ls/n0;)V

    move-object v1, p1

    goto :goto_0

    :cond_2
    move-object v1, p2

    :cond_3
    :goto_0
    sget-object p1, Ls/y0;->b:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    invoke-virtual {p1, p0, v0, v1}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_4

    invoke-virtual {p0, p2}, Ls/y0;->z(Ljava/lang/Object;)V

    invoke-virtual {p0, v0, p2}, Ls/y0;->i(Ls/n0;Ljava/lang/Object;)V

    return-object p2

    :cond_4
    invoke-virtual {p1, p0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    if-eq p1, v0, :cond_3

    sget-object p0, Ls/y;->d:Lkotlinx/coroutines/internal/q;

    return-object p0

    :cond_5
    check-cast p1, Ls/n0;

    invoke-virtual {p0, p1}, Ls/y0;->o(Ls/n0;)Ls/b1;

    move-result-object v0

    if-nez v0, :cond_6

    sget-object p0, Ls/y;->d:Lkotlinx/coroutines/internal/q;

    goto/16 :goto_7

    :cond_6
    instance-of v1, p1, Ls/w0;

    const/4 v2, 0x0

    if-eqz v1, :cond_7

    move-object v1, p1

    check-cast v1, Ls/w0;

    goto :goto_1

    :cond_7
    move-object v1, v2

    :goto_1
    if-nez v1, :cond_8

    new-instance v1, Ls/w0;

    invoke-direct {v1, v0, v2}, Ls/w0;-><init>(Ls/b1;Ljava/lang/Throwable;)V

    :cond_8
    monitor-enter v1

    :try_start_0
    invoke-virtual {v1}, Ls/w0;->f()Z

    move-result v3

    if-eqz v3, :cond_9

    sget-object p0, Ls/y;->b:Lkotlinx/coroutines/internal/q;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    goto/16 :goto_7

    :cond_9
    :try_start_1
    invoke-virtual {v1}, Ls/w0;->i()V

    if-eq v1, p1, :cond_c

    sget-object v3, Ls/y0;->b:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    :cond_a
    invoke-virtual {v3, p0, p1, v1}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_b

    goto :goto_2

    :cond_b
    invoke-virtual {v3, p0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    if-eq v4, p1, :cond_a

    sget-object p0, Ls/y;->d:Lkotlinx/coroutines/internal/q;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    monitor-exit v1

    goto/16 :goto_7

    :catchall_0
    move-exception p0

    goto/16 :goto_8

    :cond_c
    :goto_2
    :try_start_2
    invoke-virtual {v1}, Ls/w0;->e()Z

    move-result v3

    instance-of v4, p2, Ls/m;

    if-eqz v4, :cond_d

    move-object v4, p2

    check-cast v4, Ls/m;

    goto :goto_3

    :cond_d
    move-object v4, v2

    :goto_3
    if-eqz v4, :cond_e

    iget-object v4, v4, Ls/m;->a:Ljava/lang/Throwable;

    invoke-virtual {v1, v4}, Ls/w0;->b(Ljava/lang/Throwable;)V

    :cond_e
    invoke-virtual {v1}, Ls/w0;->d()Ljava/lang/Throwable;

    move-result-object v4

    const/4 v5, 0x1

    xor-int/2addr v3, v5

    invoke-static {v3}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v3
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    if-eqz v3, :cond_f

    goto :goto_4

    :cond_f
    move-object v4, v2

    :goto_4
    monitor-exit v1

    if-eqz v4, :cond_10

    invoke-virtual {p0, v0, v4}, Ls/y0;->y(Ls/b1;Ljava/lang/Throwable;)V

    :cond_10
    instance-of v0, p1, Ls/j;

    if-eqz v0, :cond_11

    move-object v0, p1

    check-cast v0, Ls/j;

    goto :goto_5

    :cond_11
    move-object v0, v2

    :goto_5
    if-nez v0, :cond_12

    invoke-interface {p1}, Ls/n0;->c()Ls/b1;

    move-result-object p1

    if-eqz p1, :cond_13

    invoke-static {p1}, Ls/y0;->x(Lkotlinx/coroutines/internal/g;)Ls/j;

    move-result-object v2

    goto :goto_6

    :cond_12
    move-object v2, v0

    :cond_13
    :goto_6
    if-eqz v2, :cond_16

    :cond_14
    new-instance p1, Ls/v0;

    invoke-direct {p1, p0, v1, v2, p2}, Ls/v0;-><init>(Ls/y0;Ls/w0;Ls/j;Ljava/lang/Object;)V

    iget-object v0, v2, Ls/j;->f:Ls/k;

    const/4 v3, 0x0

    invoke-static {v0, v3, p1, v5}, Lkotlinx/coroutines/scheduling/h;->e(Ls/r0;ZLs/u0;I)Ls/g0;

    move-result-object p1

    sget-object v0, Ls/c1;->b:Ls/c1;

    if-eq p1, v0, :cond_15

    sget-object p0, Ls/y;->c:Lkotlinx/coroutines/internal/q;

    goto :goto_7

    :cond_15
    invoke-static {v2}, Ls/y0;->x(Lkotlinx/coroutines/internal/g;)Ls/j;

    move-result-object v2

    if-nez v2, :cond_14

    :cond_16
    invoke-virtual {p0, v1, p2}, Ls/y0;->k(Ls/w0;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    :goto_7
    return-object p0

    :goto_8
    monitor-exit v1

    throw p0
.end method

.method public a()Z
    .locals 1

    invoke-virtual {p0}, Ls/y0;->q()Ljava/lang/Object;

    move-result-object p0

    instance-of v0, p0, Ls/n0;

    if-eqz v0, :cond_0

    check-cast p0, Ls/n0;

    invoke-interface {p0}, Ls/n0;->a()Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public final b(Ljava/lang/Object;Ls/b1;Ls/u0;)Z
    .locals 5

    new-instance v0, Ls/x0;

    invoke-direct {v0, p3, p0, p1}, Ls/x0;-><init>(Lkotlinx/coroutines/internal/g;Ls/y0;Ljava/lang/Object;)V

    :goto_0
    invoke-virtual {p2}, Lkotlinx/coroutines/internal/g;->h()Lkotlinx/coroutines/internal/g;

    move-result-object p0

    sget-object p1, Lkotlinx/coroutines/internal/g;->c:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    invoke-virtual {p1, p3, p0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->lazySet(Ljava/lang/Object;Ljava/lang/Object;)V

    sget-object p1, Lkotlinx/coroutines/internal/g;->b:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    invoke-virtual {p1, p3, p2}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->lazySet(Ljava/lang/Object;Ljava/lang/Object;)V

    iput-object p2, v0, Ls/x0;->c:Lkotlinx/coroutines/internal/g;

    :cond_0
    invoke-virtual {p1, p0, p2, v0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v1

    const/4 v2, 0x0

    const/4 v3, 0x2

    const/4 v4, 0x1

    if-eqz v1, :cond_2

    invoke-virtual {v0, p0}, Lkotlinx/coroutines/internal/c;->a(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    if-nez p0, :cond_1

    move p0, v4

    goto :goto_1

    :cond_1
    move p0, v3

    goto :goto_1

    :cond_2
    invoke-virtual {p1, p0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    if-eq v1, p2, :cond_0

    move p0, v2

    :goto_1
    if-eq p0, v4, :cond_3

    if-eq p0, v3, :cond_4

    goto :goto_0

    :cond_3
    move v2, v4

    :cond_4
    return v2
.end method

.method public c(Ljava/lang/Object;)V
    .locals 0

    return-void
.end method

.method public d(Ljava/lang/Object;)V
    .locals 0

    invoke-virtual {p0, p1}, Ls/y0;->c(Ljava/lang/Object;)V

    return-void
.end method

.method public final e(Ljava/lang/Object;)Z
    .locals 9

    sget-object v0, Ls/y;->b:Lkotlinx/coroutines/internal/q;

    invoke-virtual {p0}, Ls/y0;->n()Z

    move-result v1

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-eqz v1, :cond_3

    :cond_0
    invoke-virtual {p0}, Ls/y0;->q()Ljava/lang/Object;

    move-result-object v0

    instance-of v1, v0, Ls/n0;

    if-eqz v1, :cond_2

    instance-of v1, v0, Ls/w0;

    if-eqz v1, :cond_1

    move-object v1, v0

    check-cast v1, Ls/w0;

    invoke-virtual {v1}, Ls/w0;->f()Z

    move-result v1

    if-eqz v1, :cond_1

    goto :goto_0

    :cond_1
    new-instance v1, Ls/m;

    invoke-virtual {p0, p1}, Ls/y0;->j(Ljava/lang/Object;)Ljava/lang/Throwable;

    move-result-object v4

    invoke-direct {v1, v2, v4}, Ls/m;-><init>(ZLjava/lang/Throwable;)V

    invoke-virtual {p0, v0, v1}, Ls/y0;->D(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    sget-object v1, Ls/y;->d:Lkotlinx/coroutines/internal/q;

    if-eq v0, v1, :cond_0

    goto :goto_1

    :cond_2
    :goto_0
    sget-object v0, Ls/y;->b:Lkotlinx/coroutines/internal/q;

    :goto_1
    sget-object v1, Ls/y;->c:Lkotlinx/coroutines/internal/q;

    if-ne v0, v1, :cond_3

    return v3

    :cond_3
    sget-object v1, Ls/y;->b:Lkotlinx/coroutines/internal/q;

    if-ne v0, v1, :cond_11

    const/4 v0, 0x0

    move-object v1, v0

    :cond_4
    :goto_2
    invoke-virtual {p0}, Ls/y0;->q()Ljava/lang/Object;

    move-result-object v4

    instance-of v5, v4, Ls/w0;

    if-eqz v5, :cond_9

    monitor-enter v4

    :try_start_0
    move-object v5, v4

    check-cast v5, Ls/w0;

    invoke-virtual {v5}, Ls/w0;->g()Z

    move-result v5

    if-eqz v5, :cond_5

    sget-object p1, Ls/y;->e:Lkotlinx/coroutines/internal/q;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v4

    :goto_3
    move-object v0, p1

    goto/16 :goto_6

    :cond_5
    :try_start_1
    move-object v5, v4

    check-cast v5, Ls/w0;

    invoke-virtual {v5}, Ls/w0;->e()Z

    move-result v5

    if-nez v1, :cond_6

    invoke-virtual {p0, p1}, Ls/y0;->j(Ljava/lang/Object;)Ljava/lang/Throwable;

    move-result-object v1

    goto :goto_4

    :catchall_0
    move-exception p0

    goto :goto_5

    :cond_6
    :goto_4
    move-object p1, v4

    check-cast p1, Ls/w0;

    invoke-virtual {p1, v1}, Ls/w0;->b(Ljava/lang/Throwable;)V

    move-object p1, v4

    check-cast p1, Ls/w0;

    invoke-virtual {p1}, Ls/w0;->d()Ljava/lang/Throwable;

    move-result-object p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    xor-int/lit8 v1, v5, 0x1

    if-eqz v1, :cond_7

    move-object v0, p1

    :cond_7
    monitor-exit v4

    if-eqz v0, :cond_8

    check-cast v4, Ls/w0;

    iget-object p1, v4, Ls/w0;->b:Ls/b1;

    invoke-virtual {p0, p1, v0}, Ls/y0;->y(Ls/b1;Ljava/lang/Throwable;)V

    :cond_8
    sget-object p1, Ls/y;->b:Lkotlinx/coroutines/internal/q;

    goto :goto_3

    :goto_5
    monitor-exit v4

    throw p0

    :cond_9
    instance-of v5, v4, Ls/n0;

    if-eqz v5, :cond_10

    if-nez v1, :cond_a

    invoke-virtual {p0, p1}, Ls/y0;->j(Ljava/lang/Object;)Ljava/lang/Throwable;

    move-result-object v1

    :cond_a
    move-object v5, v4

    check-cast v5, Ls/n0;

    invoke-interface {v5}, Ls/n0;->a()Z

    move-result v6

    if-eqz v6, :cond_e

    invoke-virtual {p0, v5}, Ls/y0;->o(Ls/n0;)Ls/b1;

    move-result-object v6

    if-nez v6, :cond_b

    goto :goto_2

    :cond_b
    new-instance v7, Ls/w0;

    invoke-direct {v7, v6, v1}, Ls/w0;-><init>(Ls/b1;Ljava/lang/Throwable;)V

    :cond_c
    sget-object v4, Ls/y0;->b:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    invoke-virtual {v4, p0, v5, v7}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_d

    invoke-virtual {p0, v6, v1}, Ls/y0;->y(Ls/b1;Ljava/lang/Throwable;)V

    sget-object p1, Ls/y;->b:Lkotlinx/coroutines/internal/q;

    goto :goto_3

    :cond_d
    invoke-virtual {v4, p0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    if-eq v4, v5, :cond_c

    goto :goto_2

    :cond_e
    new-instance v5, Ls/m;

    invoke-direct {v5, v2, v1}, Ls/m;-><init>(ZLjava/lang/Throwable;)V

    invoke-virtual {p0, v4, v5}, Ls/y0;->D(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    sget-object v6, Ls/y;->b:Lkotlinx/coroutines/internal/q;

    if-eq v5, v6, :cond_f

    sget-object v4, Ls/y;->d:Lkotlinx/coroutines/internal/q;

    if-eq v5, v4, :cond_4

    move-object v0, v5

    goto :goto_6

    :cond_f
    new-instance p0, Ljava/lang/IllegalStateException;

    new-instance p1, Ljava/lang/StringBuilder;

    const-string v0, "Cannot happen in "

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_10
    sget-object p1, Ls/y;->e:Lkotlinx/coroutines/internal/q;

    goto/16 :goto_3

    :cond_11
    :goto_6
    sget-object p1, Ls/y;->b:Lkotlinx/coroutines/internal/q;

    if-ne v0, p1, :cond_12

    :goto_7
    move v2, v3

    goto :goto_8

    :cond_12
    sget-object p1, Ls/y;->c:Lkotlinx/coroutines/internal/q;

    if-ne v0, p1, :cond_13

    goto :goto_7

    :cond_13
    sget-object p1, Ls/y;->e:Lkotlinx/coroutines/internal/q;

    if-ne v0, p1, :cond_14

    goto :goto_8

    :cond_14
    invoke-virtual {p0, v0}, Ls/y0;->c(Ljava/lang/Object;)V

    goto :goto_7

    :goto_8
    return v2
.end method

.method public final f(Ljava/lang/Throwable;)Z
    .locals 3

    invoke-virtual {p0}, Ls/y0;->u()Z

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_0

    return v1

    :cond_0
    instance-of v0, p1, Ljava/util/concurrent/CancellationException;

    iget-object p0, p0, Ls/y0;->_parentHandle:Ljava/lang/Object;

    check-cast p0, Ls/i;

    if-eqz p0, :cond_4

    sget-object v2, Ls/c1;->b:Ls/c1;

    if-ne p0, v2, :cond_1

    goto :goto_1

    :cond_1
    invoke-interface {p0, p1}, Ls/i;->b(Ljava/lang/Throwable;)Z

    move-result p0

    if-nez p0, :cond_3

    if-eqz v0, :cond_2

    goto :goto_0

    :cond_2
    const/4 v1, 0x0

    :cond_3
    :goto_0
    return v1

    :cond_4
    :goto_1
    return v0
.end method

.method public final fold(Ljava/lang/Object;Ll/p;)Ljava/lang/Object;
    .locals 0

    invoke-interface {p2, p1, p0}, Ll/p;->invoke(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method public g()Ljava/lang/String;
    .locals 0

    const-string p0, "Job was cancelled"

    return-object p0
.end method

.method public final get(Le/i;)Le/h;
    .locals 1

    sget-object v0, Ls/t;->c:Ls/t;

    invoke-static {v0, p1}, Ls/y;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method public final getKey()Le/i;
    .locals 0

    sget-object p0, Ls/t;->c:Ls/t;

    return-object p0
.end method

.method public h(Ljava/lang/Throwable;)Z
    .locals 2

    instance-of v0, p1, Ljava/util/concurrent/CancellationException;

    const/4 v1, 0x1

    if-eqz v0, :cond_0

    return v1

    :cond_0
    invoke-virtual {p0, p1}, Ls/y0;->e(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    invoke-virtual {p0}, Ls/y0;->m()Z

    move-result p0

    if-eqz p0, :cond_1

    goto :goto_0

    :cond_1
    const/4 v1, 0x0

    :goto_0
    return v1
.end method

.method public final i(Ls/n0;Ljava/lang/Object;)V
    .locals 7

    iget-object v0, p0, Ls/y0;->_parentHandle:Ljava/lang/Object;

    check-cast v0, Ls/i;

    if-eqz v0, :cond_0

    invoke-interface {v0}, Ls/g0;->dispose()V

    sget-object v0, Ls/c1;->b:Ls/c1;

    iput-object v0, p0, Ls/y0;->_parentHandle:Ljava/lang/Object;

    :cond_0
    instance-of v0, p2, Ls/m;

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    check-cast p2, Ls/m;

    goto :goto_0

    :cond_1
    move-object p2, v1

    :goto_0
    if-eqz p2, :cond_2

    iget-object p2, p2, Ls/m;->a:Ljava/lang/Throwable;

    goto :goto_1

    :cond_2
    move-object p2, v1

    :goto_1
    instance-of v0, p1, Ls/u0;

    const-string v2, " for "

    const-string v3, "Exception in completion handler "

    if-eqz v0, :cond_3

    :try_start_0
    move-object v0, p1

    check-cast v0, Ls/u0;

    invoke-virtual {v0, p2}, Ls/u0;->l(Ljava/lang/Throwable;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_4

    :catchall_0
    move-exception p2

    new-instance v0, Lc/b;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v0, p1, p2}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    invoke-virtual {p0, v0}, Ls/y0;->s(Lc/b;)V

    goto :goto_4

    :cond_3
    invoke-interface {p1}, Ls/n0;->c()Ls/b1;

    move-result-object p1

    if-eqz p1, :cond_7

    invoke-virtual {p1}, Lkotlinx/coroutines/internal/g;->f()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lkotlinx/coroutines/internal/g;

    :goto_2
    invoke-static {v0, p1}, Ls/y;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_6

    instance-of v4, v0, Ls/u0;

    if-eqz v4, :cond_5

    move-object v4, v0

    check-cast v4, Ls/u0;

    :try_start_1
    invoke-virtual {v4, p2}, Ls/u0;->l(Ljava/lang/Throwable;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    goto :goto_3

    :catchall_1
    move-exception v5

    if-eqz v1, :cond_4

    invoke-static {v1, v5}, Ls/y;->a(Ljava/lang/Throwable;Ljava/lang/Throwable;)V

    goto :goto_3

    :cond_4
    new-instance v1, Lc/b;

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-direct {v1, v4, v5}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    :cond_5
    :goto_3
    invoke-virtual {v0}, Lkotlinx/coroutines/internal/g;->g()Lkotlinx/coroutines/internal/g;

    move-result-object v0

    goto :goto_2

    :cond_6
    if-eqz v1, :cond_7

    invoke-virtual {p0, v1}, Ls/y0;->s(Lc/b;)V

    :cond_7
    :goto_4
    return-void
.end method

.method public final j(Ljava/lang/Object;)Ljava/lang/Throwable;
    .locals 3

    instance-of p0, p1, Ljava/lang/Throwable;

    if-eqz p0, :cond_0

    check-cast p1, Ljava/lang/Throwable;

    goto :goto_1

    :cond_0
    check-cast p1, Ls/e1;

    check-cast p1, Ls/y0;

    invoke-virtual {p1}, Ls/y0;->q()Ljava/lang/Object;

    move-result-object p0

    instance-of v0, p0, Ls/w0;

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    move-object v0, p0

    check-cast v0, Ls/w0;

    invoke-virtual {v0}, Ls/w0;->d()Ljava/lang/Throwable;

    move-result-object v0

    goto :goto_0

    :cond_1
    instance-of v0, p0, Ls/m;

    if-eqz v0, :cond_2

    move-object v0, p0

    check-cast v0, Ls/m;

    iget-object v0, v0, Ls/m;->a:Ljava/lang/Throwable;

    goto :goto_0

    :cond_2
    instance-of v0, p0, Ls/n0;

    if-nez v0, :cond_5

    move-object v0, v1

    :goto_0
    instance-of v2, v0, Ljava/util/concurrent/CancellationException;

    if-eqz v2, :cond_3

    move-object v1, v0

    check-cast v1, Ljava/util/concurrent/CancellationException;

    :cond_3
    if-nez v1, :cond_4

    new-instance v1, Ls/s0;

    invoke-static {p0}, Ls/y0;->C(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    const-string v2, "Parent job is "

    invoke-virtual {v2, p0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v1, p0, v0, p1}, Ls/s0;-><init>(Ljava/lang/String;Ljava/lang/Throwable;Ls/r0;)V

    :cond_4
    move-object p1, v1

    :goto_1
    return-object p1

    :cond_5
    new-instance p1, Ljava/lang/IllegalStateException;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "Cannot be cancelling child in this state: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {p1, p0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method public final k(Ls/w0;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 8

    instance-of v0, p2, Ls/m;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    move-object v0, p2

    check-cast v0, Ls/m;

    goto :goto_0

    :cond_0
    move-object v0, v1

    :goto_0
    if-eqz v0, :cond_1

    iget-object v0, v0, Ls/m;->a:Ljava/lang/Throwable;

    goto :goto_1

    :cond_1
    move-object v0, v1

    :goto_1
    monitor-enter p1

    :try_start_0
    invoke-virtual {p1}, Ls/w0;->e()Z

    invoke-virtual {p1, v0}, Ls/w0;->h(Ljava/lang/Throwable;)Ljava/util/ArrayList;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v3

    const/4 v4, 0x1

    const/4 v5, 0x0

    if-eqz v3, :cond_2

    invoke-virtual {p1}, Ls/w0;->e()Z

    move-result v3

    if-eqz v3, :cond_6

    new-instance v3, Ls/s0;

    invoke-virtual {p0}, Ls/y0;->g()Ljava/lang/String;

    move-result-object v6

    invoke-direct {v3, v6, v1, p0}, Ls/s0;-><init>(Ljava/lang/String;Ljava/lang/Throwable;Ls/r0;)V

    move-object v1, v3

    goto :goto_2

    :cond_2
    invoke-interface {v2}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_3
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v6

    if-eqz v6, :cond_4

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v6

    move-object v7, v6

    check-cast v7, Ljava/lang/Throwable;

    instance-of v7, v7, Ljava/util/concurrent/CancellationException;

    xor-int/2addr v7, v4

    if-eqz v7, :cond_3

    move-object v1, v6

    :cond_4
    check-cast v1, Ljava/lang/Throwable;

    if-eqz v1, :cond_5

    goto :goto_2

    :cond_5
    invoke-interface {v2, v5}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Throwable;

    :cond_6
    :goto_2
    if-eqz v1, :cond_9

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v3

    if-gt v3, v4, :cond_7

    goto :goto_4

    :cond_7
    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v3

    new-instance v6, Ljava/util/IdentityHashMap;

    invoke-direct {v6, v3}, Ljava/util/IdentityHashMap;-><init>(I)V

    invoke-static {v6}, Ljava/util/Collections;->newSetFromMap(Ljava/util/Map;)Ljava/util/Set;

    move-result-object v3

    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_8
    :goto_3
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v6

    if-eqz v6, :cond_9

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/Throwable;

    if-eq v6, v1, :cond_8

    if-eq v6, v1, :cond_8

    instance-of v7, v6, Ljava/util/concurrent/CancellationException;

    if-nez v7, :cond_8

    invoke-interface {v3, v6}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_8

    invoke-static {v1, v6}, Ls/y;->a(Ljava/lang/Throwable;Ljava/lang/Throwable;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_3

    :cond_9
    :goto_4
    monitor-exit p1

    if-nez v1, :cond_a

    goto :goto_5

    :cond_a
    if-ne v1, v0, :cond_b

    goto :goto_5

    :cond_b
    new-instance p2, Ls/m;

    invoke-direct {p2, v5, v1}, Ls/m;-><init>(ZLjava/lang/Throwable;)V

    :goto_5
    if-eqz v1, :cond_e

    invoke-virtual {p0, v1}, Ls/y0;->f(Ljava/lang/Throwable;)Z

    move-result v0

    if-nez v0, :cond_c

    invoke-virtual {p0, v1}, Ls/y0;->r(Ljava/lang/Throwable;)Z

    move-result v0

    if-eqz v0, :cond_e

    :cond_c
    if-eqz p2, :cond_d

    move-object v0, p2

    check-cast v0, Ls/m;

    sget-object v1, Ls/m;->b:Ljava/util/concurrent/atomic/AtomicIntegerFieldUpdater;

    invoke-virtual {v1, v0, v5, v4}, Ljava/util/concurrent/atomic/AtomicIntegerFieldUpdater;->compareAndSet(Ljava/lang/Object;II)Z

    goto :goto_6

    :cond_d
    new-instance p0, Ljava/lang/NullPointerException;

    const-string p1, "null cannot be cast to non-null type kotlinx.coroutines.CompletedExceptionally"

    invoke-direct {p0, p1}, Ljava/lang/NullPointerException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_e
    :goto_6
    invoke-virtual {p0, p2}, Ls/y0;->z(Ljava/lang/Object;)V

    sget-object v0, Ls/y0;->b:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    instance-of v1, p2, Ls/n0;

    if-eqz v1, :cond_f

    new-instance v1, Ls/o0;

    move-object v2, p2

    check-cast v2, Ls/n0;

    invoke-direct {v1, v2}, Ls/o0;-><init>(Ls/n0;)V

    goto :goto_7

    :cond_f
    move-object v1, p2

    :cond_10
    :goto_7
    invoke-virtual {v0, p0, p1, v1}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_11

    goto :goto_8

    :cond_11
    invoke-virtual {v0, p0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-eq v2, p1, :cond_10

    :goto_8
    invoke-virtual {p0, p1, p2}, Ls/y0;->i(Ls/n0;Ljava/lang/Object;)V

    return-object p2

    :catchall_0
    move-exception p0

    monitor-exit p1

    throw p0
.end method

.method public final l()Ljava/util/concurrent/CancellationException;
    .locals 4

    invoke-virtual {p0}, Ls/y0;->q()Ljava/lang/Object;

    move-result-object v0

    instance-of v1, v0, Ls/w0;

    const/4 v2, 0x0

    const-string v3, "Job is still new or active: "

    if-eqz v1, :cond_3

    check-cast v0, Ls/w0;

    invoke-virtual {v0}, Ls/w0;->d()Ljava/lang/Throwable;

    move-result-object v0

    if-eqz v0, :cond_2

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v1

    const-string v3, " is cancelling"

    invoke-virtual {v1, v3}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    instance-of v3, v0, Ljava/util/concurrent/CancellationException;

    if-eqz v3, :cond_0

    move-object v2, v0

    check-cast v2, Ljava/util/concurrent/CancellationException;

    :cond_0
    if-nez v2, :cond_6

    new-instance v2, Ls/s0;

    if-nez v1, :cond_1

    invoke-virtual {p0}, Ls/y0;->g()Ljava/lang/String;

    move-result-object v1

    :cond_1
    invoke-direct {v2, v1, v0, p0}, Ls/s0;-><init>(Ljava/lang/String;Ljava/lang/Throwable;Ls/r0;)V

    goto :goto_0

    :cond_2
    new-instance v0, Ljava/lang/IllegalStateException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_3
    instance-of v1, v0, Ls/n0;

    if-nez v1, :cond_7

    instance-of v1, v0, Ls/m;

    if-eqz v1, :cond_5

    check-cast v0, Ls/m;

    iget-object v0, v0, Ls/m;->a:Ljava/lang/Throwable;

    instance-of v1, v0, Ljava/util/concurrent/CancellationException;

    if-eqz v1, :cond_4

    move-object v2, v0

    check-cast v2, Ljava/util/concurrent/CancellationException;

    :cond_4
    if-nez v2, :cond_6

    new-instance v1, Ls/s0;

    invoke-virtual {p0}, Ls/y0;->g()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2, v0, p0}, Ls/s0;-><init>(Ljava/lang/String;Ljava/lang/Throwable;Ls/r0;)V

    move-object v2, v1

    goto :goto_0

    :cond_5
    new-instance v0, Ls/s0;

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v1

    const-string v3, " has completed normally"

    invoke-virtual {v1, v3}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1, v2, p0}, Ls/s0;-><init>(Ljava/lang/String;Ljava/lang/Throwable;Ls/r0;)V

    move-object v2, v0

    :cond_6
    :goto_0
    return-object v2

    :cond_7
    new-instance v0, Ljava/lang/IllegalStateException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public m()Z
    .locals 0

    const/4 p0, 0x1

    return p0
.end method

.method public final minusKey(Le/i;)Le/j;
    .locals 1

    sget-object v0, Ls/t;->c:Ls/t;

    invoke-static {v0, p1}, Ls/y;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    sget-object p0, Le/k;->b:Le/k;

    :cond_0
    return-object p0
.end method

.method public n()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public final o(Ls/n0;)Ls/b1;
    .locals 2

    invoke-interface {p1}, Ls/n0;->c()Ls/b1;

    move-result-object v0

    if-nez v0, :cond_2

    instance-of v0, p1, Ls/h0;

    if-eqz v0, :cond_0

    new-instance v0, Ls/b1;

    invoke-direct {v0}, Lkotlinx/coroutines/internal/g;-><init>()V

    goto :goto_0

    :cond_0
    instance-of v0, p1, Ls/u0;

    if-eqz v0, :cond_1

    check-cast p1, Ls/u0;

    invoke-virtual {p0, p1}, Ls/y0;->B(Ls/u0;)V

    const/4 v0, 0x0

    goto :goto_0

    :cond_1
    new-instance p0, Ljava/lang/IllegalStateException;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "State should have list: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_2
    :goto_0
    return-object v0
.end method

.method public final p()Ls/i;
    .locals 0

    iget-object p0, p0, Ls/y0;->_parentHandle:Ljava/lang/Object;

    check-cast p0, Ls/i;

    return-object p0
.end method

.method public final plus(Le/j;)Le/j;
    .locals 0

    invoke-static {p0, p1}, Ls/y;->l(Le/j;Le/j;)Le/j;

    move-result-object p0

    return-object p0
.end method

.method public final q()Ljava/lang/Object;
    .locals 2

    :goto_0
    iget-object v0, p0, Ls/y0;->_state:Ljava/lang/Object;

    instance-of v1, v0, Lkotlinx/coroutines/internal/m;

    if-nez v1, :cond_0

    return-object v0

    :cond_0
    check-cast v0, Lkotlinx/coroutines/internal/m;

    invoke-virtual {v0, p0}, Lkotlinx/coroutines/internal/m;->a(Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0
.end method

.method public r(Ljava/lang/Throwable;)Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public s(Lc/b;)V
    .locals 0

    throw p1
.end method

.method public final t(Ls/r0;)V
    .locals 7

    sget-object v0, Ls/c1;->b:Ls/c1;

    if-nez p1, :cond_0

    iput-object v0, p0, Ls/y0;->_parentHandle:Ljava/lang/Object;

    return-void

    :cond_0
    check-cast p1, Ls/y0;

    :goto_0
    invoke-virtual {p1}, Ls/y0;->q()Ljava/lang/Object;

    move-result-object v1

    instance-of v2, v1, Ls/h0;

    sget-object v3, Ls/y0;->b:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    const/4 v4, 0x1

    const/4 v5, 0x0

    const/4 v6, -0x1

    if-eqz v2, :cond_4

    move-object v2, v1

    check-cast v2, Ls/h0;

    iget-boolean v2, v2, Ls/h0;->b:Z

    if-eqz v2, :cond_1

    goto :goto_3

    :cond_1
    sget-object v2, Ls/y;->h:Ls/h0;

    :cond_2
    invoke-virtual {v3, p1, v1, v2}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_3

    invoke-virtual {p1}, Ls/y0;->A()V

    :goto_1
    move v5, v4

    goto :goto_3

    :cond_3
    invoke-virtual {v3, p1}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    if-eq v5, v1, :cond_2

    :goto_2
    move v5, v6

    goto :goto_3

    :cond_4
    instance-of v2, v1, Ls/m0;

    if-eqz v2, :cond_7

    move-object v2, v1

    check-cast v2, Ls/m0;

    iget-object v2, v2, Ls/m0;->b:Ls/b1;

    :cond_5
    invoke-virtual {v3, p1, v1, v2}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_6

    invoke-virtual {p1}, Ls/y0;->A()V

    goto :goto_1

    :cond_6
    invoke-virtual {v3, p1}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    if-eq v5, v1, :cond_5

    goto :goto_2

    :cond_7
    :goto_3
    if-eqz v5, :cond_8

    if-eq v5, v4, :cond_8

    goto :goto_0

    :cond_8
    new-instance v1, Ls/j;

    invoke-direct {v1, p0}, Ls/j;-><init>(Ls/y0;)V

    const/4 v2, 0x2

    invoke-static {p1, v4, v1, v2}, Lkotlinx/coroutines/scheduling/h;->e(Ls/r0;ZLs/u0;I)Ls/g0;

    move-result-object p1

    check-cast p1, Ls/i;

    iput-object p1, p0, Ls/y0;->_parentHandle:Ljava/lang/Object;

    invoke-virtual {p0}, Ls/y0;->q()Ljava/lang/Object;

    move-result-object v1

    instance-of v1, v1, Ls/n0;

    xor-int/2addr v1, v4

    if-eqz v1, :cond_9

    invoke-interface {p1}, Ls/g0;->dispose()V

    iput-object v0, p0, Ls/y0;->_parentHandle:Ljava/lang/Object;

    :cond_9
    return-void
.end method

.method public final toString()Ljava/lang/String;
    .locals 3

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Ls/y0;->w()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v2, 0x7b

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ls/y0;->q()Ljava/lang/Object;

    move-result-object v2

    invoke-static {v2}, Ls/y0;->C(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v2, 0x7d

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x40

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-static {p0}, Ls/y;->h(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public u()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public final v(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 3

    :cond_0
    invoke-virtual {p0}, Ls/y0;->q()Ljava/lang/Object;

    move-result-object v0

    invoke-virtual {p0, v0, p1}, Ls/y0;->D(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    sget-object v1, Ls/y;->b:Lkotlinx/coroutines/internal/q;

    if-ne v0, v1, :cond_3

    new-instance v0, Ljava/lang/IllegalStateException;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "Job "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p0, " is already complete or completing, but is being completed with "

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    instance-of v1, p1, Ls/m;

    const/4 v2, 0x0

    if-eqz v1, :cond_1

    check-cast p1, Ls/m;

    goto :goto_0

    :cond_1
    move-object p1, v2

    :goto_0
    if-eqz p1, :cond_2

    iget-object v2, p1, Ls/m;->a:Ljava/lang/Throwable;

    :cond_2
    invoke-direct {v0, p0, v2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v0

    :cond_3
    sget-object v1, Ls/y;->d:Lkotlinx/coroutines/internal/q;

    if-eq v0, v1, :cond_0

    return-object v0
.end method

.method public w()Ljava/lang/String;
    .locals 0

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public final y(Ls/b1;Ljava/lang/Throwable;)V
    .locals 6

    invoke-virtual {p1}, Lkotlinx/coroutines/internal/g;->f()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lkotlinx/coroutines/internal/g;

    const/4 v1, 0x0

    :goto_0
    invoke-static {v0, p1}, Ls/y;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_2

    instance-of v2, v0, Ls/t0;

    if-eqz v2, :cond_1

    move-object v2, v0

    check-cast v2, Ls/u0;

    :try_start_0
    invoke-virtual {v2, p2}, Ls/u0;->l(Ljava/lang/Throwable;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_1

    :catchall_0
    move-exception v3

    if-eqz v1, :cond_0

    invoke-static {v1, v3}, Ls/y;->a(Ljava/lang/Throwable;Ljava/lang/Throwable;)V

    goto :goto_1

    :cond_0
    new-instance v1, Lc/b;

    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, "Exception in completion handler "

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, " for "

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2, v3}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    :cond_1
    :goto_1
    invoke-virtual {v0}, Lkotlinx/coroutines/internal/g;->g()Lkotlinx/coroutines/internal/g;

    move-result-object v0

    goto :goto_0

    :cond_2
    if-eqz v1, :cond_3

    invoke-virtual {p0, v1}, Ls/y0;->s(Lc/b;)V

    :cond_3
    invoke-virtual {p0, p2}, Ls/y0;->f(Ljava/lang/Throwable;)Z

    return-void
.end method

.method public z(Ljava/lang/Object;)V
    .locals 0

    return-void
.end method
