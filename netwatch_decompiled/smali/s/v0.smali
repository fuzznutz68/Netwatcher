.class public final Ls/v0;
.super Ls/u0;
.source "SourceFile"


# instance fields
.field public final f:Ls/y0;

.field public final g:Ls/w0;

.field public final h:Ls/j;

.field public final i:Ljava/lang/Object;


# direct methods
.method public constructor <init>(Ls/y0;Ls/w0;Ls/j;Ljava/lang/Object;)V
    .locals 0

    invoke-direct {p0}, Lkotlinx/coroutines/internal/g;-><init>()V

    iput-object p1, p0, Ls/v0;->f:Ls/y0;

    iput-object p2, p0, Ls/v0;->g:Ls/w0;

    iput-object p3, p0, Ls/v0;->h:Ls/j;

    iput-object p4, p0, Ls/v0;->i:Ljava/lang/Object;

    return-void
.end method


# virtual methods
.method public final bridge synthetic invoke(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    check-cast p1, Ljava/lang/Throwable;

    invoke-virtual {p0, p1}, Ls/v0;->l(Ljava/lang/Throwable;)V

    sget-object p0, Lc/i;->a:Lc/i;

    return-object p0
.end method

.method public final l(Ljava/lang/Throwable;)V
    .locals 6

    iget-object p1, p0, Ls/v0;->f:Ls/y0;

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    iget-object v0, p0, Ls/v0;->h:Ls/j;

    invoke-static {v0}, Ls/y0;->x(Lkotlinx/coroutines/internal/g;)Ls/j;

    move-result-object v0

    iget-object v1, p0, Ls/v0;->g:Ls/w0;

    iget-object p0, p0, Ls/v0;->i:Ljava/lang/Object;

    if-eqz v0, :cond_2

    :cond_0
    new-instance v2, Ls/v0;

    invoke-direct {v2, p1, v1, v0, p0}, Ls/v0;-><init>(Ls/y0;Ls/w0;Ls/j;Ljava/lang/Object;)V

    const/4 v3, 0x0

    const/4 v4, 0x1

    iget-object v5, v0, Ls/j;->f:Ls/k;

    invoke-static {v5, v3, v2, v4}, Lkotlinx/coroutines/scheduling/h;->e(Ls/r0;ZLs/u0;I)Ls/g0;

    move-result-object v2

    sget-object v3, Ls/c1;->b:Ls/c1;

    if-eq v2, v3, :cond_1

    goto :goto_0

    :cond_1
    invoke-static {v0}, Ls/y0;->x(Lkotlinx/coroutines/internal/g;)Ls/j;

    move-result-object v0

    if-nez v0, :cond_0

    :cond_2
    invoke-virtual {p1, v1, p0}, Ls/y0;->k(Ls/w0;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    invoke-virtual {p1, p0}, Ls/y0;->c(Ljava/lang/Object;)V

    :goto_0
    return-void
.end method
