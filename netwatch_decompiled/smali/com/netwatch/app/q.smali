.class public final synthetic Lcom/netwatch/app/q;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic b:Lcom/netwatch/app/MainActivity;

.field public final synthetic c:Ljava/util/List;

.field public final synthetic d:Ljava/util/List;

.field public final synthetic e:Ljava/lang/String;

.field public final synthetic f:Ljava/lang/String;


# direct methods
.method public synthetic constructor <init>(Lcom/netwatch/app/MainActivity;Ljava/util/ArrayList;Ljava/util/ArrayList;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/netwatch/app/q;->b:Lcom/netwatch/app/MainActivity;

    iput-object p2, p0, Lcom/netwatch/app/q;->c:Ljava/util/List;

    iput-object p3, p0, Lcom/netwatch/app/q;->d:Ljava/util/List;

    iput-object p4, p0, Lcom/netwatch/app/q;->e:Ljava/lang/String;

    iput-object p5, p0, Lcom/netwatch/app/q;->f:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 4

    iget-object v0, p0, Lcom/netwatch/app/q;->e:Ljava/lang/String;

    iget-object v1, p0, Lcom/netwatch/app/q;->f:Ljava/lang/String;

    iget-object v2, p0, Lcom/netwatch/app/q;->b:Lcom/netwatch/app/MainActivity;

    iget-object v3, p0, Lcom/netwatch/app/q;->c:Ljava/util/List;

    iget-object p0, p0, Lcom/netwatch/app/q;->d:Ljava/util/List;

    invoke-static {v2, v3, p0, v0, v1}, Lcom/netwatch/app/MainActivity;->q(Lcom/netwatch/app/MainActivity;Ljava/util/List;Ljava/util/List;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method
