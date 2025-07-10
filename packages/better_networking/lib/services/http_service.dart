import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:seed/seed.dart';
import '../consts.dart';
import '../extensions/extensions.dart';
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
  if (httpClientManager.wasRequestCancelled(requestId)) {
    httpClientManager.removeCancelledRequest(requestId);
  }
  final client = httpClientManager.createClient(requestId, noSSL: noSSL);

  (Uri?, String?) uriRec = getValidRequestUri(
    requestModel.url,
    requestModel.enabledParams,
    defaultUriScheme: defaultUriScheme,
  );

  if (uriRec.$1 != null) {
    Uri requestUrl = uriRec.$1!;
    Map<String, String> headers = requestModel.enabledHeadersMap;
    bool overrideContentType = false;
    HttpResponse? response;
    String? body;
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      if (apiType == APIType.rest) {
        var isMultiPartRequest =
            requestModel.bodyContentType == ContentType.formdata;

        if (kMethodsWithBody.contains(requestModel.method)) {
          var requestBody = requestModel.body;
          if (requestBody != null &&
              !isMultiPartRequest &&
              requestBody.isNotEmpty) {
            body = requestBody;
            if (requestModel.hasContentTypeHeader) {
              overrideContentType = true;
            } else {
              headers[HttpHeaders.contentTypeHeader] =
                  requestModel.bodyContentType.header;
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
            http.StreamedResponse multiPartResponse = await client.send(
              multiPartRequest,
            );

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
          case HTTPVerb.put:
          case HTTPVerb.patch:
          case HTTPVerb.delete:
          case HTTPVerb.options:
            final request = prepareHttpRequest(
              url: requestUrl,
              method: requestModel.method.name.toUpperCase(),
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
        response = await client.post(requestUrl, headers: headers, body: body);
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
    request.headers[HttpHeaders.contentTypeHeader] = headers
        .getValueContentType()!;
    if (!overrideContentType) {
      headers.removeKeyContentType();
    }
  }
  if (body != null) {
    request.body = body;
    headers[HttpHeaders.contentLengthHeader] = request.bodyBytes.length
        .toString();
  }
  request.headers.addAll(headers);
  return request;
}

Future<Stream<(String?, Duration?, String?)?>> streamHttpRequest(
  String requestId,
  APIType apiType,
  HttpRequestModel requestModel, {
  SupportedUriSchemes defaultUriScheme = kDefaultUriScheme,
  bool noSSL = false,
}) async {
  final controller = StreamController<(String?, Duration?, String?)?>();
  StreamSubscription<String?>? subscription;
  final stopwatch = Stopwatch()..start();

  cleanup() async {
    stopwatch.stop();
    httpClientManager.closeClient(requestId);
    await Future.microtask(() {});
    controller.close();
  }

  Future<void> handleError(dynamic error) async {
    await Future.microtask(() {});
    if (httpClientManager.wasRequestCancelled(requestId)) {
      controller.add((null, null, kMsgRequestCancelled));
      httpClientManager.removeCancelledRequest(requestId);
    } else {
      controller.add((null, null, error.toString()));
    }
    await cleanup();
  }

  controller.onCancel = () async {
    await subscription?.cancel();
    httpClientManager.cancelRequest(requestId);
  };

  if (httpClientManager.wasRequestCancelled(requestId)) {
    controller.add((null, null, kMsgRequestCancelled));
    httpClientManager.removeCancelledRequest(requestId);
    controller.close();
    return controller.stream;
  }

  final client = httpClientManager.createClient(requestId, noSSL: noSSL);
  final (uri, uriError) = getValidRequestUri(
    requestModel.url,
    requestModel.enabledParams,
    defaultUriScheme: defaultUriScheme,
  );

  if (uri == null) {
    await handleError(uriError ?? 'Invalid URL');
    return controller.stream;
  }

  final headers = requestModel.enabledHeadersMap;
  final hasBody = kMethodsWithBody.contains(requestModel.method);
  final isMultipart = requestModel.bodyContentType == ContentType.formdata;

  try {
    //HANDLE MULTI-PART
    if (apiType == APIType.rest && isMultipart && hasBody) {
      final multipart = http.MultipartRequest(
        requestModel.method.name.toUpperCase(),
        uri,
      )..headers.addAll(headers);

      for (final data in requestModel.formDataList) {
        if (data.type == FormDataType.text) {
          multipart.fields[data.name] = data.value;
        } else {
          multipart.files.add(
            await http.MultipartFile.fromPath(data.name, data.value),
          );
        }
      }

      final streamedResponse = await client.send(multipart);
      final stream = streamTextResponse(streamedResponse);

      subscription = stream.listen(
        (data) => controller.add((data, stopwatch.elapsed, null)),
        onDone: () => cleanup(),
        onError: handleError,
      );

      return controller.stream;
    }

    String? body;
    bool overrideContentType = false;

    if (hasBody && requestModel.body?.isNotEmpty == true) {
      body = requestModel.body;
      if (!requestModel.hasContentTypeHeader) {
        headers[HttpHeaders.contentTypeHeader] =
            requestModel.bodyContentType.header;
      } else {
        overrideContentType = true;
      }
    }

    final request = prepareHttpRequest(
      url: uri,
      method: requestModel.method.name.toUpperCase(),
      headers: headers,
      body: body,
      overrideContentType: overrideContentType,
    );

    final streamedResponse = await client.send(request);
    final stream = streamTextResponse(streamedResponse);

    subscription = stream.listen(
      (data) {
        if (!controller.isClosed) {
          controller.add((data, stopwatch.elapsed, null));
        }
      },
      onDone: () => cleanup(),
      onError: handleError,
    );

    return controller.stream;
  } catch (e) {
    await handleError(e);
    return controller.stream;
  }
}
