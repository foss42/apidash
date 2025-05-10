import 'package:flutter/material.dart';

/// Log level enum for categorizing log entries
enum LogLevel { 
  debug,
  info, 
  success, 
  warning, 
  error,
}

/// Model for workflow log entries
class LogEntry {
  final String message;
  final LogLevel level;
  final DateTime timestamp;
  final String? nodeId;
  final String? details;

  LogEntry({
    required this.message,
    this.level = LogLevel.info,
    DateTime? timestamp,
    this.nodeId,
    this.details,
  }) : timestamp = timestamp ?? DateTime.now();

  Color getColor() {
    switch (level) {
      case LogLevel.info:
        return Colors.blue;
      case LogLevel.success:
        return Colors.green;
      case LogLevel.warning:
        return Colors.orange;
      case LogLevel.error:
        return Colors.red;
      case LogLevel.debug:
        return Colors.grey;
    }
  }

  IconData getIcon() {
    switch (level) {
      case LogLevel.info:
        return Icons.info_outline;
      case LogLevel.success:
        return Icons.check_circle_outline;
      case LogLevel.warning:
        return Icons.warning_amber_outlined;
      case LogLevel.error:
        return Icons.error_outline;
      case LogLevel.debug:
        return Icons.code;
    }
  }
}
