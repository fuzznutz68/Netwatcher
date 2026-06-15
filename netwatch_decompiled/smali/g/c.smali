.class public abstract Lg/c;
.super Lg/a;
.source "SourceFile"


# instance fields
.field private final _context:Le/j;

.field private transient intercepted:Le/e;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Le/e;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>(Le/e;)V
    .locals 1

    if-eqz p1, :cond_0

    .line 2
    invoke-interface {p1}, Le/e;->getContext()Le/j;

    move-result-object v0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    invoke-direct {p0, p1, v0}, Lg/c;-><init>(Le/e;Le/j;)V

    return-void
.end method

.method public constructor <init>(Le/e;Le/j;)V
    .locals 0

    .line 1
    invoke-direct {p0, p1}, Lg/a;-><init>(Le/e;)V

    iput-object p2, p0, Lg/c;->_context:Le/j;

    return-void
.end method


# virtual methods
.method public getContext()Le/j;
    .locals 0

    iget-object p0, p0, Lg/c;->_context:Le/j;

    invoke-static {p0}, Ls/y;->d(Ljava/lang/Object;)V

    return-object p0
.end method

.method public final intercepted()Le/e;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Le/e;"
        }
    .end annotation

    iget-object v0, p0, Lg/c;->intercepted:Le/e;

    if-nez v0, :cond_2

    invoke-virtual {p0}, Lg/c;->getContext()Le/j;

    move-result-object v0

    sget-object v1, Le/f;->b:Le/f;

    invoke-interface {v0, v1}, Le/j;->get(Le/i;)Le/h;

    move-result-object v0

    check-cast v0, Le/g;

    if-eqz v0, :cond_0

    invoke-interface {v0, p0}, Le/g;->interceptContinuation(Le/e;)Le/e;

    move-result-object v0

    if-nez v0, :cond_1

    :cond_0
    move-object v0, p0

    :cond_1
    iput-object v0, p0, Lg/c;->intercepted:Le/e;

    :cond_2
    return-object v0
.end method

.method public releaseIntercepted()V
    .locals 3

    iget-object v0, p0, Lg/c;->intercepted:Le/e;

    if-eqz v0, :cond_0

    if-eq v0, p0, :cond_0

    invoke-virtual {p0}, Lg/c;->getContext()Le/j;

    move-result-object v1

    sget-object v2, Le/f;->b:Le/f;

    invoke-interface {v1, v2}, Le/j;->get(Le/i;)Le/h;

    move-result-object v1

    invoke-static {v1}, Ls/y;->d(Ljava/lang/Object;)V

    check-cast v1, Le/g;

    invoke-interface {v1, v0}, Le/g;->releaseInterceptedContinuation(Le/e;)V

    :cond_0
    sget-object v0, Lg/b;->b:Lg/b;

    iput-object v0, p0, Lg/c;->intercepted:Le/e;

    return-void
.end method
