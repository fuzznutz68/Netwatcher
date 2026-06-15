.class public final synthetic Lcom/netwatch/app/y;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic b:Lcom/netwatch/app/NetWatchVpnService;

.field public final synthetic c:[B

.field public final synthetic d:Ljava/lang/String;

.field public final synthetic e:I

.field public final synthetic f:Ljava/lang/String;

.field public final synthetic g:I

.field public final synthetic h:Ljava/io/FileOutputStream;

.field public final synthetic i:[B

.field public final synthetic j:I


# direct methods
.method public synthetic constructor <init>(Lcom/netwatch/app/NetWatchVpnService;[BLjava/lang/String;ILjava/lang/String;ILjava/io/FileOutputStream;[BI)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/netwatch/app/y;->b:Lcom/netwatch/app/NetWatchVpnService;

    iput-object p2, p0, Lcom/netwatch/app/y;->c:[B

    iput-object p3, p0, Lcom/netwatch/app/y;->d:Ljava/lang/String;

    iput p4, p0, Lcom/netwatch/app/y;->e:I

    iput-object p5, p0, Lcom/netwatch/app/y;->f:Ljava/lang/String;

    iput p6, p0, Lcom/netwatch/app/y;->g:I

    iput-object p7, p0, Lcom/netwatch/app/y;->h:Ljava/io/FileOutputStream;

    iput-object p8, p0, Lcom/netwatch/app/y;->i:[B

    iput p9, p0, Lcom/netwatch/app/y;->j:I

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 9

    iget-object v0, p0, Lcom/netwatch/app/y;->b:Lcom/netwatch/app/NetWatchVpnService;

    iget-object v1, p0, Lcom/netwatch/app/y;->c:[B

    iget-object v2, p0, Lcom/netwatch/app/y;->d:Ljava/lang/String;

    iget v3, p0, Lcom/netwatch/app/y;->e:I

    iget-object v4, p0, Lcom/netwatch/app/y;->f:Ljava/lang/String;

    iget v5, p0, Lcom/netwatch/app/y;->g:I

    iget-object v6, p0, Lcom/netwatch/app/y;->h:Ljava/io/FileOutputStream;

    iget-object v7, p0, Lcom/netwatch/app/y;->i:[B

    iget v8, p0, Lcom/netwatch/app/y;->j:I

    invoke-static/range {v0 .. v8}, Lcom/netwatch/app/NetWatchVpnService;->b(Lcom/netwatch/app/NetWatchVpnService;[BLjava/lang/String;ILjava/lang/String;ILjava/io/FileOutputStream;[BI)V

    return-void
.end method
