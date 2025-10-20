# cnvrt

A simple currency conversion app.

[![Flutter CI/CD](https://github.com/wesleybliss/cnvrt/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/wesleybliss/cnvrt/actions/workflows/ci-cd.yml)

## Getting Started

1. Clone the repository
2. Make sure Flutter is up to date (`flutter clean`, `flutter pub get`, etc.)
3. Make sure AGP is up to date
4. Run the API server
5. Bridge ADB ports via `adb reverse tcp:3002 tcp:3002`
6. Run the build server via `dart run build_runner watch`
7. Run the app


## TODO

* [ ] Common denominations screen? (e.g. 50k COP = $usd, 100k, etc)
* [ ] Ability to perform basic math operations
* [ ] More translations
