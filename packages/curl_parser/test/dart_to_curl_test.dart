import 'package:apidash_core/apidash_core.dart';
import 'package:curl_parser/curl_parser.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Basic HTTP Methods',
    () {
      test(
        'GET request',
        () {
          final curl = Curl(
            method: 'GET',
            uri: Uri.parse('https://api.apidash.dev'),
          );
          expect(
            curl.toCurlString(),
            'curl "https://api.apidash.dev"',
          );
        },
      );

      test(
        'POST request',
        () {
          final curl = Curl(
            method: 'POST',
            uri: Uri.parse('https://api.apidash.dev/test'),
          );
          expect(
            curl.toCurlString(),
            'curl -X POST "https://api.apidash.dev/test"',
          );
        },
      );

      test('HEAD request', () {
        final curl = Curl(
          method: 'HEAD',
          uri: Uri.parse('https://api.apidash.dev'),
        );
        expect(
          curl.toCurlString(),
          'curl -I "https://api.apidash.dev"',
        );
      });
    },
  );

  group(
    'Headers and Data',
    () {
      test(
        'request with headers',
        () {
          final curl = Curl(
            method: 'GET',
            uri: Uri.parse('https://api.apidash.dev'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer token123'
            },
          );
          expect(
            curl.toCurlString(),
            r'''curl "https://api.apidash.dev" \
 -H "Content-Type: application/json" \
 -H "Authorization: Bearer token123"''',
          );
        },
      );

      test('POST request with data', () {
        final curl = Curl(
          method: 'POST',
          uri: Uri.parse('https://api.apidash.dev/test'),
          headers: {'Content-Type': 'application/json'},
          data: '{"key": "value"}',
        );
        expect(
          curl.toCurlString(),
          r"""curl -X POST "https://api.apidash.dev/test" \
 -H "Content-Type: application/json" \
 -d '{"key": "value"}'""",
        );
      });
    },
  );

  group(
    'Post with Form Data',
    () {
      test('request with form data', () {
        final curl = Curl(
          method: 'POST',
          uri: Uri.parse('https://api.apidash.dev/upload'),
          headers: {'Content-Type': 'multipart/form-data'},
          form: true,
          formData: [
            FormDataModel(
              name: "file",
              value: "/path/to/file.txt",
              type: FormDataType.file,
            ),
            FormDataModel(
              name: "name",
              value: "test",
              type: FormDataType.text,
            ),
          ],
        );
        expect(
          curl.toCurlString(),
          r'''curl -X POST "https://api.apidash.dev/upload" \
 -H "Content-Type: multipart/form-data" \
 -F "file=@/path/to/file.txt" \
 -F "name=test"''',
        );
      });
    },
  );

  group(
    'Special Parameters',
    () {
      test(
        'request with cookie',
        () {
          final curl = Curl(
            method: 'GET',
            uri: Uri.parse('https://api.apidash.dev'),
            cookie: 'session=abc123',
          );
          expect(
            curl.toCurlString(),
            r"""curl "https://api.apidash.dev" \
 -b 'session=abc123'""",
          );
        },
      );

      test(
        'request with user credentials',
        () {
          final curl = Curl(
            method: 'GET',
            uri: Uri.parse('https://api.apidash.dev'),
            user: 'username:password',
          );
          expect(
            curl.toCurlString(),
            r"""curl "https://api.apidash.dev" \
 -u 'username:password'""",
          );
        },
      );

      test(
        'request with referer',
        () {
          final curl = Curl(
            method: 'GET',
            uri: Uri.parse('https://api.apidash.dev'),
            referer: 'https://example.com',
          );
          expect(
            curl.toCurlString(),
            r"""curl "https://api.apidash.dev" \
 -e 'https://example.com'""",
          );
        },
      );

      test(
        'request with user agent',
        () {
          final curl = Curl(
            method: 'GET',
            uri: Uri.parse('https://api.apidash.dev'),
            userAgent: 'MyApp/1.0',
          );
          expect(
            curl.toCurlString(),
            r"""curl "https://api.apidash.dev" \
 -A 'MyApp/1.0'""",
          );
        },
      );

      test(
        'request with insecure flag',
        () {
          final curl = Curl(
            method: 'GET',
            uri: Uri.parse('https://api.apidash.dev'),
            insecure: true,
          );
          expect(
            curl.toCurlString(),
            r"""curl "https://api.apidash.dev" -k""",
          );
        },
      );

      test('request with location flag', () {
        final curl = Curl(
          method: 'GET',
          uri: Uri.parse('https://api.apidash.dev'),
          location: true,
        );
        expect(
          curl.toCurlString(),
          r"""curl "https://api.apidash.dev" -L""",
        );
      });
    },
  );

  group(
    'Complex Requests',
    () {
      test('request with all parameters', () {
        final curl = Curl(
          method: 'POST',
          uri: Uri.parse('https://api.apidash.dev/test'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer token123'
          },
          data: '{"key": "value"}',
          cookie: 'session=abc123',
          user: 'username:password',
          referer: 'https://example.com',
          userAgent: 'MyApp/1.0',
          insecure: true,
          location: true,
        );
        expect(
          curl.toCurlString(),
          r"""curl -X POST "https://api.apidash.dev/test" \
 -H "Content-Type: application/json" \
 -H "Authorization: Bearer token123" \
 -d '{"key": "value"}' \
 -b 'session=abc123' \
 -u 'username:password' \
 -e 'https://example.com' \
 -A 'MyApp/1.0' -k -L""",
        );
      });
    },
  );
}
