@echo off
setlocal enabledelayedexpansion

REM Set Flutter path
set FLUTTER_PATH=d:\flutter\bin\flutter.bat

REM Print Flutter version
echo.
echo ========================================
echo Flutter Setup and Project Build
echo ========================================
echo.

%FLUTTER_PATH% --version
echo.

REM Check devices
echo Checking available devices...
%FLUTTER_PATH% devices
echo.

REM Run the project on Android
echo.
echo Running project on Android device...
echo.
%FLUTTER_PATH% run -d android

pause
