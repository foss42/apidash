import 'package:flutter/foundation.dart';

@immutable
class GenAIException implements Exception {
  final String message;
  final int? statusCode;
  final String? details;

  const GenAIException(this.message, {this.statusCode, this.details});

  @override
  String toString() {
    if (statusCode != null) {
      return 'GenAIException ($statusCode): $message';
    }
    return 'GenAIException: $message';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenAIException &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          statusCode == other.statusCode &&
          details == other.details;

  @override
  int get hashCode => Object.hash(message, statusCode, details);
}
