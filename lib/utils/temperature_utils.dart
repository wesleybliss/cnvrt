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
