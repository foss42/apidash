import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:seed/consts.dart';
import '../consts.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'http_service.dart';





class SSETransformer extends StreamTransformerBase<String, String> {
  const SSETransformer();

  @override
  Stream<String> bind(Stream<String> stream) async* {
    String buffer = "";
    await for (final chunk in stream) {
      buffer += chunk;
      List<String> frames = buffer.split("\n\n");

    
      buffer = frames.removeLast();

      for (final frame in frames) {
        yield frame.trim(); 
      }
    }
  }
}
class LoggingInterceptor implements InterceptorContract {
  Map<String, String>? interceptedHeaders;

  @override
  FutureOr<BaseRequest> interceptRequest({required BaseRequest request}) async {
    interceptedHeaders = request.headers;
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {

    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest() => true;

  @override
  FutureOr<bool> shouldInterceptResponse() => true;
}

Future<void> sendSSERequest(
  String requestId,
  APIType apiType,
  HttpRequestModel requestModel, {
  SupportedUriSchemes defaultUriScheme = kDefaultUriScheme,
  bool noSSL = false,
  Function(int statusCode, Map<String, String> headers, Map<String, String>? interceptedHeaders, Duration?)? onConnect,
  Function(String event)? onData,
  Function(Object error, StackTrace stackTrace)? onError,
  Function()? onDone,
  Function()? onCancel,
}) async {
  if (httpClientManager.wasRequestCancelled(requestId)) {
    httpClientManager.removeCancelledRequest(requestId);
  }
  final interceptor = LoggingInterceptor();
  final baseClient = httpClientManager.createClient(requestId, noSSL: noSSL);
  final client = InterceptedClient.build(interceptors: [interceptor], client: baseClient);

  try {
    (Uri?, String?) uriRec = getValidRequestUri(
      requestModel.url,
      requestModel.enabledParams,
      defaultUriScheme: defaultUriScheme,
    );
    if (uriRec.$1 == null) return;

    Uri requestUrl = uriRec.$1!;
    var isMultiPartRequest = requestModel.bodyContentType == ContentType.formdata;
    var stopwatch = Stopwatch()..start();
    late http.StreamedResponse streamedResponse;
    if (apiType == APIType.sse) {
      
      if (isMultiPartRequest) {
        var multiPartRequest = http.MultipartRequest(
          requestModel.method.name.toUpperCase(),
          requestUrl,
        );
        multiPartRequest.headers.addAll(requestModel.enabledHeadersMap);

        for (var formData in requestModel.formDataList) {
          if (formData.type == FormDataType.text) {
            multiPartRequest.fields[formData.name] = formData.value;
          } else {
            multiPartRequest.files.add(await http.MultipartFile.fromPath(formData.name, formData.value));
          }
        }

        streamedResponse = await multiPartRequest.send();
        stopwatch.stop();
        
        
       
      } else {
        var request = http.Request(requestModel.method.name.toUpperCase(), requestUrl);
        request.headers.addAll(requestModel.enabledHeadersMap);

        if (kMethodsWithBody.contains(requestModel.method) && requestModel.body != null) {
          request.body = requestModel.body!;
          request.headers[HttpHeaders.contentTypeHeader] = requestModel.bodyContentType.header;
        }

        streamedResponse = await client.send(request);
        stopwatch.stop();
        
        
       
      }
      onConnect?.call(
          streamedResponse.statusCode, streamedResponse.headers, interceptor.interceptedHeaders, stopwatch.elapsed
      );
      
      final stream = streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const SSETransformer());
      stream.listen(
        (frame) {
           onData?.call(frame);
        },
        onError: (error) {
           
            if (httpClientManager.wasRequestCancelled(requestId)) {
              onCancel?.call();  
              
              return;   
             }
          (error, stackTrace) => onError?.call(error, stackTrace);
         
        },
        onDone: () {
          if (httpClientManager.wasRequestCancelled(requestId)) {
              onCancel?.call();  
              return;  
          }
          onDone?.call();
        
        }
      );
    }
  } catch (e, stackTrace) {
    
    onError?.call(e, stackTrace);
  }
  
}

