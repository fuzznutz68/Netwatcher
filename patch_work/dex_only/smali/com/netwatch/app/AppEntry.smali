.class public Lcom/netwatch/app/AppEntry;
.super Ljava/lang/Object;
.source "SourceFile"


# instance fields
.field public final label:Ljava/lang/String;

.field public final packageName:Ljava/lang/String;

.field public final uid:I


# direct methods
.method public constructor <init>(Ljava/lang/String;Ljava/lang/String;I)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/netwatch/app/AppEntry;->label:Ljava/lang/String;

    iput-object p2, p0, Lcom/netwatch/app/AppEntry;->packageName:Ljava/lang/String;

    iput p3, p0, Lcom/netwatch/app/AppEntry;->uid:I

    return-void
.end method


# virtual methods
.method public toString()Ljava/lang/String;
    .locals 0

    iget-object p0, p0, Lcom/netwatch/app/AppEntry;->label:Ljava/lang/String;

    return-object p0
.end method
