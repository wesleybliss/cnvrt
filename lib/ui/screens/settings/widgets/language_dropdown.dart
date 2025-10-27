import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/l10n/app_localizations.dart';
import 'package:cnvrt/utils/language_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageDropdown extends ConsumerWidget {
  final String? value;

  const LanguageDropdown({super.key, required this.value});

  String _getLocalizedLanguageName(BuildContext context, String languageCode) {
    final l10n = AppLocalizations.of(context)!;
    switch (languageCode) {
      case 'en':
        return l10n.languageEnglish;
      case 'es':
        return l10n.languageSpanish;
      case 'it':
        return l10n.languageItalian;
      case 'zh':
        return l10n.languageChinese;
      default:
        // Fallback to existing map or the code itself
        return languageNamesMap[languageCode] ?? languageCode;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final items = [DropdownMenuItem(value: "system", child: Text(l10n.system))];

    for (var locale in AppLocalizations.supportedLocales) {
      final localizedName = _getLocalizedLanguageName(context, locale.languageCode);
      items.add(DropdownMenuItem(value: locale.languageCode, child: Text(localizedName)));
    }

    final dropdown = DropdownButton(
      value: value,
      items: items,
      onChanged: (String? value) {
        ref.read(settingsNotifierProvider.notifier).setLanguage(value ?? "system");
      },
      hint: Text(l10n.selectAnOption),
    );

    return ListTile(
      title: Text(l10n.language),
      subtitle: Text(l10n.languageDescription),
      leading: const Icon(Icons.language),
      trailing: dropdown,
    );
  }
}
