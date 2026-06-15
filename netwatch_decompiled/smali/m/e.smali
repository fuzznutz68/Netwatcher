.class public abstract Lm/e;
.super Ljava/lang/Object;
.source "SourceFile"


# static fields
.field public static final b:Lm/d;

.field public static final c:Lm/e;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    new-instance v0, Lm/d;

    invoke-direct {v0}, Lm/e;-><init>()V

    sput-object v0, Lm/e;->b:Lm/d;

    sget-object v0, Lh/c;->a:Lh/b;

    invoke-virtual {v0}, Lh/b;->b()Lm/e;

    move-result-object v0

    sput-object v0, Lm/e;->c:Lm/e;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public abstract a()I
.end method

.method public abstract b()I
.end method
