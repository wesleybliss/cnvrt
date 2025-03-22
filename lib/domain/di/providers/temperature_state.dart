import 'package:cnvrt/utils/temperature_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'temperature_state.g.dart';

enum TemperatureUnit { celsius, fahrenheit, kelvin }

@riverpod
class TemperatureState extends _$TemperatureState {
  @override
  ({double temperature, TemperatureUnit inputUnit, TemperatureUnit outputUnit}) build() {
    return (temperature: 0.0, inputUnit: TemperatureUnit.celsius, outputUnit: TemperatureUnit.fahrenheit);
  }

  void setTemperature(double value) {
    state = (temperature: value, inputUnit: state.inputUnit, outputUnit: state.outputUnit);
  }

  void setInputUnit(TemperatureUnit unit) {
    state = (temperature: state.temperature, inputUnit: unit, outputUnit: state.outputUnit);
  }

  void setOutputUnit(TemperatureUnit unit) {
    state = (temperature: state.temperature, inputUnit: state.inputUnit, outputUnit: unit);
  }

  double get convertedTemperature {
    double inputValue = state.temperature;
    TemperatureUnit inputUnit = state.inputUnit;
    TemperatureUnit outputUnit = state.outputUnit;

    switch (inputUnit) {
      case TemperatureUnit.celsius:
        if (outputUnit == TemperatureUnit.fahrenheit) {
          return celsiusToFahrenheit(inputValue);
        } else if (outputUnit == TemperatureUnit.kelvin) {
          return celsiusToKelvin(inputValue);
        } else {
          return inputValue; // Same unit
        }
      case TemperatureUnit.fahrenheit:
        if (outputUnit == TemperatureUnit.celsius) {
          return fahrenheitToCelsius(inputValue);
        } else if (outputUnit == TemperatureUnit.kelvin) {
          return fahrenheitToKelvin(inputValue);
        } else {
          return inputValue; // Same unit
        }
      case TemperatureUnit.kelvin:
        if (outputUnit == TemperatureUnit.celsius) {
          return kelvinToCelsius(inputValue);
        } else if (outputUnit == TemperatureUnit.fahrenheit) {
          return kelvinToFahrenheit(inputValue);
        } else {
          return inputValue; // Same unit
        }
    }
  }
}
