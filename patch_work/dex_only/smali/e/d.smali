.class public final Le/d;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Le/j;
.implements Ljava/io/Serializable;


# instance fields
.field public final b:Le/j;

.field public final c:Le/h;


# direct methods
.method public constructor <init>(Le/h;Le/j;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p2, p0, Le/d;->b:Le/j;

    iput-object p1, p0, Le/d;->c:Le/h;

    return-void
.end method


# virtual methods
.method public final equals(Ljava/lang/Object;)Z
    .locals 5

    if-eq p0, p1, :cond_7

    instance-of v0, p1, Le/d;

    if-eqz v0, :cond_6

    check-cast p1, Le/d;

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 v0, 0x2

    move-object v1, p1

    move v2, v0

    :goto_0
    iget-object v1, v1, Le/d;->b:Le/j;

    instance-of v3, v1, Le/d;

    const/4 v4, 0x0

    if-eqz v3, :cond_0

    check-cast v1, Le/d;

    goto :goto_1

    :cond_0
    move-object v1, v4

    :goto_1
    if-nez v1, :cond_5

    move-object v1, p0

    :goto_2
    iget-object v1, v1, Le/d;->b:Le/j;

    instance-of v3, v1, Le/d;

    if-eqz v3, :cond_1

    check-cast v1, Le/d;

    goto :goto_3

    :cond_1
    move-object v1, v4

    :goto_3
    if-nez v1, :cond_4

    if-ne v2, v0, :cond_6

    :goto_4
    iget-object v0, p0, Le/d;->c:Le/h;

    invoke-interface {v0}, Le/h;->getKey()Le/i;

    move-result-object v1

    invoke-virtual {p1, v1}, Le/d;->get(Le/i;)Le/h;

    move-result-object v1

    invoke-static {v1, v0}, Ls/y;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_2

    goto :goto_5

    :cond_2
    iget-object p0, p0, Le/d;->b:Le/j;

    instance-of v0, p0, Le/d;

    if-eqz v0, :cond_3

    check-cast p0, Le/d;

    goto :goto_4

    :cond_3
    const-string v0, "null cannot be cast to non-null type kotlin.coroutines.CoroutineContext.Element"

    invoke-static {p0, v0}, Ls/y;->e(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p0, Le/h;

    invoke-interface {p0}, Le/h;->getKey()Le/i;

    move-result-object v0

    invoke-virtual {p1, v0}, Le/d;->get(Le/i;)Le/h;

    move-result-object p1

    invoke-static {p1, p0}, Ls/y;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_6

    goto :goto_6

    :cond_4
    add-int/lit8 v0, v0, 0x1

    goto :goto_2

    :cond_5
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_6
    :goto_5
    const/4 p0, 0x0

    goto :goto_7

    :cond_7
    :goto_6
    const/4 p0, 0x1

    :goto_7
    return p0
.end method

.method public final fold(Ljava/lang/Object;Ll/p;)Ljava/lang/Object;
    .locals 1

    iget-object v0, p0, Le/d;->b:Le/j;

    invoke-interface {v0, p1, p2}, Le/j;->fold(Ljava/lang/Object;Ll/p;)Ljava/lang/Object;

    move-result-object p1

    iget-object p0, p0, Le/d;->c:Le/h;

    invoke-interface {p2, p1, p0}, Ll/p;->invoke(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method public final get(Le/i;)Le/h;
    .locals 1

    :goto_0
    iget-object v0, p0, Le/d;->c:Le/h;

    invoke-interface {v0, p1}, Le/j;->get(Le/i;)Le/h;

    move-result-object v0

    if-eqz v0, :cond_0

    return-object v0

    :cond_0
    iget-object p0, p0, Le/d;->b:Le/j;

    instance-of v0, p0, Le/d;

    if-eqz v0, :cond_1

    check-cast p0, Le/d;

    goto :goto_0

    :cond_1
    invoke-interface {p0, p1}, Le/j;->get(Le/i;)Le/h;

    move-result-object p0

    return-object p0
.end method

.method public final hashCode()I
    .locals 1

    iget-object v0, p0, Le/d;->b:Le/j;

    invoke-virtual {v0}, Ljava/lang/Object;->hashCode()I

    move-result v0

    iget-object p0, p0, Le/d;->c:Le/h;

    invoke-virtual {p0}, Ljava/lang/Object;->hashCode()I

    move-result p0

    add-int/2addr p0, v0

    return p0
.end method

.method public final minusKey(Le/i;)Le/j;
    .locals 3

    iget-object v0, p0, Le/d;->c:Le/h;

    invoke-interface {v0, p1}, Le/j;->get(Le/i;)Le/h;

    move-result-object v1

    iget-object v2, p0, Le/d;->b:Le/j;

    if-eqz v1, :cond_0

    return-object v2

    :cond_0
    invoke-interface {v2, p1}, Le/j;->minusKey(Le/i;)Le/j;

    move-result-object p1

    if-ne p1, v2, :cond_1

    goto :goto_0

    :cond_1
    sget-object p0, Le/k;->b:Le/k;

    if-ne p1, p0, :cond_2

    move-object p0, v0

    goto :goto_0

    :cond_2
    new-instance p0, Le/d;

    invoke-direct {p0, v0, p1}, Le/d;-><init>(Le/h;Le/j;)V

    :goto_0
    return-object p0
.end method

.method public final plus(Le/j;)Le/j;
    .locals 0

    invoke-static {p0, p1}, Ls/y;->l(Le/j;Le/j;)Le/j;

    move-result-object p0

    return-object p0
.end method

.method public final toString()Ljava/lang/String;
    .locals 3

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "["

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v1, Le/c;->c:Le/c;

    const-string v2, ""

    invoke-virtual {p0, v2, v1}, Le/d;->fold(Ljava/lang/Object;Ll/p;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 p0, 0x5d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
