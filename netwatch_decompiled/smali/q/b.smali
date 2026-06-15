.class public final Lq/b;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Lq/g;


# static fields
.field public static final a:Lq/b;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    new-instance v0, Lq/b;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lq/b;->a:Lq/b;

    return-void
.end method


# virtual methods
.method public final iterator()Ljava/util/Iterator;
    .locals 0

    sget-object p0, Ld/h;->b:Ld/h;

    return-object p0
.end method
