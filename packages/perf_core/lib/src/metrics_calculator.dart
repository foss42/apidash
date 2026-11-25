import 'perf_results.dart';
import 'perf_run_config.dart';
import 'perf_sample.dart';

/// Intermediate result of [PerfMetricsCalculator.compute].
class PerfComputation {
  const PerfComputation({
    required this.summary,
    required this.timeSeries,
    required this.requests,
    required this.errors,
  });

  final PerfRunSummary summary;
  final List<PerfTimeSeriesPoint> timeSeries;
  final List<PerfRequestStats> requests;
  final List<PerfErrorEntry> errors;
}

/// Reduces raw [PerfSample]s into the aggregates stored in a
/// [PerfRunResults] file.
///
/// Pure Dart, no I/O and no dependencies — the same code runs inside the
/// Flutter app and inside a future standalone headless CLI.
abstract final class PerfMetricsCalculator {
  /// Default width of each time-series bucket.
  static const defaultBucketSize = Duration(seconds: 1);

  /// Default cap on stored error entries; `summary.errorCount` always
  /// reflects the true total.
  static const defaultMaxErrors = 1000;

  /// Computes run-level and per-request aggregates from [samples].
  ///
  /// Samples are sorted by timestamp internally, so callers may pass them in
  /// any order. Empty input produces [PerfRunSummary.empty] and empty
  /// series/lists.
  ///
  /// [bucketSize] controls the width of each [PerfTimeSeriesPoint]; every
  /// bucket between the first and last sample is emitted, including empty
  /// ones, so charts have a continuous x-axis.
  ///
  /// [maxErrors] caps the number of [PerfErrorEntry] records; the summary's
  /// `errorCount` is never capped.
  static PerfComputation compute(
    List<PerfSample> samples, {
    Duration bucketSize = defaultBucketSize,
    int maxErrors = defaultMaxErrors,
  }) {
    if (samples.isEmpty) {
      return const PerfComputation(
        summary: PerfRunSummary.empty,
        timeSeries: [],
        requests: [],
        errors: [],
      );
    }

    final sorted = [...samples]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final latencies = sorted.map((s) => s.latencyMs).toList()..sort();
    final first = sorted.first.timestamp;
    final last = sorted.last.timestamp;
    final durationMs = last.difference(first).inMilliseconds;
    final durationSeconds = durationMs / 1000.0;
    final errorCount = sorted.where((s) => !s.success).length;

    final summary = PerfRunSummary(
      totalRequests: sorted.length,
      errorCount: errorCount,
      errorRate: errorCount / sorted.length,
      requestsPerSecond: durationSeconds > 0
          ? sorted.length / durationSeconds
          : sorted.length.toDouble(),
      avgLatencyMs: latencies.reduce((a, b) => a + b) / latencies.length,
      minLatencyMs: latencies.first,
      maxLatencyMs: latencies.last,
      p50LatencyMs: _percentile(latencies, 50),
      p90LatencyMs: _percentile(latencies, 90),
      p95LatencyMs: _percentile(latencies, 95),
      p99LatencyMs: _percentile(latencies, 99),
      actualDurationMilliseconds: durationMs < 0 ? 0 : durationMs,
      startedAt: first,
      finishedAt: last,
    );

    return PerfComputation(
      summary: summary,
      timeSeries: _buildTimeSeries(
        sorted,
        first: first,
        last: last,
        bucketSize: bucketSize,
      ),
      requests: _buildRequestStats(sorted),
      errors: _buildErrors(sorted, maxErrors: maxErrors),
    );
  }

  /// Convenience wrapper that computes [compute] and wraps the result in a
  /// versioned [PerfRunResults] ready for `jsonEncode`.
  static PerfRunResults computeResults(
    PerfRunConfig config,
    List<PerfSample> samples, {
    Duration bucketSize = defaultBucketSize,
    int maxErrors = defaultMaxErrors,
  }) {
    final computation = compute(
      samples,
      bucketSize: bucketSize,
      maxErrors: maxErrors,
    );
    return PerfRunResults(
      formatVersion: PerfRunResults.currentFormatVersion,
      runId: config.runId,
      config: config,
      summary: computation.summary,
      timeSeries: computation.timeSeries,
      requests: computation.requests,
      errors: computation.errors,
    );
  }

  /// Nearest-rank percentile on an ascending-sorted list of latencies.
  /// Returns `0` for an empty list.
  static double _percentile(List<double> sorted, int percentile) {
    if (sorted.isEmpty) return 0;
    final rank =
        ((percentile / 100) * sorted.length).ceil().clamp(1, sorted.length) - 1;
    return sorted[rank];
  }

  static List<PerfTimeSeriesPoint> _buildTimeSeries(
    List<PerfSample> sorted, {
    required DateTime first,
    required DateTime last,
    required Duration bucketSize,
  }) {
    final bucketMs = bucketSize.inMilliseconds;
    if (bucketMs <= 0) {
      throw ArgumentError.value(bucketSize, 'bucketSize', 'must be positive');
    }

    final startMs = first.toUtc().millisecondsSinceEpoch;
    final endMs = last.toUtc().millisecondsSinceEpoch;
    final firstBucket = startMs - (startMs % bucketMs);
    final bucketCount = ((endMs - firstBucket) ~/ bucketMs) + 1;
    final intervalSeconds = bucketMs / 1000.0;
    assert(intervalSeconds > 0);

    final buckets = List<_Bucket>.generate(bucketCount, (_) => _Bucket());
    for (final sample in sorted) {
      final sampleMs = sample.timestamp.toUtc().millisecondsSinceEpoch;
      final index = ((sampleMs - firstBucket) ~/ bucketMs).clamp(
        0,
        bucketCount - 1,
      );
      buckets[index].add(sample);
    }

    return List.unmodifiable([
      for (var i = 0; i < buckets.length; i++)
        PerfTimeSeriesPoint(
          bucketStart: DateTime.fromMillisecondsSinceEpoch(
            firstBucket + i * bucketMs,
            isUtc: true,
          ),
          intervalSeconds: intervalSeconds,
          requestCount: buckets[i].count,
          errorCount: buckets[i].errors,
          avgLatencyMs: buckets[i].avgLatencyMs,
          requestsPerSecond: buckets[i].count / intervalSeconds,
        ),
    ]);
  }

  static List<PerfRequestStats> _buildRequestStats(List<PerfSample> sorted) {
    final groups = <String, _RequestGroup>{};
    final order = <String>[];
    for (final sample in sorted) {
      final group = groups.putIfAbsent(sample.requestKey, () {
        order.add(sample.requestKey);
        return _RequestGroup(sample.requestName);
      });
      group.add(sample);
    }

    return List.unmodifiable([
      for (final key in order) groups[key]!.toStats(key),
    ]);
  }

  static List<PerfErrorEntry> _buildErrors(
    List<PerfSample> sorted, {
    required int maxErrors,
  }) {
    final cap = maxErrors < 0 ? 0 : maxErrors;
    final errors = <PerfErrorEntry>[];
    for (final sample in sorted) {
      if (sample.success) continue;
      errors.add(
        PerfErrorEntry(
          timestamp: sample.timestamp,
          requestKey: sample.requestKey,
          requestName: sample.requestName,
          message: sample.error ?? 'request failed',
          statusCode: sample.statusCode,
        ),
      );
      if (errors.length >= cap) break;
    }
    return List.unmodifiable(errors);
  }
}

class _Bucket {
  int count = 0;
  int errors = 0;
  double latencySum = 0;

  void add(PerfSample sample) {
    count++;
    latencySum += sample.latencyMs;
    if (!sample.success) errors++;
  }

  double get avgLatencyMs => count == 0 ? 0 : latencySum / count;
}

class _RequestGroup {
  _RequestGroup(this.name);

  final String name;
  final List<double> latencies = [];
  int errors = 0;

  void add(PerfSample sample) {
    latencies.add(sample.latencyMs);
    if (!sample.success) errors++;
  }

  PerfRequestStats toStats(String key) {
    final sorted = [...latencies]..sort();
    final count = sorted.length;
    return PerfRequestStats(
      requestKey: key,
      requestName: name,
      count: count,
      errorCount: errors,
      errorRate: count == 0 ? 0 : errors / count,
      avgLatencyMs: sorted.isEmpty ? 0 : sorted.reduce((a, b) => a + b) / count,
      minLatencyMs: sorted.isEmpty ? 0 : sorted.first,
      maxLatencyMs: sorted.isEmpty ? 0 : sorted.last,
      p50LatencyMs: PerfMetricsCalculator._percentile(sorted, 50),
      p90LatencyMs: PerfMetricsCalculator._percentile(sorted, 90),
      p95LatencyMs: PerfMetricsCalculator._percentile(sorted, 95),
      p99LatencyMs: PerfMetricsCalculator._percentile(sorted, 99),
    );
  }
}
