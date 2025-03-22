double celsiusToFahrenheit(double celsius) {
  return (celsius * 9 / 5) + 32;
}

double fahrenheitToCelsius(double fahrenheit) {
  return (fahrenheit - 32) * 5 / 9;
}

double celsiusToKelvin(double celsius) {
  return celsius + 273.15;
}

double kelvinToCelsius(double kelvin) {
  return kelvin - 273.15;
}

double fahrenheitToKelvin(double fahrenheit) {
  return (fahrenheit + 459.67) * 5 / 9;
}

double kelvinToFahrenheit(double kelvin) {
  return kelvin * 9 / 5 - 459.67;
}
