.class public Lkotlinx/coroutines/internal/p;
.super Ls/a;
.source "SourceFile"

# interfaces
.implements Lg/d;


# instance fields
.field public final d:Le/e;


# direct methods
.method public constructor <init>(Le/e;Le/j;)V
    .locals 1

    const/4 v0, 0x1

    invoke-direct {p0, p2, v0}, Ls/a;-><init>(Le/j;Z)V

    iput-object p1, p0, Lkotlinx/coroutines/internal/p;->d:Le/e;

    return-void
.end method


# virtual methods
.method public c(Ljava/lang/Object;)V
    .locals 1

    iget-object p0, p0, Lkotlinx/coroutines/internal/p;->d:Le/e;

    invoke-static {p0}, Ls/y;->j(Le/e;)Le/e;

    move-result-object p0

    invoke-static {p1}, Lkotlinx/coroutines/scheduling/h;->h(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Lkotlinx/coroutines/internal/b;->d(Le/e;Ljava/lang/Object;Ll/l;)V

    return-void
.end method

.method public d(Ljava/lang/Object;)V
    .locals 0

    iget-object p0, p0, Lkotlinx/coroutines/internal/p;->d:Le/e;

    invoke-static {p1}, Lkotlinx/coroutines/scheduling/h;->h(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    invoke-interface {p0, p1}, Le/e;->resumeWith(Ljava/lang/Object;)V

    return-void
.end method

.method public final getCallerFrame()Lg/d;
    .locals 1

    iget-object p0, p0, Lkotlinx/coroutines/internal/p;->d:Le/e;

    instance-of v0, p0, Lg/d;

    if-eqz v0, :cond_0

    check-cast p0, Lg/d;

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method public final u()Z
    .locals 0

    const/4 p0, 0x1

    return p0
.end method
