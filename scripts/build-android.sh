#!/bin/bash

# Build Android APK for GitRadar
# Usage: ./scripts/build-android.sh [debug|release]

set -e

cd "$(dirname "$0")/../app"

BUILD_TYPE="${1:-debug}"

echo "Building GitRadar Android APK ($BUILD_TYPE)..."

# Ensure dependencies are up to date
flutter pub get

if [ "$BUILD_TYPE" = "release" ]; then
    echo "Building release APK..."
    flutter build apk --release
    APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
else
    echo "Building debug APK..."
    flutter build apk --debug
    APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
fi

if [ -f "$APK_PATH" ]; then
    echo ""
    echo "Build successful!"
    echo "APK location: app/$APK_PATH"
    echo ""
    echo "To install on connected device:"
    echo "  adb install app/$APK_PATH"
    echo ""
    echo "Or run directly:"
    echo "  cd app && flutter run -d <device-id>"
    echo ""
    echo "List connected devices:"
    echo "  flutter devices"
else
    echo "Build failed - APK not found"
    exit 1
fi
