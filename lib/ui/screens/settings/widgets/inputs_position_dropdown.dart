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
      items: [
        DropdownMenuItem(value: "top", child: Text(AppLocalizations.of(context)!.top)),
        DropdownMenuItem(value: "center", child: Text(AppLocalizations.of(context)!.center)),
        DropdownMenuItem(value: "bottom", child: Text(AppLocalizations.of(context)!.bottom)),
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
