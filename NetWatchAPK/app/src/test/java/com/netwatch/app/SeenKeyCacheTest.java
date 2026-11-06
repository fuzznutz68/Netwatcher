package com.netwatch.app;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class SeenKeyCacheTest {

    private SeenKeyCache cache() {
        // 30s dedup, 60s prune sweep, generous cap
        return new SeenKeyCache(30_000L, 60_000L, 20_000);
    }

    @Test public void firstSightingReports() {
        assertTrue(cache().shouldReport("TCP1.2.3.4:443", 1_000L));
    }

    @Test public void repeatWithinWindowIsSuppressed() {
        SeenKeyCache c = cache();
        assertTrue(c.shouldReport("k", 1_000L));
        assertFalse(c.shouldReport("k", 20_000L));
    }

    @Test public void repeatAfterWindowReportsAgain() {
        SeenKeyCache c = cache();
        assertTrue(c.shouldReport("k", 1_000L));
        assertTrue(c.shouldReport("k", 31_001L));
    }

    @Test public void pruneDropsExpiredEntries() {
        SeenKeyCache c = cache();
        c.shouldReport("old", 1_000L);
        assertEquals(1, c.size());
        // Sweep at 100s: cutoff is 100s - 60s = 40s, so the 1s entry is gone
        c.prune(100_000L);
        assertEquals(0, c.size());
    }

    @Test public void pruningNeverResurrectsSuppressedDuplicates() {
        SeenKeyCache c = cache();
        assertTrue(c.shouldReport("k", 1_000L));
        c.prune(2_000L);                       // early sweep must not remove a fresh entry
        assertFalse(c.shouldReport("k", 2_500L));
    }

    @Test public void sizeCapBoundsMemoryDuringBursts() {
        SeenKeyCache c = new SeenKeyCache(30_000L, 3_600_000L, 10);
        for (int i = 0; i < 100; i++) c.shouldReport("k" + i, 1_000L + i);
        assertTrue("cache must stay bounded, was " + c.size(), c.size() <= 10);
    }
}
