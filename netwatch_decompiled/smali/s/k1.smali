.class public final Ls/k1;
.super Lkotlinx/coroutines/internal/p;
.source "SourceFile"


# instance fields
.field public e:Ljava/lang/ThreadLocal;


# virtual methods
.method public final E()Z
    .locals 1

    iget-object p0, p0, Ls/k1;->e:Ljava/lang/ThreadLocal;

    invoke-virtual {p0}, Ljava/lang/ThreadLocal;->get()Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Ljava/lang/ThreadLocal;->set(Ljava/lang/Object;)V

    const/4 p0, 0x1

    return p0
.end method

.method public final d(Ljava/lang/Object;)V
    .locals 4

    iget-object v0, p0, Ls/k1;->e:Ljava/lang/ThreadLocal;

    invoke-virtual {v0}, Ljava/lang/ThreadLocal;->get()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lc/d;

    const/4 v2, 0x0

    if-eqz v1, :cond_0

    iget-object v3, v1, Lc/d;->b:Ljava/lang/Object;

    check-cast v3, Le/j;

    iget-object v1, v1, Lc/d;->c:Ljava/lang/Object;

    invoke-static {v3, v1}, Lkotlinx/coroutines/internal/b;->c(Le/j;Ljava/lang/Object;)V

    invoke-virtual {v0, v2}, Ljava/lang/ThreadLocal;->set(Ljava/lang/Object;)V

    :cond_0
    invoke-static {p1}, Lkotlinx/coroutines/scheduling/h;->h(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    iget-object p0, p0, Lkotlinx/coroutines/internal/p;->d:Le/e;

    invoke-interface {p0}, Le/e;->getContext()Le/j;

    move-result-object v0

    invoke-static {v0, v2}, Lkotlinx/coroutines/internal/b;->e(Le/j;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    sget-object v3, Lkotlinx/coroutines/internal/b;->e:Lkotlinx/coroutines/internal/q;

    if-eq v1, v3, :cond_1

    invoke-static {p0, v0, v1}, Lkotlinx/coroutines/scheduling/h;->n(Le/e;Le/j;Ljava/lang/Object;)Ls/k1;

    move-result-object v2

    :cond_1
    :try_start_0
    invoke-interface {p0, p1}, Le/e;->resumeWith(Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v2, :cond_2

    invoke-virtual {v2}, Ls/k1;->E()Z

    move-result p0

    if-eqz p0, :cond_3

    :cond_2
    invoke-static {v0, v1}, Lkotlinx/coroutines/internal/b;->c(Le/j;Ljava/lang/Object;)V

    :cond_3
    return-void

    :catchall_0
    move-exception p0

    if-eqz v2, :cond_4

    invoke-virtual {v2}, Ls/k1;->E()Z

    move-result p1

    if-eqz p1, :cond_5

    :cond_4
    invoke-static {v0, v1}, Lkotlinx/coroutines/internal/b;->c(Le/j;Ljava/lang/Object;)V

    :cond_5
    throw p0
.end method
