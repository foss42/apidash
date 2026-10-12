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
      expect(harParser.parseFormData('token=YWJjZA=='), [
        ('token', 'YWJjZA=='),
      ]);
    });

    test('keeps values containing = in the middle', () {
      expect(harParser.parseFormData('filter=a=b'), [('filter', 'a=b')]);
    });

    test('preserves all pairs when a value contains =', () {
      expect(harParser.parseFormData('user=deepak&token=abc==&role=admin'), [
        ('user', 'deepak'),
        ('token', 'abc=='),
        ('role', 'admin'),
      ]);
    });

    test('decodes percent-encoded keys and values', () {
      expect(harParser.parseFormData('full%20name=John%20Doe'), [
        ('full name', 'John Doe'),
      ]);
    });

    test('decodes plus signs as spaces in form data', () {
      expect(harParser.parseFormData('full+name=John+Doe'), [
        ('full name', 'John Doe'),
      ]);
    });

    test('handles an empty value', () {
      expect(harParser.parseFormData('key='), [('key', '')]);
    });

    test('skips pairs without an equals sign', () {
      expect(harParser.parseFormData('flag&name=apidash'), [
        ('name', 'apidash'),
      ]);
    });

    test('preserves duplicate keys in their original order', () {
      expect(harParser.parseFormData('tag=red&tag=blue&tag=green'), [
        ('tag', 'red'),
        ('tag', 'blue'),
        ('tag', 'green'),
      ]);
    });

    test('preserves order across interleaved duplicate keys', () {
      expect(harParser.parseFormData('user=a&tag=red&role=admin&tag=blue'), [
        ('user', 'a'),
        ('tag', 'red'),
        ('role', 'admin'),
        ('tag', 'blue'),
      ]);
    });

    test('returns an empty list for null or empty input', () {
      expect(harParser.parseFormData(null), isEmpty);
      expect(harParser.parseFormData(''), isEmpty);
    });
  });

  group('HarParserIO HAR request import', () {
    test('keeps duplicate urlencoded fields as separate form data rows', () {
      const harJson = '''
{
  "log": {
    "version": "1.2",
    "creator": {"name": "apidash-test", "version": "1.0"},
    "entries": [
      {
        "startedDateTime": "2023-01-01T00:00:00.000Z",
        "time": 1,
        "request": {
          "method": "POST",
          "url": "https://example.com/api",
          "httpVersion": "HTTP/1.1",
          "headers": [],
          "queryString": [],
          "cookies": [],
          "postData": {
            "mimeType": "application/x-www-form-urlencoded",
            "text": "tag=red&tag=blue&tag=green"
          },
          "headersSize": -1,
          "bodySize": -1
        }
      }
    ]
  }
}
''';

      final requests = HarParserIO().getHttpRequestModelList(harJson);

      expect(requests, isNotNull);
      expect(requests, hasLength(1));
      expect(requests!.single.$2.formData, const [
        FormDataModel(name: 'tag', value: 'red', type: FormDataType.text),
        FormDataModel(name: 'tag', value: 'blue', type: FormDataType.text),
        FormDataModel(name: 'tag', value: 'green', type: FormDataType.text),
      ]);
    });
  });
}
