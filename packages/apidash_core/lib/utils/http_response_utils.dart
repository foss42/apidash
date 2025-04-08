import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:xml/xml.dart';
import '../consts.dart';

String? formatBody(String? body, MediaType? mediaType) {
  if (mediaType != null && body != null) {
    var subtype = mediaType.subtype;
    try {
      if (subtype.contains(kSubTypeJson)) {
        final tmp = jsonDecode(body);
        String result = kJsonEncoder.convert(tmp);
        return result;
      }
      if (subtype.contains(kSubTypeXml)) {
        final document = XmlDocument.parse(body);
        String result = document.toXmlString(pretty: true, indent: '  ');
        return result;
      }
      if (subtype == kSubTypeHtml) {
        var len = body.length;
        var lines = kSplitter.convert(body);
        var numOfLines = lines.length;
        if (numOfLines != 0 && len / numOfLines <= kCodeCharsPerLineLimit) {
          return body;
        }
      }
    } catch (e) {
      return null;
    }
  }
  return null;
}

Future<http.Response> convertStreamedResponse(
  http.StreamedResponse streamedResponse,
) async {
  Uint8List bodyBytes = await streamedResponse.stream.toBytes();

  http.Response response = http.Response.bytes(
    bodyBytes,
    streamedResponse.statusCode,
    headers: streamedResponse.headers,
    persistentConnection: streamedResponse.persistentConnection,
    reasonPhrase: streamedResponse.reasonPhrase,
    request: streamedResponse.request,
  );

  return response;
}

Future<http.Response> convertDioToHttpResponse(
  dio.Response response,
) async {
  // 1) Copy response headers from Dio into a new map for the http.Response
  final headers = <String, String>{};
  response.headers.forEach((name, values) {
    // If multiple values exist for the same header, join them with commas
    headers[name] = values.join(', ');
  });

  // 2) Status code and reason phrase (e.g., "OK", "Not Found", "Unauthorized")
  final int statusCode = response.statusCode ?? 0;
  final String? reasonPhrase = response.statusMessage;

  // 3) Handle different possible data types in Dio response
  final data = response.data;

  // -- If the response is streamed data (e.g., ResponseType.stream)
  if (data is dio.ResponseBody || data is Stream<List<int>> || data is Stream<Uint8List>) {
    Stream<Uint8List> byteStream;
    if (data is dio.ResponseBody) {
      byteStream = data.stream;
    } else {
      byteStream = (data as Stream).cast<Uint8List>();
    }
    final List<int> bytes = await byteStream.expand((chunk) => chunk).toList();
    headers['content-length'] = bytes.length.toString();

    return http.Response.bytes(
      bytes,
      statusCode,
      headers: headers,
      reasonPhrase: reasonPhrase,
    );
  }

  // -- If the response data is raw bytes (e.g., List<int> or Uint8List) --
  if (data is List<int> || data is Uint8List) {
    final Uint8List bytes = (data is Uint8List) ? data : Uint8List.fromList(data);
    headers['content-length'] = bytes.length.toString();
    return http.Response.bytes(
      bytes,
      statusCode,
      headers: headers,
      reasonPhrase: reasonPhrase,
    );
  }

  // -- Handle String or JSON objects (Map/List) --
  String body;
  if (data is String) {
    body = data;
  } else {
    // If Dio has parsed JSON into a Dart Map or List, encode it back to a string
    body = jsonEncode(data);
    headers.putIfAbsent('content-type', () => 'application/json');
  }

  // Update content-length for the final body
  final bodyBytes = utf8.encode(body);
  headers['content-length'] = bodyBytes.length.toString();

  // Return a formatted http.Response
  return http.Response(
    body,
    statusCode,
    headers: headers,
    reasonPhrase: reasonPhrase,
  );
}
