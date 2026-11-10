import 'dart:convert';

/// Maximum allowed length of an error message before truncation.
const int kMaxErrorMessageLength = 500;

/// Matches HTML tags for stripping or sanitizing.
final RegExp _kHtmlTagRegex = RegExp(r'<[^>]*>', multiLine: true);

/// Patterns for redacting sensitive credentials from error messages.
final List<RegExp> _kCredentialRedactionRegexes = [
  RegExp(r'sk-[a-zA-Z0-9_\-]{8,}'),
  RegExp(r'AIza[0-9A-Za-z_\-]{35}'),
  RegExp(r'(bearer\s+)[a-zA-Z0-9_\-\.]{8,}', caseSensitive: false),
  RegExp(
    r'((?:api[_-]?key|secret|token|password)\s*[:=]\s*)[^\s,;&"\\]+',
    caseSensitive: false,
  ),
];

/// Extracts a human-readable, actionable error message from an AI provider's
/// HTTP error response body.
///
/// Supports schemas from Gemini, Anthropic, OpenAI, Azure OpenAI, Ollama,
/// generic JSON, FastAPI, HTML gateway errors, malformed JSON, and plain text.
String extractGenAIErrorMessage(String responseBody, int statusCode) {
  final trimmed = responseBody.trim();
  if (trimmed.isEmpty) {
    return 'HTTP $statusCode error';
  }

  // 1. Detect if the response body is an HTML document or markup block
  if (_looksLikeHtml(trimmed)) {
    return 'HTTP $statusCode error';
  }

  // 2. Attempt JSON extraction
  String? extractedMessage;
  try {
    final decoded = jsonDecode(trimmed);
    if (decoded is Map) {
      extractedMessage = _extractMessageFromMap(decoded);
    }
  } catch (_) {
    // Malformed JSON falls through safely to plain text handling
  }

  // 3. Fallback to raw text if no JSON error field was identified
  final rawMessage = extractedMessage ?? trimmed;

  // 4. Strip any stray HTML tags
  String sanitized = _stripHtmlTags(rawMessage);
  if (sanitized.isEmpty) {
    return 'HTTP $statusCode error';
  }

  // 5. Redact any credentials accidentally reflected in error responses
  sanitized = _redactCredentials(sanitized);

  // 6. Truncate excessively long messages
  if (sanitized.length > kMaxErrorMessageLength) {
    sanitized = '${sanitized.substring(0, kMaxErrorMessageLength)}...';
  }

  // 7. If an explicit error message was extracted from JSON, return it
  if (extractedMessage != null) {
    return sanitized;
  }

  // 8. If fallback plain text already starts with "HTTP $statusCode", return as-is
  if (sanitized.startsWith('HTTP $statusCode')) {
    return sanitized;
  }

  // 9. Standard fallback with HTTP status code preserved
  return 'HTTP $statusCode: $sanitized';
}

/// Inspects common error keys in decoded JSON maps.
String? _extractMessageFromMap(Map map) {
  // 1. Gemini, Anthropic, OpenAI, Azure OpenAI: {"error": {"message": "..."}}
  // or Ollama: {"error": "..."}
  if (map.containsKey('error')) {
    final error = map['error'];
    if (error is Map) {
      final msg = error['message'];
      if (msg is String && msg.trim().isNotEmpty) {
        return msg.trim();
      }
    } else if (error is String && error.trim().isNotEmpty) {
      return error.trim();
    }
  }

  // 2. Generic REST: {"message": "..."}
  if (map.containsKey('message')) {
    final msg = map['message'];
    if (msg is String && msg.trim().isNotEmpty) {
      return msg.trim();
    }
  }

  // 3. FastAPI: {"detail": "..."} or {"detail": [{"msg": "..."}]}
  if (map.containsKey('detail')) {
    final detail = map['detail'];
    if (detail is String && detail.trim().isNotEmpty) {
      return detail.trim();
    } else if (detail is List && detail.isNotEmpty && detail.first is Map) {
      final msg = detail.first['msg'];
      if (msg is String && msg.trim().isNotEmpty) {
        return msg.trim();
      }
    }
  }

  return null;
}

/// Determines if a string appears to be an HTML document or markup block.
bool _looksLikeHtml(String text) {
  final lower = text.toLowerCase();
  return lower.startsWith('<!doctype html') ||
      lower.startsWith('<html') ||
      (lower.startsWith('<') && lower.endsWith('>') && lower.contains('</'));
}

/// Removes HTML tags and collapses redundant whitespace.
String _stripHtmlTags(String text) {
  return text
      .replaceAll(_kHtmlTagRegex, ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

/// Redacts sensitive tokens or keys from the error string.
String _redactCredentials(String text) {
  var result = text;
  for (final regex in _kCredentialRedactionRegexes) {
    result = result.replaceAllMapped(regex, (match) {
      final fullMatch = match.group(0)!;
      // If regex has a capturing prefix (e.g. "Bearer " or "api_key="), preserve prefix
      if (match.groupCount >= 1 && match.group(1) != null) {
        return '${match.group(1)}***';
      }
      // For OpenAI sk-... prefix, keep 'sk-' and mask the rest
      if (fullMatch.startsWith('sk-') || fullMatch.startsWith('SK-')) {
        return 'sk-***';
      }
      // For Google AIza... prefix, keep 'AIza' and mask the rest
      if (fullMatch.startsWith('AIza')) {
        return 'AIza***';
      }
      return '***';
    });
  }
  return result;
}
