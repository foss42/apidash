import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;
import 'package:seed/seed.dart';
import '../consts.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'dio_client_manager.dart' as dio1;

typedef HttpResponse = http.Response;

final httpClientManager = dio1.HttpClientManager();

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
    HttpResponse? response;
    String? body;
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      if (apiType == APIType.rest) {
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
            http.StreamedResponse multiPartResponse =
                await client.send(multiPartRequest);

            stopwatch.stop();
            http.Response convertedMultiPartResponse =
                await convertStreamedResponse(multiPartResponse);
            return (convertedMultiPartResponse, stopwatch.elapsed, null);
          }
        }
<<<<<<< HEAD
        switch (requestModel.method) {
          case HTTPVerb.get:
            var dioResponse = await client.get(requestUrl.toString(), options: dio.Options(headers: headers));
            response=await convertDioToHttpResponse(dioResponse);
            break;
          case HTTPVerb.head:
            var dioResponse = await client.head(requestUrl.toString(), options: dio.Options(headers: headers));
            response=await convertDioToHttpResponse(dioResponse);
            break;
          case HTTPVerb.post:
            try {
              // Define Dio options for the request
              final dioOptions = dio.Options(
                method: 'POST',
                headers: headers,
                responseType: dio.ResponseType.json,   // Can be changed based on requirement (json, bytes, stream, plain)
                contentType: 'application/json',       // Default content type for POST
                followRedirects: true,                 // Allows automatic following of redirects
                receiveDataWhenStatusError: true,      // Allows data reception even on error status codes
                maxRedirects: 5,                       // Maximum number of redirects
                persistentConnection: true,            // Persistent HTTP connection
                sendTimeout: const Duration(seconds: 30),  // Timeout for sending data
                receiveTimeout: const Duration(seconds: 30), // Timeout for receiving data
                validateStatus: (status) => status != null && status >= 200 && status < 300,
              );

              // Making a POST request using Dio client
              var dioResponse = await client.post(
                requestUrl.toString(),
                data: body,
                options: dioOptions,
                onSendProgress: (count, total) {
                  print('Progress: $count / $total bytes sent');
                },
                onReceiveProgress: (count, total) {
                  print('Progress: $count / $total bytes received');
                },
              );

              // Converting Dio response to http.Response using the helper function
              response = await convertDioToHttpResponse(dioResponse);

              // Logging the response for debugging
              print('HTTP Response Status: ${response.statusCode}');
              print('HTTP Response Headers: ${response.headers}');
              print('HTTP Response Body: ${response.body}');
            } on dio.DioError catch (e) {
              // Handling Dio exceptions and extracting the response if available
              if (e.response != null) {
                print('DioError: ${e.message}');
                print('Error Response: ${e.response?.data}');
                print('Error Headers: ${e.response?.headers}');
                
                response = await convertDioToHttpResponse(
                  e.response!,
                );
              } else {
                // Re-throw if there's no response at all (network failure, timeout, etc.)
                print('Request failed with no response: ${e.message}');
                rethrow;
              }
            }
            break;

          case HTTPVerb.put:
            var dioResponse = await client.put(requestUrl.toString(), data: body, options: dio.Options(headers: headers));
            response=await convertDioToHttpResponse(dioResponse);
            break;
          case HTTPVerb.patch:
            var dioResponse = await client.patch(requestUrl.toString(), data: body, options: dio.Options(headers: headers));
            response=await convertDioToHttpResponse(dioResponse);
            break;
          case HTTPVerb.delete:
            var dioResponse = await client.delete(requestUrl.toString(), data: body, options: dio.Options(headers: headers));
            response=await convertDioToHttpResponse(dioResponse);
            break;
        }
=======
        response = switch (requestModel.method) {
          HTTPVerb.get => await client.get(requestUrl, headers: headers),
          HTTPVerb.head => response =
              await client.head(requestUrl, headers: headers),
          HTTPVerb.post => response =
              await client.post(requestUrl, headers: headers, body: body),
          HTTPVerb.put => response =
              await client.put(requestUrl, headers: headers, body: body),
          HTTPVerb.patch => response =
              await client.patch(requestUrl, headers: headers, body: body),
          HTTPVerb.delete => response =
              await client.delete(requestUrl, headers: headers, body: body),
        };
>>>>>>> 440f9fbdec10eb1524e8934c4ad2b54413692301
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
        var dioResponse = await client.post(
          requestUrl.toString(),
          data: body,
          options: dio.Options(headers: headers),
        );
        response=await convertDioToHttpResponse(dioResponse);
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