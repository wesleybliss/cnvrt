#!/bin/bash
# Build script for FOSS (Free and Open Source Software) variant - RELEASE
# This build excludes proprietary libraries like Firebase

set -e  # Exit on error

echo "========================================="
echo "Building CNVRT FOSS variant (RELEASE)"
echo "========================================="
echo ""

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "Error: pubspec.yaml not found. Run this script from the project root."
    exit 1
fi

echo "Cleaning previous builds..."
flutter clean

echo ""
echo "Getting dependencies..."
flutter pub get

echo ""
echo "Running code generation..."
flutter pub run build_runner build --delete-conflicting-outputs

echo ""
echo "Building FOSS APK (release)..."
flutter build apk --flavor foss --dart-define=FOSS_BUILD=true --release

echo ""
echo "========================================="
echo "✓ FOSS release APK built successfully!"
echo "========================================="
echo "Location: build/app/outputs/flutter-apk/app-foss-release.apk"
echo ""
echo "This APK is suitable for:"
echo "  - F-Droid"
echo "  - Direct distribution"
echo "  - Any FOSS app store"
echo ""
