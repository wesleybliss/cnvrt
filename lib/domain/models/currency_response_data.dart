import 'package:cnvrt/db/database.dart';
import 'package:drift/drift.dart' as drift;

class CurrencyResponseData {
  final List<CurrenciesCompanion> currencies;

  CurrencyResponseData({required this.currencies});

  factory CurrencyResponseData.fromJson(Map<String, dynamic> json) {
    final currencies = json['currencies'] as List<dynamic>;
    return CurrencyResponseData(
      currencies: currencies.map((x) => CurrenciesCompanion(
        id: drift.Value.absent(), // ID is absent because it's not saved yet
        symbol: drift.Value(x['symbol'] as String),
        name: drift.Value(x['name'] as String),
        rate: drift.Value((x['rate'] as num?)?.toDouble() ?? 0.0),
        selected: drift.Value(x['selected'] as bool? ?? false),
        order: drift.Value(x['order'] as int? ?? 0),
      )).toList(),
    );
  }
}
