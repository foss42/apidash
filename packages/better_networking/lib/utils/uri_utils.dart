import 'package:collection/collection.dart' show mergeMaps;
import 'package:seed/seed.dart';
import '../consts.dart';
import 'http_request_utils.dart';

(String?, bool) getUriScheme(Uri uri) {
  if (uri.hasScheme) {
    if (kSupportedUriSchemes.contains(uri.scheme.toLowerCase())) {
      return (uri.scheme, true);
    }
    return (uri.scheme, false);
  }
  return (null, false);
}

/// Maps the user's HTTP default-URI-scheme preference onto its WebSocket
/// equivalent, so `https` implies `wss` and `http` implies `ws`.
SupportedWebSocketUriSchemes webSocketSchemeFor(SupportedUriSchemes scheme) {
  return switch (scheme) {
    SupportedUriSchemes.https => SupportedWebSocketUriSchemes.wss,
    SupportedUriSchemes.http => SupportedWebSocketUriSchemes.ws,
  };
}

/// Applies [defaultUriScheme] to [url] when the scheme is omitted, mirroring
/// how [getValidRequestUri] defaults HTTP URLs.
///
/// Localhost and bare-IP hosts default to `ws://` rather than `wss://`, for the
/// same reason [getValidRequestUri] forces `http` for those hosts: local
/// development servers rarely terminate TLS.
///
/// A URL that already carries a scheme is returned untouched, including an
/// unsupported one, so that `WebSocket.connect` can surface its own
/// "Unsupported URL scheme" error rather than this function guessing at intent.
///
/// Returns `null` when [url] is null/blank, matching the "URL is missing"
/// case callers already handle.
String? applyWebSocketUriScheme(
  String? url, {
  SupportedWebSocketUriSchemes defaultUriScheme = kDefaultWebSocketUriScheme,
}) {
  url = url?.trim();
  if (url == null || url == "") {
    return null;
  }

  // Checked before parsing: `Uri.parse("localhost:8765")` yields the scheme
  // "localhost", and `Uri.parse("127.0.0.1:8765")` throws outright, so neither
  // can be identified by inspecting the parsed Uri.
  if (kLocalhostRegex.hasMatch(url) || kIPHostRegex.hasMatch(url)) {
    return '${SupportedWebSocketUriSchemes.ws.name}://$url';
  }

  final uri = Uri.tryParse(url);
  if (uri == null) {
    return url;
  }
  if (uri.hasScheme) {
    return url;
  }
  return '${defaultUriScheme.name}://$url';
}

String stripUriParams(Uri uri) {
  return "${uri.scheme}://${uri.authority}${uri.path}";
}

String stripUrlParams(String url) {
  var idx = url.indexOf("?");
  return idx > 0 ? url.substring(0, idx) : url;
}

(Uri?, String?) getValidRequestUri(
  String? url,
  List<NameValueModel>? requestParams, {
  SupportedUriSchemes defaultUriScheme = kDefaultUriScheme,
}) {
  url = url?.trim();
  if (url == null || url == "") {
    return (null, "URL is missing!");
  }

  if (kLocalhostRegex.hasMatch(url) || kIPHostRegex.hasMatch(url)) {
    url = '${SupportedUriSchemes.http.name}://$url';
  }

  Uri? uri = Uri.tryParse(url);
  if (uri == null) {
    return (null, "Check URL (malformed)");
  }
  (String?, bool) urlScheme = getUriScheme(uri);

  if (urlScheme.$1 != null) {
    if (!urlScheme.$2) {
      return (null, "Unsupported URL Scheme (${urlScheme.$1})");
    }
  } else {
    url = "${defaultUriScheme.name}://$url";
  }

  uri = Uri.parse(url);
  if (uri.hasFragment) {
    uri = uri.removeFragment();
  }

  Map<String, String>? queryParams = rowsToMap(requestParams);
  if (queryParams != null && queryParams.isNotEmpty) {
    if (uri.hasQuery) {
      Map<String, String> urlQueryParams = uri.queryParameters;
      queryParams = mergeMaps(urlQueryParams, queryParams);
    }
    uri = uri.replace(queryParameters: queryParams);
  }
  return (uri, null);
}
