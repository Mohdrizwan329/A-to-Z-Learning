# R8 runs over the release build, and anything reached only by reflection is
# invisible to it. Each block below names a library that looks up its own
# classes by name at runtime and would otherwise crash only on a real device.

# ML Kit loads the text-recognition model through a reflective registry.
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**
# The Flutter plugin compiles against the Chinese/Devanagari/Japanese/Korean
# models, which the app no longer bundles because it only scans Latin script.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**

# Firebase and Play Services read annotated fields off model classes.
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# flutter_local_notifications serialises every scheduled alarm through Gson, so
# a renamed field means the alarms silently stop firing after a reboot.
-keep class com.dexterous.** { *; }
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}
-keepattributes Signature, InnerClasses, EnclosingMethod
-keepattributes RuntimeVisibleAnnotations, RuntimeVisibleParameterAnnotations
-dontwarn com.google.gson.**

# Flutter's own deferred-components hooks reference Play Core, which a plain
# APK build does not ship.
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Keeps the line numbers in a release crash report readable.
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
