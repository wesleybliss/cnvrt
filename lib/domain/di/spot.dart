import 'package:cnvrt/domain/di/disposable.dart';
import 'package:cnvrt/domain/di/spot_exception.dart';
import 'package:cnvrt/utils/logger.dart';

typedef SpotGetter<T> = T Function(Function<R>() get);

typedef SpotAsyncGetter<T> = Future<T> Function(Function<R>() get);

enum SpotType {
  factory,
  singleton,
  asyncSingleton,
}

/// Represents a service that can be located
/// type = the type of service (factory or singleton)
/// locator = the function to instantiate the type
/// The locator function is called lazily the first time the dependency is requested
class SpotService<T> {
  final SpotType type;
  final SpotGetter<T>? locator;
  final SpotAsyncGetter<T>? asyncLocator;
  final Type targetType;
  // int _observers = 0;

  // Instance of the dependency (only used for singletons)
  T? instance;
  bool _initializing = false;  // Flag for thread-safe initialization
  Future<T>? _initializationFuture;  // Track async initialization

  SpotService(this.type, this.locator, this.targetType, {this.asyncLocator});

  // int get observers => _observers;

  R _spot<R>() => Spot.spot<R>();

  T locate() {
    if (type == SpotType.asyncSingleton) {
      throw SpotException(
        'Cannot synchronously resolve async singleton $T. '
        'Use await Spot.spotAsync<$T>() instead.'
      );
    }

    if (type == SpotType.factory) {
      return locator!(_spot);
    }

    // Thread-safe singleton initialization
    // Note: Dart is single-threaded per isolate, but this prevents re-entrant
    // initialization issues and prepares for potential multi-isolate scenarios
    
    // Fast path: check if already initialized
    if (instance != null) return instance!;
    
    // Guard against re-entrant initialization (circular dependencies)
    if (_initializing) {
      throw SpotException(
        'Re-entrant initialization detected for $T. '
        'This usually indicates a circular dependency.'
      );
    }
    
    // Mark as initializing and create instance
    _initializing = true;
    try {
      instance = locator!(_spot);
      return instance!;
    } finally {
      _initializing = false;
    }
  }

  Future<T> locateAsync() async {
    if (type == SpotType.factory) {
      return locator!(_spot);
    }

    if (type == SpotType.singleton) {
      return locate();  // Delegate to sync method
    }

    // Async singleton
    if (instance != null) return instance!;

    // Guard against re-entrant initialization
    if (_initializing) {
      // If already initializing, wait for the initialization future
      if (_initializationFuture != null) {
        return await _initializationFuture!;
      }
      throw SpotException(
        'Re-entrant async initialization detected for $T. '
        'This usually indicates a circular dependency.'
      );
    }

    // Mark as initializing and create instance
    _initializing = true;
    try {
      // Start initialization
      _initializationFuture = asyncLocator!(_spot);
      instance = await _initializationFuture!;
      _initializationFuture = null;
      return instance!;
    } finally {
      _initializing = false;
    }
  }

  void dispose() {
    // Call dispose on instance if it implements Disposable
    if (instance is Disposable) {
      try {
        (instance as Disposable).dispose();
      } catch (e) {
        // Log error but continue with disposal
        Spot.log.e('Error disposing $T', e);
      }
    }
    instance = null;
    _initializationFuture = null;
  }

/*void addObserver() {
    _observers++;
    log('Observer count for $T is now $_observers');
  }

  void removeObserver() {
    _observers--;
    log('Observer count for $T is now $_observers');
    if (observers == 0) {
      log('No more observers for $T - disposing');
      instance = null;
    }
  }*/
}

/// Minimal service locator pattern
abstract class Spot {
  static final log = Logger('Spot');

  // Enable/disable logging
  static bool logging = false;

  /// Registry of all types => dependencies
  static final registry = <Type, SpotService>{};

  /// Track current resolution stack to detect circular dependencies
  static final _resolutionStack = <Type>[];

  static bool get isEmpty => registry.isEmpty;

  /// Check if a type is registered without throwing an exception
  /// Useful for conditional logic and debugging
  static bool isRegistered<T>() => registry.containsKey(T);

  /// Print all registered types with their details to the log
  /// Useful for debugging and inspecting the DI container state
  static void printRegistry() {
    log.i('=== Spot Registry (${registry.length} types) ===');
    for (var entry in registry.entries) {
      final service = entry.value;
      final typeStr = switch (service.type) {
        SpotType.singleton => 'singleton',
        SpotType.factory => 'factory',
        SpotType.asyncSingleton => 'async singleton',
      };
      final hasInstance = service.instance != null ? '(initialized)' : '';
      log.i('  ${entry.key} -> ${service.targetType} [$typeStr] $hasInstance');
    }
    log.i('=' * 50);
  }

  /// Registers a new factory dependency
  /// The concrete type [R] must extend or implement the interface type [T]
  /// This provides compile-time type safety to prevent registration mistakes
  static void registerFactory<T, R extends T>(SpotGetter<R> locator) {
    if (registry.containsKey(T) && logging) {
      log.w('Overriding factory: $T with $R');
    }

    registry[T] = SpotService<T>(SpotType.factory, locator as SpotGetter<T>, R);

    if (logging) log.v('Registered factory $T -> $R');
  }

  /// Registers a new singleton dependency
  /// The concrete type [R] must extend or implement the interface type [T]
  /// This provides compile-time type safety to prevent registration mistakes
  static void registerSingle<T, R extends T>(SpotGetter<R> locator) {
    if (registry.containsKey(T) && logging) {
      log.w('Overriding single: $T with $R');
    }

    registry[T] = SpotService<T>(SpotType.singleton, locator as SpotGetter<T>, R);

    if (logging) log.v('Registered singleton $T -> $R');
  }

  /// Registers a new async singleton dependency
  /// The concrete type [R] must extend or implement the interface type [T]
  /// Use [spotAsync] to resolve async singletons
  static void registerAsync<T, R extends T>(SpotAsyncGetter<R> locator) {
    if (registry.containsKey(T) && logging) {
      log.w('Overriding async singleton: $T with $R');
    }

    registry[T] = SpotService<T>(
      SpotType.asyncSingleton,
      null,
      R,
      asyncLocator: locator as SpotAsyncGetter<T>,
    );

    if (logging) log.v('Registered async singleton $T -> $R');
  }

  static SpotService<T> getRegistered<T>() {
    if (!registry.containsKey(T)) {
      final registeredTypes = registry.keys.map((t) => t.toString()).join(', ');
      throw SpotException(
        'Type $T is not registered in Spot container.\n'
        'Registered types: ${registeredTypes.isNotEmpty ? registeredTypes : '(none)'}'
      );
    }

    return registry[T]! as SpotService<T>;
  }

  /// Injects the dependency
  /// @example
  static T spot<T>() {
    if (!registry.containsKey(T)) {
      final registeredTypes = registry.keys.map((t) => t.toString()).join(', ');
      throw SpotException(
        'Type $T is not registered in Spot container.\n'
        'Registered types: ${registeredTypes.isNotEmpty ? registeredTypes : '(none)'}\n\n'
        'Did you forget to register it in SpotModule.registerDependencies()?\n'
        'Example: single<$T, ConcreteType>((get) => ConcreteType());'
      );
    }

    // Check for circular dependency
    if (_resolutionStack.contains(T)) {
      final cycle = [..._resolutionStack, T].map((t) => t.toString()).join(' -> ');
      throw SpotException(
        'Circular dependency detected: $cycle\n'
        'Cannot resolve $T because it depends on itself (directly or indirectly).'
      );
    }

    _resolutionStack.add(T);

    try {
      if (logging) log.v('Injecting $T -> ${registry[T]!.targetType}');

      final instance = registry[T]!.locate();
      if (instance == null) {
        throw SpotException('Class $T resolved to null');
      }

      return instance;
    } catch (e) {
      if (e is SpotException) {
        rethrow;  // Re-throw SpotException as-is
      }
      log.e('Failed to locate class $T', e);
      throw SpotException('Failed to resolve $T: ${e.toString()}');
    } finally {
      _resolutionStack.removeLast();
    }
  }

  /// Injects an async dependency
  /// Use this for dependencies registered with [registerAsync]
  static Future<T> spotAsync<T>() async {
    if (!registry.containsKey(T)) {
      final registeredTypes = registry.keys.map((t) => t.toString()).join(', ');
      throw SpotException(
        'Type $T is not registered in Spot container.\n'
        'Registered types: ${registeredTypes.isNotEmpty ? registeredTypes : '(none)'}\n\n'
        'Did you forget to register it in SpotModule or with Spot.registerAsync()?'
      );
    }

    // Check for circular dependency
    if (_resolutionStack.contains(T)) {
      final cycle = [..._resolutionStack, T].map((t) => t.toString()).join(' -> ');
      throw SpotException(
        'Circular dependency detected: $cycle\n'
        'Cannot resolve $T because it depends on itself (directly or indirectly).'
      );
    }

    _resolutionStack.add(T);

    try {
      if (logging) log.v('Async injecting $T -> ${registry[T]!.targetType}');

      final instance = await registry[T]!.locateAsync();
      if (instance == null) {
        throw SpotException('Class $T resolved to null');
      }

      return instance;
    } catch (e) {
      if (e is SpotException) {
        rethrow;  // Re-throw SpotException as-is
      }
      log.e('Failed to async locate class $T', e);
      throw SpotException('Failed to async resolve $T: ${e.toString()}');
    } finally {
      _resolutionStack.removeLast();
    }
  }

  /// Convenience method for registering dependencies
  /// Alternatively, you can just call
  /// Spot.registerFactory & Spot.registerSingle directly
  static void init(
    void Function(
      void Function<T, R extends T>(SpotGetter<R> locator) factory,
      void Function<T, R extends T>(SpotGetter<R> locator) single,
    )
        initializer,
  ) =>
      initializer(registerFactory, registerSingle);

  /// Disposes a specific singleton instance
  /// 
  /// If the instance implements [Disposable], its dispose() method will be called.
  /// The instance will be removed from the registry and recreated on next injection.
  static void dispose<T>() {
    if (registry.containsKey(T)) {
      if (logging) log.v('Disposing $T');
      registry[T]?.dispose();
      registry.remove(T);
      if (logging) log.v('Disposed $T');
    }
  }

  /// Disposes all registered services
  /// 
  /// Iterates through all registered services and calls their dispose() method.
  /// If any service implements [Disposable], its cleanup method will be invoked.
  /// Finally, clears the entire registry.
  static void disposeAll() {
    if (logging) log.i('Disposing all registered services (${registry.length} total)...');

    for (var entry in registry.entries) {
      try {
        if (logging) log.v('Disposing ${entry.key}');
        entry.value.dispose();
      } catch (e) {
        log.e('Error disposing ${entry.key}', e);
      }
    }

    registry.clear();
    if (logging) log.i('All services disposed');
  }
}

// Shorthand for convenience
T spot<T>() => Spot.spot<T>();

Future<T> spotAsync<T>() => Spot.spotAsync<T>();

/*mixin SpotDisposable<T extends StatefulWidget> on State<T> {
  final List<SpotService> services = [];

  T spot<T>() {
    final service = Spot.getRegistered<T>();
    services.add(service);
    service.addObserver();
    return service.locate();
  }

  @override
  @mustCallSuper
  void dispose() {
    for (var it in services) {
      it.removeObserver();
    }
    services.clear();

    super.dispose();
  }
}*/

//
//
// DEMO
//
//

/*
abstract class Heater {
  void on();
  void off();
  bool isHot();
}

abstract class Pump {
  void pump();
}

class ElectricHeater implements Heater {
  bool heating = false;

  @override
  void on() {
    print("~ ~ ~ heating ~ ~ ~");
    heating = true;
  }

  @override
  void off() {
    heating = false;
  }

  @override
  bool isHot() {
    return heating;
  }
}

class Thermosiphon implements Pump {
  final Heater heater;

  Thermosiphon(this.heater);

  @override
  void pump() {
    if (heater.isHot()) {
      print("=> => pumping => =>");
    }
  }
}

class CoffeeMaker {
  final Heater heater = spot<Heater>();
  final Pump pump = spot<Pump>();

  void brew() {
    heater.on();
    pump.pump();
    print(" [_]P coffee! [_]P ");
    heater.off();
  }
}

// Constructor injection demo
class ThingOne {
  void run() {
    print('Thing one was run');
  }
}

class ThingTwo {
  final ThingOne thingOne;
  const ThingTwo(this.thingOne);
  void run() {
    print('Thing two was run');
    thingOne.run();
  }
}

class ThingThree {
  final ThingTwo thingTwo;
  const ThingThree(this.thingTwo);
  void run() {
    print('Thing three was run');
    thingTwo.run();
  }
}

void main() {
  Spot.init((factory, single) {
    single<Heater>((get) => ElectricHeater());
    single<Pump>((get) => Thermosiphon(get<Heater>()));
  });

  // print('Spot registered: ${Spot.registry.keys.join(', ')}');

  final coffeeMaker = CoffeeMaker();
  print('\nMaking a coffee...\n');
  coffeeMaker.brew();
  
  print('\n\nConstructor injection demo\n');
  final thingThree = spot<ThingThree>();
  thingThree.run();
}
*/
