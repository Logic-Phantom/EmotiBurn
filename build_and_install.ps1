# Flutter 앱 빌드 및 설치 자동화 스크립트
# Flutter 앱 빌드 및 설치 자동화 스크립트
# 콘솔 인코딩 설정 (PowerShell, Windows에서 한글 깨짐 방지)
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[Console]::OutputEncoding = $utf8NoBom
$OutputEncoding = $utf8NoBom

# 오류 발생 시 스크립트 중단
$ErrorActionPreference = "Continue"

Write-Host "🚀 Flutter 앱 빌드 및 설치 시작..." -ForegroundColor Green

# Flutter 클린
Write-Host "🧹 Flutter 클린 실행 중..." -ForegroundColor Yellow
flutter clean

# Flutter pub get
Write-Host "📦 의존성 패키지 설치 중..." -ForegroundColor Yellow
flutter pub get

# Gradle을 사용하여 직접 빌드
Write-Host "🔨 Gradle 빌드 실행 중..." -ForegroundColor Yellow
try {
    Set-Location android
    ./gradlew assembleDebug --info
    Set-Location ..
} catch {
    Write-Host "❌ Gradle 빌드 실패!" -ForegroundColor Red
    Write-Host $_
    exit 1
}

# APK 파일 경로 (가장 최근 생성된 APK 자동 탐색)
$apkPath = Get-ChildItem -Path . -Recurse -Filter *.apk | Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName

if ($apkPath -and (Test-Path $apkPath)) {
    Write-Host "✅ APK 빌드 성공! 위치: $apkPath" -ForegroundColor Green
    
    Write-Host "📱 연결된 기기 확인 중..." -ForegroundColor Yellow
    $devices = flutter devices
    Write-Host $devices
    
    if ($devices -match "android") {
        Write-Host "📱 앱 설치 중..." -ForegroundColor Yellow
        adb install -r $apkPath
        Write-Host "✅ 앱 설치 완료!" -ForegroundColor Green
    } else {
        Write-Host "❌ 연결된 Android 기기가 없습니다." -ForegroundColor Red
    }
} else {
    Write-Host "❌ APK 파일을 찾을 수 없습니다!" -ForegroundColor Red
    Write-Host "🔍 Gradle 빌드 로그를 확인하세요." -ForegroundColor Yellow
    exit 1
}

Write-Host "✨ 작업 완료!" -ForegroundColor Green 