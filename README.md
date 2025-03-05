# cnvrt

A simple currency conversion app.

## Getting Started

1. Clone the repository
2. Make sure Flutter is up to date (`flutter clean`, `flutter pub get`, etc.)
3. Make sure AGP is up to date
4. Run the API server
5. Bridge ADB ports via `adb reverse tcp:3001 tcp:3001`
6. Run the app


## TODO

1. Remember theme preference for subsequent launches

### Settings

1. Show "drag to reorder" handles
2. Show copy to clipboard buttons
3. Show full currency name label
4. Position of inputs (top, middle, bottom)
5. Show currency rate (all, selected, none)

### Converters

1. Temperature F to/from C
2. Distance Miles to/from Kilometers


`flutter build apk --release && adb -s 'adb-RFCX60JX8MP-MRJbrg._adb-tls-connect._tcp' install build/app/outputs/flutter-apk/app-release.apk`