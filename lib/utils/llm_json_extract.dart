class LlmJsonExtract {
  LlmJsonExtract._();

  /// extract JSON from LLM text.
  static String? tryExtractJson(String text) {
    final fenced = _extractMarkdownFence(text);
    if (fenced != null) return fenced.trim();

    final balanced = _extractBalancedJson(text);
    if (balanced != null) return balanced.trim();

    return null;
  }

  static String? _extractMarkdownFence(String text) {
    final fence = RegExp(
      r'```(?:json)?\s*([\s\S]*?)\s*```',
      caseSensitive: false,
    );

    final m = fence.firstMatch(text);
    if (m == null) return null;
    final inner = m.group(1);
    if (inner == null) return null;

    final trimmedLeft = inner.trimLeft();
    if (!(trimmedLeft.startsWith('{') || trimmedLeft.startsWith('['))) {
      return null;
    }
    return inner;
  }

  // Find the first balanced {...} or [...] substring and return it, or null.
  static String? _extractBalancedJson(String text) {
    final startObj = text.indexOf('{');
    final startArr = text.indexOf('[');
    int start;
    if (startObj == -1 && startArr == -1) return null;
    if (startObj == -1) {
      start = startArr;
    } else if (startArr == -1) {
      start = startObj;
    } else {
      start = startObj < startArr ? startObj : startArr;
    }

    final String open = text[start];
    final String close = open == '{' ? '}' : ']';

    int depth = 0;
    bool inString = false;
    bool escape = false;

    for (var i = start; i < text.length; i++) {
      final ch = text[i];

      if (inString) {
        if (escape) {
          escape = false;
        } else if (ch == '\\') {
          // start escape sequence inside string
          escape = true;
        } else if (ch == '"') {
          inString = false;
        }
        continue;
      }

      if (ch == '"') {
        inString = true;
        continue;
      }

      if (ch == open) depth++;
      if (ch == close) depth--;

      if (depth == 0) {
        return text.substring(start, i + 1);
      }
    }

    return null;
  }
}
