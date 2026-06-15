.class public final Ls/b;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ls/d1;


# static fields
.field public static final b:Ls/b;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    new-instance v0, Ls/b;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Ls/b;->b:Ls/b;

    return-void
.end method


# virtual methods
.method public final toString()Ljava/lang/String;
    .locals 0

    const-string p0, "Active"

    return-object p0
.end method
