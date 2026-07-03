package com.netwatch.app;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.HashMap;
import java.util.Map;

/**
 * Runtime Light/Dark theme engine for NetWatch.
 *
 * The app's terminal-style UI uses hardcoded hex colors throughout its layouts,
 * drawables, and dynamically-generated card views (rather than theme attributes).
 * Rather than rewriting every layout, this walks the live view tree and remaps
 * exact-match background / text colors from the Dark palette to the Light palette
 * (and back), covering both static (XML-inflated) and dynamic (Java-created) views.
 */
public class ThemeManager {

    public static final String PREFS_NAME   = "netwatch_prefs";
    public static final String PREF_THEME    = "theme_mode"; // "dark" | "light"

    // ── Background color remaps (dark hex -> light hex) ─────────────────────
    private static final Map<Integer, Integer> BG_MAP = new HashMap<>();
    // ── Text color remaps (dark hex -> light hex) ────────────────────────────
    private static final Map<Integer, Integer> TEXT_MAP = new HashMap<>();
    // Reverse maps, built once, for restoring dark mode
    private static final Map<Integer, Integer> BG_MAP_REV = new HashMap<>();
    private static final Map<Integer, Integer> TEXT_MAP_REV = new HashMap<>();

    static {
        // Structural backgrounds
        bg(0xFF0A0E17, 0xFFF3F5F8);  // main app background
        bg(0xFF0D1117, 0xFFFFFFFF);  // header / card / tab-selected bg
        bg(0xFF0a1220, 0xFFEDEFF3);  // nested panel bg
        bg(0xFF1A2A3A, 0xFFD6DCE2); // card border
        bg(0xFF1E3040, 0xFFC6CFD8); // input border
        bg(0xFF001820, 0xFFDFF5F9); // primary button bg (idle)
        bg(0xFF003040, 0xFFC7ECF2); // primary button bg (pressed)
        bg(0xFF1A0505, 0xFFFBE4E4); // danger button bg (idle)
        bg(0xFF3A0A0A, 0xFFF6C8C8); // danger button bg (pressed)

        // Structural text
        text(0xFFE0E8F0, 0xFF16202B); // primary text
        text(0xFFC8D8E8, 0xFF26333F); // value text
        text(0xFF546E7A, 0xFF45606D); // muted/secondary text
        text(0xFF8892A4, 0xFF5C6B7A); // tab inactive text
        text(0xFF3A4A5A, 0xFF8FA0AC); // hint text
        text(0xFF6a7a8a, 0xFF52616E); // secondary label

        for (Map.Entry<Integer, Integer> e : BG_MAP.entrySet())   BG_MAP_REV.put(e.getValue(), e.getKey());
        for (Map.Entry<Integer, Integer> e : TEXT_MAP.entrySet()) TEXT_MAP_REV.put(e.getValue(), e.getKey());
    }

    private static void bg(int dark, int light)   { BG_MAP.put(dark, light); }
    private static void text(int dark, int light) { TEXT_MAP.put(dark, light); }

    public static boolean isLight(Context ctx) {
        SharedPreferences p = ctx.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        return "light".equals(p.getString(PREF_THEME, "dark"));
    }

    public static void setLight(Context ctx, boolean light) {
        ctx.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
           .edit().putString(PREF_THEME, light ? "light" : "dark").apply();
    }

    /** Recursively remap every background/text color in this view subtree to the given theme. */
    public static void apply(View root, boolean light) {
        if (root == null) return;
        remapBackground(root, light);
        if (root instanceof TextView) remapText((TextView) root, light);
        if (root instanceof ViewGroup) {
            ViewGroup vg = (ViewGroup) root;
            for (int i = 0; i < vg.getChildCount(); i++) {
                apply(vg.getChildAt(i), light);
            }
        }
    }

    private static void remapBackground(View v, boolean light) {
        Drawable bgDrawable = v.getBackground();
        if (bgDrawable == null) return;
        Map<Integer, Integer> map = light ? BG_MAP : BG_MAP_REV;

        try {
            if (bgDrawable instanceof ColorDrawable) {
                ColorDrawable cd = (ColorDrawable) bgDrawable;
                Integer mapped = map.get(cd.getColor());
                if (mapped != null) v.setBackgroundColor(mapped);
            } else if (bgDrawable instanceof GradientDrawable) {
                GradientDrawable gd = (GradientDrawable) bgDrawable.mutate();
                android.content.res.ColorStateList csl = gd.getColor();
                if (csl != null) {
                    int current = csl.getDefaultColor();
                    Integer mapped = map.get(current);
                    if (mapped != null) gd.setColor(mapped);
                }
                android.content.res.ColorStateList strokeCsl = gd.getStrokeColor();
                if (strokeCsl != null) {
                    int current = strokeCsl.getDefaultColor();
                    Integer mapped = map.get(current);
                    if (mapped != null) gd.setStroke(2, mapped);
                }
                v.setBackground(gd);
            }
        } catch (Exception ignored) {
            // Selector/layer-list drawables (tab_selector, buttons) are left as-is —
            // their accent colors (cyan/green/red) are intentionally theme-independent.
        }
    }

    private static void remapText(TextView tv, boolean light) {
        Map<Integer, Integer> map = light ? TEXT_MAP : TEXT_MAP_REV;
        int current = tv.getCurrentTextColor();
        Integer mapped = map.get(current);
        if (mapped != null) tv.setTextColor(mapped);
    }

    /** Auto-apply theme to any child view added to this container later (dynamic cards, rows, etc.) */
    public static void autoTheme(final ViewGroup container, final ThemeState state) {
        container.setOnHierarchyChangeListener(new ViewGroup.OnHierarchyChangeListener() {
            @Override public void onChildViewAdded(View parent, View child) {
                apply(child, state.isLight());
            }
            @Override public void onChildViewRemoved(View parent, View child) { }
        });
    }

    /** Simple mutable holder so lambdas/listeners always read the live theme flag. */
    public static class ThemeState {
        private boolean light;
        public ThemeState(boolean light) { this.light = light; }
        public boolean isLight() { return light; }
        public void set(boolean light) { this.light = light; }
    }
}
