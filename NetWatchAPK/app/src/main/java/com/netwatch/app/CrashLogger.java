package com.netwatch.app;

import android.content.Context;
import android.util.Log;

import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Date;

/**
 * Diagnostic aid for the v2.10.2-P0 regression investigation.
 *
 * Writes the full stack trace of any uncaught exception to
 *   Android/data/com.netwatch.net/files/crash_last.txt
 * and to logcat under the "NetWatchCrash" tag, then delegates to the previous
 * handler so platform crash reporting/behaviour is unchanged.
 *
 * Contains no user data beyond the trace itself.
 */
public final class CrashLogger {

    private CrashLogger() { }

    public static void install(final Context appCtx) {
        final Thread.UncaughtExceptionHandler previous =
                Thread.getDefaultUncaughtExceptionHandler();

        Thread.setDefaultUncaughtExceptionHandler((thread, error) -> {
            try {
                StringWriter sw = new StringWriter();
                error.printStackTrace(new PrintWriter(sw));
                String body = "time: " + new Date() + "\n"
                        + "thread: " + thread.getName() + "\n"
                        + "device: " + android.os.Build.MANUFACTURER + " "
                        + android.os.Build.MODEL + " / API " + android.os.Build.VERSION.SDK_INT + "\n\n"
                        + sw;

                Log.e("NetWatchCrash", body);

                File dir = appCtx.getExternalFilesDir(null);
                if (dir == null) dir = appCtx.getFilesDir();
                long now = System.currentTimeMillis();
                try (FileWriter w = new FileWriter(new File(dir, "crash_last.txt"))) {
                    w.write(body);
                }
                try (FileWriter w = new FileWriter(new File(dir, "crash_" + now + ".txt"))) {
                    w.write(body);
                }
            } catch (Throwable ignored) { }

            if (previous != null) previous.uncaughtException(thread, error);
        });
    }
}
