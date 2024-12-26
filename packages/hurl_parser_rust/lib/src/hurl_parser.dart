import 'package:hurl_parser_rust/src/rust/frb_generated.dart';
import 'package:hurl_parser_rust/src/rust/api/simple.dart';

/// A Dart wrapper for the Rust-based Hurl parser
class HurlParser {
  static HurlParser? _instance;
  static bool _initialized = false;

  // Private constructor
  HurlParser._();

  /// Gets the singleton instance of HurlParser, initializing if necessary
  static Future<HurlParser> getInstance() async {
    if (_instance == null) {
      _instance = HurlParser._();
      if (!_initialized) {
        await RustLib.init();
        _initialized = true;
      }
    }
    return _instance!;
  }

  /// Parses a Hurl file content and returns its JSON representation
  ///
  /// Args:
  ///   input: String containing the Hurl file content
  ///
  /// Returns:
  ///   A JSON string representing the parsed Hurl content
  ///
  /// Throws:
  ///   StateError if parser is not initialized
  ///   String if parsing fails
  String parseHurl(String input) {
    if (!_initialized) {
      throw StateError('HurlParser not initialized. Call getInstance() first.');
    }
    return parseHurlToJson(content: input);
  }
}
