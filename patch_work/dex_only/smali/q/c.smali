.class public final Lq/c;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/util/Iterator;


# instance fields
.field public final b:Ljava/util/Iterator;

.field public c:I

.field public d:Ljava/lang/Object;

.field public final synthetic e:Lq/d;


# direct methods
.method public constructor <init>(Lq/d;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lq/c;->e:Lq/d;

    iget-object p1, p1, Lq/d;->a:Lq/g;

    invoke-interface {p1}, Lq/g;->iterator()Ljava/util/Iterator;

    move-result-object p1

    iput-object p1, p0, Lq/c;->b:Ljava/util/Iterator;

    const/4 p1, -0x1

    iput p1, p0, Lq/c;->c:I

    return-void
.end method


# virtual methods
.method public final a()V
    .locals 3

    :cond_0
    iget-object v0, p0, Lq/c;->b:Ljava/util/Iterator;

    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    iget-object v1, p0, Lq/c;->e:Lq/d;

    iget-object v2, v1, Lq/d;->b:Ll/l;

    invoke-interface {v2, v0}, Ll/l;->invoke(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Boolean;

    invoke-virtual {v2}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v2

    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    if-nez v2, :cond_0

    iput-object v0, p0, Lq/c;->d:Ljava/lang/Object;

    const/4 v0, 0x1

    iput v0, p0, Lq/c;->c:I

    return-void

    :cond_1
    const/4 v0, 0x0

    iput v0, p0, Lq/c;->c:I

    return-void
.end method

.method public final hasNext()Z
    .locals 2

    iget v0, p0, Lq/c;->c:I

    const/4 v1, -0x1

    if-ne v0, v1, :cond_0

    invoke-virtual {p0}, Lq/c;->a()V

    :cond_0
    iget p0, p0, Lq/c;->c:I

    const/4 v0, 0x1

    if-ne p0, v0, :cond_1

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public final next()Ljava/lang/Object;
    .locals 3

    iget v0, p0, Lq/c;->c:I

    const/4 v1, -0x1

    if-ne v0, v1, :cond_0

    invoke-virtual {p0}, Lq/c;->a()V

    :cond_0
    iget v0, p0, Lq/c;->c:I

    if-eqz v0, :cond_1

    iget-object v0, p0, Lq/c;->d:Ljava/lang/Object;

    const/4 v2, 0x0

    iput-object v2, p0, Lq/c;->d:Ljava/lang/Object;

    iput v1, p0, Lq/c;->c:I

    return-object v0

    :cond_1
    new-instance p0, Ljava/util/NoSuchElementException;

    invoke-direct {p0}, Ljava/util/NoSuchElementException;-><init>()V

    throw p0
.end method

.method public final remove()V
    .locals 1

    new-instance p0, Ljava/lang/UnsupportedOperationException;

    const-string v0, "Operation is not supported for read-only collection"

    invoke-direct {p0, v0}, Ljava/lang/UnsupportedOperationException;-><init>(Ljava/lang/String;)V

    throw p0
.end method
