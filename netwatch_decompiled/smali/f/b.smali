.class public final Lf/b;
.super Lg/h;
.source "SourceFile"


# instance fields
.field public b:I

.field public final synthetic c:Ll/p;

.field public final synthetic d:Ljava/lang/Object;


# direct methods
.method public constructor <init>(Ljava/lang/Object;Le/e;Ll/p;)V
    .locals 0

    iput-object p3, p0, Lf/b;->c:Ll/p;

    iput-object p1, p0, Lf/b;->d:Ljava/lang/Object;

    const-string p1, "null cannot be cast to non-null type kotlin.coroutines.Continuation<kotlin.Any?>"

    invoke-static {p2, p1}, Ls/y;->e(Ljava/lang/Object;Ljava/lang/String;)V

    invoke-direct {p0, p2}, Lg/h;-><init>(Le/e;)V

    return-void
.end method


# virtual methods
.method public final invokeSuspend(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 2

    iget v0, p0, Lf/b;->b:I

    const/4 v1, 0x1

    if-eqz v0, :cond_1

    if-ne v0, v1, :cond_0

    const/4 v0, 0x2

    iput v0, p0, Lf/b;->b:I

    invoke-static {p1}, Ls/y;->o(Ljava/lang/Object;)V

    goto :goto_0

    :cond_0
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "This coroutine had already completed"

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_1
    iput v1, p0, Lf/b;->b:I

    invoke-static {p1}, Ls/y;->o(Ljava/lang/Object;)V

    iget-object p1, p0, Lf/b;->c:Ll/p;

    const-string v0, "null cannot be cast to non-null type kotlin.Function2<R of kotlin.coroutines.intrinsics.IntrinsicsKt__IntrinsicsJvmKt.createCoroutineUnintercepted$lambda$1, kotlin.coroutines.Continuation<T of kotlin.coroutines.intrinsics.IntrinsicsKt__IntrinsicsJvmKt.createCoroutineUnintercepted$lambda$1>, kotlin.Any?>"

    invoke-static {p1, v0}, Ls/y;->e(Ljava/lang/Object;Ljava/lang/String;)V

    invoke-static {p1}, Ls/y;->c(Ljava/lang/Object;)V

    iget-object v0, p0, Lf/b;->d:Ljava/lang/Object;

    invoke-interface {p1, v0, p0}, Ll/p;->invoke(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    :goto_0
    return-object p1
.end method
