import 'package:cnvrt/domain/di/providers/weight/weight_state.dart';
import 'package:cnvrt/theme.dart';
import 'package:cnvrt/ui/screens/units/weight_row/weight_row_field.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeightRow extends ConsumerStatefulWidget {
  const WeightRow({super.key});

  @override
  WeightRowState createState() => WeightRowState();
}

class WeightRowState extends ConsumerState<WeightRow> {
  final log = Logger('WeightRow');
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
    final weightState = ref.watch(weightStateProvider());
    final weightNotifier = ref.read(weightStateProvider().notifier);
    final isKilogramsToPounds = weightState.direction == WeightConversionDirection.kilogramsToPounds;

    final inputDecoration = defaultInputDecoration.copyWith(
      hintText: "1",
      prefix: Text("KG"),
      labelStyle: TextStyle(fontSize: 12),
    );

    final outputDecoration = defaultInputDecoration.copyWith(
      hintText: "1",
      prefix: Text("LBS"),
      labelStyle: TextStyle(fontSize: 12),
    );

    void swapInputs() {
      weightNotifier.setDirection(
        isKilogramsToPounds ? WeightConversionDirection.poundsToKilograms : WeightConversionDirection.kilogramsToPounds,
      );
    }

    inputController.text = weightState.kilograms == -1 ? "" : weightState.kilograms.toString();
    outputController.text = weightState.pounds == -1 ? "" : weightState.pounds.toString();

    var fields = [
      WeightRowField(
        controller: inputController,
        decoration: inputDecoration,
        onChanged: (text) {
          weightNotifier.setKilograms(int.tryParse(text) ?? 0);
        },
      ),
      IconButton(onPressed: swapInputs, icon: Icon(Icons.sync_alt)),
      WeightRowField(
        controller: outputController,
        decoration: outputDecoration,
        onChanged: (text) {
          weightNotifier.setPounds(int.tryParse(text) ?? 0);
        },
      ),
    ];

    if (!isKilogramsToPounds) {
      fields = fields.reversed.toList();
    }

    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text("Weight", style: Theme.of(context).textTheme.labelLarge),
          ),
          Row(children: fields),
        ],
      ),
    );
  }
}
