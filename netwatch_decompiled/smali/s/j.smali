.class public final Ls/j;
.super Ls/t0;
.source "SourceFile"

# interfaces
.implements Ls/i;


# instance fields
.field public final f:Ls/k;


# direct methods
.method public constructor <init>(Ls/y0;)V
    .locals 0

    invoke-direct {p0}, Lkotlinx/coroutines/internal/g;-><init>()V

    iput-object p1, p0, Ls/j;->f:Ls/k;

    return-void
.end method


# virtual methods
.method public final b(Ljava/lang/Throwable;)Z
    .locals 0

    invoke-virtual {p0}, Ls/u0;->k()Ls/y0;

    move-result-object p0

    invoke-virtual {p0, p1}, Ls/y0;->h(Ljava/lang/Throwable;)Z

    move-result p0

    return p0
.end method

.method public final bridge synthetic invoke(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    check-cast p1, Ljava/lang/Throwable;

    invoke-virtual {p0, p1}, Ls/j;->l(Ljava/lang/Throwable;)V

    sget-object p0, Lc/i;->a:Lc/i;

    return-object p0
.end method

.method public final l(Ljava/lang/Throwable;)V
    .locals 0

    invoke-virtual {p0}, Ls/u0;->k()Ls/y0;

    move-result-object p1

    iget-object p0, p0, Ls/j;->f:Ls/k;

    check-cast p0, Ls/y0;

    invoke-virtual {p0, p1}, Ls/y0;->e(Ljava/lang/Object;)Z

    return-void
.end method
