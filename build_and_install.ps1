# Flutter App Build and Install Automation Script
# -----------------------------------------------
# Flutter App Build and Install Automation Script (UTF-8 Encoding Support)
# -----------------------------------------------

# Set console encoding (Prevent Korean character corruption)
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null  # Set console code page to UTF-8

# Stop script on error
$ErrorActionPreference = "Continue"

Write-Host "🚀 Starting Flutter app build and installation..." -ForegroundColor Green

# Flutter clean
Write-Host "🧹 Running Flutter clean..." -ForegroundColor Yellow
flutter clean

# Install dependencies
Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
flutter pub get

# Build using Gradle directly
Write-Host "🔨 Running Gradle build..." -ForegroundColor Yellow
try {
    Set-Location android
    ./gradlew assembleDebug --info
    Set-Location ..
} catch {
    Write-Host "❌ Gradle build failed!" -ForegroundColor Red
    Write-Host $_
    exit 1
}

# APK path (automatically find the most recently generated APK)
$apkPath = Get-ChildItem -Path . -Recurse -Filter *.apk | Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName

if ($apkPath -and (Test-Path $apkPath)) {
    Write-Host "✅ APK build succeeded! Location: $apkPath" -ForegroundColor Green
    
    Write-Host "📱 Checking connected devices..." -ForegroundColor Yellow
    $devices = flutter devices
    Write-Host $devices
    
    if ($devices -match "android") {
        Write-Host "📱 Installing app..." -ForegroundColor Yellow
        adb install -r $apkPath
        Write-Host "✅ App installation complete!" -ForegroundColor Green
    } else {
        Write-Host "❌ No connected Android device found." -ForegroundColor Red
    }
} else {
    Write-Host "❌ Could not find APK file!" -ForegroundColor Red
    Write-Host "🔍 Check Gradle build logs for more info." -ForegroundColor Yellow
    exit 1
}

Write-Host "✨ All done!" -ForegroundColor Green
