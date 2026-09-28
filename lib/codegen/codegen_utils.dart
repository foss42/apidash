import 'dart:convert';

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

/// Returns [value] as a Go interpreted string literal.
///
/// Every escape that JSON produces is also a Go escape with the same
/// meaning, so a JSON string is a valid Go string.
String goStringLiteral(String value) => jsonEncode(value);

/// Returns [value] as a Go raw string when that keeps it unchanged,
/// otherwise falls back to [goStringLiteral].
///
/// Raw strings cannot contain a backtick, and Go drops carriage returns
/// from them.
String goRawStringLiteral(String value) {
  if (value.contains('`') || value.contains('\r')) {
    return goStringLiteral(value);
  }
  return '`$value`';
}

/// Returns [value] as a double-quoted C string literal.
String cStringLiteral(String value) {
  final result = StringBuffer('"');
  var previous = '';
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
    } else if (char == '?' && previous == '?') {
      // `??` followed by some characters is a trigraph in older C standards
      result.write(r'\?');
    } else if (rune < 0x20 || rune == 0x7f) {
      // octal, because a `\x` escape would also swallow any hex digits
      // that follow it
      result.write('\\${rune.toRadixString(8).padLeft(3, '0')}');
    } else {
      result.write(char);
    }
    previous = char;
  }
  result.write('"');
  return result.toString();
}

/// Returns [value] as a regular (non-verbatim) C# string literal.
String csharpStringLiteral(String value) {
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
    } else if (rune < 0x20 ||
        rune == 0x7f ||
        rune == 0x85 ||
        rune == 0x2028 ||
        rune == 0x2029) {
      // C# also treats U+0085, U+2028 and U+2029 as line breaks, which
      // cannot appear inside a regular string literal
      result.write('\\u${rune.toRadixString(16).padLeft(4, '0')}');
    } else {
      result.write(char);
    }
  }
  result.write('"');
  return result.toString();
}

/// Returns [value] as a multi-line C# raw string literal, with the opening
/// and closing quotes on their own lines.
///
/// The delimiter is one quote longer than the longest run of quotes in
/// [value], so the value can contain `"""`. Falls back to
/// [csharpStringLiteral] when a raw string cannot hold it exactly.
String csharpRawStringLiteral(String value) {
  final hasUnsafeCharacter = value.runes.any(
    (rune) =>
        (rune < 0x20 && rune != 0x0a && rune != 0x09) ||
        rune == 0x7f ||
        rune == 0x85 ||
        rune == 0x2028 ||
        rune == 0x2029,
  );
  if (hasUnsafeCharacter) {
    return csharpStringLiteral(value);
  }
  final longestQuoteRun = RegExp(r'"+')
      .allMatches(value)
      .fold(
        0,
        (longest, match) =>
            match[0]!.length > longest ? match[0]!.length : longest,
      );
  final quotes = '"' * (longestQuoteRun < 3 ? 3 : longestQuoteRun + 1);
  return '$quotes\n$value\n$quotes';
}
