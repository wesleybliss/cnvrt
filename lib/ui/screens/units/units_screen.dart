import 'package:cnvrt/ui/screens/units/numeric_units_row.dart';
import 'package:cnvrt/utils/unit_conversion_utils.dart' as unit_conversion_utils;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnitsScreen extends ConsumerWidget {
  UnitsScreen({super.key});

  final temperatureRow = NumericUnitsRow(
    title: "Temperature",
    sourceLabel: "C",
    targetLabel: "F",
    convertNormalFn: unit_conversion_utils.fahrenheitToCelsius,
    convertReversedFn: unit_conversion_utils.celsiusToFahrenheit,
  );

  final distanceRow = NumericUnitsRow(
    title: "Distance",
    sourceLabel: "KM",
    targetLabel: "MI",
    convertNormalFn: unit_conversion_utils.milesToKm,
    convertReversedFn: unit_conversion_utils.kmToMiles,
  );

  final speedRow = NumericUnitsRow(
    title: "Speed",
    sourceLabel: "KPH",
    targetLabel: "MPH",
    convertNormalFn: unit_conversion_utils.mphToKph,
    convertReversedFn: unit_conversion_utils.kphToMph,
  );

  final weightRow = NumericUnitsRow(
    title: "Weight",
    sourceLabel: "KG",
    targetLabel: "LBS",
    convertNormalFn: unit_conversion_utils.poundsToKilograms,
    convertReversedFn: unit_conversion_utils.kilogramsToPounds,
  );

  final areaRow = NumericUnitsRow(
    title: "Area",
    sourceLabel: "SQMT",
    targetLabel: "SQFT",
    convertNormalFn: unit_conversion_utils.squareFeetToSquareMeters,
    convertReversedFn: unit_conversion_utils.squareMetersToSquareFeet,
  );

  final volumeRow = NumericUnitsRow(
    title: "Volume",
    sourceLabel: "LTR",
    targetLabel: "GAL",
    convertNormalFn: unit_conversion_utils.gallonsToLiters,
    convertReversedFn: unit_conversion_utils.litersToGallons,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListView(shrinkWrap: true, children: [temperatureRow, distanceRow, speedRow, weightRow, areaRow, volumeRow]),
      ],
    );
  }
}
