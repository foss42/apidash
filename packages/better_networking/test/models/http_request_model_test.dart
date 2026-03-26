import 'package:better_networking/better_networking.dart';
import 'package:test/test.dart';

void main() {
  group('HttpRequestModel', () {
    test('should correctly convert to and from JSON', () {
      const model = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.example.com',
        headers: [
          NameValueModel(name: 'Content-Type', value: 'application/json'),
        ],
        params: [NameValueModel(name: 'q', value: 'flutter')],
        isHeaderEnabledList: [true],
        isParamEnabledList: [true],
        bodyContentType: ContentType.json,
        body: '{"key": "value"}',
      );

      final json = model.toJson();
      final fromJson = HttpRequestModel.fromJson(json);

      expect(fromJson.method, HTTPVerb.post);
      expect(fromJson.url, 'https://api.example.com');
      expect(fromJson.bodyContentType, ContentType.json);
      expect(fromJson.headers?.first.name, 'Content-Type');
    });

    test('enabled headers and params map', () {
      const model = HttpRequestModel(
        headers: [
          NameValueModel(name: 'Accept', value: 'application/json'),
          NameValueModel(name: 'X-Test', value: 'test'),
        ],
        isHeaderEnabledList: [true, false],
        params: [NameValueModel(name: 'search', value: 'dart')],
        isParamEnabledList: [true],
      );

      expect(model.enabledHeadersMap.length, 1);
      expect(model.enabledHeadersMap.containsKey('Accept'), true);
      expect(model.enabledHeadersMap.containsKey('X-Test'), false);

      expect(model.enabledParamsMap.length, 1);
      expect(model.enabledParamsMap.containsKey('search'), true);
    });

    test('content type checks', () {
      const model = HttpRequestModel(bodyContentType: ContentType.formdata);
      expect(model.hasFormDataContentType, true);
      expect(model.hasJsonContentType, false);
    });

    test('hasBody logic', () {
      const modelJson = HttpRequestModel(
        method: HTTPVerb.post,
        bodyContentType: ContentType.json,
        body: '{"hello":"world"}',
      );

      expect(modelJson.hasBody, true);
      expect(modelJson.hasJsonData, true);
      expect(modelJson.hasTextData, false);
    });

    test('formData processing and file check', () {
      const formData = [
        FormDataModel(
          name: 'file1',
          value: 'file.txt',
          type: FormDataType.file,
        ),
        FormDataModel(name: 'username', value: 'test', type: FormDataType.text),
      ];

      const model = HttpRequestModel(
        method: HTTPVerb.post,
        bodyContentType: ContentType.formdata,
        formData: formData,
      );

      expect(model.hasFormData, true);
      expect(model.formDataMapList.length, 2);
      expect(model.hasFileInFormData, true);
    });

    test('formUrlEncoded content type check', () {
      const model =
          HttpRequestModel(bodyContentType: ContentType.formUrlEncoded);
      expect(model.hasFormUrlEncodedContentType, true);
      expect(model.hasFormDataContentType, false);
      expect(model.hasJsonContentType, false);
      expect(model.hasTextContentType, false);
    });

    test('hasFormUrlEncodedData with POST and form data', () {
      const formData = [
        FormDataModel(name: 'user', value: 'john', type: FormDataType.text),
        FormDataModel(name: 'pass', value: 'secret', type: FormDataType.text),
      ];

      const model = HttpRequestModel(
        method: HTTPVerb.post,
        bodyContentType: ContentType.formUrlEncoded,
        formData: formData,
      );

      expect(model.hasFormUrlEncodedData, true);
      expect(model.hasBody, true);
      expect(model.hasAnyBody, true);
      expect(model.hasFormData, false);
      expect(model.hasJsonData, false);
    });

    test('formUrlEncodedBody encodes key-value pairs correctly', () {
      const formData = [
        FormDataModel(name: 'user', value: 'john', type: FormDataType.text),
        FormDataModel(name: 'pass', value: 'secret', type: FormDataType.text),
      ];

      const model = HttpRequestModel(
        method: HTTPVerb.post,
        bodyContentType: ContentType.formUrlEncoded,
        formData: formData,
      );

      expect(model.formUrlEncodedBody, 'user=john&pass=secret');
    });

    test('formUrlEncodedBody percent-encodes special characters', () {
      const formData = [
        FormDataModel(
            name: 'query', value: 'hello world', type: FormDataType.text),
        FormDataModel(
            name: 'url', value: 'https://example.com', type: FormDataType.text),
      ];

      const model = HttpRequestModel(
        method: HTTPVerb.post,
        bodyContentType: ContentType.formUrlEncoded,
        formData: formData,
      );

      expect(model.formUrlEncodedBody,
          'query=hello%20world&url=https%3A%2F%2Fexample.com');
    });

    test('formUrlEncodedBody skips empty field names', () {
      const formData = [
        FormDataModel(name: '', value: 'empty', type: FormDataType.text),
        FormDataModel(name: 'key', value: 'val', type: FormDataType.text),
      ];

      const model = HttpRequestModel(
        method: HTTPVerb.post,
        bodyContentType: ContentType.formUrlEncoded,
        formData: formData,
      );

      expect(model.formUrlEncodedBody, 'key=val');
    });

    test('formUrlEncoded JSON serialization round-trip', () {
      const model = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://example.com',
        bodyContentType: ContentType.formUrlEncoded,
      );

      final json = model.toJson();
      final fromJson = HttpRequestModel.fromJson(json);

      expect(fromJson.bodyContentType, ContentType.formUrlEncoded);
      expect(fromJson.hasFormUrlEncodedContentType, true);
    });
  });
}
