.class public abstract Ld/a;
.super Ljava/util/AbstractList;
.source "SourceFile"

# interfaces
.implements Ljava/util/List;


# virtual methods
.method public final remove(I)Ljava/lang/Object;
    .locals 8

    check-cast p0, Ld/c;

    iget v0, p0, Ld/c;->d:I

    if-ltz p1, :cond_7

    if-ge p1, v0, :cond_7

    invoke-virtual {p0}, Ld/a;->size()I

    move-result v0

    const/4 v1, 0x1

    sub-int/2addr v0, v1

    const-string v2, "ArrayDeque is empty."

    const/4 v3, 0x0

    if-ne p1, v0, :cond_1

    invoke-virtual {p0}, Ld/c;->isEmpty()Z

    move-result p1

    if-nez p1, :cond_0

    iget p1, p0, Ld/c;->b:I

    invoke-virtual {p0}, Ld/a;->size()I

    move-result v0

    sub-int/2addr v0, v1

    add-int/2addr v0, p1

    invoke-virtual {p0, v0}, Ld/c;->e(I)I

    move-result p1

    iget-object v0, p0, Ld/c;->c:[Ljava/lang/Object;

    aget-object v2, v0, p1

    aput-object v3, v0, p1

    iget p1, p0, Ld/c;->d:I

    sub-int/2addr p1, v1

    iput p1, p0, Ld/c;->d:I

    goto/16 :goto_3

    :cond_0
    new-instance p0, Ljava/util/NoSuchElementException;

    invoke-direct {p0, v2}, Ljava/util/NoSuchElementException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_1
    if-nez p1, :cond_3

    invoke-virtual {p0}, Ld/c;->isEmpty()Z

    move-result p1

    if-nez p1, :cond_2

    iget-object p1, p0, Ld/c;->c:[Ljava/lang/Object;

    iget v0, p0, Ld/c;->b:I

    aget-object v2, p1, v0

    aput-object v3, p1, v0

    invoke-virtual {p0, v0}, Ld/c;->d(I)I

    move-result p1

    iput p1, p0, Ld/c;->b:I

    iget p1, p0, Ld/c;->d:I

    sub-int/2addr p1, v1

    iput p1, p0, Ld/c;->d:I

    goto/16 :goto_3

    :cond_2
    new-instance p0, Ljava/util/NoSuchElementException;

    invoke-direct {p0, v2}, Ljava/util/NoSuchElementException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_3
    iget v0, p0, Ld/c;->b:I

    add-int/2addr v0, p1

    invoke-virtual {p0, v0}, Ld/c;->e(I)I

    move-result v0

    iget-object v2, p0, Ld/c;->c:[Ljava/lang/Object;

    aget-object v4, v2, v0

    iget v5, p0, Ld/c;->d:I

    shr-int/2addr v5, v1

    const/4 v6, 0x0

    if-ge p1, v5, :cond_5

    iget p1, p0, Ld/c;->b:I

    if-lt v0, p1, :cond_4

    add-int/lit8 v5, p1, 0x1

    invoke-static {v2, v2, v5, p1, v0}, Ld/d;->q([Ljava/lang/Object;[Ljava/lang/Object;III)V

    goto :goto_0

    :cond_4
    invoke-static {v2, v2, v1, v6, v0}, Ld/d;->q([Ljava/lang/Object;[Ljava/lang/Object;III)V

    iget-object p1, p0, Ld/c;->c:[Ljava/lang/Object;

    array-length v0, p1

    sub-int/2addr v0, v1

    aget-object v0, p1, v0

    aput-object v0, p1, v6

    iget v0, p0, Ld/c;->b:I

    add-int/lit8 v2, v0, 0x1

    array-length v5, p1

    sub-int/2addr v5, v1

    invoke-static {p1, p1, v2, v0, v5}, Ld/d;->q([Ljava/lang/Object;[Ljava/lang/Object;III)V

    :goto_0
    iget-object p1, p0, Ld/c;->c:[Ljava/lang/Object;

    iget v0, p0, Ld/c;->b:I

    aput-object v3, p1, v0

    invoke-virtual {p0, v0}, Ld/c;->d(I)I

    move-result p1

    iput p1, p0, Ld/c;->b:I

    goto :goto_2

    :cond_5
    iget p1, p0, Ld/c;->b:I

    invoke-virtual {p0}, Ld/a;->size()I

    move-result v2

    sub-int/2addr v2, v1

    add-int/2addr v2, p1

    invoke-virtual {p0, v2}, Ld/c;->e(I)I

    move-result p1

    if-gt v0, p1, :cond_6

    iget-object v2, p0, Ld/c;->c:[Ljava/lang/Object;

    add-int/lit8 v5, v0, 0x1

    add-int/lit8 v6, p1, 0x1

    invoke-static {v2, v2, v0, v5, v6}, Ld/d;->q([Ljava/lang/Object;[Ljava/lang/Object;III)V

    goto :goto_1

    :cond_6
    iget-object v2, p0, Ld/c;->c:[Ljava/lang/Object;

    add-int/lit8 v5, v0, 0x1

    array-length v7, v2

    invoke-static {v2, v2, v0, v5, v7}, Ld/d;->q([Ljava/lang/Object;[Ljava/lang/Object;III)V

    iget-object v0, p0, Ld/c;->c:[Ljava/lang/Object;

    array-length v2, v0

    sub-int/2addr v2, v1

    aget-object v5, v0, v6

    aput-object v5, v0, v2

    add-int/lit8 v2, p1, 0x1

    invoke-static {v0, v0, v6, v1, v2}, Ld/d;->q([Ljava/lang/Object;[Ljava/lang/Object;III)V

    :goto_1
    iget-object v0, p0, Ld/c;->c:[Ljava/lang/Object;

    aput-object v3, v0, p1

    :goto_2
    iget p1, p0, Ld/c;->d:I

    sub-int/2addr p1, v1

    iput p1, p0, Ld/c;->d:I

    move-object v2, v4

    :goto_3
    return-object v2

    :cond_7
    new-instance p0, Ljava/lang/IndexOutOfBoundsException;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "index: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ", size: "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IndexOutOfBoundsException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public final size()I
    .locals 0

    check-cast p0, Ld/c;

    iget p0, p0, Ld/c;->d:I

    return p0
.end method
