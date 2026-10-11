import 'package:curl_parser/utils/string.dart';
import 'package:test/test.dart';

const defaultTimeout = Timeout(Duration(seconds: 3));

void main() {
  test('parse cURL with single quotes', () async {
    expect(
      splitAsCommandLineArgs(
        r"""--url 'https://api.github.com/repos/foss42/apidash?raw=true' \
  --header 'User-Agent: Test Agent'""",
      ),
      [
        "--url",
        "https://api.github.com/repos/foss42/apidash?raw=true",
        "--header",
        "User-Agent: Test Agent",
      ],
    );
  }, timeout: defaultTimeout);

  test('parse cURL with double quotes', () async {
    expect(
      splitAsCommandLineArgs(
        r'''--url "https://api.github.com/repos/foss42/apidash?raw=true" \
  --header "User-Agent: Test Agent"''',
      ),
      [
        "--url",
        "https://api.github.com/repos/foss42/apidash?raw=true",
        "--header",
        "User-Agent: Test Agent",
      ],
    );
  }, timeout: defaultTimeout);

  test('parse cURL DevTools', () async {
    expect(
      splitAsCommandLineArgs(
        r"""--request GET 'https://dummyimage.com/150/92c952' \
--header 'user-agent: Dart/3.8 (dart:io)' \
--header 'accept-encoding: gzip' \
--header 'content-length: 0' \
--header 'host: dummyimage.com'""",
      ),
      [
        '--request',
        'GET',
        'https://dummyimage.com/150/92c952',
        '--header',
        'user-agent: Dart/3.8 (dart:io)',
        '--header',
        'accept-encoding: gzip',
        '--header',
        'content-length: 0',
        '--header',
        'host: dummyimage.com',
      ],
    );
  }, timeout: defaultTimeout);

  test('parse cURL with body', () async {
    expect(
      splitAsCommandLineArgs(r"""--request POST \
  --url 'https://api.apidash.dev/case/lower' \
  --header 'Content-Type: application/json' \
  --data '{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}'"""),
      [
        "--request",
        "POST",
        "--url",
        "https://api.apidash.dev/case/lower",
        "--header",
        "Content-Type: application/json",
        "--data",
        r'''{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}''',
      ],
    );
  }, timeout: defaultTimeout);

  test('split handles CRLF and backslash-newline', () async {
    final args = splitAsCommandLineArgs(
      "--request GET \\\r\n  --url 'https://api.apidash.dev/echo' \\\n+  \n  --header 'A: 1' ",
    );
    expect(args, [
      '--request',
      'GET',
      '--url',
      'https://api.apidash.dev/echo',
      '--header',
      'A: 1',
    ]);
  }, timeout: defaultTimeout);

  group('clean', () {
    test('removes enclosing double quotes but preserves apostrophes', () {
      expect(
        clean('"https://api.example.com/search?author=O\'Reilly"'),
        "https://api.example.com/search?author=O'Reilly",
      );
    });

    test('removes enclosing single quotes but preserves double quotes', () {
      expect(
        clean("'https://api.example.com/items?filter=\"active\"'"),
        'https://api.example.com/items?filter="active"',
      );
    });

    test('preserves quotes in unquoted strings', () {
      expect(
        clean('https://api.example.com/search?author=O\'Reilly'),
        "https://api.example.com/search?author=O'Reilly",
      );
      expect(
        clean('https://api.example.com/items?filter="active"'),
        'https://api.example.com/items?filter="active"',
      );
    });

    test('preserves unmatched boundary quotes', () {
      expect(clean('"example'), '"example');
      expect(clean("example'"), "example'");
      expect(clean('"example\''), '"example\'');
    });

    test('handles null, empty strings, and single characters', () {
      expect(clean(null), isNull);
      expect(clean(''), '');
      expect(clean('"'), '"');
      expect(clean("'"), "'");
      expect(clean('a'), 'a');
    });

    test('removes matching quotes around an empty string', () {
      expect(clean('""'), '');
      expect(clean("''"), '');
    });
  });
}
