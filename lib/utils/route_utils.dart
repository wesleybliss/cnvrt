/// Gets a route parameter, safely casting it to the correct type
///
/// @example
/// String? foo = paramOf(params, 'foo');
/// String bar = paramOf(params, 'bar', 'defaultBar');
/// int biz = paramOf(params, 'biz', 10);
T? paramOf<T>(Map<String, dynamic> params, String key, [T? defaultValue]) {
  final List<T?>? values = params[key] as List<T?>?;
  if (values == null || values.isEmpty) {
    return defaultValue;
  }
  return values[0];
}
