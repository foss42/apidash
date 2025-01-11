// lib/src/hurl_parser.dart

import 'dart:convert';
import '../src/rust/frb_generated.dart';
import '../src/rust/api/simple.dart';
import 'models/hurl_file.dart';

/// Main class for parsing Hurl files
class HurlParser {
  static HurlParser? _instance;
  static bool _initialized = false;

  HurlParser._();

  /// Gets the singleton instance of HurlParser
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
  HurlFile parse(String content) {
    if (!_initialized) {
      throw StateError('HurlParser not initialized. Call getInstance() first.');
    }

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
  String parseToJson(String content) {
    if (!_initialized) {
      throw StateError('HurlParser not initialized. Call getInstance() first.');
    }

    return parseHurlToJson(content: content);
  }
}
