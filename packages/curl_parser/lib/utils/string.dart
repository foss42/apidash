import 'package:shlex/shlex.dart' as shlex;

/// Splits a cURL command into tokens suitable for ArgParser.
///
/// - Normalizes backslash-newline continuations and CRLF endings.
/// - Removes stray '+' concatenation artifacts from some shells.
/// - Uses shlex to respect quoted strings.
List<String> splitAsCommandLineArgs(String command) {
  // Normalize common shell continuations: backslash + newline
  var normalized = command
      .replaceAll(RegExp(r"\\\s*\r?\n"), ' ')
      .replaceAll('\r', '')
      .trim();
  // Remove stray '+' line concatenation tokens if present in copied shells
  normalized = normalized.replaceAll(RegExp(r"\s\+\s*\n?"), ' ');
  return shlex.split(normalized);
}

/// Removes surrounding quotes from a url/string token.
String? clean(String? url) {
  if (url == null || url.length < 2) return url;
  final first = url[0];
  if ((first == '"' || first == "'") && url.endsWith(first)) {
    return url.substring(1, url.length - 1);
  }
  return url;
}

/// Provides `firstOrNull` for lists.
extension FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
