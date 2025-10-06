## 4. Testing Support

### 4.1 Enhanced Test Utilities

**Current State:** Basic test helper exists but could be more comprehensive.

**Recommended Enhancements:**

```dart
class SpotTestHelper {
  static final _originalRegistry = <Type, SpotService>{};
  
  /// Save current registry state
  static void saveState() {
    _originalRegistry.clear();
    _originalRegistry.addAll(Spot.registry);
  }
  
  /// Restore saved registry state
  static void restoreState() {
    Spot.registry.clear();
    Spot.registry.addAll(_originalRegistry);
    _originalRegistry.clear();
  }
  
  /// Reset DI container
  static void resetDI() {
    Spot.disposeAll();
  }
  
  /// Register a mock for testing
  static void registerMock<T>(T mock) {
    Spot.registerSingle<T, T>((get) => mock);
  }
  
  /// Run test with isolated DI state
  static Future<void> runIsolated(Future<void> Function() testFn) async {
    saveState();
    try {
      await testFn();
    } finally {
      restoreState();
    }
  }
  
  /// Verify a dependency is registered
  static bool isRegistered<T>() {
    return Spot.isRegistered<T>();
  }
  
  /// Get registration info for debugging
  static String getRegistrationInfo<T>() {
    if (!Spot.registry.containsKey(T)) {
      return '$T: NOT REGISTERED';
    }
    
    final service = Spot.registry[T]!;
    final typeStr = service.type == SpotType.singleton ? 'singleton' : 'factory';
    final hasInstance = service.instance != null;
    return '$T -> ${service.targetType} [$typeStr] ${hasInstance ? "(initialized)" : "(not initialized)"}';
  }
}

// Usage in tests:
test('currency conversion works correctly', () async {
  await SpotTestHelper.runIsolated(() async {
    // Register mocks for this test only
    SpotTestHelper.registerMock<ISettings>(MockSettings(
      roundingDecimals: 2,
      accountForInflation: false,
    ));
    
    // Test code here
    final result = convertCurrencies('USD', 100, currencies);
    expect(result['EUR'], closeTo(85.0, 0.1));
  });
  // Original DI state is restored automatically
});
```

**Benefits:**
- Easy mock registration
- Isolated test state
- Automatic cleanup
- Better debugging tools
