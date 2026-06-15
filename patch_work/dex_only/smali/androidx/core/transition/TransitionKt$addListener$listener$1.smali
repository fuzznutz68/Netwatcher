.class public final Landroidx/core/transition/TransitionKt$addListener$listener$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/transition/Transition$TransitionListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Landroidx/core/transition/TransitionKt;->addListener(Landroid/transition/Transition;Ll/l;Ll/l;Ll/l;Ll/l;Ll/l;)Landroid/transition/Transition$TransitionListener;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = null
.end annotation


# instance fields
.field final synthetic $onCancel:Ll/l;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ll/l;"
        }
    .end annotation
.end field

.field final synthetic $onEnd:Ll/l;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ll/l;"
        }
    .end annotation
.end field

.field final synthetic $onPause:Ll/l;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ll/l;"
        }
    .end annotation
.end field

.field final synthetic $onResume:Ll/l;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ll/l;"
        }
    .end annotation
.end field

.field final synthetic $onStart:Ll/l;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ll/l;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>(Ll/l;Ll/l;Ll/l;Ll/l;Ll/l;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ll/l;",
            "Ll/l;",
            "Ll/l;",
            "Ll/l;",
            "Ll/l;",
            ")V"
        }
    .end annotation

    iput-object p1, p0, Landroidx/core/transition/TransitionKt$addListener$listener$1;->$onEnd:Ll/l;

    iput-object p2, p0, Landroidx/core/transition/TransitionKt$addListener$listener$1;->$onResume:Ll/l;

    iput-object p3, p0, Landroidx/core/transition/TransitionKt$addListener$listener$1;->$onPause:Ll/l;

    iput-object p4, p0, Landroidx/core/transition/TransitionKt$addListener$listener$1;->$onCancel:Ll/l;

    iput-object p5, p0, Landroidx/core/transition/TransitionKt$addListener$listener$1;->$onStart:Ll/l;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onTransitionCancel(Landroid/transition/Transition;)V
    .locals 0

    iget-object p0, p0, Landroidx/core/transition/TransitionKt$addListener$listener$1;->$onCancel:Ll/l;

    invoke-interface {p0, p1}, Ll/l;->invoke(Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method public onTransitionEnd(Landroid/transition/Transition;)V
    .locals 0

    iget-object p0, p0, Landroidx/core/transition/TransitionKt$addListener$listener$1;->$onEnd:Ll/l;

    invoke-interface {p0, p1}, Ll/l;->invoke(Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method public onTransitionPause(Landroid/transition/Transition;)V
    .locals 0

    iget-object p0, p0, Landroidx/core/transition/TransitionKt$addListener$listener$1;->$onPause:Ll/l;

    invoke-interface {p0, p1}, Ll/l;->invoke(Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method public onTransitionResume(Landroid/transition/Transition;)V
    .locals 0

    iget-object p0, p0, Landroidx/core/transition/TransitionKt$addListener$listener$1;->$onResume:Ll/l;

    invoke-interface {p0, p1}, Ll/l;->invoke(Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method public onTransitionStart(Landroid/transition/Transition;)V
    .locals 0

    iget-object p0, p0, Landroidx/core/transition/TransitionKt$addListener$listener$1;->$onStart:Ll/l;

    invoke-interface {p0, p1}, Ll/l;->invoke(Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method
