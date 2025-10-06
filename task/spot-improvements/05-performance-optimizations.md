## 5. Performance Optimizations

### 5.1 Registry Lookup Optimization

**Issue:** Every call to `spot<T>()` performs multiple map lookups and type checks.

**Recommended Optimization:**

```dart
abstract class Spot {
  static final registry = <Type, SpotService>{};
  
  // Cache frequently accessed singletons
  static final _singletonCache = <Type, dynamic>{};
  
  static T spot<T>() {
    // Fast path: check singleton cache first
    if (_singletonCache.containsKey(T)) {
      return _singletonCache[T] as T;
    }
    
    final service = registry[T];
    if (service == null) {
      throw SpotException('$T is not registered');
    }

    if (logging) log.v('Injecting $T -> ${service.targetType}');

    try {
      final instance = service.locate();
      if (instance == null) {
        throw SpotException('$T resolved to null');
      }
      
      // Cache initialized singletons
      if (service.type == SpotType.singleton) {
        _singletonCache[T] = instance;
      }
      
      return instance;
    } catch (e) {
      log.e('Failed to locate $T', e);
      rethrow;
    }
  }
  
  static void dispose<T>() {
    if (registry.containsKey(T)) {
      registry[T]?.dispose();
      registry.remove(T);
      _singletonCache.remove(T);  // Clear cache
    }
  }

  static void disposeAll() {
    registry.clear();
    _singletonCache.clear();
  }
}
```

**Benefits:**
- Faster repeated access to singletons
- Reduced map lookup overhead
- Still maintains lazy initialization
