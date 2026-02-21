import 'dart:convert';

/// Lightweight JSON parser helper to avoid adding dependencies.
/// Intended for parsing AI agent structured outputs that may be wrapped
/// in markdown code fences or include extra prose.
class MessageJson {
  static Map<String, dynamic> safeParse(String input) {
    // Try strict JSON first
    try {
      return _parseJson(input);
    } catch (_) {}

    // Walk the string using a depth counter to find the outermost { ... }
    // block. Using lastIndexOf('}') is NOT safe because the generated code
    // inside the "value" field often contains braces of its own.
    final start = input.indexOf('{');
    if (start == -1) return {};

    int depth = 0;
    bool inString = false;
    bool escaped = false;

    for (int i = start; i < input.length; i++) {
      final ch = input[i];
      if (escaped) {
        escaped = false;
        continue;
      }
      if (ch == r'\' && inString) {
        escaped = true;
        continue;
      }
      if (ch == '"') {
        inString = !inString;
        continue;
      }
      if (inString) continue;

      if (ch == '{') {
        depth++;
      } else if (ch == '}') {
        depth--;
        if (depth == 0) {
          final slice = input.substring(start, i + 1);
          try {
            return _parseJson(slice);
          } catch (_) {
            return {};
          }
        }
      }
    }
    return {};
  }

  static Map<String, dynamic> _parseJson(String s) {
    final decoded = jsonDecode(s);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return {};
  }
}
