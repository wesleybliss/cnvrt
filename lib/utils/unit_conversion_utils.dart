//region Temperature

int celsiusToFahrenheit(int celsius) {
  return ((celsius * 9 / 5) + 32).toInt();
}

int fahrenheitToCelsius(int fahrenheit) {
  return ((fahrenheit - 32) * 5 / 9).toInt();
}

int celsiusToKelvin(int celsius) {
  return (celsius + 273.15).toInt();
}

int kelvinToCelsius(int kelvin) {
  return (kelvin - 273.15).toInt();
}

int fahrenheitToKelvin(int fahrenheit) {
  return ((fahrenheit + 459.67) * 5 / 9).toInt();
}

int kelvinToFahrenheit(int kelvin) {
  return (kelvin * 9 / 5 - 459.67).toInt();
}

//endregion Temperature

//region Distance

int kmToMiles(int km) {
  return (km / 1.60934).toInt();
}

int milesToKm(int miles) {
  return (miles * 1.60934).toInt();
}

//endregion Distance

//region Weight

int kilogramsToPounds(int kg) {
  return (kg * 2.20462).toInt();
}

int poundsToKilograms(int lbs) {
  return (lbs / 2.20462).toInt();
}

//endregion Weight
