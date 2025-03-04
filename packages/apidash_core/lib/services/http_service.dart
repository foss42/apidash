import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:charset/charset.dart';
import 'package:http/http.dart' as http;
import 'package:seed/seed.dart';
import '../consts.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'http_client_manager.dart';
import 'dart:collection';

typedef HttpResponse = http.Response;

final httpClientManager = HttpClientManager();

// Function to get encoding by name, supporting both built-in and charset package
Encoding getEncodingFromCharset(String? charsetName) {
  if (charsetName == null) {
    return utf8;
  }
  
  // Normalize to lowercase for case-insensitive matching
  final normalizedName = charsetName.toLowerCase().trim();
  
  // Direct codec mappings - built-in encodings first
  switch (normalizedName) {
    // Built-in encodings
    case 'utf-8':
    case 'utf8':
    case 'utf_8':
    case 'csutf8':
      return Utf8Codec();
    
    case 'ascii':
    case 'us-ascii':
    case 'us':
    case 'iso-ir-6':
    case 'ansi_x3.4-1968':
    case 'ansi_x3.4-1986':
    case 'iso_646.irv:1991':
    case 'iso646-us':
    case 'ibm367':
    case 'cp367':
    case 'csascii':
      return AsciiCodec();
    
    case 'iso-8859-1':
    case 'iso8859-1':
    case 'iso_8859-1':
    case 'latin1':
    case 'iso_8859-1:1987':
    case 'iso-ir-100':
    case 'l1':
    case 'ibm819':
    case 'cp819':
    case 'csisolatin1':
      return Latin1Codec();
    
    // UTF-16 variants
    case 'utf-16':
    case 'utf16':
    case 'utf_16':
      return Utf16Codec();
    
    case 'utf-16be':
    case 'utf16be':
    case 'utf_16be':
      return const Utf16Codec();
    
    case 'utf-16le':
    case 'utf16le':
    case 'utf_16le':
      return const Utf16Codec();
      
    // UTF-32 variants
    case 'utf-32':
    case 'utf32':
    case 'utf_32':
      return utf32;
      
    // Japanese encodings
    case 'shift_jis':
    case 'shift-jis':
    case 'sjis':
      return shiftJis;
    
    case 'euc-jp':
    case 'euc_jp':
      return eucJp;
      
    // Korean encoding
    case 'euc-kr':
    case 'euc_kr':
      return eucKr;
      
    // Chinese encoding
    case 'gbk':
    case 'gb2312':
      return gbk;
      
    // Windows code pages
    case 'windows-1250':
    case 'cp1250':
      return windows1250;
    
    case 'windows-1251':
    case 'cp1251':
      return windows1251;
    
    case 'windows-1252':
    case 'cp1252':
      return windows1252;
    
    case 'windows-1253':
    case 'cp1253':
      return windows1253;
    
    // More Windows code pages and ISO encodings
    // For other ISO Latin encodings, use a more generic approach
    case 'iso-8859-2':
    case 'latin2':
      return latin2;
    
    case 'iso-8859-3': 
    case 'latin3':
      return latin3;
    
    case 'iso-8859-4':
    case 'latin4':
      return latin4;
    
    case 'iso-8859-5':
    case 'latin-cyrillic':
      // Return a fallback if latinCyrillic is not available
      return windows1251; // Cyrillic encoding as fallback
    
    case 'iso-8859-6':
    case 'latin-arabic':
      // Return a fallback if latinArabic is not available
      return windows1256; // Arabic encoding as fallback
    
    case 'iso-8859-7':
    case 'latin-greek':
      // Return a fallback if latinGreek is not available
      return windows1253; // Greek encoding as fallback
    
    case 'iso-8859-8':
    case 'latin-hebrew':
      // Return a fallback if latinHebrew is not available
      return windows1255; // Hebrew encoding as fallback
    
    case 'iso-8859-9':
    case 'latin5':
      // Return a fallback if latin5 is not available
      return windows1254; // Turkish encoding as fallback
    
    case 'iso-8859-10':
    case 'latin6':
      // Return a fallback (no direct equivalent)
      return utf8;
    
    case 'iso-8859-11':
    case 'latin-thai':
      // Return a fallback if latinThai is not available
      return windows874; // Thai encoding as fallback
    
    case 'iso-8859-13':
    case 'latin7':
      // Return a fallback if latin7 is not available
      return windows1257; // Baltic encoding as fallback
    
    case 'iso-8859-14':
    case 'latin8':
      // Return a fallback (no direct equivalent)
      return latin1;
    
    case 'iso-8859-15':
    case 'latin9':
      // Return a fallback if latin9 is not available
      return latin1; // Very similar to Latin-1
    
    case 'iso-8859-16':
    case 'latin10':
      // Return a fallback if latin10 is not available
      return utf8;
    
    // Default to UTF-8 for anything else
    default:
      print("Warning: Unsupported charset: $normalizedName, using UTF-8 as fallback");
      return utf8;
  }
}

Future<(HttpResponse?, Duration?, String?)> sendHttpRequest(
  String requestId,
  APIType apiType,
  HttpRequestModel requestModel, {
  SupportedUriSchemes defaultUriScheme = kDefaultUriScheme,
  bool noSSL = false,
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
        
        // Replace the switch statement with manual Request creation
        final request = http.Request(
          requestModel.method.name.toUpperCase(),
          requestUrl,
        );
        // Set headers
        request.headers.addAll(headers);
        
        // Set body if needed
        if (body != null && kMethodsWithBody.contains(requestModel.method)) {
          // Extract charset from Content-Type header if present
          Encoding encoding = utf8; // Default to UTF-8
          
          final contentTypeHeader = request.headers[HttpHeaders.contentTypeHeader];          
          if (contentTypeHeader != null) {
            final charsetMatch = RegExp(r'charset=([^\s;]+)', caseSensitive: false)
                .firstMatch(contentTypeHeader);
            
            if (charsetMatch != null) {
              final charsetName = charsetMatch.group(1);
              
              if (charsetName != null) {
                // Get the encoding object using our helper function
                encoding = getEncodingFromCharset(charsetName);
              }
            }
          }
          
          // Encode the body using the determined encoding
          request.bodyBytes = encoding.encode(body);
        }
        
        // Use the client to send the request
        final streamedResponse = await client.send(request);
        response = await http.Response.fromStream(streamedResponse);
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
