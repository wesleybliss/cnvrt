import 'package:cnvrt/domain/di/providers/currencies/currencies_provider.dart';
import 'package:cnvrt/l10n/app_localizations.dart';
import 'package:cnvrt/ui/widgets/currencies_list.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrenciesReady extends ConsumerStatefulWidget {
  const CurrenciesReady({super.key});

  @override
  ConsumerState<CurrenciesReady> createState() => _CurrenciesReadyState();
}

class _CurrenciesReadyState extends ConsumerState<CurrenciesReady> {
  final log = Logger('CurrenciesReady');
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(currenciesProvider);
    final searchText = controller.text.toLowerCase();

    final filteredCurrencies =
        searchText.isEmpty
            ? state.currencies
            : state.currencies.where((it) {
              final currencyName = it.name.toLowerCase();
              final currencySymbol = it.symbol.toLowerCase();
              return currencyName.contains(searchText) || currencySymbol.contains(searchText);
            }).toList();

    filteredCurrencies.sort((a, b) {
      if (a.selected && !b.selected) {
        return -1; // a is selected, b is not
      } else if (!a.selected && b.selected) {
        return 1; // a is not selected, b is
      } else {
        return a.symbol.compareTo(b.symbol); // Both are selected or both are not selected
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Text(
            AppLocalizations.of(context)!.chooseYourFavoriteCurrencies,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              labelText: AppLocalizations.of(context)!.searchByNameOrSymbol,
            ),
            onChanged: (text) {
              // Empty state update to trigger the change & filter the list
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: CurrenciesList(
            currencies: filteredCurrencies,
            onFavoriteToggled: () {
              controller.clear();
              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}
