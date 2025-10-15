import 'package:cnvrt/domain/di/providers/currencies/currencies_provider.dart';
import 'package:cnvrt/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrenciesError extends ConsumerWidget {
  const CurrenciesError({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currenciesProvider);

    void onFetchCurrenciesClick() {
      ref.read(currenciesProvider.notifier).fetchCurrencies();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${AppLocalizations.of(context)!.error}: ${state.error}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onFetchCurrenciesClick,
            child: Text(AppLocalizations.of(context)!.fetchCurrencies),
          ),
        ],
      ),
    );
  }
}
