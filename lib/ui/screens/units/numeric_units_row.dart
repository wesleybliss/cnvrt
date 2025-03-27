import 'package:cnvrt/domain/di/providers/units/numeric_units_state.dart';
import 'package:cnvrt/theme.dart';
import 'package:cnvrt/ui/screens/units/numeric_units_row_field.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NumericUnitsRow extends ConsumerStatefulWidget {
  final String title;
  final String sourceLabel;
  final String targetLabel;
  final int Function(int value) convertNormalFn;
  final int Function(int value) convertReversedFn;

  const NumericUnitsRow({
    super.key,
    required this.title,
    required this.sourceLabel,
    required this.targetLabel,
    required this.convertNormalFn,
    required this.convertReversedFn,
  });

  @override
  NumericUnitsRowState createState() => NumericUnitsRowState();
}

class NumericUnitsRowState extends ConsumerState<NumericUnitsRow> {
  final log = Logger('NumericUnitsRow');
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
    // final provider =
    final state = ref.watch(
      numericUnitsStateProvider(convertNormalFn: widget.convertNormalFn, convertReversedFn: widget.convertReversedFn),
    );
    final notifier = ref.read(
      numericUnitsStateProvider(
        convertNormalFn: widget.convertNormalFn,
        convertReversedFn: widget.convertReversedFn,
      ).notifier,
    );
    final isDirectionNormal = state.direction == NumericUnitsConversionDirection.normal;

    final inputDecoration = defaultInputDecoration.copyWith(
      hintText: "1",
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 14.0),
        child: Text(widget.sourceLabel, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ),
      labelStyle: TextStyle(fontSize: 12),
    );

    final outputDecoration = defaultInputDecoration.copyWith(
      hintText: "1",
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 14.0),
        child: Text(widget.targetLabel, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ),
      labelStyle: TextStyle(fontSize: 12),
    );

    void swapInputs() {
      notifier.setDirection(
        isDirectionNormal ? NumericUnitsConversionDirection.reversed : NumericUnitsConversionDirection.normal,
      );
    }

    inputController.text = state.source == -1 ? "" : state.source.toString();
    outputController.text = state.target == -1 ? "" : state.target.toString();

    var fields = [
      NumericUnitsRowField(
        controller: inputController,
        decoration: inputDecoration,
        onChanged: (text) {
          notifier.setSource(int.tryParse(text) ?? 0);
        },
      ),
      IconButton(onPressed: swapInputs, icon: Icon(Icons.sync_alt)),
      NumericUnitsRowField(
        controller: outputController,
        decoration: outputDecoration,
        onChanged: (text) {
          notifier.setTarget(int.tryParse(text) ?? 0);
        },
      ),
    ];

    if (!isDirectionNormal) {
      fields = fields.reversed.toList();
    }

    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(widget.title, style: Theme.of(context).textTheme.labelLarge),
          ),
          Row(children: fields),
        ],
      ),
    );
  }
}
