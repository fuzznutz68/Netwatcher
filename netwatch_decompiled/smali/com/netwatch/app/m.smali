.class public final synthetic Lcom/netwatch/app/m;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic b:Lcom/netwatch/app/MainActivity;

.field public final synthetic c:Landroid/widget/TextView;

.field public final synthetic d:Z

.field public final synthetic e:J

.field public final synthetic f:Landroid/widget/TextView;

.field public final synthetic g:Ljava/lang/String;


# direct methods
.method public synthetic constructor <init>(Lcom/netwatch/app/MainActivity;Landroid/widget/TextView;ZJLandroid/widget/TextView;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/netwatch/app/m;->b:Lcom/netwatch/app/MainActivity;

    iput-object p2, p0, Lcom/netwatch/app/m;->c:Landroid/widget/TextView;

    iput-boolean p3, p0, Lcom/netwatch/app/m;->d:Z

    iput-wide p4, p0, Lcom/netwatch/app/m;->e:J

    iput-object p6, p0, Lcom/netwatch/app/m;->f:Landroid/widget/TextView;

    iput-object p7, p0, Lcom/netwatch/app/m;->g:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 7

    iget-object v0, p0, Lcom/netwatch/app/m;->b:Lcom/netwatch/app/MainActivity;

    iget-object v1, p0, Lcom/netwatch/app/m;->c:Landroid/widget/TextView;

    iget-boolean v2, p0, Lcom/netwatch/app/m;->d:Z

    iget-wide v3, p0, Lcom/netwatch/app/m;->e:J

    iget-object v5, p0, Lcom/netwatch/app/m;->f:Landroid/widget/TextView;

    iget-object v6, p0, Lcom/netwatch/app/m;->g:Ljava/lang/String;

    invoke-static/range {v0 .. v6}, Lcom/netwatch/app/MainActivity;->n(Lcom/netwatch/app/MainActivity;Landroid/widget/TextView;ZJLandroid/widget/TextView;Ljava/lang/String;)V

    return-void
.end method
