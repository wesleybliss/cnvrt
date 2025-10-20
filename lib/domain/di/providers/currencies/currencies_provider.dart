import 'package:cnvrt/db/database.dart';
import 'package:cnvrt/domain/constants/constants.dart';
import 'package:cnvrt/utils/crashlytics_utils.dart';
import 'package:cnvrt/utils/network_utils.dart';
import 'package:spot_di/spot_di.dart';
import 'package:cnvrt/domain/io/repos/i_currencies_repo.dart';
import 'package:cnvrt/domain/io/services/i_currencies_service.dart';
import 'package:cnvrt/domain/models/currency_response.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrenciesState {
  final List<Currency> currencies;
  final bool loading;
  final Exception? error;
  final bool isFetching;
  final bool hasNetworkError;

  CurrenciesState({
    List<Currency>? currencies,
    this.loading = false,
    this.error,
    this.isFetching = false,
    this.hasNetworkError = false,
  }) : currencies = currencies ?? List.empty();

  CurrenciesState copyWith({
    List<Currency>? currencies,
    bool? loading,
    Exception? error,
    bool? isFetching,
    bool? hasNetworkError,
    bool clearError = false,
  }) {
    return CurrenciesState(
      currencies: currencies ?? this.currencies,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      isFetching: isFetching ?? this.isFetching,
      hasNetworkError: hasNetworkError ?? this.hasNetworkError,
    );
  }
}

class CurrenciesNotifier extends StateNotifier<CurrenciesState> {
  final log = Logger('CurrenciesNotifier');
  final currenciesRepo = spot<ICurrenciesRepo>();
  final currenciesService = spot<ICurrenciesService>();

  CurrenciesNotifier() : super(CurrenciesState());

  void setCurrency(Currency currency) {
    final next = state.currencies.map((e) => e.id == currency.id ? currency : e).toList();
    state = state.copyWith(currencies: next);
    currenciesRepo.create(currency);
  }

  Future<void> clearCurrencies() async {
    await currenciesRepo.deleteAll();
    state = state.copyWith(currencies: [], loading: false);
  }

  Future<List<Currency>> readCurrencies({bool showLoading = true}) async {
    if (showLoading) {
      state = state.copyWith(loading: true);
    }

    final items = await currenciesRepo.findAllOrderedByOrder();

    state = state.copyWith(currencies: items, loading: false);

    // log.d('readCurrencies:\n${items.map((e) => '${e.symbol}: (${e.selected})').join('\n')}');
    log.d('readCurrencies: ${items.length}');

    return items;
  }

  Future<void> fetchCurrencies() async {
    if (state.loading) return;

    state = state.copyWith(
      loading: true,
      isFetching: true,
      currencies: state.currencies,
    );

    try {
      final CurrencyResponse? res = await currenciesService.fetchCurrencies();

      final data = res?.data.currencies ?? [];

      log.d("fetchCurrencies: upserting ${data.length} currencies");

      // Update currencies without destroying locally saved data, like selected state
      final savedCurrencies = await currenciesRepo.upsertManyCompanions(data);

      // Success: clear any error states
      state = state.copyWith(
        loading: false,
        isFetching: false,
        currencies: savedCurrencies,
        hasNetworkError: false,
        clearError: true,
      );
    } catch (e, st) {
      final isConnectivity = isConnectivityError(e);
      final hasCache = state.currencies.isNotEmpty;

      if (isConnectivity) {
        log.w('Network connectivity issue: ${toStringSafe(e, maxLength: 200)}');
        
        if (hasCache) {
          // User has cached data, just flag the network error
          state = state.copyWith(
            loading: false,
            isFetching: false,
            hasNetworkError: true,
            clearError: true,
          );
        } else {
          // No cached data, set error for full-screen error display
          state = state.copyWith(
            loading: false,
            isFetching: false,
            hasNetworkError: true,
            error: e as Exception,
          );
        }
        return;
      }

      // Non-connectivity errors: report to Crashlytics and show error
      log.e('Non-connectivity error fetching currencies', e);
      await recordNonConnectivityError(e, st);
      
      state = state.copyWith(
        loading: false,
        isFetching: false,
        error: e as Exception,
        hasNetworkError: false,
      );
    }
  }

  Future<void> initializeCurrencies() async {
    final keys = Constants.keys.settings;
    final prefs = await SharedPreferences.getInstance();
    
    // Check if caching is disabled for debugging
    final disableCache = prefs.getBool(keys.disableCurrencyCaching) ?? false;
    if (disableCache) {
      log.d('Currency caching is disabled - forcing fresh fetch');
      await fetchCurrencies();
      prefs.setString(keys.lastUpdated, DateTime.now().toIso8601String());
      return;
    }
    
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
