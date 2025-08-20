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

typedef HttpStreamOutput = (
  bool? streamOutput,
  HttpResponse? resp,
  Duration? dur,
  String? err,
)?;

final httpClientManager = HttpClientManager();

Future<(HttpResponse?, Duration?, String?)> sendHttpRequestV1(
  String requestId,
  APIType apiType,
  AuthModel? authData,
  HttpRequestModel requestModel, {
  SupportedUriSchemes defaultUriScheme = kDefaultUriScheme,
  bool noSSL = false,
}) async {
  if (httpClientManager.wasRequestCancelled(requestId)) {
    httpClientManager.removeCancelledRequest(requestId);
  }
  final client = httpClientManager.createClient(requestId, noSSL: noSSL);

  HttpRequestModel authenticatedRequestModel = requestModel.copyWith();

  try {
    if (authData != null && authData.type != APIAuthType.none) {
      authenticatedRequestModel = await handleAuth(requestModel, authData);
    }
  } catch (e) {
    return (null, null, e.toString());
  }

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
            http.StreamedResponse multiPartResponse = await client.send(
              multiPartRequest,
            );

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

Future<(HttpResponse?, Duration?, String?)> sendHttpRequest(
  String requestId,
  APIType apiType,
  HttpRequestModel requestModel, {
  SupportedUriSchemes defaultUriScheme = kDefaultUriScheme,
  bool noSSL = false,
}) async {
  final stream = await streamHttpRequest(
    requestId,
    apiType,
    requestModel,
    defaultUriScheme: defaultUriScheme,
    noSSL: noSSL,
  );
  final output = await stream.first;
  return (output?.$2, output?.$3, output?.$4);
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

Future<Stream<HttpStreamOutput>> streamHttpRequest(
  String requestId,
  APIType apiType,
  HttpRequestModel httpRequestModel, {
  SupportedUriSchemes defaultUriScheme = kDefaultUriScheme,
  bool noSSL = false,
}) async {
  final authData = httpRequestModel.authModel;
  final controller = StreamController<HttpStreamOutput>();
  StreamSubscription<List<int>?>? subscription;
  final stopwatch = Stopwatch()..start();

  Future<void> _cleanup() async {
    stopwatch.stop();
    await subscription?.cancel();
    httpClientManager.closeClient(requestId);
    await Future.microtask(() {});
    controller.close();
  }

  Future<void> _addCancelledMessage() async {
    if (!controller.isClosed) {
      controller.add((null, null, null, kMsgRequestCancelled));
    }
    httpClientManager.removeCancelledRequest(requestId);
    await _cleanup();
  }

  Future<void> _addErrorMessage(dynamic error) async {
    await Future.microtask(() {});
    if (httpClientManager.wasRequestCancelled(requestId)) {
      await _addCancelledMessage();
    } else {
      controller.add((null, null, null, error.toString()));
      await _cleanup();
    }
  }

  controller.onCancel = () async {
    await subscription?.cancel();
    httpClientManager.cancelRequest(requestId);
  };

  if (httpClientManager.wasRequestCancelled(requestId)) {
    await _addCancelledMessage();
    return controller.stream;
  }

  final client = httpClientManager.createClient(requestId, noSSL: noSSL);

  HttpRequestModel authenticatedHttpRequestModel = httpRequestModel.copyWith();

  try {
    if (authData != null && authData.type != APIAuthType.none) {
      authenticatedHttpRequestModel = await handleAuth(
        httpRequestModel,
        authData,
      );
    }
  } catch (e) {
    await _addErrorMessage(e.toString());
    return controller.stream;
  }

  final (uri, uriError) = getValidRequestUri(
    authenticatedHttpRequestModel.url,
    authenticatedHttpRequestModel.enabledParams,
    defaultUriScheme: defaultUriScheme,
  );

  if (uri == null) {
    await _addErrorMessage(uriError ?? 'Invalid URL');
    return controller.stream;
  }

  try {
    final streamedResponse = await makeStreamedRequest(
      client: client,
      uri: uri,
      requestModel: authenticatedHttpRequestModel,
      apiType: apiType,
    );

    HttpResponse _createResponseFromBytes(List<int> bytes) {
      return HttpResponse.bytes(
        bytes,
        streamedResponse.statusCode,
        request: streamedResponse.request,
        headers: streamedResponse.headers,
        isRedirect: streamedResponse.isRedirect,
        persistentConnection: streamedResponse.persistentConnection,
        reasonPhrase: streamedResponse.reasonPhrase,
      );
    }

    final contentType =
        getMediaTypeFromHeaders(streamedResponse.headers)?.mimeType ?? '';
    final chunkList = <List<int>>[];

    subscription = streamedResponse.stream.listen(
      (bytes) async {
        if (controller.isClosed) return;
        final isStreaming = kStreamingResponseTypes.contains(contentType);
        if (isStreaming) {
          final response = _createResponseFromBytes(bytes);
          controller.add((true, response, stopwatch.elapsed, null));
        } else {
          chunkList.add(bytes);
        }
      },
      onDone: () async {
        if (chunkList.isNotEmpty && !controller.isClosed) {
          final allBytes = chunkList.expand((x) => x).toList();
          final response = _createResponseFromBytes(allBytes);
          final isStreaming = kStreamingResponseTypes.contains(contentType);
          controller.add((isStreaming, response, stopwatch.elapsed, null));
          chunkList.clear();
        } else {
          final response = _createResponseFromBytes([]);
          controller.add((false, response, stopwatch.elapsed, null));
        }
        await _cleanup();
      },
      onError: _addErrorMessage,
    );
    return controller.stream;
  } catch (e) {
    await _addErrorMessage(e);
    return controller.stream;
  }
}

Future<http.StreamedResponse> makeStreamedRequest({
  required http.Client client,
  required Uri uri,
  required HttpRequestModel requestModel,
  required APIType apiType,
}) async {
  final headers = requestModel.enabledHeadersMap;
  final hasBody = kMethodsWithBody.contains(requestModel.method);
  final isMultipart = requestModel.bodyContentType == ContentType.formdata;

  http.StreamedResponse streamedResponse;

  //----------------- Request Creation ---------------------
  //Handling HTTP Multipart Requests
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
    streamedResponse = await client.send(multipart);
  } else if (apiType == APIType.graphql) {
    // Handling GraphQL Requests
    var requestBody = getGraphQLBody(requestModel);
    String? body;
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
    final request = http.Request('POST', uri)
      ..headers.addAll(headers)
      ..body = body ?? '';
    streamedResponse = await client.send(request);
  } else {
    //Handling regular REST Requests
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
    streamedResponse = await client.send(request);
  }
  return streamedResponse;
}
