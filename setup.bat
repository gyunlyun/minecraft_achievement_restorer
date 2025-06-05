@echo off
echo Setting up Minecraft Achievement Restorer...
echo.

echo Checking Flutter installation...
flutter --version
if %errorlevel% neq 0 (
    echo Error: Flutter is not installed or not in PATH
    echo Please install Flutter from https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

echo.
echo Installing dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo Error: Failed to install dependencies
    pause
    exit /b 1
)

echo.
echo Generating localization files...
flutter gen-l10n
if %errorlevel% neq 0 (
    echo Error: Failed to generate localization files
    pause
    exit /b 1
)

echo.
echo Running tests...
flutter test
if %errorlevel% neq 0 (
    echo Warning: Some tests failed
)

echo.
echo Setup complete! You can now run the app with:
echo flutter run -d windows
echo.
echo Or build a release version with:
echo flutter build windows --release
echo.
pause
