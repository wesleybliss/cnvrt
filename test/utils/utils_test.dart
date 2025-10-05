import 'package:cnvrt/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('jsonPretty', () {
    test('formats simple object', () {
      final obj = {'name': 'John', 'age': 30};
      final result = jsonPretty(obj);
      expect(result, contains('name'));
      expect(result, contains('John'));
      expect(result, contains('age'));
      expect(result, contains('30'));
    });

    test('formats nested object', () {
      final obj = {
        'user': {
          'name': 'Alice',
          'details': {'age': 25, 'city': 'NYC'}
        }
      };
      final result = jsonPretty(obj);
      expect(result, contains('user'));
      expect(result, contains('name'));
      expect(result, contains('details'));
      expect(result, contains('city'));
    });

    test('formats array', () {
      final obj = {
        'items': [1, 2, 3]
      };
      final result = jsonPretty(obj);
      expect(result, contains('items'));
      expect(result, contains('['));
      expect(result, contains(']'));
    });

    test('uses custom indent', () {
      final obj = {'key': 'value'};
      final result = jsonPretty(obj, '  ');
      expect(result, contains('  '));
    });

    test('handles null', () {
      final result = jsonPretty(null);
      expect(result, equals('null'));
    });

    test('handles empty object', () {
      final result = jsonPretty({});
      expect(result, equals('{}'));
    });
  });

  group('Utils.truncate', () {
    test('returns null for null input', () {
      expect(Utils.truncate(null), isNull);
    });

    test('returns original string if shorter than threshold', () {
      expect(Utils.truncate('hello', 10), equals('hello'));
      expect(Utils.truncate('short', 5), equals('short'));
    });

    test('truncates long strings', () {
      final long = 'This is a very long string that should be truncated';
      final result = Utils.truncate(long, 10);
      expect(result, isNotNull);
      expect(result!.length, equals(20)); // 10 from start + 10 from end
      expect(result.startsWith('This is a '), isTrue);
      expect(result.endsWith(' truncated'), isTrue);
    });

    test('keeps first and last N characters', () {
      final text = '1234567890ABCDEFGHIJ';
      final result = Utils.truncate(text, 3);
      expect(result, equals('123HIJ'));
    });

    test('handles strings at exact threshold', () {
      final text = '12345678901234567890'; // 20 chars
      final result = Utils.truncate(text, 10); // threshold = 10*2 = 20
      expect(result, equals(text)); // Should return original
    });

    test('default maxLen is 10', () {
      final long = 'A' * 25;
      final result = Utils.truncate(long);
      expect(result!.length, equals(20)); // 10 + 10
    });
  });

  group('Utils.getOrDefault', () {
    test('returns function result when successful', () {
      final result = Utils.getOrDefault(() => 42);
      expect(result, equals(42));
    });

    test('returns function result for string', () {
      final result = Utils.getOrDefault(() => 'hello');
      expect(result, equals('hello'));
    });

    test('returns default value when function throws', () {
      final result = Utils.getOrDefault<int>(() => throw Exception('error'), 99);
      expect(result, equals(99));
    });

    test('returns null as default when not specified and function throws', () {
      final result = Utils.getOrDefault<int?>(() => throw Exception('error'));
      expect(result, isNull);
    });

    test('works with complex objects', () {
      final obj = {'key': 'value'};
      final result = Utils.getOrDefault(() => obj);
      expect(result, equals(obj));
    });

    test('catches and handles any exception type', () {
      final result1 = Utils.getOrDefault<String>(() => throw ArgumentError('bad'), 'default');
      expect(result1, equals('default'));

      final result2 = Utils.getOrDefault<String>(() => throw StateError('bad'), 'fallback');
      expect(result2, equals('fallback'));
    });

    test('can return false as valid value', () {
      final result = Utils.getOrDefault(() => false, true);
      expect(result, isFalse);
    });

    test('can return zero as valid value', () {
      final result = Utils.getOrDefault(() => 0, 42);
      expect(result, equals(0));
    });
  });

  group('Utils.encodeStringToBase64UrlSafeString', () {
    test('encodes simple string', () {
      final result = Utils.encodeStringToBase64UrlSafeString('hello');
      expect(result, isNotEmpty);
      expect(result, isA<String>());
    });

    test('encodes special characters', () {
      final result = Utils.encodeStringToBase64UrlSafeString('hello@world!');
      expect(result, isNotEmpty);
    });

    test('encodes empty string', () {
      final result = Utils.encodeStringToBase64UrlSafeString('');
      expect(result, isEmpty);
    });

    test('encodes URL with special characters', () {
      final url = 'https://example.com?foo=bar&baz=qux';
      final result = Utils.encodeStringToBase64UrlSafeString(url);
      expect(result, isNotEmpty);
      // URL-safe base64 should not contain + or /
      expect(result.contains('+'), isFalse);
      expect(result.contains('/'), isFalse);
    });

    test('produces URL-safe encoding', () {
      final result = Utils.encodeStringToBase64UrlSafeString('test+data/more=stuff');
      // Should use - and _ instead of + and /
      expect(result.contains('+'), isFalse);
      expect(result.contains('/'), isFalse);
    });

    test('can be decoded back', () {
      final original = 'test string with spaces and punctuation!';
      final encoded = Utils.encodeStringToBase64UrlSafeString(original);
      final decoded = Utils.decodeFromBase64UrlSafeEncodedString(encoded);
      expect(decoded, equals(original));
    });
  });

  group('Utils.decodeFromBase64UrlSafeEncodedString', () {
    test('decodes encoded string', () {
      final encoded = Utils.encodeStringToBase64UrlSafeString('hello world');
      final result = Utils.decodeFromBase64UrlSafeEncodedString(encoded);
      expect(result, equals('hello world'));
    });

    test('decodes special characters', () {
      final original = 'test@example.com';
      final encoded = Utils.encodeStringToBase64UrlSafeString(original);
      final result = Utils.decodeFromBase64UrlSafeEncodedString(encoded);
      expect(result, equals(original));
    });

    test('handles empty string', () {
      final encoded = Utils.encodeStringToBase64UrlSafeString('');
      final result = Utils.decodeFromBase64UrlSafeEncodedString(encoded);
      expect(result, isEmpty);
    });

    test('roundtrip with URL', () {
      final original = 'https://example.com/path?query=value';
      final encoded = Utils.encodeStringToBase64UrlSafeString(original);
      final decoded = Utils.decodeFromBase64UrlSafeEncodedString(encoded);
      expect(decoded, equals(original));
    });

    test('roundtrip with unicode characters', () {
      final original = 'Hello 世界 🌍';
      final encoded = Utils.encodeStringToBase64UrlSafeString(original);
      final decoded = Utils.decodeFromBase64UrlSafeEncodedString(encoded);
      expect(decoded, equals(original));
    });

    test('roundtrip with long text', () {
      final original = 'A' * 1000;
      final encoded = Utils.encodeStringToBase64UrlSafeString(original);
      final decoded = Utils.decodeFromBase64UrlSafeEncodedString(encoded);
      expect(decoded, equals(original));
      expect(decoded.length, equals(1000));
    });
  });

  group('Utils.getHashedUserAvatarUrl', () {
    test('generates URL for email', () {
      final result = Utils.getHashedUserAvatarUrl('test@example.com');
      expect(result, startsWith('https://api.multiavatar.com/'));
    });

    test('generates different URLs for different emails', () {
      final url1 = Utils.getHashedUserAvatarUrl('alice@example.com');
      final url2 = Utils.getHashedUserAvatarUrl('bob@example.com');
      expect(url1, isNot(equals(url2)));
    });

    test('generates consistent URL for same email', () {
      final url1 = Utils.getHashedUserAvatarUrl('test@example.com');
      final url2 = Utils.getHashedUserAvatarUrl('test@example.com');
      expect(url1, equals(url2));
    });

    test('hashes the email (not plaintext)', () {
      final email = 'test@example.com';
      final url = Utils.getHashedUserAvatarUrl(email);
      // URL should not contain the original email
      expect(url.toLowerCase().contains(email.toLowerCase()), isFalse);
    });

    test('handles empty email', () {
      final result = Utils.getHashedUserAvatarUrl('');
      expect(result, startsWith('https://api.multiavatar.com/'));
    });

    test('handles special characters in email', () {
      final result = Utils.getHashedUserAvatarUrl('user+tag@example.com');
      expect(result, startsWith('https://api.multiavatar.com/'));
    });
  });

  group('todo function', () {
    test('throws exception with message', () {
      expect(
        () => todo('implement this feature'),
        throwsA(isA<Exception>()),
      );
    });

    test('exception contains todo marker', () {
      try {
        todo('test message');
        fail('Should have thrown');
      } catch (e) {
        expect(e.toString(), contains('@todo'));
        expect(e.toString(), contains('test message'));
      }
    });

    test('can be used as placeholder', () {
      void someFunction() {
        todo('not implemented yet');
      }

      expect(someFunction, throwsException);
    });
  });
}
