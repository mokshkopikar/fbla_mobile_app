# Fix Chrome Build Error

## The Problem
OneDrive is locking files in the `build` directory, preventing Flutter from cleaning/rebuilding.

## Solution Steps

### Step 1: Pause OneDrive Sync
- Right-click OneDrive icon in system tray
- Pause syncing (choose duration)

### Step 2: Manually Delete Locked Directories
Run these commands in PowerShell:

```powershell
cd "c:\Users\Milind Kopikare\OneDrive\AI_projects\fbla_mobile_app"

# Close any programs that might be using these files (VS Code, Android Studio, etc.)

# Delete build directory
Remove-Item -Recurse -Force "build" -ErrorAction SilentlyContinue

# Delete .dart_tool if it's locked
Remove-Item -Recurse -Force ".dart_tool" -ErrorAction SilentlyContinue

# Wait a few seconds for OneDrive to release locks
Start-Sleep -Seconds 3
```

### Step 3: Clean Flutter Cache
```powershell
flutter clean
```

### Step 4: Get Dependencies
```powershell
flutter pub get
```

### Step 5: Run on Chrome
```powershell
flutter run -d chrome
```

## Alternative: Exclude Build Directory from OneDrive

If this keeps happening, you can exclude the `build` folder from OneDrive sync:

1. Right-click OneDrive icon → Settings
2. Go to "Sync and backup" → "Advanced settings"
3. Choose folders to sync
4. Or add `build/` to OneDrive's exclusion list

## If It Still Fails

Try building for web first, then running:
```powershell
flutter build web
flutter run -d chrome
```

Or use the Windows desktop target instead:
```powershell
flutter run -d windows
```
