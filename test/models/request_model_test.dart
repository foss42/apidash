import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';

void main() {
  int statusCode = 200;
  Map<String, String> headers = {
    "content-length": "16",
    "x-cloud-trace-context": "dad62aaf7f640300bbf629f4ae2f2f63",
    "content-type": "application/json",
    "date": "Sun, 23 Apr 2023 23:46:31 GMT",
    "server": "Google Frontend"
  };
  Map<String, String> requestHeaders = {
    "content-length": "18",
    "content-type": "application/json; charset=utf-8"
  };
  String body = '{"data":"world"}';
  Uint8List bodyBytes = Uint8List.fromList([
    123,
    34,
    100,
    97,
    116,
    97,
    34,
    58,
    34,
    119,
    111,
    114,
    108,
    100,
    34,
    125
  ]);
  String formattedBody = '''{
  "data": "world"
}''';
  Duration time = const Duration(milliseconds: 516);

  ResponseModel responseModel = ResponseModel(
      statusCode: statusCode,
      headers: headers,
      requestHeaders: requestHeaders,
      body: body,
      formattedBody: formattedBody,
      bodyBytes: bodyBytes,
      time: time);

  RequestModel requestModel = RequestModel(
      id: '1',
      method: HTTPVerb.post,
      url: 'api.foss42.com/case/lower',
      name: 'foss42 api',
      requestHeaders: const [
        NameValueModel(name: 'content-length', value: '18'),
        NameValueModel(
            name: 'content-type', value: 'application/json; charset=utf-8')
      ],
      requestBodyContentType: ContentType.json,
      requestBody: '''{
"text":"WORLD"
}''',
      responseStatus: 200,
      responseModel: responseModel);

  RequestModel requestModelDup = const RequestModel(
      id: '1',
      method: HTTPVerb.post,
      url: 'api.foss42.com/case/lower',
      name: 'foss42 api',
      requestHeaders: [
        NameValueModel(name: 'content-length', value: '18'),
        NameValueModel(
            name: 'content-type', value: 'application/json; charset=utf-8')
      ],
      requestBodyContentType: ContentType.json,
      requestBody: '''{
"text":"WORLD"
}''');

  RequestModel requestModelCopy = const RequestModel(
      id: '1',
      method: HTTPVerb.post,
      url: 'api.foss42.com/case/lower',
      name: 'foss42 api (copy)',
      requestHeaders: [
        NameValueModel(name: 'content-length', value: '18'),
        NameValueModel(
            name: 'content-type', value: 'application/json; charset=utf-8')
      ],
      requestBodyContentType: ContentType.json,
      requestBody: '''{
"text":"WORLD"
}''');

  Map<String, dynamic> requestModelAsJson = {
    "id": '1',
    "method": 'post',
    "url": 'api.foss42.com/case/lower',
    "name": 'foss42 api',
    'description': '',
    "requestHeaders": {
      'content-length': '18',
      'content-type': 'application/json; charset=utf-8'
    },
    'isHeaderEnabledList': null,
    'requestParams': null,
    'isParamEnabledList': null,
    "requestBodyContentType": 'json',
    "requestBody": '''{
"text":"WORLD"
}''',
    'requestFormDataList': null,
    'responseStatus': null,
    'message': null,
    'responseModel': null
  };
  test('Testing copyWith', () {
    final requestModelcopyWith = requestModel.copyWith(name: 'API foss42');
    expect(requestModelcopyWith.name, 'API foss42');
  });
  test('Testing duplicate', () {
    expect(requestModel.duplicate(id: '1'), requestModelCopy);
  });

  test('Testing toJson', () {
    expect(requestModelDup.toJson(), requestModelAsJson);
  });

  test('Testing fromJson', () {
    final modelFromJson = RequestModel.fromJson(requestModelAsJson);
    expect(modelFromJson, requestModelDup);
  });

  final requestModeDupString = [
    "Request Id: 1",
    "Request Method: post",
    "Request URL: api.foss42.com/case/lower",
    "Request Name: foss42 api",
    "Request Description: ",
    "Request Tab Index: 0",
    "Request Headers: [NameValueModel(name: content-length, value: 18), NameValueModel(name: content-type, value: application/json; charset=utf-8)]",
    "Enabled Headers: null",
    "Request Params: null",
    "Enabled Params: null",
    "Request Body Content Type: ContentType.json",
    'Request Body: {\n"text":"WORLD"\n}',
    'Request FormData: null',
    "Response Status: null",
    "Response Message: null",
    "Response: null"
  ].join("\n");
  test('Testing toString', () {
    expect(requestModelDup.toString(), requestModeDupString);
  });

  test('Testing getters', () {
    expect(requestModel.enabledRequestHeaders, const [
      NameValueModel(name: 'content-length', value: '18'),
      NameValueModel(
          name: 'content-type', value: 'application/json; charset=utf-8')
    ]);
    expect(requestModel.enabledRequestParams, null);
    expect(requestModel.enabledHeadersMap, {
      'content-length': '18',
      'content-type': 'application/json; charset=utf-8'
    });
    expect(requestModel.enabledParamsMap, {});
    expect(requestModel.headersMap, {
      'content-length': '18',
      'content-type': 'application/json; charset=utf-8'
    });
    expect(requestModel.paramsMap, {});
    expect(requestModel.formDataMapList, []);
    expect(requestModel.isFormDataRequest, false);
    expect(requestModel.hasContentTypeHeader, true);
  });

  test('Testing hashcode', () {
    expect(requestModel.hashCode, greaterThan(0));
  });
}
