import 'package:apidash_core/apidash_core.dart';
import '../consts.dart';
import '../utils/jwt_utils.dart'; // Import JWT utilities

String getRequestTitleFromUrl(String? url) {
  if (url == null || url.trim().isEmpty) {
    return kUntitled;
  }
  if (url.contains("://")) {
    String rem = url.split("://")[1];
    if (rem.trim().isEmpty) {
      return kUntitled;
    }
    return rem;
  }
  return url;
}

(List<ResponseBodyView>, String?) getResponseBodyViewOptions(
    MediaType? mediaType) {
  if (mediaType == null) {
    return (kRawBodyViewOptions, null);
  }
  var type = mediaType.type;
  var subtype = mediaType.subtype;
  if (kResponseBodyViewOptions.containsKey(type)) {
    if (kResponseBodyViewOptions[type]!.containsKey(subtype)) {
      return (
        kResponseBodyViewOptions[type]![subtype]!,
        kCodeHighlighterMap[subtype] ?? subtype
      );
    }
    if (subtype.contains(kSubTypeJson)) {
      subtype = kSubTypeJson;
    }
    if (subtype.contains(kSubTypeXml)) {
      subtype = kSubTypeXml;
    }
    if (kResponseBodyViewOptions[type]!.containsKey(subtype)) {
      return (
        kResponseBodyViewOptions[type]![subtype]!,
        kCodeHighlighterMap[subtype] ?? subtype
      );
    }
    return (
      kResponseBodyViewOptions[type]![kSubTypeDefaultViewOptions]!,
      subtype
    );
  }
  return (kNoBodyViewOptions, null);
}

// Utility function to get authorization header for API requests
Future<Map<String, String>> getAuthHeaders() async {
  final token = await JwtUtils.getToken();
  final headers = <String, String>{
    'Content-Type': 'application/json',
  };

  if (token != null) {
    headers['Authorization'] = 'Bearer $token';
  }
  return headers;
}
