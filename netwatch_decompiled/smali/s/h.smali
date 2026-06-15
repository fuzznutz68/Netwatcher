.class public final Ls/h;
.super Ls/t0;
.source "SourceFile"


# instance fields
.field public final f:Ls/f;


# direct methods
.method public constructor <init>(Ls/f;)V
    .locals 0

    invoke-direct {p0}, Lkotlinx/coroutines/internal/g;-><init>()V

    iput-object p1, p0, Ls/h;->f:Ls/f;

    return-void
.end method


# virtual methods
.method public final bridge synthetic invoke(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    check-cast p1, Ljava/lang/Throwable;

    invoke-virtual {p0, p1}, Ls/h;->l(Ljava/lang/Throwable;)V

    sget-object p0, Lc/i;->a:Lc/i;

    return-object p0
.end method

.method public final l(Ljava/lang/Throwable;)V
    .locals 1

    invoke-virtual {p0}, Ls/u0;->k()Ls/y0;

    move-result-object p1

    iget-object p0, p0, Ls/h;->f:Ls/f;

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    invoke-virtual {p1}, Ls/y0;->l()Ljava/util/concurrent/CancellationException;

    move-result-object p1

    invoke-virtual {p0}, Ls/f;->o()Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    iget-object v0, p0, Ls/f;->e:Le/e;

    check-cast v0, Lkotlinx/coroutines/internal/d;

    invoke-virtual {v0, p1}, Lkotlinx/coroutines/internal/d;->h(Ljava/util/concurrent/CancellationException;)Z

    move-result v0

    if-eqz v0, :cond_1

    goto :goto_1

    :cond_1
    :goto_0
    invoke-virtual {p0, p1}, Ls/f;->i(Ljava/lang/Throwable;)V

    invoke-virtual {p0}, Ls/f;->o()Z

    move-result p1

    if-nez p1, :cond_3

    iget-object p1, p0, Ls/f;->g:Ls/g0;

    if-nez p1, :cond_2

    goto :goto_1

    :cond_2
    invoke-interface {p1}, Ls/g0;->dispose()V

    sget-object p1, Ls/c1;->b:Ls/c1;

    iput-object p1, p0, Ls/f;->g:Ls/g0;

    :cond_3
    :goto_1
    return-void
.end method
