import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cnvrt/domain/di/providers/settings_provider.dart';

class InputsPositionDropdown extends ConsumerWidget {
  final String value;

  const InputsPositionDropdown({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dropdown = DropdownButton(
      value: value,
      items: const [
        DropdownMenuItem(
          value: "top",
          child: Text("Top"),
        ),
        DropdownMenuItem(
          value: "center",
          child: Text("Center"),
        ),
        DropdownMenuItem(
          value: "bottom",
          child: Text("Bottom"),
        ),
      ],
      onChanged: (String? value) {
        ref.read(settingsNotifierProvider.notifier).setInputsPosition(value ?? "center");
      },
      hint: const Text('Select an option'),
    );

    return ListTile(
      title: const Text('Align inputs to'),
      leading: const Icon(Icons.align_vertical_center),
      trailing: dropdown,
    );
  }
}
