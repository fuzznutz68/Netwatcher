.class public final Ls/z0;
.super Ls/f1;
.source "SourceFile"


# instance fields
.field public final d:Le/e;


# direct methods
.method public constructor <init>(Le/j;Ll/p;)V
    .locals 1

    const/4 v0, 0x0

    invoke-direct {p0, p1, v0}, Ls/a;-><init>(Le/j;Z)V

    invoke-static {p0, p0, p2}, Ls/y;->g(Ljava/lang/Object;Le/e;Ll/p;)Le/e;

    move-result-object p1

    iput-object p1, p0, Ls/z0;->d:Le/e;

    return-void
.end method


# virtual methods
.method public final A()V
    .locals 3

    iget-object v0, p0, Ls/z0;->d:Le/e;

    :try_start_0
    invoke-static {v0}, Ls/y;->j(Le/e;)Le/e;

    move-result-object v0

    sget-object v1, Lc/i;->a:Lc/i;

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Lkotlinx/coroutines/internal/b;->d(Le/e;Ljava/lang/Object;Ll/l;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-void

    :catchall_0
    move-exception v0

    new-instance v1, Lc/e;

    invoke-direct {v1, v0}, Lc/e;-><init>(Ljava/lang/Throwable;)V

    invoke-virtual {p0, v1}, Ls/a;->resumeWith(Ljava/lang/Object;)V

    throw v0
.end method
