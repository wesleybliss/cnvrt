# FOSS Builds Documentation

## Overview

CNVRT supports building FOSS (Free and Open Source Software) variants that exclude proprietary libraries. This makes the app suitable for distribution through F-Droid and other FOSS app stores.

## Build Flavors

The app has two build flavors:

### 1. Standard (Default)
- Includes all features
- Uses Firebase Crashlytics for error reporting
- Suitable for Google Play Store and Apple App Store
- **Build command**: `flutter build apk --flavor standard`

### 2. FOSS
- Excludes all proprietary libraries (Firebase, Google Services)
- Fully FOSS-compliant
- Suitable for F-Droid and other FOSS app stores
- **Build command**: `flutter build apk --flavor foss --dart-define=FOSS_BUILD=true`

## What's Different in FOSS Builds?

The FOSS flavor excludes:
- **Firebase Core** - No Firebase initialization
- **Firebase Crashlytics** - No crash reporting to Firebase

The app remains fully functional without these features. Error logging still works locally through the app's logger.

## Building FOSS Variants

### Quick Build (Using Scripts)

We provide convenience scripts for building FOSS variants:

```bash
# Debug build
./build-foss.sh

# Release build (for distribution)
./build-foss-release.sh
```

### Manual Build Commands

#### Debug Build
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter build apk --flavor foss --dart-define=FOSS_BUILD=true --debug
```

#### Release Build
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter build apk --flavor foss --dart-define=FOSS_BUILD=true --release
```

### Output Location

Built APKs are located in:
```
build/app/outputs/flutter-apk/
├── app-foss-debug.apk     # Debug build
└── app-foss-release.apk   # Release build
```

## Technical Implementation

### Android Configuration

The Android build system uses product flavors to manage the different variants:

**File**: `android/app/build.gradle.kts`

```kotlin
flavorDimensions += "distribution"

productFlavors {
    create("standard") {
        dimension = "distribution"
        // Includes Firebase
    }
    
    create("foss") {
        dimension = "distribution"
        // Excludes Firebase
    }
}
```

Firebase plugins are conditionally applied only when `google-services.json` exists in the standard flavor directory.

**Flavor-Specific Directories:**

- `android/app/src/standard/google-services.json` - Real Firebase configuration for standard builds
- `android/app/src/foss/google-services.json` - Dummy Firebase configuration for FOSS builds

The FOSS build includes a dummy `google-services.json` file to satisfy the Google Services Gradle plugin, but since Firebase is never initialized in the Dart code (thanks to `FlavorConfig.isFirebaseEnabled`), these dummy values are never used at runtime.

### Dart/Flutter Configuration

**File**: `lib/config/flavor.dart`

The flavor is detected at compile time using Dart's `const` evaluation:

```dart
class FlavorConfig {
  static const bool isFossBuild = bool.fromEnvironment('FOSS_BUILD', defaultValue: false);
  static bool get isFirebaseEnabled => !isFossBuild;
}
```

This allows the Dart code to conditionally:
- Skip Firebase initialization
- Disable crash reporting
- Hide Firebase-related UI elements (debug screens)

### Conditional Code Execution

Firebase initialization is skipped in FOSS builds:

```dart
Future<void> initializeFirebase() async {
  if (!FlavorConfig.isFirebaseEnabled) {
    log.d('[Firebase] FOSS build detected - skipping initialization');
    return;
  }
  // Standard Firebase initialization continues...
}
```

## Testing FOSS Builds

1. **Build the FOSS variant** using one of the methods above
2. **Install on a device**: `adb install build/app/outputs/flutter-apk/app-foss-release.apk`
3. **Verify Firebase is disabled**:
   - Check app logs for "FOSS build detected" messages
   - Verify no Firebase services are initialized
   - Check that Crashlytics section is hidden in Debug screen

## F-Droid Considerations

For F-Droid submission:

1. **Use the FOSS flavor exclusively**
2. **Ensure all proprietary code is excluded**
3. **Review** `pubspec.yaml` to ensure no non-free dependencies remain
4. **Build reproducibly** by using consistent Flutter SDK versions
5. **Sign with F-Droid's keys** (F-Droid handles this)

### Metadata for F-Droid

When submitting to F-Droid, specify the build commands in the metadata:

```yaml
Builds:
  - versionName: '1.0.6'
    versionCode: 1
    gradle:
      - foss
    prebuild: flutter pub get
    build: |
      flutter build apk --flavor foss --dart-define=FOSS_BUILD=true --release
```

## Verifying FOSS Compliance

To verify the FOSS build is truly proprietary-free:

1. **Check the APK contents**:
   ```bash
   unzip -l build/app/outputs/flutter-apk/app-foss-release.apk | grep -i firebase
   ```
   Should return no Firebase-related files.

2. **Run static analysis**:
   ```bash
   flutter analyze
   ```

3. **Check for proprietary dependencies**:
   Review `pubspec.lock` and ensure Firebase dependencies aren't pulled in.

## Maintaining FOSS Compatibility

When adding new features:

1. **Check for proprietary dependencies** - Avoid adding new closed-source libraries
2. **Use flavor checks** - Wrap any platform-specific code with `FlavorConfig.isFirebaseEnabled`
3. **Test both flavors** - Always build and test both standard and FOSS variants
4. **Document changes** - Update this file when adding flavor-specific behavior

## Troubleshooting

### "FirebaseCrashlytics not found" Error

This usually happens if you forget to add `--dart-define=FOSS_BUILD=true`. Make sure to include it:
```bash
flutter build apk --flavor foss --dart-define=FOSS_BUILD=true
```

### Firebase Still Initializing in FOSS Build

Check that:
1. The `--dart-define=FOSS_BUILD=true` flag was passed
2. `FlavorConfig.isFirebaseEnabled` returns `false`
3. Firebase initialization code checks the flavor before running

### Build Fails with Gradle Errors

The Firebase plugins are conditionally applied. If you see Gradle errors:
1. Try `flutter clean`
2. Delete `android/.gradle` and `android/app/build` directories
3. Rebuild with the full command

## Additional Resources

- [F-Droid Inclusion Policy](https://f-droid.org/en/docs/Inclusion_Policy/)
- [Flutter Flavors Documentation](https://flutter.dev/docs/deployment/flavors)
- [Android Product Flavors](https://developer.android.com/studio/build/build-variants)

## Support

For issues specific to FOSS builds, please open an issue on the project's issue tracker with the `foss` label.
