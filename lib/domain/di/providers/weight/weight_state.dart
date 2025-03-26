import 'package:cnvrt/utils/logger.dart';
import 'package:cnvrt/utils/unit_conversion_utils.dart' as unit_conversion_utils;
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weight_state.g.dart';

enum WeightConversionDirection { poundsToKilograms, kilogramsToPounds }

@CopyWith()
class WeightStateModel {
  final int pounds;
  final int kilograms;
  final WeightConversionDirection direction;

  WeightStateModel(this.pounds, this.kilograms, this.direction);
}

@riverpod
class WeightState extends _$WeightState {
  final log = Logger('WeightState');

  @override
  WeightStateModel build({
    int pounds = -1,
    int kilograms = -1,
    WeightConversionDirection direction = WeightConversionDirection.kilogramsToPounds,
  }) => WeightStateModel(pounds, kilograms, direction);

  void setDirection(WeightConversionDirection direction) {
    this.direction = direction;
  }

  void setPounds(int value) {
    log.d("update: pounds: $value");
    state = state.copyWith(pounds: value, kilograms: unit_conversion_utils.poundsToKilograms(value));
  }

  void setKilograms(int value) {
    log.d("update: kilograms: $value");
    state = state.copyWith(pounds: unit_conversion_utils.kilogramsToPounds(value), kilograms: value);
  }
}
