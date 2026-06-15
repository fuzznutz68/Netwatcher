.class public final Ls/l1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Le/h;
.implements Le/i;


# static fields
.field public static final b:Ls/l1;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    new-instance v0, Ls/l1;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Ls/l1;->b:Ls/l1;

    return-void
.end method


# virtual methods
.method public final fold(Ljava/lang/Object;Ll/p;)Ljava/lang/Object;
    .locals 0

    invoke-interface {p2, p1, p0}, Ll/p;->invoke(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method public final get(Le/i;)Le/h;
    .locals 0

    invoke-static {p0, p1}, Ls/y;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method public final getKey()Le/i;
    .locals 0

    return-object p0
.end method

.method public final minusKey(Le/i;)Le/j;
    .locals 0

    invoke-static {p0, p1}, Ls/y;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    sget-object p0, Le/k;->b:Le/k;

    :cond_0
    return-object p0
.end method

.method public final plus(Le/j;)Le/j;
    .locals 0

    invoke-static {p0, p1}, Ls/y;->l(Le/j;Le/j;)Le/j;

    move-result-object p0

    return-object p0
.end method
