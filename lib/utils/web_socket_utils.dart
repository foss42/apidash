import 'package:collection/collection.dart' show mergeMaps;

import '../consts.dart';
import '../models/models.dart';
import 'convert_utils.dart' show rowsToMap;

(String? scheme, bool isValid) getUriScheme(Uri uri) {
  if (uri.hasScheme) {
    if (kSupportedWebSocketUriSchemes.contains(uri.scheme)) {
      return (uri.scheme, true);
    }
    return (uri.scheme, false);
  }
  return (null, false);
}

(Uri?, String?) getValidWebSocketRequestUri(
    String? url, List<NameValueModel>? requestParams,
    {String defaultUriScheme = kDefaultWebSocketUriScheme}) {
  url = url?.trim();
  if (url == null || url == "") {
    return (null, "URL is missing!");
  }
  Uri? uri = Uri.tryParse(url);
  if (uri == null) {
    return (null, "Check URL (malformed)");
  }
  final (uriScheme, isValid) = getUriScheme(uri);

  if (uriScheme != null) {
    if (!isValid) {
      return (null, "Unsupported URL Scheme ($uriScheme)");
    }
  } else {
    url = "$defaultUriScheme://$url";
  }

  uri = Uri.parse(url);
  if (uri.hasFragment) {
    uri = uri.removeFragment();
  }

  Map<String, String>? queryParams = rowsToMap(requestParams);
  if (queryParams != null) {
    if (uri.hasQuery) {
      Map<String, String> urlQueryParams = uri.queryParameters;
      queryParams = mergeMaps(urlQueryParams, queryParams);
    }
    uri = uri.replace(queryParameters: queryParams);
  }
  return (uri, null);
}
