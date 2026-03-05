@echo off
REM MathKids Adventure - Quick Run Script
REM AI Math Solver Feature

set JAVA_HOME=D:\Android\jdk-17.0.13+11
set ANDROID_HOME=D:\Android\sdk
set ANDROID_SDK_ROOT=D:\Android\sdk
set PATH=D:\Flutter\bin;%JAVA_HOME%\bin;%PATH%

echo ========================================
echo    MathKids Adventure - AI Math Solver
echo ========================================
echo.

:menu
echo เลือกคำสั่ง:
echo   1. Install Dependencies (flutter pub get)
echo   2. Run on Android Device
echo   3. Run on iOS Device
echo   4. Build APK (Release)
echo   5. Build iOS (Release)
echo   6. Clean Project
echo   7. Run Tests
echo   8. Exit
echo.

set /p choice="เลือก (1-8): "

if "%choice%"=="1" goto install
if "%choice%"=="2" goto android
if "%choice%"=="3" goto ios
if "%choice%"=="4" goto build_apk
if "%choice%"=="5" goto build_ios
if "%choice%"=="6" goto clean
if "%choice%"=="7" goto test
if "%choice%"=="8" goto exit

echo.
echo Invalid choice!
goto menu

:install
echo.
echo Installing dependencies...
flutter pub get
echo.
echo Dependencies installed!
pause
goto menu

:android
echo.
echo Running on Android...
echo    Checking for connected devices...
flutter devices
echo.
flutter run
pause
goto menu

:ios
echo.
echo Running on iOS...
echo    Checking for connected devices...
flutter devices
echo.
flutter run -d iPhone
pause
goto menu

:build_apk
echo.
echo Building Android APK (Release)...
flutter build apk --release
echo.
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo APK built successfully!
    echo Location: build\app\outputs\flutter-apk\app-release.apk
) else (
    echo Build failed!
)
pause
goto menu

:build_ios
echo.
echo Building iOS (Release)...
flutter build ios --release
echo.
echo iOS build completed!
echo    Open Xcode to archive and export
pause
goto menu

:clean
echo.
echo Cleaning project...
flutter clean
echo    Removing build files...
if exist "build" rmdir /s /q build
echo    Re-getting dependencies...
flutter pub get
echo.
echo Project cleaned!
pause
goto menu

:test
echo.
echo Running tests...
flutter test
pause
goto menu

:exit
echo.
echo Goodbye!
exit
