/// A single completed request observation produced by a load generator.
///
/// The load engine (CLI/app) emits these; [PerfMetricsCalculator] reduces
/// them into the summary, time-series and per-request statistics stored in
/// the results file.
class PerfSample {
  const PerfSample({
    required this.timestamp,
    required this.requestKey,
    required this.requestName,
    required this.latencyMs,
    required this.success,
    this.statusCode,
    this.error,
  });

  /// Wall-clock time the response completed (or the attempt failed).
  final DateTime timestamp;

  /// Stable identifier of the request in the sequence. Used to group
  /// per-request statistics; should be unique per sequence entry.
  final String requestKey;

  /// Human-readable request name for display.
  final String requestName;

  /// End-to-end latency in milliseconds.
  final double latencyMs;

  /// Whether the request is considered successful (2xx/3xx, or whatever the
  /// runner defines as success).
  final bool success;

  /// Optional HTTP status code, when the runner exposes one.
  final int? statusCode;

  /// Optional error description for failed samples.
  final String? error;

  @override
  String toString() =>
      'PerfSample($requestKey, ${latencyMs}ms, success: $success)';
}
