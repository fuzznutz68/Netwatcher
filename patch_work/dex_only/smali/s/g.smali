.class public final Ls/g;
.super Ls/m;
.source "SourceFile"


# static fields
.field public static final synthetic c:Ljava/util/concurrent/atomic/AtomicIntegerFieldUpdater;


# instance fields
.field private volatile synthetic _resumed:I


# direct methods
.method static constructor <clinit>()V
    .locals 2

    const-class v0, Ls/g;

    const-string v1, "_resumed"

    invoke-static {v0, v1}, Ljava/util/concurrent/atomic/AtomicIntegerFieldUpdater;->newUpdater(Ljava/lang/Class;Ljava/lang/String;)Ljava/util/concurrent/atomic/AtomicIntegerFieldUpdater;

    move-result-object v0

    sput-object v0, Ls/g;->c:Ljava/util/concurrent/atomic/AtomicIntegerFieldUpdater;

    return-void
.end method

.method public constructor <init>(Le/e;Ljava/lang/Throwable;Z)V
    .locals 0

    invoke-direct {p0, p3, p2}, Ls/m;-><init>(ZLjava/lang/Throwable;)V

    const/4 p1, 0x0

    iput p1, p0, Ls/g;->_resumed:I

    return-void
.end method
