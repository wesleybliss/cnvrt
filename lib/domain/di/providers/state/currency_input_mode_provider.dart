import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CurrencyInputModes {
  normal,
  decimal, // @todo
  addition,
  subtraction,
  multiplication,
  division,
}

class CurrencyInputModeNotifier extends Notifier<CurrencyInputModes> {
  @override
  CurrencyInputModes build() => CurrencyInputModes.normal;

  void setMode(CurrencyInputModes value) {
    state = value;
  }
}

final currencyInputModeProvider = NotifierProvider<CurrencyInputModeNotifier, CurrencyInputModes>(
    CurrencyInputModeNotifier.new);
