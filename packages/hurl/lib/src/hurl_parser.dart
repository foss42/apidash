import 'dart:convert';
import '../src/rust/frb_generated.dart';
import '../src/rust/api/simple.dart';
import 'models/hurl_file.dart';

/// Main class for parsing Hurl files
class HurlParser {
  /// Whether the Rust library has been initialized
  static bool _isLibInitialized = false;

  /// Initializes the Rust library required for parsing
  ///
  /// This must be called before using any parsing functions
  ///
  /// Throws:
  ///   [StateError] if already initialized
  static Future<void> initialize() async {
    if (_isLibInitialized) {
      throw StateError('HurlParser is already initialized');
    }
    await RustLib.init();
    _isLibInitialized = true;
  }

  /// Checks if the library is initialized and throws if not
  static void _checkInitialization() {
    if (!_isLibInitialized) {
      throw StateError(
          'HurlParser not initialized. Call HurlParser.initialize() first.');
    }
  }

  /// Parses a Hurl file content into a [HurlFile] object
  ///
  /// Args:
  ///   content: The Hurl file content as a string
  ///
  /// Returns:
  ///   A [HurlFile] object representing the parsed content
  ///
  /// Throws:
  ///   [StateError] if parser is not initialized
  ///   [FormatException] if parsing fails
  static HurlFile parse(String content) {
    _checkInitialization();
    final jsonString = parseHurlToJson(content: content);
    return HurlFile.fromJson(jsonDecode(jsonString));
  }

  /// Parses a Hurl file content and returns the raw JSON string
  ///
  /// This is useful if you want to handle the JSON parsing yourself
  ///
  /// Args:
  ///   content: The Hurl file content as a string
  ///
  /// Returns:
  ///   A JSON string representing the parsed content
  ///
  /// Throws:
  ///   [StateError] if parser is not initialized
  static String parseToJson(String content) {
    _checkInitialization();
    return parseHurlToJson(content: content);
  }
}
