import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:apidash/utils/utils.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';

Future<(http.Response?, Duration?, String?)> request(
  RequestModel requestModel,
  SettingsModel settingsModel, // Pass SettingsModel instance
  {
  String defaultUriScheme = kDefaultUriScheme,
}) async {
  (Uri?, String?) uriRec = getValidRequestUri(
    requestModel.url,
    requestModel.enabledRequestParams,
    defaultUriScheme: defaultUriScheme,
  );
  if (uriRec.$1 != null) {
    Uri requestUrl = uriRec.$1!;
    Map<String, String> headers = requestModel.enabledHeadersMap;
    http.Response response;
    String? body;
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      var isMultiPartRequest =
          requestModel.requestBodyContentType == ContentType.formdata;
      if (kMethodsWithBody.contains(requestModel.method)) {
        var requestBody = requestModel.requestBody;
        if (requestBody != null && !isMultiPartRequest) {
          var contentLength = utf8.encode(requestBody).length;
          if (contentLength > 0) {
            body = requestBody;
            headers[HttpHeaders.contentLengthHeader] = contentLength.toString();
            if (!requestModel.hasContentTypeHeader) {
              headers[HttpHeaders.contentTypeHeader] =
                  requestModel.requestBodyContentType.header;
            }
          }
        }
        if (isMultiPartRequest) {
          var multiPartRequest = http.MultipartRequest(
            requestModel.method.name.toUpperCase(),
            requestUrl,
          );
          multiPartRequest.headers.addAll(headers);
          for (var formData
              in (requestModel.requestFormDataList ?? <FormDataModel>[])) {
            if (formData.type == FormDataType.text) {
              multiPartRequest.fields.addAll({formData.name: formData.value});
            } else {
              multiPartRequest.files.add(
                await http.MultipartFile.fromPath(
                  formData.name,
                  formData.value,
                ),
              );
            }
          }
          http.StreamedResponse multiPartResponse = await multiPartRequest
              .send()
              .timeout(Duration(
                  milliseconds: settingsModel.connectionTimeout ??
                      30));
          stopwatch.stop();
          http.Response convertedMultiPartResponse =
              await convertStreamedResponse(multiPartResponse);
          return (convertedMultiPartResponse, stopwatch.elapsed, null);
        }
      }
      switch (requestModel.method) {
        case HTTPVerb.get:
          response = await http.get(requestUrl, headers: headers).timeout(
              Duration(
                  milliseconds: settingsModel.connectionTimeout ??
                      30));
          break;
        case HTTPVerb.head:
          response = await http.head(requestUrl, headers: headers).timeout(
              Duration(
                  milliseconds: settingsModel.connectionTimeout ??
                      30));
          break;
        case HTTPVerb.post:
          response = await http
              .post(requestUrl, headers: headers, body: body)
              .timeout(Duration(
                  milliseconds: settingsModel.connectionTimeout ??
                      30));
          break;
        case HTTPVerb.put:
          response = await http
              .put(requestUrl, headers: headers, body: body)
              .timeout(Duration(
                  milliseconds: settingsModel.connectionTimeout ??
                      30));
          break;
        case HTTPVerb.patch:
          response = await http
              .patch(requestUrl, headers: headers, body: body)
              .timeout(Duration(
                  milliseconds: settingsModel.connectionTimeout ??
                      30)); 
          break;
        case HTTPVerb.delete:
          response = await http
              .delete(requestUrl, headers: headers, body: body)
              .timeout(Duration(
                  milliseconds: settingsModel.connectionTimeout ??
                      30));
          break;
      }
      stopwatch.stop();
      return (response, stopwatch.elapsed, null);
    } on TimeoutException catch (e) {
      return (null, null, 'Connection timed out: $e');
    } catch (e) {
      return (null, null, e.toString());
    }
  } else {
    return (null, null, uriRec.$2);
  }
}
