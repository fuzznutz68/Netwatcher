package com.netwatch.app;

/* loaded from: classes.dex */
public class TrafficEntry {
    public final int bytes;
    public final String direction;
    public final String host;
    public final String ipPort;
    public final String protocol;
    public final String timestamp;

    public TrafficEntry(String str, String str2, String str3, String str4, int i2, String str5) {
        this.direction = str;
        this.protocol = str2;
        this.host = str3;
        this.ipPort = str4;
        this.bytes = i2;
        this.timestamp = str5;
    }

    public String toString() {
        String g2;
        StringBuilder sb = new StringBuilder();
        sb.append(this.timestamp);
        sb.append("  ");
        sb.append(this.direction);
        sb.append("  ");
        sb.append(this.protocol);
        sb.append("  ");
        if (this.host.isEmpty()) {
            g2 = this.ipPort;
        } else {
            StringBuilder sb2 = new StringBuilder();
            sb2.append(this.host);
            sb2.append(" (");
            g2 = androidx.activity.result.a.g(sb2, this.ipPort, ")");
        }
        sb.append(g2);
        sb.append("  ");
        sb.append(this.bytes);
        sb.append("B");
        return sb.toString();
    }
}
