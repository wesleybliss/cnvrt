import 'package:cnvrt/ui/screens/units/temperature_row/temperature_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnitsScreen extends ConsumerWidget {
  const UnitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListView(shrinkWrap: true, children: [TemperatureRow()]),
      ],
    );
  }
}
