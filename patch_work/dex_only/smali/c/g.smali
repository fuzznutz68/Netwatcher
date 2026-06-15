.class public final Lc/g;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Lc/c;
.implements Ljava/io/Serializable;


# instance fields
.field public b:Ll/a;

.field public volatile c:Ljava/lang/Object;

.field public final d:Ljava/lang/Object;


# direct methods
.method public constructor <init>(Ll/a;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lc/g;->b:Ll/a;

    sget-object p1, Lc/h;->a:Lc/h;

    iput-object p1, p0, Lc/g;->c:Ljava/lang/Object;

    iput-object p0, p0, Lc/g;->d:Ljava/lang/Object;

    return-void
.end method


# virtual methods
.method public final getValue()Ljava/lang/Object;
    .locals 3

    iget-object v0, p0, Lc/g;->c:Ljava/lang/Object;

    sget-object v1, Lc/h;->a:Lc/h;

    if-eq v0, v1, :cond_0

    return-object v0

    :cond_0
    iget-object v0, p0, Lc/g;->d:Ljava/lang/Object;

    monitor-enter v0

    :try_start_0
    iget-object v2, p0, Lc/g;->c:Ljava/lang/Object;

    if-eq v2, v1, :cond_1

    goto :goto_0

    :cond_1
    iget-object v1, p0, Lc/g;->b:Ll/a;

    invoke-static {v1}, Ls/y;->d(Ljava/lang/Object;)V

    invoke-interface {v1}, Ll/a;->invoke()Ljava/lang/Object;

    move-result-object v2

    iput-object v2, p0, Lc/g;->c:Ljava/lang/Object;

    const/4 v1, 0x0

    iput-object v1, p0, Lc/g;->b:Ll/a;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :goto_0
    monitor-exit v0

    return-object v2

    :catchall_0
    move-exception p0

    monitor-exit v0

    throw p0
.end method

.method public final toString()Ljava/lang/String;
    .locals 2

    iget-object v0, p0, Lc/g;->c:Ljava/lang/Object;

    sget-object v1, Lc/h;->a:Lc/h;

    if-eq v0, v1, :cond_0

    invoke-virtual {p0}, Lc/g;->getValue()Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_0
    const-string p0, "Lazy value not initialized yet."

    :goto_0
    return-object p0
.end method
