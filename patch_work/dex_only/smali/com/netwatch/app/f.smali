.class public final synthetic Lcom/netwatch/app/f;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/view/View$OnClickListener;


# instance fields
.field public final synthetic a:Lcom/netwatch/app/MainActivity;

.field public final synthetic b:Ljava/lang/String;

.field public final synthetic c:Landroid/widget/LinearLayout;

.field public final synthetic d:Landroid/widget/TextView;

.field public final synthetic e:Z

.field public final synthetic f:Landroid/widget/TextView;

.field public final synthetic g:Landroid/widget/TextView;

.field public final synthetic h:Landroid/widget/Button;


# direct methods
.method public synthetic constructor <init>(Lcom/netwatch/app/MainActivity;Ljava/lang/String;Landroid/widget/LinearLayout;Landroid/widget/TextView;ZLandroid/widget/TextView;Landroid/widget/TextView;Landroid/widget/Button;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/netwatch/app/f;->a:Lcom/netwatch/app/MainActivity;

    iput-object p2, p0, Lcom/netwatch/app/f;->b:Ljava/lang/String;

    iput-object p3, p0, Lcom/netwatch/app/f;->c:Landroid/widget/LinearLayout;

    iput-object p4, p0, Lcom/netwatch/app/f;->d:Landroid/widget/TextView;

    iput-boolean p5, p0, Lcom/netwatch/app/f;->e:Z

    iput-object p6, p0, Lcom/netwatch/app/f;->f:Landroid/widget/TextView;

    iput-object p7, p0, Lcom/netwatch/app/f;->g:Landroid/widget/TextView;

    iput-object p8, p0, Lcom/netwatch/app/f;->h:Landroid/widget/Button;

    return-void
.end method


# virtual methods
.method public final onClick(Landroid/view/View;)V
    .locals 9

    iget-object v0, p0, Lcom/netwatch/app/f;->a:Lcom/netwatch/app/MainActivity;

    iget-object v1, p0, Lcom/netwatch/app/f;->b:Ljava/lang/String;

    iget-object v2, p0, Lcom/netwatch/app/f;->c:Landroid/widget/LinearLayout;

    iget-object v3, p0, Lcom/netwatch/app/f;->d:Landroid/widget/TextView;

    iget-boolean v4, p0, Lcom/netwatch/app/f;->e:Z

    iget-object v5, p0, Lcom/netwatch/app/f;->f:Landroid/widget/TextView;

    iget-object v6, p0, Lcom/netwatch/app/f;->g:Landroid/widget/TextView;

    iget-object v7, p0, Lcom/netwatch/app/f;->h:Landroid/widget/Button;

    move-object v8, p1

    invoke-static/range {v0 .. v8}, Lcom/netwatch/app/MainActivity;->S(Lcom/netwatch/app/MainActivity;Ljava/lang/String;Landroid/widget/LinearLayout;Landroid/widget/TextView;ZLandroid/widget/TextView;Landroid/widget/TextView;Landroid/widget/Button;Landroid/view/View;)V

    return-void
.end method
