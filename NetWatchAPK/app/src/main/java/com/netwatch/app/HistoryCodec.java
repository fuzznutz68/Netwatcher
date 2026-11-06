package com.netwatch.app;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;

/** Pure JSON (de)serialisation for monitoring sessions — no Android dependencies, unit-testable. */
public final class HistoryCodec {

    private HistoryCodec() { }

    public static JSONObject toJson(HistoryManager.Session s) throws JSONException {
        JSONObject o = new JSONObject();
        o.put("appLabel", s.appLabel);
        o.put("packageName", s.packageName);
        o.put("startTime", s.startTime);
        o.put("endTime", s.endTime);
        o.put("txBytes", s.txBytes);
        o.put("rxBytes", s.rxBytes);
        JSONArray arr = new JSONArray();
        for (Map.Entry<String, String> e : s.hosts.entrySet()) {
            JSONObject h = new JSONObject();
            h.put("host", e.getKey());
            h.put("ts", e.getValue());
            arr.put(h);
        }
        o.put("hosts", arr);
        return o;
    }

    public static HistoryManager.Session fromJson(String json, String id) throws JSONException {
        JSONObject o = new JSONObject(json);
        HistoryManager.Session s = new HistoryManager.Session();
        s.id          = id;
        s.appLabel    = o.optString("appLabel", "Device");
        s.packageName = o.optString("packageName", "");
        s.startTime   = o.optLong("startTime", 0);
        s.endTime     = o.optLong("endTime", 0);
        s.txBytes     = o.optLong("txBytes", -1);
        s.rxBytes     = o.optLong("rxBytes", -1);
        JSONArray arr = o.optJSONArray("hosts");
        if (arr != null) {
            for (int i = 0; i < arr.length(); i++) {
                JSONObject h = arr.optJSONObject(i);
                if (h != null) s.hosts.put(h.optString("host"), h.optString("ts"));
            }
        }
        return s;
    }
}
