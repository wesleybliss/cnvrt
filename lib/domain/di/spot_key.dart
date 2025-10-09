/// Registry key that supports both unnamed and named service registration.
/// 
/// [SpotKey] allows registering multiple implementations of the same type
/// by differentiating them with an optional name qualifier.
/// 
/// When [name] is null, the key represents the default/unnamed instance.
/// When [name] is provided, it creates a named instance that can coexist
/// with other implementations of the same type.
/// 
/// Example:
/// ```dart
/// // Register multiple HTTP clients
/// final publicKey = SpotKey<HttpClient>(HttpClient, 'public');
/// final authKey = SpotKey<HttpClient>(HttpClient, 'authenticated');
/// final defaultKey = SpotKey<HttpClient>(HttpClient);  // name = null
/// ```
class SpotKey<T> {
  /// The type being registered
  final Type type;
  
  /// Optional name qualifier for named instances
  final String? name;
  
  /// Creates a registry key for service lookup.
  /// 
  /// - [type]: The type being registered (typically T)
  /// - [name]: Optional name for named instances (null for default instance)
  const SpotKey(this.type, [this.name]);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpotKey &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          name == other.name;
  
  @override
  int get hashCode => type.hashCode ^ (name?.hashCode ?? 0);
  
  @override
  String toString() => name != null ? '$type($name)' : '$type';
}
