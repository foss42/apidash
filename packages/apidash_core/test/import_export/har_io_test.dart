import 'package:test/test.dart';
import 'package:apidash_core/apidash_core.dart';

void main() {
  group('HarParserIO parseFormData', () {
    late HarParserIO harParser;

    setUp(() {
      harParser = HarParserIO();
    });

    test('parses a simple key-value pair', () {
      expect(harParser.parseFormData('name=apidash'), [('name', 'apidash')]);
    });

    test('keeps every entry when a name repeats', () {
      expect(
        harParser.parseFormData('tag=red&tag=blue&tag=green'),
        [('tag', 'red'), ('tag', 'blue'), ('tag', 'green')],
      );
    });

    test('keeps values containing a trailing = (base64)', () {
      expect(
        harParser.parseFormData('token=YWJjZA=='),
        [('token', 'YWJjZA==')],
      );
    });

    test('keeps values containing = in the middle', () {
      expect(
        harParser.parseFormData('filter=a=b'),
        [('filter', 'a=b')],
      );
    });

    test('preserves all pairs when a value contains =', () {
      expect(
        harParser.parseFormData('user=deepak&token=abc==&role=admin'),
        [('user', 'deepak'), ('token', 'abc=='), ('role', 'admin')],
      );
    });

    test('decodes percent-encoded keys and values', () {
      expect(
        harParser.parseFormData('full%20name=John%20Doe'),
        [('full name', 'John Doe')],
      );
    });

    test('decodes plus signs as spaces in form data', () {
      expect(
        harParser.parseFormData('full+name=John+Doe'),
        [('full name', 'John Doe')],
      );
    });

    test('handles an empty value', () {
      expect(harParser.parseFormData('key='), [('key', '')]);
    });

    test('returns no fields for null or empty input', () {
      expect(harParser.parseFormData(null), []);
      expect(harParser.parseFormData(''), []);
    });
  });

  group('HarParserIO form data import', () {
    late HarParserIO harParser;

    setUp(() {
      harParser = HarParserIO();
    });

    test('keeps every field of a url-encoded body in the order written', () {
      const harJson = '''
{
  "log": {
    "version": "1.2",
    "creator": {"name": "api-dash-test", "version": "1.0"},
    "entries": [
      {
        "startedDateTime": "2026-10-30T00:00:00.000Z",
        "time": 1,
        "request": {
          "method": "POST",
          "url": "https://example.com/submit",
          "httpVersion": "HTTP/1.1",
          "headers": [
            {"name": "Content-Type", "value": "application/x-www-form-urlencoded"}
          ],
          "queryString": [],
          "cookies": [],
          "headersSize": -1,
          "bodySize": -1,
          "postData": {
            "mimeType": "application/x-www-form-urlencoded",
            "text": "tag=red&tag=blue&tag=green"
          }
        },
        "response": {
          "status": 200,
          "statusText": "OK",
          "httpVersion": "HTTP/1.1",
          "headers": [],
          "cookies": [],
          "content": {"size": 0, "mimeType": "text/plain"},
          "redirectURL": "",
          "headersSize": -1,
          "bodySize": -1
        },
        "cache": {},
        "timings": {"send": 0, "wait": 1, "receive": 0}
      }
    ]
  }
}
''';

      final models = harParser.getHttpRequestModelList(harJson);

      expect(models, isNotNull);
      final request = models!.single.$2;
      expect(request.bodyContentType, ContentType.formdata);
      expect(
        request.formData?.map((field) => '${field.name}=${field.value}'),
        ['tag=red', 'tag=blue', 'tag=green'],
      );
    });
  });
}
