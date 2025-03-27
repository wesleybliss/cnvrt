# cnvrt

A simple currency conversion app.


## Getting Started

1. Clone the repository
2. Make sure Flutter is up to date (`flutter clean`, `flutter pub get`, etc.)
3. Make sure AGP is up to date
4. Run the API server
5. Bridge ADB ports via `adb reverse tcp:3002 tcp:3002`
6. Run the build server via `dart run build_runner watch`
7. Run the app


## TODO

* [x] Remember theme preference for subsequent launches
* [x] Show flag next to currency symbol on inputs
* [ ] Common denominations screen? (e.g. 50k COP = $usd, 100k, etc)
* [ ] Ability to perform basic math operations
* [ ] Translations


### Settings

* [x] Show "drag to reorder" handles
* [x] Show copy to clipboard buttons
* [x] Show full currency name label
* [x] Position of inputs (top, middle, bottom)
* [x] Show currency rate (all, selected, none)

### Converters

* [x] Temperature F to/from C
* [x] Distance Miles to/from Kilometers
* [x] Weight from Pounds to/from Kilograms
* [x] Volume from Gallons to/from Liters
* [x] Speed from MPH to/from KPH
* [x] Area from Square Feet to/from Square Meters
