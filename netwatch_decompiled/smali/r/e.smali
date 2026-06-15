.class public abstract Lr/e;
.super Lr/d;
.source "SourceFile"


# direct methods
.method public static final p(Ljava/lang/CharSequence;Ljava/lang/String;IZ)I
    .locals 9

    if-nez p3, :cond_1

    instance-of v0, p0, Ljava/lang/String;

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    check-cast p0, Ljava/lang/String;

    invoke-virtual {p0, p1, p2}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result p0

    goto/16 :goto_8

    :cond_1
    :goto_0
    invoke-interface {p0}, Ljava/lang/CharSequence;->length()I

    move-result v0

    new-instance v1, Lo/d;

    const/4 v2, 0x0

    if-gez p2, :cond_2

    move p2, v2

    :cond_2
    invoke-interface {p0}, Ljava/lang/CharSequence;->length()I

    move-result v3

    if-le v0, v3, :cond_3

    move v0, v3

    :cond_3
    const/4 v3, 0x1

    invoke-direct {v1, p2, v0, v3}, Lo/b;-><init>(III)V

    instance-of v0, p0, Ljava/lang/String;

    iget v1, v1, Lo/b;->c:I

    if-eqz v0, :cond_8

    if-le p2, v1, :cond_4

    goto/16 :goto_7

    :cond_4
    :goto_1
    move-object v6, p0

    check-cast v6, Ljava/lang/String;

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v8

    const/4 v5, 0x0

    if-nez p3, :cond_5

    invoke-virtual {p1, v5, v6, p2, v8}, Ljava/lang/String;->regionMatches(ILjava/lang/String;II)Z

    move-result v0

    goto :goto_2

    :cond_5
    move-object v3, p1

    move v4, p3

    move v7, p2

    invoke-virtual/range {v3 .. v8}, Ljava/lang/String;->regionMatches(ZILjava/lang/String;II)Z

    move-result v0

    :goto_2
    if-eqz v0, :cond_7

    :cond_6
    move p0, p2

    goto :goto_8

    :cond_7
    if-eq p2, v1, :cond_f

    add-int/lit8 p2, p2, 0x1

    goto :goto_1

    :cond_8
    if-le p2, v1, :cond_9

    goto :goto_7

    :cond_9
    :goto_3
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    if-ltz p2, :cond_e

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v3

    sub-int/2addr v3, v0

    if-ltz v3, :cond_e

    invoke-interface {p0}, Ljava/lang/CharSequence;->length()I

    move-result v3

    sub-int/2addr v3, v0

    if-le p2, v3, :cond_a

    goto :goto_6

    :cond_a
    move v3, v2

    :goto_4
    if-ge v3, v0, :cond_6

    invoke-virtual {p1, v3}, Ljava/lang/String;->charAt(I)C

    move-result v4

    add-int v5, p2, v3

    invoke-interface {p0, v5}, Ljava/lang/CharSequence;->charAt(I)C

    move-result v5

    if-ne v4, v5, :cond_b

    goto :goto_5

    :cond_b
    if-nez p3, :cond_c

    goto :goto_6

    :cond_c
    invoke-static {v4}, Ljava/lang/Character;->toUpperCase(C)C

    move-result v4

    invoke-static {v5}, Ljava/lang/Character;->toUpperCase(C)C

    move-result v5

    if-eq v4, v5, :cond_d

    invoke-static {v4}, Ljava/lang/Character;->toLowerCase(C)C

    move-result v4

    invoke-static {v5}, Ljava/lang/Character;->toLowerCase(C)C

    move-result v5

    if-ne v4, v5, :cond_e

    :cond_d
    :goto_5
    add-int/lit8 v3, v3, 0x1

    goto :goto_4

    :cond_e
    :goto_6
    if-eq p2, v1, :cond_f

    add-int/lit8 p2, p2, 0x1

    goto :goto_3

    :cond_f
    :goto_7
    const/4 p0, -0x1

    :goto_8
    return p0
.end method

.method public static q(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    const/16 v1, 0x2e

    invoke-virtual {p0, v1, v0}, Ljava/lang/String;->lastIndexOf(II)I

    move-result v0

    const/4 v1, -0x1

    if-ne v0, v1, :cond_0

    goto :goto_0

    :cond_0
    add-int/lit8 v0, v0, 0x1

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    const-string v0, "this as java.lang.String\u2026ing(startIndex, endIndex)"

    invoke-static {p0, v0}, Ls/y;->f(Ljava/lang/Object;Ljava/lang/String;)V

    :goto_0
    return-object p0
.end method
