import 'dart:async';
import 'dart:io';

import 'package:apidash_core/apidash_core.dart' as http;
import 'package:dio/dio.dart';
import 'package:seed/seed.dart';

import '../consts.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'http_client_manager.dart';

typedef DioHttpResponse = Response; // from dio
typedef HttpHttpResponse = http.Response; // from http

final httpClientManager = HttpClientManager();

Future<(Response?, Duration?, String?)> sendHttpRequest(
  String requestId,
  APIType apiType,
  HttpRequestModel requestModel, {
  SupportedUriSchemes defaultUriScheme = kDefaultUriScheme,
  bool noSSL = false,
}) async {
  if (httpClientManager.wasRequestCancelled(requestId)) {
    httpClientManager.removeCancelledRequest(requestId);
  }

  final dio = httpClientManager.createClient(requestId, noSSL: noSSL);
  final cancelToken = httpClientManager.getCancelToken(requestId);

  final (uri, uriError) = getValidRequestUri(
    requestModel.url,
    requestModel.enabledParams,
    defaultUriScheme: defaultUriScheme,
  );

  if (uri == null) return (null, null, uriError);

  try {
    final headers = requestModel.enabledHeadersMap;
    final stopwatch = Stopwatch()..start();
    Response? response;

    final isMultiPartRequest =
        requestModel.bodyContentType == ContentType.formdata;

    if (!requestModel.hasContentTypeHeader) {
      headers[HttpHeaders.contentTypeHeader] =
          requestModel.bodyContentType.header;
    }

    if (apiType == APIType.rest) {
      if (kMethodsWithBody.contains(requestModel.method)) {
        if (isMultiPartRequest) {
          final formData = FormData();

          for (var formField in requestModel.formDataList) {
            if (formField.type == FormDataType.text) {
              formData.fields.add(MapEntry(formField.name, formField.value));
            } else {
              formData.files.add(
                MapEntry(
                  formField.name,
                  await MultipartFile.fromFile(formField.value),
                ),
              );
            }
          }

          response = await dio.request(
            uri.toString(),
            data: formData,
            options: Options(
              method: requestModel.method.name.toUpperCase(),
              headers: headers,
            ),
            cancelToken: cancelToken,
          );
        } else {
          final body = requestModel.body ?? '';
          response = await dio.request(
            uri.toString(),
            data: body,
            options: Options(
              method: requestModel.method.name.toUpperCase(),
              headers: headers,
            ),
            cancelToken: cancelToken,
          );
        }
      } else {
        response = await dio.request(
          uri.toString(),
          options: Options(
            method: requestModel.method.name.toUpperCase(),
            headers: headers,
          ),
          cancelToken: cancelToken,
        );
      }
    }

    if (apiType == APIType.graphql) {
      final body = getGraphQLBody(requestModel);
      if (body != null) {
        headers[HttpHeaders.contentTypeHeader] = ContentType.json.header;
        response = await dio.post(
          uri.toString(),
          data: body,
          options: Options(headers: headers),
          cancelToken: cancelToken,
        );
      }
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
}

void cancelHttpRequest(String? requestId) {
  httpClientManager.cancelRequest(requestId);
}
