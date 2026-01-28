# Mac/iOS Setup Guide for FBLA Mobile App

## Prerequisites

1. **Mac Computer** with macOS
2. **Xcode** (free from Mac App Store)
3. **Flutter** installed on Mac
4. **iPhone** connected via USB
5. **Apple Developer Account** (free account works for testing on your own device)

---

## Step 1: Sync Code from GitHub on Mac

### Option A: Clone Repository (Fresh Start)
```bash
# Open Terminal on Mac
cd ~/Documents  # or wherever you want the project
git clone https://github.com/mokshkopikar/fbla_mobile_app.git
cd fbla_mobile_app
```

### Option B: Pull Latest Changes (If Already Cloned)
```bash
cd ~/path/to/fbla_mobile_app
git pull origin main
```

---

## Step 2: Install Flutter on Mac

### Check if Flutter is Installed
```bash
flutter --version
```

### If Not Installed:
1. Download Flutter SDK from: https://docs.flutter.dev/get-started/install/macos
2. Extract to a location (e.g., `~/development/flutter`)
3. Add to PATH:
   ```bash
   # Add to ~/.zshrc or ~/.bash_profile
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```
4. Reload shell: `source ~/.zshrc` (or `source ~/.bash_profile`)
5. Run: `flutter doctor`

---

## Step 3: Install Xcode

1. Open **Mac App Store**
2. Search for **"Xcode"**
3. Click **"Get"** or **"Install"** (it's free, but large ~12GB)
4. Wait for installation to complete
5. Open Xcode and accept license agreements
6. Install additional components when prompted

### Verify Xcode Installation
```bash
xcode-select --print-path
# Should show: /Applications/Xcode.app/Contents/Developer
```

---

## Step 4: Configure Flutter for iOS

### Run Flutter Doctor
```bash
cd ~/path/to/fbla_mobile_app
flutter doctor
```

### Fix Any Issues:
```bash
# Install CocoaPods (iOS dependency manager)
sudo gem install cocoapods

# Accept Xcode license
sudo xcodebuild -license accept

# Install iOS tools
flutter doctor --android-licenses  # Not needed for iOS, but good to have
```

### Verify iOS Setup
```bash
flutter doctor -v
# Should show:
# [✓] Xcode - develop for iOS and macOS
# [✓] CocoaPods version installed
```

---

## Step 5: Prepare iPhone for Testing

### Enable Developer Mode on iPhone:
1. Go to **Settings** → **Privacy & Security**
2. Scroll down to **Developer Mode**
3. Toggle **Developer Mode** ON
4. Restart iPhone when prompted

### Trust Your Computer:
1. Connect iPhone to Mac via USB
2. On iPhone, tap **"Trust This Computer"** when prompted
3. Enter your iPhone passcode

### Enable USB Debugging (Not needed, but helpful):
- iPhone will automatically trust the Mac after first connection

---

## Step 6: Get Dependencies

```bash
cd ~/path/to/fbla_mobile_app
flutter pub get
```

---

## Step 7: Build and Run on iPhone

### Check Connected Devices
```bash
flutter devices
# Should show your iPhone listed
```

### Run on iPhone
```bash
flutter run
# Or specify device:
flutter run -d <device-id>
```

### First Time Setup:
- Xcode will ask to sign the app
- You may need to:
  1. Open `ios/Runner.xcworkspace` in Xcode
  2. Select your iPhone as the target
  3. Go to **Signing & Capabilities** tab
  4. Select your **Team** (your Apple ID)
  5. Xcode will automatically create a provisioning profile

---

## Step 8: Troubleshooting

### Issue: "No devices found"
**Solution:**
```bash
# Check if iPhone is connected
system_profiler SPUSBDataType | grep -i iphone

# Trust computer on iPhone
# Settings → General → Reset → Reset Location & Privacy
# Then reconnect and trust again
```

### Issue: "Signing requires a development team"
**Solution:**
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Runner** project in left sidebar
3. Select **Runner** target
4. Go to **Signing & Capabilities** tab
5. Check **"Automatically manage signing"**
6. Select your **Team** (your Apple ID)
7. Xcode will handle the rest

### Issue: "CocoaPods not installed"
**Solution:**
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
```

### Issue: "Flutter doctor shows iOS issues"
**Solution:**
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Accept Xcode license
sudo xcodebuild -license accept

# Run flutter doctor again
flutter doctor
```

---

## Step 9: Build Release Version (Optional)

### For App Store Distribution (Later):
```bash
flutter build ios --release
```

### For Ad-Hoc Distribution:
```bash
flutter build ios --release --no-codesign
```

---

## Quick Reference Commands

```bash
# Check Flutter setup
flutter doctor

# Get dependencies
flutter pub get

# List connected devices
flutter devices

# Run on iPhone
flutter run

# Clean build
flutter clean
flutter pub get

# Build iOS app
flutter build ios
```

---

## Common Mac-Specific Notes

1. **Terminal**: Use Terminal.app (comes with macOS) or iTerm2
2. **Path**: Flutter is usually in `~/development/flutter` or `/usr/local/flutter`
3. **Permissions**: You may need to grant Terminal "Full Disk Access" in System Preferences
4. **Xcode Updates**: Keep Xcode updated for latest iOS SDK support

---

## Next Steps After Setup

1. ✅ Code synced from GitHub
2. ✅ Flutter installed and configured
3. ✅ Xcode installed
4. ✅ iPhone connected and trusted
5. ✅ App running on iPhone
6. 🎉 Test all features on iPhone!

---

## Need Help?

If you encounter issues:
1. Check `flutter doctor -v` output
2. Review Xcode error messages
3. Check iPhone connection in System Information
4. Verify Developer Mode is enabled on iPhone
5. Ensure you're signed in with Apple ID in Xcode

Good luck with your iOS testing! 🚀
