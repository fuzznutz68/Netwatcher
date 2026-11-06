package com.netwatch.app;

import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class HistoryCodecTest {

    private HistoryManager.Session sample() {
        HistoryManager.Session s = new HistoryManager.Session();
        s.appLabel = "YouTube";
        s.packageName = "com.google.android.youtube";
        s.startTime = 1_700_000_000_000L;
        s.endTime = 1_700_000_600_000L;
        s.txBytes = 1234;
        s.rxBytes = 98765;
        s.hosts.put("r1.googlevideo.com", "12:00:01");
        s.hosts.put("i.ytimg.com", "12:00:05");
        return s;
    }

    @Test public void roundTripPreservesAllFields() throws Exception {
        HistoryManager.Session a = sample();
        HistoryManager.Session b = HistoryCodec.fromJson(HistoryCodec.toJson(a).toString(), "id1");

        assertEquals(a.appLabel, b.appLabel);
        assertEquals(a.packageName, b.packageName);
        assertEquals(a.startTime, b.startTime);
        assertEquals(a.endTime, b.endTime);
        assertEquals(a.txBytes, b.txBytes);
        assertEquals(a.rxBytes, b.rxBytes);
        assertEquals("id1", b.id);
    }

    @Test public void hostOrderIsPreserved() throws Exception {
        HistoryManager.Session a = sample();
        HistoryManager.Session b = HistoryCodec.fromJson(HistoryCodec.toJson(a).toString(), "id");

        List<String> expected = new ArrayList<>(a.hosts.keySet());
        List<String> actual = new ArrayList<>(b.hosts.keySet());
        assertEquals(expected, actual);
        assertEquals(a.hosts.get("r1.googlevideo.com"), b.hosts.get("r1.googlevideo.com"));
    }

    @Test public void missingFieldsFallBackToDefaults() throws Exception {
        HistoryManager.Session s = HistoryCodec.fromJson("{}", "id");
        assertEquals("Device", s.appLabel);
        assertEquals("", s.packageName);
        assertEquals(0L, s.startTime);
        assertEquals(-1L, s.txBytes);
        assertTrue(s.hosts.isEmpty());
    }
}
