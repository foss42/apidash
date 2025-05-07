import 'dart:typed_data';
import 'package:apidash_core/apidash_core.dart';

const int statusCode = 200;
const Map<String, String> headers = {
  "content-length": "16",
  "x-cloud-trace-context": "dad62aaf7f640300bbf629f4ae2f2f63",
  "content-type": "application/json",
  "date": "Sun, 23 Apr 2023 23:46:31 GMT",
  "server": "Google Frontend"
};

const Map<String, String> requestHeaders = {
  "content-length": "18",
  "content-type": "application/json; charset=utf-8"
};

const String body = '{"data":"world"}';
Uint8List bodyBytes = Uint8List.fromList(
    [123, 34, 100, 97, 116, 97, 34, 58, 34, 119, 111, 114, 108, 100, 34, 125]);
const String formattedBody = '''{
  "data": "world"
}''';
const Duration time = Duration(milliseconds: 516);

HttpResponseModel responseModel = HttpResponseModel(
  statusCode: statusCode,
  headers: headers,
  requestHeaders: requestHeaders,
  body: body,
  formattedBody: formattedBody,
  bodyBytes: bodyBytes,
  time: time,
);

Map<String, dynamic> responseModelJson = {
  "statusCode": statusCode,
  "headers": headers,
  "requestHeaders": requestHeaders,
  "body": body,
  "formattedBody": formattedBody,
  "bodyBytes": bodyBytes,
  "time": 516000,
};
