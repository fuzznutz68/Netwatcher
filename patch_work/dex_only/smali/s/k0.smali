.class public abstract Ls/k0;
.super Ls/s;
.source "SourceFile"


# instance fields
.field public b:J

.field public c:Z

.field public d:Lkotlinx/coroutines/internal/a;


# virtual methods
.method public final b()V
    .locals 4

    iget-wide v0, p0, Ls/k0;->b:J

    const-wide v2, 0x100000000L

    sub-long/2addr v0, v2

    iput-wide v0, p0, Ls/k0;->b:J

    const-wide/16 v2, 0x0

    cmp-long v0, v0, v2

    if-lez v0, :cond_0

    goto :goto_0

    :cond_0
    iget-boolean v0, p0, Ls/k0;->c:Z

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Ls/k0;->g()V

    :cond_1
    :goto_0
    return-void
.end method

.method public final c(Ls/e0;)V
    .locals 11

    iget-object v0, p0, Ls/k0;->d:Lkotlinx/coroutines/internal/a;

    if-nez v0, :cond_0

    new-instance v0, Lkotlinx/coroutines/internal/a;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    const/16 v1, 0x10

    new-array v1, v1, [Ljava/lang/Object;

    iput-object v1, v0, Lkotlinx/coroutines/internal/a;->a:[Ljava/lang/Object;

    iput-object v0, p0, Ls/k0;->d:Lkotlinx/coroutines/internal/a;

    :cond_0
    iget-object v1, v0, Lkotlinx/coroutines/internal/a;->a:[Ljava/lang/Object;

    iget p0, v0, Lkotlinx/coroutines/internal/a;->c:I

    aput-object p1, v1, p0

    add-int/lit8 p0, p0, 0x1

    array-length p1, v1

    add-int/lit8 p1, p1, -0x1

    and-int/2addr p0, p1

    iput p0, v0, Lkotlinx/coroutines/internal/a;->c:I

    iget v4, v0, Lkotlinx/coroutines/internal/a;->b:I

    if-ne p0, v4, :cond_1

    array-length p0, v1

    shl-int/lit8 p1, p0, 0x1

    new-array p1, p1, [Ljava/lang/Object;

    const/4 v3, 0x0

    const/4 v5, 0x0

    const/16 v6, 0xa

    move-object v2, p1

    invoke-static/range {v1 .. v6}, Ld/d;->r([Ljava/lang/Object;[Ljava/lang/Object;IIII)V

    iget-object v5, v0, Lkotlinx/coroutines/internal/a;->a:[Ljava/lang/Object;

    array-length v1, v5

    iget v9, v0, Lkotlinx/coroutines/internal/a;->b:I

    sub-int v7, v1, v9

    const/4 v8, 0x0

    const/4 v10, 0x4

    move-object v6, p1

    invoke-static/range {v5 .. v10}, Ld/d;->r([Ljava/lang/Object;[Ljava/lang/Object;IIII)V

    iput-object p1, v0, Lkotlinx/coroutines/internal/a;->a:[Ljava/lang/Object;

    const/4 p1, 0x0

    iput p1, v0, Lkotlinx/coroutines/internal/a;->b:I

    iput p0, v0, Lkotlinx/coroutines/internal/a;->c:I

    :cond_1
    return-void
.end method

.method public abstract d()Ljava/lang/Thread;
.end method

.method public final e(Z)V
    .locals 4

    iget-wide v0, p0, Ls/k0;->b:J

    if-eqz p1, :cond_0

    const-wide v2, 0x100000000L

    goto :goto_0

    :cond_0
    const-wide/16 v2, 0x1

    :goto_0
    add-long/2addr v2, v0

    iput-wide v2, p0, Ls/k0;->b:J

    if-nez p1, :cond_1

    const/4 p1, 0x1

    iput-boolean p1, p0, Ls/k0;->c:Z

    :cond_1
    return-void
.end method

.method public final f()Z
    .locals 6

    iget-object p0, p0, Ls/k0;->d:Lkotlinx/coroutines/internal/a;

    const/4 v0, 0x0

    if-nez p0, :cond_0

    goto :goto_1

    :cond_0
    iget v1, p0, Lkotlinx/coroutines/internal/a;->b:I

    iget v2, p0, Lkotlinx/coroutines/internal/a;->c:I

    const/4 v3, 0x1

    const/4 v4, 0x0

    if-ne v1, v2, :cond_1

    goto :goto_0

    :cond_1
    iget-object v2, p0, Lkotlinx/coroutines/internal/a;->a:[Ljava/lang/Object;

    aget-object v5, v2, v1

    aput-object v4, v2, v1

    add-int/2addr v1, v3

    array-length v2, v2

    sub-int/2addr v2, v3

    and-int/2addr v1, v2

    iput v1, p0, Lkotlinx/coroutines/internal/a;->b:I

    if-eqz v5, :cond_3

    move-object v4, v5

    :goto_0
    check-cast v4, Ls/e0;

    if-nez v4, :cond_2

    goto :goto_1

    :cond_2
    invoke-virtual {v4}, Ls/e0;->run()V

    move v0, v3

    :goto_1
    return v0

    :cond_3
    new-instance p0, Ljava/lang/NullPointerException;

    const-string v0, "null cannot be cast to non-null type T of kotlinx.coroutines.internal.ArrayQueue"

    invoke-direct {p0, v0}, Ljava/lang/NullPointerException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public abstract g()V
.end method

.method public final limitedParallelism(I)Ls/s;
    .locals 0

    invoke-static {p1}, Lkotlinx/coroutines/scheduling/h;->b(I)V

    return-object p0
.end method
