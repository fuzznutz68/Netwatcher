.class public abstract Lkotlinx/coroutines/scheduling/h;
.super Ljava/lang/Object;
.source "SourceFile"


# direct methods
.method public static a(Ls/r0;)V
    .locals 3

    check-cast p0, Ls/y0;

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    new-instance v0, Ls/s0;

    invoke-virtual {p0}, Ls/y0;->g()Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2, p0}, Ls/s0;-><init>(Ljava/lang/String;Ljava/lang/Throwable;Ls/r0;)V

    invoke-virtual {p0, v0}, Ls/y0;->e(Ljava/lang/Object;)Z

    return-void
.end method

.method public static final b(I)V
    .locals 1

    const/4 v0, 0x1

    if-lt p0, v0, :cond_0

    return-void

    :cond_0
    const-string v0, "Expected positive parallelism level, but got "

    invoke-static {v0, p0}, Landroidx/activity/result/a;->c(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object p0

    new-instance v0, Ljava/lang/IllegalArgumentException;

    invoke-virtual {p0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public static final c(Le/j;Le/j;Z)Le/j;
    .locals 3

    sget-object p2, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    sget-object v0, Ls/o;->d:Ls/o;

    invoke-interface {p0, p2, v0}, Le/j;->fold(Ljava/lang/Object;Ll/p;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Boolean;

    invoke-virtual {v1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v1

    invoke-interface {p1, p2, v0}, Le/j;->fold(Ljava/lang/Object;Ll/p;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Ljava/lang/Boolean;

    invoke-virtual {p2}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p2

    if-nez v1, :cond_0

    if-nez p2, :cond_0

    invoke-interface {p0, p1}, Le/j;->plus(Le/j;)Le/j;

    move-result-object p0

    return-object p0

    :cond_0
    sget-object v0, Le/k;->b:Le/k;

    new-instance v1, Ls/p;

    const/4 v2, 0x2

    invoke-direct {v1, v2}, Lkotlin/jvm/internal/l;-><init>(I)V

    invoke-interface {p0, v0, v1}, Le/j;->fold(Ljava/lang/Object;Ll/p;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Le/j;

    if-eqz p2, :cond_1

    sget-object p2, Ls/o;->c:Ls/o;

    invoke-interface {p1, v0, p2}, Le/j;->fold(Ljava/lang/Object;Ll/p;)Ljava/lang/Object;

    move-result-object p1

    :cond_1
    check-cast p1, Le/j;

    invoke-interface {p0, p1}, Le/j;->plus(Le/j;)Le/j;

    move-result-object p0

    return-object p0
.end method

.method public static final d(Le/j;Ljava/lang/Throwable;)V
    .locals 3

    :try_start_0
    sget-object v0, Ls/t;->b:Ls/t;

    invoke-interface {p0, v0}, Le/j;->get(Le/i;)Le/h;

    move-result-object v0

    check-cast v0, Ls/u;

    if-eqz v0, :cond_0

    check-cast v0, Lt/b;

    invoke-virtual {v0, p0, p1}, Lt/b;->b(Le/j;Ljava/lang/Throwable;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-void

    :cond_0
    invoke-static {p0, p1}, Ls/v;->a(Le/j;Ljava/lang/Throwable;)V

    return-void

    :catchall_0
    move-exception v0

    if-ne p1, v0, :cond_1

    goto :goto_0

    :cond_1
    new-instance v1, Ljava/lang/RuntimeException;

    const-string v2, "Exception while trying to handle coroutine exception"

    invoke-direct {v1, v2, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    invoke-static {v1, p1}, Ls/y;->a(Ljava/lang/Throwable;Ljava/lang/Throwable;)V

    move-object p1, v1

    :goto_0
    invoke-static {p0, p1}, Ls/v;->a(Le/j;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static e(Ls/r0;ZLs/u0;I)Ls/g0;
    .locals 7

    and-int/lit8 v0, p3, 0x1

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    move p1, v1

    :cond_0
    and-int/lit8 p3, p3, 0x2

    if-eqz p3, :cond_1

    const/4 v1, 0x1

    :cond_1
    check-cast p0, Ls/y0;

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 p3, 0x0

    if-eqz p1, :cond_3

    instance-of v0, p2, Ls/t0;

    if-eqz v0, :cond_2

    move-object v0, p2

    check-cast v0, Ls/t0;

    goto :goto_0

    :cond_2
    move-object v0, p3

    :goto_0
    if-nez v0, :cond_4

    new-instance v0, Ls/q0;

    invoke-direct {v0, p2}, Ls/q0;-><init>(Ls/u0;)V

    goto :goto_1

    :cond_3
    move-object v0, p2

    :cond_4
    :goto_1
    iput-object p0, v0, Ls/u0;->e:Ls/y0;

    :cond_5
    :goto_2
    invoke-virtual {p0}, Ls/y0;->q()Ljava/lang/Object;

    move-result-object v2

    instance-of v3, v2, Ls/h0;

    if-eqz v3, :cond_c

    move-object v3, v2

    check-cast v3, Ls/h0;

    iget-boolean v4, v3, Ls/h0;->b:Z

    if-eqz v4, :cond_8

    sget-object v4, Ls/y0;->b:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    :cond_6
    invoke-virtual {v4, p0, v2, v0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_7

    goto/16 :goto_8

    :cond_7
    invoke-virtual {v4, p0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    if-eq v3, v2, :cond_6

    goto :goto_2

    :cond_8
    new-instance v2, Ls/b1;

    invoke-direct {v2}, Lkotlinx/coroutines/internal/g;-><init>()V

    iget-boolean v4, v3, Ls/h0;->b:Z

    if-eqz v4, :cond_9

    move-object v4, v2

    goto :goto_3

    :cond_9
    new-instance v4, Ls/m0;

    invoke-direct {v4, v2}, Ls/m0;-><init>(Ls/b1;)V

    :cond_a
    :goto_3
    sget-object v2, Ls/y0;->b:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    invoke-virtual {v2, p0, v3, v4}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_b

    goto :goto_2

    :cond_b
    invoke-virtual {v2, p0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-eq v2, v3, :cond_a

    goto :goto_2

    :cond_c
    instance-of v3, v2, Ls/n0;

    if-eqz v3, :cond_16

    move-object v3, v2

    check-cast v3, Ls/n0;

    invoke-interface {v3}, Ls/n0;->c()Ls/b1;

    move-result-object v3

    if-nez v3, :cond_e

    if-eqz v2, :cond_d

    check-cast v2, Ls/u0;

    invoke-virtual {p0, v2}, Ls/y0;->B(Ls/u0;)V

    goto :goto_2

    :cond_d
    new-instance p0, Ljava/lang/NullPointerException;

    const-string p1, "null cannot be cast to non-null type kotlinx.coroutines.JobNode"

    invoke-direct {p0, p1}, Ljava/lang/NullPointerException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_e
    sget-object v4, Ls/c1;->b:Ls/c1;

    if-eqz p1, :cond_13

    instance-of v5, v2, Ls/w0;

    if-eqz v5, :cond_13

    monitor-enter v2

    :try_start_0
    move-object v5, v2

    check-cast v5, Ls/w0;

    invoke-virtual {v5}, Ls/w0;->d()Ljava/lang/Throwable;

    move-result-object v5

    if-eqz v5, :cond_f

    instance-of v6, p2, Ls/j;

    if-eqz v6, :cond_12

    move-object v6, v2

    check-cast v6, Ls/w0;

    invoke-virtual {v6}, Ls/w0;->f()Z

    move-result v6

    if-nez v6, :cond_12

    goto :goto_4

    :catchall_0
    move-exception p0

    goto :goto_5

    :cond_f
    :goto_4
    invoke-virtual {p0, v2, v3, v0}, Ls/y0;->b(Ljava/lang/Object;Ls/b1;Ls/u0;)Z

    move-result v4
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez v4, :cond_10

    monitor-exit v2

    goto/16 :goto_2

    :cond_10
    if-nez v5, :cond_11

    monitor-exit v2

    goto :goto_8

    :cond_11
    move-object v4, v0

    :cond_12
    monitor-exit v2

    goto :goto_6

    :goto_5
    monitor-exit v2

    throw p0

    :cond_13
    move-object v5, p3

    :goto_6
    if-eqz v5, :cond_15

    if-eqz v1, :cond_14

    invoke-interface {p2, v5}, Ll/l;->invoke(Ljava/lang/Object;)Ljava/lang/Object;

    :cond_14
    move-object v0, v4

    goto :goto_8

    :cond_15
    invoke-virtual {p0, v2, v3, v0}, Ls/y0;->b(Ljava/lang/Object;Ls/b1;Ls/u0;)Z

    move-result v2

    if-eqz v2, :cond_5

    goto :goto_8

    :cond_16
    if-eqz v1, :cond_19

    instance-of p0, v2, Ls/m;

    if-eqz p0, :cond_17

    check-cast v2, Ls/m;

    goto :goto_7

    :cond_17
    move-object v2, p3

    :goto_7
    if-eqz v2, :cond_18

    iget-object p3, v2, Ls/m;->a:Ljava/lang/Throwable;

    :cond_18
    invoke-interface {p2, p3}, Ll/l;->invoke(Ljava/lang/Object;)Ljava/lang/Object;

    :cond_19
    sget-object v0, Ls/c1;->b:Ls/c1;

    :goto_8
    return-object v0
.end method

.method public static final f(I)Z
    .locals 2

    const/4 v0, 0x1

    if-eq p0, v0, :cond_1

    const/4 v1, 0x2

    if-ne p0, v1, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :cond_1
    :goto_0
    return v0
.end method

.method public static g(Ls/w;Lt/c;Ll/p;I)Ls/f1;
    .locals 3

    and-int/lit8 v0, p3, 0x1

    if-eqz v0, :cond_0

    sget-object p1, Le/k;->b:Le/k;

    :cond_0
    const/4 v0, 0x2

    and-int/2addr p3, v0

    const/4 v1, 0x1

    if-eqz p3, :cond_1

    move p3, v1

    goto :goto_0

    :cond_1
    const/4 p3, 0x0

    :goto_0
    invoke-interface {p0}, Ls/w;->getCoroutineContext()Le/j;

    move-result-object p0

    invoke-static {p0, p1, v1}, Lkotlinx/coroutines/scheduling/h;->c(Le/j;Le/j;Z)Le/j;

    move-result-object p0

    sget-object p1, Ls/f0;->a:Lkotlinx/coroutines/scheduling/d;

    if-eq p0, p1, :cond_2

    sget-object v2, Le/f;->b:Le/f;

    invoke-interface {p0, v2}, Le/j;->get(Le/i;)Le/h;

    move-result-object v2

    if-nez v2, :cond_2

    invoke-interface {p0, p1}, Le/j;->plus(Le/j;)Le/j;

    move-result-object p0

    :cond_2
    const/4 p1, 0x0

    if-eqz p3, :cond_8

    if-ne p3, v0, :cond_3

    new-instance v2, Ls/z0;

    invoke-direct {v2, p0, p2}, Ls/z0;-><init>(Le/j;Ll/p;)V

    goto :goto_1

    :cond_3
    new-instance v2, Ls/f1;

    invoke-direct {v2, p0, v1}, Ls/a;-><init>(Le/j;Z)V

    :goto_1
    invoke-static {p3}, Ls/x;->b(I)I

    move-result p0

    if-eqz p0, :cond_6

    if-eq p0, v1, :cond_7

    if-eq p0, v0, :cond_5

    const/4 p3, 0x3

    if-ne p0, p3, :cond_4

    :try_start_0
    iget-object p0, v2, Ls/a;->c:Le/j;

    invoke-static {p0, p1}, Lkotlinx/coroutines/internal/b;->e(Le/j;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :try_start_1
    invoke-static {p2}, Ls/y;->c(Ljava/lang/Object;)V

    invoke-interface {p2, v2, v2}, Ll/p;->invoke(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p2
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    :try_start_2
    invoke-static {p0, p1}, Lkotlinx/coroutines/internal/b;->c(Le/j;Ljava/lang/Object;)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    sget-object p0, Lf/a;->b:Lf/a;

    if-eq p2, p0, :cond_7

    invoke-virtual {v2, p2}, Ls/a;->resumeWith(Ljava/lang/Object;)V

    goto :goto_3

    :catchall_0
    move-exception p0

    goto :goto_2

    :catchall_1
    move-exception p2

    :try_start_3
    invoke-static {p0, p1}, Lkotlinx/coroutines/internal/b;->c(Le/j;Ljava/lang/Object;)V

    throw p2
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    :goto_2
    new-instance p1, Lc/e;

    invoke-direct {p1, p0}, Lc/e;-><init>(Ljava/lang/Throwable;)V

    invoke-virtual {v2, p1}, Ls/a;->resumeWith(Ljava/lang/Object;)V

    goto :goto_3

    :cond_4
    new-instance p0, Lc/b;

    invoke-direct {p0}, Ljava/lang/RuntimeException;-><init>()V

    throw p0

    :cond_5
    invoke-static {v2, v2, p2}, Ls/y;->g(Ljava/lang/Object;Le/e;Ll/p;)Le/e;

    move-result-object p0

    invoke-static {p0}, Ls/y;->j(Le/e;)Le/e;

    move-result-object p0

    sget-object p1, Lc/i;->a:Lc/i;

    invoke-interface {p0, p1}, Le/e;->resumeWith(Ljava/lang/Object;)V

    goto :goto_3

    :cond_6
    invoke-static {p2, v2, v2}, Lkotlinx/coroutines/scheduling/h;->j(Ll/p;Ls/a;Ls/a;)V

    :cond_7
    :goto_3
    return-object v2

    :cond_8
    throw p1
.end method

.method public static final h(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 1

    instance-of v0, p0, Ls/m;

    if-eqz v0, :cond_0

    check-cast p0, Ls/m;

    iget-object p0, p0, Ls/m;->a:Ljava/lang/Throwable;

    new-instance v0, Lc/e;

    invoke-direct {v0, p0}, Lc/e;-><init>(Ljava/lang/Throwable;)V

    move-object p0, v0

    :cond_0
    return-object p0
.end method

.method public static final i(Ls/e0;Le/e;Z)V
    .locals 3

    invoke-virtual {p0}, Ls/e0;->f()Ljava/lang/Object;

    move-result-object v0

    invoke-virtual {p0, v0}, Ls/e0;->c(Ljava/lang/Object;)Ljava/lang/Throwable;

    move-result-object v1

    if-eqz v1, :cond_0

    new-instance p0, Lc/e;

    invoke-direct {p0, v1}, Lc/e;-><init>(Ljava/lang/Throwable;)V

    goto :goto_0

    :cond_0
    invoke-virtual {p0, v0}, Ls/e0;->d(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    :goto_0
    if-eqz p2, :cond_5

    check-cast p1, Lkotlinx/coroutines/internal/d;

    iget-object p2, p1, Lkotlinx/coroutines/internal/d;->f:Le/e;

    invoke-interface {p2}, Le/e;->getContext()Le/j;

    move-result-object v0

    iget-object v1, p1, Lkotlinx/coroutines/internal/d;->h:Ljava/lang/Object;

    invoke-static {v0, v1}, Lkotlinx/coroutines/internal/b;->e(Le/j;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    sget-object v2, Lkotlinx/coroutines/internal/b;->e:Lkotlinx/coroutines/internal/q;

    if-eq v1, v2, :cond_1

    invoke-static {p2, v0, v1}, Lkotlinx/coroutines/scheduling/h;->n(Le/e;Le/j;Ljava/lang/Object;)Ls/k1;

    move-result-object p2

    goto :goto_1

    :cond_1
    const/4 p2, 0x0

    :goto_1
    :try_start_0
    iget-object p1, p1, Lkotlinx/coroutines/internal/d;->f:Le/e;

    invoke-interface {p1, p0}, Le/e;->resumeWith(Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz p2, :cond_2

    invoke-virtual {p2}, Ls/k1;->E()Z

    move-result p0

    if-eqz p0, :cond_6

    :cond_2
    invoke-static {v0, v1}, Lkotlinx/coroutines/internal/b;->c(Le/j;Ljava/lang/Object;)V

    goto :goto_2

    :catchall_0
    move-exception p0

    if-eqz p2, :cond_3

    invoke-virtual {p2}, Ls/k1;->E()Z

    move-result p1

    if-eqz p1, :cond_4

    :cond_3
    invoke-static {v0, v1}, Lkotlinx/coroutines/internal/b;->c(Le/j;Ljava/lang/Object;)V

    :cond_4
    throw p0

    :cond_5
    invoke-interface {p1, p0}, Le/e;->resumeWith(Ljava/lang/Object;)V

    :cond_6
    :goto_2
    return-void
.end method

.method public static j(Ll/p;Ls/a;Ls/a;)V
    .locals 1

    :try_start_0
    invoke-static {p1, p2, p0}, Ls/y;->g(Ljava/lang/Object;Le/e;Ll/p;)Le/e;

    move-result-object p0

    invoke-static {p0}, Ls/y;->j(Le/e;)Le/e;

    move-result-object p0

    sget-object p1, Lc/i;->a:Lc/i;

    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Lkotlinx/coroutines/internal/b;->d(Le/e;Ljava/lang/Object;Ll/l;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-void

    :catchall_0
    move-exception p0

    new-instance p1, Lc/e;

    invoke-direct {p1, p0}, Lc/e;-><init>(Ljava/lang/Throwable;)V

    invoke-virtual {p2, p1}, Ls/a;->resumeWith(Ljava/lang/Object;)V

    throw p0
.end method

.method public static final k(Lkotlinx/coroutines/internal/p;Lkotlinx/coroutines/internal/p;Ll/p;)Ljava/lang/Object;
    .locals 1

    :try_start_0
    invoke-static {p2}, Ls/y;->c(Ljava/lang/Object;)V

    invoke-interface {p2, p1, p0}, Ll/p;->invoke(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception p1

    new-instance p2, Ls/m;

    const/4 v0, 0x0

    invoke-direct {p2, v0, p1}, Ls/m;-><init>(ZLjava/lang/Throwable;)V

    move-object p1, p2

    :goto_0
    sget-object p2, Lf/a;->b:Lf/a;

    if-ne p1, p2, :cond_0

    goto :goto_3

    :cond_0
    invoke-virtual {p0, p1}, Ls/y0;->v(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    sget-object p1, Ls/y;->c:Lkotlinx/coroutines/internal/q;

    if-ne p0, p1, :cond_1

    goto :goto_3

    :cond_1
    instance-of p1, p0, Ls/m;

    if-nez p1, :cond_5

    instance-of p1, p0, Ls/o0;

    if-eqz p1, :cond_2

    move-object p1, p0

    check-cast p1, Ls/o0;

    goto :goto_1

    :cond_2
    const/4 p1, 0x0

    :goto_1
    if-eqz p1, :cond_4

    iget-object p1, p1, Ls/o0;->a:Ls/n0;

    if-nez p1, :cond_3

    goto :goto_2

    :cond_3
    move-object p2, p1

    goto :goto_3

    :cond_4
    :goto_2
    move-object p2, p0

    :goto_3
    return-object p2

    :cond_5
    check-cast p0, Ls/m;

    iget-object p0, p0, Ls/m;->a:Ljava/lang/Throwable;

    throw p0
.end method

.method public static final l(JJJLjava/lang/String;)J
    .locals 24

    move-wide/from16 v0, p2

    move-wide/from16 v2, p4

    move-object/from16 v4, p6

    sget v5, Lkotlinx/coroutines/internal/r;->a:I

    :try_start_0
    invoke-static/range {p6 .. p6}, Ljava/lang/System;->getProperty(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    const/4 v6, 0x0

    :goto_0
    if-nez v6, :cond_0

    move-wide/from16 v5, p0

    goto/16 :goto_7

    :cond_0
    new-instance v7, Lo/d;

    const/4 v8, 0x2

    const/16 v9, 0x24

    const/4 v10, 0x1

    invoke-direct {v7, v8, v9, v10}, Lo/b;-><init>(III)V

    iget v7, v7, Lo/b;->c:I

    const/16 v11, 0xa

    if-gt v11, v7, :cond_f

    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v7

    if-nez v7, :cond_3

    :cond_1
    :goto_1
    move-object/from16 v19, v6

    :cond_2
    :goto_2
    const/4 v5, 0x0

    goto/16 :goto_6

    :cond_3
    const/4 v8, 0x0

    invoke-virtual {v6, v8}, Ljava/lang/String;->charAt(I)C

    move-result v9

    const/16 v12, 0x30

    const-wide v13, -0x7fffffffffffffffL    # -4.9E-324

    if-ge v9, v12, :cond_6

    if-ne v7, v10, :cond_4

    goto :goto_1

    :cond_4
    const/16 v12, 0x2d

    if-ne v9, v12, :cond_5

    const-wide/high16 v13, -0x8000000000000000L

    move v8, v10

    goto :goto_3

    :cond_5
    const/16 v12, 0x2b

    if-ne v9, v12, :cond_1

    goto :goto_3

    :cond_6
    move v10, v8

    :goto_3
    const-wide v15, -0x38e38e38e38e38eL    # -2.772000429909333E291

    const-wide/16 v17, 0x0

    move-wide/from16 v19, v17

    move-wide/from16 v17, v15

    :goto_4
    if-ge v10, v7, :cond_a

    invoke-virtual {v6, v10}, Ljava/lang/String;->charAt(I)C

    move-result v9

    invoke-static {v9, v11}, Ljava/lang/Character;->digit(II)I

    move-result v9

    if-gez v9, :cond_7

    goto :goto_1

    :cond_7
    move-wide/from16 v22, v19

    move-object/from16 v19, v6

    move-wide/from16 v5, v22

    cmp-long v20, v5, v17

    if-gez v20, :cond_8

    cmp-long v17, v17, v15

    if-nez v17, :cond_2

    int-to-long v2, v11

    div-long v17, v13, v2

    cmp-long v2, v5, v17

    if-gez v2, :cond_8

    goto :goto_2

    :cond_8
    int-to-long v2, v11

    mul-long/2addr v2, v5

    int-to-long v5, v9

    add-long v20, v13, v5

    cmp-long v9, v2, v20

    if-gez v9, :cond_9

    goto :goto_2

    :cond_9
    sub-long/2addr v2, v5

    add-int/lit8 v10, v10, 0x1

    move-object/from16 v6, v19

    move-wide/from16 v19, v2

    move-wide/from16 v2, p4

    goto :goto_4

    :cond_a
    move-wide/from16 v22, v19

    move-object/from16 v19, v6

    move-wide/from16 v5, v22

    if-eqz v8, :cond_b

    invoke-static {v5, v6}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    :goto_5
    move-object v5, v2

    goto :goto_6

    :cond_b
    neg-long v2, v5

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    goto :goto_5

    :goto_6
    const/16 v2, 0x27

    const-string v3, "System property \'"

    if-eqz v5, :cond_e

    invoke-virtual {v5}, Ljava/lang/Long;->longValue()J

    move-result-wide v5

    cmp-long v7, v0, v5

    if-gtz v7, :cond_c

    move-wide/from16 v7, p4

    cmp-long v9, v5, v7

    if-gtz v9, :cond_d

    :goto_7
    return-wide v5

    :cond_c
    move-wide/from16 v7, p4

    :cond_d
    new-instance v9, Ljava/lang/IllegalStateException;

    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v10, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "\' should be in range "

    invoke-virtual {v10, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v0, ".."

    invoke-virtual {v10, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v7, v8}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v0, ", but is \'"

    invoke-virtual {v10, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v9, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v9

    :cond_e
    new-instance v0, Ljava/lang/IllegalStateException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "\' has unrecognized value \'"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-object/from16 v5, v19

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_f
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "radix 10 was not in valid range "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    new-instance v2, Lo/d;

    invoke-direct {v2, v8, v9, v10}, Lo/b;-><init>(III)V

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public static m(Ljava/lang/String;IIII)I
    .locals 7

    and-int/lit8 v0, p4, 0x4

    if-eqz v0, :cond_0

    const/4 p2, 0x1

    :cond_0
    and-int/lit8 p4, p4, 0x8

    if-eqz p4, :cond_1

    const p3, 0x7fffffff

    :cond_1
    int-to-long v0, p1

    int-to-long v2, p2

    int-to-long v4, p3

    move-object v6, p0

    invoke-static/range {v0 .. v6}, Lkotlinx/coroutines/scheduling/h;->l(JJJLjava/lang/String;)J

    move-result-wide p0

    long-to-int p0, p0

    return p0
.end method

.method public static final n(Le/e;Le/j;Ljava/lang/Object;)Ls/k1;
    .locals 2

    instance-of v0, p0, Lg/d;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return-object v1

    :cond_0
    sget-object v0, Ls/l1;->b:Ls/l1;

    invoke-interface {p1, v0}, Le/j;->get(Le/i;)Le/h;

    move-result-object v0

    if-eqz v0, :cond_4

    check-cast p0, Lg/d;

    :cond_1
    instance-of v0, p0, Ls/d0;

    if-eqz v0, :cond_2

    goto :goto_0

    :cond_2
    invoke-interface {p0}, Lg/d;->getCallerFrame()Lg/d;

    move-result-object p0

    if-nez p0, :cond_3

    goto :goto_0

    :cond_3
    instance-of v0, p0, Ls/k1;

    if-eqz v0, :cond_1

    move-object v1, p0

    check-cast v1, Ls/k1;

    :goto_0
    if-eqz v1, :cond_4

    new-instance p0, Lc/d;

    invoke-direct {p0, p1, p2}, Lc/d;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    iget-object p1, v1, Ls/k1;->e:Ljava/lang/ThreadLocal;

    invoke-virtual {p1, p0}, Ljava/lang/ThreadLocal;->set(Ljava/lang/Object;)V

    :cond_4
    return-object v1
.end method

.method public static final o(Ls/s;Ll/p;Le/e;)Ljava/lang/Object;
    .locals 4

    invoke-interface {p2}, Le/e;->getContext()Le/j;

    move-result-object v0

    sget-object v1, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    sget-object v2, Ls/o;->d:Ls/o;

    invoke-interface {p0, v1, v2}, Le/j;->fold(Ljava/lang/Object;Ll/p;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Boolean;

    invoke-virtual {v1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v1

    if-nez v1, :cond_0

    invoke-interface {v0, p0}, Le/j;->plus(Le/j;)Le/j;

    move-result-object p0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    invoke-static {v0, p0, v1}, Lkotlinx/coroutines/scheduling/h;->c(Le/j;Le/j;Z)Le/j;

    move-result-object p0

    :goto_0
    sget-object v1, Ls/t;->c:Ls/t;

    invoke-interface {p0, v1}, Le/j;->get(Le/i;)Le/h;

    move-result-object v1

    check-cast v1, Ls/r0;

    if-eqz v1, :cond_2

    invoke-interface {v1}, Ls/r0;->a()Z

    move-result v2

    if-eqz v2, :cond_1

    goto :goto_1

    :cond_1
    check-cast v1, Ls/y0;

    invoke-virtual {v1}, Ls/y0;->l()Ljava/util/concurrent/CancellationException;

    move-result-object p0

    throw p0

    :cond_2
    :goto_1
    if-ne p0, v0, :cond_3

    new-instance v0, Lkotlinx/coroutines/internal/p;

    invoke-direct {v0, p2, p0}, Lkotlinx/coroutines/internal/p;-><init>(Le/e;Le/j;)V

    invoke-static {v0, v0, p1}, Lkotlinx/coroutines/scheduling/h;->k(Lkotlinx/coroutines/internal/p;Lkotlinx/coroutines/internal/p;Ll/p;)Ljava/lang/Object;

    move-result-object p0

    goto :goto_3

    :cond_3
    sget-object v1, Le/f;->b:Le/f;

    invoke-interface {p0, v1}, Le/j;->get(Le/i;)Le/h;

    move-result-object v2

    invoke-interface {v0, v1}, Le/j;->get(Le/i;)Le/h;

    move-result-object v0

    invoke-static {v2, v0}, Ls/y;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_6

    new-instance v0, Ls/k1;

    sget-object v2, Ls/l1;->b:Ls/l1;

    invoke-interface {p0, v2}, Le/j;->get(Le/i;)Le/h;

    move-result-object v3

    if-nez v3, :cond_4

    invoke-interface {p0, v2}, Le/j;->plus(Le/j;)Le/j;

    move-result-object v2

    goto :goto_2

    :cond_4
    move-object v2, p0

    :goto_2
    invoke-direct {v0, p2, v2}, Lkotlinx/coroutines/internal/p;-><init>(Le/e;Le/j;)V

    new-instance v2, Ljava/lang/ThreadLocal;

    invoke-direct {v2}, Ljava/lang/ThreadLocal;-><init>()V

    iput-object v2, v0, Ls/k1;->e:Ljava/lang/ThreadLocal;

    invoke-interface {p2}, Le/e;->getContext()Le/j;

    move-result-object p2

    invoke-interface {p2, v1}, Le/j;->get(Le/i;)Le/h;

    move-result-object p2

    instance-of p2, p2, Ls/s;

    const/4 v1, 0x0

    if-nez p2, :cond_5

    invoke-static {p0, v1}, Lkotlinx/coroutines/internal/b;->e(Le/j;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p2

    invoke-static {p0, p2}, Lkotlinx/coroutines/internal/b;->c(Le/j;Ljava/lang/Object;)V

    new-instance v2, Lc/d;

    invoke-direct {v2, p0, p2}, Lc/d;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    iget-object p2, v0, Ls/k1;->e:Ljava/lang/ThreadLocal;

    invoke-virtual {p2, v2}, Ljava/lang/ThreadLocal;->set(Ljava/lang/Object;)V

    :cond_5
    invoke-static {p0, v1}, Lkotlinx/coroutines/internal/b;->e(Le/j;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p2

    :try_start_0
    invoke-static {v0, v0, p1}, Lkotlinx/coroutines/scheduling/h;->k(Lkotlinx/coroutines/internal/p;Lkotlinx/coroutines/internal/p;Ll/p;)Ljava/lang/Object;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    invoke-static {p0, p2}, Lkotlinx/coroutines/internal/b;->c(Le/j;Ljava/lang/Object;)V

    move-object p0, p1

    goto :goto_3

    :catchall_0
    move-exception p1

    invoke-static {p0, p2}, Lkotlinx/coroutines/internal/b;->c(Le/j;Ljava/lang/Object;)V

    throw p1

    :cond_6
    new-instance v0, Ls/d0;

    invoke-direct {v0, p2, p0}, Ls/d0;-><init>(Le/e;Le/j;)V

    invoke-static {p1, v0, v0}, Lkotlinx/coroutines/scheduling/h;->j(Ll/p;Ls/a;Ls/a;)V

    invoke-virtual {v0}, Ls/d0;->E()Ljava/lang/Object;

    move-result-object p0

    :goto_3
    return-object p0
.end method
