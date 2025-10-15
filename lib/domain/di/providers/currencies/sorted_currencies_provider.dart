import 'package:cnvrt/db/database.dart';
import 'package:cnvrt/domain/di/providers/currencies/currencies_provider.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Derived provider that automatically updates when selectedCurrenciesProvider changes
final sortedCurrenciesProvider = Provider<List<Currency>>((ref) {
  final log = Logger('sortedCurrenciesProvider');
  final selectedCurrencies = ref.watch(selectedCurrenciesProvider);
  
  final sorted = List<Currency>.from(selectedCurrencies)..sort((a, b) {
    final orderComparison = a.order.compareTo(b.order);
    if (orderComparison != 0) return orderComparison;
    return a.symbol.compareTo(b.symbol);
  });
  
  log.d('sorted currencies: ${sorted.map((e) => e.symbol).join(", ")}');
  return sorted;
});
