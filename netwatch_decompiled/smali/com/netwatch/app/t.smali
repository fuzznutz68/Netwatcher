.class public final synthetic Lcom/netwatch/app/t;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# instance fields
.field public final synthetic a:Lcom/netwatch/app/MainActivity;


# direct methods
.method public synthetic constructor <init>(Lcom/netwatch/app/MainActivity;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/netwatch/app/t;->a:Lcom/netwatch/app/MainActivity;

    return-void
.end method


# virtual methods
.method public final onClick(Landroid/content/DialogInterface;I)V
    .locals 0

    iget-object p0, p0, Lcom/netwatch/app/t;->a:Lcom/netwatch/app/MainActivity;

    invoke-static {p0, p1, p2}, Lcom/netwatch/app/MainActivity;->G(Lcom/netwatch/app/MainActivity;Landroid/content/DialogInterface;I)V

    return-void
.end method
