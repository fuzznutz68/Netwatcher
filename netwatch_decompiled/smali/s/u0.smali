.class public abstract Ls/u0;
.super Lkotlinx/coroutines/internal/g;
.source "SourceFile"

# interfaces
.implements Ls/g0;
.implements Ls/n0;
.implements Ll/l;


# instance fields
.field public e:Ls/y0;


# virtual methods
.method public final a()Z
    .locals 0

    const/4 p0, 0x1

    return p0
.end method

.method public final c()Ls/b1;
    .locals 0

    const/4 p0, 0x0

    return-object p0
.end method

.method public final dispose()V
    .locals 5

    invoke-virtual {p0}, Ls/u0;->k()Ls/y0;

    move-result-object v0

    :goto_0
    invoke-virtual {v0}, Ls/y0;->q()Ljava/lang/Object;

    move-result-object v1

    instance-of v2, v1, Ls/u0;

    if-eqz v2, :cond_3

    if-eq v1, p0, :cond_0

    goto :goto_1

    :cond_0
    sget-object v2, Ls/y;->h:Ls/h0;

    :cond_1
    sget-object v3, Ls/y0;->b:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    invoke-virtual {v3, v0, v1, v2}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_2

    goto :goto_1

    :cond_2
    invoke-virtual {v3, v0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    if-eq v3, v1, :cond_1

    goto :goto_0

    :cond_3
    instance-of v0, v1, Ls/n0;

    if-eqz v0, :cond_4

    check-cast v1, Ls/n0;

    invoke-interface {v1}, Ls/n0;->c()Ls/b1;

    move-result-object v0

    if-eqz v0, :cond_4

    invoke-virtual {p0}, Lkotlinx/coroutines/internal/g;->j()V

    :cond_4
    :goto_1
    return-void
.end method

.method public final k()Ls/y0;
    .locals 1

    iget-object p0, p0, Ls/u0;->e:Ls/y0;

    if-eqz p0, :cond_0

    return-object p0

    :cond_0
    new-instance p0, Lc/b;

    const-string v0, "lateinit property job has not been initialized"

    invoke-direct {p0, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    const-class v0, Ls/y;

    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, p0}, Ls/y;->n(Ljava/lang/String;Ljava/lang/RuntimeException;)V

    throw p0
.end method

.method public abstract l(Ljava/lang/Throwable;)V
.end method

.method public final toString()Ljava/lang/String;
    .locals 2

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x40

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-static {p0}, Ls/y;->h(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "[job@"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ls/u0;->k()Ls/y0;

    move-result-object p0

    invoke-static {p0}, Ls/y;->h(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 p0, 0x5d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
