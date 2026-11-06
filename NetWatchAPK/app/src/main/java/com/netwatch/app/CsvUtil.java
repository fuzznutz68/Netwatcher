package com.netwatch.app;

/** RFC 4180 field escaping, shared by connection-history and LAN exports. */
public final class CsvUtil {

    private CsvUtil() { }

    /** Always quotes the field and doubles embedded quotes. Null becomes an empty quoted field. */
    public static String escape(String value) {
        if (value == null) return "\"\"";
        return "\"" + value.replace("\"", "\"\"") + "\"";
    }
}
