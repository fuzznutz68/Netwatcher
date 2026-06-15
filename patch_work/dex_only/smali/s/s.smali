.class public abstract Ls/s;
.super Le/a;
.source "SourceFile"

# interfaces
.implements Le/g;


# static fields
.field public static final Key:Ls/r;


# direct methods
.method static constructor <clinit>()V
    .locals 3

    new-instance v0, Ls/r;

    sget-object v1, Le/f;->b:Le/f;

    sget-object v2, Ls/q;->c:Ls/q;

    invoke-direct {v0, v1, v2}, Le/b;-><init>(Le/i;Ls/q;)V

    sput-object v0, Ls/s;->Key:Ls/r;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    sget-object v0, Le/f;->b:Le/f;

    invoke-direct {p0, v0}, Le/a;-><init>(Le/i;)V

    return-void
.end method


# virtual methods
.method public abstract dispatch(Le/j;Ljava/lang/Runnable;)V
.end method

.method public dispatchYield(Le/j;Ljava/lang/Runnable;)V
    .locals 0

    invoke-virtual {p0, p1, p2}, Ls/s;->dispatch(Le/j;Ljava/lang/Runnable;)V

    return-void
.end method

.method public get(Le/i;)Le/h;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<E::",
            "Le/h;",
            ">(",
            "Le/i;",
            ")TE;"
        }
    .end annotation

    instance-of v0, p1, Le/b;

    const/4 v1, 0x0

    if-eqz v0, :cond_2

    check-cast p1, Le/b;

    invoke-interface {p0}, Le/h;->getKey()Le/i;

    move-result-object v0

    if-eq v0, p1, :cond_1

    iget-object v2, p1, Le/b;->c:Le/i;

    if-ne v2, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    goto :goto_1

    :cond_1
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    :goto_0
    const/4 v0, 0x1

    :goto_1
    if-eqz v0, :cond_4

    iget-object p1, p1, Le/b;->b:Ll/l;

    invoke-interface {p1, p0}, Ll/l;->invoke(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Le/h;

    instance-of p1, p0, Le/h;

    if-eqz p1, :cond_4

    goto :goto_2

    :cond_2
    sget-object v0, Le/f;->b:Le/f;

    if-ne v0, p1, :cond_3

    goto :goto_2

    :cond_3
    move-object p0, v1

    :goto_2
    move-object v1, p0

    :cond_4
    return-object v1
.end method

.method public final interceptContinuation(Le/e;)Le/e;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(",
            "Le/e;",
            ")",
            "Le/e;"
        }
    .end annotation

    new-instance v0, Lkotlinx/coroutines/internal/d;

    invoke-direct {v0, p0, p1}, Lkotlinx/coroutines/internal/d;-><init>(Ls/s;Le/e;)V

    return-object v0
.end method

.method public isDispatchNeeded(Le/j;)Z
    .locals 0

    instance-of p0, p0, Ls/j1;

    xor-int/lit8 p0, p0, 0x1

    return p0
.end method

.method public limitedParallelism(I)Ls/s;
    .locals 1

    invoke-static {p1}, Lkotlinx/coroutines/scheduling/h;->b(I)V

    new-instance v0, Lkotlinx/coroutines/internal/e;

    invoke-direct {v0, p0, p1}, Lkotlinx/coroutines/internal/e;-><init>(Ls/s;I)V

    return-object v0
.end method

.method public minusKey(Le/i;)Le/j;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Le/i;",
            ")",
            "Le/j;"
        }
    .end annotation

    instance-of v0, p1, Le/b;

    sget-object v1, Le/k;->b:Le/k;

    if-eqz v0, :cond_2

    check-cast p1, Le/b;

    invoke-interface {p0}, Le/h;->getKey()Le/i;

    move-result-object v0

    if-eq v0, p1, :cond_1

    iget-object v2, p1, Le/b;->c:Le/i;

    if-ne v2, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    goto :goto_1

    :cond_1
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    :goto_0
    const/4 v0, 0x1

    :goto_1
    if-eqz v0, :cond_3

    iget-object p1, p1, Le/b;->b:Ll/l;

    invoke-interface {p1, p0}, Ll/l;->invoke(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Le/h;

    if-eqz p1, :cond_3

    :goto_2
    move-object p0, v1

    goto :goto_3

    :cond_2
    sget-object v0, Le/f;->b:Le/f;

    if-ne v0, p1, :cond_3

    goto :goto_2

    :cond_3
    :goto_3
    return-object p0
.end method

.method public final plus(Ls/s;)Ls/s;
    .locals 0

    return-object p1
.end method

.method public final releaseInterceptedContinuation(Le/e;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Le/e;",
            ")V"
        }
    .end annotation

    check-cast p1, Lkotlinx/coroutines/internal/d;

    invoke-virtual {p1}, Lkotlinx/coroutines/internal/d;->i()V

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x40

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-static {p0}, Ls/y;->h(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
