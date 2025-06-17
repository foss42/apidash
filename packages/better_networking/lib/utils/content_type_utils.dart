import 'package:http_parser/http_parser.dart';
import '../consts.dart';
import '../extensions/extensions.dart';

ContentType? getContentTypeFromHeadersMap(
  Map<String, String>? kvMap,
) {
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

ContentType? getContentTypeFromContentTypeStr(
  String? contentType,
) {
  if (contentType != null) {
    var val = getMediaTypeFromContentType(contentType);
    return getContentTypeFromMediaType(val);
  }
  return null;
}
