import 'dart:convert';
import 'package:xml/xml.dart';

/// Utility functions for escaping, formatting byte sizes, duration,
/// pretty-printing bodies, and MIME-type language detection for documentation generators.

/// Escapes text for Markdown table cells.
/// Replaces pipe characters with `\|` and converts newlines to `<br/>` to avoid breaking table layout.
String escapeMarkdownTable(String? text) {
  if (text == null || text.isEmpty) {
    return '-';
  }
  return text
      .replaceAll(r'\', r'\\')
      .replaceAll('|', r'\|')
      .replaceAll('\r\n', '<br/>')
      .replaceAll('\n', '<br/>')
      .replaceAll('\r', '<br/>');
}

/// Formats byte size into human-readable representation (e.g., `450 B`, `12.4 KB`, `1.5 MB`).
String formatByteSize(int? bytes) {
  if (bytes == null || bytes <= 0) {
    return '0 B';
  }
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  int unitIndex = 0;
  double size = bytes.toDouble();

  while (size >= 1024 && unitIndex < units.length - 1) {
    size /= 1024;
    unitIndex++;
  }

  if (unitIndex == 0) {
    return '$bytes B';
  }
  // Trim trailing zeros after decimal if any
  String formatted = size.toStringAsFixed(1);
  if (formatted.endsWith('.0')) {
    formatted = formatted.substring(0, formatted.length - 2);
  }
  return '$formatted ${units[unitIndex]}';
}

/// Formats a [Duration] into human-readable duration (e.g., `250 µs`, `45 ms`, `1.23 s`).
String formatDuration(Duration? duration) {
  if (duration == null) {
    return '-';
  }
  final microseconds = duration.inMicroseconds;
  if (microseconds < 1000) {
    return '$microseconds µs';
  }
  final milliseconds = duration.inMilliseconds;
  if (milliseconds < 1000) {
    return '$milliseconds ms';
  }
  final seconds = milliseconds / 1000.0;
  String formatted = seconds.toStringAsFixed(2);
  if (formatted.endsWith('.00')) {
    formatted = formatted.substring(0, formatted.length - 3);
  } else if (formatted.endsWith('0')) {
    formatted = formatted.substring(0, formatted.length - 1);
  }
  return '$formatted s';
}

/// Detects the syntax highlighting codeblock language from a MIME content-type.
String detectMimeLanguage(String? contentType) {
  if (contentType == null || contentType.trim().isEmpty) {
    return 'text';
  }
  final mime = contentType.toLowerCase().split(';').first.trim();
  if (mime.contains('json')) {
    return 'json';
  }
  if (mime.contains('xml')) {
    return 'xml';
  }
  if (mime.contains('html')) {
    return 'html';
  }
  if (mime.contains('javascript') || mime.contains('ecmascript')) {
    return 'javascript';
  }
  if (mime.contains('css')) {
    return 'css';
  }
  if (mime.contains('yaml') || mime.contains('x-yaml')) {
    return 'yaml';
  }
  if (mime.contains('markdown')) {
    return 'markdown';
  }
  if (mime.startsWith('text/')) {
    return 'text';
  }
  return 'text';
}

/// Formats/pretty-prints payload body content (JSON, XML, or plain text) with fallback.
String formatDocBody(String? body, {String? contentType}) {
  if (body == null || body.trim().isEmpty) {
    return '';
  }
  final trimmed = body.trim();
  final mimeLang = detectMimeLanguage(contentType);

  if (mimeLang == 'json' ||
      (trimmed.startsWith('{') && trimmed.endsWith('}')) ||
      (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
    try {
      final decoded = json.decode(trimmed);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      // Fallback to raw text if not valid JSON
    }
  }

  if (mimeLang == 'xml' ||
      (trimmed.startsWith('<') && trimmed.endsWith('>'))) {
    try {
      final document = XmlDocument.parse(trimmed);
      return document.toXmlString(pretty: true, indent: '  ');
    } catch (_) {
      // Fallback to raw text if XML parsing fails
    }
  }

  return trimmed;
}

/// Returns the standard HTTP status reason phrase for a given [statusCode].
String getHttpStatusText(int? statusCode) {
  if (statusCode == null) return '-';
  switch (statusCode) {
    case 100:
      return 'Continue';
    case 101:
      return 'Switching Protocols';
    case 200:
      return 'OK';
    case 201:
      return 'Created';
    case 202:
      return 'Accepted';
    case 204:
      return 'No Content';
    case 301:
      return 'Moved Permanently';
    case 302:
      return 'Found';
    case 304:
      return 'Not Modified';
    case 400:
      return 'Bad Request';
    case 401:
      return 'Unauthorized';
    case 403:
      return 'Forbidden';
    case 404:
      return 'Not Found';
    case 405:
      return 'Method Not Allowed';
    case 408:
      return 'Request Timeout';
    case 409:
      return 'Conflict';
    case 422:
      return 'Unprocessable Entity';
    case 429:
      return 'Too Many Requests';
    case 500:
      return 'Internal Server Error';
    case 501:
      return 'Not Implemented';
    case 502:
      return 'Bad Gateway';
    case 503:
      return 'Service Unavailable';
    case 504:
      return 'Gateway Timeout';
    default:
      if (statusCode >= 200 && statusCode < 300) return 'Success';
      if (statusCode >= 300 && statusCode < 400) return 'Redirection';
      if (statusCode >= 400 && statusCode < 500) return 'Client Error';
      if (statusCode >= 500 && statusCode < 600) return 'Server Error';
      return 'Status $statusCode';
  }
}

/// Standard descriptions for common HTTP headers.
const Map<String, String> kCommonHeaderDescriptions = {
  'accept': 'Acceptable response media types',
  'accept-charset': 'Character sets that are acceptable',
  'accept-encoding': 'Acceptable content encoding (compression)',
  'accept-language': 'Preferred natural languages',
  'authorization': 'Authentication credentials',
  'cache-control': 'Directives for caching mechanisms',
  'connection': 'Connection control options',
  'content-length': 'Length of the request body in bytes',
  'content-type': 'Media type of the request body',
  'cookie': 'HTTP cookies previously sent by the server',
  'date': 'Date and time the message was sent',
  'expect': 'Expectations that need to be met by the server',
  'forwarded': 'Information from reverse proxy servers',
  'from': 'Email address of the human user sending request',
  'host': 'Domain name of the server and port',
  'if-match': 'Perform action only if entity matches ETag',
  'if-modified-since': 'Perform action only if modified since date',
  'if-none-match': 'Perform action only if entity does not match ETag',
  'if-range': 'Send parts of document if unchanged',
  'if-unmodified-since': 'Perform action only if unmodified since date',
  'origin': 'Origin of cross-site or preflight request',
  'pragma': 'Implementation-specific directives',
  'proxy-authorization': 'Credentials to authenticate with proxy',
  'range': 'Request only part of an entity',
  'referer': 'Address of the previous web page',
  'upgrade': 'Ask server to upgrade to another protocol',
  'user-agent': 'Client application user agent string',
  'via': 'Informs client of proxies through which request was sent',
  'warning': 'General warning about message status',
  'x-api-key': 'API authentication key',
  'x-requested-with': 'Identifies Ajax requests',
  'x-forwarded-for': 'Originating IP address of a client',
  'x-forwarded-proto': 'Originating protocol (HTTP/HTTPS)',
};

/// Resolves a description for a given header name.
String getHeaderDescription(String? headerName) {
  if (headerName == null || headerName.trim().isEmpty) return '-';
  return kCommonHeaderDescriptions[headerName.trim().toLowerCase()] ?? '-';
}
