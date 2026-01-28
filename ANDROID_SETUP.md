# Android APK Build & Testing Guide

## Prerequisites

1. **Android Studio** - Download from https://developer.android.com/studio
2. **Android SDK** - Installed via Android Studio
3. **Flutter SDK** - Already installed ✓

## Step 1: Verify Flutter Android Setup

Run this command to check your setup:
```bash
flutter doctor
```

You should see:
- ✅ Flutter (Channel stable)
- ✅ Android toolchain (Android SDK)
- ✅ Android Studio (if installed)

## Step 2: Check Available Devices

List available Android devices/emulators:
```bash
flutter devices
```

**Options for Testing:**

### Option A: Android Emulator (Recommended for Development)
1. Open **Android Studio**
2. Go to **Tools > Device Manager**
3. Click **Create Device**
4. Select a device (e.g., Pixel 5)
5. Download a system image (e.g., Android 13)
6. Click **Finish**
7. Start the emulator
8. Run `flutter devices` to see it listed

### Option B: Physical Android Device
1. Enable **Developer Options** on your Android phone:
   - Go to Settings > About Phone
   - Tap "Build Number" 7 times
2. Enable **USB Debugging**:
   - Settings > Developer Options > USB Debugging (ON)
3. Connect phone via USB
4. Accept the USB debugging prompt on your phone
5. Run `flutter devices` to see it listed

## Step 3: Build APK

### Debug APK (For Testing)
```bash
cd "c:\Users\Milind Kopikare\OneDrive\AI_projects\fbla_mobile_app"
flutter build apk --debug
```

**Output location:** `build/app/outputs/flutter-apk/app-debug.apk`

### Release APK (For Competition/Distribution)
```bash
flutter build apk --release
```

**Output location:** `build/app/outputs/flutter-apk/app-release.apk`

**Note:** Release APK is smaller and optimized, but requires signing for Play Store distribution.

## Step 4: Install & Test on Device

### Method 1: Direct Install via Flutter
```bash
flutter install
```
This will install the app on the connected device/emulator.

### Method 2: Install APK Manually
1. Transfer the APK file to your Android device
2. On your device, go to Settings > Security
3. Enable "Install from Unknown Sources" (or "Install Unknown Apps")
4. Open the APK file and tap "Install"

### Method 3: Run Directly
```bash
flutter run
```
This builds and runs the app directly on the connected device/emulator.

## Step 5: Test All Features

Once the app is installed, test:

1. **Profile Tab** - Test validation (try grade level 8 or 13)
2. **News Search** - Search for "Leadership"
3. **Event Filtering** - Filter by "National"
4. **Reminder Feature** - Tap alarm icon on events
5. **Social Share** - Test share functionality
6. **Resources** - Open resource links
7. **Navigation** - Switch between all tabs

## Troubleshooting

### "No devices found"
- Make sure Android Studio is installed
- Start an emulator or connect a physical device
- Run `flutter devices` to verify

### Build Errors
- Run `flutter clean` then `flutter pub get`
- Make sure Android SDK is properly installed
- Check `flutter doctor` for issues

### APK Installation Failed
- Enable "Install from Unknown Sources" on device
- Check device storage space
- Try uninstalling any previous version first

## For Competition

**Recommended APK:** Use `app-release.apk` for the competition demo.

**File Size:** Should be reasonable (typically 20-50 MB for Flutter apps)

**Testing Checklist:**
- ✅ App installs successfully
- ✅ All 5 features work correctly
- ✅ Navigation is smooth
- ✅ Validation works (profile)
- ✅ Search works (news, resources)
- ✅ Share functionality works
- ✅ App works offline (mock data)

## Next Steps

After successful Android testing, you can:
1. Test on multiple Android devices/versions
2. Build for iOS (requires macOS)
3. Prepare for competition presentation

---

**App Details:**
- **Package Name:** `com.fbla.future_engagement`
- **App Name:** FBLA Future Engagement
- **Version:** 1.0.0+1
