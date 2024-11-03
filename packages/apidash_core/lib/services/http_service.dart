import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../consts.dart';
import '../models/models.dart';
import '../utils/utils.dart';

typedef HttpResponse = http.Response;

Future<(HttpResponse?, Duration?, String?)> request(
  HttpRequestModel requestModel, {
  String defaultUriScheme = kDefaultUriScheme,
}) async {
  (Uri?, String?) uriRec = getValidRequestUri(
    requestModel.url,
    requestModel.enabledParams,
    defaultUriScheme: defaultUriScheme,
  );
  if (uriRec.$1 != null) {
    Uri requestUrl = uriRec.$1!;
    Map<String, String> headers = requestModel.enabledHeadersMap;
    HttpResponse response;
    String? body;
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      var isMultiPartRequest =
          requestModel.bodyContentType == ContentType.formdata;
      if (kMethodsWithBody.contains(requestModel.method)) {
        var requestBody = requestModel.body;
        if (requestBody != null && !isMultiPartRequest) {
          var contentLength = utf8.encode(requestBody).length;
          if (contentLength > 0) {
            body = requestBody;
            headers[HttpHeaders.contentLengthHeader] = contentLength.toString();
            if (!requestModel.hasContentTypeHeader) {
              headers[HttpHeaders.contentTypeHeader] =
                  requestModel.bodyContentType.header;
            }
          }
        }
        if (isMultiPartRequest) {
          var multiPartRequest = http.MultipartRequest(
            requestModel.method.name.toUpperCase(),
            requestUrl,
          );
          multiPartRequest.headers.addAll(headers);
          for (var formData in requestModel.formDataList) {
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
