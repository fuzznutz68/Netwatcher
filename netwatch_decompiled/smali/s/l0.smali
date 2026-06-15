.class public abstract Ls/l0;
.super Ls/s;
.source "SourceFile"

# interfaces
.implements Ljava/io/Closeable;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    sget-object v0, Ls/s;->Key:Ls/r;

    instance-of v1, v0, Le/b;

    if-eqz v1, :cond_0

    iget-object v0, v0, Le/b;->c:Le/i;

    :cond_0
    return-void
.end method
