.class public abstract Ls/a;
.super Ls/y0;
.source "SourceFile"

# interfaces
.implements Le/e;
.implements Ls/w;


# instance fields
.field public final c:Le/j;


# direct methods
.method public constructor <init>(Le/j;Z)V
    .locals 0

    invoke-direct {p0, p2}, Ls/y0;-><init>(Z)V

    sget-object p2, Ls/t;->c:Ls/t;

    invoke-interface {p1, p2}, Le/j;->get(Le/i;)Le/h;

    move-result-object p2

    check-cast p2, Ls/r0;

    invoke-virtual {p0, p2}, Ls/y0;->t(Ls/r0;)V

    invoke-interface {p1, p0}, Le/j;->plus(Le/j;)Le/j;

    move-result-object p1

    iput-object p1, p0, Ls/a;->c:Le/j;

    return-void
.end method


# virtual methods
.method public final a()Z
    .locals 0

    invoke-super {p0}, Ls/y0;->a()Z

    move-result p0

    return p0
.end method

.method public final g()Ljava/lang/String;
    .locals 1

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object p0

    const-string v0, " was cancelled"

    invoke-virtual {p0, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public final getContext()Le/j;
    .locals 0

    iget-object p0, p0, Ls/a;->c:Le/j;

    return-object p0
.end method

.method public final getCoroutineContext()Le/j;
    .locals 0

    iget-object p0, p0, Ls/a;->c:Le/j;

    return-object p0
.end method

.method public final resumeWith(Ljava/lang/Object;)V
    .locals 2

    invoke-static {p1}, Lc/f;->a(Ljava/lang/Object;)Ljava/lang/Throwable;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    new-instance p1, Ls/m;

    const/4 v1, 0x0

    invoke-direct {p1, v1, v0}, Ls/m;-><init>(ZLjava/lang/Throwable;)V

    :goto_0
    invoke-virtual {p0, p1}, Ls/y0;->v(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    sget-object v0, Ls/y;->c:Lkotlinx/coroutines/internal/q;

    if-ne p1, v0, :cond_1

    return-void

    :cond_1
    invoke-virtual {p0, p1}, Ls/a;->d(Ljava/lang/Object;)V

    return-void
.end method

.method public final s(Lc/b;)V
    .locals 0

    iget-object p0, p0, Ls/a;->c:Le/j;

    invoke-static {p0, p1}, Lkotlinx/coroutines/scheduling/h;->d(Le/j;Ljava/lang/Throwable;)V

    return-void
.end method

.method public final w()Ljava/lang/String;
    .locals 0

    invoke-super {p0}, Ls/y0;->w()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public final z(Ljava/lang/Object;)V
    .locals 0

    instance-of p0, p1, Ls/m;

    if-eqz p0, :cond_0

    check-cast p1, Ls/m;

    iget-object p0, p1, Ls/m;->a:Ljava/lang/Throwable;

    :cond_0
    return-void
.end method
