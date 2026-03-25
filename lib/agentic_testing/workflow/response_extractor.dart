import 'dart:convert';
import '../execution/execution_response.dart';

/// Extracts a value from an ExecutionResponse using a dot-path string.
///
/// Supported path prefixes:
///   body.<dot.path>   → navigates JSON response body using dot notation
///   header.<Name>     → reads a response header by name (case-insensitive)
class ResponseExtractor {
  const ResponseExtractor();

  /// Returns the extracted value as a String, or null if not found.
  dynamic extract(ExecutionResponse response, String path) {
    if (path.startsWith('body.')) {
      return _fromBody(response.body, path.substring(5));
    } else if (path.startsWith('header.')) {
      final headerName = path.substring(7).toLowerCase();
      final match = response.headers?.entries.firstWhere(
        (e) => e.key.toLowerCase() == headerName,
        orElse: () => const MapEntry('', ''),
      );
      return match?.value.isEmpty == true ? null : match?.value;
    }
    return null;
  }

  dynamic _fromBody(String? body, String dotPath) {
    if (body == null || body.trim().isEmpty) return null;
    try {
      dynamic current = jsonDecode(body);
      for (final segment in dotPath.split('.')) {
        if (current is Map) {
          current = current[segment];
        } else if (current is List) {
          final index = int.tryParse(segment);
          if (index != null && index < current.length) {
            current = current[index];
          } else {
            return null;
          }
        } else {
          return null;
        }
        if (current == null) return null;
      }
      return current;
    } catch (_) {
      return null;
    }
  }
}
