import 'package:perf_core/perf_core.dart';
import 'package:test/test.dart';

void main() {
  final t0 = DateTime.utc(2026, 1, 1, 12);

  PerfSample sample({
    required int secondOffset,
    required String key,
    required double latencyMs,
    bool success = true,
    String? error,
    int? statusCode,
  }) {
    return PerfSample(
      timestamp: t0.add(Duration(seconds: secondOffset)),
      requestKey: key,
      requestName: 'Request $key',
      latencyMs: latencyMs,
      success: success,
      statusCode: statusCode,
      error: error,
    );
  }

  group('PerfMetricsCalculator.compute', () {
    test('empty input produces an empty summary', () {
      final result = PerfMetricsCalculator.compute(const []);
      expect(result.summary.totalRequests, 0);
      expect(result.summary.requestsPerSecond, 0);
      expect(result.timeSeries, isEmpty);
      expect(result.requests, isEmpty);
      expect(result.errors, isEmpty);
    });

    test('computes totals, latency stats and error rate', () {
      final samples = [
        sample(secondOffset: 0, key: 'a', latencyMs: 100),
        sample(secondOffset: 1, key: 'a', latencyMs: 200),
        sample(secondOffset: 2, key: 'a', latencyMs: 300),
        sample(
          secondOffset: 3,
          key: 'a',
          latencyMs: 400,
          success: false,
          error: 'boom',
          statusCode: 500,
        ),
      ];

      final result = PerfMetricsCalculator.compute(samples);
      final s = result.summary;

      expect(s.totalRequests, 4);
      expect(s.errorCount, 1);
      expect(s.errorRate, closeTo(0.25, 1e-9));
      expect(s.minLatencyMs, 100);
      expect(s.maxLatencyMs, 400);
      expect(s.avgLatencyMs, closeTo(250, 1e-9));
      // 4 samples over 3 seconds.
      expect(s.actualDurationMilliseconds, 3000);
      expect(s.requestsPerSecond, closeTo(4 / 3, 1e-9));
      expect(s.startedAt, t0);
      expect(s.finishedAt, t0.add(const Duration(seconds: 3)));
    });

    test('computes nearest-rank percentiles', () {
      // Latencies 10..100 ms, one per second.
      final samples = [
        for (var i = 1; i <= 100; i++)
          sample(secondOffset: i, key: 'a', latencyMs: i * 10.0),
      ];
      final s = PerfMetricsCalculator.compute(samples).summary;

      expect(s.p50LatencyMs, 500);
      expect(s.p90LatencyMs, 900);
      expect(s.p95LatencyMs, 950);
      expect(s.p99LatencyMs, 990);
    });

    test('sorts unsorted samples before aggregating', () {
      final samples = [
        sample(secondOffset: 2, key: 'a', latencyMs: 30),
        sample(secondOffset: 0, key: 'a', latencyMs: 10),
        sample(secondOffset: 1, key: 'a', latencyMs: 20),
      ];
      final s = PerfMetricsCalculator.compute(samples).summary;
      expect(s.startedAt, t0);
      expect(s.finishedAt, t0.add(const Duration(seconds: 2)));
      expect(s.minLatencyMs, 10);
    });

    test('builds per-request stats grouped by requestKey in first-seen '
        'order', () {
      final samples = [
        sample(secondOffset: 0, key: 'get-users', latencyMs: 50),
        sample(secondOffset: 1, key: 'create-user', latencyMs: 120),
        sample(
          secondOffset: 2,
          key: 'get-users',
          latencyMs: 70,
          success: false,
          error: 'timeout',
        ),
        sample(secondOffset: 3, key: 'create-user', latencyMs: 130),
      ];

      final requests = PerfMetricsCalculator.compute(samples).requests;
      expect(requests.map((r) => r.requestKey), ['get-users', 'create-user']);

      final getUsers = requests[0];
      expect(getUsers.count, 2);
      expect(getUsers.errorCount, 1);
      expect(getUsers.errorRate, closeTo(0.5, 1e-9));
      expect(getUsers.avgLatencyMs, closeTo(60, 1e-9));

      final createUser = requests[1];
      expect(createUser.count, 2);
      expect(createUser.errorCount, 0);
      expect(createUser.avgLatencyMs, closeTo(125, 1e-9));
    });

    test(
      'builds a continuous bucketed time series including empty buckets',
      () {
        final samples = [
          sample(secondOffset: 0, key: 'a', latencyMs: 100),
          sample(secondOffset: 1, key: 'a', latencyMs: 200),
          // gap at second 2
          sample(
            secondOffset: 3,
            key: 'a',
            latencyMs: 300,
            success: false,
            error: 'err',
          ),
        ];

        final series = PerfMetricsCalculator.compute(samples).timeSeries;

        expect(series, hasLength(4));
        expect(series[0].requestCount, 1);
        expect(series[0].avgLatencyMs, 100);
        expect(series[1].requestCount, 1);
        expect(series[2].requestCount, 0);
        expect(series[2].avgLatencyMs, 0);
        expect(series[3].requestCount, 1);
        expect(series[3].errorCount, 1);
        expect(series[3].requestsPerSecond, 1);
        expect(series.every((p) => p.intervalSeconds == 1), isTrue);
      },
    );

    test('honours a custom bucket size', () {
      final samples = [
        sample(secondOffset: 0, key: 'a', latencyMs: 10),
        sample(secondOffset: 5, key: 'a', latencyMs: 20),
      ];
      final series = PerfMetricsCalculator.compute(
        samples,
        bucketSize: const Duration(seconds: 10),
      ).timeSeries;

      expect(series, hasLength(1));
      expect(series.single.requestCount, 2);
      expect(series.single.intervalSeconds, 10);
    });

    test('caps stored errors but keeps the true errorCount', () {
      final samples = [
        for (var i = 0; i < 10; i++)
          sample(
            secondOffset: i,
            key: 'a',
            latencyMs: 10,
            success: false,
            error: 'e$i',
          ),
      ];
      final result = PerfMetricsCalculator.compute(samples, maxErrors: 3);

      expect(result.summary.errorCount, 10);
      expect(result.errors, hasLength(3));
      expect(result.errors.first.message, 'e0');
    });

    test('rejects a non-positive bucket size', () {
      expect(
        () => PerfMetricsCalculator.compute([
          sample(secondOffset: 0, key: 'a', latencyMs: 1),
        ], bucketSize: Duration.zero),
        throwsArgumentError,
      );
    });
  });

  group('computeResults', () {
    test('wraps computation in a versioned PerfRunResults', () {
      final config = PerfRunConfig(
        runId: 'run-1',
        startedAt: DateTime.utc(2026),
        requestSequence: [
          PerfRequestRef(id: 'r1', name: 'Get users', method: 'GET'),
        ],
        virtualUsers: 5,
        durationSeconds: 60,
        loadProfile: PerfLoadProfile(
          type: PerfLoadProfileType.fixed,
          virtualUsers: 5,
        ),
      );
      final results = PerfMetricsCalculator.computeResults(config, [
        sample(secondOffset: 0, key: 'r1', latencyMs: 42),
      ]);

      expect(results.formatVersion, PerfRunResults.currentFormatVersion);
      expect(results.runId, 'run-1');
      expect(results.config.virtualUsers, 5);
      expect(results.summary.totalRequests, 1);
    });
  });
}
