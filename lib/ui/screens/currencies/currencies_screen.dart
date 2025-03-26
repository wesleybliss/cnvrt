import 'package:cnvrt/domain/di/providers/currencies/currencies_provider.dart';
import 'package:cnvrt/ui/screens/currencies/currencies_error.dart';
import 'package:cnvrt/ui/screens/currencies/currencies_loading.dart';
import 'package:cnvrt/ui/screens/currencies/currencies_ready.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrenciesScreen extends ConsumerStatefulWidget {
  const CurrenciesScreen({super.key});
  @override
  ConsumerState<CurrenciesScreen> createState() => _CurrenciesScreenState();
}

class _CurrenciesScreenState extends ConsumerState<CurrenciesScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(currenciesProvider);

    return state.loading
        ? const CurrenciesLoading()
        : state.error != null
        ? const CurrenciesError()
        : const CurrenciesReady();
  }
}
