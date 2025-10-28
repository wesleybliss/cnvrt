# cnvrt

A simple conversion app for currencies and other units.

[![Flutter CI/CD](https://github.com/wesleybliss/cnvrt/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/wesleybliss/cnvrt/actions/workflows/ci-cd.yml)

## Getting Started

1. Clone the repository
2. Make sure Flutter is up to date (`flutter clean`, `flutter pub get`, etc.)
3. Make sure AGP is up to date
4. Run the API server
5. Bridge ADB ports via `adb reverse tcp:3002 tcp:3002`
6. Run the build server via `dart run build_runner watch`
7. Run the app


## Build Variants

The app supports two build flavors:

- **Standard**: Full-featured build with Firebase Crashlytics for error reporting. Suitable for Google Play Store and Apple App Store.
- **FOSS**: Free and Open Source Software build that excludes all proprietary libraries (Firebase, Google Services). Suitable for F-Droid and other FOSS app stores.

### Building FOSS Variant

```bash
# Quick build using the provided script
./bin/build-foss-release.sh

# Or manually
flutter build apk --flavor foss --dart-define=FOSS_BUILD=true --release
```

For detailed information about FOSS builds, see [docs/FOSS_BUILDS.md](docs/FOSS_BUILDS.md).

## TODO

* [ ] Common denominations screen? (e.g. 50k COP = $usd, 100k, etc)
* [ ] Ability to perform basic math operations
* [ ] More translations
* [ ] More unit types (data storage, cooking, etc)
* [x] Alternate FOSS flavor without Google or Firebase dependencies
