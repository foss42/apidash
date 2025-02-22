import 'dart:convert';
import 'dart:developer' as developer;
import 'har.dart';

class HarParserImpl {
  /// Parses the HAR [content] and returns a list of [HarEntry] objects.
  static List<HarEntry>? getRequestEntries(String content) {
    try {
      developer.log("Starting HAR parsing...", name: "HarParserImpl");
      final harJson = jsonDecode(content) as Map<String, dynamic>;
      final har = Har.fromJson(harJson);
      developer.log("Parsed ${har.entries.length} entries from HAR.", name: "HarParserImpl");
      return har.entries;
    } catch (e, s) {
      developer.log("Failed to parse HAR file: $e", name: "HarParserImpl", error: e, stackTrace: s);
      return null;
    }
  }
}