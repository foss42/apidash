import 'package:test/test.dart';
import 'package:apidash_core/apidash_core.dart';

void main() {
  group('HarParserIO parseFormData', () {
    late HarParserIO harParser;

    setUp(() {
      harParser = HarParserIO();
    });

    test('parses a simple key-value pair', () {
      expect(harParser.parseFormData('name=apidash'), {'name': 'apidash'});
    });

    test('keeps values containing a trailing = (base64)', () {
      expect(harParser.parseFormData('token=YWJjZA=='), {'token': 'YWJjZA=='});
    });

    test('keeps values containing = in the middle', () {
      expect(harParser.parseFormData('filter=a=b'), {'filter': 'a=b'});
    });

    test('preserves all pairs when a value contains =', () {
      expect(harParser.parseFormData('user=deepak&token=abc==&role=admin'), {
        'user': 'deepak',
        'token': 'abc==',
        'role': 'admin',
      });
    });

    test('decodes percent-encoded keys and values', () {
      expect(harParser.parseFormData('full%20name=John%20Doe'), {
        'full name': 'John Doe',
      });
    });

    test('decodes plus signs as spaces in form data', () {
      expect(harParser.parseFormData('full+name=John+Doe'), {
        'full name': 'John Doe',
      });
    });

    test('handles an empty value', () {
      expect(harParser.parseFormData('key='), {'key': ''});
    });

    test('returns an empty map for null or empty input', () {
      expect(harParser.parseFormData(null), {});
      expect(harParser.parseFormData(''), {});
    });
  });

  group('HarParserIO harRequestToHttpRequestModel body parsing', () {
    late HarParserIO harParser;

    setUp(() {
      harParser = HarParserIO();
    });

    test('imports application/json with charset parameter', () {
      const harJson = '''
{
  "log": {
    "entries": [
      {
        "request": {
          "method": "POST",
          "url": "https://example.com/api",
          "headers": [],
          "queryString": [],
          "postData": {
            "mimeType": "application/json; charset=UTF-8",
            "text": "{\\"key\\": \\"value\\"}"
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
      final req = result[0].$2;
      expect(req.bodyContentType, ContentType.json);
      expect(req.body, '{"key": "value"}');
    });

    test('imports application/problem+json and json subtype variants', () {
      const harJson = '''
{
  "log": {
    "entries": [
      {
        "request": {
          "method": "POST",
          "url": "https://example.com/problem",
          "headers": [],
          "queryString": [],
          "postData": {
            "mimeType": "application/problem+json; charset=utf-8",
            "text": "{\\"title\\": \\"Not Found\\"}"
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
      final req = result[0].$2;
      expect(req.bodyContentType, ContentType.json);
      expect(req.body, '{"title": "Not Found"}');
    });

    test('imports application/json without parameters', () {
      const harJson = '''
{
  "log": {
    "entries": [
      {
        "request": {
          "method": "POST",
          "url": "https://example.com/api",
          "headers": [],
          "queryString": [],
          "postData": {
            "mimeType": "application/json",
            "text": "{\\"hello\\": \\"world\\"}"
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
      final req = result[0].$2;
      expect(req.bodyContentType, ContentType.json);
      expect(req.body, '{"hello": "world"}');
    });

    test(
      'imports application/x-www-form-urlencoded with charset parameter',
      () {
        const harJson = '''
{
  "log": {
    "entries": [
      {
        "request": {
          "method": "POST",
          "url": "https://example.com/login",
          "headers": [],
          "queryString": [],
          "postData": {
            "mimeType": "application/x-www-form-urlencoded; charset=utf-8",
            "text": "username=john&password=doe"
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
        final req = result[0].$2;
        expect(req.bodyContentType, ContentType.formdata);
        expect(req.formData, isNotNull);
        expect(req.formData!.length, 2);
        expect(req.formData![0].name, 'username');
        expect(req.formData![0].value, 'john');
        expect(req.formData![0].type, FormDataType.text);
        expect(req.formData![1].name, 'password');
        expect(req.formData![1].value, 'doe');
        expect(req.formData![1].type, FormDataType.text);
      },
    );

    test('imports multipart/form-data with boundary parameter', () {
      const harJson = '''
{
  "log": {
    "entries": [
      {
        "request": {
          "method": "POST",
          "url": "https://example.com/upload",
          "headers": [],
          "queryString": [],
          "postData": {
            "mimeType": "multipart/form-data; boundary=----WebKitFormBoundaryX",
            "params": [
              {
                "name": "description",
                "value": "profile picture",
                "contentType": "text/plain; charset=utf-8"
              },
              {
                "name": "avatar",
                "fileName": "photo.png",
                "contentType": "image/png"
              }
            ]
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
      final req = result[0].$2;
      expect(req.bodyContentType, ContentType.formdata);
      expect(req.formData, isNotNull);
      expect(req.formData!.length, 2);
      expect(req.formData![0].name, 'description');
      expect(req.formData![0].value, 'profile picture');
      expect(req.formData![0].type, FormDataType.text);
      expect(req.formData![1].name, 'avatar');
      expect(req.formData![1].value, 'photo.png');
      expect(req.formData![1].type, FormDataType.file);
    });

    test('imports text/plain body', () {
      const harJson = '''
{
  "log": {
    "entries": [
      {
        "request": {
          "method": "POST",
          "url": "https://example.com/text",
          "headers": [],
          "queryString": [],
          "postData": {
            "mimeType": "text/plain; charset=utf-8",
            "text": "Hello world"
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
      final req = result[0].$2;
      expect(req.bodyContentType, ContentType.text);
      expect(req.body, 'Hello world');
    });

    test('imports other media types as text fallback', () {
      const harJson = '''
{
  "log": {
    "entries": [
      {
        "request": {
          "method": "POST",
          "url": "https://example.com/xml",
          "headers": [],
          "queryString": [],
          "postData": {
            "mimeType": "application/xml; charset=utf-8",
            "text": "<note><to>User</to></note>"
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
      final req = result[0].$2;
      expect(req.bodyContentType, ContentType.text);
      expect(req.body, '<note><to>User</to></note>');
    });

    test('handles requests with no postData or empty postData', () {
      const harJson = '''
{
  "log": {
    "entries": [
      {
        "request": {
          "method": "GET",
          "url": "https://example.com/get",
          "headers": [],
          "queryString": []
        }
      }
    ]
  }
}
''';
      final result = harParser.getHttpRequestModelList(harJson);
      expect(result, isNotNull);
      expect(result!.length, 1);
      final req = result[0].$2;
      expect(req.body, isNull);
      expect(req.bodyContentType, kDefaultContentType);
      expect(req.formData, isEmpty);
    });
  });
}
