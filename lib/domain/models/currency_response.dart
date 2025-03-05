import 'package:cnvrt/domain/models/currency_response_data.dart';

class CurrencyResponse {
  final String source;
  final int timestamp;
  final CurrencyResponseData data;

  CurrencyResponse({
    required this.source,
    required this.timestamp,
    required this.data,
  });

  factory CurrencyResponse.fromJson(Map<String, dynamic> json) {
    return CurrencyResponse(
      source: json['source'],
      timestamp: json['timestamp'],
      data: CurrencyResponseData.fromJson(json['data']),
    );
  }
}
