.class final Landroidx/core/view/ViewGroupKt$descendants$1;
.super Lg/i;
.source "SourceFile"

# interfaces
.implements Ll/p;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Landroidx/core/view/ViewGroupKt;->getDescendants(Landroid/view/ViewGroup;)Lq/g;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lg/i;",
        "Ll/p;"
    }
.end annotation

.annotation runtime Lg/e;
    c = "androidx.core.view.ViewGroupKt$descendants$1"
    f = "ViewGroup.kt"
    l = {
        0x77,
        0x79
    }
    m = "invokeSuspend"
.end annotation


# instance fields
.field final synthetic $this_descendants:Landroid/view/ViewGroup;

.field I$0:I

.field I$1:I

.field private synthetic L$0:Ljava/lang/Object;

.field L$1:Ljava/lang/Object;

.field L$2:Ljava/lang/Object;

.field label:I


# direct methods
.method public constructor <init>(Landroid/view/ViewGroup;Le/e;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/view/ViewGroup;",
            "Le/e;",
            ")V"
        }
    .end annotation

    iput-object p1, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->$this_descendants:Landroid/view/ViewGroup;

    invoke-direct {p0, p2}, Lg/i;-><init>(Le/e;)V

    return-void
.end method


# virtual methods
.method public final create(Ljava/lang/Object;Le/e;)Le/e;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            "Le/e;",
            ")",
            "Le/e;"
        }
    .end annotation

    new-instance v0, Landroidx/core/view/ViewGroupKt$descendants$1;

    iget-object p0, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->$this_descendants:Landroid/view/ViewGroup;

    invoke-direct {v0, p0, p2}, Landroidx/core/view/ViewGroupKt$descendants$1;-><init>(Landroid/view/ViewGroup;Le/e;)V

    iput-object p1, v0, Landroidx/core/view/ViewGroupKt$descendants$1;->L$0:Ljava/lang/Object;

    return-object v0
.end method

.method public bridge synthetic invoke(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    .line 1
    check-cast p1, Lq/i;

    check-cast p2, Le/e;

    invoke-virtual {p0, p1, p2}, Landroidx/core/view/ViewGroupKt$descendants$1;->invoke(Lq/i;Le/e;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method public final invoke(Lq/i;Le/e;)Ljava/lang/Object;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lq/i;",
            "Le/e;",
            ")",
            "Ljava/lang/Object;"
        }
    .end annotation

    .line 2
    invoke-virtual {p0, p1, p2}, Landroidx/core/view/ViewGroupKt$descendants$1;->create(Ljava/lang/Object;Le/e;)Le/e;

    move-result-object p0

    check-cast p0, Landroidx/core/view/ViewGroupKt$descendants$1;

    sget-object p1, Lc/i;->a:Lc/i;

    invoke-virtual {p0, p1}, Landroidx/core/view/ViewGroupKt$descendants$1;->invokeSuspend(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method public final invokeSuspend(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 12

    sget-object v0, Lf/a;->b:Lf/a;

    iget v1, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->label:I

    sget-object v2, Lc/i;->a:Lc/i;

    const/4 v3, 0x2

    const/4 v4, 0x1

    if-eqz v1, :cond_2

    if-eq v1, v4, :cond_1

    if-ne v1, v3, :cond_0

    iget v1, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->I$1:I

    iget v5, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->I$0:I

    iget-object v6, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->L$1:Ljava/lang/Object;

    check-cast v6, Landroid/view/ViewGroup;

    iget-object v7, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->L$0:Ljava/lang/Object;

    check-cast v7, Lq/i;

    invoke-static {p1}, Ls/y;->o(Ljava/lang/Object;)V

    move-object v8, v0

    goto/16 :goto_4

    :cond_0
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "call to \'resume\' before \'invoke\' with coroutine"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_1
    iget v1, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->I$1:I

    iget v5, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->I$0:I

    iget-object v6, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->L$2:Ljava/lang/Object;

    check-cast v6, Landroid/view/View;

    iget-object v7, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->L$1:Ljava/lang/Object;

    check-cast v7, Landroid/view/ViewGroup;

    iget-object v8, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->L$0:Ljava/lang/Object;

    check-cast v8, Lq/i;

    invoke-static {p1}, Ls/y;->o(Ljava/lang/Object;)V

    move-object p1, v8

    move-object v8, v0

    goto :goto_1

    :cond_2
    invoke-static {p1}, Ls/y;->o(Ljava/lang/Object;)V

    iget-object p1, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->L$0:Ljava/lang/Object;

    check-cast p1, Lq/i;

    iget-object v1, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->$this_descendants:Landroid/view/ViewGroup;

    invoke-virtual {v1}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v5

    const/4 v6, 0x0

    move-object v7, v0

    :goto_0
    if-ge v6, v5, :cond_8

    invoke-virtual {v1, v6}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v8

    const-string v9, "getChildAt(index)"

    invoke-static {v8, v9}, Ls/y;->f(Ljava/lang/Object;Ljava/lang/String;)V

    iput-object p1, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->L$0:Ljava/lang/Object;

    iput-object v1, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->L$1:Ljava/lang/Object;

    iput-object v8, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->L$2:Ljava/lang/Object;

    iput v6, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->I$0:I

    iput v5, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->I$1:I

    iput v4, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->label:I

    move-object v9, p1

    check-cast v9, Lq/h;

    iput-object v8, v9, Lq/h;->c:Ljava/lang/Object;

    const/4 v10, 0x3

    iput v10, v9, Lq/h;->b:I

    iput-object p0, v9, Lq/h;->e:Le/e;

    if-ne v0, v7, :cond_3

    return-object v7

    :cond_3
    move-object v11, v7

    move-object v7, v1

    move v1, v5

    move v5, v6

    move-object v6, v8

    move-object v8, v11

    :goto_1
    instance-of v9, v6, Landroid/view/ViewGroup;

    if-eqz v9, :cond_7

    check-cast v6, Landroid/view/ViewGroup;

    invoke-static {v6}, Landroidx/core/view/ViewGroupKt;->getDescendants(Landroid/view/ViewGroup;)Lq/g;

    move-result-object v6

    iput-object p1, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->L$0:Ljava/lang/Object;

    iput-object v7, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->L$1:Ljava/lang/Object;

    const/4 v9, 0x0

    iput-object v9, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->L$2:Ljava/lang/Object;

    iput v5, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->I$0:I

    iput v1, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->I$1:I

    iput v3, p0, Landroidx/core/view/ViewGroupKt$descendants$1;->label:I

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    invoke-interface {v6}, Lq/g;->iterator()Ljava/util/Iterator;

    move-result-object v6

    move-object v9, p1

    check-cast v9, Lq/h;

    invoke-interface {v6}, Ljava/util/Iterator;->hasNext()Z

    move-result v10

    if-nez v10, :cond_4

    move-object v6, v2

    goto :goto_2

    :cond_4
    iput-object v6, v9, Lq/h;->d:Ljava/util/Iterator;

    iput v3, v9, Lq/h;->b:I

    iput-object p0, v9, Lq/h;->e:Le/e;

    move-object v6, v0

    :goto_2
    if-ne v6, v0, :cond_5

    goto :goto_3

    :cond_5
    move-object v6, v2

    :goto_3
    if-ne v6, v8, :cond_6

    return-object v8

    :cond_6
    move-object v6, v7

    move-object v7, p1

    :goto_4
    move-object p1, v7

    move-object v7, v8

    move-object v11, v6

    move v6, v1

    move-object v1, v11

    goto :goto_5

    :cond_7
    move v6, v1

    move-object v1, v7

    move-object v7, v8

    :goto_5
    add-int/2addr v5, v4

    move v11, v6

    move v6, v5

    move v5, v11

    goto :goto_0

    :cond_8
    return-object v2
.end method
