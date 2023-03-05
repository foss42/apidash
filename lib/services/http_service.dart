import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_api_tool/consts.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart' show mergeMaps;
import '../models/models.dart';

const SUPPORTED_URI_SCHEMES = [
  "https",
  "http"
];

const DEFAULT_URI_SCHEME = "https://";

const METHODS_WITH_BODY = [HTTPVerb.post, HTTPVerb.put, HTTPVerb.patch, HTTPVerb.delete,];

(String?, bool) getUriScheme(Uri uri) {
  if(uri.hasScheme){
    if(SUPPORTED_URI_SCHEMES.contains(uri.scheme)){
      return (uri.scheme, true);
    }
    return (uri.scheme, false);
  }
  return (null, false);
}

(Uri?, String?) getValidRequestUri(String? url, List<KVRow>? requestParams) {
  if(url == null || url.trim() == ""){
    return (null, "URL is missing!");
  }
  Uri? uri =  Uri.tryParse(url);
  if(uri == null){
    return (null, "Check URL (malformed)");
  }
  (String?, bool) urlScheme = getUriScheme(uri);

  if(urlScheme.$0 != null){
    if (!urlScheme.$1){
      return (null, "Unsupported URL Scheme (${urlScheme.$0})");
    }
  }
  else {
    url = DEFAULT_URI_SCHEME + url;
  }

  uri =  Uri.parse(url);
  if (uri.hasFragment){
    uri = uri.removeFragment();
  }

  Map<String, String>? queryParams = rowsToMap(requestParams);
  if(queryParams != null){
    if(uri.hasQuery){
      Map<String, String> urlQueryParams = uri.queryParameters;
      queryParams = mergeMaps(urlQueryParams, queryParams);
    }
    uri = uri.replace(queryParameters: queryParams);
  }
  return (uri, null);
}

Future<(http.Response?, Duration?, String?)> request(RequestModel requestModel) async {
  (Uri?, String?) uriRec = getValidRequestUri(requestModel.url, 
                                           requestModel.requestParams);
  if(uriRec.$0 != null){
    Uri requestUrl = uriRec.$0!;
    Map<String, String> headers = rowsToMap(requestModel.requestHeaders) ?? {};
    http.Response response;
    String? body;
    try {
      if(METHODS_WITH_BODY.contains(requestModel.method)){
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
