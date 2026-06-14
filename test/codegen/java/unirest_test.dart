import 'package:apidash/codegen/java/unirest.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JavaUnirestGen', () {
    final generator = JavaUnirestGen();

    test('getCode returns code for GET request', () {
      final req = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.test.com',
      );
      final result = generator.getCode(req);
      expect(result, isNotNull);
      expect(result, contains('Unirest\n                .get(requestURL)'));
      expect(result, contains('final String requestURL = "https://api.test.com";'));
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
      expect(result, contains('.queryString("q", "test")'));
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
      expect(result, contains('.header("Authorization", "Bearer token")'));
    });

    test('getCode handles text body', () {
      final req = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.test.com',
        bodyContentType: ContentType.text,
        body: 'Hello World',
      );
      final result = generator.getCode(req);
      expect(result, contains('final String requestBody = """\nHello World""";'));
      expect(result, contains('.body(requestBody)'));
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
          const FormDataModel(name: 'field', value: 'value', type: FormDataType.text),
        ],
      );
      final result = generator.getCode(req);
      expect(result, contains('.field("field", "value")'));
    });
  });
}
