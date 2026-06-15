.class public final synthetic Lcom/netwatch/app/x;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic b:Lcom/netwatch/app/NetWatchVpnService;

.field public final synthetic c:[B

.field public final synthetic d:I

.field public final synthetic e:Ljava/lang/String;

.field public final synthetic f:I

.field public final synthetic g:Ljava/lang/String;

.field public final synthetic h:I

.field public final synthetic i:Ljava/io/FileOutputStream;


# direct methods
.method public synthetic constructor <init>(Lcom/netwatch/app/NetWatchVpnService;[BILjava/lang/String;ILjava/lang/String;ILjava/io/FileOutputStream;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/netwatch/app/x;->b:Lcom/netwatch/app/NetWatchVpnService;

    iput-object p2, p0, Lcom/netwatch/app/x;->c:[B

    iput p3, p0, Lcom/netwatch/app/x;->d:I

    iput-object p4, p0, Lcom/netwatch/app/x;->e:Ljava/lang/String;

    iput p5, p0, Lcom/netwatch/app/x;->f:I

    iput-object p6, p0, Lcom/netwatch/app/x;->g:Ljava/lang/String;

    iput p7, p0, Lcom/netwatch/app/x;->h:I

    iput-object p8, p0, Lcom/netwatch/app/x;->i:Ljava/io/FileOutputStream;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 8

    iget-object v0, p0, Lcom/netwatch/app/x;->b:Lcom/netwatch/app/NetWatchVpnService;

    iget-object v1, p0, Lcom/netwatch/app/x;->c:[B

    iget v2, p0, Lcom/netwatch/app/x;->d:I

    iget-object v3, p0, Lcom/netwatch/app/x;->e:Ljava/lang/String;

    iget v4, p0, Lcom/netwatch/app/x;->f:I

    iget-object v5, p0, Lcom/netwatch/app/x;->g:Ljava/lang/String;

    iget v6, p0, Lcom/netwatch/app/x;->h:I

    iget-object v7, p0, Lcom/netwatch/app/x;->i:Ljava/io/FileOutputStream;

    invoke-static/range {v0 .. v7}, Lcom/netwatch/app/NetWatchVpnService;->a(Lcom/netwatch/app/NetWatchVpnService;[BILjava/lang/String;ILjava/lang/String;ILjava/io/FileOutputStream;)V

    return-void
.end method
