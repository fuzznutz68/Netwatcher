.class public final Landroidx/core/transition/TransitionKt$doOnStart$$inlined$addListener$default$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/transition/Transition$TransitionListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Landroidx/core/transition/TransitionKt;->doOnStart(Landroid/transition/Transition;Ll/l;)Landroid/transition/Transition$TransitionListener;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = null
.end annotation


# instance fields
.field final synthetic $onStart:Ll/l;


# direct methods
.method public constructor <init>(Ll/l;)V
    .locals 0

    iput-object p1, p0, Landroidx/core/transition/TransitionKt$doOnStart$$inlined$addListener$default$1;->$onStart:Ll/l;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onTransitionCancel(Landroid/transition/Transition;)V
    .locals 0

    return-void
.end method

.method public onTransitionEnd(Landroid/transition/Transition;)V
    .locals 0

    return-void
.end method

.method public onTransitionPause(Landroid/transition/Transition;)V
    .locals 0

    return-void
.end method

.method public onTransitionResume(Landroid/transition/Transition;)V
    .locals 0

    return-void
.end method

.method public onTransitionStart(Landroid/transition/Transition;)V
    .locals 0

    iget-object p0, p0, Landroidx/core/transition/TransitionKt$doOnStart$$inlined$addListener$default$1;->$onStart:Ll/l;

    invoke-interface {p0, p1}, Ll/l;->invoke(Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method
