.class public final Ls/x0;
.super Lkotlinx/coroutines/internal/c;
.source "SourceFile"


# instance fields
.field public final b:Lkotlinx/coroutines/internal/g;

.field public c:Lkotlinx/coroutines/internal/g;

.field public final synthetic d:Ls/y0;

.field public final synthetic e:Ljava/lang/Object;


# direct methods
.method public constructor <init>(Lkotlinx/coroutines/internal/g;Ls/y0;Ljava/lang/Object;)V
    .locals 0

    iput-object p2, p0, Ls/x0;->d:Ls/y0;

    iput-object p3, p0, Ls/x0;->e:Ljava/lang/Object;

    invoke-direct {p0}, Lkotlinx/coroutines/internal/c;-><init>()V

    iput-object p1, p0, Ls/x0;->b:Lkotlinx/coroutines/internal/g;

    return-void
.end method


# virtual methods
.method public final b(Ljava/lang/Object;Ljava/lang/Object;)V
    .locals 4

    check-cast p1, Lkotlinx/coroutines/internal/g;

    if-nez p2, :cond_0

    const/4 p2, 0x1

    goto :goto_0

    :cond_0
    const/4 p2, 0x0

    :goto_0
    iget-object v0, p0, Ls/x0;->b:Lkotlinx/coroutines/internal/g;

    if-eqz p2, :cond_1

    move-object v1, v0

    goto :goto_1

    :cond_1
    iget-object v1, p0, Ls/x0;->c:Lkotlinx/coroutines/internal/g;

    :goto_1
    if-eqz v1, :cond_4

    sget-object v2, Lkotlinx/coroutines/internal/g;->b:Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;

    :cond_2
    invoke-virtual {v2, p1, p0, v1}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->compareAndSet(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_3

    if-eqz p2, :cond_4

    iget-object p0, p0, Ls/x0;->c:Lkotlinx/coroutines/internal/g;

    invoke-static {p0}, Ls/y;->d(Ljava/lang/Object;)V

    invoke-virtual {v0, p0}, Lkotlinx/coroutines/internal/g;->e(Lkotlinx/coroutines/internal/g;)V

    goto :goto_2

    :cond_3
    invoke-virtual {v2, p1}, Ljava/util/concurrent/atomic/AtomicReferenceFieldUpdater;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    if-eq v3, p0, :cond_2

    :cond_4
    :goto_2
    return-void
.end method

.method public final c(Ljava/lang/Object;)Lkotlinx/coroutines/internal/q;
    .locals 0

    check-cast p1, Lkotlinx/coroutines/internal/g;

    iget-object p1, p0, Ls/x0;->d:Ls/y0;

    invoke-virtual {p1}, Ls/y0;->q()Ljava/lang/Object;

    move-result-object p1

    iget-object p0, p0, Ls/x0;->e:Ljava/lang/Object;

    if-ne p1, p0, :cond_0

    const/4 p0, 0x0

    goto :goto_0

    :cond_0
    sget-object p0, Lkotlinx/coroutines/internal/b;->d:Lkotlinx/coroutines/internal/q;

    :goto_0
    return-object p0
.end method
