// dio_request_helper.dart
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:seed/seed.dart';

import '../consts.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'dio_client_manager.dart';   // ⬅️ NEW  (the class you shared earlier)

typedef DioResponse = Response<dynamic>;

final dioClientManager = DioClientManager();

/// Replaces `sendHttpRequest`.  Returns:
/// (response, latency, errorMessage)   –  errorMessage is **null** on success.
Future<(DioResponse?, Duration?, String?)> sendDioRequest(
  String requestId,
  APIType apiType,
  HttpRequestModel requestModel, {
  SupportedUriSchemes defaultUriScheme = kDefaultUriScheme,
  bool noSSL = false,
}) async {
  final dio = dioClientManager.createDioClient(requestId, noSSL: noSSL);
  final cancelToken = dioClientManager.getCancelToken(requestId);

  final (uri, uriErr) = getValidRequestUri(
    requestModel.url,
    requestModel.enabledParams,
    defaultUriScheme: defaultUriScheme,
  );
  if (uri == null) return (null, null, uriErr);

  final headers = <String, dynamic>{}..addAll(requestModel.enabledHeadersMap);
  String? rawBody;

  dynamic data;
  Options? options;
  if (apiType == APIType.rest) {
    final isMultipart = requestModel.bodyContentType == ContentType.formdata;

    if (kMethodsWithBody.contains(requestModel.method)) {
      if (isMultipart) {
        // Build multipart/form‑data using Dio's FormData
        final form = FormData();
        for (final field in requestModel.formDataList) {
          if (field.type == FormDataType.text) {
            form.fields.add(MapEntry(field.name, field.value));
          } else {
            form.files.add(
              MapEntry(
                field.name,
                await MultipartFile.fromFile(field.value),
              ),
            );
          }
        }
        data = form;
      } else if (requestModel.body != null) {
        rawBody = requestModel.body!;
        data = rawBody;
        if (!requestModel.hasContentTypeHeader) {
          headers[HttpHeaders.contentTypeHeader] =
              requestModel.bodyContentType.header;
        }
        headers[HttpHeaders.contentLengthHeader] =
            utf8.encode(rawBody).length.toString();
      }
    }

    options = Options(headers: headers, responseType: ResponseType.bytes);
  }

  if (apiType == APIType.graphql) {
    final graphQLBody = getGraphQLBody(requestModel);
    if (graphQLBody != null) {
      rawBody = graphQLBody;
      data = rawBody;

      if (!requestModel.hasContentTypeHeader) {
        headers[HttpHeaders.contentTypeHeader] = ContentType.json.header;
      }
      headers[HttpHeaders.contentLengthHeader] =
          utf8.encode(rawBody).length.toString();
    }
    options = Options(headers: headers, responseType: ResponseType.bytes);
  }

  final stopwatch = Stopwatch()..start();
  try {
    DioResponse response;

    switch (requestModel.method) {
      case HTTPVerb.get:
        response = await dio.getUri(uri, options: options, cancelToken: cancelToken);
        break;
      case HTTPVerb.head:
        response = await dio.headUri(uri, options: options, cancelToken: cancelToken);
        break;
      case HTTPVerb.post:
        response = await dio.postUri(uri, data: data, options: options, cancelToken: cancelToken);
        break;
      case HTTPVerb.put:
        response = await dio.putUri(uri, data: data, options: options, cancelToken: cancelToken);
        break;
      case HTTPVerb.patch:
        response = await dio.patchUri(uri, data: data, options: options, cancelToken: cancelToken);
        break;
      case HTTPVerb.delete:
        response = await dio.deleteUri(uri, data: data, options: options, cancelToken: cancelToken);
        break;
    }

    stopwatch.stop();
    return (response, stopwatch.elapsed, null);
  } on DioException catch (e) {
    // Cancelled by user?
    if (dioClientManager.wasRequestCancelled(requestId)) {
      return (null, null, kMsgRequestCancelled);
    }
    return (e.response, null, e.message);
  } catch (e) {
    return (null, null, e.toString());
  } finally {
    dioClientManager.cancelRequest(requestId); // cleans token + adapter resources
  }
}

/// Exposed for UI / caller.
void cancelDioRequest(String? requestId) => dioClientManager.cancelRequest(requestId);
