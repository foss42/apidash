import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';

void main() {
  const mdGenerator = MarkdownDocGenerator();
  const curlGenerator = CurlSessionGenerator();
  const List<DocGenerator> allGenerators = [mdGenerator, curlGenerator];

  group('DocGenerator - Polymorphism & Interface Integrity', () {
    test('Both generators conform to DocGenerator contract', () {
      const request = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.example.com/status',
      );
      for (final generator in allGenerators) {
        final output = generator.generate(
          request: request,
          requestName: 'System Status',
        );
        expect(output, isNotEmpty);
      }
    });
  });

  group('Task 1: Standard GET request with query parameters', () {
    const request = HttpRequestModel(
      method: HTTPVerb.get,
      url: 'https://api.example.com/items',
      params: [
        NameValueModel(name: 'page', value: '2'),
        NameValueModel(name: 'limit', value: '50'),
        NameValueModel(name: 'sort', value: 'created_at:desc'),
      ],
    );

    test('MarkdownDocGenerator outputs query parameters table and omits body', () {
      final md = mdGenerator.generate(
        request: request,
        requestName: 'Get Paginated Items',
      );
      expect(md, contains('# Get Paginated Items'));
      expect(md, contains('`GET` `https://api.example.com/items`'));
      expect(md, contains('### Query Parameters'));
      expect(md, contains('| Parameter | Value |'));
      expect(md, contains('| page | 2 |'));
      expect(md, contains('| limit | 50 |'));
      expect(md, contains('| sort | created_at:desc |'));
      expect(md, isNot(contains('### Request Body')));
    });

    test('CurlSessionGenerator appends query parameters to target URL', () {
      final curl = curlGenerator.generate(
        request: request,
        requestName: 'Get Paginated Items',
      );
      expect(curl, startsWith('# Get Paginated Items\n'));
      expect(
        curl,
        contains("curl -X GET 'https://api.example.com/items?page=2&limit=50&sort=created_at%3Adesc'\n"),
      );
      expect(curl, isNot(contains('--data')));
    });
  });

  group('Task 2: POST request with JSON body and authorization header', () {
    const request = HttpRequestModel(
      method: HTTPVerb.post,
      url: 'https://api.example.com/v1/auth/profile',
      headers: [
        NameValueModel(name: 'Authorization', value: 'Bearer token_xyz_123'),
        NameValueModel(name: 'Content-Type', value: 'application/json'),
        NameValueModel(name: 'X-Tenant-ID', value: 'enterprise-alpha'),
      ],
      bodyContentType: ContentType.json,
      body: '{"username":"johndoe","email":"john@example.com","roles":["admin","editor"]}',
    );

    const response = HttpResponseModel(
      statusCode: 201,
      time: Duration(milliseconds: 65),
      headers: {
        'Content-Type': 'application/json',
      },
      body: '{"id":1001,"status":"active"}',
    );

    test('MarkdownDocGenerator formats headers table, descriptions, and pretty JSON', () {
      final md = mdGenerator.generate(
        request: request,
        response: response,
        requestName: 'Update Profile',
      );

      // Request Headers with descriptions
      expect(md, contains('### Headers'));
      expect(md, contains('| Authorization | Bearer token_xyz_123 | Authentication credentials |'));
      expect(md, contains('| Content-Type | application/json | Media type of the request body |'));
      expect(md, contains('| X-Tenant-ID | enterprise-alpha | - |'));

      // Pretty JSON Request Body
      expect(md, contains('### Request Body (application/json)'));
      expect(md, contains('```json\n{\n  "username": "johndoe",\n  "email": "john@example.com",\n  "roles": [\n    "admin",\n    "editor"\n  ]\n}\n```'));

      // Response Status, Elapsed time, and Body
      expect(md, contains('- **Status Code**: `201 Created`'));
      expect(md, contains('- **Time Elapsed**: `65 ms`'));
      expect(md, contains('### Response Body\n```json\n{\n  "id": 1001,\n  "status": "active"\n}\n```'));
    });

    test('CurlSessionGenerator generates -H and --data flags with response comment', () {
      final curl = curlGenerator.generate(
        request: request,
        response: response,
        requestName: 'Update Profile',
      );
      expect(curl, contains("curl -X POST 'https://api.example.com/v1/auth/profile' \\\n"));
      expect(curl, contains("  -H 'Authorization: Bearer token_xyz_123' \\\n"));
      expect(curl, contains("  -H 'Content-Type: application/json' \\\n"));
      expect(curl, contains("  -H 'X-Tenant-ID: enterprise-alpha' \\\n"));
      expect(curl, contains('  --data \'{"username":"johndoe","email":"john@example.com","roles":["admin","editor"]}\''));
      expect(curl, endsWith('# Response: 201 Created (65 ms)\n'));
    });
  });

  group('Task 3: Multipart/form-data request with text fields and file paths', () {
    const request = HttpRequestModel(
      method: HTTPVerb.post,
      url: 'https://api.example.com/v1/documents/upload',
      headers: [
        NameValueModel(name: 'Authorization', value: 'Bearer upload_token'),
        NameValueModel(name: 'Content-Type', value: 'multipart/form-data'),
      ],
      bodyContentType: ContentType.formdata,
      formData: [
        FormDataModel(name: 'title', value: 'Quarterly Report', type: FormDataType.text),
        FormDataModel(name: 'document', value: '/docs/report_q3.pdf', type: FormDataType.file),
        FormDataModel(name: 'is_public', value: 'false', type: FormDataType.text),
      ],
    );

    test('MarkdownDocGenerator creates multipart table with types and values', () {
      final md = mdGenerator.generate(request: request);
      expect(md, contains('### Request Body (multipart/form-data)'));
      expect(md, contains('| Field | Type | Value |'));
      expect(md, contains('| title | Text | Quarterly Report |'));
      expect(md, contains('| document | File | /docs/report_q3.pdf |'));
      expect(md, contains('| is_public | Text | false |'));
    });

    test('CurlSessionGenerator formats -F flags and skips Content-Type header', () {
      final curl = curlGenerator.generate(request: request);
      expect(curl, contains("  -H 'Authorization: Bearer upload_token' \\\n"));
      // Omits redundant Content-Type so curl manages multipart boundary
      expect(curl, isNot(contains("-H 'Content-Type: multipart/form-data'")));
      expect(curl, contains("  -F 'title=Quarterly Report' \\\n"));
      expect(curl, contains("  -F 'document=@/docs/report_q3.pdf' \\\n"));
      expect(curl, contains("  -F 'is_public=false'"));
    });
  });

  group('Task 4: Response with non-JSON body (HTML, XML, plain text)', () {
    const request = HttpRequestModel(
      method: HTTPVerb.get,
      url: 'https://api.example.com/content',
    );

    test('Renders HTML response with language detection and pretty markup', () {
      const htmlBody = '<!DOCTYPE html><html><head><title>Test</title></head><body><h1>Hello</h1></body></html>';
      final response = HttpResponseModel(
        statusCode: 200,
        time: const Duration(milliseconds: 30),
        headers: {'Content-Type': 'text/html; charset=utf-8'},
        body: htmlBody,
      );

      final md = mdGenerator.generate(request: request, response: response);
      expect(md, contains('### Response Body'));
      expect(md, contains('```html'));
      expect(md, contains('<h1>Hello</h1>'));

      final curl = curlGenerator.generate(request: request, response: response);
      expect(curl, contains('# Response: 200 OK (30 ms)'));
    });

    test('Renders XML response with xml language block and formatted content', () {
      const xmlBody = '<root><user id="1"><name>Alice</name></user></root>';
      final response = HttpResponseModel(
        statusCode: 200,
        time: const Duration(milliseconds: 40),
        headers: {'Content-Type': 'application/xml'},
        body: xmlBody,
      );

      final md = mdGenerator.generate(request: request, response: response);
      expect(md, contains('### Response Body'));
      expect(md, contains('```xml'));
      expect(md, contains('<root>'));
      expect(md, contains('<name>Alice</name>'));

      final curl = curlGenerator.generate(request: request, response: response);
      expect(curl, contains('# Response: 200 OK (40 ms)'));
    });

    test('Renders plain text response with text language block', () {
      const textBody = 'Service is running normally. All checks passed.';
      final response = HttpResponseModel(
        statusCode: 200,
        time: const Duration(milliseconds: 20),
        headers: {'Content-Type': 'text/plain'},
        body: textBody,
      );

      final md = mdGenerator.generate(request: request, response: response);
      expect(md, contains('### Response Body'));
      expect(md, contains('```text'));
      expect(md, contains(textBody));

      final curl = curlGenerator.generate(request: request, response: response);
      expect(curl, contains('# Response: 200 OK (20 ms)'));
    });
  });

  group('Task 5: Error status code responses (404 Not Found, 500 Internal Server Error)', () {
    const request = HttpRequestModel(
      method: HTTPVerb.get,
      url: 'https://api.example.com/api/resource/missing',
    );

    test('Renders 404 Not Found response correctly', () {
      final response = HttpResponseModel(
        statusCode: 404,
        time: const Duration(milliseconds: 88),
        headers: {'Content-Type': 'application/json'},
        body: '{"error":"Resource not found"}',
      );

      final md = mdGenerator.generate(request: request, response: response);
      expect(md, contains('- **Status Code**: `404 Not Found`'));
      expect(md, contains('- **Time Elapsed**: `88 ms`'));
      expect(md, contains('"error": "Resource not found"'));

      final curl = curlGenerator.generate(request: request, response: response);
      expect(curl, contains('# Response: 404 Not Found (88 ms)'));
    });

    test('Renders 500 Internal Server Error response correctly', () {
      final response = HttpResponseModel(
        statusCode: 500,
        time: const Duration(milliseconds: 250),
        headers: {'Content-Type': 'text/plain'},
        body: 'Database connection failed',
      );

      final md = mdGenerator.generate(request: request, response: response);
      expect(md, contains('- **Status Code**: `500 Internal Server Error`'));
      expect(md, contains('- **Time Elapsed**: `250 ms`'));
      expect(md, contains('Database connection failed'));

      final curl = curlGenerator.generate(request: request, response: response);
      expect(curl, contains('# Response: 500 Internal Server Error (250 ms)'));
    });
  });

  group('Task 6: Empty / null body cases', () {
    test('Handles request with null and empty string body without error', () {
      for (final bodyVal in [null, '', '   ']) {
        final request = HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.example.com/ping',
          body: bodyVal,
        );

        final md = mdGenerator.generate(request: request);
        expect(md, isNot(contains('### Request Body')));

        final curl = curlGenerator.generate(request: request);
        expect(curl, isNot(contains('--data')));
      }
    });

    test('Handles response with null body and empty headers cleanly', () {
      const request = HttpRequestModel(
        method: HTTPVerb.delete,
        url: 'https://api.example.com/records/99',
      );
      const response = HttpResponseModel(
        statusCode: 204,
        time: Duration(milliseconds: 12),
        body: null,
        headers: {},
      );

      final md = mdGenerator.generate(request: request, response: response);
      expect(md, contains('- **Status Code**: `204 No Content`'));
      expect(md, contains('- **Time Elapsed**: `12 ms`'));
      expect(md, isNot(contains('### Response Headers')));
      expect(md, isNot(contains('### Response Body')));

      final curl = curlGenerator.generate(request: request, response: response);
      expect(curl, contains('# Response: 204 No Content (12 ms)'));
    });

    test('Handles response with empty string body cleanly', () {
      const request = HttpRequestModel(
        method: HTTPVerb.head,
        url: 'https://api.example.com/file.zip',
      );
      const response = HttpResponseModel(
        statusCode: 200,
        time: Duration(milliseconds: 15),
        body: '',
        headers: {'Content-Length': '1048576'},
      );

      final md = mdGenerator.generate(request: request, response: response);
      expect(md, contains('- **Status Code**: `200 OK`'));
      expect(md, contains('### Response Headers'));
      expect(md, isNot(contains('### Response Body')));

      final curl = curlGenerator.generate(request: request, response: response);
      expect(curl, contains('# Response: 200 OK (15 ms)'));
    });
  });
}
