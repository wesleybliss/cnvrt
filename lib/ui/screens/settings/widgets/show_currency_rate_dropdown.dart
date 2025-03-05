import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cnvrt/domain/di/providers/settings_provider.dart';

class ShowCurrencyRateDropdown extends ConsumerWidget {
  final String value;

  const ShowCurrencyRateDropdown({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dropdown = DropdownButton(
      value: value,
      items: const [
        DropdownMenuItem(
          value: "all",
          child: Text("All"),
        ),
        DropdownMenuItem(
          value: "selected",
          child: Text("Selected"),
        ),
        DropdownMenuItem(
          value: "none",
          child: Text("None"),
        ),
      ],
      onChanged: (String? value) {
        ref.read(settingsNotifierProvider.notifier).setShowCurrencyRate(value ?? "selected");
      },
      hint: const Text('Select an option'),
    );

    return ListTile(
      title: const Text('Show current rates'),
      leading: const Icon(Icons.message),
      trailing: dropdown,
    );
  }
}
