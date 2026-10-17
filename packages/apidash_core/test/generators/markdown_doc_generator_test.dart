import 'dart:convert';
import 'dart:typed_data';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';

void main() {
  const generator = MarkdownDocGenerator();

  group('MarkdownDocGenerator - Title & Header', () {
    test('Uses explicit requestName if provided', () {
      const request = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.example.com/users',
      );
      final md = generator.generate(
        request: request,
        requestName: 'Fetch All Users',
      );
      expect(
        md,
        startsWith(
          '# Fetch All Users\n`GET` `https://api.example.com/users`\n',
        ),
      );
    });

    test('Falls back to METHOD + URL if requestName is null', () {
      const request = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.example.com/items',
      );
      final md = generator.generate(request: request);
      expect(
        md,
        startsWith(
          '# POST https://api.example.com/items\n`POST` `https://api.example.com/items`\n',
        ),
      );
    });

    test('Falls back to API Request if URL is empty', () {
      const request = HttpRequestModel(method: HTTPVerb.get, url: '');
      final md = generator.generate(request: request);
      expect(md, startsWith('# API Request\n`GET`\n'));
    });
  });

  group('MarkdownDocGenerator - Graceful Omission & Acceptance Criteria', () {
    test('Omits response section completely when response is null', () {
      const request = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.example.com/ping',
      );
      final md = generator.generate(request: request);
      expect(md.contains('## Response'), isFalse);
      expect(md.contains('## Request'), isTrue);
    });

    test('Omits empty headers, query parameters, and body cleanly', () {
      const request = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.example.com/ping',
        headers: [],
        params: [],
        body: null,
      );
      final md = generator.generate(request: request);
      expect(md.contains('### Headers'), isFalse);
      expect(md.contains('### Query Parameters'), isFalse);
      expect(md.contains('### Request Body'), isFalse);
    });
  });

  group('MarkdownDocGenerator - Request Headers Table', () {
    test('Renders headers with standard description and fallback', () {
      const request = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.example.com/secure',
        headers: [
          NameValueModel(name: 'Authorization', value: 'Bearer token123'),
          NameValueModel(name: 'Content-Type', value: 'application/json'),
          NameValueModel(name: 'X-Custom-ID', value: 'custom-999'),
        ],
      );
      final md = generator.generate(request: request);
      expect(md.contains('### Headers'), isTrue);
      expect(md.contains('| Header | Value | Description |'), isTrue);
      expect(
        md.contains(
          '| Authorization | Bearer token123 | Authentication credentials |',
        ),
        isTrue,
      );
      expect(
        md.contains(
          '| Content-Type | application/json | Media type of the request body |',
        ),
        isTrue,
      );
      expect(md.contains('| X-Custom-ID | custom-999 | - |'), isTrue);
    });

    test('Escapes pipe characters in header names and values', () {
      const request = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.example.com',
        headers: [NameValueModel(name: 'X-Pipe|Header', value: 'val1|val2')],
      );
      final md = generator.generate(request: request);
      expect(md.contains(r'| X-Pipe\|Header | val1\|val2 | - |'), isTrue);
    });

    test('Ignores rows with empty header name', () {
      const request = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.example.com',
        headers: [
          NameValueModel(name: '', value: 'ignored'),
          NameValueModel(name: '   ', value: 'also-ignored'),
        ],
      );
      final md = generator.generate(request: request);
      expect(md.contains('### Headers'), isFalse);
    });
  });

  group('MarkdownDocGenerator - Query Parameters Table', () {
    test('Renders active query parameters', () {
      const request = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.example.com/search',
        params: [
          NameValueModel(name: 'q', value: 'dart test'),
          NameValueModel(name: 'page', value: 2),
        ],
      );
      final md = generator.generate(request: request);
      expect(md.contains('### Query Parameters'), isTrue);
      expect(md.contains('| Parameter | Value |'), isTrue);
      expect(md.contains('| q | dart test |'), isTrue);
      expect(md.contains('| page | 2 |'), isTrue);
    });

    test('Ignores rows with empty param name', () {
      const request = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.example.com',
        params: [NameValueModel(name: '', value: 'ignored')],
      );
      final md = generator.generate(request: request);
      expect(md.contains('### Query Parameters'), isFalse);
    });
  });

  group('MarkdownDocGenerator - Request Body', () {
    test('Renders and pretty-prints JSON request body', () {
      const request = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.example.com/items',
        bodyContentType: ContentType.json,
        body: '{"name":"item1","price":10}',
      );
      final md = generator.generate(request: request);
      expect(md.contains('### Request Body (application/json)'), isTrue);
      expect(md.contains('```json'), isTrue);
      expect(md.contains('  "name": "item1"'), isTrue);
      expect(md.contains('  "price": 10'), isTrue);
    });

    test('Renders plain text request body', () {
      const request = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.example.com/echo',
        bodyContentType: ContentType.text,
        body: 'Hello Plain Text!',
      );
      final md = generator.generate(request: request);
      expect(md.contains('### Request Body (text/plain)'), isTrue);
      expect(md.contains('Hello Plain Text!'), isTrue);
    });

    test('Renders multipart/form-data body table', () {
      const request = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.example.com/upload',
        bodyContentType: ContentType.formdata,
        formData: [
          FormDataModel(
            name: 'avatar',
            value: 'image.png',
            type: FormDataType.file,
          ),
          FormDataModel(name: 'userId', value: '123', type: FormDataType.text),
        ],
      );
      final md = generator.generate(request: request);
      expect(md.contains('### Request Body (multipart/form-data)'), isTrue);
      expect(md.contains('| Field | Type | Value |'), isTrue);
      expect(md.contains('| avatar | File | image.png |'), isTrue);
      expect(md.contains('| userId | Text | 123 |'), isTrue);
    });
  });

  group('MarkdownDocGenerator - Response Section', () {
    test('Renders status code, duration, content size, headers, and body', () {
      const request = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.example.com/items/1',
      );
      final responseBody = json.encode({'id': 1, 'name': 'Widget'});
      final responseBytes = Uint8List.fromList(utf8.encode(responseBody));
      final response = HttpResponseModel(
        statusCode: 200,
        time: const Duration(milliseconds: 45),
        headers: {'content-type': 'application/json', 'server': 'nginx'},
        body: responseBody,
        bodyBytes: responseBytes,
      );

      final md = generator.generate(
        request: request,
        response: response,
        requestName: 'Get Single Item',
      );

      expect(md.contains('## Response'), isTrue);
      expect(md.contains('- **Status Code**: `200 OK`'), isTrue);
      expect(md.contains('- **Time Elapsed**: `45 ms`'), isTrue);
      expect(md.contains('- **Content Size**: `24 B`'), isTrue);
      expect(md.contains('### Response Headers'), isTrue);
      expect(md.contains('| content-type | application/json |'), isTrue);
      expect(md.contains('| server | nginx |'), isTrue);
      expect(md.contains('### Response Body'), isTrue);
      expect(md.contains('```json'), isTrue);
      expect(md.contains('  "id": 1'), isTrue);
      expect(md.contains('  "name": "Widget"'), isTrue);
    });

    test('Renders error response (404 Not Found)', () {
      const request = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.example.com/not-found',
      );
      final response = HttpResponseModel(
        statusCode: 404,
        time: const Duration(milliseconds: 120),
        headers: {'content-type': 'text/plain'},
        body: 'Not Found Error',
      );

      final md = generator.generate(request: request, response: response);
      expect(md.contains('- **Status Code**: `404 Not Found`'), isTrue);
      expect(md.contains('- **Time Elapsed**: `120 ms`'), isTrue);
      expect(md.contains('Not Found Error'), isTrue);
    });

    test('Omits response headers and body when empty', () {
      const request = HttpRequestModel(
        method: HTTPVerb.delete,
        url: 'https://api.example.com/items/1',
      );
      const response = HttpResponseModel(
        statusCode: 204,
        time: Duration(milliseconds: 15),
        headers: {},
        body: null,
      );

      final md = generator.generate(request: request, response: response);
      expect(md.contains('- **Status Code**: `204 No Content`'), isTrue);
      expect(md.contains('### Response Headers'), isFalse);
      expect(md.contains('### Response Body'), isFalse);
    });
  });

  group('MarkdownDocGenerator - Full Template Conformance', () {
    test('Matches exact specification template structure', () {
      const request = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.example.com/v1/users',
        headers: [
          NameValueModel(name: 'Authorization', value: 'Bearer secret'),
          NameValueModel(name: 'Content-Type', value: 'application/json'),
        ],
        params: [NameValueModel(name: 'notify', value: 'true')],
        bodyContentType: ContentType.json,
        body: '{"username":"johndoe"}',
      );

      final responseBody = '{\n  "id": 42,\n  "username": "johndoe"\n}';
      final response = HttpResponseModel(
        statusCode: 201,
        time: const Duration(milliseconds: 45),
        headers: {'Content-Type': 'application/json'},
        body: responseBody,
        bodyBytes: Uint8List.fromList(utf8.encode(responseBody)),
      );

      final result = generator.generate(
        request: request,
        response: response,
        requestName: 'Create User',
      );

      final expected = '''# Create User
`POST` `https://api.example.com/v1/users`

## Request
### Headers
| Header | Value | Description |
| :--- | :--- | :--- |
| Authorization | Bearer secret | Authentication credentials |
| Content-Type | application/json | Media type of the request body |

### Query Parameters
| Parameter | Value |
| :--- | :--- |
| notify | true |

### Request Body (application/json)
```json
{
  "username": "johndoe"
}
```

## Response
- **Status Code**: `201 Created`
- **Time Elapsed**: `45 ms`
- **Content Size**: `39 B`

### Response Headers
| Header | Value |
| :--- | :--- |
| Content-Type | application/json |

### Response Body
```json
{
  "id": 42,
  "username": "johndoe"
}
```
''';

      expect(result, expected);
    });
  });
}
