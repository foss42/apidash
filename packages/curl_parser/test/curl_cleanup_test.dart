import 'package:curl_parser/curl_parser.dart';
import 'package:seed/seed.dart';
import 'package:test/test.dart';

/// Tests covering changes from the best-practices cleanup of curl.dart:
/// - const constructor
/// - FormatException (instead of generic Exception)
/// - Header parsing preserving colons in values
/// - Form data parsing preserving '=' in values
/// - StringBuffer-based toCurlString
void main() {
  group('const constructor', () {
    test('can be used in a const context', () {
      // The const keyword here would fail at compile time if the constructor
      // were not const.
      const curl = Curl(
        method: 'GET',
        uri: _constUri,
      );
      expect(curl.method, 'GET');
    });

    test('two identical const instances are identical', () {
      const a = Curl(method: 'GET', uri: _constUri);
      const b = Curl(method: 'GET', uri: _constUri);
      expect(identical(a, b), isTrue);
    });
  });

  group('FormatException on invalid input', () {
    test('throws FormatException when input does not start with curl', () {
      expect(
        () => Curl.parse('wget https://example.com'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when URL is missing', () {
      expect(
        () => Curl.parse('curl -X GET'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException for header without colon', () {
      expect(
        () => Curl.parse('curl -H "InvalidHeader" https://example.com'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException for form data without equals sign', () {
      expect(
        () =>
            Curl.parse('curl -X POST https://example.com -F "invalid_format"'),
        throwsA(isA<FormatException>()),
      );
    });

    test('tryParse returns null for all FormatException cases', () {
      expect(Curl.tryParse('wget https://example.com'), isNull);
      expect(Curl.tryParse('curl -X GET'), isNull);
      expect(Curl.tryParse('curl -H "NoColon" https://example.com'), isNull);
      expect(
        Curl.tryParse('curl -X POST https://example.com -F "no_equals"'),
        isNull,
      );
    });
  });

  group('header parsing preserves colons in values', () {
    test('parses header value containing a single colon', () {
      final curl = Curl.parse(
        'curl -H "Authorization: Bearer abc:def" https://example.com',
      );
      expect(curl.headers?['Authorization'], 'Bearer abc:def');
    });

    test('parses header value containing multiple colons', () {
      final curl = Curl.parse(
        'curl -H "X-Custom: a:b:c:d" https://example.com',
      );
      expect(curl.headers?['X-Custom'], 'a:b:c:d');
    });

    test('parses header value that is a URL with port', () {
      final curl = Curl.parse(
        'curl -H "X-Redirect: https://example.com:8080/path" https://api.test.com',
      );
      expect(curl.headers?['X-Redirect'], 'https://example.com:8080/path');
    });

    test('trims whitespace around header key and value', () {
      // cURL headers often have "Key: Value" with space after colon
      final curl = Curl.parse(
        r'''curl -H "Content-Type:   application/json  " https://example.com''',
      );
      expect(curl.headers?['Content-Type'], 'application/json');
    });
  });

  group('form data parsing preserves equals in values', () {
    test('parses form value containing an equals sign', () {
      final curl = Curl.parse(
        'curl -X POST https://example.com -F "data=abc=def"',
      );
      expect(curl.formData, isNotNull);
      expect(curl.formData!.length, 1);
      expect(curl.formData![0].name, 'data');
      expect(curl.formData![0].value, 'abc=def');
      expect(curl.formData![0].type, FormDataType.text);
    });

    test('parses form value containing multiple equals signs (base64)', () {
      final curl = Curl.parse(
        'curl -X POST https://example.com -F "token=dGVzdA=="',
      );
      expect(curl.formData, isNotNull);
      expect(curl.formData![0].name, 'token');
      expect(curl.formData![0].value, 'dGVzdA==');
    });

    test('parses file form entry with equals in path', () {
      final curl = Curl.parse(
        'curl -X POST https://example.com -F "file=@/tmp/a=b.txt"',
      );
      expect(curl.formData, isNotNull);
      expect(curl.formData![0].name, 'file');
      expect(curl.formData![0].value, '/tmp/a=b.txt');
      expect(curl.formData![0].type, FormDataType.file);
    });
  });

  group('toCurlString (StringBuffer implementation)', () {
    test('produces identical output for simple GET', () {
      const curl = Curl(
        method: 'GET',
        uri: _constUri,
      );
      expect(curl.toCurlString(), 'curl "https://example.com"');
    });

    test('produces correct output for complex request', () {
      final curl = Curl(
        method: 'PUT',
        uri: Uri.parse('https://api.example.com/resource'),
        headers: {'Content-Type': 'application/json'},
        data: '{"key":"value"}',
        cookie: 'sid=xyz',
        user: 'admin:secret',
        referer: 'https://example.com',
        userAgent: 'TestAgent/2.0',
        insecure: true,
        location: true,
      );
      expect(
        curl.toCurlString(),
        r'''curl -X PUT "https://api.example.com/resource" \
 -H "Content-Type: application/json" \
 -d '{"key":"value"}' \
 -b 'sid=xyz' \
 -u 'admin:secret' \
 -e 'https://example.com' \
 -A 'TestAgent/2.0' -k -L''',
      );
    });

    test('roundtrips correctly through parse and toCurlString', () {
      final original = Curl(
        method: 'POST',
        uri: Uri.parse('https://api.example.com/data'),
        headers: {
          'Authorization': 'Bearer tok:en:123',
          'Accept': 'application/json',
        },
        data: 'payload=value',
      );
      final curlString = original.toCurlString();
      final parsed = Curl.parse(curlString);
      expect(parsed.method, original.method);
      expect(parsed.uri, original.uri);
      expect(parsed.headers, original.headers);
      expect(parsed.data, original.data);
    });

    test('roundtrip preserves header values with colons', () {
      final original = Curl(
        method: 'GET',
        uri: Uri.parse('https://api.example.com'),
        headers: {'X-Forwarded-For': 'http://proxy:8080'},
      );
      final parsed = Curl.parse(original.toCurlString());
      expect(parsed.headers?['X-Forwarded-For'], 'http://proxy:8080');
    });
  });
}

/// A compile-time constant URI for use in const Curl tests.
const _constUri = _ConstUri();

class _ConstUri implements Uri {
  const _ConstUri();

  @override
  String get scheme => 'https';
  @override
  String get host => 'example.com';
  @override
  int get port => 443;
  @override
  String get path => '';
  @override
  String get query => '';
  @override
  String get fragment => '';
  @override
  String get userInfo => '';
  @override
  String get authority => 'example.com';
  @override
  List<String> get pathSegments => const [];
  @override
  Map<String, String> get queryParameters => const {};
  @override
  Map<String, List<String>> get queryParametersAll => const {};
  @override
  bool get hasAbsolutePath => true;
  @override
  bool get hasAuthority => true;
  @override
  bool get hasEmptyPath => true;
  @override
  bool get hasFragment => false;
  @override
  bool get hasPort => false;
  @override
  bool get hasQuery => false;
  @override
  bool get hasScheme => true;
  @override
  bool get isAbsolute => true;
  @override
  String get origin => 'https://example.com';
  @override
  UriData? get data => null;

  @override
  String toString() => 'https://example.com';

  @override
  Uri normalizePath() => this;
  @override
  Uri resolve(String reference) => Uri.parse(reference);
  @override
  Uri resolveUri(Uri reference) => reference;
  @override
  Uri replace({
    String? scheme,
    String? userInfo,
    String? host,
    int? port,
    String? path,
    Iterable<String>? pathSegments,
    String? query,
    Map<String, dynamic>? queryParameters,
    String? fragment,
  }) =>
      this;
  @override
  Uri removeFragment() => this;
  @override
  String toFilePath({bool? windows}) => '';

  @override
  bool operator ==(Object other) =>
      other is Uri && other.toString() == toString();

  @override
  int get hashCode => toString().hashCode;

  @override
  // ignore: override_on_non_overriding_member
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
