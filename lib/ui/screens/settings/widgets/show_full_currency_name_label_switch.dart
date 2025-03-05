import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cnvrt/domain/di/providers/settings_provider.dart';

class ShowFullCurrencyNameLabelSwitch extends ConsumerWidget {
  final bool value;

  const ShowFullCurrencyNameLabelSwitch({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      title: const Text('Show full currency name label'),
      value: value,
      onChanged: (bool value) {
        ref.read(settingsNotifierProvider.notifier).setShowFullCurrencyNameLabel(value);
      },
      secondary: const Icon(Icons.label),
    );
  }
}
