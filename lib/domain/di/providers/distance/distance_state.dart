import 'package:cnvrt/utils/logger.dart';
import 'package:cnvrt/utils/unit_conversion_utils.dart' as unit_conversion_utils;
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'distance_state.g.dart';

enum DistanceConversionDirection { milesToKilometers, kilometersToMiles }

@CopyWith()
class DistanceStateModel {
  final int miles;
  final int kilometers;
  final DistanceConversionDirection direction;

  DistanceStateModel(this.miles, this.kilometers, this.direction);
}

@riverpod
class DistanceState extends _$DistanceState {
  final log = Logger('DistanceState');

  @override
  DistanceStateModel build({
    int miles = -1,
    int kilometers = -1,
    DistanceConversionDirection direction = DistanceConversionDirection.kilometersToMiles,
  }) => DistanceStateModel(miles, kilometers, direction);

  void setDirection(DistanceConversionDirection direction) {
    this.direction = direction;
  }

  void setMiles(int value) {
    log.d("update: miles: $value");
    state = state.copyWith(miles: value, kilometers: unit_conversion_utils.milesToKm(value));
  }

  void setKilometers(int value) {
    log.d("update: kilometers: $value");
    state = state.copyWith(miles: unit_conversion_utils.kmToMiles(value), kilometers: value);
  }
}
