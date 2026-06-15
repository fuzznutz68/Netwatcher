.class public Ls/f1;
.super Ls/a;
.source "SourceFile"


# virtual methods
.method public final r(Ljava/lang/Throwable;)Z
    .locals 0

    iget-object p0, p0, Ls/a;->c:Le/j;

    invoke-static {p0, p1}, Lkotlinx/coroutines/scheduling/h;->d(Le/j;Ljava/lang/Throwable;)V

    const/4 p0, 0x1

    return p0
.end method
