package com.netwatch.app;

/* loaded from: classes.dex */
public class AppEntry {
    public final String label;
    public final String packageName;
    public final int uid;

    public AppEntry(String str, String str2, int i2) {
        this.label = str;
        this.packageName = str2;
        this.uid = i2;
    }

    public String toString() {
        return this.label;
    }
}
