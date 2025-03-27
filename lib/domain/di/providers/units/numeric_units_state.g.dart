// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'numeric_units_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NumericUnitsStateModelCWProxy {
  NumericUnitsStateModel source(int source);

  NumericUnitsStateModel target(int target);

  NumericUnitsStateModel direction(NumericUnitsConversionDirection direction);

  NumericUnitsStateModel convertNormalFn(int Function(int) convertNormalFn);

  NumericUnitsStateModel convertReversedFn(int Function(int) convertReversedFn);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NumericUnitsStateModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NumericUnitsStateModel(...).copyWith(id: 12, name: "My name")
  /// ````
  NumericUnitsStateModel call({
    int source,
    int target,
    NumericUnitsConversionDirection direction,
    int Function(int) convertNormalFn,
    int Function(int) convertReversedFn,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfNumericUnitsStateModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfNumericUnitsStateModel.copyWith.fieldName(...)`
class _$NumericUnitsStateModelCWProxyImpl
    implements _$NumericUnitsStateModelCWProxy {
  const _$NumericUnitsStateModelCWProxyImpl(this._value);

  final NumericUnitsStateModel _value;

  @override
  NumericUnitsStateModel source(int source) => this(source: source);

  @override
  NumericUnitsStateModel target(int target) => this(target: target);

  @override
  NumericUnitsStateModel direction(NumericUnitsConversionDirection direction) =>
      this(direction: direction);

  @override
  NumericUnitsStateModel convertNormalFn(int Function(int) convertNormalFn) =>
      this(convertNormalFn: convertNormalFn);

  @override
  NumericUnitsStateModel convertReversedFn(
          int Function(int) convertReversedFn) =>
      this(convertReversedFn: convertReversedFn);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NumericUnitsStateModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NumericUnitsStateModel(...).copyWith(id: 12, name: "My name")
  /// ````
  NumericUnitsStateModel call({
    Object? source = const $CopyWithPlaceholder(),
    Object? target = const $CopyWithPlaceholder(),
    Object? direction = const $CopyWithPlaceholder(),
    Object? convertNormalFn = const $CopyWithPlaceholder(),
    Object? convertReversedFn = const $CopyWithPlaceholder(),
  }) {
    return NumericUnitsStateModel(
      source == const $CopyWithPlaceholder()
          ? _value.source
          // ignore: cast_nullable_to_non_nullable
          : source as int,
      target == const $CopyWithPlaceholder()
          ? _value.target
          // ignore: cast_nullable_to_non_nullable
          : target as int,
      direction == const $CopyWithPlaceholder()
          ? _value.direction
          // ignore: cast_nullable_to_non_nullable
          : direction as NumericUnitsConversionDirection,
      convertNormalFn: convertNormalFn == const $CopyWithPlaceholder()
          ? _value.convertNormalFn
          // ignore: cast_nullable_to_non_nullable
          : convertNormalFn as int Function(int),
      convertReversedFn: convertReversedFn == const $CopyWithPlaceholder()
          ? _value.convertReversedFn
          // ignore: cast_nullable_to_non_nullable
          : convertReversedFn as int Function(int),
    );
  }
}

extension $NumericUnitsStateModelCopyWith on NumericUnitsStateModel {
  /// Returns a callable class that can be used as follows: `instanceOfNumericUnitsStateModel.copyWith(...)` or like so:`instanceOfNumericUnitsStateModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NumericUnitsStateModelCWProxy get copyWith =>
      _$NumericUnitsStateModelCWProxyImpl(this);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$numericUnitsStateHash() => r'6d481c045d766286c6e0aff4fec7dc08de92e5dc';

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

abstract class _$NumericUnitsState
    extends BuildlessAutoDisposeNotifier<NumericUnitsStateModel> {
  late final int source;
  late final int target;
  late final int Function(int) convertNormalFn;
  late final int Function(int) convertReversedFn;
  late final NumericUnitsConversionDirection direction;

  NumericUnitsStateModel build({
    int source = -1,
    int target = -1,
    required int Function(int) convertNormalFn,
    required int Function(int) convertReversedFn,
    NumericUnitsConversionDirection direction =
        NumericUnitsConversionDirection.normal,
  });
}

/// See also [NumericUnitsState].
@ProviderFor(NumericUnitsState)
const numericUnitsStateProvider = NumericUnitsStateFamily();

/// See also [NumericUnitsState].
class NumericUnitsStateFamily extends Family<NumericUnitsStateModel> {
  /// See also [NumericUnitsState].
  const NumericUnitsStateFamily();

  /// See also [NumericUnitsState].
  NumericUnitsStateProvider call({
    int source = -1,
    int target = -1,
    required int Function(int) convertNormalFn,
    required int Function(int) convertReversedFn,
    NumericUnitsConversionDirection direction =
        NumericUnitsConversionDirection.normal,
  }) {
    return NumericUnitsStateProvider(
      source: source,
      target: target,
      convertNormalFn: convertNormalFn,
      convertReversedFn: convertReversedFn,
      direction: direction,
    );
  }

  @override
  NumericUnitsStateProvider getProviderOverride(
    covariant NumericUnitsStateProvider provider,
  ) {
    return call(
      source: provider.source,
      target: provider.target,
      convertNormalFn: provider.convertNormalFn,
      convertReversedFn: provider.convertReversedFn,
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
  String? get name => r'numericUnitsStateProvider';
}

/// See also [NumericUnitsState].
class NumericUnitsStateProvider extends AutoDisposeNotifierProviderImpl<
    NumericUnitsState, NumericUnitsStateModel> {
  /// See also [NumericUnitsState].
  NumericUnitsStateProvider({
    int source = -1,
    int target = -1,
    required int Function(int) convertNormalFn,
    required int Function(int) convertReversedFn,
    NumericUnitsConversionDirection direction =
        NumericUnitsConversionDirection.normal,
  }) : this._internal(
          () => NumericUnitsState()
            ..source = source
            ..target = target
            ..convertNormalFn = convertNormalFn
            ..convertReversedFn = convertReversedFn
            ..direction = direction,
          from: numericUnitsStateProvider,
          name: r'numericUnitsStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$numericUnitsStateHash,
          dependencies: NumericUnitsStateFamily._dependencies,
          allTransitiveDependencies:
              NumericUnitsStateFamily._allTransitiveDependencies,
          source: source,
          target: target,
          convertNormalFn: convertNormalFn,
          convertReversedFn: convertReversedFn,
          direction: direction,
        );

  NumericUnitsStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.source,
    required this.target,
    required this.convertNormalFn,
    required this.convertReversedFn,
    required this.direction,
  }) : super.internal();

  final int source;
  final int target;
  final int Function(int) convertNormalFn;
  final int Function(int) convertReversedFn;
  final NumericUnitsConversionDirection direction;

  @override
  NumericUnitsStateModel runNotifierBuild(
    covariant NumericUnitsState notifier,
  ) {
    return notifier.build(
      source: source,
      target: target,
      convertNormalFn: convertNormalFn,
      convertReversedFn: convertReversedFn,
      direction: direction,
    );
  }

  @override
  Override overrideWith(NumericUnitsState Function() create) {
    return ProviderOverride(
      origin: this,
      override: NumericUnitsStateProvider._internal(
        () => create()
          ..source = source
          ..target = target
          ..convertNormalFn = convertNormalFn
          ..convertReversedFn = convertReversedFn
          ..direction = direction,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        source: source,
        target: target,
        convertNormalFn: convertNormalFn,
        convertReversedFn: convertReversedFn,
        direction: direction,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<NumericUnitsState, NumericUnitsStateModel>
      createElement() {
    return _NumericUnitsStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NumericUnitsStateProvider &&
        other.source == source &&
        other.target == target &&
        other.convertNormalFn == convertNormalFn &&
        other.convertReversedFn == convertReversedFn &&
        other.direction == direction;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);
    hash = _SystemHash.combine(hash, target.hashCode);
    hash = _SystemHash.combine(hash, convertNormalFn.hashCode);
    hash = _SystemHash.combine(hash, convertReversedFn.hashCode);
    hash = _SystemHash.combine(hash, direction.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NumericUnitsStateRef
    on AutoDisposeNotifierProviderRef<NumericUnitsStateModel> {
  /// The parameter `source` of this provider.
  int get source;

  /// The parameter `target` of this provider.
  int get target;

  /// The parameter `convertNormalFn` of this provider.
  int Function(int) get convertNormalFn;

  /// The parameter `convertReversedFn` of this provider.
  int Function(int) get convertReversedFn;

  /// The parameter `direction` of this provider.
  NumericUnitsConversionDirection get direction;
}

class _NumericUnitsStateProviderElement
    extends AutoDisposeNotifierProviderElement<NumericUnitsState,
        NumericUnitsStateModel> with NumericUnitsStateRef {
  _NumericUnitsStateProviderElement(super.provider);

  @override
  int get source => (origin as NumericUnitsStateProvider).source;
  @override
  int get target => (origin as NumericUnitsStateProvider).target;
  @override
  int Function(int) get convertNormalFn =>
      (origin as NumericUnitsStateProvider).convertNormalFn;
  @override
  int Function(int) get convertReversedFn =>
      (origin as NumericUnitsStateProvider).convertReversedFn;
  @override
  NumericUnitsConversionDirection get direction =>
      (origin as NumericUnitsStateProvider).direction;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
