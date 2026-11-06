package com.netwatch.app;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;

import androidx.test.core.app.ApplicationProvider;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.annotation.Config;

/**
 * Regression test for the P0 monitoring-start crash.
 *
 * startForeground() must be given a notification whose channel exists. On Android 8+
 * a missing channel makes the framework raise
 * RemoteServiceException: Bad notification for startForeground:
 * java.lang.RuntimeException: invalid channel for service notification
 * asynchronously on the main thread, which kills the process.
 */
@RunWith(RobolectricTestRunner.class)
@Config(sdk = 34)
public class NotificationChannelTest {

    private static final String TRAFFIC_CHANNEL = "netwatch_monitor";

    @Test
    public void trafficServiceCreatesItsNotificationChannelBeforeForeground() {
        Context ctx = ApplicationProvider.getApplicationContext();
        NotificationManager nm = (NotificationManager) ctx.getSystemService(Context.NOTIFICATION_SERVICE);
        nm.deleteNotificationChannel(TRAFFIC_CHANNEL);   // simulate a fresh install

        Intent i = new Intent(ctx, TrafficMonitorService.class);
        i.putExtra("target_uid", 10001);
        i.putExtra("target_pkg", "com.example.alpha");
        i.putExtra("target_name", "Alpha");

        TrafficMonitorService svc =
                Robolectric.buildService(TrafficMonitorService.class, i).create().get();
        svc.onStartCommand(i, 0, 1);

        assertNotNull("traffic service must create its notification channel before startForeground()",
                nm.getNotificationChannel(TRAFFIC_CHANNEL));
        assertTrue(svc.stopSelfResult(1) || true);
    }

    /**
     * Requirement: the channel must also exist on the null-intent system restart path,
     * where onStartCommand() has no extras and falls back to restoreTarget().
     */
    @Test
    public void nullIntentRestartAlsoCreatesChannel() {
        Context ctx = ApplicationProvider.getApplicationContext();
        NotificationManager nm = (NotificationManager) ctx.getSystemService(Context.NOTIFICATION_SERVICE);
        nm.deleteNotificationChannel(TRAFFIC_CHANNEL);   // fresh install, no prior channel

        TrafficMonitorService svc =
                Robolectric.buildService(TrafficMonitorService.class).create().get();
        svc.onStartCommand(null, 0, 1);                   // system restart delivers null intent

        assertNotNull("channel must exist before startForeground() on a null-intent restart",
                nm.getNotificationChannel(TRAFFIC_CHANNEL));
    }
}
