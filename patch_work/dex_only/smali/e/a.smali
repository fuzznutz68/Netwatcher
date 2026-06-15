.class public abstract Le/a;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Le/h;


# instance fields
.field private final key:Le/i;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Le/i;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>(Le/i;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Le/a;->key:Le/i;

    return-void
.end method


# virtual methods
.method public fold(Ljava/lang/Object;Ll/p;)Ljava/lang/Object;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<R:",
            "Ljava/lang/Object;",
            ">(TR;",
            "Ll/p;",
            ")TR;"
        }
    .end annotation

    invoke-interface {p2, p1, p0}, Ll/p;->invoke(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method public get(Le/i;)Le/h;
    .locals 1

    invoke-interface {p0}, Le/h;->getKey()Le/i;

    move-result-object v0

    invoke-static {v0, p1}, Ls/y;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method public getKey()Le/i;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Le/i;"
        }
    .end annotation

    iget-object p0, p0, Le/a;->key:Le/i;

    return-object p0
.end method

.method public minusKey(Le/i;)Le/j;
    .locals 1

    invoke-interface {p0}, Le/h;->getKey()Le/i;

    move-result-object v0

    invoke-static {v0, p1}, Ls/y;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    sget-object p0, Le/k;->b:Le/k;

    :cond_0
    return-object p0
.end method

.method public plus(Le/j;)Le/j;
    .locals 0

    invoke-static {p0, p1}, Ls/y;->l(Le/j;Le/j;)Le/j;

    move-result-object p0

    return-object p0
.end method
