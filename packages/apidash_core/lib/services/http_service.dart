import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:seed/seed.dart';
import '../consts.dart';
import '../models/models.dart';
import '../utils/utils.dart';

typedef HttpResponse = http.Response;

Future<(HttpResponse?, Duration?, String?)> request(
  HttpRequestModel requestModel, {
  String defaultUriScheme = kDefaultUriScheme,
  http.Client? client,
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
    bool shouldCloseClient = false;
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      if (client == null) {
        client = http.Client();
        shouldCloseClient = true;
      }
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
          response = await client.get(requestUrl, headers: headers);
          break;
        case HTTPVerb.head:
          response = await client.head(requestUrl, headers: headers);
          break;
        case HTTPVerb.post:
          response =
              await client.post(requestUrl, headers: headers, body: body);
          break;
        case HTTPVerb.put:
          response = await client.put(requestUrl, headers: headers, body: body);
          break;
        case HTTPVerb.patch:
          response =
              await client.patch(requestUrl, headers: headers, body: body);
          break;
        case HTTPVerb.delete:
          response =
              await client.delete(requestUrl, headers: headers, body: body);
          break;
      }
      stopwatch.stop();
      return (response, stopwatch.elapsed, null);
    } on http.ClientException catch (e) {
      if (e.message.contains('Connection closed') ||
          e.message.contains('abort')) {
        return (null, null, 'Request Cancelled');
      } else {
        return (null, null, e.toString());
      }
    } catch (e) {
      return (null, null, e.toString());
    } finally {
      if (shouldCloseClient) {
        client?.close();
      }
    }
  } else {
    return (null, null, uriRec.$2);
  }
}
