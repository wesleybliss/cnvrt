import 'package:cnvrt/l10n/app_localizations.dart';
import 'package:cnvrt/ui/screens/units/numeric_units_row.dart';
import 'package:cnvrt/utils/unit_conversion_utils.dart'
    as unit_conversion_utils;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnitsScreen extends ConsumerWidget {
  const UnitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final temperatureRows = [
      NumericUnitsRow(
        title: AppLocalizations.of(context)!.temperature,
        sourceLabel: "C",
        targetLabel: "F",
        convertNormalFn: unit_conversion_utils.fahrenheitToCelsius,
        convertReversedFn: unit_conversion_utils.celsiusToFahrenheit,
      ),
    ];

    final distanceRows = [
      NumericUnitsRow(
        title: AppLocalizations.of(context)!.distance,
        sourceLabel: "KM",
        targetLabel: "MI",
        convertNormalFn: unit_conversion_utils.milesToKm,
        convertReversedFn: unit_conversion_utils.kmToMiles,
      ),
    ];

    final speedRows = [
      NumericUnitsRow(
        title: AppLocalizations.of(context)!.speed,
        sourceLabel: "KPH",
        targetLabel: "MPH",
        convertNormalFn: unit_conversion_utils.mphToKph,
        convertReversedFn: unit_conversion_utils.kphToMph,
      ),
    ];

    final weightRows = [
      NumericUnitsRow(
        title: AppLocalizations.of(context)!.weight,
        sourceLabel: "GR",
        targetLabel: "OZ",
        convertNormalFn: unit_conversion_utils.ouncesToGrams,
        convertReversedFn: unit_conversion_utils.gramsToOunces,
      ),
      NumericUnitsRow(
        sourceLabel: "KG",
        targetLabel: "LBS",
        convertNormalFn: unit_conversion_utils.poundsToKilograms,
        convertReversedFn: unit_conversion_utils.kilogramsToPounds,
      ),
    ];

    final lengthRows = [
      NumericUnitsRow(
        title: "Length",
        sourceLabel: "CM",
        targetLabel: "IN",
        convertNormalFn: unit_conversion_utils.inchesToCm,
        convertReversedFn: unit_conversion_utils.cmToInches,
      ),
    ];

    final areaRows = [
      NumericUnitsRow(
        title: AppLocalizations.of(context)!.area,
        sourceLabel: "SQMT",
        targetLabel: "SQFT",
        convertNormalFn: unit_conversion_utils.squareFeetToSquareMeters,
        convertReversedFn: unit_conversion_utils.squareMetersToSquareFeet,
      ),
    ];

    final volumeRows = [
      NumericUnitsRow(
        title: AppLocalizations.of(context)!.volume,
        sourceLabel: "LTR",
        targetLabel: "GAL",
        convertNormalFn: unit_conversion_utils.gallonsToLiters,
        convertReversedFn: unit_conversion_utils.litersToGallons,
      ),
      NumericUnitsRow(
        sourceLabel: "ML",
        targetLabel: "FL OZ",
        convertNormalFn: unit_conversion_utils.flOzToMl,
        convertReversedFn: unit_conversion_utils.mlToFlOz,
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          ...temperatureRows,
          ...distanceRows,
          ...speedRows,
          ...weightRows,
          ...areaRows,
          ...volumeRows,
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
