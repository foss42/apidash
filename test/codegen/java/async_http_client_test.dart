import 'package:apidash/codegen/java/async_http_client.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JavaAsyncHttpClientGen', () {
    final generator = JavaAsyncHttpClientGen();

    test('getCode returns code for GET request', () {
      final req = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.test.com',
      );
      final result = generator.getCode(req);
      expect(result, isNotNull);
      expect(result, contains('asyncHttpClient.prepare("GET", url)'));
      expect(result, contains('String url = "https://api.test.com";'));
    });

    test('getCode handles query params', () {
      final req = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.test.com',
        params: [
          const NameValueModel(name: 'q', value: 'test'),
        ],
      );
      final result = generator.getCode(req);
      expect(result, contains('.addQueryParam("q", "test")'));
    });

    test('getCode handles headers', () {
      final req = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.test.com',
        headers: [
          const NameValueModel(name: 'Authorization', value: 'Bearer token'),
        ],
      );
      final result = generator.getCode(req);
      expect(result, contains('.addHeader("Authorization", "Bearer token")'));
    });

    test('getCode handles text body', () {
      final req = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.test.com',
        bodyContentType: ContentType.text,
        body: 'Hello World',
      );
      final result = generator.getCode(req);
      expect(result, contains('String bodyContent = """\nHello World""";'));
      expect(result, contains('requestBuilder.setBody(bodyContent)'));
    });

    test('getCode handles JSON body', () {
      final req = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.test.com',
        bodyContentType: ContentType.json,
        body: '{"key": "value"}',
      );
      final result = generator.getCode(req);
      expect(result, contains('{"key": "value"}'));
    });

    test('getCode handles form data text', () {
      final req = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.test.com',
        bodyContentType: ContentType.formdata,
        formData: [
          const FormDataModel(name: 'field', value: 'value', type: FormDataType.text),
        ],
      );
      final result = generator.getCode(req);
      expect(result, contains('put("field", "value")'));
      expect(result, contains('new StringPart('));
    });

    test('getCode handles form data file', () {
      final req = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.test.com',
        bodyContentType: ContentType.formdata,
        formData: [
          const FormDataModel(name: 'file', value: 'path/to/file', type: FormDataType.file),
        ],
      );
      final result = generator.getCode(req);
      expect(result, contains('put("file", "path/to/file")'));
      expect(result, contains('new FilePart('));
    });
  });
}
