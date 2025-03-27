import 'package:cnvrt/utils/logger.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'numeric_units_state.g.dart';

enum NumericUnitsConversionDirection { normal, reversed }

@CopyWith()
class NumericUnitsStateModel {
  final int source;
  final int target;
  final int Function(int value) convertNormalFn;
  final int Function(int value) convertReversedFn;
  final NumericUnitsConversionDirection direction;

  NumericUnitsStateModel(
    this.source,
    this.target,
    this.direction, {
    required this.convertNormalFn,
    required this.convertReversedFn,
  });
}

@riverpod
class NumericUnitsState extends _$NumericUnitsState {
  final log = Logger('NumericUnitsState');

  @override
  NumericUnitsStateModel build({
    int source = -1,
    int target = -1,
    required int Function(int value) convertNormalFn,
    required int Function(int value) convertReversedFn,
    NumericUnitsConversionDirection direction = NumericUnitsConversionDirection.normal,
  }) => NumericUnitsStateModel(
    source,
    target,
    direction,
    convertNormalFn: convertNormalFn,
    convertReversedFn: convertReversedFn,
  );

  void setDirection(NumericUnitsConversionDirection direction) {
    this.direction = direction;
  }

  void setSource(int value) {
    log.d("update: source: $value");
    state = state.copyWith(source: value, target: state.convertReversedFn(value));
  }

  void setTarget(int value) {
    log.d("update: target: $value");
    state = state.copyWith(source: state.convertNormalFn(value), target: value);
  }
}
