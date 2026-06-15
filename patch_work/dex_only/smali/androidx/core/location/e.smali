.class public final synthetic Landroidx/core/location/e;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic b:I

.field public final synthetic c:Ljava/util/concurrent/Executor;

.field public final synthetic d:I

.field public final synthetic e:Ljava/lang/Object;


# direct methods
.method public synthetic constructor <init>(Ljava/lang/Object;Ljava/util/concurrent/Executor;II)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p4, p0, Landroidx/core/location/e;->b:I

    iput-object p1, p0, Landroidx/core/location/e;->e:Ljava/lang/Object;

    iput-object p2, p0, Landroidx/core/location/e;->c:Ljava/util/concurrent/Executor;

    iput p3, p0, Landroidx/core/location/e;->d:I

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 3

    iget v0, p0, Landroidx/core/location/e;->b:I

    iget v1, p0, Landroidx/core/location/e;->d:I

    iget-object v2, p0, Landroidx/core/location/e;->c:Ljava/util/concurrent/Executor;

    iget-object p0, p0, Landroidx/core/location/e;->e:Ljava/lang/Object;

    packed-switch v0, :pswitch_data_0

    check-cast p0, Landroidx/core/location/LocationManagerCompat$PreRGnssStatusTransport;

    invoke-static {p0, v2, v1}, Landroidx/core/location/LocationManagerCompat$PreRGnssStatusTransport;->c(Landroidx/core/location/LocationManagerCompat$PreRGnssStatusTransport;Ljava/util/concurrent/Executor;I)V

    return-void

    :pswitch_0
    check-cast p0, Landroidx/core/location/LocationManagerCompat$GpsStatusTransport;

    invoke-static {p0, v2, v1}, Landroidx/core/location/LocationManagerCompat$GpsStatusTransport;->a(Landroidx/core/location/LocationManagerCompat$GpsStatusTransport;Ljava/util/concurrent/Executor;I)V

    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method
