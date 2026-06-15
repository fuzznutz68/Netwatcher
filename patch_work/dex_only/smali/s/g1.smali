.class public final Ls/g1;
.super Ls/y0;
.source "SourceFile"


# instance fields
.field public final c:Z


# direct methods
.method public constructor <init>(Ls/r0;)V
    .locals 4

    const/4 v0, 0x1

    invoke-direct {p0, v0}, Ls/y0;-><init>(Z)V

    invoke-virtual {p0, p1}, Ls/y0;->t(Ls/r0;)V

    invoke-virtual {p0}, Ls/y0;->p()Ls/i;

    move-result-object p1

    instance-of v1, p1, Ls/j;

    const/4 v2, 0x0

    if-eqz v1, :cond_0

    check-cast p1, Ls/j;

    goto :goto_0

    :cond_0
    move-object p1, v2

    :goto_0
    const/4 v1, 0x0

    if-eqz p1, :cond_3

    invoke-virtual {p1}, Ls/u0;->k()Ls/y0;

    move-result-object p1

    :goto_1
    invoke-virtual {p1}, Ls/y0;->m()Z

    move-result v3

    if-eqz v3, :cond_1

    goto :goto_3

    :cond_1
    invoke-virtual {p1}, Ls/y0;->p()Ls/i;

    move-result-object p1

    instance-of v3, p1, Ls/j;

    if-eqz v3, :cond_2

    check-cast p1, Ls/j;

    goto :goto_2

    :cond_2
    move-object p1, v2

    :goto_2
    if-eqz p1, :cond_3

    invoke-virtual {p1}, Ls/u0;->k()Ls/y0;

    move-result-object p1

    goto :goto_1

    :cond_3
    move v0, v1

    :goto_3
    iput-boolean v0, p0, Ls/g1;->c:Z

    return-void
.end method


# virtual methods
.method public final h(Ljava/lang/Throwable;)Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public final m()Z
    .locals 0

    iget-boolean p0, p0, Ls/g1;->c:Z

    return p0
.end method

.method public final bridge synthetic n()Z
    .locals 0

    const/4 p0, 0x1

    return p0
.end method
