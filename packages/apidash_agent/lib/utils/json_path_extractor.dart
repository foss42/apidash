import 'dart:convert';

// Simple JSONPath extractor supporting:
// $.fieldName            → top-level field
// $.nested.field         → nested field
// $.array[0].field       → array index access
class JsonPathExtractor {
  static dynamic extract(String path, String responseBody) {
    try {
      final json = jsonDecode(responseBody);
      return _traverse(path, json);
    } catch (_) {
      return null;
    }
  }

  static dynamic _traverse(String path, dynamic json) {
    // Strip leading '$.'
    final cleaned = path.startsWith(r'$.') ? path.substring(2) : path;
    final parts = _parseParts(cleaned);

    dynamic current = json;
    for (final part in parts) {
      if (current == null) return null;

      // Array index access: e.g. items[0]
      final arrayMatch = RegExp(r'^(\w+)\[(\d+)\]$').firstMatch(part);
      if (arrayMatch != null) {
        final key = arrayMatch.group(1)!;
        final index = int.parse(arrayMatch.group(2)!);
        current = current[key];
        if (current is List && index < current.length) {
          current = current[index];
        } else {
          return null;
        }
      } else {
        // Map key or list index
        if (current is Map) {
          current = current[part];
        } else if (current is List) {
          final index = int.tryParse(part);
          if (index != null && index < current.length) {
            current = current[index];
          } else {
            return null;
          }
        } else {
          return null;
        }
      }
    }
    return current;
  }

  // Splits "a.b.c" into ["a", "b", "c"] respecting array notation
  static List<String> _parseParts(String path) {
    return path.split('.').where((p) => p.isNotEmpty).toList();
  }
}