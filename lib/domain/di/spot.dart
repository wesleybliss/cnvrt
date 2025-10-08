import 'package:cnvrt/utils/logger.dart';

typedef SpotGetter<T> = T Function(Function<R>() get);

typedef SpotInitCallback = void Function<T, R>(SpotGetter<T> get);

enum SpotType {
  factory,
  singleton,
}

/// Represents a service that can be located
/// type = the type of service (factory or singleton)
/// locator = the function to instantiate the type
/// The locator function is called lazily the first time the dependency is requested
class SpotService<T> {
  final SpotType type;
  final SpotGetter<T> locator;
  final Type targetType;
  // int _observers = 0;

  // Instance of the dependency (only used for singletons)
  T? instance;
  bool _initializing = false;  // Flag for thread-safe initialization

  SpotService(this.type, this.locator, this.targetType);

  // int get observers => _observers;

  R _spot<R>() => Spot.spot<R>();

  T locate() {
    if (type == SpotType.factory) {
      return locator(_spot);
    }

    // Thread-safe singleton initialization
    // Note: Dart is single-threaded per isolate, but this prevents re-entrant
    // initialization issues and prepares for potential multi-isolate scenarios
    
    // Fast path: check if already initialized
    if (instance != null) return instance!;
    
    // Guard against re-entrant initialization (circular dependencies)
    if (_initializing) {
      throw Exception(
        'Re-entrant initialization detected for $T. '
        'This usually indicates a circular dependency.'
      );
    }
    
    // Mark as initializing and create instance
    _initializing = true;
    try {
      instance = locator(_spot);
      return instance!;
    } finally {
      _initializing = false;
    }
  }

  void dispose() {
    instance = null;
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

  static bool get isEmpty => registry.isEmpty;

  /// Registers a new factory dependency
  //static void registerFactory<T, R>(T Function(Function<R>() get) locator) {
  static void registerFactory<T, R>(SpotGetter<T> locator) {
    if (registry.containsKey(T) && logging) {
      log.w('Overriding factory: (${T.runtimeType}) ${registry[T].runtimeType} with ${R.runtimeType}');
    }

    registry[T] = SpotService(SpotType.factory, locator, R);

    if (logging) log.v('Registered factory $T');
  }

  /// Registers a new singleton dependency
  static void registerSingle<T, R>(SpotGetter<T> locator) {
    if (registry.containsKey(T) && logging) {
      log.w('Overriding single: (${T.runtimeType}) ${registry[T].runtimeType} with ${R.runtimeType}');
    }

    registry[T] = SpotService(SpotType.singleton, locator, R);

    if (logging) log.v('Registered singleton $T');
  }

  static SpotService<T> getRegistered<T>() {
    if (!registry.containsKey(T)) {
      throw Exception('Spot: Class $T is not registered');
    }

    return registry[T]! as SpotService<T>;
  }

  /// Injects the dependency
  /// @example
  static T spot<T>() {
    if (!registry.containsKey(T)) {
      throw Exception('Spot: Class $T is not registered');
    }

    if (logging) log.v('Injecting $T -> ${registry[T]!.targetType}');

    late final T instance;

    try {
      instance = registry[T]!.locate();
      if (instance == null) {
        throw Exception('Spot: Class $T is not registered');
      }
    } catch (e) {
      log.e('Failed to locate class $T', e);
      throw Exception('Spot: Class $T is not registered');
    }

    return instance;
  }

  /// Convenience method for registering dependencies
  /// Alternatively, you can just call
  /// Spot.registerFactory & Spot.registerSingle directly
  static void init(Function(SpotInitCallback factory, SpotInitCallback single) initializer) =>
      initializer(registerFactory, registerSingle);

  /// For intentionally disposing of singleton instances
  /// Instances will be recreated the next time the dependency is injected
  static void dispose<T>() {
    if (registry.containsKey(T)) {
      registry[T]?.dispose();
      registry.remove(T);
    }
  }

  static void disposeAll() {
    registry.clear();
  }
}

// Shorthand for convenience
T spot<T>() => Spot.spot<T>();

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
