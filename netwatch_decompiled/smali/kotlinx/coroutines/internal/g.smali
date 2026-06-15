.class public Lkotlinx/coroutines/internal/g;
.super Ljava/lang/Object;
.source "SourceFile"


# static fields
.field public static final synthetic b:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

.field public static final synthetic c:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

.field public static final synthetic d:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;


# instance fields
.field volatile synthetic _next:Ljava/lang/Object;

.field volatile synthetic _prev:Ljava/lang/Object;

.field private volatile synthetic _removedRef:Ljava/lang/Object;


# direct methods
.method static constructor <clinit>()V
    .locals 3

    const-string v0, "_next"

    const-class v1, Lkotlinx/coroutines/internal/g;

    const-class v2, Ljava/lang/Object;

    invoke-static {v1, v2, v0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->newUpdater(Ljava/lang/Class;Ljava/lang/Class;Ljava/lang/String;)Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    move-result-object v0

    sput-object v0, Lkotlinx/coroutines/internal/g;->b:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    const-string v0, "_prev"

    invoke-static {v1, v2, v0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->newUpdater(Ljava/lang/Class;Ljava/lang/Class;Ljava/lang/String;)Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    move-result-object v0

    sput-object v0, Lkotlinx/coroutines/internal/g;->c:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    const-string v0, "_removedRef"

    invoke-static {v1, v2, v0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->newUpdater(Ljava/lang/Class;Ljava/lang/Class;Ljava/lang/String;)Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    move-result-object v0

    sput-object v0, Lkotlinx/coroutines/internal/g;->d:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p0, p0, Lkotlinx/coroutines/internal/g;->_next:Ljava/lang/Object;

    iput-object p0, p0, Lkotlinx/coroutines/internal/g;->_prev:Ljava/lang/Object;

    const/4 v0, 0x0

    iput-object v0, p0, Lkotlinx/coroutines/internal/g;->_removedRef:Ljava/lang/Object;

    return-void
.end method


# virtual methods
.method public final d()Lkotlinx/coroutines/internal/g;
    .locals 8

    :goto_0
    iget-object v0, p0, Lkotlinx/coroutines/internal/g;->_prev:Ljava/lang/Object;

    check-cast v0, Lkotlinx/coroutines/internal/g;

    const/4 v1, 0x0

    move-object v2, v0

    :goto_1
    move-object v3, v1

    :goto_2
    iget-object v4, v2, Lkotlinx/coroutines/internal/g;->_next:Ljava/lang/Object;

    if-ne v4, p0, :cond_3

    if-ne v0, v2, :cond_0

    return-object v2

    :cond_0
    sget-object v5, Lkotlinx/coroutines/internal/g;->c:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    :cond_1
    invoke-virtual {v5, p0, v0, v2}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    return-object v2

    :cond_2
    invoke-virtual {v5, p0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    if-eq v1, v0, :cond_1

    goto :goto_0

    :cond_3
    invoke-virtual {p0}, Lkotlinx/coroutines/internal/g;->i()Z

    move-result v5

    if-eqz v5, :cond_4

    return-object v1

    :cond_4
    if-nez v4, :cond_5

    return-object v2

    :cond_5
    instance-of v5, v4, Lkotlinx/coroutines/internal/m;

    if-eqz v5, :cond_6

    check-cast v4, Lkotlinx/coroutines/internal/m;

    invoke-virtual {v4, v2}, Lkotlinx/coroutines/internal/m;->a(Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0

    :cond_6
    instance-of v5, v4, Lkotlinx/coroutines/internal/n;

    if-eqz v5, :cond_a

    if-eqz v3, :cond_9

    sget-object v5, Lkotlinx/coroutines/internal/g;->b:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    check-cast v4, Lkotlinx/coroutines/internal/n;

    iget-object v4, v4, Lkotlinx/coroutines/internal/n;->a:Lkotlinx/coroutines/internal/g;

    :cond_7
    invoke-virtual {v5, v3, v2, v4}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_8

    move-object v2, v3

    goto :goto_1

    :cond_8
    invoke-virtual {v5, v3}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    if-eq v6, v2, :cond_7

    goto :goto_0

    :cond_9
    iget-object v2, v2, Lkotlinx/coroutines/internal/g;->_prev:Ljava/lang/Object;

    check-cast v2, Lkotlinx/coroutines/internal/g;

    goto :goto_2

    :cond_a
    move-object v3, v4

    check-cast v3, Lkotlinx/coroutines/internal/g;

    move-object v7, v3

    move-object v3, v2

    move-object v2, v7

    goto :goto_2
.end method

.method public final e(Lkotlinx/coroutines/internal/g;)V
    .locals 3

    :goto_0
    iget-object v0, p1, Lkotlinx/coroutines/internal/g;->_prev:Ljava/lang/Object;

    check-cast v0, Lkotlinx/coroutines/internal/g;

    invoke-virtual {p0}, Lkotlinx/coroutines/internal/g;->f()Ljava/lang/Object;

    move-result-object v1

    if-eq v1, p1, :cond_0

    return-void

    :cond_0
    sget-object v1, Lkotlinx/coroutines/internal/g;->c:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    :cond_1
    invoke-virtual {v1, p1, v0, p0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_3

    invoke-virtual {p0}, Lkotlinx/coroutines/internal/g;->i()Z

    move-result p0

    if-eqz p0, :cond_2

    invoke-virtual {p1}, Lkotlinx/coroutines/internal/g;->d()Lkotlinx/coroutines/internal/g;

    :cond_2
    return-void

    :cond_3
    invoke-virtual {v1, p1}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-eq v2, v0, :cond_1

    goto :goto_0
.end method

.method public final f()Ljava/lang/Object;
    .locals 2

    :goto_0
    iget-object v0, p0, Lkotlinx/coroutines/internal/g;->_next:Ljava/lang/Object;

    instance-of v1, v0, Lkotlinx/coroutines/internal/m;

    if-nez v1, :cond_0

    return-object v0

    :cond_0
    check-cast v0, Lkotlinx/coroutines/internal/m;

    invoke-virtual {v0, p0}, Lkotlinx/coroutines/internal/m;->a(Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0
.end method

.method public final g()Lkotlinx/coroutines/internal/g;
    .locals 1

    invoke-virtual {p0}, Lkotlinx/coroutines/internal/g;->f()Ljava/lang/Object;

    move-result-object p0

    instance-of v0, p0, Lkotlinx/coroutines/internal/n;

    if-eqz v0, :cond_0

    move-object v0, p0

    check-cast v0, Lkotlinx/coroutines/internal/n;

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    if-eqz v0, :cond_1

    iget-object v0, v0, Lkotlinx/coroutines/internal/n;->a:Lkotlinx/coroutines/internal/g;

    if-nez v0, :cond_2

    :cond_1
    move-object v0, p0

    check-cast v0, Lkotlinx/coroutines/internal/g;

    :cond_2
    return-object v0
.end method

.method public final h()Lkotlinx/coroutines/internal/g;
    .locals 1

    invoke-virtual {p0}, Lkotlinx/coroutines/internal/g;->d()Lkotlinx/coroutines/internal/g;

    move-result-object v0

    if-nez v0, :cond_1

    iget-object p0, p0, Lkotlinx/coroutines/internal/g;->_prev:Ljava/lang/Object;

    check-cast p0, Lkotlinx/coroutines/internal/g;

    move-object v0, p0

    :goto_0
    invoke-virtual {v0}, Lkotlinx/coroutines/internal/g;->i()Z

    move-result p0

    if-nez p0, :cond_0

    goto :goto_1

    :cond_0
    iget-object p0, v0, Lkotlinx/coroutines/internal/g;->_prev:Ljava/lang/Object;

    move-object v0, p0

    check-cast v0, Lkotlinx/coroutines/internal/g;

    goto :goto_0

    :cond_1
    :goto_1
    return-object v0
.end method

.method public i()Z
    .locals 0

    invoke-virtual {p0}, Lkotlinx/coroutines/internal/g;->f()Ljava/lang/Object;

    move-result-object p0

    instance-of p0, p0, Lkotlinx/coroutines/internal/n;

    return p0
.end method

.method public final j()V
    .locals 5

    :goto_0
    invoke-virtual {p0}, Lkotlinx/coroutines/internal/g;->f()Ljava/lang/Object;

    move-result-object v0

    instance-of v1, v0, Lkotlinx/coroutines/internal/n;

    if-eqz v1, :cond_0

    check-cast v0, Lkotlinx/coroutines/internal/n;

    iget-object p0, v0, Lkotlinx/coroutines/internal/n;->a:Lkotlinx/coroutines/internal/g;

    goto :goto_1

    :cond_0
    if-ne v0, p0, :cond_1

    check-cast v0, Lkotlinx/coroutines/internal/g;

    goto :goto_1

    :cond_1
    move-object v1, v0

    check-cast v1, Lkotlinx/coroutines/internal/g;

    iget-object v2, v1, Lkotlinx/coroutines/internal/g;->_removedRef:Ljava/lang/Object;

    check-cast v2, Lkotlinx/coroutines/internal/n;

    if-nez v2, :cond_2

    new-instance v2, Lkotlinx/coroutines/internal/n;

    invoke-direct {v2, v1}, Lkotlinx/coroutines/internal/n;-><init>(Lkotlinx/coroutines/internal/g;)V

    sget-object v3, Lkotlinx/coroutines/internal/g;->d:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    invoke-virtual {v3, v1, v2}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->lazySet(Ljava/lang/Object;Ljava/lang/Object;)V

    :cond_2
    sget-object v3, Lkotlinx/coroutines/internal/g;->b:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    :cond_3
    invoke-virtual {v3, p0, v0, v2}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_4

    invoke-virtual {v1}, Lkotlinx/coroutines/internal/g;->d()Lkotlinx/coroutines/internal/g;

    :goto_1
    return-void

    :cond_4
    invoke-virtual {v3, p0}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    if-eq v4, v0, :cond_3

    goto :goto_0
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    new-instance v1, Lkotlinx/coroutines/internal/f;

    invoke-direct {v1, p0}, Lkotlin/jvm/internal/n;-><init>(Ljava/lang/Object;)V

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const/16 v1, 0x40

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-static {p0}, Ls/y;->h(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
