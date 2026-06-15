.class public final synthetic Lcom/netwatch/app/s;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic b:Lcom/netwatch/app/MainActivity;

.field public final synthetic c:Ljava/lang/String;

.field public final synthetic d:J

.field public final synthetic e:D

.field public final synthetic f:D


# direct methods
.method public synthetic constructor <init>(Lcom/netwatch/app/MainActivity;Ljava/lang/String;JDD)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/netwatch/app/s;->b:Lcom/netwatch/app/MainActivity;

    iput-object p2, p0, Lcom/netwatch/app/s;->c:Ljava/lang/String;

    iput-wide p3, p0, Lcom/netwatch/app/s;->d:J

    iput-wide p5, p0, Lcom/netwatch/app/s;->e:D

    iput-wide p7, p0, Lcom/netwatch/app/s;->f:D

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 8

    iget-object v0, p0, Lcom/netwatch/app/s;->b:Lcom/netwatch/app/MainActivity;

    iget-object v1, p0, Lcom/netwatch/app/s;->c:Ljava/lang/String;

    iget-wide v2, p0, Lcom/netwatch/app/s;->d:J

    iget-wide v4, p0, Lcom/netwatch/app/s;->e:D

    iget-wide v6, p0, Lcom/netwatch/app/s;->f:D

    invoke-static/range {v0 .. v7}, Lcom/netwatch/app/MainActivity;->t(Lcom/netwatch/app/MainActivity;Ljava/lang/String;JDD)V

    return-void
.end method
