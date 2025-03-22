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

* [x] Remember theme preference for subsequent launches
* [x] Show flag next to currency symbol on inputs
* [ ] Translations
* [ ] Common denominations screen? (e.g. 50k COP = $usd, 100k, etc)


### Settings

* [x] Show "drag to reorder" handles
* [x] Show copy to clipboard buttons
* [x] Show full currency name label
* [x] Position of inputs (top, middle, bottom)
* [x] Show currency rate (all, selected, none)

### Converters

1. Temperature F to/from C
2. Distance Miles to/from Kilometers


`flutter build apk --release && adb -s 'adb-RFCX60JX8MP-MRJbrg._adb-tls-connect._tcp' install build/app/outputs/flutter-apk/app-release.apk`