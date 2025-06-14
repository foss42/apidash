import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:seed/seed.dart';
import '../consts.dart';
import '../extensions/extensions.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import '../utils/handle_auth.dart';
import 'http_client_manager.dart';

typedef HttpResponse = http.Response;

final httpClientManager = HttpClientManager();

Future<(HttpResponse?, Duration?, String?)> sendHttpRequest(
  String requestId,
  APIType apiType,
  ApiAuthModel? authData,
  HttpRequestModel requestModel, {
  SupportedUriSchemes defaultUriScheme = kDefaultUriScheme,
  bool noSSL = false,
}) async {
  if (httpClientManager.wasRequestCancelled(requestId)) {
    httpClientManager.removeCancelledRequest(requestId);
  }
  final client = httpClientManager.createClient(requestId, noSSL: noSSL);

  // Handle authentication
  final authenticatedRequestModel = handleAuth(requestModel, authData);

  (Uri?, String?) uriRec = getValidRequestUri(
    authenticatedRequestModel.url,
    authenticatedRequestModel.enabledParams,
    defaultUriScheme: defaultUriScheme,
  );

  if (uriRec.$1 != null) {
    Uri requestUrl = uriRec.$1!;
    Map<String, String> headers = authenticatedRequestModel.enabledHeadersMap;
    bool overrideContentType = false;
    HttpResponse? response;
    String? body;
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      if (apiType == APIType.rest) {
        var isMultiPartRequest =
            requestModel.bodyContentType == ContentType.formdata;

        if (kMethodsWithBody.contains(authenticatedRequestModel.method)) {
          var requestBody = authenticatedRequestModel.body;
          if (requestBody != null &&
              !isMultiPartRequest &&
              requestBody.isNotEmpty) {
            body = requestBody;
            if (authenticatedRequestModel.hasContentTypeHeader) {
              overrideContentType = true;
            } else {
              headers[HttpHeaders.contentTypeHeader] =
                  authenticatedRequestModel.bodyContentType.header;
            }
          }
          if (isMultiPartRequest) {
            var multiPartRequest = http.MultipartRequest(
              authenticatedRequestModel.method.name.toUpperCase(),
              requestUrl,
            );
            multiPartRequest.headers.addAll(headers);
            for (var formData in authenticatedRequestModel.formDataList) {
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
                await client.send(multiPartRequest);

            stopwatch.stop();
            http.Response convertedMultiPartResponse =
                await convertStreamedResponse(multiPartResponse);
            return (convertedMultiPartResponse, stopwatch.elapsed, null);
          }
        }
        switch (authenticatedRequestModel.method) {
          case HTTPVerb.get:
            response = await client.get(requestUrl, headers: headers);
            break;
          case HTTPVerb.head:
            response = await client.head(requestUrl, headers: headers);
            break;
          case HTTPVerb.post:
          case HTTPVerb.put:
          case HTTPVerb.patch:
          case HTTPVerb.delete:
          case HTTPVerb.options:
            final request = prepareHttpRequest(
              url: requestUrl,
              method: authenticatedRequestModel.method.name.toUpperCase(),
              headers: headers,
              body: body,
              overrideContentType: overrideContentType,
            );
            final streamed = await client.send(request);
            response = await http.Response.fromStream(streamed);
            break;
        }
      }
      if (apiType == APIType.graphql) {
        var requestBody = getGraphQLBody(authenticatedRequestModel);
        if (requestBody != null) {
          var contentLength = utf8.encode(requestBody).length;
          if (contentLength > 0) {
            body = requestBody;
            headers[HttpHeaders.contentLengthHeader] = contentLength.toString();
            if (!authenticatedRequestModel.hasContentTypeHeader) {
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
      if (httpClientManager.wasRequestCancelled(requestId)) {
        return (null, null, kMsgRequestCancelled);
      }
      return (null, null, e.toString());
    } finally {
      httpClientManager.closeClient(requestId);
    }
  } else {
    return (null, null, uriRec.$2);
  }
}

void cancelHttpRequest(String? requestId) {
  httpClientManager.cancelRequest(requestId);
}

http.Request prepareHttpRequest({
  required Uri url,
  required String method,
  required Map<String, String> headers,
  required String? body,
  bool overrideContentType = false,
}) {
  var request = http.Request(method, url);
  if (headers.getValueContentType() != null) {
    request.headers[HttpHeaders.contentTypeHeader] =
        headers.getValueContentType()!;
    if (!overrideContentType) {
      headers.removeKeyContentType();
    }
  }
  if (body != null) {
    request.body = body;
    headers[HttpHeaders.contentLengthHeader] =
        request.bodyBytes.length.toString();
  }
  request.headers.addAll(headers);
  return request;
}
