package com.netwatch.app;

public class AppEntry {
    public final String label;
    public final String packageName;
    public final int    uid;

    public AppEntry(String label, String packageName, int uid) {
        this.label       = label;
        this.packageName = packageName;
        this.uid         = uid;
    }

    @Override
    public String toString() { return label; }
}
