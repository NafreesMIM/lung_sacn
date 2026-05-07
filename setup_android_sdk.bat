@echo off
REM Quick Android SDK Setup Script for LungScan+
REM This script downloads and configures Android SDK Command Line Tools

echo.
echo ================================================
echo   Android SDK Quick Setup
echo ================================================
echo.

REM Check if SDK exists
set SDK_PATH=%USERPROFILE%\AppData\Local\Android\Sdk

if exist "%SDK_PATH%" (
    echo Android SDK already exists at %SDK_PATH%
    goto setup_flutter
)

echo Downloading Android SDK Command Line Tools...
echo This may take a few minutes...
echo.

REM Create directories
if not exist "%USERPROFILE%\AppData\Local\Android" mkdir "%USERPROFILE%\AppData\Local\Android"

REM Download SDK command line tools (requires internet)
REM Note: You may need to download manually from:
REM https://developer.android.com/studio#downloads (scroll down for "Command line tools only")

echo.
echo To download Android SDK Command Line Tools:
echo 1. Visit: https://developer.android.com/studio
echo 2. Scroll down to "Command line tools only"
echo 3. Download for Windows
echo 4. Extract to: %USERPROFILE%\AppData\Local\Android\cmdline-tools
echo.

:setup_flutter
echo.
echo Configuring Flutter to use Android SDK...
d:\flutter\bin\flutter.bat config --android-sdk "%SDK_PATH%"

echo.
echo Running flutter doctor to verify...
d:\flutter\bin\flutter.bat doctor

echo.
echo Setup complete! Now try:
echo   flutter devices
echo   flutter run
echo.

pause
