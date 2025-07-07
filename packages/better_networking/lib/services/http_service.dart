// ignore_for_file: no_leading_underscores_for_local_identifiers

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

typedef HttpStreamOutput = (
  bool? streamOutput,
  HttpResponse? resp,
  Duration? dur,
  String? err,
)?;

Future<Stream<HttpStreamOutput>> streamHttpRequest(
  String requestId,
  APIType apiType,
  HttpRequestModel requestModel, {
  SupportedUriSchemes defaultUriScheme = kDefaultUriScheme,
  bool noSSL = false,
}) async {
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
  final (uri, uriError) = getValidRequestUri(
    requestModel.url,
    requestModel.enabledParams,
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
      requestModel: requestModel,
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
        streamedResponse.headers['content-type']?.toString() ?? '';
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
