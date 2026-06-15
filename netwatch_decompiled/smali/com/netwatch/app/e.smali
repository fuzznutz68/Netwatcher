.class public final synthetic Lcom/netwatch/app/e;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic b:Lcom/netwatch/app/MainActivity;

.field public final synthetic c:I

.field public final synthetic d:Ljava/util/List;

.field public final synthetic e:I

.field public final synthetic f:I


# direct methods
.method public synthetic constructor <init>(Lcom/netwatch/app/MainActivity;ILjava/util/List;II)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/netwatch/app/e;->b:Lcom/netwatch/app/MainActivity;

    iput p2, p0, Lcom/netwatch/app/e;->c:I

    iput-object p3, p0, Lcom/netwatch/app/e;->d:Ljava/util/List;

    iput p4, p0, Lcom/netwatch/app/e;->e:I

    iput p5, p0, Lcom/netwatch/app/e;->f:I

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 4

    iget v0, p0, Lcom/netwatch/app/e;->e:I

    iget v1, p0, Lcom/netwatch/app/e;->f:I

    iget-object v2, p0, Lcom/netwatch/app/e;->b:Lcom/netwatch/app/MainActivity;

    iget v3, p0, Lcom/netwatch/app/e;->c:I

    iget-object p0, p0, Lcom/netwatch/app/e;->d:Ljava/util/List;

    invoke-static {v2, v3, p0, v0, v1}, Lcom/netwatch/app/MainActivity;->R(Lcom/netwatch/app/MainActivity;ILjava/util/List;II)V

    return-void
.end method
