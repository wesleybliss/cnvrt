import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeDropdown extends ConsumerWidget {
  final String value;

  const ThemeDropdown({super.key, required this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dropdown = DropdownButton(
      value: value,
      items: [
        DropdownMenuItem(value: "dark", child: Text(AppLocalizations.of(context)!.dark)),
        DropdownMenuItem(value: "light", child: Text(AppLocalizations.of(context)!.light)),
        DropdownMenuItem(value: "system", child: Text(AppLocalizations.of(context)!.system)),
      ],
      onChanged: (String? value) {
        ref.read(settingsNotifierProvider.notifier).setTheme(value ?? "system");
      },
      hint: Text(AppLocalizations.of(context)!.selectAnOption),
    );

    return ListTile(
      title: Text(AppLocalizations.of(context)!.theme),
      subtitle: Text(AppLocalizations.of(context)!.themeDescription),
      leading: const Icon(Icons.color_lens),
      trailing: dropdown,
    );
  }
}
