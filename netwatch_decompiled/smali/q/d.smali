.class public final Lq/d;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Lq/g;


# instance fields
.field public final a:Lq/g;

.field public final b:Ll/l;


# direct methods
.method public constructor <init>(Lq/f;)V
    .locals 1

    sget-object v0, Lq/m;->b:Lq/m;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lq/d;->a:Lq/g;

    iput-object v0, p0, Lq/d;->b:Ll/l;

    return-void
.end method


# virtual methods
.method public final iterator()Ljava/util/Iterator;
    .locals 1

    new-instance v0, Lq/c;

    invoke-direct {v0, p0}, Lq/c;-><init>(Lq/d;)V

    return-object v0
.end method
