import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:xml/xml.dart';
import '../consts.dart';
import 'dart:convert';
import 'dart:typed_data';

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

// Stream<String?> streamTextResponse(
//   http.StreamedResponse streamedResponse,
// ) async* {
//   try {
//     if (streamedResponse.statusCode != 200) {
//       final errorText = await streamedResponse.stream.bytesToString();
//       throw Exception('${streamedResponse.statusCode}\n$errorText');
//     }
//     final utf8Stream = streamedResponse.stream.transform(utf8.decoder);
//     await for (final chunk in utf8Stream) {
//       yield chunk;
//     }
//   } catch (e) {
//     rethrow;
//   }
// }

String getCharset(String contentType) {
  final match = RegExp(
    r'charset=([^\s;]+)',
    caseSensitive: false,
  ).firstMatch(contentType);
  return match?.group(1)?.toLowerCase() ?? 'utf-8'; // default to utf-8
}

String decodeBytes(List<int> bytes, String contentType) {
  String _decodeUtf16(List<int> bytes, Endian endianness) {
    final byteData = ByteData.sublistView(Uint8List.fromList(bytes));
    final codeUnits = <int>[];
    for (int i = 0; i + 1 < byteData.lengthInBytes; i += 2) {
      codeUnits.add(byteData.getUint16(i, endianness));
    }
    return String.fromCharCodes(codeUnits);
  }

  final cSet = getCharset(contentType);
  switch (cSet) {
    case 'utf-8':
    case 'utf8':
      return utf8.decode(bytes, allowMalformed: true);
    case 'utf-16':
    case 'utf-16le':
      return _decodeUtf16(bytes, Endian.little);
    case 'utf-16be':
      return _decodeUtf16(bytes, Endian.big);
    case 'iso-8859-1':
    case 'latin1':
      return latin1.decode(bytes);
    case 'us-ascii':
    case 'ascii':
      return ascii.decode(bytes);
    default:
      return utf8.decode(bytes, allowMalformed: true); //UTF8
  }
}
