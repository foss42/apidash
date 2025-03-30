import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../consts.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'http_service.dart';


Future<void> sendSSERequest(
  String requestId,
  APIType apiType,
  HttpRequestModel requestModel, {
  SupportedUriSchemes defaultUriScheme = kDefaultUriScheme,
  bool noSSL = false,
  Function(int statusCode, Map<String, String> headers)? onConnect,
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
        final int statusCode = streamedResponse.statusCode;
      final Map<String, String> responseHeaders = streamedResponse.headers;
    
        onConnect?.call(statusCode, responseHeaders);
      
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
      }
    }
    
}