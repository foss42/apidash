import 'package:apidash_core/apidash_core.dart' show APIType, HTTPVerb;
import '../enums.dart';
import 'body_chunk.dart';

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
