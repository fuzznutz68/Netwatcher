.class public abstract Lm/a;
.super Lm/e;
.source "SourceFile"


# virtual methods
.method public final a()I
    .locals 0

    invoke-virtual {p0}, Lm/a;->c()Ljava/util/Random;

    move-result-object p0

    invoke-virtual {p0}, Ljava/util/Random;->nextInt()I

    move-result p0

    return p0
.end method

.method public final b()I
    .locals 1

    const/high16 v0, 0x7fff0000

    invoke-virtual {p0}, Lm/a;->c()Ljava/util/Random;

    move-result-object p0

    invoke-virtual {p0, v0}, Ljava/util/Random;->nextInt(I)I

    move-result p0

    return p0
.end method

.method public abstract c()Ljava/util/Random;
.end method
