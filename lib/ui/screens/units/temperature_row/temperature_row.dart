import 'package:cnvrt/domain/di/providers/temperature/temperature_state.dart';
import 'package:cnvrt/theme.dart';
import 'package:cnvrt/ui/screens/units/temperature_row/temperature_row_field.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TemperatureRow extends ConsumerStatefulWidget {
  const TemperatureRow({super.key});

  @override
  TemperatureRowState createState() => TemperatureRowState();
}

class TemperatureRowState extends ConsumerState<TemperatureRow> {
  final log = Logger('TemperatureRow');
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
    final temperatureState = ref.watch(temperatureStateProvider());
    final temperatureNotifier = ref.read(temperatureStateProvider().notifier);
    final isCelsiusToFahrenheit = temperatureState.direction == TemperatureConversionDirection.celsiusToFahrenheit;

    final inputDecoration = defaultInputDecoration.copyWith(
      hintText: "1",
      prefix: Text("C"),
      labelStyle: TextStyle(fontSize: 12),
    );

    final outputDecoration = defaultInputDecoration.copyWith(
      hintText: "2",
      prefix: Text("F"),
      labelStyle: TextStyle(fontSize: 12),
    );

    void swapInputs() {
      temperatureNotifier.setDirection(
        isCelsiusToFahrenheit
            ? TemperatureConversionDirection.fahrenheitToCelsius
            : TemperatureConversionDirection.celsiusToFahrenheit,
      );
    }

    inputController.text = temperatureState.celsius == -1 ? "" : temperatureState.celsius.toString();
    outputController.text = temperatureState.fahrenheit == -1 ? "" : temperatureState.fahrenheit.toString();

    var fields = [
      TemperatureRowField(
        controller: inputController,
        decoration: inputDecoration,
        onChanged: (text) {
          temperatureNotifier.setCelsius(int.tryParse(text) ?? 0);
        },
      ),
      IconButton(onPressed: swapInputs, icon: Icon(Icons.sync_alt)),
      TemperatureRowField(
        controller: outputController,
        decoration: outputDecoration,
        onChanged: (text) {
          temperatureNotifier.setFahrenheit(int.tryParse(text) ?? 0);
        },
      ),
    ];

    if (!isCelsiusToFahrenheit) {
      fields = fields.reversed.toList();
    }

    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text("Temperature", style: Theme.of(context).textTheme.labelLarge),
          ),
          Row(children: fields),
        ],
      ),
    );
  }
}
