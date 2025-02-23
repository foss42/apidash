import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:seed/seed.dart';
import '../consts.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'http_client_manager.dart';

typedef HttpResponse = http.Response;

final httpClientManager = HttpClientManager();

Future<(HttpResponse?, Duration?, String?)> sendHttpRequest(
  String requestId,
  APIType apiType,
  HttpRequestModel requestModel, {
  SupportedUriSchemes defaultUriScheme = kDefaultUriScheme,
  bool noSSL = false,
}) async {
  print("entered send http  request");
  final client = httpClientManager.createClient(requestId, noSSL: noSSL);

  (Uri?, String?) uriRec = getValidRequestUri(
    requestModel.url,
    requestModel.enabledParams,
    defaultUriScheme: defaultUriScheme,
  );

  if (uriRec.$1 != null) {
    Uri requestUrl = uriRec.$1!;
    Map<String, String> headers = requestModel.enabledHeadersMap;
    HttpResponse? response;
    String? body;
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      if (apiType == APIType.rest) {
        print("entered into rest");
        var isMultiPartRequest =
            requestModel.bodyContentType == ContentType.formdata;

        if (kMethodsWithBody.contains(requestModel.method)) {
          var requestBody = requestModel.body;
          if (requestBody != null && !isMultiPartRequest) {
            var contentLength = utf8.encode(requestBody).length;
            if (contentLength > 0) {
              body = requestBody;
              headers[HttpHeaders.contentLengthHeader] =
                  contentLength.toString();
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
            print("Just before multipart request");
            http.StreamedResponse multiPartResponse =
                await multiPartRequest.send();
            print("Just after mutipart request");
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
            print("entered into post");
            response =
                await client.post(requestUrl, headers: headers, body: body);
            print("Response ${response.toString()}");
            break;
          case HTTPVerb.put:
            response =
                await client.put(requestUrl, headers: headers, body: body);
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
      }
      if (apiType == APIType.graphql) {
        var requestBody = getGraphQLBody(requestModel);
        if (requestBody != null) {
          var contentLength = utf8.encode(requestBody).length;
          if (contentLength > 0) {
            body = requestBody;
            headers[HttpHeaders.contentLengthHeader] = contentLength.toString();
            if (!requestModel.hasContentTypeHeader) {
              headers[HttpHeaders.contentTypeHeader] = ContentType.json.header;
            }
          }
        }
        response = await client.post(
          requestUrl,
          headers: headers,
          body: body,
        );
      }
      stopwatch.stop();
      
      return (response, stopwatch.elapsed, null);
    } catch (e) {
      print("Inside error of sendHttpRequest");
      if (httpClientManager.wasRequestCancelled(requestId)) {
        return (null, null, kMsgRequestCancelled);
      }
      return (null, null, e.toString());
    } finally {
      print("entered into finally");
      httpClientManager.closeClient(requestId);
    }
  } else {
    return (null, null, uriRec.$2);
  }
}

void cancelHttpRequest(String? requestId) {
  print("inside cancelHttpRequest");
  httpClientManager.cancelRequest(requestId);
}
