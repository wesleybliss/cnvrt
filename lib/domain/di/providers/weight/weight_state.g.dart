// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WeightStateModelCWProxy {
  WeightStateModel pounds(int pounds);

  WeightStateModel kilograms(int kilograms);

  WeightStateModel direction(WeightConversionDirection direction);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WeightStateModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WeightStateModel(...).copyWith(id: 12, name: "My name")
  /// ````
  WeightStateModel call({
    int pounds,
    int kilograms,
    WeightConversionDirection direction,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWeightStateModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWeightStateModel.copyWith.fieldName(...)`
class _$WeightStateModelCWProxyImpl implements _$WeightStateModelCWProxy {
  const _$WeightStateModelCWProxyImpl(this._value);

  final WeightStateModel _value;

  @override
  WeightStateModel pounds(int pounds) => this(pounds: pounds);

  @override
  WeightStateModel kilograms(int kilograms) => this(kilograms: kilograms);

  @override
  WeightStateModel direction(WeightConversionDirection direction) =>
      this(direction: direction);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WeightStateModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WeightStateModel(...).copyWith(id: 12, name: "My name")
  /// ````
  WeightStateModel call({
    Object? pounds = const $CopyWithPlaceholder(),
    Object? kilograms = const $CopyWithPlaceholder(),
    Object? direction = const $CopyWithPlaceholder(),
  }) {
    return WeightStateModel(
      pounds == const $CopyWithPlaceholder()
          ? _value.pounds
          // ignore: cast_nullable_to_non_nullable
          : pounds as int,
      kilograms == const $CopyWithPlaceholder()
          ? _value.kilograms
          // ignore: cast_nullable_to_non_nullable
          : kilograms as int,
      direction == const $CopyWithPlaceholder()
          ? _value.direction
          // ignore: cast_nullable_to_non_nullable
          : direction as WeightConversionDirection,
    );
  }
}

extension $WeightStateModelCopyWith on WeightStateModel {
  /// Returns a callable class that can be used as follows: `instanceOfWeightStateModel.copyWith(...)` or like so:`instanceOfWeightStateModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WeightStateModelCWProxy get copyWith => _$WeightStateModelCWProxyImpl(this);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$weightStateHash() => r'680e49d058d3d039f54eb5a15a027c9a226f62e1';

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

abstract class _$WeightState
    extends BuildlessAutoDisposeNotifier<WeightStateModel> {
  late final int pounds;
  late final int kilograms;
  late final WeightConversionDirection direction;

  WeightStateModel build({
    int pounds = -1,
    int kilograms = -1,
    WeightConversionDirection direction =
        WeightConversionDirection.kilogramsToPounds,
  });
}

/// See also [WeightState].
@ProviderFor(WeightState)
const weightStateProvider = WeightStateFamily();

/// See also [WeightState].
class WeightStateFamily extends Family<WeightStateModel> {
  /// See also [WeightState].
  const WeightStateFamily();

  /// See also [WeightState].
  WeightStateProvider call({
    int pounds = -1,
    int kilograms = -1,
    WeightConversionDirection direction =
        WeightConversionDirection.kilogramsToPounds,
  }) {
    return WeightStateProvider(
      pounds: pounds,
      kilograms: kilograms,
      direction: direction,
    );
  }

  @override
  WeightStateProvider getProviderOverride(
    covariant WeightStateProvider provider,
  ) {
    return call(
      pounds: provider.pounds,
      kilograms: provider.kilograms,
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
  String? get name => r'weightStateProvider';
}

/// See also [WeightState].
class WeightStateProvider
    extends AutoDisposeNotifierProviderImpl<WeightState, WeightStateModel> {
  /// See also [WeightState].
  WeightStateProvider({
    int pounds = -1,
    int kilograms = -1,
    WeightConversionDirection direction =
        WeightConversionDirection.kilogramsToPounds,
  }) : this._internal(
          () => WeightState()
            ..pounds = pounds
            ..kilograms = kilograms
            ..direction = direction,
          from: weightStateProvider,
          name: r'weightStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$weightStateHash,
          dependencies: WeightStateFamily._dependencies,
          allTransitiveDependencies:
              WeightStateFamily._allTransitiveDependencies,
          pounds: pounds,
          kilograms: kilograms,
          direction: direction,
        );

  WeightStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pounds,
    required this.kilograms,
    required this.direction,
  }) : super.internal();

  final int pounds;
  final int kilograms;
  final WeightConversionDirection direction;

  @override
  WeightStateModel runNotifierBuild(
    covariant WeightState notifier,
  ) {
    return notifier.build(
      pounds: pounds,
      kilograms: kilograms,
      direction: direction,
    );
  }

  @override
  Override overrideWith(WeightState Function() create) {
    return ProviderOverride(
      origin: this,
      override: WeightStateProvider._internal(
        () => create()
          ..pounds = pounds
          ..kilograms = kilograms
          ..direction = direction,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pounds: pounds,
        kilograms: kilograms,
        direction: direction,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<WeightState, WeightStateModel>
      createElement() {
    return _WeightStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WeightStateProvider &&
        other.pounds == pounds &&
        other.kilograms == kilograms &&
        other.direction == direction;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pounds.hashCode);
    hash = _SystemHash.combine(hash, kilograms.hashCode);
    hash = _SystemHash.combine(hash, direction.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WeightStateRef on AutoDisposeNotifierProviderRef<WeightStateModel> {
  /// The parameter `pounds` of this provider.
  int get pounds;

  /// The parameter `kilograms` of this provider.
  int get kilograms;

  /// The parameter `direction` of this provider.
  WeightConversionDirection get direction;
}

class _WeightStateProviderElement
    extends AutoDisposeNotifierProviderElement<WeightState, WeightStateModel>
    with WeightStateRef {
  _WeightStateProviderElement(super.provider);

  @override
  int get pounds => (origin as WeightStateProvider).pounds;
  @override
  int get kilograms => (origin as WeightStateProvider).kilograms;
  @override
  WeightConversionDirection get direction =>
      (origin as WeightStateProvider).direction;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
