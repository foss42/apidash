import 'package:test/test.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:har/har.dart' as har;

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

  group('HarParserIO harRequestToHttpRequestModel MIME type handling', () {
    late HarParserIO harParser;

    setUp(() {
      harParser = HarParserIO();
    });

    test(
      'preserves JSON body when mimeType contains parameters like charset',
      () {
        final req = har.Request(
          method: 'POST',
          url: 'https://api.example.com/data',
          postData: const har.PostData(
            mimeType: 'application/json; charset=UTF-8',
            text: '{"key": "value"}',
          ),
        );

        final model = harParser.harRequestToHttpRequestModel(req);
        expect(model.method, HTTPVerb.post);
        expect(model.bodyContentType, ContentType.json);
        expect(model.body, '{"key": "value"}');
      },
    );

    test(
      'preserves JSON body for structured syntax suffix mimeType (+json)',
      () {
        final req = har.Request(
          method: 'POST',
          url: 'https://api.example.com/problem',
          postData: const har.PostData(
            mimeType: 'application/problem+json; charset=utf-8',
            text: '{"title": "Bad Request"}',
          ),
        );

        final model = harParser.harRequestToHttpRequestModel(req);
        expect(model.bodyContentType, ContentType.json);
        expect(model.body, '{"title": "Bad Request"}');
      },
    );

    test('preserves URL-encoded form data when mimeType contains charset', () {
      final req = har.Request(
        method: 'POST',
        url: 'https://api.example.com/login',
        postData: const har.PostData(
          mimeType: 'application/x-www-form-urlencoded; charset=utf-8',
          text: 'username=alice&password=secret%26token',
        ),
      );

      final model = harParser.harRequestToHttpRequestModel(req);
      expect(model.bodyContentType, ContentType.formdata);
      expect(model.formData, isNotNull);
      expect(model.formData!.length, 2);
      expect(model.formData![0].name, 'username');
      expect(model.formData![0].value, 'alice');
      expect(model.formData![0].type, FormDataType.text);
      expect(model.formData![1].name, 'password');
      expect(model.formData![1].value, 'secret&token');
      expect(model.formData![1].type, FormDataType.text);
    });

    test('preserves multipart form data when mimeType contains boundary', () {
      final req = har.Request(
        method: 'POST',
        url: 'https://api.example.com/upload',
        postData: const har.PostData(
          mimeType: 'multipart/form-data; boundary=----WebKitFormBoundaryX',
          params: [
            har.Param(
              name: 'title',
              value: 'avatar',
              contentType: 'text/plain',
            ),
            har.Param(
              name: 'file',
              fileName: 'photo.jpg',
              contentType: 'image/jpeg',
            ),
          ],
        ),
      );

      final model = harParser.harRequestToHttpRequestModel(req);
      expect(model.bodyContentType, ContentType.formdata);
      expect(model.formData, isNotNull);
      expect(model.formData!.length, 2);
      expect(model.formData![0].name, 'title');
      expect(model.formData![0].value, 'avatar');
      expect(model.formData![0].type, FormDataType.text);
      expect(model.formData![1].name, 'file');
      expect(model.formData![1].value, 'photo.jpg');
      expect(model.formData![1].type, FormDataType.file);
    });

    test('preserves plain text request body with charset', () {
      final req = har.Request(
        method: 'POST',
        url: 'https://api.example.com/log',
        postData: const har.PostData(
          mimeType: 'text/plain; charset=UTF-8',
          text: 'Sample plain text log message',
        ),
      );

      final model = harParser.harRequestToHttpRequestModel(req);
      expect(model.bodyContentType, ContentType.text);
      expect(model.body, 'Sample plain text log message');
    });

    test('preserves XML body with application/xml mimeType', () {
      final req = har.Request(
        method: 'POST',
        url: 'https://api.example.com/soap',
        postData: const har.PostData(
          mimeType: 'application/xml; charset=utf-8',
          text: '<note><to>User</to></note>',
        ),
      );

      final model = harParser.harRequestToHttpRequestModel(req);
      expect(model.bodyContentType, ContentType.text);
      expect(model.body, '<note><to>User</to></note>');
    });

    test(
      'preserves request body with text fallback when mimeType is unknown',
      () {
        final req = har.Request(
          method: 'POST',
          url: 'https://api.example.com/raw',
          postData: const har.PostData(
            mimeType: 'application/octet-stream',
            text: 'raw content bytes or string',
          ),
        );

        final model = harParser.harRequestToHttpRequestModel(req);
        expect(model.body, 'raw content bytes or string');
      },
    );

    test('populates URL-encoded formData from params if text is empty', () {
      final req = har.Request(
        method: 'POST',
        url: 'https://api.example.com/form',
        postData: const har.PostData(
          mimeType: 'application/x-www-form-urlencoded',
          params: [
            har.Param(name: 'q', value: 'search-term'),
            har.Param(name: 'lang', value: 'en'),
          ],
        ),
      );

      final model = harParser.harRequestToHttpRequestModel(req);
      expect(model.bodyContentType, ContentType.formdata);
      expect(model.formData, isNotNull);
      expect(model.formData!.length, 2);
      expect(model.formData![0].name, 'q');
      expect(model.formData![0].value, 'search-term');
    });

    test(
      'parses full HAR JSON log correctly through getHttpRequestModelList',
      () {
        const harContent = '''
{
  "log": {
    "version": "1.2",
    "creator": {"name": "Browser", "version": "1.0"},
    "entries": [
      {
        "request": {
          "method": "POST",
          "url": "https://api.example.com/users?source=web",
          "httpVersion": "HTTP/1.1",
          "headers": [
            {"name": "Content-Type", "value": "application/json; charset=UTF-8"}
          ],
          "queryString": [
            {"name": "source", "value": "web"}
          ],
          "postData": {
            "mimeType": "application/json; charset=UTF-8",
            "text": "{\\"name\\": \\"John Doe\\"}"
          }
        }
      }
    ]
  }
}
''';

        final result = harParser.getHttpRequestModelList(harContent);
        expect(result, isNotNull);
        expect(result!.length, 1);
        final (url, model) = result.first;
        expect(url, 'https://api.example.com/users?source=web');
        expect(model.url, 'https://api.example.com/users');
        expect(model.method, HTTPVerb.post);
        expect(model.bodyContentType, ContentType.json);
        expect(model.body, '{"name": "John Doe"}');
        expect(model.params, isNotNull);
        expect(model.params!.first.name, 'source');
        expect(model.params!.first.value, 'web');
      },
    );

    test('handles postData being null gracefully', () {
      final req = const har.Request(
        method: 'GET',
        url: 'https://api.example.com/items',
      );

      final model = harParser.harRequestToHttpRequestModel(req);
      expect(model.method, HTTPVerb.get);
      expect(model.body, isNull);
      expect(model.bodyContentType, ContentType.json);
      expect(model.formData, isEmpty);
    });

    test('handles postData with null mimeType and text gracefully', () {
      final req = const har.Request(
        method: 'POST',
        url: 'https://api.example.com/items',
        postData: har.PostData(),
      );

      final model = harParser.harRequestToHttpRequestModel(req);
      expect(model.body, isNull);
      expect(model.formData, isEmpty);
    });

    test('infers JSON when mimeType is null but text contains valid JSON', () {
      final req = const har.Request(
        method: 'POST',
        url: 'https://api.example.com/items',
        postData: har.PostData(text: '{"inferred": true}'),
      );

      final model = harParser.harRequestToHttpRequestModel(req);
      expect(model.bodyContentType, ContentType.json);
      expect(model.body, '{"inferred": true}');
    });

    test('falls back to text when mimeType is null and text is not JSON', () {
      final req = const har.Request(
        method: 'POST',
        url: 'https://api.example.com/items',
        postData: har.PostData(text: 'not a json string'),
      );

      final model = harParser.harRequestToHttpRequestModel(req);
      expect(model.bodyContentType, ContentType.text);
      expect(model.body, 'not a json string');
    });

    test('handles malformed mimeType without throwing exception', () {
      final req = const har.Request(
        method: 'POST',
        url: 'https://api.example.com/items',
        postData: har.PostData(
          mimeType: 'invalid;;;///mime',
          text: 'raw content',
        ),
      );

      final model = harParser.harRequestToHttpRequestModel(req);
      expect(model.body, 'raw content');
      expect(model.bodyContentType, ContentType.text);
    });

    test('handles multipart param with null fileName and value gracefully', () {
      final req = const har.Request(
        method: 'POST',
        url: 'https://api.example.com/upload',
        postData: har.PostData(
          mimeType: 'multipart/form-data',
          params: [har.Param(name: 'emptyParam')],
        ),
      );

      final model = harParser.harRequestToHttpRequestModel(req);
      expect(model.bodyContentType, ContentType.formdata);
      expect(model.formData, isNotNull);
      expect(model.formData!.length, 1);
      expect(model.formData![0].name, 'emptyParam');
      expect(model.formData![0].value, '');
      expect(model.formData![0].type, FormDataType.text);
    });

    test(
      'treats multipart param with text/plain; charset=utf-8 as FormDataType.text not file',
      () {
        final req = har.Request(
          method: 'POST',
          url: 'https://api.example.com/upload',
          postData: const har.PostData(
            mimeType: 'multipart/form-data; boundary=----WebKitFormBoundaryX',
            params: [
              har.Param(
                name: 'comments',
                value: 'User feedback note',
                contentType: 'text/plain; charset=utf-8',
              ),
            ],
          ),
        );

        final model = harParser.harRequestToHttpRequestModel(req);
        expect(model.bodyContentType, ContentType.formdata);
        expect(model.formData, isNotNull);
        expect(model.formData!.length, 1);
        expect(model.formData![0].name, 'comments');
        expect(model.formData![0].value, 'User feedback note');
        expect(model.formData![0].type, FormDataType.text);
      },
    );

    test(
      'does not classify text/plain as JSON when parameters contain the substring "json"',
      () {
        final req = const har.Request(
          method: 'POST',
          url: 'https://api.example.com/log',
          postData: har.PostData(
            mimeType: 'text/plain; charset=utf-8; file=not_a_json_file.txt',
            text: 'plain text body containing "json" keyword in param',
          ),
        );

        final model = harParser.harRequestToHttpRequestModel(req);
        expect(model.bodyContentType, ContentType.text);
        expect(
          model.body,
          'plain text body containing "json" keyword in param',
        );
      },
    );

    test(
      'preserves explicit non-JSON mimeType as text even if content is valid JSON',
      () {
        final req = const har.Request(
          method: 'POST',
          url: 'https://api.example.com/raw',
          postData: har.PostData(
            mimeType: 'application/octet-stream',
            text: '12345',
          ),
        );

        final model = harParser.harRequestToHttpRequestModel(req);
        expect(model.bodyContentType, ContentType.text);
        expect(model.body, '12345');
      },
    );

    test(
      'preserves empty string body for non-JSON media type instead of dropping to null',
      () {
        final req = const har.Request(
          method: 'POST',
          url: 'https://api.example.com/raw',
          postData: har.PostData(
            mimeType: 'application/octet-stream',
            text: '',
          ),
        );

        final model = harParser.harRequestToHttpRequestModel(req);
        expect(model.bodyContentType, ContentType.text);
        expect(model.body, '');
      },
    );

    test('returns null when getHttpRequestModelList receives invalid JSON', () {
      final result = harParser.getHttpRequestModelList('{invalid json');
      expect(result, isNull);
    });

    test(
      'returns empty list when getHttpRequestModelList receives HAR with 0 entries',
      () {
        const emptyHar = '''
{
  "log": {
    "version": "1.2",
    "creator": {"name": "Browser", "version": "1.0"},
    "entries": []
  }
}
''';
        final result = harParser.getHttpRequestModelList(emptyHar);
        expect(result, isNotNull);
        expect(result, isEmpty);
      },
    );
  });
}
