import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowDragReorderHandlesSwitch extends ConsumerWidget {
  final bool value;

  const ShowDragReorderHandlesSwitch({super.key, required this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      title: Text(AppLocalizations.of(context)!.showDragToReorderHandles),
      value: value,
      onChanged: (bool value) {
        ref.read(settingsNotifierProvider.notifier).setDragReorderHandles(value);
      },
      secondary: const Icon(Icons.drag_indicator),
    );
  }
}
