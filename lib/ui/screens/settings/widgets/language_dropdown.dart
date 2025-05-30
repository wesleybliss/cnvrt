import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/l10n/app_localizations.dart';
import 'package:cnvrt/utils/language_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageDropdown extends ConsumerWidget {
  final String? value;

  const LanguageDropdown({super.key, required this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = [DropdownMenuItem(value: "system", child: Text(AppLocalizations.of(context)!.system))];

    for (var locale in AppLocalizations.supportedLocales) {
      final canonicalName = languageNamesMap[locale.languageCode] ?? locale.languageCode;

      items.add(DropdownMenuItem(value: locale.languageCode, child: Text(canonicalName)));
    }

    final dropdown = DropdownButton(
      value: value,
      items: items,
      onChanged: (String? value) {
        ref.read(settingsNotifierProvider.notifier).setLanguage(value ?? "system");
      },
      hint: Text(AppLocalizations.of(context)!.selectAnOption),
    );

    return ListTile(
      title: Text(AppLocalizations.of(context)!.language),
      leading: const Icon(Icons.language),
      trailing: dropdown,
    );
  }
}
