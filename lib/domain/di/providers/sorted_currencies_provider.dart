import 'package:cnvrt/db/database.dart';
import 'package:cnvrt/domain/di/providers/state/currencies_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sortedCurrenciesProvider = StateNotifierProvider<SortedCurrenciesNotifier, List<Currency>>((ref) {
  // Initialize with the selected currencies
  final selectedCurrencies = ref.watch(selectedCurrenciesProvider);
  return SortedCurrenciesNotifier(selectedCurrencies, ref);
});

class SortedCurrenciesNotifier extends StateNotifier<List<Currency>> {
  final Ref ref;

  SortedCurrenciesNotifier(List<Currency> initialCurrencies, this.ref)
    : super(
        List.from(initialCurrencies)..sort((a, b) {
          final orderComparison = a.order.compareTo(b.order);
          if (orderComparison != 0) return orderComparison;
          return a.symbol.compareTo(b.symbol);
        }),
      );

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;

    final item = state.removeAt(oldIndex);
    state.insert(newIndex, item);

    // Update order properties
    for (int i = 0; i < state.length; i++) {
      final updatedCurrency = state[i].copyWith(order: i);
      state[i] = updatedCurrency;

      // Persist changes to disk
      ref.read(currenciesProvider.notifier).setCurrency(updatedCurrency);
    }
  }
}
