import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import 'http_request_models.dart';

void main() {
  test('Testing copyWith', () {
    var httpRequestModel = httpRequestModelPost10;
    final httpRequestModelcopyWith =
        httpRequestModel.copyWith(url: 'https://apidash.dev');
    expect(httpRequestModelcopyWith.url, 'https://apidash.dev');
    // original model unchanged
    expect(httpRequestModel.url, 'https://api.apidash.dev/case/lower');
  });

  test('Testing toJson', () {
    var httpRequestModel = httpRequestModelPost10;
    expect(httpRequestModel.toJson(), httpRequestModelPost10Json);
  });

  test('Testing fromJson', () {
    var httpRequestModel = httpRequestModelPost10;
    final modelFromJson = HttpRequestModel.fromJson(httpRequestModelPost10Json);
    expect(modelFromJson, httpRequestModel);
    expect(modelFromJson.params, const [
      NameValueModel(name: 'size', value: '2'),
      NameValueModel(name: 'len', value: '3'),
    ]);
  });

  test('Testing getters', () {
    var httpRequestModel = httpRequestModelPost10;
    expect(httpRequestModel.headersMap, {
      'User-Agent': 'Test Agent',
      'Content-Type': 'application/json; charset=utf-8'
    });
    expect(httpRequestModel.paramsMap, {'size': '2', 'len': '3'});
    expect(httpRequestModel.enabledHeaders, const [
      NameValueModel(
          name: 'Content-Type', value: 'application/json; charset=utf-8')
    ]);
    expect(httpRequestModel.enabledParams, const [
      NameValueModel(name: 'size', value: '2'),
      NameValueModel(name: 'len', value: '3'),
    ]);
    expect(httpRequestModel.enabledHeadersMap,
        {'Content-Type': 'application/json; charset=utf-8'});
    expect(httpRequestModel.enabledParamsMap, {'size': '2', 'len': '3'});
    expect(httpRequestModel.hasContentTypeHeader, true);

    expect(httpRequestModel.hasFormDataContentType, false);
    expect(httpRequestModel.hasJsonContentType, true);
    expect(httpRequestModel.hasTextContentType, false);
    expect(httpRequestModel.hasFormData, false);

    expect(httpRequestModel.hasJsonData, true);
    expect(httpRequestModel.hasTextData, false);
    expect(httpRequestModel.hasFormData, false);

    httpRequestModel =
        httpRequestModel.copyWith(bodyContentType: ContentType.formdata);
    expect(httpRequestModel.hasFormData, true);
    expect(httpRequestModel.formDataList, const [
      FormDataModel(name: "token", value: "xyz", type: FormDataType.text),
      FormDataModel(
          name: "imfile",
          value: "/Documents/up/1.png",
          type: FormDataType.file),
    ]);
    expect(httpRequestModel.formDataMapList, [
      {'name': 'token', 'value': 'xyz', 'type': 'text'},
      {'name': 'imfile', 'value': '/Documents/up/1.png', 'type': 'file'}
    ]);
    expect(httpRequestModel.hasFileInFormData, true);
  });

  test('Testing immutability', () {
    var httpRequestModel = httpRequestModelPost10;
    var httpRequestModel2 =
        httpRequestModel.copyWith(headers: httpRequestModel.headers);
    expect(httpRequestModel.headers, httpRequestModel2.headers);
    expect(
        identical(httpRequestModel.headers, httpRequestModel2.headers), false);
    var httpRequestModel3 = httpRequestModel.copyWith(headers: null);
    expect(httpRequestModel3.headers, null);
  });
}
