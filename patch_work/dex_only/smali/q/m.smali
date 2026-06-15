.class public final Lq/m;
.super Lkotlin/jvm/internal/l;
.source "SourceFile"

# interfaces
.implements Ll/l;


# static fields
.field public static final b:Lq/m;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    new-instance v0, Lq/m;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Lkotlin/jvm/internal/l;-><init>(I)V

    sput-object v0, Lq/m;->b:Lq/m;

    return-void
.end method


# virtual methods
.method public final invoke(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    if-nez p1, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p0

    return-object p0
.end method
