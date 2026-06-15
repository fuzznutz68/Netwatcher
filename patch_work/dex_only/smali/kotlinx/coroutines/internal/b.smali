.class public abstract Lkotlinx/coroutines/internal/b;
.super Ljava/lang/Object;
.source "SourceFile"


# static fields
.field public static final a:Lkotlinx/coroutines/internal/q;

.field public static final b:Lkotlinx/coroutines/internal/q;

.field public static final c:Lkotlinx/coroutines/internal/q;

.field public static final d:Lkotlinx/coroutines/internal/q;

.field public static final e:Lkotlinx/coroutines/internal/q;


# direct methods
.method static synthetic constructor <clinit>()V
    .locals 2

    new-instance v0, Lkotlinx/coroutines/internal/q;

    const-string v1, "NO_DECISION"

    invoke-direct {v0, v1}, Lkotlinx/coroutines/internal/q;-><init>(Ljava/lang/String;)V

    sput-object v0, Lkotlinx/coroutines/internal/b;->a:Lkotlinx/coroutines/internal/q;

    new-instance v0, Lkotlinx/coroutines/internal/q;

    const-string v1, "UNDEFINED"

    invoke-direct {v0, v1}, Lkotlinx/coroutines/internal/q;-><init>(Ljava/lang/String;)V

    sput-object v0, Lkotlinx/coroutines/internal/b;->b:Lkotlinx/coroutines/internal/q;

    new-instance v0, Lkotlinx/coroutines/internal/q;

    const-string v1, "REUSABLE_CLAIMED"

    invoke-direct {v0, v1}, Lkotlinx/coroutines/internal/q;-><init>(Ljava/lang/String;)V

    sput-object v0, Lkotlinx/coroutines/internal/b;->c:Lkotlinx/coroutines/internal/q;

    new-instance v0, Lkotlinx/coroutines/internal/q;

    const-string v1, "CONDITION_FALSE"

    invoke-direct {v0, v1}, Lkotlinx/coroutines/internal/q;-><init>(Ljava/lang/String;)V

    sput-object v0, Lkotlinx/coroutines/internal/b;->d:Lkotlinx/coroutines/internal/q;

    new-instance v0, Lkotlinx/coroutines/internal/q;

    const-string v1, "NO_THREAD_ELEMENTS"

    invoke-direct {v0, v1}, Lkotlinx/coroutines/internal/q;-><init>(Ljava/lang/String;)V

    sput-object v0, Lkotlinx/coroutines/internal/b;->e:Lkotlinx/coroutines/internal/q;

    return-void
.end method

.method public static final c(Le/j;Ljava/lang/Object;)V
    .locals 2

    sget-object v0, Lkotlinx/coroutines/internal/b;->e:Lkotlinx/coroutines/internal/q;

    if-ne p1, v0, :cond_0

    return-void

    :cond_0
    instance-of v0, p1, Lkotlinx/coroutines/internal/t;

    const/4 v1, 0x0

    if-eqz v0, :cond_2

    check-cast p1, Lkotlinx/coroutines/internal/t;

    iget-object p0, p1, Lkotlinx/coroutines/internal/t;->b:[Ls/h1;

    array-length v0, p0

    add-int/lit8 v0, v0, -0x1

    if-gez v0, :cond_1

    return-void

    :cond_1
    aget-object p0, p0, v0

    invoke-static {v1}, Ls/y;->d(Ljava/lang/Object;)V

    iget-object p0, p1, Lkotlinx/coroutines/internal/t;->a:[Ljava/lang/Object;

    aget-object p0, p0, v0

    throw v1

    :cond_2
    sget-object p1, Lkotlinx/coroutines/internal/s;->d:Lkotlinx/coroutines/internal/s;

    invoke-interface {p0, v1, p1}, Le/j;->fold(Ljava/lang/Object;Ll/p;)Ljava/lang/Object;

    move-result-object p0

    if-eqz p0, :cond_3

    invoke-static {p0}, Landroidx/activity/result/a;->l(Ljava/lang/Object;)V

    throw v1

    :cond_3
    new-instance p0, Ljava/lang/NullPointerException;

    const-string p1, "null cannot be cast to non-null type kotlinx.coroutines.ThreadContextElement<kotlin.Any?>"

    invoke-direct {p0, p1}, Ljava/lang/NullPointerException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static final d(Le/e;Ljava/lang/Object;Ll/l;)V
    .locals 8

    instance-of v0, p0, Lkotlinx/coroutines/internal/d;

    if-eqz v0, :cond_a

    check-cast p0, Lkotlinx/coroutines/internal/d;

    invoke-static {p1}, Lc/f;->a(Ljava/lang/Object;)Ljava/lang/Throwable;

    move-result-object v0

    if-nez v0, :cond_1

    if-eqz p2, :cond_0

    new-instance v0, Ls/n;

    invoke-direct {v0, p1, p2}, Ls/n;-><init>(Ljava/lang/Object;Ll/l;)V

    goto :goto_0

    :cond_0
    move-object v0, p1

    goto :goto_0

    :cond_1
    new-instance p2, Ls/m;

    const/4 v1, 0x0

    invoke-direct {p2, v1, v0}, Ls/m;-><init>(ZLjava/lang/Throwable;)V

    move-object v0, p2

    :goto_0
    iget-object p2, p0, Lkotlinx/coroutines/internal/d;->f:Le/e;

    invoke-interface {p2}, Le/e;->getContext()Le/j;

    move-result-object v1

    iget-object v2, p0, Lkotlinx/coroutines/internal/d;->e:Ls/s;

    invoke-virtual {v2, v1}, Ls/s;->isDispatchNeeded(Le/j;)Z

    move-result v1

    const/4 v3, 0x1

    if-eqz v1, :cond_2

    iput-object v0, p0, Lkotlinx/coroutines/internal/d;->g:Ljava/lang/Object;

    iput v3, p0, Ls/e0;->d:I

    invoke-interface {p2}, Le/e;->getContext()Le/j;

    move-result-object p1

    invoke-virtual {v2, p1, p0}, Ls/s;->dispatch(Le/j;Ljava/lang/Runnable;)V

    goto/16 :goto_5

    :cond_2
    invoke-static {}, Ls/i1;->a()Ls/k0;

    move-result-object v1

    iget-wide v4, v1, Ls/k0;->b:J

    const-wide v6, 0x100000000L

    cmp-long v2, v4, v6

    if-ltz v2, :cond_3

    iput-object v0, p0, Lkotlinx/coroutines/internal/d;->g:Ljava/lang/Object;

    iput v3, p0, Ls/e0;->d:I

    invoke-virtual {v1, p0}, Ls/k0;->c(Ls/e0;)V

    goto/16 :goto_5

    :cond_3
    invoke-virtual {v1, v3}, Ls/k0;->e(Z)V

    const/4 v2, 0x0

    :try_start_0
    invoke-interface {p2}, Le/e;->getContext()Le/j;

    move-result-object v3

    sget-object v4, Ls/t;->c:Ls/t;

    invoke-interface {v3, v4}, Le/j;->get(Le/i;)Le/h;

    move-result-object v3

    check-cast v3, Ls/r0;

    if-eqz v3, :cond_4

    invoke-interface {v3}, Ls/r0;->a()Z

    move-result v4

    if-nez v4, :cond_4

    check-cast v3, Ls/y0;

    invoke-virtual {v3}, Ls/y0;->l()Ljava/util/concurrent/CancellationException;

    move-result-object p1

    invoke-virtual {p0, v0, p1}, Lkotlinx/coroutines/internal/d;->a(Ljava/lang/Object;Ljava/util/concurrent/CancellationException;)V

    new-instance p2, Lc/e;

    invoke-direct {p2, p1}, Lc/e;-><init>(Ljava/lang/Throwable;)V

    invoke-virtual {p0, p2}, Lkotlinx/coroutines/internal/d;->resumeWith(Ljava/lang/Object;)V

    goto :goto_2

    :catchall_0
    move-exception p1

    goto :goto_4

    :cond_4
    iget-object v0, p0, Lkotlinx/coroutines/internal/d;->h:Ljava/lang/Object;

    invoke-interface {p2}, Le/e;->getContext()Le/j;

    move-result-object v3

    invoke-static {v3, v0}, Lkotlinx/coroutines/internal/b;->e(Le/j;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    sget-object v4, Lkotlinx/coroutines/internal/b;->e:Lkotlinx/coroutines/internal/q;

    if-eq v0, v4, :cond_5

    invoke-static {p2, v3, v0}, Lkotlinx/coroutines/scheduling/h;->n(Le/e;Le/j;Ljava/lang/Object;)Ls/k1;

    move-result-object v4
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_1

    :cond_5
    move-object v4, v2

    :goto_1
    :try_start_1
    invoke-interface {p2, p1}, Le/e;->resumeWith(Ljava/lang/Object;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    if-eqz v4, :cond_6

    :try_start_2
    invoke-virtual {v4}, Ls/k1;->E()Z

    move-result p1

    if-eqz p1, :cond_7

    :cond_6
    invoke-static {v3, v0}, Lkotlinx/coroutines/internal/b;->c(Le/j;Ljava/lang/Object;)V

    :cond_7
    :goto_2
    invoke-virtual {v1}, Ls/k0;->f()Z

    move-result p1
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    if-nez p1, :cond_7

    :goto_3
    invoke-virtual {v1}, Ls/k0;->b()V

    goto :goto_5

    :catchall_1
    move-exception p1

    if-eqz v4, :cond_8

    :try_start_3
    invoke-virtual {v4}, Ls/k1;->E()Z

    move-result p2

    if-eqz p2, :cond_9

    :cond_8
    invoke-static {v3, v0}, Lkotlinx/coroutines/internal/b;->c(Le/j;Ljava/lang/Object;)V

    :cond_9
    throw p1
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    :goto_4
    :try_start_4
    invoke-virtual {p0, p1, v2}, Ls/e0;->e(Ljava/lang/Throwable;Ljava/lang/Throwable;)V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_2

    goto :goto_3

    :catchall_2
    move-exception p0

    invoke-virtual {v1}, Ls/k0;->b()V

    throw p0

    :cond_a
    invoke-interface {p0, p1}, Le/e;->resumeWith(Ljava/lang/Object;)V

    :goto_5
    return-void
.end method

.method public static final e(Le/j;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 1

    const/4 v0, 0x0

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    if-nez p1, :cond_0

    sget-object p1, Lkotlinx/coroutines/internal/s;->c:Lkotlinx/coroutines/internal/s;

    invoke-interface {p0, v0, p1}, Le/j;->fold(Ljava/lang/Object;Ll/p;)Ljava/lang/Object;

    move-result-object p1

    invoke-static {p1}, Ls/y;->d(Ljava/lang/Object;)V

    :cond_0
    if-ne p1, v0, :cond_1

    sget-object p0, Lkotlinx/coroutines/internal/b;->e:Lkotlinx/coroutines/internal/q;

    goto :goto_0

    :cond_1
    instance-of v0, p1, Ljava/lang/Integer;

    if-eqz v0, :cond_2

    new-instance v0, Lkotlinx/coroutines/internal/t;

    check-cast p1, Ljava/lang/Number;

    invoke-virtual {p1}, Ljava/lang/Number;->intValue()I

    move-result p1

    invoke-direct {v0, p0, p1}, Lkotlinx/coroutines/internal/t;-><init>(Le/j;I)V

    sget-object p1, Lkotlinx/coroutines/internal/s;->e:Lkotlinx/coroutines/internal/s;

    invoke-interface {p0, v0, p1}, Le/j;->fold(Ljava/lang/Object;Ll/p;)Ljava/lang/Object;

    move-result-object p0

    :goto_0
    return-object p0

    :cond_2
    invoke-static {p1}, Landroidx/activity/result/a;->l(Ljava/lang/Object;)V

    const/4 p0, 0x0

    throw p0
.end method


# virtual methods
.method public abstract a()Z
.end method

.method public abstract b()V
.end method
