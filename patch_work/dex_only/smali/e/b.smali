.class public abstract Le/b;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Le/i;


# instance fields
.field public final b:Ll/l;

.field public final c:Le/i;


# direct methods
.method public constructor <init>(Le/i;Ls/q;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p2, p0, Le/b;->b:Ll/l;

    instance-of p2, p1, Le/b;

    if-eqz p2, :cond_0

    check-cast p1, Le/b;

    iget-object p1, p1, Le/b;->c:Le/i;

    :cond_0
    iput-object p1, p0, Le/b;->c:Le/i;

    return-void
.end method
