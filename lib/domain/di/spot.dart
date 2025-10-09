import 'package:cnvrt/domain/di/disposable.dart';
import 'package:cnvrt/domain/di/spot_exception.dart';
import 'package:cnvrt/domain/di/spot_key.dart';
import 'package:cnvrt/utils/logger.dart';

/// Factory function type for creating instances.
/// 
/// The `get` parameter allows resolving dependencies:
/// ```dart
/// (get) => ApiClient(dio: get<Dio>(), settings: get<ISettings>())
/// ```
typedef SpotGetter<T> = T Function(Function<R>() get);

/// Async factory function type for creating instances with async initialization.
/// 
/// The `get` parameter allows resolving dependencies:
/// ```dart
/// (get) async {
///   final db = AppDatabase();
///   await db.initialize();
///   return db;
/// }
/// ```
typedef SpotAsyncGetter<T> = Future<T> Function(Function<R>() get);

/// Type of service registration.
enum SpotType {
  /// Creates a new instance on each resolution
  factory,
  
  /// Creates one instance and reuses it for all resolutions
  singleton,
  
  /// Creates one instance asynchronously and reuses it
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

/// Lightweight service locator for dependency injection.
/// 
/// Spot provides a minimal yet powerful DI framework with support for:
/// - **Singletons**: Shared instance across the application
/// - **Factories**: New instance on each request
/// - **Async Singletons**: Asynchronous initialization support
/// - **Lifecycle Hooks**: Automatic cleanup via [Disposable] interface
/// - **Type Safety**: Compile-time type checking with `R extends T`
/// - **Circular Dependency Detection**: Runtime detection with helpful error messages
/// - **Testing Support**: Comprehensive utilities via [SpotTestHelper]
/// - **Performance**: Singleton caching for faster repeated access
/// 
/// ## Registration
/// 
/// Register dependencies during app initialization:
/// 
/// ```dart
/// Spot.init((factory, single) {
///   // Singleton - one instance shared across app
///   single<ISettings, Settings>((get) => Settings());
///   
///   // Factory - new instance on each request
///   factory<IRepository, Repository>((get) => Repository(get<Database>()));
///   
///   // Singleton with dependencies
///   single<IApiClient, ApiClient>((get) => ApiClient(
///     dio: get<Dio>(),
///     settings: get<ISettings>(),
///   ));
/// });
/// 
/// // Async singleton (requires async initialization)
/// Spot.registerAsync<Database, AppDatabase>((get) async {
///   final db = AppDatabase();
///   await db.initialize();
///   return db;
/// });
/// ```
/// 
/// ## Resolution
/// 
/// Inject dependencies using [spot] or [spotAsync]:
/// 
/// ```dart
/// // Synchronous resolution
/// final settings = spot<ISettings>();
/// final repo = Spot.spot<IRepository>();
/// 
/// // Asynchronous resolution
/// final db = await spotAsync<Database>();
/// final api = await Spot.spotAsync<ApiClient>();
/// ```
/// 
/// ## Lifecycle Management
/// 
/// Services implementing [Disposable] are automatically cleaned up:
/// 
/// ```dart
/// class ApiClient implements Disposable {
///   final Dio dio;
///   ApiClient(this.dio);
///   
///   @override
///   void dispose() {
///     dio.close();
///   }
/// }
/// 
/// // Dispose specific service
/// Spot.dispose<ApiClient>();  // Calls dispose() automatically
/// 
/// // Dispose all services
/// Spot.disposeAll();  // Cleanup on app shutdown
/// ```
/// 
/// ## Testing
/// 
/// Use [SpotTestHelper] for isolated test environments:
/// 
/// ```dart
/// test('with mocked dependencies', () async {
///   await SpotTestHelper.runIsolated(() async {
///     SpotTestHelper.registerMock<ISettings>(MockSettings());
///     // Test runs with mock, original state restored after
///   });
/// });
/// ```
/// 
/// ## Features
/// 
/// - **Thread-Safe**: Singleton initialization prevents race conditions
/// - **Performance**: Caching for fast repeated singleton access
/// - **Debugging**: [printRegistry] and [isRegistered] utilities
/// - **Error Messages**: Detailed errors with registered type listings
/// - **Circular Detection**: Clear error messages showing dependency cycles
/// 
/// See also:
/// - [spot] for dependency resolution
/// - [registerFactory] for factory registration
/// - [registerSingle] for singleton registration
/// - [registerAsync] for async singleton registration
/// - [Disposable] for lifecycle management
/// - [SpotTestHelper] for testing utilities
abstract class Spot {
  static final log = Logger('Spot');

  // Enable/disable logging
  static bool logging = false;

  /// Registry of all types => dependencies
  /// Uses [SpotKey] to support both unnamed and named instances
  static final registry = <SpotKey, SpotService>{};

  /// Cache for initialized singleton instances (performance optimization)
  /// Provides O(1) lookup for frequently accessed singletons
  /// Uses [SpotKey] to support both unnamed and named instances
  static final _singletonCache = <SpotKey, dynamic>{};

  /// Track current resolution stack to detect circular dependencies
  static final _resolutionStack = <SpotKey>[];

  static bool get isEmpty => registry.isEmpty;

  /// Check if a type is registered without throwing an exception
  /// Useful for conditional logic and debugging
  /// 
  /// Parameters:
  /// - [name]: Optional name qualifier for named instances
  static bool isRegistered<T>({String? name}) => registry.containsKey(SpotKey<T>(T, name));

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
      final keyStr = entry.key.toString();  // Uses SpotKey.toString()
      log.i('  $keyStr -> ${service.targetType} [$typeStr] $hasInstance');
    }
    log.i('=' * 50);
  }

  /// Registers a factory that creates a new instance on each resolution.
  /// 
  /// Factories are useful for stateless services or when you need a fresh
  /// instance each time (e.g., request handlers, temporary workers).
  /// 
  /// Type Parameters:
  /// - [T]: The interface or base type to register
  /// - [R]: The concrete implementation (must extend or implement [T])
  /// 
  /// Parameters:
  /// - [locator]: Factory function that creates instances. Use `get` parameter
  ///   to resolve dependencies.
  /// - [name]: Optional name qualifier for named instances
  /// 
  /// Example:
  /// ```dart
  /// // Simple factory
  /// Spot.registerFactory<IRepository, Repository>(
  ///   (get) => Repository(),
  /// );
  /// 
  /// // Named factory
  /// Spot.registerFactory<HttpClient, PublicHttpClient>(
  ///   (get) => PublicHttpClient(),
  ///   name: 'public',
  /// );
  /// 
  /// // Factory with dependencies
  /// Spot.registerFactory<IApiClient, ApiClient>(
  ///   (get) => ApiClient(
  ///     dio: get<Dio>(),
  ///     settings: get<ISettings>(),
  ///   ),
  /// );
  /// ```
  /// 
  /// See also:
  /// - [registerSingle] for singleton registration
  /// - [registerAsync] for async singleton registration
  static void registerFactory<T, R extends T>(SpotGetter<R> locator, {String? name}) {
    final key = SpotKey<T>(T, name);
    
    if (registry.containsKey(key) && logging) {
      log.w('Overriding factory: $key with $R');
    }

    registry[key] = SpotService<T>(SpotType.factory, locator as SpotGetter<T>, R);

    if (logging) log.v('Registered factory $key -> $R');
  }

  /// Registers a singleton that returns the same instance on each resolution.
  /// 
  /// Singletons are initialized lazily on first access and cached for
  /// subsequent requests. Perfect for shared state, services, and managers.
  /// 
  /// Type Parameters:
  /// - [T]: The interface or base type to register
  /// - [R]: The concrete implementation (must extend or implement [T])
  /// 
  /// Parameters:
  /// - [locator]: Factory function called once to create the singleton.
  ///   Use `get` parameter to resolve dependencies.
  /// - [name]: Optional name qualifier for named instances
  /// 
  /// Example:
  /// ```dart
  /// // Simple singleton
  /// Spot.registerSingle<ISettings, Settings>(
  ///   (get) => Settings(),
  /// );
  /// 
  /// // Named singleton
  /// Spot.registerSingle<Database, ProductionDatabase>(
  ///   (get) => ProductionDatabase(),
  ///   name: 'production',
  /// );
  /// 
  /// // Singleton with dependencies
  /// Spot.registerSingle<IAuthService, AuthService>(
  ///   (get) => AuthService(
  ///     apiClient: get<IApiClient>(),
  ///     storage: get<IStorage>(),
  ///   ),
  /// );
  /// ```
  /// 
  /// See also:
  /// - [registerFactory] for factory registration
  /// - [registerAsync] for async singleton registration
  /// - [dispose] to reset and recreate singletons
  static void registerSingle<T, R extends T>(SpotGetter<R> locator, {String? name}) {
    final key = SpotKey<T>(T, name);
    
    if (registry.containsKey(key) && logging) {
      log.w('Overriding single: $key with $R');
    }

    registry[key] = SpotService<T>(SpotType.singleton, locator as SpotGetter<T>, R);

    if (logging) log.v('Registered singleton $key -> $R');
  }

  /// Registers an async singleton with asynchronous initialization.
  /// 
  /// Use this for services that require async setup (database connections,
  /// API authentication, file loading, etc.). The instance is created once
  /// on first access and cached for subsequent requests.
  /// 
  /// Type Parameters:
  /// - [T]: The interface or base type to register
  /// - [R]: The concrete implementation (must extend or implement [T])
  /// 
  /// Parameters:
  /// - [locator]: Async factory function called once to create the singleton.
  ///   Use `get` parameter to resolve dependencies.
  /// - [name]: Optional name qualifier for named instances
  /// 
  /// Example:
  /// ```dart
  /// // Database with async initialization
  /// Spot.registerAsync<Database, AppDatabase>((get) async {
  ///   final db = AppDatabase();
  ///   await db.initialize();
  ///   await db.runMigrations();
  ///   return db;
  /// });
  /// 
  /// // Named async singleton
  /// Spot.registerAsync<Cache, RemoteCache>(
  ///   (get) async => await RemoteCache.connect(),
  ///   name: 'remote',
  /// );
  /// 
  /// // API client with token refresh
  /// Spot.registerAsync<IApiClient, ApiClient>((get) async {
  ///   final client = ApiClient();
  ///   await client.refreshTokens();
  ///   return client;
  /// });
  /// 
  /// // Resolve with spotAsync
  /// final db = await spotAsync<Database>();
  /// ```
  /// 
  /// See also:
  /// - [spotAsync] for async resolution
  /// - [registerSingle] for synchronous singletons
  static void registerAsync<T, R extends T>(SpotAsyncGetter<R> locator, {String? name}) {
    final key = SpotKey<T>(T, name);
    
    if (registry.containsKey(key) && logging) {
      log.w('Overriding async singleton: $key with $R');
    }

    registry[key] = SpotService<T>(
      SpotType.asyncSingleton,
      null,
      R,
      asyncLocator: locator as SpotAsyncGetter<T>,
    );

    if (logging) log.v('Registered async singleton $key -> $R');
  }

  static SpotService<T> getRegistered<T>({String? name}) {
    final key = SpotKey<T>(T, name);
    
    if (!registry.containsKey(key)) {
      final registeredTypes = registry.keys.map((k) => k.toString()).join(', ');
      throw SpotException(
        'Type $key is not registered in Spot container.\n'
        'Registered types: ${registeredTypes.isNotEmpty ? registeredTypes : '(none)'}'
      );
    }

    return registry[key]! as SpotService<T>;
  }

  /// Resolves and returns an instance of type [T].
  /// 
  /// For singletons, returns the cached instance (created lazily on first access).
  /// For factories, creates and returns a new instance each time.
  /// 
  /// Performance: Singletons benefit from caching for fast O(1) repeated access.
  /// 
  /// Type Parameters:
  /// - [T]: The type to resolve (must be registered)
  /// 
  /// Parameters:
  /// - [name]: Optional name qualifier for named instances
  /// 
  /// Returns: Instance of type [T]
  /// 
  /// Throws:
  /// - [SpotException] if [T] is not registered
  /// - [SpotException] if circular dependency detected
  /// - [SpotException] if trying to resolve async singleton synchronously
  /// 
  /// Example:
  /// ```dart
  /// // Basic usage
  /// final settings = Spot.spot<ISettings>();
  /// final repo = spot<IRepository>();  // Global function
  /// 
  /// // Named instance
  /// final publicClient = Spot.spot<HttpClient>(name: 'public');
  /// final authClient = Spot.spot<HttpClient>(name: 'authenticated');
  /// 
  /// // In widget
  /// class MyWidget extends StatelessWidget {
  ///   final ISettings settings = spot<ISettings>();
  ///   
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Text('Theme: ${settings.theme}');
  ///   }
  /// }
  /// ```
  /// 
  /// See also:
  /// - [spotAsync] for async singletons
  /// - [isRegistered] to check registration status
  static T spot<T>({String? name}) {
    final key = SpotKey<T>(T, name);
    
    // Fast path: check singleton cache first for performance
    if (_singletonCache.containsKey(key)) {
      if (logging) log.v('Cache hit for $key');
      return _singletonCache[key] as T;
    }

    if (!registry.containsKey(key)) {
      final registeredTypes = registry.keys.map((k) => k.toString()).join(', ');
      throw SpotException(
        'Type $key is not registered in Spot container.\n'
        'Registered types: ${registeredTypes.isNotEmpty ? registeredTypes : '(none)'}\n\n'
        'Did you forget to register it in SpotModule.registerDependencies()?\n'
        'Example: single<$T, ConcreteType>((get) => ConcreteType());'
      );
    }

    // Check for circular dependency
    if (_resolutionStack.contains(key)) {
      final cycle = [..._resolutionStack, key].map((k) => k.toString()).join(' -> ');
      throw SpotException(
        'Circular dependency detected: $cycle\n'
        'Cannot resolve $key because it depends on itself (directly or indirectly).'
      );
    }

    _resolutionStack.add(key);

    try {
      if (logging) log.v('Injecting $key -> ${registry[key]!.targetType}');

      final service = registry[key]!;
      final instance = service.locate();
      if (instance == null) {
        throw SpotException('Class $key resolved to null');
      }

      // Cache initialized singletons for faster subsequent access
      if (service.type == SpotType.singleton && service.instance != null) {
        _singletonCache[key] = instance;
        if (logging) log.v('Cached singleton $key');
      }

      return instance;
    } catch (e) {
      if (e is SpotException) {
        rethrow;  // Re-throw SpotException as-is
      }
      log.e('Failed to locate class $key', e);
      throw SpotException('Failed to resolve $key: ${e.toString()}');
    } finally {
      _resolutionStack.removeLast();
    }
  }

  /// Resolves and returns an async singleton of type [T].
  /// 
  /// Use this for services registered with [registerAsync] that require
  /// asynchronous initialization. The instance is created once and cached.
  /// 
  /// Can also be used to resolve regular singletons asynchronously.
  /// 
  /// Type Parameters:
  /// - [T]: The type to resolve (must be registered)
  /// 
  /// Parameters:
  /// - [name]: Optional name qualifier for named instances
  /// 
  /// Returns: `Future<T>` that resolves to the instance
  /// 
  /// Throws:
  /// - [SpotException] if [T] is not registered
  /// - [SpotException] if circular dependency detected
  /// 
  /// Example:
  /// ```dart
  /// // Resolve async singleton
  /// final db = await Spot.spotAsync<Database>();
  /// final api = await spotAsync<IApiClient>();
  /// 
  /// // Named instance
  /// final remoteCache = await spotAsync<Cache>(name: 'remote');
  /// 
  /// // In async context
  /// Future<void> initApp() async {
  ///   final db = await spotAsync<Database>();
  ///   await db.loadInitialData();
  /// }
  /// 
  /// // Multiple async dependencies
  /// final results = await Future.wait([
  ///   spotAsync<Database>(),
  ///   spotAsync<IApiClient>(),
  ///   spotAsync<IAuthService>(),
  /// ]);
  /// ```
  /// 
  /// See also:
  /// - [registerAsync] for async singleton registration
  /// - [spot] for synchronous resolution
  static Future<T> spotAsync<T>({String? name}) async {
    final key = SpotKey<T>(T, name);
    
    // Fast path: check singleton cache first for performance
    if (_singletonCache.containsKey(key)) {
      if (logging) log.v('Cache hit for async $key');
      return _singletonCache[key] as T;
    }

    if (!registry.containsKey(key)) {
      final registeredTypes = registry.keys.map((k) => k.toString()).join(', ');
      throw SpotException(
        'Type $key is not registered in Spot container.\n'
        'Registered types: ${registeredTypes.isNotEmpty ? registeredTypes : '(none)'}\n\n'
        'Did you forget to register it in SpotModule or with Spot.registerAsync()?'
      );
    }

    // Check for circular dependency
    if (_resolutionStack.contains(key)) {
      final cycle = [..._resolutionStack, key].map((k) => k.toString()).join(' -> ');
      throw SpotException(
        'Circular dependency detected: $cycle\n'
        'Cannot resolve $key because it depends on itself (directly or indirectly).'
      );
    }

    _resolutionStack.add(key);

    try {
      if (logging) log.v('Async injecting $key -> ${registry[key]!.targetType}');

      final service = registry[key]!;
      final instance = await service.locateAsync();
      if (instance == null) {
        throw SpotException('Class $key resolved to null');
      }

      // Cache initialized async singletons for faster subsequent access
      if (service.type == SpotType.asyncSingleton && service.instance != null) {
        _singletonCache[key] = instance;
        if (logging) log.v('Cached async singleton $key');
      }

      return instance;
    } catch (e) {
      if (e is SpotException) {
        rethrow;  // Re-throw SpotException as-is
      }
      log.e('Failed to async locate class $key', e);
      throw SpotException('Failed to async resolve $key: ${e.toString()}');
    } finally {
      _resolutionStack.removeLast();
    }
  }

  /// Convenience method for registering dependencies
  /// Alternatively, you can just call
  /// Spot.registerFactory & Spot.registerSingle directly
  /// 
  /// Note: Named instances are not supported via the init helper.
  /// Use registerFactory/registerSingle/registerAsync directly with the name parameter.
  static void init(
    void Function(
      void Function<T, R extends T>(SpotGetter<R> locator, {String? name}) factory,
      void Function<T, R extends T>(SpotGetter<R> locator, {String? name}) single,
    )
        initializer,
  ) =>
      initializer(registerFactory, registerSingle);

  /// Disposes a specific singleton instance
  /// 
  /// If the instance implements [Disposable], its dispose() method will be called.
  /// The instance will be removed from the registry and cache, and recreated on next injection.
  /// 
  /// Parameters:
  /// - [name]: Optional name qualifier for named instances
  static void dispose<T>({String? name}) {
    final key = SpotKey<T>(T, name);
    
    if (registry.containsKey(key)) {
      if (logging) log.v('Disposing $key');
      registry[key]?.dispose();
      registry.remove(key);
      _singletonCache.remove(key);  // Clear from cache
      if (logging) log.v('Disposed $key');
    }
  }

  /// Disposes all registered services
  /// 
  /// Iterates through all registered services and calls their dispose() method.
  /// If any service implements [Disposable], its cleanup method will be invoked.
  /// Finally, clears the entire registry and singleton cache.
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
    _singletonCache.clear();  // Clear singleton cache
    if (logging) log.i('All services disposed');
  }
}

/// Global convenience function for resolving dependencies.
/// 
/// Shorthand for [Spot.spot].
/// 
/// Parameters:
/// - [name]: Optional name qualifier for named instances
/// 
/// Example:
/// ```dart
/// final settings = spot<ISettings>();
/// final repo = spot<IRepository>();
/// 
/// // Named instance
/// final publicClient = spot<HttpClient>(name: 'public');
/// ```
T spot<T>({String? name}) => Spot.spot<T>(name: name);

/// Global convenience function for resolving async dependencies.
/// 
/// Shorthand for [Spot.spotAsync].
/// 
/// Parameters:
/// - [name]: Optional name qualifier for named instances
/// 
/// Example:
/// ```dart
/// final db = await spotAsync<Database>();
/// final api = await spotAsync<IApiClient>();
/// 
/// // Named instance
/// final remoteCache = await spotAsync<Cache>(name: 'remote');
/// ```
Future<T> spotAsync<T>({String? name}) => Spot.spotAsync<T>(name: name);

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
