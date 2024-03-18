import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:apidash/models/response_model.dart';
import 'package:http/http.dart' as http;

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

  Map<String, dynamic> responseModelJson = {
    "statusCode": statusCode,
    "headers": headers,
    "requestHeaders": requestHeaders,
    "body": body,
    "bodyBytes": bodyBytes,
    "time": 516000,
  };

  String responseModelStringExpected = [
    "Response Status: 200",
    "Response Time: 0:00:00.516000",
    "Response Headers: {content-length: 16, x-cloud-trace-context: dad62aaf7f640300bbf629f4ae2f2f63, content-type: application/json, date: Sun, 23 Apr 2023 23:46:31 GMT, server: Google Frontend}",
    "Response Request Headers: {content-length: 18, content-type: application/json; charset=utf-8}",
    'Response Body: {"data":"world"}',
  ].join("\n");

  test('Testing toJSON', () {
    expect(responseModel.toJson(), responseModelJson);
  });

  test('Testing toString', () {
    expect(responseModel.toString(), responseModelStringExpected);
  });

  test('Testing fromJson', () {
    final responseModelData = ResponseModel.fromJson(responseModelJson);
    expect(responseModelData, responseModel);
  });

  test('Testing fromResponse', () async {
    final response = await http.get(
      Uri.parse('https://api.apidash.dev/'),
    );
    final responseData = responseModel.fromResponse(response: response);
    expect(responseData.statusCode, 200);
    expect(responseData.body,
        '{"data":"Check out https://api.apidash.dev/docs to get started."}');
    expect(responseData.formattedBody, '''{
  "data": "Check out https://api.apidash.dev/docs to get started."
}''');
  });
  test('Testing fromResponse for contentType not Json', () async {
    final response = await http.get(
      Uri.parse('https://apidash.dev/'),
    );
    final responseData = responseModel.fromResponse(response: response);
    expect(responseData.statusCode, 200);
    expect(responseData.body!.length, greaterThan(1000));
    expect(responseData.contentType, 'text/html; charset=utf-8');
    expect(responseData.mediaType!.mimeType, 'text/html');
  });
  test('Testing hashcode', () {
    expect(responseModel.hashCode, greaterThan(0));
  });
}
