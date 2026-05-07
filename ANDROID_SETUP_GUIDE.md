# Android Setup Guide for LungScan+ 

## Current Status

✅ **Flutter SDK**: Installed and Working (v3.29.1)  
✅ **Dart SDK**: Installed (v3.7.0)  
✅ **Project Dependencies**: Downloaded via `flutter pub get`  
❌ **Android SDK**: NOT Installed  
❌ **Android Studio**: NOT Installed  
❌ **Firebase**: NOT Configured  

---

## Prerequisites

Before running the app on Android, you need to install:

### 1. **Android Studio** (Required)
   - Download from: https://developer.android.com/studio
   - Install to default location
   - On first launch, it will help install Android SDK

### 2. **Android SDK Components** (Automatic with Android Studio)
   - Android SDK Platform API 33 or higher
   - Android SDK Build-Tools
   - Android SDK Platform-Tools

### 3. **Java Development Kit (JDK)**
   - Required for Android development
   - Android Studio includes bundled JDK

---

## Step-by-Step Setup for Android

### Step 1: Install Android Studio

1. Download Android Studio from https://developer.android.com/studio
2. Run the installer and follow the setup wizard
3. Accept the default installation path (usually `C:\Program Files\Android\Android Studio`)
4. On first launch, Android Studio will prompt to install Android SDK components
   - Accept all default installations

### Step 2: Configure Flutter to Use Android SDK

After Android Studio installation, configure Flutter:

```bash
# Set Android SDK path (usually automatic, but verify with)
flutter config --android-sdk "C:\Program Files\Android\Android Studio\Sdk"

# Verify Android setup
flutter doctor
```

### Step 3: Create Android Virtual Device (Emulator)

In Android Studio:
1. Open **Tools → Device Manager**
2. Click **Create Device**
3. Select a device (e.g., Pixel 4)
4. Select API Level (recommend API 30+)
5. Click **Finish**

Or use command line:
```bash
flutter emulators --create --name lung_scan_emulator
flutter emulators --launch lung_scan_emulator
```

### Step 4: Accept Android Licenses

```bash
flutter doctor --android-licenses
```

---

## Firebase Configuration for Android

### Step 1: Firebase Project Setup

1. Go to https://console.firebase.google.com
2. Create a new project (or use existing)
3. Add Android app to your Firebase project:
   - Package name: `com.example.lung_scan_new` (or your app's package name)
   - App nickname: `LungScan+ Android`
   - SHA-1 fingerprint (see below)

### Step 2: Get SHA-1 Fingerprint

Run this command to get your signing certificate fingerprint:

```bash
# For debug builds:
cd android
./gradlew signingReport
# or on Windows:
gradlew.bat signingReport
```

Copy the SHA-1 from the output and add it to Firebase console.

### Step 3: Download google-services.json

1. In Firebase console, download `google-services.json`
2. Place it in: `android/app/google-services.json`
3. Verify file exists:
   ```bash
   ls android/app/google-services.json
   ```

### Step 4: Configure Firebase in pubspec.yaml

Verify these dependencies are in `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^3.15.1
  firebase_auth: ^5.6.2
  cloud_firestore: ^5.6.11
```

### Step 5: Update Android Build Configuration

Edit `android/app/build.gradle`:

```gradle
plugins {
    id 'com.android.application'
    id 'com.google.gms.google-services'  // Add this line
}

dependencies {
    // Firebase dependencies are handled by Flutter plugins
}
```

Edit `android/build.gradle`:

```gradle
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'  // Add this
    }
}
```

---

## Running the App on Android

### Option 1: Run on Android Emulator

```bash
# Start emulator
flutter emulators --launch lung_scan_emulator

# Wait for emulator to fully load, then run app
flutter run

# Or explicitly:
flutter run -d emulator-5554
```

### Option 2: Run on Physical Android Device

1. Enable Developer Mode on your Android phone:
   - Settings → About → Build Number (tap 7 times)
   - Settings → Developer Options → Enable USB Debugging
2. Connect phone via USB cable
3. Authorize USB debugging on phone
4. Run:
   ```bash
   flutter devices  # Verify phone is listed
   flutter run
   ```

### Option 3: Build APK for Installation

```bash
# Build debug APK
flutter build apk

# Build release APK
flutter build apk --release

# APK location: build/app/outputs/flutter-apk/app-debug.apk
```

---

## Common Android Setup Issues

### Issue: "Android SDK not found"

**Solution:**
```bash
flutter config --android-sdk "C:\Program Files\Android\Android Studio\Sdk"
flutter doctor
```

### Issue: "Android toolchain not available"

**Solution:**
```bash
flutter doctor --android-licenses  # Accept all licenses
flutter pub get
flutter clean
```

### Issue: "Gradle build failed"

**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: Firebase initialization error at runtime

**Solution:**
1. Verify `google-services.json` is in correct location: `android/app/google-services.json`
2. Rebuild app: `flutter clean && flutter pub get && flutter run`
3. Check Firebase console for correct package name

### Issue: Google Play Services not available

**Solution:**
- This occurs if using emulator without Google Play
- Create emulator image with "Google Play" version included
- Or use physical device

---

## Alternative: Run on Windows (No Android Required)

If Android setup is too complex, you can run the app on Windows:

```bash
flutter run -d windows
```

**Note:** Some features may not work on Windows (like location services, device-specific sensors). For full functionality, use Android.

---

## Verify Android Setup

```bash
# Full diagnostic report
flutter doctor -v

# Check connected devices
flutter devices

# List available emulators
flutter emulators

# Run tests
flutter test
```

---

## Next Steps

1. ✅ Install Android Studio
2. ✅ Create Android Virtual Device
3. ✅ Download and configure `google-services.json`
4. ✅ Accept Android licenses
5. ✅ Run `flutter doctor` to verify all green
6. ✅ Launch emulator and run the app

---

## Support

For more information:
- [Flutter Android Setup](https://flutter.dev/docs/get-started/install/windows#android-setup)
- [Firebase Setup for Flutter](https://firebase.flutter.dev/docs/overview/)
- [Android Studio Documentation](https://developer.android.com/studio/intro)

---

**Generated**: May 7, 2026
