import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:apidash/utils/utils.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';

Future<(http.Response?, Duration?, String?)> request(
  RequestModel requestModel, {
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
    Object? body;
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      var isMultiPartRequest =
          requestModel.requestBodyContentType == ContentType.formdata;
      if (kMethodsWithBody.contains(requestModel.method)) {
        var requestBody = requestModel.requestBody;
        var requestFile = (requestModel.requestFile != null &&
                requestModel.requestFile!.isNotEmpty)
            ? File(requestModel.requestFile!)
            : null;
        if ((requestBody != null || requestFile != null) &&
            !isMultiPartRequest) {
          var requestFileBytes =
              requestBody == null ? await requestFile!.readAsBytes() : null;

          var contentLength = requestBody != null
              ? utf8.encode(requestBody).length
              : requestFileBytes!.length;

          if (contentLength > 0) {
            body = requestBody ?? requestFileBytes;
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
          http.StreamedResponse multiPartResponse =
              await multiPartRequest.send();
          stopwatch.stop();
          http.Response convertedMultiPartResponse =
              await convertStreamedResponse(multiPartResponse);
          return (convertedMultiPartResponse, stopwatch.elapsed, null);
        }
      }
      switch (requestModel.method) {
        case HTTPVerb.get:
          response = await http.get(requestUrl, headers: headers);
          break;
        case HTTPVerb.head:
          response = await http.head(requestUrl, headers: headers);
          break;
        case HTTPVerb.post:
          response = await http.post(requestUrl, headers: headers, body: body);
          break;
        case HTTPVerb.put:
          response = await http.put(requestUrl, headers: headers, body: body);
          break;
        case HTTPVerb.patch:
          response = await http.patch(requestUrl, headers: headers, body: body);
          break;
        case HTTPVerb.delete:
          response =
              await http.delete(requestUrl, headers: headers, body: body);
          break;
      }
      stopwatch.stop();
      return (response, stopwatch.elapsed, null);
    } catch (e) {
      return (null, null, e.toString());
    }
  } else {
    return (null, null, uriRec.$2);
  }
}
