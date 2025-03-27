import 'package:cnvrt/utils/logger.dart';

final log = Logger('unit_conversion_utils');

//region Temperature

int celsiusToFahrenheit(int celsius) {
  log.d("celsiusToFahrenheit: $celsius");
  return ((celsius * 9 / 5) + 32).toInt();
}

int fahrenheitToCelsius(int fahrenheit) {
  log.d("fahrenheitToCelsius: $fahrenheit");
  return ((fahrenheit - 32) * 5 / 9).toInt();
}

int celsiusToKelvin(int celsius) {
  log.d("celsiusToKelvin: $celsius");
  return (celsius + 273.15).toInt();
}

int kelvinToCelsius(int kelvin) {
  log.d("kelvinToCelsius: $kelvin");
  return (kelvin - 273.15).toInt();
}

int fahrenheitToKelvin(int fahrenheit) {
  log.d("fahrenheitToKelvin: $fahrenheit");
  return ((fahrenheit + 459.67) * 5 / 9).toInt();
}

int kelvinToFahrenheit(int kelvin) {
  log.d("kelvinToFahrenheit: $kelvin");
  return (kelvin * 9 / 5 - 459.67).toInt();
}

//endregion Temperature

//region Distance

int kmToMiles(int km) {
  log.d("kmToMiles: $km");
  return (km / 1.60934).toInt();
}

int milesToKm(int miles) {
  log.d("milesToKm: $miles");
  return (miles * 1.60934).toInt();
}

//endregion Distance

//region Speed

int kphToMph(int kph) {
  log.d("kphToMph: $kph");
  return (kph / 1.60934).toInt();
}

int mphToKph(int mph) {
  log.d("mphToKph: $mph");
  return (mph * 1.60934).toInt();
}

//endregion Speed

//region Area

int squareMetersToSquareFeet(int sqm) {
  log.d("squareMetersToSquareFeet: $sqm");
  return (sqm * 10.7639).toInt();
}

int squareFeetToSquareMeters(int sqft) {
  log.d("squareFeetToSquareMeters: $sqft");
  return (sqft / 10.7639).toInt();
}

//endregion Area

//region Weight

int kilogramsToPounds(int kg) {
  log.d("kilogramsToPounds: $kg");
  return (kg * 2.20462).toInt();
}

int poundsToKilograms(int lbs) {
  log.d("poundsToKilograms: $lbs");
  return (lbs / 2.20462).toInt();
}

//endregion Weight

//region Volume

int gallonsToLiters(int gallons) {
  log.d("gallonsToLiters: $gallons");
  return (gallons * 3.78541).toInt();
}

int litersToGallons(int liters) {
  log.d("litersToGallons: $liters");
  return (liters / 3.78541).toInt();
}

//endregion Volume
