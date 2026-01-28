# Git Sync Instructions (Windows)

## Current Issue
OneDrive is locking the `.git/index.lock` file, preventing git operations.

## Manual Steps to Sync Code

### Step 1: Remove Git Lock File

**Option A: Using File Explorer**
1. Navigate to: `C:\Users\Milind Kopikare\OneDrive\AI_projects\fbla_mobile_app\.git\`
2. Look for `index.lock` file
3. If it exists, delete it (you may need to close any programs using it first)

**Option B: Using PowerShell (Run as Administrator)**
```powershell
cd "C:\Users\Milind Kopikare\OneDrive\AI_projects\fbla_mobile_app"
Remove-Item ".git\index.lock" -Force -ErrorAction SilentlyContinue
```

**Option C: Pause OneDrive Temporarily**
1. Right-click OneDrive icon in system tray
2. Click "Pause syncing" → "2 hours"
3. Then try removing the lock file
4. Resume syncing after git operations complete

### Step 2: Stage All Changes

```powershell
cd "C:\Users\Milind Kopikare\OneDrive\AI_projects\fbla_mobile_app"
git add .
```

### Step 3: Commit Changes

```powershell
git commit -m "Add local caching for news and events, enhance accessibility features, add category filter and clear button to news feed"
```

### Step 4: Push to GitHub

```powershell
git push origin main
```

If prompted for credentials:
- Username: `mokshkopikar`
- Password: Use your Personal Access Token (PAT) instead of password
  - Create a token at: https://github.com/settings/tokens
  - Select scopes: `repo` (full control of private repositories)

### Alternative: Using GitHub Desktop

If command line continues to have issues:

1. **Download GitHub Desktop**: https://desktop.github.com/
2. **Open GitHub Desktop**
3. **Add Repository**: File → Add Local Repository
4. **Select**: `C:\Users\Milind Kopikare\OneDrive\AI_projects\fbla_mobile_app`
5. **Commit**: Write commit message and click "Commit to main"
6. **Push**: Click "Push origin" button

---

## What's Being Committed

### New Features:
- ✅ Local caching for News Feed
- ✅ Local caching for Event Calendar
- ✅ Category filter dropdown in News Feed
- ✅ Clear button (X) in News Feed search bar
- ✅ Persistent bottom navigation on Member Profile page
- ✅ Enhanced accessibility documentation

### New Files:
- `lib/features/news_feed/data/datasources/news_local_data_source.dart`
- `lib/features/event_calendar/data/datasources/event_local_data_source.dart`
- `test/features/news_feed/data/datasources/news_local_data_source_test.dart`
- `test/features/event_calendar/data/datasources/event_local_data_source_test.dart`
- `test/features/news_feed/data/repositories/news_repository_cache_test.dart`
- `docs/ACCESSIBILITY_FOR_JUDGES.md`
- `docs/CACHING_IMPLEMENTATION_SUMMARY.md`
- `docs/MAC_IOS_SETUP.md`
- And more documentation files

### Modified Files:
- Repository implementations (cache-first strategy)
- Dependency injection setup
- Test suite updates
- UI enhancements (news feed, member profile)

---

## Verify Sync on Mac

After pushing, on your Mac:

```bash
cd ~/path/to/fbla_mobile_app
git pull origin main
```

This will download all the latest changes including the caching implementation.

---

## Troubleshooting

### If lock file persists:
1. Close all programs (VS Code, Cursor, etc.)
2. Pause OneDrive syncing
3. Restart computer
4. Try again

### If push fails with authentication:
1. Use Personal Access Token instead of password
2. Or set up SSH keys for authentication

### If you get merge conflicts:
```powershell
git pull origin main
# Resolve conflicts if any
git add .
git commit -m "Resolve merge conflicts"
git push origin main
```

---

## Quick One-Liner (After Removing Lock File)

```powershell
cd "C:\Users\Milind Kopikare\OneDrive\AI_projects\fbla_mobile_app" ; git add . ; git commit -m "Add local caching, accessibility enhancements, and UI improvements" ; git push origin main
```

Good luck! 🚀
