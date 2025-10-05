import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InputsPositionDropdown extends ConsumerWidget {
  final String value;

  const InputsPositionDropdown({super.key, required this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dropdown = DropdownButton(
      value: value,
      items: const [
        DropdownMenuItem(value: "top", child: Text("Top")),
        DropdownMenuItem(value: "center", child: Text("Center")),
        DropdownMenuItem(value: "bottom", child: Text("Bottom")),
      ],
      onChanged: (String? value) {
        ref.read(settingsNotifierProvider.notifier).setInputsPosition(value ?? "center");
      },
      hint: Text(AppLocalizations.of(context)!.selectAnOption),
    );

    return ListTile(
      title: Text(AppLocalizations.of(context)!.alignInputsTo),
      subtitle: Text(AppLocalizations.of(context)!.alignInputsToDescription),
      leading: const Icon(Icons.align_vertical_center),
      trailing: dropdown,
    );
  }
}
