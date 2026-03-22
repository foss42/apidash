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
  });
}
