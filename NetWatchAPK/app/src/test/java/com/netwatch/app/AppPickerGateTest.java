package com.netwatch.app;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.robolectric.Shadows.shadowOf;

import android.content.ComponentName;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Looper;
import android.widget.Spinner;

import androidx.test.core.app.ApplicationProvider;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.annotation.Config;
import org.robolectric.shadows.ShadowPackageManager;

import java.util.ArrayList;
import java.util.List;

/**
 * Locks down each exclusion gate in the Traffic picker so a change to filtering
 * cannot silently add or drop a category of application.
 */
@RunWith(RobolectricTestRunner.class)
@Config(sdk = 34)
public class AppPickerGateTest {

    private static void install(String pkg, int flags, boolean launcher) {
        ShadowPackageManager spm = shadowOf(
                ApplicationProvider.getApplicationContext().getPackageManager());
        ApplicationInfo ai = new ApplicationInfo();
        ai.packageName = pkg;
        ai.flags = flags;
        ai.uid = 10100 + Math.abs(pkg.hashCode() % 500);
        PackageInfo pi = new PackageInfo();
        pi.packageName = pkg;
        pi.applicationInfo = ai;
        spm.installPackage(pi);
        if (launcher) {
            ComponentName cn = new ComponentName(pkg, pkg + ".Main");
            spm.addActivityIfNotPresent(cn);
            IntentFilter f = new IntentFilter(Intent.ACTION_MAIN);
            f.addCategory(Intent.CATEGORY_LAUNCHER);
            spm.addIntentFilterForActivity(cn, f);
        }
    }

    private static List<String> pickerPackages() throws Exception {
        MainActivity activity = Robolectric.buildActivity(MainActivity.class).setup().get();
        for (int i = 0; i < 40; i++) {
            Thread.sleep(50);
            shadowOf(Looper.getMainLooper()).idle();
        }
        Spinner spinner = activity.findViewById(R.id.appSpinner);
        assertTrue("adapter must be installed", spinner.getAdapter() != null);
        List<String> pkgs = new ArrayList<>();
        for (int i = 0; i < spinner.getAdapter().getCount(); i++) {
            Object item = spinner.getAdapter().getItem(i);
            if (item instanceof AppEntry) pkgs.add(((AppEntry) item).packageName);
        }
        return pkgs;
    }

    @Test
    public void normalUserAppIsShown() throws Exception {
        install("com.example.normal", 0, true);
        assertTrue(pickerPackages().contains("com.example.normal"));
    }

    @Test
    public void updatedSystemAppIsShown() throws Exception {
        install("com.example.updatedsys",
                ApplicationInfo.FLAG_SYSTEM | ApplicationInfo.FLAG_UPDATED_SYSTEM_APP, true);
        assertTrue(pickerPackages().contains("com.example.updatedsys"));
    }

    @Test
    public void plainSystemAppIsExcluded() throws Exception {
        install("com.example.sysonly", ApplicationInfo.FLAG_SYSTEM, true);
        assertFalse(pickerPackages().contains("com.example.sysonly"));
    }

    @Test
    public void appWithoutLauncherIsExcluded() throws Exception {
        install("com.example.nolauncher", 0, false);
        assertFalse(pickerPackages().contains("com.example.nolauncher"));
    }

    @Test
    public void frameworkPrefixIsExcluded() throws Exception {
        install("com.android.settings", 0, true);
        assertFalse(pickerPackages().contains("com.android.settings"));
    }
}
