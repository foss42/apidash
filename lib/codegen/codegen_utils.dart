/// Converts a JSON string into a Python dict literal, keeping the original
/// formatting. Only the `null`, `true` and `false` literals outside of strings
/// are replaced, so string values are never changed.
String jsonToPyDict(String jsonString) {
  const replaceWithMap = {"null": "None", "true": "True", "false": "False"};
  final keywordPattern = RegExp(r'null|true|false');
  final result = StringBuffer();
  var i = 0;
  while (i < jsonString.length) {
    final char = jsonString[i];
    if (char == '"') {
      result.write(char);
      i++;
      while (i < jsonString.length && jsonString[i] != '"') {
        if (jsonString[i] == r'\' && i + 1 < jsonString.length) {
          // `\/` is a valid JSON escape but not a Python one
          result.write(
            jsonString[i + 1] == '/' ? '/' : jsonString.substring(i, i + 2),
          );
          i += 2;
        } else {
          result.write(jsonString[i]);
          i++;
        }
      }
      if (i < jsonString.length) {
        result.write('"');
        i++;
      }
      continue;
    }
    final keyword = keywordPattern.matchAsPrefix(jsonString, i);
    if (keyword != null) {
      result.write(replaceWithMap[keyword[0]]);
      i = keyword.end;
      continue;
    }
    result.write(char);
    i++;
  }
  return result.toString();
}

/// Returns [value] as a Python string literal delimited by [quote].
String pyStringLiteral(String value, {String quote = "'"}) {
  final result = StringBuffer(quote);
  for (final rune in value.runes) {
    final char = String.fromCharCode(rune);
    if (char == r'\') {
      result.write(r'\\');
    } else if (char == quote) {
      result.write('\\$quote');
    } else if (char == '\n') {
      result.write(r'\n');
    } else if (char == '\r') {
      result.write(r'\r');
    } else if (char == '\t') {
      result.write(r'\t');
    } else if (rune < 0x20 || rune == 0x7f) {
      result.write('\\x${rune.toRadixString(16).padLeft(2, '0')}');
    } else {
      result.write(char);
    }
  }
  result.write(quote);
  return result.toString();
}

/// Returns [value] as a raw triple-quoted Python string when that keeps it
/// unchanged, otherwise falls back to an escaped [pyStringLiteral].
String pyMultilineStringLiteral(String value) {
  final canUseRawString =
      !value.contains("'''") &&
      !value.endsWith("'") &&
      !value.endsWith(r'\') &&
      !value.contains('\r');
  return canUseRawString ? "r'''$value'''" : pyStringLiteral(value);
}

/// Returns [value] as a JavaScript string literal delimited by [quote].
String jsStringLiteral(String value, {String quote = "'"}) {
  final result = StringBuffer(quote);
  for (final rune in value.runes) {
    final char = String.fromCharCode(rune);
    if (char == r'\') {
      result.write(r'\\');
    } else if (char == quote) {
      result.write('\\$quote');
    } else if (char == '\n') {
      result.write(r'\n');
    } else if (char == '\r') {
      result.write(r'\r');
    } else if (char == '\t') {
      result.write(r'\t');
    } else if (rune < 0x20 || rune == 0x7f) {
      result.write('\\x${rune.toRadixString(16).padLeft(2, '0')}');
    } else if (rune == 0x2028 || rune == 0x2029) {
      // line terminators that end a string literal in pre-ES2019 engines
      result.write('\\u${rune.toRadixString(16)}');
    } else {
      result.write(char);
    }
  }
  result.write(quote);
  return result.toString();
}

/// Returns [value] as a double-quoted Java string literal.
String javaStringLiteral(String value) {
  final result = StringBuffer('"');
  for (final rune in value.runes) {
    final char = String.fromCharCode(rune);
    if (char == r'\') {
      result.write(r'\\');
    } else if (char == '"') {
      result.write(r'\"');
    } else if (char == '\n') {
      result.write(r'\n');
    } else if (char == '\r') {
      result.write(r'\r');
    } else if (char == '\t') {
      result.write(r'\t');
    } else if (rune < 0x20 || rune == 0x7f) {
      // octal, because javac turns unicode escapes into raw characters
      // before parsing, so a `\u000a` would end the literal
      result.write('\\${rune.toRadixString(8).padLeft(3, '0')}');
    } else {
      result.write(char);
    }
  }
  result.write('"');
  return result.toString();
}

/// Returns [value] as a Java text block when that keeps it unchanged,
/// otherwise falls back to an escaped [javaStringLiteral].
///
/// Text blocks strip trailing spaces on each line and the indentation shared
/// by all lines, and end at the first `"""`, so those cases are not safe.
String javaTextBlock(String value) {
  final lines = value.split('\n');
  final hasUnsafeCharacter = value.runes.any(
    (rune) => (rune < 0x20 && rune != 0x0a && rune != 0x09) || rune == 0x7f,
  );
  final hasTrailingWhitespace = lines.any(
    (line) => line.endsWith(' ') || line.endsWith('\t'),
  );
  final hasSharedIndentation =
      lines.any((line) => line.isNotEmpty) &&
      lines
          .where((line) => line.isNotEmpty)
          .every((line) => line.startsWith(' ') || line.startsWith('\t'));
  if (value.contains('"""') ||
      value.endsWith('"') ||
      hasUnsafeCharacter ||
      hasTrailingWhitespace ||
      hasSharedIndentation) {
    return javaStringLiteral(value);
  }
  return '"""\n${value.replaceAll(r'\', r'\\')}"""';
}

/// Returns [value] as a double-quoted Kotlin string literal.
String kotlinStringLiteral(String value) {
  final result = StringBuffer('"');
  for (final rune in value.runes) {
    final char = String.fromCharCode(rune);
    if (char == r'\') {
      result.write(r'\\');
    } else if (char == '"') {
      result.write(r'\"');
    } else if (char == r'$') {
      result.write(r'\$');
    } else if (char == '\n') {
      result.write(r'\n');
    } else if (char == '\r') {
      result.write(r'\r');
    } else if (char == '\t') {
      result.write(r'\t');
    } else if (rune < 0x20 || rune == 0x7f) {
      result.write('\\u${rune.toRadixString(16).padLeft(4, '0')}');
    } else {
      result.write(char);
    }
  }
  result.write('"');
  return result.toString();
}

/// Returns [value] as a Kotlin raw string when that keeps it unchanged,
/// otherwise falls back to an escaped [kotlinStringLiteral].
///
/// Raw strings have no escapes, so a `$` that would start a string template
/// is written as `${'$'}`.
String kotlinRawStringLiteral(String value) {
  final hasUnsafeCharacter = value.runes.any(
    (rune) => (rune < 0x20 && rune != 0x0a && rune != 0x09) || rune == 0x7f,
  );
  if (value.contains('"""') || value.endsWith('"') || hasUnsafeCharacter) {
    return kotlinStringLiteral(value);
  }
  final escaped = value.replaceAllMapped(
    RegExp(r'\$(?=[\p{L}_{`])', unicode: true),
    (_) => r"${'$'}",
  );
  return '"""$escaped"""';
}
