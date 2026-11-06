package com.netwatch.app;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.robolectric.Shadows.shadowOf;

import android.content.ComponentName;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ApplicationInfo;
import android.os.Looper;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.annotation.Config;
import org.robolectric.shadows.ShadowPackageManager;

@RunWith(RobolectricTestRunner.class)
@Config(sdk = 34)
public class AppEnumerationTest {

    private void addLaunchableApp(ShadowPackageManager spm, String pkg, String label, int uid) {
        ApplicationInfo ai = new ApplicationInfo();
        ai.packageName = pkg;
        ai.uid = uid;
        ai.flags = 0;
        ai.nonLocalizedLabel = label;
        android.content.pm.PackageInfo pi = new android.content.pm.PackageInfo();
        pi.packageName = pkg;
        pi.applicationInfo = ai;
        spm.installPackage(pi);

        ComponentName cn = new ComponentName(pkg, pkg + ".Main");
        spm.addActivityIfNotPresent(cn);
        IntentFilter filter = new IntentFilter(Intent.ACTION_MAIN);
        filter.addCategory(Intent.CATEGORY_LAUNCHER);
        spm.addIntentFilterForActivity(cn, filter);
    }

    @Test
    public void enumeratesUserAppsIntoTrafficPicker() throws Exception {
        ShadowPackageManager spm = shadowOf(
                androidx.test.core.app.ApplicationProvider.getApplicationContext()
                        .getPackageManager());

        addLaunchableApp(spm, "com.example.alpha", "Alpha", 10001);
        addLaunchableApp(spm, "com.example.beta",  "Beta",  10002);
        addLaunchableApp(spm, "com.example.gamma", "Gamma", 10003);

        MainActivity activity = Robolectric.buildActivity(MainActivity.class)
                .setup().get();
        assertNotNull(activity);

        for (int i = 0; i < 40; i++) {
            Thread.sleep(50);
            shadowOf(Looper.getMainLooper()).idle();
        }

        android.widget.Spinner spinner = activity.findViewById(R.id.appSpinner);
        assertNotNull(spinner);
        assertNotNull("adapter should be installed", spinner.getAdapter());
        // The app under test is itself installed and launchable, so expect our three
        // fakes plus at least com.netwatch.net.
        int installed = androidx.test.core.app.ApplicationProvider
                .getApplicationContext().getPackageManager()
                .getInstalledApplications(0).size();
        assertEquals("traffic picker should contain every user app",
                installed, spinner.getAdapter().getCount());
        assertTrue(spinner.getAdapter().getCount() >= 3);
    }
}
