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

    test('returns an empty list for null or empty input', () {
      expect(harParser.parseFormData(null), []);
      expect(harParser.parseFormData(''), []);
    });

    // Regression test for https://github.com/foss42/apidash/issues/1857
    // Duplicate keys must all be preserved as separate entries.
    test('preserves duplicate keys instead of overwriting them', () {
      expect(
        harParser.parseFormData('tag=red&tag=blue&tag=green'),
        [('tag', 'red'), ('tag', 'blue'), ('tag', 'green')],
      );
    });

    test('preserves duplicate keys mixed with unique keys', () {
      expect(
        harParser.parseFormData('color=red&size=M&color=blue'),
        [('color', 'red'), ('size', 'M'), ('color', 'blue')],
      );
    });

    test('harRequestToHttpRequestModel preserves duplicate form fields', () {
      // Build a minimal HAR JSON with a URL-encoded body that has duplicate keys
      const harJson = '''
{
  "log": {
    "entries": [
      {
        "request": {
          "method": "POST",
          "url": "https://example.com/submit",
          "headers": [],
          "queryString": [],
          "postData": {
            "mimeType": "application/x-www-form-urlencoded",
            "text": "tag=red&tag=blue&tag=green"
          }
        }
      }
    ]
  }
}
''';
      final result = harParser.getHttpRequestModelList(harJson);
      expect(result, isNotNull);
      expect(result!.length, 1);

      final formData = result[0].$2.formData;
      expect(formData, isNotNull);
      expect(formData!.length, 3,
          reason: 'All three duplicate tag fields must be imported');
      expect(formData[0].name, 'tag');
      expect(formData[0].value, 'red');
      expect(formData[1].name, 'tag');
      expect(formData[1].value, 'blue');
      expect(formData[2].name, 'tag');
      expect(formData[2].value, 'green');
    });
  });
}
