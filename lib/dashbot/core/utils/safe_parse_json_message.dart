import 'dart:convert';

/// Lightweight JSON parser helper to avoid adding dependencies.
/// Intended for parsing AI agent structured outputs that may be wrapped
/// in markdown code fences or include extra prose.
class MessageJson {
  static Map<String, dynamic> safeParse(String input) {
    // Try strict JSON first
    try {
      return _parseJson(input);
    } catch (_) {
      // If input looks like markdown fenced block containing JSON, try to extract
      final start = input.indexOf('{');
      final end = input.lastIndexOf('}');
      if (start != -1 && end != -1 && end > start) {
        final slice = input.substring(start, end + 1);
        return _parseJson(slice);
      }
      rethrow;
    }
  }

  static Map<String, dynamic> _parseJson(String s) {
    final decoded = jsonDecode(s);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return {};
  }
}
