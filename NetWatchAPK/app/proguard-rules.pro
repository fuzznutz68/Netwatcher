# Keep all NetWatch app classes
-keep class com.netwatch.app.** { *; }

# Keep JSON classes
-keep class org.json.** { *; }

# Keep AndroidX and Material components
-keep class androidx.** { *; }
-keep class com.google.android.material.** { *; }

# Keep VPN service
-keep class * extends android.net.VpnService { *; }

# Keep broadcast receivers
-keep class * extends android.content.BroadcastReceiver { *; }

# Keep services
-keep class * extends android.app.Service { *; }

# Suppress warnings for unused classes
-dontwarn kotlin.**
-dontwarn kotlinx.**

# Strip kotlin metadata to reduce size further
-dontwarn kotlin.jvm.internal.**
-assumenosideeffects class kotlin.jvm.internal.Intrinsics {
    static void checkParameterIsNotNull(java.lang.Object, java.lang.String);
    static void checkNotNullParameter(java.lang.Object, java.lang.String);
}
