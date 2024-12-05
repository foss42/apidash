import 'package:http_parser/http_parser.dart';
import '../consts.dart';
import '../extensions/extensions.dart';

ContentType? getContentTypeFromHeadersMap(
  Map<String, String>? kvMap,
) {
  if (kvMap != null && kvMap.hasKeyContentType()) {
    var val = kvMap.getValueContentType();
    if (val != null) {
      return ContentType.text;
    }
  }
  return null;
}

MediaType? getMediaTypeFromHeaders(Map? headers) {
  var contentType = headers?.getValueContentType();
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
