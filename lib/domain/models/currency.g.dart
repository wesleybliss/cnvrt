// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CurrencyCWProxy {
  Currency id(int id);

  Currency symbol(String symbol);

  Currency name(String name);

  Currency rate(double rate);

  Currency selected(bool selected);

  Currency order(int order);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Currency(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Currency(...).copyWith(id: 12, name: "My name")
  /// ````
  Currency call({
    int id,
    String symbol,
    String name,
    double rate,
    bool selected,
    int order,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCurrency.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCurrency.copyWith.fieldName(...)`
class _$CurrencyCWProxyImpl implements _$CurrencyCWProxy {
  const _$CurrencyCWProxyImpl(this._value);

  final Currency _value;

  @override
  Currency id(int id) => this(id: id);

  @override
  Currency symbol(String symbol) => this(symbol: symbol);

  @override
  Currency name(String name) => this(name: name);

  @override
  Currency rate(double rate) => this(rate: rate);

  @override
  Currency selected(bool selected) => this(selected: selected);

  @override
  Currency order(int order) => this(order: order);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Currency(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Currency(...).copyWith(id: 12, name: "My name")
  /// ````
  Currency call({
    Object? id = const $CopyWithPlaceholder(),
    Object? symbol = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? rate = const $CopyWithPlaceholder(),
    Object? selected = const $CopyWithPlaceholder(),
    Object? order = const $CopyWithPlaceholder(),
  }) {
    return Currency(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      symbol: symbol == const $CopyWithPlaceholder()
          ? _value.symbol
          // ignore: cast_nullable_to_non_nullable
          : symbol as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      rate: rate == const $CopyWithPlaceholder()
          ? _value.rate
          // ignore: cast_nullable_to_non_nullable
          : rate as double,
      selected: selected == const $CopyWithPlaceholder()
          ? _value.selected
          // ignore: cast_nullable_to_non_nullable
          : selected as bool,
      order: order == const $CopyWithPlaceholder()
          ? _value.order
          // ignore: cast_nullable_to_non_nullable
          : order as int,
    );
  }
}

extension $CurrencyCopyWith on Currency {
  /// Returns a callable class that can be used as follows: `instanceOfCurrency.copyWith(...)` or like so:`instanceOfCurrency.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CurrencyCWProxy get copyWith => _$CurrencyCWProxyImpl(this);
}
