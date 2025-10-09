import 'package:cnvrt/domain/di/disposable.dart';
import 'package:cnvrt/domain/di/spot.dart';
import 'package:cnvrt/domain/di/spot_exception.dart';
import 'package:cnvrt/domain/di/spot_key.dart';
import 'package:cnvrt/utils/logger.dart';

/// A scoped DI container that supports parent-child hierarchies.
/// 
/// [SpotContainer] allows creating isolated dependency scopes with fallback
/// to parent containers. This is useful for:
/// - Test isolation (override dependencies without affecting global state)
/// - Feature-specific dependency trees
/// - Request-scoped dependencies (e.g., in web applications)
/// - Modular architecture with separate scopes per module
/// 
/// ## Hierarchy
/// 
/// Containers form a parent-child tree:
/// - Global container (root, created by Spot)
/// - Child scopes (created via `createChild()`)
/// - Grandchild scopes (children of children)
/// 
/// ## Resolution
/// 
/// When resolving a dependency, the container:
/// 1. Checks its own registry first
/// 2. Falls back to parent container if not found
/// 3. Continues up the chain until found or throws exception
/// 
/// ## Disposal
/// 
/// Disposing a container:
/// - Only disposes services registered in that container
/// - Does not affect parent or sibling containers
/// - Calls Disposable.dispose() on services that implement it
/// 
/// ## Example
/// 
/// ```dart
/// // Global dependencies
/// Spot.registerSingle<ISettings, Settings>((get) => Settings());
/// 
/// // Create test scope
/// final testScope = Spot.createScope();
/// testScope.registerSingle<ISettings, MockSettings>((get) => MockSettings());
/// 
/// // Use test scope
/// final settings = testScope.spot<ISettings>();  // Gets MockSettings
/// 
/// // Global scope unchanged
/// final globalSettings = spot<ISettings>();  // Gets Settings
/// 
/// // Cleanup test scope (doesn't affect global)
/// testScope.dispose();
/// ```
/// 
/// See also:
/// - [Spot.createScope] for creating child scopes
/// - [SpotTestHelper] for test-specific scope utilities
class SpotContainer {
  /// Parent container for fallback resolution
  final SpotContainer? parent;
  
  /// Local registry for this scope
  final registry = <SpotKey, SpotService>{};
  
  /// Cache for initialized singleton instances in this scope
  final _singletonCache = <SpotKey, dynamic>{};
  
  /// Track current resolution stack to detect circular dependencies
  final _resolutionStack = <SpotKey>[];
  
  /// Logger for this container
  final log = Logger('SpotContainer');
  
  /// Enable/disable logging for this container
  bool logging = false;
  
  /// Creates a new container with optional parent.
  /// 
  /// If [parent] is provided, this container will fall back to the parent
  /// when resolving dependencies that aren't registered locally.
  SpotContainer({this.parent});
  
  /// Check if a type is registered in this container or any parent.
  /// 
  /// Parameters:
  /// - [name]: Optional name qualifier for named instances
  /// 
  /// Returns: true if the type is registered in this scope or any parent
  bool isRegistered<T>({String? name}) {
    final key = SpotKey<T>(T, name);
    
    // Check local registry
    if (registry.containsKey(key)) {
      return true;
    }
    
    // Check parent
    if (parent != null) {
      return parent!.isRegistered<T>(name: name);
    }
    
    return false;
  }
  
  /// Register a factory that creates a new instance on each resolution.
  /// 
  /// This registration only applies to this container and its children.
  /// 
  /// Type Parameters:
  /// - [T]: The interface or base type to register
  /// - [R]: The concrete implementation (must extend or implement [T])
  /// 
  /// Parameters:
  /// - [locator]: Factory function that creates instances
  /// - [name]: Optional name qualifier for named instances
  void registerFactory<T, R extends T>(SpotGetter<R> locator, {String? name}) {
    final key = SpotKey<T>(T, name);
    
    if (registry.containsKey(key) && logging) {
      log.w('Overriding factory in scope: $key with $R');
    }
    
    registry[key] = SpotService<T>(SpotType.factory, locator as SpotGetter<T>, R);
    
    if (logging) log.v('Registered factory in scope: $key -> $R');
  }
  
  /// Register a singleton that returns the same instance on each resolution.
  /// 
  /// The singleton is scoped to this container. If a parent has a singleton
  /// with the same key, this registration shadows it for this scope and children.
  /// 
  /// Type Parameters:
  /// - [T]: The interface or base type to register
  /// - [R]: The concrete implementation (must extend or implement [T])
  /// 
  /// Parameters:
  /// - [locator]: Factory function called once to create the singleton
  /// - [name]: Optional name qualifier for named instances
  void registerSingle<T, R extends T>(SpotGetter<R> locator, {String? name}) {
    final key = SpotKey<T>(T, name);
    
    if (registry.containsKey(key) && logging) {
      log.w('Overriding singleton in scope: $key with $R');
    }
    
    registry[key] = SpotService<T>(SpotType.singleton, locator as SpotGetter<T>, R);
    
    if (logging) log.v('Registered singleton in scope: $key -> $R');
  }
  
  /// Register an async singleton with asynchronous initialization.
  /// 
  /// The async singleton is scoped to this container.
  /// 
  /// Type Parameters:
  /// - [T]: The interface or base type to register
  /// - [R]: The concrete implementation (must extend or implement [T])
  /// 
  /// Parameters:
  /// - [locator]: Async factory function called once to create the singleton
  /// - [name]: Optional name qualifier for named instances
  void registerAsync<T, R extends T>(SpotAsyncGetter<R> locator, {String? name}) {
    final key = SpotKey<T>(T, name);
    
    if (registry.containsKey(key) && logging) {
      log.w('Overriding async singleton in scope: $key with $R');
    }
    
    registry[key] = SpotService<T>(
      SpotType.asyncSingleton,
      null,
      R,
      asyncLocator: locator as SpotAsyncGetter<T>,
    );
    
    if (logging) log.v('Registered async singleton in scope: $key -> $R');
  }
  
  /// Resolve and return an instance of type [T].
  /// 
  /// Resolution order:
  /// 1. Check local registry
  /// 2. If not found, check parent (if exists)
  /// 3. Continue up the chain until found or throw exception
  /// 
  /// Type Parameters:
  /// - [T]: The type to resolve (must be registered in this scope or parent)
  /// 
  /// Parameters:
  /// - [name]: Optional name qualifier for named instances
  /// 
  /// Returns: Instance of type [T]
  /// 
  /// Throws:
  /// - [SpotException] if [T] is not registered in this scope or any parent
  /// - [SpotException] if circular dependency detected
  /// - [SpotException] if trying to resolve async singleton synchronously
  T spot<T>({String? name}) {
    final key = SpotKey<T>(T, name);
    
    // Fast path: check singleton cache first
    if (_singletonCache.containsKey(key)) {
      if (logging) log.v('Cache hit in scope for $key');
      return _singletonCache[key] as T;
    }
    
    // Check local registry
    if (registry.containsKey(key)) {
      return _resolveLocal<T>(key);
    }
    
    // Fall back to parent
    if (parent != null) {
      if (logging) log.v('Falling back to parent for $key');
      return parent!.spot<T>(name: name);
    }
    
    // Not found in this scope or any parent
    final registeredTypes = _getAllRegisteredKeys().map((k) => k.toString()).join(', ');
    throw SpotException(
      'Type $key is not registered in this scope or any parent scope.\n'
      'Registered in this scope: ${registry.keys.map((k) => k.toString()).join(', ')}\n'
      'All registered types: ${registeredTypes.isNotEmpty ? registeredTypes : '(none)'}'
    );
  }
  
  /// Resolve and return an async singleton of type [T].
  /// 
  /// Resolution order is the same as [spot].
  /// 
  /// Type Parameters:
  /// - [T]: The type to resolve (must be registered in this scope or parent)
  /// 
  /// Parameters:
  /// - [name]: Optional name qualifier for named instances
  /// 
  /// Returns: `Future<T>` that resolves to the instance
  /// 
  /// Throws:
  /// - [SpotException] if [T] is not registered in this scope or any parent
  /// - [SpotException] if circular dependency detected
  Future<T> spotAsync<T>({String? name}) async {
    final key = SpotKey<T>(T, name);
    
    // Fast path: check singleton cache first
    if (_singletonCache.containsKey(key)) {
      if (logging) log.v('Cache hit in scope for async $key');
      return _singletonCache[key] as T;
    }
    
    // Check local registry
    if (registry.containsKey(key)) {
      return await _resolveLocalAsync<T>(key);
    }
    
    // Fall back to parent
    if (parent != null) {
      if (logging) log.v('Falling back to parent for async $key');
      return await parent!.spotAsync<T>(name: name);
    }
    
    // Not found in this scope or any parent
    final registeredTypes = _getAllRegisteredKeys().map((k) => k.toString()).join(', ');
    throw SpotException(
      'Type $key is not registered in this scope or any parent scope.\n'
      'Registered in this scope: ${registry.keys.map((k) => k.toString()).join(', ')}\n'
      'All registered types: ${registeredTypes.isNotEmpty ? registeredTypes : '(none)'}'
    );
  }
  
  /// Helper method to resolve from local registry
  T _resolveLocal<T>(SpotKey<T> key) {
    // Check for circular dependency
    if (_resolutionStack.contains(key)) {
      final cycle = [..._resolutionStack, key].map((k) => k.toString()).join(' -> ');
      throw SpotException(
        'Circular dependency detected in scope: $cycle\n'
        'Cannot resolve $key because it depends on itself (directly or indirectly).'
      );
    }
    
    _resolutionStack.add(key);
    
    try {
      if (logging) log.v('Resolving in scope: $key -> ${registry[key]!.targetType}');
      
      final service = registry[key]!;
      final instance = service.locate();
      if (instance == null) {
        throw SpotException('Class $key resolved to null in scope');
      }
      
      // Cache initialized singletons
      if (service.type == SpotType.singleton && service.instance != null) {
        _singletonCache[key] = instance;
        if (logging) log.v('Cached singleton in scope: $key');
      }
      
      return instance;
    } catch (e) {
      if (e is SpotException) {
        rethrow;
      }
      log.e('Failed to locate class in scope: $key', e);
      throw SpotException('Failed to resolve $key in scope: ${e.toString()}');
    } finally {
      _resolutionStack.removeLast();
    }
  }
  
  /// Helper method to resolve async from local registry
  Future<T> _resolveLocalAsync<T>(SpotKey<T> key) async {
    // Check for circular dependency
    if (_resolutionStack.contains(key)) {
      final cycle = [..._resolutionStack, key].map((k) => k.toString()).join(' -> ');
      throw SpotException(
        'Circular dependency detected in scope: $cycle\n'
        'Cannot resolve $key because it depends on itself (directly or indirectly).'
      );
    }
    
    _resolutionStack.add(key);
    
    try {
      if (logging) log.v('Async resolving in scope: $key -> ${registry[key]!.targetType}');
      
      final service = registry[key]!;
      final instance = await service.locateAsync();
      if (instance == null) {
        throw SpotException('Class $key resolved to null in scope');
      }
      
      // Cache initialized async singletons
      if (service.type == SpotType.asyncSingleton && service.instance != null) {
        _singletonCache[key] = instance;
        if (logging) log.v('Cached async singleton in scope: $key');
      }
      
      return instance;
    } catch (e) {
      if (e is SpotException) {
        rethrow;
      }
      log.e('Failed to async locate class in scope: $key', e);
      throw SpotException('Failed to async resolve $key in scope: ${e.toString()}');
    } finally {
      _resolutionStack.removeLast();
    }
  }
  
  /// Get all registered keys from this scope and all parents
  List<SpotKey> _getAllRegisteredKeys() {
    final keys = <SpotKey>[...registry.keys];
    if (parent != null) {
      keys.addAll(parent!._getAllRegisteredKeys());
    }
    return keys;
  }
  
  /// Create a child scope that inherits from this container.
  /// 
  /// The child scope will fall back to this container for dependency resolution,
  /// but can override registrations locally.
  /// 
  /// Returns: A new [SpotContainer] with this container as parent
  SpotContainer createChild() {
    return SpotContainer(parent: this);
  }
  
  /// Dispose all services registered in this container only.
  /// 
  /// This does not affect parent containers or child containers.
  /// Services implementing [Disposable] will have their dispose() method called.
  void dispose() {
    if (logging) log.i('Disposing scope (${registry.length} services)...');
    
    for (var entry in registry.entries) {
      try {
        if (logging) log.v('Disposing in scope: ${entry.key}');
        entry.value.dispose();
      } catch (e) {
        log.e('Error disposing ${entry.key} in scope', e);
      }
    }
    
    registry.clear();
    _singletonCache.clear();
    if (logging) log.i('Scope disposed');
  }
}
