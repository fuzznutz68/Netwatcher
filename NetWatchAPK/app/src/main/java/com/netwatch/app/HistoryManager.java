package com.netwatch.app;

import android.content.Context;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Persists completed Traffic Monitor sessions to disk as JSON files so the user
 * can review them later ("Connection History"). No network/server involved —
 * everything is stored locally under the app's private files directory.
 */
public class HistoryManager {

    private static final String DIR_NAME = "traffic_history";
    private static final int    MAX_SESSIONS = 100; // keep storage bounded

    public static class Session {
        public String id;             // filename-safe timestamp
        public String appLabel;
        public String packageName;
        public long   startTime;      // epoch millis
        public long   endTime;        // epoch millis
        public long   txBytes;
        public long   rxBytes;
        public LinkedHashMap<String, String> hosts = new LinkedHashMap<>(); // host -> HH:mm:ss

        public int connectionCount() { return hosts.size(); }
    }

    private static File dir(Context ctx) {
        File d = new File(ctx.getFilesDir(), DIR_NAME);
        if (!d.exists()) d.mkdirs();
        return d;
    }

    /** Save a completed monitoring session. No-op if there were zero connections logged. */
    public static void save(Context ctx, Session s) {
        if (s.hosts.isEmpty()) return;
        try {
            JSONObject o = HistoryCodec.toJson(s);

            String filename = "session_" + s.startTime + ".json";
            File f = new File(dir(ctx), filename);
            try (FileWriter fw = new FileWriter(f)) { fw.write(o.toString()); }

            trimOldSessions(ctx);
        } catch (JSONException | IOException ignored) { }
    }

    private static void trimOldSessions(Context ctx) {
        File[] files = dir(ctx).listFiles();
        if (files == null || files.length <= MAX_SESSIONS) return;
        List<File> list = new ArrayList<>();
        Collections.addAll(list, files);
        list.sort(Comparator.comparingLong(File::lastModified));
        int toDelete = list.size() - MAX_SESSIONS;
        for (int i = 0; i < toDelete; i++) list.get(i).delete();
    }

    /** List all sessions, newest first. */
    public static List<Session> listAll(Context ctx) {
        List<Session> result = new ArrayList<>();
        File[] files = dir(ctx).listFiles();
        if (files == null) return result;
        for (File f : files) {
            try {
                String json = new String(Files.readAllBytes(f.toPath()));
                result.add(HistoryCodec.fromJson(json, f.getName()));
            } catch (Exception ignored) { }
        }
        result.sort((a, b) -> Long.compare(b.startTime, a.startTime));
        return result;
    }

    public static void delete(Context ctx, String sessionId) {
        new File(dir(ctx), sessionId).delete();
    }

    public static void deleteAll(Context ctx) {
        File[] files = dir(ctx).listFiles();
        if (files == null) return;
        for (File f : files) f.delete();
    }
}
