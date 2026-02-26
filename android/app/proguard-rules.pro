# Keep generic type information
-keepattributes Signature

# Keep Flutter Local Notifications classes
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Keep Gson classes (often used internally and affected by R8)
-keep class com.google.gson.** { *; }

# General Flutter rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# RevenueCat / Purchases rules
-keep class com.revenuecat.purchases.** { *; }
-keep class com.revenuecat.purchases.common.** { *; }

# Suppress warnings for missing classes
-dontwarn com.google.android.play.core.**
-dontwarn com.dexterous.flutterlocalnotifications.**
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**
-dontwarn androidx.media3.**
-dontwarn com.google.errorprone.annotations.**
-dontwarn com.revenuecat.**


# Firebase (General Safety)
-keep class com.google.firebase.** { *; }
