.class public abstract Lg/h;
.super Lg/a;
.source "SourceFile"


# direct methods
.method public constructor <init>(Le/e;)V
    .locals 0

    invoke-direct {p0, p1}, Lg/a;-><init>(Le/e;)V

    if-eqz p1, :cond_1

    invoke-interface {p1}, Le/e;->getContext()Le/j;

    move-result-object p0

    sget-object p1, Le/k;->b:Le/k;

    if-ne p0, p1, :cond_0

    goto :goto_0

    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Coroutines with restricted suspension must have EmptyCoroutineContext"

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_1
    :goto_0
    return-void
.end method


# virtual methods
.method public getContext()Le/j;
    .locals 0

    sget-object p0, Le/k;->b:Le/k;

    return-object p0
.end method
