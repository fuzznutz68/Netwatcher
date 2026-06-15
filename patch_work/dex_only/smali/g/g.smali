.class public abstract Lg/g;
.super Ljava/lang/Object;
.source "SourceFile"


# static fields
.field public static final a:Lg/f;

.field public static b:Lg/f;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    new-instance v0, Lg/f;

    const/4 v1, 0x0

    invoke-direct {v0, v1, v1, v1}, Lg/f;-><init>(Ljava/lang/reflect/Method;Ljava/lang/reflect/Method;Ljava/lang/reflect/Method;)V

    sput-object v0, Lg/g;->a:Lg/f;

    return-void
.end method
