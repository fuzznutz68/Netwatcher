package com.netwatch.app;

import static org.junit.Assert.assertNotNull;

import androidx.test.core.app.ApplicationProvider;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.annotation.Config;

@RunWith(RobolectricTestRunner.class)
@Config(sdk = 34)
public class TrafficTabStartupTest {

    @Test
    public void trafficTabLaunchesWithoutCrash() {
        MainActivity activity = Robolectric.buildActivity(MainActivity.class)
                .setup()
                .get();
        assertNotNull(activity);
    }
}
