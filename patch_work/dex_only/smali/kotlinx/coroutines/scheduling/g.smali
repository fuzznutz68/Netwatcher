.class public abstract Lkotlinx/coroutines/scheduling/g;
.super Ls/l0;
.source "SourceFile"


# instance fields
.field public final b:Lkotlinx/coroutines/scheduling/b;


# direct methods
.method public constructor <init>(IIJ)V
    .locals 7

    const-string v5, "DefaultDispatcher"

    invoke-direct {p0}, Ls/s;-><init>()V

    new-instance v6, Lkotlinx/coroutines/scheduling/b;

    move-object v0, v6

    move v1, p1

    move v2, p2

    move-wide v3, p3

    invoke-direct/range {v0 .. v5}, Lkotlinx/coroutines/scheduling/b;-><init>(IIJLjava/lang/String;)V

    iput-object v6, p0, Lkotlinx/coroutines/scheduling/g;->b:Lkotlinx/coroutines/scheduling/b;

    return-void
.end method


# virtual methods
.method public final dispatch(Le/j;Ljava/lang/Runnable;)V
    .locals 1

    iget-object p0, p0, Lkotlinx/coroutines/scheduling/g;->b:Lkotlinx/coroutines/scheduling/b;

    const/4 p1, 0x0

    const/4 v0, 0x6

    invoke-static {p0, p2, p1, v0}, Lkotlinx/coroutines/scheduling/b;->c(Lkotlinx/coroutines/scheduling/b;Ljava/lang/Runnable;ZI)V

    return-void
.end method

.method public final dispatchYield(Le/j;Ljava/lang/Runnable;)V
    .locals 1

    iget-object p0, p0, Lkotlinx/coroutines/scheduling/g;->b:Lkotlinx/coroutines/scheduling/b;

    const/4 p1, 0x1

    const/4 v0, 0x2

    invoke-static {p0, p2, p1, v0}, Lkotlinx/coroutines/scheduling/b;->c(Lkotlinx/coroutines/scheduling/b;Ljava/lang/Runnable;ZI)V

    return-void
.end method
