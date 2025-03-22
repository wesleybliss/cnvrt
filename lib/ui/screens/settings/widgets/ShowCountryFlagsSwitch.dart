import 'package:cnvrt/domain/di/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowCountryFlagsSwitch extends ConsumerWidget {
  final bool value;

  const ShowCountryFlagsSwitch({super.key, required this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      title: const Text('Show country flags'),
      value: value,
      onChanged: (bool value) {
        ref.read(settingsNotifierProvider.notifier).setShowCountryFlags(value);
      },
      secondary: const Icon(Icons.flag),
    );
  }
}
