import 'package:cnvrt/domain/di/providers/temperature_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnitsScreen extends ConsumerWidget {
  const UnitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final temperatureState = ref.watch(temperatureStateProvider);
    final temperatureNotifier = ref.read(temperatureStateProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Enter Temperature', border: OutlineInputBorder()),
            onChanged: (value) {
              final parsedValue = double.tryParse(value);
              if (parsedValue != null) {
                temperatureNotifier.setTemperature(parsedValue);
              }
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButton<TemperatureUnit>(
                value: temperatureState.inputUnit,
                items:
                    TemperatureUnit.values
                        .map((unit) => DropdownMenuItem(value: unit, child: Text(unit.name)))
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    temperatureNotifier.setInputUnit(value);
                  }
                },
              ),
              const Text('to'),
              DropdownButton<TemperatureUnit>(
                value: temperatureState.outputUnit,
                items:
                    TemperatureUnit.values
                        .map((unit) => DropdownMenuItem(value: unit, child: Text(unit.name)))
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    temperatureNotifier.setOutputUnit(value);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Result: ${temperatureNotifier.convertedTemperature.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(width: 8),
                  Text(temperatureState.outputUnit.name),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
