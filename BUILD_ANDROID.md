# Quick Start: Build Android APK

## Quick Commands

### 1. Check for Android Devices
```bash
flutter devices
```

### 2. Build Debug APK (For Testing)
```bash
flutter build apk --debug
```
**Output:** `build/app/outputs/flutter-apk/app-debug.apk`

### 3. Build Release APK (For Competition)
```bash
flutter build apk --release
```
**Output:** `build/app/outputs/flutter-apk/app-release.apk`

### 4. Run on Connected Device/Emulator
```bash
flutter run
```

## Testing Options

### Option 1: Android Emulator
1. Open **Android Studio**
2. **Tools > Device Manager > Create Device**
3. Select device (e.g., Pixel 5) and system image
4. Start emulator
5. Run `flutter run`

### Option 2: Physical Android Device
1. Enable **Developer Options** (tap Build Number 7 times)
2. Enable **USB Debugging**
3. Connect via USB
4. Run `flutter run`

### Option 3: Install APK Manually
1. Build APK: `flutter build apk --release`
2. Transfer `app-release.apk` to phone
3. Enable "Install from Unknown Sources"
4. Install APK

## App Configuration

- **Package Name:** `com.fbla.future_engagement`
- **App Name:** FBLA Future Engagement
- **Version:** 1.0.0+1

## Troubleshooting

**No devices found?**
- Install Android Studio
- Start emulator or connect physical device
- Run `flutter doctor` to check setup

**Build fails?**
- Run `flutter clean`
- Run `flutter pub get`
- Check `flutter doctor` for issues

---

See `ANDROID_SETUP.md` for detailed instructions.
