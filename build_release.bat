@echo off
start cmd /c flutter clean -v
pause
flutter build apk --release --target-platform android-arm64 -v
pause