import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UseLargeInputsSwitch extends ConsumerWidget {
  final bool value;

  const UseLargeInputsSwitch({super.key, required this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      title: Text(AppLocalizations.of(context)!.useLargeInputs),
      subtitle: Text(AppLocalizations.of(context)!.useLargeInputsDescription),
      value: value,
      onChanged: (bool value) {
        ref.read(settingsNotifierProvider.notifier).setUseLargeInputs(value);
      },
      secondary: const Icon(Icons.format_size),
    );
  }
}
