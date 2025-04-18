import 'log_entry.dart';

class WorkflowLogEntry extends LogEntry {
  WorkflowLogEntry({
    required String message,
    required LogLevel level,
    DateTime? timestamp,
    String? nodeId,
    String? details,
  }) : super(
          message: message,
          level: level,
          timestamp: timestamp,
          nodeId: nodeId,
          details: details,
        );

  @override
  String toString() {
    return '[$level] ${timestamp.toIso8601String()}: $message';
  }
}
