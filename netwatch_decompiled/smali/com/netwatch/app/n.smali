.class public final synthetic Lcom/netwatch/app/n;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic b:Lcom/netwatch/app/MainActivity;

.field public final synthetic c:Ljava/lang/String;

.field public final synthetic d:Landroid/widget/TextView;

.field public final synthetic e:Landroid/widget/TextView;


# direct methods
.method public synthetic constructor <init>(Lcom/netwatch/app/MainActivity;Ljava/lang/String;Landroid/widget/TextView;Landroid/widget/TextView;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/netwatch/app/n;->b:Lcom/netwatch/app/MainActivity;

    iput-object p2, p0, Lcom/netwatch/app/n;->c:Ljava/lang/String;

    iput-object p3, p0, Lcom/netwatch/app/n;->d:Landroid/widget/TextView;

    iput-object p4, p0, Lcom/netwatch/app/n;->e:Landroid/widget/TextView;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 3

    iget-object v0, p0, Lcom/netwatch/app/n;->d:Landroid/widget/TextView;

    iget-object v1, p0, Lcom/netwatch/app/n;->e:Landroid/widget/TextView;

    iget-object v2, p0, Lcom/netwatch/app/n;->b:Lcom/netwatch/app/MainActivity;

    iget-object p0, p0, Lcom/netwatch/app/n;->c:Ljava/lang/String;

    invoke-static {v2, p0, v0, v1}, Lcom/netwatch/app/MainActivity;->T(Lcom/netwatch/app/MainActivity;Ljava/lang/String;Landroid/widget/TextView;Landroid/widget/TextView;)V

    return-void
.end method
