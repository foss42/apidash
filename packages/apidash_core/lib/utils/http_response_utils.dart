import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:xml/xml.dart';
import '../consts.dart';

String? getContentTypeFromHeaders(Map? headers) {
  return headers?[HttpHeaders.contentTypeHeader];
}

MediaType? getMediaTypeFromHeaders(Map? headers) {
  var contentType = getContentTypeFromHeaders(headers);
  MediaType? mediaType = getMediaTypeFromContentType(contentType);
  return mediaType;
}

MediaType? getMediaTypeFromContentType(String? contentType) {
  if (contentType != null) {
    try {
      MediaType mediaType = MediaType.parse(contentType);
      return mediaType;
    } catch (e) {
      return null;
    }
  }
  return null;
}

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
