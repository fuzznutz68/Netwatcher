.class public final synthetic Lcom/netwatch/app/i;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;


# instance fields
.field public final synthetic a:Lcom/netwatch/app/MainActivity;

.field public final synthetic b:Landroid/content/SharedPreferences;


# direct methods
.method public synthetic constructor <init>(Lcom/netwatch/app/MainActivity;Landroid/content/SharedPreferences;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/netwatch/app/i;->a:Lcom/netwatch/app/MainActivity;

    iput-object p2, p0, Lcom/netwatch/app/i;->b:Landroid/content/SharedPreferences;

    return-void
.end method


# virtual methods
.method public final onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .locals 1

    iget-object v0, p0, Lcom/netwatch/app/i;->a:Lcom/netwatch/app/MainActivity;

    iget-object p0, p0, Lcom/netwatch/app/i;->b:Landroid/content/SharedPreferences;

    invoke-static {v0, p0, p1, p2}, Lcom/netwatch/app/MainActivity;->O(Lcom/netwatch/app/MainActivity;Landroid/content/SharedPreferences;Landroid/widget/CompoundButton;Z)V

    return-void
.end method
