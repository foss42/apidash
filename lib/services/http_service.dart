import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:apidash/utils/utils.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';

Future<(http.Response?, Duration?, String?)> request(RequestModel requestModel) async {
  (Uri?, String?) uriRec = getValidRequestUri(requestModel.url, 
                                           requestModel.requestParams);
  if(uriRec.$0 != null){
    Uri requestUrl = uriRec.$0!;
    Map<String, String> headers = rowsToMap(requestModel.requestHeaders) ?? {};
    http.Response response;
    String? body;
    try {
      if(kMethodsWithBody.contains(requestModel.method)){
        if(requestModel.requestBody != null){
          var contentLength = utf8.encode(requestModel.requestBody).length;
          if (contentLength > 0){
            body = requestModel.requestBody as String;
            headers[HttpHeaders.contentLengthHeader] = contentLength.toString();
            switch(requestModel.requestBodyContentType){
              case ContentType.json:
                headers[HttpHeaders.contentTypeHeader] = 'application/json';
                break;
              case ContentType.text:
                headers[HttpHeaders.contentTypeHeader] = 'text/plain';
                break;
            }
          }
        }
      }
      Stopwatch stopwatch = Stopwatch()..start();
      switch(requestModel.method){
        case HTTPVerb.get:
          response = await http.get(requestUrl, 
                                    headers: headers);
          break;
        case HTTPVerb.head:
          response = await http.head(requestUrl, 
                                    headers: headers);
          break;
        case HTTPVerb.post:
          response = await http.post(requestUrl, 
                                    headers: headers,
                                    body: body);
          break;
        case HTTPVerb.put:
          response = await http.put(requestUrl, 
                                    headers: headers,
                                    body: body);
          break;
        case HTTPVerb.patch:
          response = await http.patch(requestUrl, 
                                    headers: headers,
                                    body: body);
          break;
        case HTTPVerb.delete:
          response = await http.delete(requestUrl, 
                                    headers: headers,
                                    body: body);
          break;
      }
      stopwatch.stop(); 
      return (response, stopwatch.elapsed, null);
    }
    catch (e) {
      return (null, null, e.toString());
    }
  }
  else {
    return (null, null, uriRec.$1);
  }
}
