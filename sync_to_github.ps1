# Git Sync Script for FBLA Mobile App
# Run this in PowerShell (Run as Administrator if needed)

Write-Host "Starting Git Sync..." -ForegroundColor Green

# Navigate to project directory
$projectPath = "C:\Users\Milind Kopikare\OneDrive\AI_projects\fbla_mobile_app"
Set-Location $projectPath

# Step 1: Remove lock file
Write-Host "`nStep 1: Removing git lock file..." -ForegroundColor Yellow
if (Test-Path ".git\index.lock") {
    try {
        Remove-Item ".git\index.lock" -Force
        Write-Host "Lock file removed successfully." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Could not remove lock file. Please close all programs and try again." -ForegroundColor Red
        Write-Host "Or manually delete: $projectPath\.git\index.lock" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "No lock file found. Continuing..." -ForegroundColor Green
}

# Wait a moment
Start-Sleep -Seconds 1

# Step 2: Stage all changes
Write-Host "`nStep 2: Staging all changes..." -ForegroundColor Yellow
try {
    git add .
    Write-Host "All changes staged successfully." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to stage changes." -ForegroundColor Red
    exit 1
}

# Step 3: Commit changes
Write-Host "`nStep 3: Committing changes..." -ForegroundColor Yellow
$commitMessage = "Add local caching for news and events, enhance accessibility features, add category filter and clear button, comprehensive documentation for judges"
try {
    git commit -m $commitMessage
    Write-Host "Changes committed successfully." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to commit. Check if there are changes to commit." -ForegroundColor Red
    exit 1
}

# Step 4: Push to GitHub
Write-Host "`nStep 4: Pushing to GitHub..." -ForegroundColor Yellow
try {
    git push origin main
    Write-Host "`nSUCCESS! All changes pushed to GitHub." -ForegroundColor Green
    Write-Host "`nRepository: https://github.com/mokshkopikar/fbla_mobile_app" -ForegroundColor Cyan
} catch {
    Write-Host "ERROR: Failed to push. You may need to enter credentials:" -ForegroundColor Red
    Write-Host "  Username: mokshkopikar" -ForegroundColor Yellow
    Write-Host "  Password: Use your Personal Access Token" -ForegroundColor Yellow
    exit 1
}

Write-Host "`nDone! Your code is now synced with GitHub." -ForegroundColor Green
