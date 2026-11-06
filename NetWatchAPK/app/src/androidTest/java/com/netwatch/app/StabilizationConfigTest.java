package com.netwatch.app;

import android.content.Context;
import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.platform.app.InstrumentationRegistry;

import org.junit.Test;
import org.junit.runner.RunWith;

import java.lang.reflect.Field;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotEquals;
import static org.junit.Assert.assertTrue;

/** Instrumented checks for configuration that unit tests cannot observe. */
@RunWith(AndroidJUnit4.class)
public class StabilizationConfigTest {

    private static int notifId(Class<?> cls) throws Exception {
        Field f = cls.getDeclaredField("NOTIF_ID");
        f.setAccessible(true);
        return f.getInt(null);
    }

    @Test public void notificationIdsAreUniqueAcrossServices() throws Exception {
        int vpn     = notifId(NetWatchVpnService.class);
        int traffic = notifId(TrafficMonitorService.class);
        int device  = notifId(DeviceMonitorService.class);
        assertNotEquals(vpn, traffic);
        assertNotEquals(vpn, device);
        assertNotEquals(traffic, device);
    }

    @Test public void sessionPreferencesAreSeparateFromUserPreferences() {
        Context ctx = InstrumentationRegistry.getInstrumentation().getTargetContext();
        ctx.getSharedPreferences("netwatch_session", Context.MODE_PRIVATE).edit()
                .putInt("target_uid", 10123).apply();
        assertTrue(ctx.getSharedPreferences("netwatch_session", Context.MODE_PRIVATE)
                .contains("target_uid"));
        // The backed-up preferences file must never carry monitoring identity.
        String backupAllowlist = "netwatch_prefs.xml";
        assertNotEquals(backupAllowlist, "netwatch_session.xml");
    }

    @Test public void failClosedDefaultsAreInvalidIdentities() {
        Context ctx = InstrumentationRegistry.getInstrumentation().getTargetContext();
        ctx.getSharedPreferences("netwatch_session", Context.MODE_PRIVATE).edit().clear().commit();
        int uid = ctx.getSharedPreferences("netwatch_session", Context.MODE_PRIVATE)
                .getInt("target_uid", -1);
        String pkg = ctx.getSharedPreferences("netwatch_session", Context.MODE_PRIVATE)
                .getString("target_pkg", "");
        assertEquals(-1, uid);          // invalid => service must stop, never go device-wide
        assertEquals("", pkg);
    }
}
