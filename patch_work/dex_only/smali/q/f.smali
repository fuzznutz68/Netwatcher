.class public final Lq/f;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Lq/g;


# instance fields
.field public final synthetic a:I

.field public final b:Ll/l;

.field public final c:Ljava/lang/Object;


# direct methods
.method public constructor <init>(Lq/g;Ll/l;)V
    .locals 1

    .line 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x1

    iput v0, p0, Lq/f;->a:I

    iput-object p1, p0, Lq/f;->c:Ljava/lang/Object;

    iput-object p2, p0, Lq/f;->b:Ll/l;

    return-void
.end method

.method public constructor <init>(Lq/l;Ll/l;)V
    .locals 1

    .line 2
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    iput v0, p0, Lq/f;->a:I

    iput-object p1, p0, Lq/f;->c:Ljava/lang/Object;

    iput-object p2, p0, Lq/f;->b:Ll/l;

    return-void
.end method


# virtual methods
.method public final iterator()Ljava/util/Iterator;
    .locals 1

    iget v0, p0, Lq/f;->a:I

    packed-switch v0, :pswitch_data_0

    new-instance v0, Lq/n;

    invoke-direct {v0, p0}, Lq/n;-><init>(Lq/f;)V

    return-object v0

    :pswitch_0
    new-instance v0, Lq/e;

    invoke-direct {v0, p0}, Lq/e;-><init>(Lq/f;)V

    return-object v0

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method
