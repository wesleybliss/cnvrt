import 'package:cnvrt/domain/di/providers/distance/distance_state.dart';
import 'package:cnvrt/theme.dart';
import 'package:cnvrt/ui/screens/units/distance_row/distance_row_field.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DistanceRow extends ConsumerStatefulWidget {
  const DistanceRow({super.key});

  @override
  DistanceRowState createState() => DistanceRowState();
}

class DistanceRowState extends ConsumerState<DistanceRow> {
  final log = Logger('DistanceRow');
  final inputController = TextEditingController();
  final outputController = TextEditingController();

  @override
  void dispose() {
    inputController.dispose();
    outputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final distanceState = ref.watch(distanceStateProvider());
    final distanceNotifier = ref.read(distanceStateProvider().notifier);
    final isKilometersToMiles = distanceState.direction == DistanceConversionDirection.kilometersToMiles;

    final inputDecoration = defaultInputDecoration.copyWith(
      hintText: "1",
      prefix: Text("KM"),
      labelStyle: TextStyle(fontSize: 12),
    );

    final outputDecoration = defaultInputDecoration.copyWith(
      hintText: "1",
      prefix: Text("MI"),
      labelStyle: TextStyle(fontSize: 12),
    );

    void swapInputs() {
      distanceNotifier.setDirection(
        isKilometersToMiles
            ? DistanceConversionDirection.milesToKilometers
            : DistanceConversionDirection.kilometersToMiles,
      );
    }

    inputController.text = distanceState.kilometers == -1 ? "" : distanceState.kilometers.toString();
    outputController.text = distanceState.miles == -1 ? "" : distanceState.miles.toString();

    var fields = [
      DistanceRowField(
        controller: inputController,
        decoration: inputDecoration,
        onChanged: (text) {
          distanceNotifier.setKilometers(int.tryParse(text) ?? 0);
        },
      ),
      IconButton(onPressed: swapInputs, icon: Icon(Icons.sync_alt)),
      DistanceRowField(
        controller: outputController,
        decoration: outputDecoration,
        onChanged: (text) {
          distanceNotifier.setMiles(int.tryParse(text) ?? 0);
        },
      ),
    ];

    if (!isKilometersToMiles) {
      fields = fields.reversed.toList();
    }

    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text("Distance", style: Theme.of(context).textTheme.labelLarge),
          ),
          Row(children: fields),
        ],
      ),
    );
  }
}
