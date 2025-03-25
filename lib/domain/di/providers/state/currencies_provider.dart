import 'package:cnvrt/db/database.dart';
import 'package:cnvrt/domain/constants/constants.dart';
import 'package:cnvrt/domain/di/spot.dart';
import 'package:cnvrt/domain/io/repos/i_currencies_repo.dart';
import 'package:cnvrt/domain/io/services/i_currencies_service.dart';
import 'package:cnvrt/domain/models/currency_response.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrenciesState {
  final List<Currency> currencies;
  final bool loading;
  final String? error;
  final bool isFetching;

  CurrenciesState({List<Currency>? currencies, this.loading = false, this.error, this.isFetching = false})
    : currencies = currencies ?? List.empty();
}

class CurrenciesNotifier extends StateNotifier<CurrenciesState> {
  final log = Logger('CurrenciesNotifier');
  final currenciesRepo = spot<ICurrenciesRepo>();
  final currenciesService = spot<ICurrenciesService>();

  CurrenciesNotifier() : super(CurrenciesState());

  void setCurrency(Currency currency) {
    final next = state.currencies.map((e) => e.id == currency.id ? currency : e).toList();
    state = CurrenciesState(currencies: next);
    currenciesRepo.create(currency);
  }

  Future<void> clearCurrencies() async {
    await currenciesRepo.deleteAll();
    state = CurrenciesState(currencies: [], loading: false);
  }

  Future<List<Currency>> readCurrencies({bool showLoading = true}) async {
    if (showLoading) {
      state = CurrenciesState(loading: true);
    }

    final items = await currenciesRepo.findAllOrderedByOrder();

    state = CurrenciesState(currencies: items, loading: false);

    // log.d('readCurrencies:\n${items.map((e) => '${e.symbol}: (${e.selected})').join('\n')}');
    log.d('readCurrencies: ${items.length}');

    return items;
  }

  Future<void> fetchCurrencies() async {
    state = CurrenciesState(loading: true, isFetching: true, currencies: state.currencies);

    try {
      final CurrencyResponse? res = await currenciesService.fetchCurrencies();

      final data = res?.data.currencies ?? [];

      log.d("fetchCurrencies: upserting $data");

      // Update currencies without destroying locally saved data, like selected state
      final savedCurrencies = await currenciesRepo.upsertManyCompanions(data);

      state = CurrenciesState(loading: false, isFetching: false, currencies: savedCurrencies);
    } catch (e) {
      log.e('error', e);
      state = CurrenciesState(loading: false, isFetching: false, error: e.toString());
    }
  }

  Future<void> initializeCurrencies() async {
    final keys = Constants.keys.settings;
    final prefs = await SharedPreferences.getInstance();
    final lastUpdatedValue = prefs.getString(keys.lastUpdated);
    final lastUpdated = lastUpdatedValue != null ? DateTime.parse(lastUpdatedValue) : null;
    final lastUpdatedDiff = lastUpdated == null ? 0 : DateTime.now().difference(lastUpdated).inHours;
    final updateFrequencyInHours = prefs.getInt(keys.updateFrequencyInHours);
    final shouldUpdate = lastUpdated == null || lastUpdatedDiff > (updateFrequencyInHours ?? 12);
    final savedCurrencies = await readCurrencies();

    // If we haven't fetched in more than 6 hours, fetch again
    if (savedCurrencies.isEmpty || shouldUpdate) {
      log.d('Initializing currencies. Either no currencies saved, or more than 6 hours since last update');
      await fetchCurrencies();

      prefs.setString(keys.lastUpdated, DateTime.now().toIso8601String());
    }
  }
}

final currenciesProvider = StateNotifierProvider<CurrenciesNotifier, CurrenciesState>((ref) {
  return CurrenciesNotifier();
});

final selectedCurrenciesProvider = Provider<List<Currency>>((ref) {
  // Watch the state from the currenciesProvider
  final currenciesState = ref.watch(currenciesProvider);
  // Derive the selected currencies
  return currenciesState.currencies.where((currency) => currency.selected).toList();
});

class FocusedCurrencyInputSymbolNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setSymbol(String value) {
    state = value;
  }
}

// Provider to track the currently selected input's currency symbol
final focusedCurrencyInputSymbolProvider = NotifierProvider<FocusedCurrencyInputSymbolNotifier, String?>(
  FocusedCurrencyInputSymbolNotifier.new,
);
