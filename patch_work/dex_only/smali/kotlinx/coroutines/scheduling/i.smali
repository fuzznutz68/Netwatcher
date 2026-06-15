.class public abstract Lkotlinx/coroutines/scheduling/i;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public b:J

.field public c:Lkotlinx/coroutines/scheduling/j;


# direct methods
.method public constructor <init>(JLkotlinx/coroutines/scheduling/j;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-wide p1, p0, Lkotlinx/coroutines/scheduling/i;->b:J

    iput-object p3, p0, Lkotlinx/coroutines/scheduling/i;->c:Lkotlinx/coroutines/scheduling/j;

    return-void
.end method
