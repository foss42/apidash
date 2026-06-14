import 'package:apidash/codegen/java/okhttp.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JavaOkHttpCodeGen', () {
    final generator = JavaOkHttpCodeGen();

    test('getCode returns code for GET request', () {
      final req = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.test.com',
      );
      final result = generator.getCode(req);
      expect(result, isNotNull);
      expect(result, contains('.get()'));
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
      expect(result, contains('.addQueryParameter("q", "test")'));
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
      expect(result, contains('RequestBody.create('));
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
      expect(result, contains('"{\\"key\\": \\"value\\"}"'));
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
      expect(result, contains('.addFormDataPart("field","value")'));
    });
  });
}
