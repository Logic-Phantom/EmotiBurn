@echo off
echo Building and installing Flutter app...

REM Build APK
echo Building APK...
call flutter build apk --flavor=dev --debug
if errorlevel 1 (
    echo Build failed!
    exit /b 1
)

REM Set APK path
set APK_PATH=android\app\build\outputs\apk\dev\debug\app-dev-debug.apk

REM Install APK
echo Installing APK from %APK_PATH%
call adb install -r "%APK_PATH%"
if errorlevel 1 (
    echo Installation failed!
    exit /b 1
)

echo.
echo Installation completed successfully!
echo.
pause 