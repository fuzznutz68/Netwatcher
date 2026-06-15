.class public final synthetic Lcom/netwatch/app/d;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic b:Lcom/netwatch/app/MainActivity;

.field public final synthetic c:Ljava/lang/String;

.field public final synthetic d:Z

.field public final synthetic e:J


# direct methods
.method public synthetic constructor <init>(Lcom/netwatch/app/MainActivity;Ljava/lang/String;ZJ)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/netwatch/app/d;->b:Lcom/netwatch/app/MainActivity;

    iput-object p2, p0, Lcom/netwatch/app/d;->c:Ljava/lang/String;

    iput-boolean p3, p0, Lcom/netwatch/app/d;->d:Z

    iput-wide p4, p0, Lcom/netwatch/app/d;->e:J

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 4

    iget-boolean v0, p0, Lcom/netwatch/app/d;->d:Z

    iget-wide v1, p0, Lcom/netwatch/app/d;->e:J

    iget-object v3, p0, Lcom/netwatch/app/d;->b:Lcom/netwatch/app/MainActivity;

    iget-object p0, p0, Lcom/netwatch/app/d;->c:Ljava/lang/String;

    invoke-static {v3, p0, v0, v1, v2}, Lcom/netwatch/app/MainActivity;->A(Lcom/netwatch/app/MainActivity;Ljava/lang/String;ZJ)V

    return-void
.end method
