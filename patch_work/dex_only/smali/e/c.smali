.class public final Le/c;
.super Lkotlin/jvm/internal/l;
.source "SourceFile"

# interfaces
.implements Ll/p;


# static fields
.field public static final c:Le/c;

.field public static final d:Le/c;


# instance fields
.field public final synthetic b:I


# direct methods
.method static synthetic constructor <clinit>()V
    .locals 2

    new-instance v0, Le/c;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Le/c;-><init>(I)V

    sput-object v0, Le/c;->c:Le/c;

    new-instance v0, Le/c;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Le/c;-><init>(I)V

    sput-object v0, Le/c;->d:Le/c;

    return-void
.end method

.method public synthetic constructor <init>(I)V
    .locals 0

    iput p1, p0, Le/c;->b:I

    const/4 p1, 0x2

    invoke-direct {p0, p1}, Lkotlin/jvm/internal/l;-><init>(I)V

    return-void
.end method


# virtual methods
.method public final invoke(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 2

    iget p0, p0, Le/c;->b:I

    packed-switch p0, :pswitch_data_0

    check-cast p1, Le/j;

    check-cast p2, Le/h;

    invoke-interface {p2}, Le/h;->getKey()Le/i;

    move-result-object p0

    invoke-interface {p1, p0}, Le/j;->minusKey(Le/i;)Le/j;

    move-result-object p0

    sget-object p1, Le/k;->b:Le/k;

    if-ne p0, p1, :cond_0

    goto :goto_1

    :cond_0
    sget-object v0, Le/f;->b:Le/f;

    invoke-interface {p0, v0}, Le/j;->get(Le/i;)Le/h;

    move-result-object v1

    check-cast v1, Le/g;

    if-nez v1, :cond_1

    new-instance p1, Le/d;

    invoke-direct {p1, p2, p0}, Le/d;-><init>(Le/h;Le/j;)V

    :goto_0
    move-object p2, p1

    goto :goto_1

    :cond_1
    invoke-interface {p0, v0}, Le/j;->minusKey(Le/i;)Le/j;

    move-result-object p0

    if-ne p0, p1, :cond_2

    new-instance p0, Le/d;

    invoke-direct {p0, v1, p2}, Le/d;-><init>(Le/h;Le/j;)V

    move-object p2, p0

    goto :goto_1

    :cond_2
    new-instance p1, Le/d;

    new-instance v0, Le/d;

    invoke-direct {v0, p2, p0}, Le/d;-><init>(Le/h;Le/j;)V

    invoke-direct {p1, v1, v0}, Le/d;-><init>(Le/h;Le/j;)V

    goto :goto_0

    :goto_1
    return-object p2

    :pswitch_0
    check-cast p1, Ljava/lang/String;

    check-cast p2, Le/h;

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p0

    if-nez p0, :cond_3

    invoke-virtual {p2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_2

    :cond_3
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ", "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    :goto_2
    return-object p0

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method
