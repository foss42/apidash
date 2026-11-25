import 'load_profile.dart';
import 'perf_run_config.dart';

/// Aggregate metrics for a whole performance test run.
class PerfRunSummary {
  const PerfRunSummary({
    required this.totalRequests,
    required this.errorCount,
    required this.errorRate,
    required this.requestsPerSecond,
    required this.avgLatencyMs,
    required this.minLatencyMs,
    required this.maxLatencyMs,
    required this.p50LatencyMs,
    required this.p90LatencyMs,
    required this.p95LatencyMs,
    required this.p99LatencyMs,
    required this.actualDurationMilliseconds,
    this.startedAt,
    this.finishedAt,
  });

  /// Total number of completed request attempts (successful + failed).
  final int totalRequests;

  /// Number of failed request attempts.
  final int errorCount;

  /// `errorCount / totalRequests` in the range 0..1. `0` when there were no
  /// requests.
  final double errorRate;

  /// `totalRequests / actualDurationSeconds`. `0` when the run produced no
  /// measurable duration.
  final double requestsPerSecond;

  final double avgLatencyMs;
  final double minLatencyMs;
  final double maxLatencyMs;
  final double p50LatencyMs;
  final double p90LatencyMs;
  final double p95LatencyMs;
  final double p99LatencyMs;

  /// Wall-clock duration between the first and last sample, in milliseconds.
  final int actualDurationMilliseconds;

  /// Timestamp of the first sample, if any.
  final DateTime? startedAt;

  /// Timestamp of the last sample, if any.
  final DateTime? finishedAt;

  /// Empty summary used when a run produced no samples.
  static const empty = PerfRunSummary(
    totalRequests: 0,
    errorCount: 0,
    errorRate: 0,
    requestsPerSecond: 0,
    avgLatencyMs: 0,
    minLatencyMs: 0,
    maxLatencyMs: 0,
    p50LatencyMs: 0,
    p90LatencyMs: 0,
    p95LatencyMs: 0,
    p99LatencyMs: 0,
    actualDurationMilliseconds: 0,
  );

  Map<String, Object?> toJson() => {
    'totalRequests': totalRequests,
    'errorCount': errorCount,
    'errorRate': errorRate,
    'requestsPerSecond': requestsPerSecond,
    'avgLatencyMs': avgLatencyMs,
    'minLatencyMs': minLatencyMs,
    'maxLatencyMs': maxLatencyMs,
    'p50LatencyMs': p50LatencyMs,
    'p90LatencyMs': p90LatencyMs,
    'p95LatencyMs': p95LatencyMs,
    'p99LatencyMs': p99LatencyMs,
    'actualDurationMilliseconds': actualDurationMilliseconds,
    if (startedAt != null) 'startedAt': startedAt!.toUtc().toIso8601String(),
    if (finishedAt != null) 'finishedAt': finishedAt!.toUtc().toIso8601String(),
  };

  factory PerfRunSummary.fromJson(Map<String, Object?> json) {
    return PerfRunSummary(
      totalRequests: (json['totalRequests'] as num?)?.toInt() ?? 0,
      errorCount: (json['errorCount'] as num?)?.toInt() ?? 0,
      errorRate: (json['errorRate'] as num?)?.toDouble() ?? 0,
      requestsPerSecond: (json['requestsPerSecond'] as num?)?.toDouble() ?? 0,
      avgLatencyMs: (json['avgLatencyMs'] as num?)?.toDouble() ?? 0,
      minLatencyMs: (json['minLatencyMs'] as num?)?.toDouble() ?? 0,
      maxLatencyMs: (json['maxLatencyMs'] as num?)?.toDouble() ?? 0,
      p50LatencyMs: (json['p50LatencyMs'] as num?)?.toDouble() ?? 0,
      p90LatencyMs: (json['p90LatencyMs'] as num?)?.toDouble() ?? 0,
      p95LatencyMs: (json['p95LatencyMs'] as num?)?.toDouble() ?? 0,
      p99LatencyMs: (json['p99LatencyMs'] as num?)?.toDouble() ?? 0,
      actualDurationMilliseconds:
          (json['actualDurationMilliseconds'] as num?)?.toInt() ?? 0,
      startedAt: DateTime.tryParse(json['startedAt'] as String? ?? '')?.toUtc(),
      finishedAt: DateTime.tryParse(
        json['finishedAt'] as String? ?? '',
      )?.toUtc(),
    );
  }

  @override
  String toString() => 'PerfRunSummary(${toJson()})';
}

/// Aggregated statistics for one request in the sequence.
class PerfRequestStats {
  const PerfRequestStats({
    required this.requestKey,
    required this.requestName,
    required this.count,
    required this.errorCount,
    required this.errorRate,
    required this.avgLatencyMs,
    required this.minLatencyMs,
    required this.maxLatencyMs,
    required this.p50LatencyMs,
    required this.p90LatencyMs,
    required this.p95LatencyMs,
    required this.p99LatencyMs,
  });

  final String requestKey;
  final String requestName;

  /// Number of completed attempts for this request.
  final int count;

  /// Number of failed attempts for this request.
  final int errorCount;

  /// `errorCount / count` in the range 0..1.
  final double errorRate;

  final double avgLatencyMs;
  final double minLatencyMs;
  final double maxLatencyMs;
  final double p50LatencyMs;
  final double p90LatencyMs;
  final double p95LatencyMs;
  final double p99LatencyMs;

  Map<String, Object?> toJson() => {
    'requestKey': requestKey,
    'requestName': requestName,
    'count': count,
    'errorCount': errorCount,
    'errorRate': errorRate,
    'avgLatencyMs': avgLatencyMs,
    'minLatencyMs': minLatencyMs,
    'maxLatencyMs': maxLatencyMs,
    'p50LatencyMs': p50LatencyMs,
    'p90LatencyMs': p90LatencyMs,
    'p95LatencyMs': p95LatencyMs,
    'p99LatencyMs': p99LatencyMs,
  };

  factory PerfRequestStats.fromJson(Map<String, Object?> json) {
    return PerfRequestStats(
      requestKey: json['requestKey'] as String? ?? '',
      requestName: json['requestName'] as String? ?? '',
      count: (json['count'] as num?)?.toInt() ?? 0,
      errorCount: (json['errorCount'] as num?)?.toInt() ?? 0,
      errorRate: (json['errorRate'] as num?)?.toDouble() ?? 0,
      avgLatencyMs: (json['avgLatencyMs'] as num?)?.toDouble() ?? 0,
      minLatencyMs: (json['minLatencyMs'] as num?)?.toDouble() ?? 0,
      maxLatencyMs: (json['maxLatencyMs'] as num?)?.toDouble() ?? 0,
      p50LatencyMs: (json['p50LatencyMs'] as num?)?.toDouble() ?? 0,
      p90LatencyMs: (json['p90LatencyMs'] as num?)?.toDouble() ?? 0,
      p95LatencyMs: (json['p95LatencyMs'] as num?)?.toDouble() ?? 0,
      p99LatencyMs: (json['p99LatencyMs'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  String toString() => 'PerfRequestStats($requestKey, count: $count)';
}

/// One bucket of the run's time series, used to draw timeline charts.
class PerfTimeSeriesPoint {
  const PerfTimeSeriesPoint({
    required this.bucketStart,
    required this.intervalSeconds,
    required this.requestCount,
    required this.errorCount,
    required this.avgLatencyMs,
    required this.requestsPerSecond,
  });

  /// Start of the bucket (UTC recommended).
  final DateTime bucketStart;

  /// Bucket width in seconds.
  final double intervalSeconds;

  /// Completed attempts inside this bucket.
  final int requestCount;

  /// Failed attempts inside this bucket.
  final int errorCount;

  /// Mean latency of attempts inside this bucket; `0` when empty.
  final double avgLatencyMs;

  /// `requestCount / intervalSeconds`.
  final double requestsPerSecond;

  Map<String, Object?> toJson() => {
    'bucketStart': bucketStart.toUtc().toIso8601String(),
    'intervalSeconds': intervalSeconds,
    'requestCount': requestCount,
    'errorCount': errorCount,
    'avgLatencyMs': avgLatencyMs,
    'requestsPerSecond': requestsPerSecond,
  };

  factory PerfTimeSeriesPoint.fromJson(Map<String, Object?> json) {
    return PerfTimeSeriesPoint(
      bucketStart:
          DateTime.tryParse(json['bucketStart'] as String? ?? '')?.toUtc() ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      intervalSeconds: (json['intervalSeconds'] as num?)?.toDouble() ?? 1,
      requestCount: (json['requestCount'] as num?)?.toInt() ?? 0,
      errorCount: (json['errorCount'] as num?)?.toInt() ?? 0,
      avgLatencyMs: (json['avgLatencyMs'] as num?)?.toDouble() ?? 0,
      requestsPerSecond: (json['requestsPerSecond'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  String toString() => 'PerfTimeSeriesPoint($bucketStart, $requestCount req)';
}

/// A single recorded failure, kept so the dashboard can show what broke.
class PerfErrorEntry {
  const PerfErrorEntry({
    required this.timestamp,
    required this.requestKey,
    required this.message,
    this.requestName,
    this.statusCode,
  });

  final DateTime timestamp;
  final String requestKey;
  final String? requestName;
  final String message;
  final int? statusCode;

  Map<String, Object?> toJson() => {
    'timestamp': timestamp.toUtc().toIso8601String(),
    'requestKey': requestKey,
    if (requestName != null) 'requestName': requestName,
    'message': message,
    if (statusCode != null) 'statusCode': statusCode,
  };

  factory PerfErrorEntry.fromJson(Map<String, Object?> json) {
    return PerfErrorEntry(
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '')?.toUtc() ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      requestKey: json['requestKey'] as String? ?? '',
      requestName: json['requestName'] as String?,
      message: json['message'] as String? ?? '',
      statusCode: (json['statusCode'] as num?)?.toInt(),
    );
  }

  @override
  String toString() => 'PerfErrorEntry($requestKey: $message)';
}

/// The portable, versioned results file written by the CLI and consumed by
/// the API Dash performance dashboard.
///
/// Serialized with [dart:convert] `jsonEncode`/`jsonDecode`; the top-level
/// JSON object contains `formatVersion`, `runId`, `config`, `summary`,
/// `timeSeries`, `requests` and `errors`.
class PerfRunResults {
  const PerfRunResults({
    required this.formatVersion,
    required this.runId,
    required this.config,
    required this.summary,
    required this.timeSeries,
    required this.requests,
    required this.errors,
  });

  /// Current results format version written by this package.
  static const currentFormatVersion = 1;

  /// Version of the results format. Readers must reject versions they do not
  /// understand.
  final int formatVersion;

  /// Unique identifier of the run (mirrors `config.runId`).
  final String runId;

  /// Run configuration the results were produced with.
  final PerfRunConfig config;

  /// Whole-run aggregate metrics.
  final PerfRunSummary summary;

  /// Bucketed time series for timeline charts.
  final List<PerfTimeSeriesPoint> timeSeries;

  /// Per-request statistics, ordered by first appearance in the sequence.
  final List<PerfRequestStats> requests;

  /// Recorded failures (may be capped by the producer; see
  /// [PerfMetricsCalculator.compute]'s `maxErrors`).
  final List<PerfErrorEntry> errors;

  Map<String, Object?> toJson() => {
    'formatVersion': formatVersion,
    'runId': runId,
    'config': config.toJson(),
    'summary': summary.toJson(),
    'timeSeries': timeSeries.map((p) => p.toJson()).toList(),
    'requests': requests.map((r) => r.toJson()).toList(),
    'errors': errors.map((e) => e.toJson()).toList(),
  };

  /// Parses a results map previously produced by [toJson].
  ///
  /// Throws a [FormatException] when `formatVersion` is missing or newer
  /// than [currentFormatVersion].
  factory PerfRunResults.fromJson(Map<String, Object?> json) {
    final version = (json['formatVersion'] as num?)?.toInt() ?? 0;
    if (version < 1 || version > currentFormatVersion) {
      throw FormatException(
        'Unsupported perf results formatVersion: $version '
        '(supported: 1..$currentFormatVersion)',
      );
    }

    List<T> parseList<T>(
      Object? raw,
      T Function(Map<String, Object?>) fromJson,
    ) {
      if (raw is! List) return const [];
      return raw
          .whereType<Map<String, Object?>>()
          .map(fromJson)
          .toList(growable: false);
    }

    return PerfRunResults(
      formatVersion: version,
      runId: json['runId'] as String? ?? '',
      config: json['config'] is Map<String, Object?>
          ? PerfRunConfig.fromJson(json['config'] as Map<String, Object?>)
          : PerfRunConfig(
              runId: json['runId'] as String? ?? '',
              startedAt: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
              requestSequence: const [],
              virtualUsers: 0,
              durationSeconds: 0,
              loadProfile: const PerfLoadProfile(
                type: PerfLoadProfileType.fixed,
              ),
            ),
      summary: json['summary'] is Map<String, Object?>
          ? PerfRunSummary.fromJson(json['summary'] as Map<String, Object?>)
          : PerfRunSummary.empty,
      timeSeries: parseList(json['timeSeries'], PerfTimeSeriesPoint.fromJson),
      requests: parseList(json['requests'], PerfRequestStats.fromJson),
      errors: parseList(json['errors'], PerfErrorEntry.fromJson),
    );
  }

  @override
  String toString() =>
      'PerfRunResults(v$formatVersion, runId: $runId, '
      '${summary.totalRequests} requests)';
}
