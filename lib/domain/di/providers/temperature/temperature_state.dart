import 'package:cnvrt/utils/logger.dart';
import 'package:cnvrt/utils/temperature_utils.dart' as temperature_utils;
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'temperature_state.g.dart';

enum TemperatureConversionDirection { celsiusToFahrenheit, fahrenheitToCelsius }

@CopyWith()
class TemperatureStateModel {
  final int celsius;
  final int fahrenheit;
  final TemperatureConversionDirection direction;

  TemperatureStateModel(this.celsius, this.fahrenheit, this.direction);
}

@riverpod
class TemperatureState extends _$TemperatureState {
  final log = Logger('TemperatureState');

  @override
  TemperatureStateModel build({
    int celsius = -1,
    int fahrenheit = -1,
    TemperatureConversionDirection direction = TemperatureConversionDirection.celsiusToFahrenheit,
  }) => TemperatureStateModel(celsius, fahrenheit, direction);

  void setDirection(TemperatureConversionDirection direction) {
    this.direction = direction;
  }

  void setCelsius(int value) {
    log.d("update: celsius: $value");
    state = state.copyWith(celsius: value, fahrenheit: temperature_utils.celsiusToFahrenheit(value));
  }

  void setFahrenheit(int value) {
    log.d("update: fahrenheit: $value");
    state = state.copyWith(celsius: temperature_utils.fahrenheitToCelsius(value), fahrenheit: value);
  }
}
