import 'package:apidash_core/apidash_core.dart';

enum DashboardTab { collections, workflows }

enum DashboardTimeRange {
  hours24,
  days7,
  days30,
  all,
}

extension DashboardTimeRangeX on DashboardTimeRange {
  String get label => switch (this) {
        DashboardTimeRange.hours24 => '24h',
        DashboardTimeRange.days7 => '7d',
        DashboardTimeRange.days30 => '30d',
        DashboardTimeRange.all => 'All',
      };

  DateTime? get since {
    final now = DateTime.now();
    return switch (this) {
      DashboardTimeRange.hours24 => now.subtract(const Duration(hours: 24)),
      DashboardTimeRange.days7 => now.subtract(const Duration(days: 7)),
      DashboardTimeRange.days30 => now.subtract(const Duration(days: 30)),
      DashboardTimeRange.all => null,
    };
  }
}

class EndpointStat {
  const EndpointStat({
    required this.url,
    required this.count,
    required this.avgMs,
    required this.failCount,
  });

  final String url;
  final int count;
  final int? avgMs;
  final int failCount;
}

class TimedRequestStat {
  const TimedRequestStat({
    required this.historyId,
    required this.name,
    required this.url,
    required this.method,
    required this.status,
    required this.timeStamp,
    required this.durationMs,
  });

  final String historyId;
  final String name;
  final String url;
  final HTTPVerb method;
  final int status;
  final DateTime timeStamp;
  final int durationMs;
}

class CollectionDashboardMetrics {
  const CollectionDashboardMetrics({
    required this.total,
    required this.successCount,
    required this.failCount,
    required this.status2xx,
    required this.status3xx,
    required this.status4xx,
    required this.status5xx,
    required this.methodCounts,
    required this.apiTypeCounts,
    required this.uniqueEndpoints,
    required this.lastRunAt,
    required this.healthScore,
    required this.successRate,
    required this.errorRatio,
    required this.timingsMs,
    required this.avgMs,
    required this.peakMs,
    required this.p50Ms,
    required this.p95Ms,
    required this.p99Ms,
    required this.timingTrend,
    required this.recentHealth,
    required this.topEndpoints,
    required this.slowest,
    required this.recentErrors,
  });

  final int total;
  final int successCount;
  final int failCount;
  final int status2xx;
  final int status3xx;
  final int status4xx;
  final int status5xx;
  final Map<HTTPVerb, int> methodCounts;
  final Map<APIType, int> apiTypeCounts;
  final int uniqueEndpoints;
  final DateTime? lastRunAt;
  final int healthScore;
  final double successRate;
  final double errorRatio;
  final List<int> timingsMs;
  final int? avgMs;
  final int? peakMs;
  final int? p50Ms;
  final int? p95Ms;
  final int? p99Ms;
  final List<({DateTime at, int ms})> timingTrend;
  final List<int> recentHealth;
  final List<EndpointStat> topEndpoints;
  final List<TimedRequestStat> slowest;
  final List<TimedRequestStat> recentErrors;

  static const empty = CollectionDashboardMetrics(
    total: 0,
    successCount: 0,
    failCount: 0,
    status2xx: 0,
    status3xx: 0,
    status4xx: 0,
    status5xx: 0,
    methodCounts: {},
    apiTypeCounts: {},
    uniqueEndpoints: 0,
    lastRunAt: null,
    healthScore: 0,
    successRate: 0,
    errorRatio: 0,
    timingsMs: [],
    avgMs: null,
    peakMs: null,
    p50Ms: null,
    p95Ms: null,
    p99Ms: null,
    timingTrend: [],
    recentHealth: [],
    topEndpoints: [],
    slowest: [],
    recentErrors: [],
  );
}

class WorkflowNodeFailStat {
  const WorkflowNodeFailStat({
    required this.label,
    required this.failCount,
    required this.avgMs,
  });

  final String label;
  final int failCount;
  final int? avgMs;
}

class WorkflowDashboardMetrics {
  const WorkflowDashboardMetrics({
    required this.totalRuns,
    required this.successCount,
    required this.failCount,
    required this.successRate,
    required this.avgDurationMs,
    required this.peakDurationMs,
    required this.avgStepCount,
    required this.lastRunAt,
    required this.durationTrend,
    required this.recentRuns,
    required this.nodeFailures,
  });

  final int totalRuns;
  final int successCount;
  final int failCount;
  final double successRate;
  final int? avgDurationMs;
  final int? peakDurationMs;
  final double avgStepCount;
  final DateTime? lastRunAt;
  final List<({DateTime at, int ms, bool success})> durationTrend;
  final List<FlowRunRow> recentRuns;
  final List<WorkflowNodeFailStat> nodeFailures;

  static const empty = WorkflowDashboardMetrics(
    totalRuns: 0,
    successCount: 0,
    failCount: 0,
    successRate: 0,
    avgDurationMs: null,
    peakDurationMs: null,
    avgStepCount: 0,
    lastRunAt: null,
    durationTrend: [],
    recentRuns: [],
    nodeFailures: [],
  );
}

class FlowRunRow {
  const FlowRunRow({
    required this.runId,
    required this.workflowName,
    required this.success,
    required this.startedAt,
    required this.durationMs,
    required this.stepCount,
    this.error,
  });

  final String runId;
  final String workflowName;
  final bool success;
  final DateTime startedAt;
  final int durationMs;
  final int stepCount;
  final String? error;
}

enum ExecutionKind { request, workflow }

enum ExecutionHistoryFilter { all, requests, workflows }

enum WebhookInterval {
  minutes5(5),
  minutes15(15),
  minutes30(30),
  minutes60(60);

  const WebhookInterval(this.minutes);
  final int minutes;

  String get label => '${minutes}m';
}

class ExecutionHistoryEntry {
  const ExecutionHistoryEntry({
    required this.kind,
    required this.id,
    required this.title,
    required this.at,
    required this.success,
    this.durationMs,
    this.detail,
    this.method,
    this.statusCode,
  });

  final ExecutionKind kind;
  final String id;
  final String title;
  final DateTime at;
  final bool success;
  final int? durationMs;
  final String? detail;
  final HTTPVerb? method;
  final int? statusCode;
}

class ScriptCoverageRequest {
  const ScriptCoverageRequest({
    required this.collectionId,
    required this.requestId,
    required this.name,
    required this.hasPre,
    required this.hasPost,
  });

  final String collectionId;
  final String requestId;
  final String name;
  final bool hasPre;
  final bool hasPost;
}

class ScriptCoverage {
  const ScriptCoverage({
    required this.totalRequests,
    required this.withPreScript,
    required this.withPostScript,
    required this.withAnyScript,
    required this.requests,
  });

  final int totalRequests;
  final int withPreScript;
  final int withPostScript;
  final int withAnyScript;
  final List<ScriptCoverageRequest> requests;

  /// Post-response scripts ≈ tests / assertions coverage.
  double get testCoverage =>
      totalRequests == 0 ? 0 : withPostScript / totalRequests;

  double get scriptCoverage =>
      totalRequests == 0 ? 0 : withAnyScript / totalRequests;

  List<ScriptCoverageRequest> get uncoveredTests => [
        for (final r in requests)
          if (!r.hasPost) r,
      ];

  static const empty = ScriptCoverage(
    totalRequests: 0,
    withPreScript: 0,
    withPostScript: 0,
    withAnyScript: 0,
    requests: [],
  );
}

class WebhookAutoSendState {
  const WebhookAutoSendState({
    this.url = '',
    this.reportName = 'API Dash Health Report',
    this.interval = WebhookInterval.minutes15,
    this.active = false,
    this.lastSentAt,
    this.lastStatus,
    this.nextSendAt,
  });

  final String url;
  final String reportName;
  final WebhookInterval interval;
  final bool active;
  final DateTime? lastSentAt;
  final String? lastStatus;
  final DateTime? nextSendAt;

  WebhookAutoSendState copyWith({
    String? url,
    String? reportName,
    WebhookInterval? interval,
    bool? active,
    DateTime? lastSentAt,
    String? lastStatus,
    DateTime? nextSendAt,
    bool clearNext = false,
    bool clearLast = false,
  }) {
    return WebhookAutoSendState(
      url: url ?? this.url,
      reportName: reportName ?? this.reportName,
      interval: interval ?? this.interval,
      active: active ?? this.active,
      lastSentAt: clearLast ? null : (lastSentAt ?? this.lastSentAt),
      lastStatus: clearLast ? null : (lastStatus ?? this.lastStatus),
      nextSendAt: clearNext ? null : (nextSendAt ?? this.nextSendAt),
    );
  }
}
