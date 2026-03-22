import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash_core/apidash_core.dart';

void main() {
  group('Testing convertCurlToHttpRequestModel', () {
    test('Basic GET request conversion', () {
      final curl = Curl(
        method: 'GET',
        uri: Uri.parse('https://api.example.com/users'),
      );

      final result = convertCurlToHttpRequestModel(curl);

      expect(result.method, HTTPVerb.get);
      expect(result.url, 'https://api.example.com/users');
      expect(result.headers, []);
      expect(result.params, []);
    });

    test('Request with existing headers should preserve them', () {
      final curl = Curl(
        method: 'GET',
        uri: Uri.parse('https://api.example.com/users'),
        headers: {
          'Content-Type': 'application/json',
          'X-Custom-Header': 'CustomValue',
        },
      );

      final result = convertCurlToHttpRequestModel(curl);

      expect(result.headers?.length, 2);
      expect(
        result.headers?.any(
            (h) => h.name == 'Content-Type' && h.value == 'application/json'),
        true,
      );
      expect(
        result.headers?.any(
            (h) => h.name == 'X-Custom-Header' && h.value == 'CustomValue'),
        true,
      );
    });

    test('Should map cookie to Cookie header', () {
      final curl = Curl(
        method: 'GET',
        uri: Uri.parse('https://api.example.com/users'),
        cookie: 'session=abc123; token=xyz789',
      );

      final result = convertCurlToHttpRequestModel(curl);

      expect(result.headers?.length, 1);
      expect(
        result.headers?.any((h) =>
            h.name == 'Cookie' && h.value == 'session=abc123; token=xyz789'),
        true,
      );
    });

    test('Should not override existing Cookie header', () {
      final curl = Curl(
        method: 'GET',
        uri: Uri.parse('https://api.example.com/users'),
        headers: {'Cookie': 'existing=cookie'},
        cookie: 'session=abc123',
      );

      final result = convertCurlToHttpRequestModel(curl);

      expect(result.headers?.length, 1);
      expect(
        result.headers
            ?.any((h) => h.name == 'Cookie' && h.value == 'existing=cookie'),
        true,
      );
    });

    test('Should map userAgent to User-Agent header', () {
      final curl = Curl(
        method: 'GET',
        uri: Uri.parse('https://api.example.com/users'),
        userAgent: 'MyCustomAgent/1.0',
      );

      final result = convertCurlToHttpRequestModel(curl);

      expect(result.headers?.length, 1);
      expect(
        result.headers?.any(
            (h) => h.name == 'User-Agent' && h.value == 'MyCustomAgent/1.0'),
        true,
      );
    });

    test('Should not override existing User-Agent header (case insensitive)',
        () {
      final curl = Curl(
        method: 'GET',
        uri: Uri.parse('https://api.example.com/users'),
        headers: {'user-agent': 'ExistingAgent/2.0'},
        userAgent: 'MyCustomAgent/1.0',
      );

      final result = convertCurlToHttpRequestModel(curl);

      expect(result.headers?.length, 1);
      expect(
        result.headers?.any(
            (h) => h.name == 'user-agent' && h.value == 'ExistingAgent/2.0'),
        true,
      );
    });

    test('Should map referer to Referer header', () {
      final curl = Curl(
        method: 'GET',
        uri: Uri.parse('https://api.example.com/users'),
        referer: 'https://example.com/source',
      );

      final result = convertCurlToHttpRequestModel(curl);

      expect(result.headers?.length, 1);
      expect(
        result.headers?.any((h) =>
            h.name == 'Referer' && h.value == 'https://example.com/source'),
        true,
      );
    });

    test('Should not override existing Referer header', () {
      final curl = Curl(
        method: 'GET',
        uri: Uri.parse('https://api.example.com/users'),
        headers: {'Referer': 'https://existing.com'},
        referer: 'https://example.com/source',
      );

      final result = convertCurlToHttpRequestModel(curl);

      expect(result.headers?.length, 1);
      expect(
        result.headers?.any(
            (h) => h.name == 'Referer' && h.value == 'https://existing.com'),
        true,
      );
    });

    test('Should map user credentials to Authorization Basic header', () {
      final curl = Curl(
        method: 'GET',
        uri: Uri.parse('https://api.example.com/users'),
        user: 'username:password',
      );

      final result = convertCurlToHttpRequestModel(curl);

      final expectedAuth =
          'Basic ${base64.encode(utf8.encode('username:password'))}';
      expect(result.headers?.length, 1);
      expect(
        result.headers
            ?.any((h) => h.name == 'Authorization' && h.value == expectedAuth),
        true,
      );
    });

    test('Should not override existing Authorization header', () {
      final curl = Curl(
        method: 'GET',
        uri: Uri.parse('https://api.example.com/users'),
        headers: {'Authorization': 'Bearer existing-token'},
        user: 'username:password',
      );

      final result = convertCurlToHttpRequestModel(curl);

      expect(result.headers?.length, 1);
      expect(
        result.headers?.any((h) =>
            h.name == 'Authorization' && h.value == 'Bearer existing-token'),
        true,
      );
    });

    test('Should not add Authorization header if user is empty', () {
      final curl = Curl(
        method: 'GET',
        uri: Uri.parse('https://api.example.com/users'),
        user: '',
      );

      final result = convertCurlToHttpRequestModel(curl);

      expect(result.headers, []);
    });

    test('Should handle multiple custom headers simultaneously', () {
      final curl = Curl(
        method: 'POST',
        uri: Uri.parse('https://api.example.com/users'),
        cookie: 'session=abc123',
        userAgent: 'MyApp/1.0',
        referer: 'https://example.com',
        user: 'admin:secret',
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final result = convertCurlToHttpRequestModel(curl);

      expect(result.headers?.length, 5);
      expect(
        result.headers?.any((h) => h.name == 'Cookie'),
        true,
      );
      expect(
        result.headers?.any((h) => h.name == 'User-Agent'),
        true,
      );
      expect(
        result.headers?.any((h) => h.name == 'Referer'),
        true,
      );
      expect(
        result.headers?.any((h) => h.name == 'Authorization'),
        true,
      );
      expect(
        result.headers?.any((h) => h.name == 'Content-Type'),
        true,
      );
    });

    test('Request with query parameters should parse them correctly', () {
      final curl = Curl(
        method: 'GET',
        uri: Uri.parse('https://api.example.com/users?page=1&limit=10'),
      );

      final result = convertCurlToHttpRequestModel(curl);

      expect(result.url, 'https://api.example.com/users');
      expect(result.params?.length, 2);
      expect(
        result.params?.any((p) => p.name == 'page' && p.value == '1'),
        true,
      );
      expect(
        result.params?.any((p) => p.name == 'limit' && p.value == '10'),
        true,
      );
    });

    test('POST request with body should include data', () {
      final curl = Curl(
        method: 'POST',
        uri: Uri.parse('https://api.example.com/users'),
        data: '{"name":"John","age":30}',
        headers: {'Content-Type': 'application/json'},
      );

      final result = convertCurlToHttpRequestModel(curl);

      expect(result.method, HTTPVerb.post);
      expect(result.body, '{"name":"John","age":30}');
      expect(result.bodyContentType, ContentType.json);
    });

    test('Form data request should set content type correctly', () {
      final curl = Curl(
        method: 'POST',
        uri: Uri.parse('https://api.example.com/upload'),
        form: true,
        formData: [
          FormDataModel(
            name: 'field1',
            value: 'value1',
            type: FormDataType.text,
          ),
          FormDataModel(
            name: 'file1',
            value: '/path/to/file.txt',
            type: FormDataType.file,
          ),
        ],
      );

      final result = convertCurlToHttpRequestModel(curl);

      expect(result.bodyContentType, ContentType.formdata);
      expect(result.formData?.length, 2);
      // File paths should be cleared
      expect(
        result.formData?.any((f) => f.name == 'file1' && f.value == ''),
        true,
      );
    });

    test('Should handle null/empty optional fields gracefully', () {
      final curl = Curl(
        method: 'GET',
        uri: Uri.parse('https://api.example.com/users'),
        cookie: null,
        userAgent: '',
        referer: null,
        user: null,
      );

      final result = convertCurlToHttpRequestModel(curl);

      expect(result.headers, []);
    });
  });

  group('Testing splitCurlCommands', () {
    test('Single curl command should return one item', () {
      const input = '''curl -X GET https://api.example.com/users''';
      final result = splitCurlCommands(input);

      expect(result.length, 1);
      expect(result[0], input);
    });

    test('Multiple curl commands should be split correctly', () {
      const input = '''
curl -X GET https://api.example.com/users
curl -X POST https://api.example.com/users -d '{"name":"John"}'
''';
      final result = splitCurlCommands(input);

      expect(result.length, 2);
      expect(result[0].contains('GET'), true);
      expect(result[1].contains('POST'), true);
    });

    test('Multi-line curl command should be preserved', () {
      const input = '''curl -X POST https://api.example.com/users \\
  -H 'Content-Type: application/json' \\
  -d '{"name":"John"}'
''';
      final result = splitCurlCommands(input);

      expect(result.length, 1);
      expect(result[0].contains('Content-Type'), true);
    });

    test('Non-curl content should return empty list', () {
      const input = 'This is not a curl command';
      final result = splitCurlCommands(input);

      expect(result.isEmpty, true);
    });
  });
}
