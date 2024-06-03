import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart' show mergeMaps;
import 'package:http_parser/http_parser.dart';
import 'package:xml/xml.dart';
import '../models/models.dart';
import 'convert_utils.dart' show rowsToMap;
import '../consts.dart';

String getRequestTitleFromUrl(String? url) {
  if (url == null || url.trim() == "") {
    return "untitled";
  }
  if (url.contains("://")) {
    String rem = url.split("://")[1];
    if (rem.trim() == "") {
      return "untitled";
    }
    return rem;
  }
  return url;
}

String? getContentTypeFromHeaders(Map? headers) {
  return headers?[HttpHeaders.contentTypeHeader];
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

MediaType? getMediaTypeFromHeaders(Map? headers) {
  var contentType = getContentTypeFromHeaders(headers);
  MediaType? mediaType = getMediaTypeFromContentType(contentType);
  return mediaType;
}

(String?, bool) getUriScheme(Uri uri) {
  if (uri.hasScheme) {
    if (kSupportedUriSchemes.contains(uri.scheme)) {
      return (uri.scheme, true);
    }
    return (uri.scheme, false);
  }
  return (null, false);
}

String stripUriParams(Uri uri) {
  return "${uri.scheme}://${uri.authority}${uri.path}";
}

String stripUrlParams(String url) {
  var idx = url.indexOf("?");
  return idx > 0 ? url.substring(0, idx) : url;
}

(Uri?, String?) getValidRequestUri(
    String? url, List<NameValueModel>? requestParams,
    {String defaultUriScheme = kDefaultUriScheme}) {
  url = url?.trim();
  if (url == null || url == "") {
    return (null, "URL is missing!");
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
    url = "$defaultUriScheme://$url";
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

(List<ResponseBodyView>, String?) getResponseBodyViewOptions(
    MediaType? mediaType) {
  if (mediaType != null) {
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
  }
  return (kNoBodyViewOptions, null);
}

String? formatBody(String? body, MediaType? mediaType) {
  if (mediaType != null && body != null) {
    var subtype = mediaType.subtype;
    try {
      if (subtype.contains(kSubTypeJson)) {
        final tmp = jsonDecode(body);
        String result = kEncoder.convert(tmp);
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
