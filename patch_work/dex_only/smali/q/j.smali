.class public abstract Lq/j;
.super Ld/d;
.source "SourceFile"


# direct methods
.method public static v(Lq/d;)Ljava/lang/Object;
    .locals 1

    new-instance v0, Lq/c;

    invoke-direct {v0, p0}, Lq/c;-><init>(Lq/d;)V

    invoke-virtual {v0}, Lq/c;->hasNext()Z

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return-object p0

    :cond_0
    invoke-virtual {v0}, Lq/c;->next()Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method public static w(Lq/g;Ll/l;)Lq/d;
    .locals 1

    new-instance v0, Lq/f;

    invoke-direct {v0, p0, p1}, Lq/f;-><init>(Lq/g;Ll/l;)V

    new-instance p0, Lq/d;

    invoke-direct {p0, v0}, Lq/d;-><init>(Lq/f;)V

    return-object p0
.end method
