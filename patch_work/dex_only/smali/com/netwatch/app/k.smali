.class public final synthetic Lcom/netwatch/app/k;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/widget/PopupMenu$OnMenuItemClickListener;


# instance fields
.field public final synthetic a:Lcom/netwatch/app/MainActivity;


# direct methods
.method public synthetic constructor <init>(Lcom/netwatch/app/MainActivity;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/netwatch/app/k;->a:Lcom/netwatch/app/MainActivity;

    return-void
.end method


# virtual methods
.method public final onMenuItemClick(Landroid/view/MenuItem;)Z
    .locals 0

    iget-object p0, p0, Lcom/netwatch/app/k;->a:Lcom/netwatch/app/MainActivity;

    invoke-static {p0, p1}, Lcom/netwatch/app/MainActivity;->F(Lcom/netwatch/app/MainActivity;Landroid/view/MenuItem;)Z

    move-result p0

    return p0
.end method
