# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /home/hasegawa/Applications/android/sdk/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

-printconfiguration "build/outputs/mapping/configuration.txt"

-keepattributes LineNumberTable,SourceFile
-renamesourcefileattribute SourceFile


# https://github.com/Kotlin/kotlinx.coroutines/issues/1606#issuecomment-621626172
-keep class kotlinx.coroutines.android.** {*;}

# https://github.com/florent37/Flutter-AssetsAudioPlayer/issues/147
-keepclassmembernames class kotlinx.** {
    volatile <fields>;
}
-keepnames class kotlinx.** { *; }

# https://issuetracker.google.com/issues/192302100
-keepclassmembers class * extends androidx.constraintlayout.motion.widget.Key {
  public <init>();
}

# https://stackoverflow.com/questions/68044720/admob-android-messaging-platform-ump-sdk-app-crash
-keep class com.google.android.gms.internal.consent_sdk.** { <fields>; }
-keepattributes *Annotation*
-keepattributes Signature


# https://github.com/Kotlin/kotlinx.serialization

# Keep `Companion` object fields of serializable classes.
# This avoids serializer lookup through `getDeclaredClasses` as done for named companion objects.
#noinspection ShrinkerUnresolvedReference
-if @kotlinx.serialization.Serializable class **
-keepclassmembers class <1> {
    static <1>$Companion Companion;
}

# Keep `serializer()` on companion objects (both default and named) of serializable classes.
-if @kotlinx.serialization.Serializable class ** {
    static **$* *;
}
-keepclassmembers class <1>$<3> {
    #noinspection ShrinkerUnresolvedReference
    kotlinx.serialization.KSerializer serializer(...);
}

# Keep `INSTANCE.serializer()` of serializable objects.
-if @kotlinx.serialization.Serializable class ** {
    public static ** INSTANCE;
}
-keepclassmembers class <1> {
    public static <1> INSTANCE;
    #noinspection ShrinkerUnresolvedReference
    kotlinx.serialization.KSerializer serializer(...);
}

# @Serializable and @Polymorphic are used at runtime for polymorphic serialization.
-keepattributes RuntimeVisibleAnnotations,AnnotationDefault

# Serializer for classes with named companion objects are retrieved using `getDeclaredClasses`.
# If you have any, uncomment and replace classes with those containing named companion objects.
#-keepattributes InnerClasses # Needed for `getDeclaredClasses`.
#-if @kotlinx.serialization.Serializable class
#com.example.myapplication.HasNamedCompanion, # <-- List serializable classes with named companions.
#com.example.myapplication.HasNamedCompanion2
#{
#    static **$* *;
#}
#-keepnames class <1>$$serializer { # -keepnames suffices; class is kept when serializer() is kept.
#    static <1>$$serializer INSTANCE;
#}


# for GradientTrackSlider
-keepclassmembernames class com.google.android.material.slider.BaseSlider

# Timber
-assumenosideeffects class timber.log.Timber* {
#    public static *** v(...);
#    public static *** d(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}

# Performance tunings
-assumenosideeffects class kotlin.jvm.internal.Intrinsics {
    public static void checkExpressionValueIsNotNull(...);
    public static void checkNotNullExpressionValue(...);
    public static void checkReturnedValueIsNotNull(...);
    public static void checkFieldIsNotNull(...);
    public static void checkParameterIsNotNull(...);
    public static void checkNotNullParameter(...);
}

# https://tech.prog-8.com/entry/2021/03/25/080000
-assumenosideeffects class java.lang.String {
    public static java.lang.String format(...);
    public java.lang.String concat(java.lang.String);
}

-assumenosideeffects class kotlin.jvm.internal.Intrinsics {
    public static java.lang.String stringPlus(java.lang.String, java.lang.Object);
}
