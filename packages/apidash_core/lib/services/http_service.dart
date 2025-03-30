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
typedef StreamedResponse = http.StreamedResponse;

final httpClientManager = HttpClientManager();

Future<(HttpResponse?, Duration?, String?,StreamedResponse?)> sendHttpRequest(
  String requestId,
  APIType apiType,
  HttpRequestModel requestModel, {
  SupportedUriSchemes defaultUriScheme = kDefaultUriScheme,
  bool noSSL = false,
  Function(String event)? onData,
  Function(Object error, StackTrace stackTrace)? onError,
  Function()? onDone,
}) async {
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
        print("inside sse http serviec");
        // ✅ SSE Handling (POST, PUT, etc. with Body)
        var request = http.Request(requestModel.method.name.toUpperCase(), requestUrl);
        
        request.headers.addAll(headers);
        request.headers["Accept"] = "text/event-stream";
      request.headers["Cache-Control"] = "no-cache";
      request.headers["Connection"] = "keep-alive";
     
        if (body != null) request.body = body;

        http.StreamedResponse streamedResponse = await client.send(request);
        print("inside streamed response");
        final stream = streamedResponse.stream
      .transform(utf8.decoder)
      .transform(const LineSplitter());
        try{ stream.listen(
    (event) {
      onData?.call(event);
      if (event.isNotEmpty) {
        print('🔹 SSE Event Received: $event');
        print(event.toString());
      //   final parsedEvent = SSEEventModel.fromRawSSE(event);
      //   ref.read(sseFramesProvider.notifier).addFrame(requestId, parsedEvent);
       
      }
    },
    onError: (error) {
      (error, stackTrace) => onError?.call(error, stackTrace);
      print('🔹 SSE Error: $error');
      // ref.read(sseFramesProvider.notifier).update((state) {
      //   return {...state, requestId: [...(state[requestId] ?? []), 'Error: $error']};
      // });
      // finalizeRequestModel(requestId);
    },
    onDone: () {
      onDone?.call();
       print('🔹 SSE Stream Done');
   //   finalizeRequestModel(requestId);
    },
 );}catch (e, stackTrace) {
      print('🔹 Error connecting to SSE: $e');
      onError?.call(e, stackTrace);
      //_reconnect(onData, onError, onDone);
    }
      //   print("streamedResponse"+streamedResponse.headers.toString());
      //  // var buffer = await convertStreamedResponse(streamedResponse);
      //  // print(buffer.body.toString());
      //   if(streamedResponse.headers['content-type']?.contains('text/event-stream') == true){
      //     print("has the content type");
      //   }
      //   stopwatch.stop();
      //   Stream<String>? utf8Stream;
      //   if (streamedResponse.statusCode == 200) {
         
      //     utf8Stream = await streamedResponse.stream
      //         .transform(utf8.decoder)
      //         .transform(const LineSplitter());
      //     print("utf8stream"+utf8Stream.toString());

      //     await for (final event in utf8Stream) {
      //       print("inside eventloop");
      //       if (event.isNotEmpty) {
      //         print('🔹 SSE Event Received: $event');
      //       }
      //     }
      //   }
      //   print("just before return ing null");
        return (null, stopwatch.elapsed, null,streamedResponse);
      }
      if (apiType == APIType.rest) {
        print("iside second rest");
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
                await multiPartRequest.send();
            stopwatch.stop();
            http.Response convertedMultiPartResponse =
                await convertStreamedResponse(multiPartResponse);
            return (convertedMultiPartResponse, stopwatch.elapsed, null,null);
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
      return (response, stopwatch.elapsed, null,null);
    } catch (e) {
      print("inside catch");
      if (httpClientManager.wasRequestCancelled(requestId)) {
        return (null, null, kMsgRequestCancelled,null);
      }
      return (null, null, e.toString(),null);
    } finally {
      print("inside finallyy");
      httpClientManager.closeClient(requestId);
    }
  } else {
    return (null, null, uriRec.$2,null);
  }
}

void cancelHttpRequest(String? requestId) {
  httpClientManager.cancelRequest(requestId);
}


// void startSSE() async {
//   var url = Uri.parse('https://sse.dev/test');
//   var client = HttpClient();

//   try {
//     var request = await client.getUrl(url);
    

//     var response = await request.close();

//     // Ensure it's a successful SSE connection
//     if (response.statusCode == 200) {
//       print("✅ Connected to SSE stream");

//       response.transform(utf8.decoder).listen(
//         (data) {
//           print("🔹 SSE Event Received: $data");
//         },
//         onError: (error) {
//           print("❌ SSE Error: $error");
//         },
//         onDone: () {
//           print("🔌 SSE Stream Closed");
//         },
//         cancelOnError: true,
//       );
//     } else {
//       print("❌ Failed to connect: ${response.statusCode}");
//     }
//   } catch (e) {
//     print("❌ Exception: $e");
//   }
// }


