.class public final Ls/q;
.super Lkotlin/jvm/internal/l;
.source "SourceFile"

# interfaces
.implements Ll/l;


# static fields
.field public static final c:Ls/q;


# instance fields
.field public final synthetic b:I


# direct methods
.method static synthetic constructor <clinit>()V
    .locals 2

    new-instance v0, Ls/q;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Ls/q;-><init>(I)V

    sput-object v0, Ls/q;->c:Ls/q;

    return-void
.end method

.method public synthetic constructor <init>(I)V
    .locals 0

    iput p1, p0, Ls/q;->b:I

    const/4 p1, 0x1

    invoke-direct {p0, p1}, Lkotlin/jvm/internal/l;-><init>(I)V

    return-void
.end method


# virtual methods
.method public final invoke(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 1

    iget p0, p0, Ls/q;->b:I

    const/4 v0, 0x0

    packed-switch p0, :pswitch_data_0

    check-cast p1, Le/h;

    instance-of p0, p1, Ls/l0;

    if-eqz p0, :cond_0

    move-object v0, p1

    check-cast v0, Ls/l0;

    :cond_0
    return-object v0

    :pswitch_0
    check-cast p1, Le/h;

    instance-of p0, p1, Ls/s;

    if-eqz p0, :cond_1

    move-object v0, p1

    check-cast v0, Ls/s;

    :cond_1
    return-object v0

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method
