import 'package:cnvrt/domain/di/providers/currencies/currencies_provider.dart';
import 'package:cnvrt/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrenciesLoading extends ConsumerWidget {
  const CurrenciesLoading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Utils.nextTick(() {
      // ref.read(currenciesProvider.notifier).fetchCurrencies();
      ref.read(currenciesProvider.notifier).readCurrencies();
    });

    return const Center(child: CircularProgressIndicator());
  }
}
