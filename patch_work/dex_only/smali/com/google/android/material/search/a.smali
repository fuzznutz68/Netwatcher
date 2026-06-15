.class public final synthetic Lcom/google/android/material/search/a;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroidx/core/view/accessibility/AccessibilityManagerCompat$TouchExplorationStateChangeListener;
.implements Lcom/google/android/material/animation/AnimatableView$Listener;


# instance fields
.field public final synthetic a:Ljava/lang/Object;


# direct methods
.method public synthetic constructor <init>(Ljava/lang/Object;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/google/android/material/search/a;->a:Ljava/lang/Object;

    return-void
.end method


# virtual methods
.method public final onAnimationEnd()V
    .locals 0

    iget-object p0, p0, Lcom/google/android/material/search/a;->a:Ljava/lang/Object;

    check-cast p0, Landroid/animation/Animator;

    invoke-virtual {p0}, Landroid/animation/Animator;->start()V

    return-void
.end method

.method public final onTouchExplorationStateChanged(Z)V
    .locals 0

    iget-object p0, p0, Lcom/google/android/material/search/a;->a:Ljava/lang/Object;

    check-cast p0, Lcom/google/android/material/search/SearchBar;

    invoke-static {p0, p1}, Lcom/google/android/material/search/SearchBar;->a(Lcom/google/android/material/search/SearchBar;Z)V

    return-void
.end method
