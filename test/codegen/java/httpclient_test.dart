import 'package:apidash/codegen/java/httpclient.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JavaHttpClientCodeGen', () {
    final generator = JavaHttpClientCodeGen();

    test('getCode returns code for GET request', () {
      final req = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.test.com',
      );
      final result = generator.getCode(req);
      expect(result, isNotNull);
      expect(result, contains('HttpRequest.newBuilder(uri).GET()'));
      expect(result, contains('URI uri = URI.create("https://api.test.com");'));
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
      expect(result, contains('.headers('));
      expect(result, contains('"Authorization", "Bearer token"'));
    });

    test('getCode handles text body', () {
      final req = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.test.com',
        bodyContentType: ContentType.text,
        body: 'Hello World',
      );
      final result = generator.getCode(req);
      expect(result, contains('HttpRequest.BodyPublishers.ofString('));
      expect(result, contains('Hello World'));
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

    test('getCode handles form data', () {
      final req = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.test.com',
        bodyContentType: ContentType.formdata,
        formData: [
          const FormDataModel(
            name: 'field',
            value: 'value',
            type: FormDataType.text,
          ),
        ],
      );
      final result = generator.getCode(req, boundary: 'test_boundary');
      expect(result, contains('buildMultipartFormData'));
      expect(result, contains('test_boundary'));
      expect(result, contains('data.put("field", "value")'));
    });
  });
}
