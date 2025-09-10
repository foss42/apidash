import 'package:apidash_core/apidash_core.dart' show APIType, HTTPVerb;

/// Source category of a terminal entry
enum TerminalSource { network, js, system }

/// Severity level of a terminal entry
enum TerminalLevel { debug, info, warn, error }

/// Phase of a network log lifecycle
enum NetworkPhase { started, progress, completed, failed }

class BodyChunk {
  BodyChunk({required this.ts, required this.text, required this.sizeBytes});

  final DateTime ts;
  final String text; // preview text (could be partial)
  final int sizeBytes;
}

class NetworkLogData {
  NetworkLogData({
    required this.phase,
    required this.apiType,
    required this.method,
    required this.url,
    this.requestHeaders,
    this.requestBodyPreview,
    this.responseStatus,
    this.responseHeaders,
    this.responseBodyPreview,
    this.duration,
    this.isStreaming = false,
    this.sentAt,
    this.completedAt,
    this.errorMessage,
    List<BodyChunk>? chunks,
  }) : chunks = chunks ?? <BodyChunk>[];

  final NetworkPhase phase;
  final APIType apiType;
  final HTTPVerb method;
  final String url;
  final Map<String, String>? requestHeaders;
  final String? requestBodyPreview;
  final int? responseStatus;
  final Map<String, String>? responseHeaders;
  final String? responseBodyPreview;
  final Duration? duration;
  final bool isStreaming;
  final DateTime? sentAt;
  final DateTime? completedAt;
  final String? errorMessage;
  final List<BodyChunk> chunks;

  NetworkLogData copyWith({
    NetworkPhase? phase,
    APIType? apiType,
    HTTPVerb? method,
    String? url,
    Map<String, String>? requestHeaders,
    String? requestBodyPreview,
    int? responseStatus,
    Map<String, String>? responseHeaders,
    String? responseBodyPreview,
    Duration? duration,
    bool? isStreaming,
    DateTime? sentAt,
    DateTime? completedAt,
    String? errorMessage,
    List<BodyChunk>? chunks,
  }) {
    return NetworkLogData(
      phase: phase ?? this.phase,
      apiType: apiType ?? this.apiType,
      method: method ?? this.method,
      url: url ?? this.url,
      requestHeaders: requestHeaders ?? this.requestHeaders,
      requestBodyPreview: requestBodyPreview ?? this.requestBodyPreview,
      responseStatus: responseStatus ?? this.responseStatus,
      responseHeaders: responseHeaders ?? this.responseHeaders,
      responseBodyPreview: responseBodyPreview ?? this.responseBodyPreview,
      duration: duration ?? this.duration,
      isStreaming: isStreaming ?? this.isStreaming,
      sentAt: sentAt ?? this.sentAt,
      completedAt: completedAt ?? this.completedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      chunks: chunks ?? this.chunks,
    );
  }
}

class JsLogData {
  JsLogData({
    required this.level,
    required this.args,
    this.stack,
    this.context,
    this.contextRequestId,
  });

  final String level; // log | warn | error | fatal
  final List<String> args;
  final String? stack;
  final String? context; // preRequest | postResponse | global
  final String? contextRequestId;
}

class SystemLogData {
  SystemLogData({required this.category, required this.message, this.stack});
  final String category; // ui | provider | io | storage | unknown
  final String message;
  final String? stack;
}

class TerminalEntry {
  TerminalEntry({
    required this.id,
    required this.ts,
    required this.source,
    required this.level,
    this.requestId,
    this.correlationId,
    this.tags = const <String>[],
    this.network,
    this.js,
    this.system,
  });

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
