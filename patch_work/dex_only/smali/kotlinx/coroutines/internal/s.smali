.class public final Lkotlinx/coroutines/internal/s;
.super Lkotlin/jvm/internal/l;
.source "SourceFile"

# interfaces
.implements Ll/p;


# static fields
.field public static final c:Lkotlinx/coroutines/internal/s;

.field public static final d:Lkotlinx/coroutines/internal/s;

.field public static final e:Lkotlinx/coroutines/internal/s;


# instance fields
.field public final synthetic b:I


# direct methods
.method static synthetic constructor <clinit>()V
    .locals 2

    new-instance v0, Lkotlinx/coroutines/internal/s;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Lkotlinx/coroutines/internal/s;-><init>(I)V

    sput-object v0, Lkotlinx/coroutines/internal/s;->c:Lkotlinx/coroutines/internal/s;

    new-instance v0, Lkotlinx/coroutines/internal/s;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Lkotlinx/coroutines/internal/s;-><init>(I)V

    sput-object v0, Lkotlinx/coroutines/internal/s;->d:Lkotlinx/coroutines/internal/s;

    new-instance v0, Lkotlinx/coroutines/internal/s;

    const/4 v1, 0x2

    invoke-direct {v0, v1}, Lkotlinx/coroutines/internal/s;-><init>(I)V

    sput-object v0, Lkotlinx/coroutines/internal/s;->e:Lkotlinx/coroutines/internal/s;

    return-void
.end method

.method public synthetic constructor <init>(I)V
    .locals 0

    iput p1, p0, Lkotlinx/coroutines/internal/s;->b:I

    const/4 p1, 0x2

    invoke-direct {p0, p1}, Lkotlin/jvm/internal/l;-><init>(I)V

    return-void
.end method


# virtual methods
.method public final invoke(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    iget p0, p0, Lkotlinx/coroutines/internal/s;->b:I

    packed-switch p0, :pswitch_data_0

    check-cast p1, Lkotlinx/coroutines/internal/t;

    check-cast p2, Le/h;

    return-object p1

    :pswitch_0
    invoke-static {p1}, Landroidx/activity/result/a;->l(Ljava/lang/Object;)V

    check-cast p2, Le/h;

    const/4 p0, 0x0

    return-object p0

    :pswitch_1
    check-cast p2, Le/h;

    return-object p1

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
