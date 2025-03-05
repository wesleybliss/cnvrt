import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cnvrt/domain/di/providers/settings_provider.dart';

class ShowCopyToClipboardButtonsSwitch extends ConsumerWidget {
  final bool value;

  const ShowCopyToClipboardButtonsSwitch({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      title: const Text('Show copy to clipboard buttons'),
      value: value,
      onChanged: (bool value) {
        ref.read(settingsNotifierProvider.notifier).setShowCopyToClipboardButtons(value);
      },
      secondary: const Icon(Icons.copy),
    );
  }
}
