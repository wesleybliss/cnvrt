
import 'package:cnvrt/domain/models/currency.dart';

class CurrencyResponseData {
  
  final List<Currency> currencies;
  
  CurrencyResponseData({
    required this.currencies,
  });
  
  factory CurrencyResponseData.fromJson(Map<String, dynamic> json) {
    final currencies = json['currencies'] as List<dynamic>;
    return CurrencyResponseData(
      currencies: List<Currency>.from(
        currencies.map((x) => Currency.fromJson(x)),
      ),
    );
  }
  
}
