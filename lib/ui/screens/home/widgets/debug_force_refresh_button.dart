import 'package:cnvrt/domain/di/providers/currencies/currencies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cnvrt/ui/widgets/currency_inputs_list/currency_inputs_list_vm.dart';

class DebugForceRefreshButton extends ConsumerStatefulWidget {
  const DebugForceRefreshButton({super.key});

  @override
  ConsumerState<DebugForceRefreshButton> createState() =>
      _DebugForceRefreshButton();
}

class _DebugForceRefreshButton extends ConsumerState<DebugForceRefreshButton> {
  void triggerForceRefresh() async {
    // Suppress clearing inputs during refresh
    // ref.read(currencyInputsListViewModelProvider.notifier).startSuppressClear();
    await ref.read(currenciesProvider.notifier).fetchCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(currenciesProvider);

    return ElevatedButton(
      onPressed: triggerForceRefresh,
      child: Text("Force Refresh"),
    );
  }
}
