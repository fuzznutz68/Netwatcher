.class public Lj/b;
.super Li/b;
.source "SourceFile"


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Li/b;-><init>()V

    return-void
.end method


# virtual methods
.method public final b()Lm/e;
    .locals 1

    sget-object p0, Lj/a;->a:Ljava/lang/Integer;

    if-eqz p0, :cond_1

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    const/16 v0, 0x22

    if-lt p0, v0, :cond_0

    goto :goto_0

    :cond_0
    new-instance p0, Lm/c;

    invoke-direct {p0}, Lm/c;-><init>()V

    goto :goto_1

    :cond_1
    :goto_0
    new-instance p0, Ln/a;

    invoke-direct {p0}, Lm/e;-><init>()V

    :goto_1
    return-object p0
.end method
