import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateFrequencyInHoursDropdown extends ConsumerWidget {
  final int value;

  const UpdateFrequencyInHoursDropdown({super.key, required this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dropdown = DropdownButton(
      value: value,
      items: const [
        DropdownMenuItem(value: 6, child: Text("6 hours")),
        DropdownMenuItem(value: 12, child: Text("12 hours")),
        DropdownMenuItem(value: 24, child: Text("24 hours")),
      ],
      onChanged: (int? value) {
        ref.read(settingsNotifierProvider.notifier).setUpdateFrequencyInHours(value ?? 12);
      },
      hint: const Text('Select an option'),
    );

    return ListTile(
      title: const Text('Update frequency'),
      leading: const Icon(Icons.access_time_filled),
      trailing: dropdown,
    );
  }
}
