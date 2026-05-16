class WorkflowNodeRunOutput {
  const WorkflowNodeRunOutput({
    required this.requestId,
    required this.statusCode,
    required this.timeMs,
    required this.responseBody,
  });

  final String requestId;
  final int? statusCode;
  final int? timeMs;
  final String? responseBody;
}

class WorkflowRunRecord {
  const WorkflowRunRecord({
    required this.startedAt,
    required this.endedAt,
    required this.success,
    this.error,
    required this.nodeCount,
  });

  final DateTime startedAt;
  final DateTime endedAt;
  final bool success;
  final String? error;
  final int nodeCount;

  int get durationMs => endedAt.difference(startedAt).inMilliseconds;

  Map<String, dynamic> toJson() => {
        'startedAt': startedAt.toIso8601String(),
        'endedAt': endedAt.toIso8601String(),
        'success': success,
        'error': error,
        'nodeCount': nodeCount,
      };

  factory WorkflowRunRecord.fromJson(Map<String, dynamic> json) =>
      WorkflowRunRecord(
        startedAt: DateTime.parse(json['startedAt'] as String),
        endedAt: DateTime.parse(json['endedAt'] as String),
        success: json['success'] as bool? ?? false,
        error: json['error'] as String?,
        nodeCount: (json['nodeCount'] as num?)?.toInt() ?? 0,
      );
}
