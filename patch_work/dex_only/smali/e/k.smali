.class public final Le/k;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Le/j;
.implements Ljava/io/Serializable;


# static fields
.field public static final b:Le/k;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    new-instance v0, Le/k;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Le/k;->b:Le/k;

    return-void
.end method


# virtual methods
.method public final fold(Ljava/lang/Object;Ll/p;)Ljava/lang/Object;
    .locals 0

    return-object p1
.end method

.method public final get(Le/i;)Le/h;
    .locals 0

    const/4 p0, 0x0

    return-object p0
.end method

.method public final hashCode()I
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public final minusKey(Le/i;)Le/j;
    .locals 0

    return-object p0
.end method

.method public final plus(Le/j;)Le/j;
    .locals 0

    return-object p1
.end method

.method public final toString()Ljava/lang/String;
    .locals 0

    const-string p0, "EmptyCoroutineContext"

    return-object p0
.end method
