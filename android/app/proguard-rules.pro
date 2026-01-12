# Keep generic type information
-keepattributes Signature

# Keep Flutter Local Notifications classes
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Keep Gson classes (often used internally and affected by R8)
-keep class com.google.gson.** { *; }

# General Flutter rules (usually handled automatically but good to have)
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Suppress warnings for missing classes (common with R8)
-dontwarn com.google.android.play.core.**
-dontwarn com.dexterous.flutterlocalnotifications.**
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**
-dontwarn androidx.media3.**
-dontwarn com.google.errorprone.annotations.**
