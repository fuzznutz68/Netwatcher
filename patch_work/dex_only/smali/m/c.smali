.class public final Lm/c;
.super Lm/a;
.source "SourceFile"


# instance fields
.field public final d:Lm/b;


# direct methods
.method public constructor <init>()V
    .locals 1

    invoke-direct {p0}, Lm/e;-><init>()V

    new-instance v0, Lm/b;

    invoke-direct {v0}, Ljava/lang/ThreadLocal;-><init>()V

    iput-object v0, p0, Lm/c;->d:Lm/b;

    return-void
.end method


# virtual methods
.method public final c()Ljava/util/Random;
    .locals 1

    iget-object p0, p0, Lm/c;->d:Lm/b;

    invoke-virtual {p0}, Ljava/lang/ThreadLocal;->get()Ljava/lang/Object;

    move-result-object p0

    const-string v0, "implStorage.get()"

    invoke-static {p0, v0}, Ls/y;->f(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p0, Ljava/util/Random;

    return-object p0
.end method
