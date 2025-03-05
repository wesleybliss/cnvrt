import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cnvrt/domain/di/providers/state/currencies_provider.dart';
import 'package:cnvrt/domain/models/currency.dart';
import 'package:cnvrt/store/SimpleCurrencyStore.dart';
import 'package:cnvrt/utils/logger.dart';

class CurrenciesList extends ConsumerWidget {
  final List<Currency> currencies;
  final VoidCallback onFavoriteToggled;

  const CurrenciesList({super.key, required this.currencies, required this.onFavoriteToggled});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: currencies.length ?? 0,
      itemBuilder: (context, index) {
        final log = Logger('CurrenciesList');
        final item = currencies[index];

        return ListTile(
          title: Text(item.symbol),
          subtitle: Text(item.name),
          trailing: Icon(
            item.selected ? Icons.favorite : Icons.favorite_border_outlined,
          ),
          onTap: () async {
            final box = store.box<Currency>();
            final next = item.copyWith(selected: !item.selected);

            // Update observable state
            ref.read(currenciesProvider.notifier).setCurrency(next);

            // Update saved data
            await box.putAsync(next);

            onFavoriteToggled();
          },
        );
      },
    );
  }
}
