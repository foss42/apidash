// lib/src/parser.dart

import 'package:hurl_parser/src/models/common/errors.dart';
import 'package:petitparser/petitparser.dart';

// Import base grammar
import 'grammar/base_grammar.dart';

// Import models
import 'models/hurl_file.dart';
import 'models/entry.dart';
import 'models/request.dart';
import 'models/response.dart';

class HurlParser {
  final Parser _parser;
  final HurlGrammar _grammar;

  /// Create a new HurlParser instance
  HurlParser()
      : _grammar = HurlGrammar(),
        _parser = HurlGrammar().build();

  /// Parse a Hurl file string and return a HurlFile model
  Result<HurlFile> parseHurlFile(String input) {
    final result = _parser.parse(input);
    if (result is Success) {
      return Result.success(_convertToHurlFile(result.value));
    } else {
      return Result.failure(ParseError(
        message: result.message,
        position: result.position,
        source: input,
      ));
    }
  }

  /// Parse a single entry (request/response pair)
  Result<Entry> parseEntry(String input) {
    // Create a parser specifically for entries
    final entryParser = _grammar.buildFrom(_grammar.entry()).end();
    final result = entryParser.parse(input);
    if (result is Success) {
      return Result.success(_convertToEntry(result.value));
    } else {
      return Result.failure(ParseError(
        message: result.message,
        position: result.position,
        source: input,
      ));
    }
  }

  /// Parse a request section
  Result<Request> parseRequest(String input) {
    // Create a parser specifically for requests
    final requestParser = _grammar.buildFrom(_grammar.request()).end();
    final result = requestParser.parse(input);
    if (result is Success) {
      return Result.success(_convertToRequest(result.value));
    } else {
      return Result.failure(ParseError(
        message: result.message,
        position: result.position,
        source: input,
      ));
    }
  }

  /// Parse a response section
  Result<Response> parseResponse(String input) {
    // Create a parser specifically for responses
    final responseParser = _grammar.buildFrom(_grammar.response()).end();
    final result = responseParser.parse(input);
    if (result is Success) {
      return Result.success(_convertToResponse(result.value));
    } else {
      return Result.failure(ParseError(
        message: result.message,
        position: result.position,
        source: input,
      ));
    }
  }

  // Conversion methods from parse results to models
  HurlFile _convertToHurlFile(dynamic value) {
    final List<Map<String, dynamic>> entries = value[0];
    return HurlFile(
      entries: entries.map((e) => Entry.fromJson(e)).toList(),
    );
  }

  Entry _convertToEntry(dynamic value) {
    return Entry.fromJson(value);
  }

  Request _convertToRequest(dynamic value) {
    return Request.fromJson(value);
  }

  Response _convertToResponse(dynamic value) {
    return Response.fromJson(value);
  }
}

/// Result class for handling parse results
class Result<T> {
  final T? value;
  final ParseError? error;
  final bool isSuccess;

  const Result.success(this.value)
      : error = null,
        isSuccess = true;

  const Result.failure(this.error)
      : value = null,
        isSuccess = false;
}
