import 'dart:convert';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import '../consts.dart';
import '../extensions/extensions.dart';

ContentType? getContentTypeFromHeadersMap(Map<String, String>? kvMap) {
  if (kvMap != null && kvMap.hasKeyContentType()) {
    var val = getMediaTypeFromHeaders(kvMap);
    return getContentTypeFromMediaType(val);
  }
  return null;
}

MediaType? getMediaTypeFromHeaders(Map? headers) {
  var contentType = headers?.getValueContentType();
  MediaType? mediaType = getMediaTypeFromContentType(contentType);
  return mediaType;
}

MediaType? getMediaTypeFromHeadersOrSniff(
  Map<String, String>? headers,
  Uint8List? bodyBytes,
) {
  final parsed = getMediaTypeFromHeaders(headers);

  final shouldSniff = parsed == null ||
      (parsed.type == kTypeApplication &&
          parsed.subtype == kSubTypeOctetStream);

  if (!shouldSniff || bodyBytes == null || bodyBytes.isEmpty) {
    return parsed;
  }

  return sniffMediaTypeFromBytes(bodyBytes) ?? parsed;
}

MediaType? sniffMediaTypeFromBytes(Uint8List bytes) {
  if (bytes.isEmpty) return null;

  // Conservative binary signatures for first-pass detection.
  if (_startsWith(bytes, const [0x25, 0x50, 0x44, 0x46])) {
    return MediaType(kTypeApplication, kSubTypePdf); // %PDF
  }
  if (_startsWith(bytes, const [0x89, 0x50, 0x4E, 0x47])) {
    return MediaType(kTypeImage, 'png');
  }
  if (_startsWith(bytes, const [0xFF, 0xD8, 0xFF])) {
    return MediaType(kTypeImage, 'jpeg');
  }
  if (_startsWith(bytes, const [0x47, 0x49, 0x46, 0x38])) {
    return MediaType(kTypeImage, 'gif');
  }

  // Text-like payload probing
  final prefixLen = bytes.length < 1024 ? bytes.length : 1024;
  final prefix = bytes.sublist(0, prefixLen);

  String textPrefix;
  try {
    textPrefix = utf8.decode(prefix);
  } catch (_) {
    textPrefix = '';
  }

  final trimmed = textPrefix.trimLeft();

  if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
    return MediaType(kTypeApplication, kSubTypeJson);
  }

  if (_isLikelyText(prefix)) {
    return MediaType(kTypeText, kSubTypePlain);
  }

  return null;
}

bool _startsWith(Uint8List bytes, List<int> sig) {
  if (bytes.length < sig.length) return false;
  for (var i = 0; i < sig.length; i++) {
    if (bytes[i] != sig[i]) return false;
  }
  return true;
}

bool _isLikelyText(Uint8List bytes) {
  var printable = 0;
  for (final b in bytes) {
    if (b == 0) return false;
    if (b == 9 || b == 10 || b == 13 || (b >= 32 && b <= 126)) {
      printable++;
    }
  }
  return bytes.isNotEmpty && printable / bytes.length > 0.9;
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

ContentType? getContentTypeFromMediaType(MediaType? mediaType) {
  if (mediaType != null) {
    if (mediaType.subtype.contains(kSubTypeJson)) {
      return ContentType.json;
    } else if (mediaType.type == kTypeMultipart &&
        mediaType.subtype == kSubTypeFormData) {
      return ContentType.formdata;
    }
    return ContentType.text;
  }
  return null;
}

ContentType? getContentTypeFromContentTypeStr(String? contentType) {
  if (contentType != null) {
    var val = getMediaTypeFromContentType(contentType);
    return getContentTypeFromMediaType(val);
  }
  return null;
}
