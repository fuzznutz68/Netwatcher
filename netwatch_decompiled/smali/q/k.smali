.class public final Lq/k;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Lq/g;


# instance fields
.field public final synthetic a:I

.field public final synthetic b:Ljava/lang/Object;


# direct methods
.method public synthetic constructor <init>(ILjava/lang/Object;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p1, p0, Lq/k;->a:I

    iput-object p2, p0, Lq/k;->b:Ljava/lang/Object;

    return-void
.end method


# virtual methods
.method public final iterator()Ljava/util/Iterator;
    .locals 1

    iget v0, p0, Lq/k;->a:I

    iget-object p0, p0, Lq/k;->b:Ljava/lang/Object;

    packed-switch v0, :pswitch_data_0

    check-cast p0, Ljava/util/Iterator;

    return-object p0

    :pswitch_0
    check-cast p0, Ll/p;

    new-instance v0, Lq/h;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    invoke-static {v0, v0, p0}, Ls/y;->g(Ljava/lang/Object;Le/e;Ll/p;)Le/e;

    move-result-object p0

    iput-object p0, v0, Lq/h;->e:Le/e;

    return-object v0

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method
