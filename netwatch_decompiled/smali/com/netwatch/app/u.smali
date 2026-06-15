.class public final synthetic Lcom/netwatch/app/u;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic b:Lcom/netwatch/app/MainActivity;

.field public final synthetic c:Ljava/lang/String;

.field public final synthetic d:Z

.field public final synthetic e:Z

.field public final synthetic f:Ljava/lang/String;


# direct methods
.method public synthetic constructor <init>(Lcom/netwatch/app/MainActivity;Ljava/lang/String;ZZLjava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/netwatch/app/u;->b:Lcom/netwatch/app/MainActivity;

    iput-object p2, p0, Lcom/netwatch/app/u;->c:Ljava/lang/String;

    iput-boolean p3, p0, Lcom/netwatch/app/u;->d:Z

    iput-boolean p4, p0, Lcom/netwatch/app/u;->e:Z

    iput-object p5, p0, Lcom/netwatch/app/u;->f:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 4

    iget-boolean v0, p0, Lcom/netwatch/app/u;->e:Z

    iget-object v1, p0, Lcom/netwatch/app/u;->f:Ljava/lang/String;

    iget-object v2, p0, Lcom/netwatch/app/u;->b:Lcom/netwatch/app/MainActivity;

    iget-object v3, p0, Lcom/netwatch/app/u;->c:Ljava/lang/String;

    iget-boolean p0, p0, Lcom/netwatch/app/u;->d:Z

    invoke-static {v2, v3, p0, v0, v1}, Lcom/netwatch/app/MainActivity;->L(Lcom/netwatch/app/MainActivity;Ljava/lang/String;ZZLjava/lang/String;)V

    return-void
.end method
