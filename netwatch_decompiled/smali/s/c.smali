.class public final Ls/c;
.super Ls/j0;
.source "SourceFile"


# instance fields
.field public final f:Ljava/lang/Thread;


# direct methods
.method public constructor <init>(Ljava/lang/Thread;)V
    .locals 0

    invoke-direct {p0}, Ls/j0;-><init>()V

    iput-object p1, p0, Ls/c;->f:Ljava/lang/Thread;

    return-void
.end method


# virtual methods
.method public final d()Ljava/lang/Thread;
    .locals 0

    iget-object p0, p0, Ls/c;->f:Ljava/lang/Thread;

    return-object p0
.end method
