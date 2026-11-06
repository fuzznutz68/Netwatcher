package com.netwatch.app;

import org.junit.Test;
import static org.junit.Assert.*;

public class MonitorTargetTest {

    @Test public void acceptsRealUidAndPackage() {
        assertTrue(MonitorTarget.isValid(10042, "com.example.app"));
        assertTrue(MonitorTarget.isValid(0, "com.example.app")); // uid 0 is not "unknown"
    }

    @Test public void rejectsUnknownUid() {
        assertFalse(MonitorTarget.isValid(-1, "com.example.app"));
    }

    @Test public void rejectsMissingPackage() {
        assertFalse(MonitorTarget.isValid(10042, ""));
        assertFalse(MonitorTarget.isValid(10042, null));
        assertFalse(MonitorTarget.isValid(10042, "   "));
    }

    @Test public void failClosedNeverTreatsEmptyTargetAsDeviceWide() {
        // Regression guard: the service must stop, not monitor all traffic.
        assertFalse(MonitorTarget.isValid(-1, ""));
    }
}
