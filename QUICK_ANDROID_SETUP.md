# Quick Android SDK Setup - For Connected Device

## Problem
Your Android device is **physically connected**, but Flutter cannot detect it because **Android SDK is not installed**.

## Solution - Quick Install (5 minutes)

### Option A: Use Android Studio (Recommended - Easiest)

#### Step 1: Download Android Studio
```
https://developer.android.com/studio
```

#### Step 2: Run Installer
- Download and run the .exe file
- Select default installation path
- Complete the wizard

#### Step 3: First Launch Setup
- Android Studio will prompt to install Android SDK
- Accept all defaults
- Wait for SDK installation (~5-10 minutes)

#### Step 4: Verify Flutter Detects Device
```bash
d:\flutter\bin\flutter.bat devices
```

Your device should now appear in the list!

---

### Option B: Command-Line Tools Only (Faster - 2 minutes)

If you prefer not to install Android Studio:

#### Step 1: Download Command-Line Tools
- Go to: https://developer.android.com/studio
- Scroll to "Command line tools only"
- Download for Windows

#### Step 2: Extract to Correct Location
```bash
# Create directory
mkdir "%USERPROFILE%\AppData\Local\Android\Sdk"

# Extract downloaded zip to:
# %USERPROFILE%\AppData\Local\Android\cmdline-tools
```

#### Step 3: Configure Flutter
```bash
d:\flutter\bin\flutter.bat config --android-sdk "%USERPROFILE%\AppData\Local\Android\Sdk"
```

#### Step 4: Accept Licenses
```bash
d:\flutter\bin\flutter.bat doctor --android-licenses
# (Type 'y' to accept all licenses)
```

#### Step 5: Verify
```bash
d:\flutter\bin\flutter.bat devices
```

---

## Verify Connection

Once SDK is installed, run:

```bash
# Check if device appears
d:\flutter\bin\flutter.bat devices

# Full diagnostic
d:\flutter\bin\flutter.bat doctor -v
```

Expected output:
```
Found 3 connected devices:
  Windows (desktop) • windows • windows-x64    
  Edge (web)        • edge    • web-javascript 
  SM-XXXXXXXXX (mobile) • DEVICE_ID • android-arm64
```

---

## Run App on Connected Android Device

Once device is detected:

```bash
cd d:\Android\lung_scan_new

# Run on Android device
d:\flutter\bin\flutter.bat run

# Or explicitly specify device
d:\flutter\bin\flutter.bat run -d DEVICE_ID
```

---

## Firebase Configuration (Important!)

Before running on Android, configure Firebase:

### Step 1: Add google-services.json
```
Location: android/app/google-services.json
Status: ⚠️ MISSING - App will crash without it
```

### Step 2: Get Firebase Configuration
1. Go to: https://console.firebase.google.com
2. Create/Select your project
3. Add Android app:
   - Package name: `com.example.lung_scan_new`
   - SHA-1 fingerprint (get via: `cd android && ./gradlew signingReport`)
4. Download `google-services.json`
5. Place in `android/app/google-services.json`

### Step 3: Enable Required Firebase Features
- ✅ Authentication (Email/Password)
- ✅ Cloud Firestore  
- ✅ Storage (optional)

---

## Troubleshooting

### "Device not detected after SDK install"
```bash
# Reconnect device via USB
# Restart Android Debug Bridge
d:\flutter\bin\flutter.bat clean
d:\flutter\bin\flutter.bat pub get
d:\flutter\bin\flutter.bat devices --device-timeout 15
```

### "No Permission / Device Offline"
- On phone: Settings → Developer Options → Authorize USB Debugging
- Revoke USB debug authorizations and reconnect
- Try different USB port or cable

### "gradle build failed"
```bash
cd android
./gradlew clean
cd ..
d:\flutter\bin\flutter.bat clean
d:\flutter\bin\flutter.bat pub get
d:\flutter\bin\flutter.bat run
```

### "firebase_core not initialized"
- Verify `google-services.json` is in `android/app/`
- Check package name matches
- Rebuild: `flutter clean && flutter pub get && flutter run`

---

## Quick Commands Checklist

```bash
# 1. Verify device connection
d:\flutter\bin\flutter.bat devices

# 2. Check all requirements
d:\flutter\bin\flutter.bat doctor -v

# 3. Get latest dependencies
d:\flutter\bin\flutter.bat pub get

# 4. Clean build (if issues)
d:\flutter\bin\flutter.bat clean

# 5. Run on connected device
d:\flutter\bin\flutter.bat run

# 6. Build APK for distribution
d:\flutter\bin\flutter.bat build apk

# 7. Build release APK
d:\flutter\bin\flutter.bat build apk --release
```

---

## Expected Timeline

- **Android Studio Install**: 15-20 minutes
- **First App Run**: 5-10 minutes (includes build)
- **Subsequent Runs**: 2-3 minutes

---

## Alternative: Windows Desktop (No SDK Needed!)

If Android setup takes too long, test on Windows first:

```bash
d:\flutter\bin\flutter.bat run -d windows
```

Then migrate to Android once you've verified the app works.

---

**Status**: Android device connected but SDK not detected  
**Next Step**: Install Android Studio or Command-Line Tools  
**Time to Resolution**: 15-20 minutes
