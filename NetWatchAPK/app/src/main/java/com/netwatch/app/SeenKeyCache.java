package com.netwatch.app;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Bounded dedup cache for observed connections. Entries expire at twice the dedup window,
 * so pruning can never resurrect a duplicate that would otherwise have been suppressed.
 */
public final class SeenKeyCache {

    private final ConcurrentHashMap<String, Long> seen = new ConcurrentHashMap<>();
    private final long dedupMs;
    private final long pruneIntervalMs;
    private final int  maxEntries;
    private long lastPruneMs;

    public SeenKeyCache(long dedupMs, long pruneIntervalMs, int maxEntries) {
        this.dedupMs = dedupMs;
        this.pruneIntervalMs = pruneIntervalMs;
        this.maxEntries = maxEntries;
    }

    /** @return true when this key should be reported (first sighting or outside the window). */
    public boolean shouldReport(String key, long nowMs) {
        Long last = seen.get(key);
        if (last == null || nowMs - last > dedupMs) {
            seen.put(key, nowMs);
            prune(nowMs);
            return true;
        }
        return false;
    }

    /** Time-based sweep, plus a hard size cap for bursts of unique destinations. */
    public void prune(long nowMs) {
        // Hard cap: evict the oldest 10% (regardless of TTL) so memory stays bounded even
        // when every destination is unique. Only these evicted keys can be reported again,
        // and only after they are gone — still bounded, still no event storm.
        if (seen.size() > maxEntries) {
            int target = Math.max(1, (int) (maxEntries * 0.9));
            List<Map.Entry<String, Long>> entries = new ArrayList<>(seen.entrySet());
            entries.sort((a, b) -> Long.compare(a.getValue(), b.getValue()));
            for (int i = 0; i < entries.size() - target; i++) {
                seen.remove(entries.get(i).getKey(), entries.get(i).getValue());
            }
        }
        if (nowMs - lastPruneMs < pruneIntervalMs) return;
        lastPruneMs = nowMs;
        long cutoff = nowMs - (dedupMs * 2);
        for (Map.Entry<String, Long> e : seen.entrySet()) {
            if (e.getValue() < cutoff) seen.remove(e.getKey(), e.getValue());
        }
    }

    public int size() { return seen.size(); }
    public boolean contains(String key) { return seen.containsKey(key); }
}
