Firebase setup for Sandwich Shop

This document walks through the steps to finish integrating Firebase into this Flutter project.

Overview
- We added `firebase_core`, `firebase_auth`, `cloud_firestore`, and `firebase_analytics` to `pubspec.yaml` and initialized Firebase in `lib/main.dart`.
- Next you must register apps in your Firebase project and add platform configuration files.
- Using the FlutterFire CLI automates generating `lib/firebase_options.dart`. We included a stub file so the app compiles before you run the CLI.

1) Choose Firebase services
- Authentication, Firestore, Analytics are already included as packages.
- If you want Cloud Messaging, Storage, or others, add the corresponding packages to `pubspec.yaml`.

2) Install FlutterFire CLI (recommended)
- Install the CLI globally (you only need to run this once):

```powershell
dart pub global activate flutterfire_cli
```

- Make sure `~/.dart_tool/bin` (Windows: `%USERPROFILE%\.pub-cache\bin`) is on your PATH so `flutterfire` is available.

3) Configure your Firebase project with FlutterFire CLI (recommended)
- From the project root run:

```powershell
flutterfire configure
```

- The cli will open a browser to sign in, ask you to pick a Firebase project and platforms, and then generate `lib/firebase_options.dart` with `DefaultFirebaseOptions`.
- After that step, `lib/main.dart` uses `DefaultFirebaseOptions.currentPlatform` to initialize Firebase automatically.

4) Manual platform configuration (if you prefer not to use the CLI)

Android
- Register an Android app in the Firebase console using your package name (`com.example.sandwich_shop` per `android/app/build.gradle.kts`).
- Download the generated `google-services.json` and place it at: `android/app/google-services.json`.
- For Gradle Kotlin DSL projects (this repo uses `build.gradle.kts`) add the Google services plugin to the `plugins` block of `android/app/build.gradle.kts`:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    // Add the Google services plugin (apply it LAST)
    id("com.google.gms.google-services")
}
```

- Add the Google services Gradle classpath to the top-level `build.gradle.kts`. Add the `dependencies` block to `buildscript` (Kotlin DSL example):

```kotlin
buildscript {
  repositories {
    google()
    mavenCentral()
  }
  dependencies {
    classpath("com.google.gms:google-services:4.3.15")
  }
}
```

(If your project uses Groovy `build.gradle`, the equivalent lines are well documented in the Firebase console.)

iOS
- Register an iOS app in Firebase and download `GoogleService-Info.plist`.
- In Xcode: open `ios/Runner.xcworkspace`, drag `GoogleService-Info.plist` into `Runner` (ensure "Copy items if needed" is checked and add to Runner target).
- Ensure `platform :ios, '11.0'` (or newer) in `ios/Podfile` if you see compatibility warnings. Then run:

```bash
cd ios
pod install
```

Web
- Register a Web app in Firebase; copy the Firebase config (apiKey, authDomain, etc.).
- Add it to `web/index.html` inside a script tag or use `flutterfire configure` which handles this.

5) Verify setup
- If you used `flutterfire configure`, rebuild the app and run it on your desired device. Example for windows:

```powershell
flutter devices
# pick a device id from above
flutter run -d <device-id>
```

- Watch the console for Firebase initialization messages. `lib/main.dart` prints initialization errors if config is missing.

6) Optional: CI
- For CI, store the generated `firebase_options.dart` securely (it contains non-secret config) or use environment-based setups depending on the platform.

7) Common troubleshooting
- Error: "Firebase.initializeApp() failed: ..." → you likely missed adding the platform config files or `firebase_options.dart`.
- Android build errors about `google-services` → ensure classpath is present in the top-level Gradle script and plugin is applied in `app` module.

If you want, I can attempt to automatically add the Gradle `classpath` lines and the plugin id to the Kotlin DSL files, or I can open a PR with these changes after you confirm.
