.class public final Ls/o;
.super Lkotlin/jvm/internal/l;
.source "SourceFile"

# interfaces
.implements Ll/p;


# static fields
.field public static final c:Ls/o;

.field public static final d:Ls/o;


# instance fields
.field public final synthetic b:I


# direct methods
.method static synthetic constructor <clinit>()V
    .locals 2

    new-instance v0, Ls/o;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Ls/o;-><init>(I)V

    sput-object v0, Ls/o;->c:Ls/o;

    new-instance v0, Ls/o;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Ls/o;-><init>(I)V

    sput-object v0, Ls/o;->d:Ls/o;

    return-void
.end method

.method public synthetic constructor <init>(I)V
    .locals 0

    iput p1, p0, Ls/o;->b:I

    const/4 p1, 0x2

    invoke-direct {p0, p1}, Lkotlin/jvm/internal/l;-><init>(I)V

    return-void
.end method


# virtual methods
.method public final invoke(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    iget p0, p0, Ls/o;->b:I

    packed-switch p0, :pswitch_data_0

    check-cast p1, Ljava/lang/Boolean;

    invoke-virtual {p1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p0

    check-cast p2, Le/h;

    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p0

    return-object p0

    :pswitch_0
    check-cast p1, Le/j;

    check-cast p2, Le/h;

    invoke-interface {p1, p2}, Le/j;->plus(Le/j;)Le/j;

    move-result-object p0

    return-object p0

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method
