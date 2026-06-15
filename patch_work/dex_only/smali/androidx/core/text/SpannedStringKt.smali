.class public final Landroidx/core/text/SpannedStringKt;
.super Ljava/lang/Object;
.source "SourceFile"


# direct methods
.method public static final synthetic getSpans(Landroid/text/Spanned;II)[Ljava/lang/Object;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(",
            "Landroid/text/Spanned;",
            "II)[TT;"
        }
    .end annotation

    invoke-static {}, Ls/y;->m()V

    const/4 p0, 0x0

    throw p0
.end method

.method public static synthetic getSpans$default(Landroid/text/Spanned;IIILjava/lang/Object;)[Ljava/lang/Object;
    .locals 0

    and-int/lit8 p1, p3, 0x2

    if-eqz p1, :cond_0

    invoke-interface {p0}, Ljava/lang/CharSequence;->length()I

    :cond_0
    invoke-static {}, Ls/y;->m()V

    const/4 p0, 0x0

    throw p0
.end method

.method public static final toSpanned(Ljava/lang/CharSequence;)Landroid/text/Spanned;
    .locals 1

    invoke-static {p0}, Landroid/text/SpannedString;->valueOf(Ljava/lang/CharSequence;)Landroid/text/SpannedString;

    move-result-object p0

    const-string v0, "valueOf(this)"

    invoke-static {p0, v0}, Ls/y;->f(Ljava/lang/Object;Ljava/lang/String;)V

    return-object p0
.end method
