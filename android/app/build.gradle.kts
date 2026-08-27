plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.jiyanlearning.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.2.13676358"
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.jiyanlearning.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // The app has no translations, so the ~80 locale folders that ship
        // inside Play Services and AndroidX are dead weight in the APK.
        resourceConfigurations += listOf("en")
        ndk {
            // Every real Android phone and tablet is ARM. x86_64 exists only for
            // Intel emulators, and it was carrying a third copy of the Flutter
            // engine and the ML Kit OCR pipeline -- 36 MB no device would load.
            abiFilters += listOf("arm64-v8a", "armeabi-v7a")
        }
    }

    packaging {
        jniLibs {
            // AGP stores .so files uncompressed so they can be mapped straight
            // out of the APK. That trades ~40 MB of download for a little disk
            // on install, which is the wrong way round for an APK that gets
            // shared directly rather than served by the Play Store.
            useLegacyPackaging = true
            // The ML Kit and DataStore AARs smuggle x86_64 copies past the
            // abiFilters below, because those only bind the libraries Flutter
            // itself builds.
            excludes += listOf("**/x86/*.so", "**/x86_64/*.so")
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
                        // Enable R8 + ProGuard rules
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

        }
    }
}

flutter {
    source = "../.."
}
dependencies {
    // Core library desugaring for flutter_local_notifications
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    // Core OCR. Only the Latin model is bundled: every TextRecognizer the app
    // builds is the default one, so the Chinese, Devanagari, Japanese and
    // Korean models were ~16 MB of never-loaded weights.
    implementation("com.google.mlkit:text-recognition:16.0.1")
    implementation(platform("com.google.firebase:firebase-bom:34.7.0"))
    implementation("com.google.firebase:firebase-analytics")
}

