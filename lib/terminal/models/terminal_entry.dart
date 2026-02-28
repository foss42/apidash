import '../enums.dart';
import 'network_log_data.dart';
import 'js_log_data.dart';
import 'system_log_data.dart';

class TerminalEntry {
  TerminalEntry({
    required this.id,
    DateTime? ts,
    required this.source,
    required this.level,
    this.requestId,
    this.correlationId,
    this.tags = const <String>[],
    this.network,
    this.js,
    this.system,
  }) : ts = ts ?? DateTime.now();

  final String id;
  final DateTime ts;
  final TerminalSource source;
  final TerminalLevel level;
  final String? requestId; // App request id for correlation
  final String? correlationId; // Additional correlation if any
  final List<String> tags;
  final NetworkLogData? network;
  final JsLogData? js;
  final SystemLogData? system;

  TerminalEntry copyWith({
    DateTime? ts,
    TerminalSource? source,
    TerminalLevel? level,
    String? requestId,
    String? correlationId,
    List<String>? tags,
    NetworkLogData? network,
    JsLogData? js,
    SystemLogData? system,
  }) {
    return TerminalEntry(
      id: id,
      ts: ts ?? this.ts,
      source: source ?? this.source,
      level: level ?? this.level,
      requestId: requestId ?? this.requestId,
      correlationId: correlationId ?? this.correlationId,
      tags: tags ?? this.tags,
      network: network ?? this.network,
      js: js ?? this.js,
      system: system ?? this.system,
    );
  }
}
