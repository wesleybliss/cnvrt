import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cnvrt/domain/di/providers/state/currencies_provider.dart';

class CurrenciesError extends ConsumerWidget {
  const CurrenciesError({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currenciesProvider);

    void onFetchCurrenciesClick() {
      ref.read(currenciesProvider.notifier).fetchCurrencies();
    }

    return Center(
        child: Column(children: [
          Text('Error: ${state.error}'),
        ]));
  }
}
