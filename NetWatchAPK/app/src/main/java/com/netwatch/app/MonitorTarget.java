package com.netwatch.app;

/** Validation for a monitoring target. Pure logic so it is unit-testable. */
public final class MonitorTarget {

    private MonitorTarget() { }

    /**
     * A target is usable only when it names a real app. UID -1 means "unknown"
     * and empty package means "no selection"; neither may ever fall back to
     * whole-device monitoring.
     */
    public static boolean isValid(int uid, String pkg) {
        return uid >= 0 && pkg != null && !pkg.trim().isEmpty();
    }
}
