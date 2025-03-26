// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distance_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DistanceStateModelCWProxy {
  DistanceStateModel miles(int miles);

  DistanceStateModel kilometers(int kilometers);

  DistanceStateModel direction(DistanceConversionDirection direction);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DistanceStateModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DistanceStateModel(...).copyWith(id: 12, name: "My name")
  /// ````
  DistanceStateModel call({
    int miles,
    int kilometers,
    DistanceConversionDirection direction,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDistanceStateModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDistanceStateModel.copyWith.fieldName(...)`
class _$DistanceStateModelCWProxyImpl implements _$DistanceStateModelCWProxy {
  const _$DistanceStateModelCWProxyImpl(this._value);

  final DistanceStateModel _value;

  @override
  DistanceStateModel miles(int miles) => this(miles: miles);

  @override
  DistanceStateModel kilometers(int kilometers) => this(kilometers: kilometers);

  @override
  DistanceStateModel direction(DistanceConversionDirection direction) =>
      this(direction: direction);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DistanceStateModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DistanceStateModel(...).copyWith(id: 12, name: "My name")
  /// ````
  DistanceStateModel call({
    Object? miles = const $CopyWithPlaceholder(),
    Object? kilometers = const $CopyWithPlaceholder(),
    Object? direction = const $CopyWithPlaceholder(),
  }) {
    return DistanceStateModel(
      miles == const $CopyWithPlaceholder()
          ? _value.miles
          // ignore: cast_nullable_to_non_nullable
          : miles as int,
      kilometers == const $CopyWithPlaceholder()
          ? _value.kilometers
          // ignore: cast_nullable_to_non_nullable
          : kilometers as int,
      direction == const $CopyWithPlaceholder()
          ? _value.direction
          // ignore: cast_nullable_to_non_nullable
          : direction as DistanceConversionDirection,
    );
  }
}

extension $DistanceStateModelCopyWith on DistanceStateModel {
  /// Returns a callable class that can be used as follows: `instanceOfDistanceStateModel.copyWith(...)` or like so:`instanceOfDistanceStateModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DistanceStateModelCWProxy get copyWith =>
      _$DistanceStateModelCWProxyImpl(this);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$distanceStateHash() => r'408449a7a27ffbe8c11b00b401a731d7eefd2ee9';

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

abstract class _$DistanceState
    extends BuildlessAutoDisposeNotifier<DistanceStateModel> {
  late final int miles;
  late final int kilometers;
  late final DistanceConversionDirection direction;

  DistanceStateModel build({
    int miles = -1,
    int kilometers = -1,
    DistanceConversionDirection direction =
        DistanceConversionDirection.kilometersToMiles,
  });
}

/// See also [DistanceState].
@ProviderFor(DistanceState)
const distanceStateProvider = DistanceStateFamily();

/// See also [DistanceState].
class DistanceStateFamily extends Family<DistanceStateModel> {
  /// See also [DistanceState].
  const DistanceStateFamily();

  /// See also [DistanceState].
  DistanceStateProvider call({
    int miles = -1,
    int kilometers = -1,
    DistanceConversionDirection direction =
        DistanceConversionDirection.kilometersToMiles,
  }) {
    return DistanceStateProvider(
      miles: miles,
      kilometers: kilometers,
      direction: direction,
    );
  }

  @override
  DistanceStateProvider getProviderOverride(
    covariant DistanceStateProvider provider,
  ) {
    return call(
      miles: provider.miles,
      kilometers: provider.kilometers,
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
  String? get name => r'distanceStateProvider';
}

/// See also [DistanceState].
class DistanceStateProvider
    extends AutoDisposeNotifierProviderImpl<DistanceState, DistanceStateModel> {
  /// See also [DistanceState].
  DistanceStateProvider({
    int miles = -1,
    int kilometers = -1,
    DistanceConversionDirection direction =
        DistanceConversionDirection.kilometersToMiles,
  }) : this._internal(
          () => DistanceState()
            ..miles = miles
            ..kilometers = kilometers
            ..direction = direction,
          from: distanceStateProvider,
          name: r'distanceStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$distanceStateHash,
          dependencies: DistanceStateFamily._dependencies,
          allTransitiveDependencies:
              DistanceStateFamily._allTransitiveDependencies,
          miles: miles,
          kilometers: kilometers,
          direction: direction,
        );

  DistanceStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.miles,
    required this.kilometers,
    required this.direction,
  }) : super.internal();

  final int miles;
  final int kilometers;
  final DistanceConversionDirection direction;

  @override
  DistanceStateModel runNotifierBuild(
    covariant DistanceState notifier,
  ) {
    return notifier.build(
      miles: miles,
      kilometers: kilometers,
      direction: direction,
    );
  }

  @override
  Override overrideWith(DistanceState Function() create) {
    return ProviderOverride(
      origin: this,
      override: DistanceStateProvider._internal(
        () => create()
          ..miles = miles
          ..kilometers = kilometers
          ..direction = direction,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        miles: miles,
        kilometers: kilometers,
        direction: direction,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<DistanceState, DistanceStateModel>
      createElement() {
    return _DistanceStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DistanceStateProvider &&
        other.miles == miles &&
        other.kilometers == kilometers &&
        other.direction == direction;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, miles.hashCode);
    hash = _SystemHash.combine(hash, kilometers.hashCode);
    hash = _SystemHash.combine(hash, direction.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DistanceStateRef on AutoDisposeNotifierProviderRef<DistanceStateModel> {
  /// The parameter `miles` of this provider.
  int get miles;

  /// The parameter `kilometers` of this provider.
  int get kilometers;

  /// The parameter `direction` of this provider.
  DistanceConversionDirection get direction;
}

class _DistanceStateProviderElement extends AutoDisposeNotifierProviderElement<
    DistanceState, DistanceStateModel> with DistanceStateRef {
  _DistanceStateProviderElement(super.provider);

  @override
  int get miles => (origin as DistanceStateProvider).miles;
  @override
  int get kilometers => (origin as DistanceStateProvider).kilometers;
  @override
  DistanceConversionDirection get direction =>
      (origin as DistanceStateProvider).direction;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
