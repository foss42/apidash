import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:charset/charset.dart'; // External package for additional encodings
import 'package:http/http.dart' as http;
import 'package:seed/consts.dart';
import '../consts.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'http_client_manager.dart';

// Alias for convenience
typedef HttpResponse = http.Response;

final httpClientManager = HttpClientManager();

// Cache for storing detected encodings
final Map<String, Encoding> _encodingCache = {};

/// Function to get encoding by charset name, supporting built-in and additional encodings
Encoding getEncodingFromCharset(String? charsetName) {
    if (charsetName == null) return utf8; // Default encoding

  final normalizedName = charsetName.toLowerCase().trim();

  // Check cache first to avoid redundant lookups
  if (_encodingCache.containsKey(normalizedName)) {
    return _encodingCache[normalizedName]!;
  }

  // Built-in Dart encodings
  Encoding? encoding;
  switch (normalizedName) {
    case 'utf-8':
    case 'utf8':
      encoding = utf8;
      break;

    case 'ascii':
      encoding = ascii;
      break;

    case 'iso-8859-1':
    case 'latin1':
      encoding = latin1;
      break;

    case 'utf-16':
    case 'utf-16be':
    case 'utf-16le':
      encoding = Utf16Codec();
      break;

    case 'utf-32':
      encoding = utf32;
      break;

    default:
      // Attempt to retrieve encoding from `charset` package
      try {
        encoding = Charset.getByName(normalizedName) ?? utf8; // Fallback to UTF-8
      } catch (e) {
        print("Warning: Unsupported charset: $normalizedName, using UTF-8 as fallback");
        encoding = utf8;
      }
  }

  // Cache result for future lookups
  _encodingCache[normalizedName] = encoding;
  print(encoding.name);
  return encoding;
}

/// Sends an HTTP request with proper encoding handling
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

  if (uriRec.$1 == null) {
    return (null, null, uriRec.$2); // Invalid URL case
  }

  Uri requestUrl = uriRec.$1!;
  Map<String, String> headers = requestModel.enabledHeadersMap;
  HttpResponse? response;
  String? body;

  try {
    Stopwatch stopwatch = Stopwatch()..start();

    if (apiType == APIType.rest) {
      bool isMultiPartRequest = requestModel.bodyContentType == ContentType.formdata;

      if (kMethodsWithBody.contains(requestModel.method)) {
        var requestBody = requestModel.body;
        if (requestBody != null && !isMultiPartRequest) {
          var contentLength = utf8.encode(requestBody).length;
          if (contentLength > 0) {
            body = requestBody;
            headers[HttpHeaders.contentLengthHeader] = contentLength.toString();
            if (!requestModel.hasContentTypeHeader) {
              headers[HttpHeaders.contentTypeHeader] = requestModel.bodyContentType.header;
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
                await http.MultipartFile.fromPath(formData.name, formData.value),
              );
            }
          }

          http.StreamedResponse multiPartResponse = await client.send(multiPartRequest);
          stopwatch.stop();
          HttpResponse convertedMultiPartResponse = await http.Response.fromStream(multiPartResponse);
          return (convertedMultiPartResponse, stopwatch.elapsed, null);
        }
      }

      // Prepare request
      final request = http.Request(requestModel.method.name.toUpperCase(), requestUrl);
      request.headers.addAll(headers);

      // Set body if applicable
      if (body != null && kMethodsWithBody.contains(requestModel.method)) {
        Encoding encoding = utf8; // Default encoding
        
        final contentTypeHeader = request.headers[HttpHeaders.contentTypeHeader];
        if (contentTypeHeader != null) {
          // First check for explicit charset parameter
          final charsetMatch = RegExp(r'charset=([^\s;]+)', caseSensitive: false).firstMatch(contentTypeHeader);
          if (charsetMatch != null) {
            final charsetName = charsetMatch.group(1);
            encoding = getEncodingFromCharset(charsetName);
          } else {
            // No explicit charset, check content type
            final contentTypeBase = contentTypeHeader.split(';')[0].trim().toLowerCase();
            
            // For text-based content types, ensure we apply proper encoding
            if (contentTypeBase.startsWith('text/') || 
                contentTypeBase == 'application/json' ||
                contentTypeBase == 'application/xml' ||
                contentTypeBase == 'application/javascript') {
              // Keep default UTF-8 encoding for text-based content
            }
          }
        }
        
        request.bodyBytes = encoding.encode(body);
      }

      // Send request
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
      response = await client.post(requestUrl, headers: headers, body: body);
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

/// Cancels an HTTP request by ID
void cancelHttpRequest(String? requestId) {
  httpClientManager.cancelRequest(requestId);
}
