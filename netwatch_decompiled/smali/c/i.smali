.class public final Lc/i;
.super Ljava/lang/Object;
.source "SourceFile"


# static fields
.field public static final a:Lc/i;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    new-instance v0, Lc/i;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lc/i;->a:Lc/i;

    return-void
.end method


# virtual methods
.method public final toString()Ljava/lang/String;
    .locals 0

    const-string p0, "kotlin.Unit"

    return-object p0
.end method
