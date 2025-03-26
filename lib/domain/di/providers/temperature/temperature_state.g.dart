// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temperature_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TemperatureStateModelCWProxy {
  TemperatureStateModel celsius(int celsius);

  TemperatureStateModel fahrenheit(int fahrenheit);

  TemperatureStateModel direction(TemperatureConversionDirection direction);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TemperatureStateModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TemperatureStateModel(...).copyWith(id: 12, name: "My name")
  /// ````
  TemperatureStateModel call({
    int celsius,
    int fahrenheit,
    TemperatureConversionDirection direction,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTemperatureStateModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTemperatureStateModel.copyWith.fieldName(...)`
class _$TemperatureStateModelCWProxyImpl
    implements _$TemperatureStateModelCWProxy {
  const _$TemperatureStateModelCWProxyImpl(this._value);

  final TemperatureStateModel _value;

  @override
  TemperatureStateModel celsius(int celsius) => this(celsius: celsius);

  @override
  TemperatureStateModel fahrenheit(int fahrenheit) =>
      this(fahrenheit: fahrenheit);

  @override
  TemperatureStateModel direction(TemperatureConversionDirection direction) =>
      this(direction: direction);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TemperatureStateModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TemperatureStateModel(...).copyWith(id: 12, name: "My name")
  /// ````
  TemperatureStateModel call({
    Object? celsius = const $CopyWithPlaceholder(),
    Object? fahrenheit = const $CopyWithPlaceholder(),
    Object? direction = const $CopyWithPlaceholder(),
  }) {
    return TemperatureStateModel(
      celsius == const $CopyWithPlaceholder()
          ? _value.celsius
          // ignore: cast_nullable_to_non_nullable
          : celsius as int,
      fahrenheit == const $CopyWithPlaceholder()
          ? _value.fahrenheit
          // ignore: cast_nullable_to_non_nullable
          : fahrenheit as int,
      direction == const $CopyWithPlaceholder()
          ? _value.direction
          // ignore: cast_nullable_to_non_nullable
          : direction as TemperatureConversionDirection,
    );
  }
}

extension $TemperatureStateModelCopyWith on TemperatureStateModel {
  /// Returns a callable class that can be used as follows: `instanceOfTemperatureStateModel.copyWith(...)` or like so:`instanceOfTemperatureStateModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TemperatureStateModelCWProxy get copyWith =>
      _$TemperatureStateModelCWProxyImpl(this);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$temperatureStateHash() => r'f405743a6bfb28cb9a83e5648c9aaa07894c7f2d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$TemperatureState
    extends BuildlessAutoDisposeNotifier<TemperatureStateModel> {
  late final int celsius;
  late final int fahrenheit;
  late final TemperatureConversionDirection direction;

  TemperatureStateModel build({
    int celsius = -1,
    int fahrenheit = -1,
    TemperatureConversionDirection direction =
        TemperatureConversionDirection.celsiusToFahrenheit,
  });
}

/// See also [TemperatureState].
@ProviderFor(TemperatureState)
const temperatureStateProvider = TemperatureStateFamily();

/// See also [TemperatureState].
class TemperatureStateFamily extends Family<TemperatureStateModel> {
  /// See also [TemperatureState].
  const TemperatureStateFamily();

  /// See also [TemperatureState].
  TemperatureStateProvider call({
    int celsius = -1,
    int fahrenheit = -1,
    TemperatureConversionDirection direction =
        TemperatureConversionDirection.celsiusToFahrenheit,
  }) {
    return TemperatureStateProvider(
      celsius: celsius,
      fahrenheit: fahrenheit,
      direction: direction,
    );
  }

  @override
  TemperatureStateProvider getProviderOverride(
    covariant TemperatureStateProvider provider,
  ) {
    return call(
      celsius: provider.celsius,
      fahrenheit: provider.fahrenheit,
      direction: provider.direction,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'temperatureStateProvider';
}

/// See also [TemperatureState].
class TemperatureStateProvider extends AutoDisposeNotifierProviderImpl<
    TemperatureState, TemperatureStateModel> {
  /// See also [TemperatureState].
  TemperatureStateProvider({
    int celsius = -1,
    int fahrenheit = -1,
    TemperatureConversionDirection direction =
        TemperatureConversionDirection.celsiusToFahrenheit,
  }) : this._internal(
          () => TemperatureState()
            ..celsius = celsius
            ..fahrenheit = fahrenheit
            ..direction = direction,
          from: temperatureStateProvider,
          name: r'temperatureStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$temperatureStateHash,
          dependencies: TemperatureStateFamily._dependencies,
          allTransitiveDependencies:
              TemperatureStateFamily._allTransitiveDependencies,
          celsius: celsius,
          fahrenheit: fahrenheit,
          direction: direction,
        );

  TemperatureStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.celsius,
    required this.fahrenheit,
    required this.direction,
  }) : super.internal();

  final int celsius;
  final int fahrenheit;
  final TemperatureConversionDirection direction;

  @override
  TemperatureStateModel runNotifierBuild(
    covariant TemperatureState notifier,
  ) {
    return notifier.build(
      celsius: celsius,
      fahrenheit: fahrenheit,
      direction: direction,
    );
  }

  @override
  Override overrideWith(TemperatureState Function() create) {
    return ProviderOverride(
      origin: this,
      override: TemperatureStateProvider._internal(
        () => create()
          ..celsius = celsius
          ..fahrenheit = fahrenheit
          ..direction = direction,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        celsius: celsius,
        fahrenheit: fahrenheit,
        direction: direction,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<TemperatureState, TemperatureStateModel>
      createElement() {
    return _TemperatureStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TemperatureStateProvider &&
        other.celsius == celsius &&
        other.fahrenheit == fahrenheit &&
        other.direction == direction;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, celsius.hashCode);
    hash = _SystemHash.combine(hash, fahrenheit.hashCode);
    hash = _SystemHash.combine(hash, direction.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TemperatureStateRef
    on AutoDisposeNotifierProviderRef<TemperatureStateModel> {
  /// The parameter `celsius` of this provider.
  int get celsius;

  /// The parameter `fahrenheit` of this provider.
  int get fahrenheit;

  /// The parameter `direction` of this provider.
  TemperatureConversionDirection get direction;
}

class _TemperatureStateProviderElement
    extends AutoDisposeNotifierProviderElement<TemperatureState,
        TemperatureStateModel> with TemperatureStateRef {
  _TemperatureStateProviderElement(super.provider);

  @override
  int get celsius => (origin as TemperatureStateProvider).celsius;
  @override
  int get fahrenheit => (origin as TemperatureStateProvider).fahrenheit;
  @override
  TemperatureConversionDirection get direction =>
      (origin as TemperatureStateProvider).direction;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
