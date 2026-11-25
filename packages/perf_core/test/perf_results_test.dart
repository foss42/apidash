import 'dart:convert';

import 'package:perf_core/perf_core.dart';
import 'package:test/test.dart';

void main() {
  group('PerfRunResults JSON round-trip', () {
    late PerfRunResults results;

    setUp(() {
      results = PerfRunResults(
        formatVersion: PerfRunResults.currentFormatVersion,
        runId: 'run-42',
        config: PerfRunConfig(
          runId: 'run-42',
          startedAt: DateTime.utc(2026, 1, 1, 12),
          collectionName: 'My Collection',
          requestSequence: const [
            PerfRequestRef(id: 'r1', name: 'Get users', method: 'GET'),
            PerfRequestRef(id: 'r2', name: 'Create user', method: 'POST'),
          ],
          virtualUsers: 20,
          durationSeconds: 600,
          loadProfile: const PerfLoadProfile(
            type: PerfLoadProfileType.rampUp,
            virtualUsers: 20,
            rampDurationSeconds: 120,
          ),
          baseUrl: 'https://api.example.com',
        ),
        summary: const PerfRunSummary(
          totalRequests: 12000,
          errorCount: 12,
          errorRate: 0.001,
          requestsPerSecond: 20,
          avgLatencyMs: 145.5,
          minLatencyMs: 12,
          maxLatencyMs: 2400,
          p50LatencyMs: 120,
          p90LatencyMs: 300,
          p95LatencyMs: 450,
          p99LatencyMs: 900,
          actualDurationMilliseconds: 600000,
          startedAt: null,
          finishedAt: null,
        ),
        timeSeries: [
          PerfTimeSeriesPoint(
            bucketStart: DateTime.utc(2026, 1, 1, 12),
            intervalSeconds: 1,
            requestCount: 20,
            errorCount: 1,
            avgLatencyMs: 140,
            requestsPerSecond: 20,
          ),
        ],
        requests: const [
          PerfRequestStats(
            requestKey: 'r1',
            requestName: 'Get users',
            count: 6000,
            errorCount: 0,
            errorRate: 0,
            avgLatencyMs: 100,
            minLatencyMs: 10,
            maxLatencyMs: 800,
            p50LatencyMs: 90,
            p90LatencyMs: 200,
            p95LatencyMs: 260,
            p99LatencyMs: 500,
          ),
        ],
        errors: [
          PerfErrorEntry(
            timestamp: DateTime.utc(2026, 1, 1, 12, 0, 5),
            requestKey: 'r1',
            requestName: 'Get users',
            message: 'connection reset',
            statusCode: 500,
          ),
        ],
      );
    });

    test('toJson -> jsonEncode -> jsonDecode -> fromJson preserves data', () {
      final encoded = jsonEncode(results.toJson());
      final decoded = PerfRunResults.fromJson(
        jsonDecode(encoded) as Map<String, Object?>,
      );

      expect(decoded.formatVersion, results.formatVersion);
      expect(decoded.runId, results.runId);
      expect(decoded.config.runId, 'run-42');
      expect(decoded.config.collectionName, 'My Collection');
      expect(decoded.config.requestSequence, hasLength(2));
      expect(decoded.config.requestSequence.first.method, 'GET');
      expect(decoded.config.virtualUsers, 20);
      expect(decoded.config.durationSeconds, 600);
      expect(decoded.config.loadProfile.type, PerfLoadProfileType.rampUp);
      expect(decoded.config.loadProfile.rampDurationSeconds, 120);
      expect(decoded.config.baseUrl, 'https://api.example.com');
      expect(decoded.config.startedAt, DateTime.utc(2026, 1, 1, 12));

      expect(decoded.summary.totalRequests, 12000);
      expect(decoded.summary.errorRate, 0.001);
      expect(decoded.summary.p99LatencyMs, 900);
      expect(decoded.summary.actualDurationMilliseconds, 600000);

      expect(decoded.timeSeries, hasLength(1));
      expect(decoded.timeSeries.single.requestCount, 20);
      expect(decoded.timeSeries.single.intervalSeconds, 1);

      expect(decoded.requests.single.requestKey, 'r1');
      expect(decoded.requests.single.p95LatencyMs, 260);

      expect(decoded.errors.single.message, 'connection reset');
      expect(decoded.errors.single.statusCode, 500);
    });

    test('re-encoding a decoded result is stable', () {
      final once = jsonEncode(results.toJson());
      final decoded = PerfRunResults.fromJson(
        jsonDecode(once) as Map<String, Object?>,
      );
      expect(jsonEncode(decoded.toJson()), once);
    });
  });

  group('format versioning', () {
    test('fromJson rejects missing or unsupported versions', () {
      expect(
        () => PerfRunResults.fromJson(const {'runId': 'x'}),
        throwsFormatException,
      );
      expect(
        () => PerfRunResults.fromJson(const {
          'formatVersion': PerfRunResults.currentFormatVersion + 1,
        }),
        throwsFormatException,
      );
      expect(
        () => PerfRunResults.fromJson(const {'formatVersion': 0}),
        throwsFormatException,
      );
    });
  });

  group('PerfLoadProfile', () {
    test('serializes all profile types', () {
      for (final type in PerfLoadProfileType.values) {
        final profile = PerfLoadProfile(
          type: type,
          virtualUsers: 10,
          rampDurationSeconds: 60,
          baselineVirtualUsers: 2,
          spikeDurationSeconds: 30,
        );
        final json = profile.toJson();
        expect(json['type'], type.name);
        final restored = PerfLoadProfile.fromJson(json);
        expect(restored.type, type);
        expect(restored.virtualUsers, 10);
        expect(restored.rampDurationSeconds, 60);
        expect(restored.baselineVirtualUsers, 2);
        expect(restored.spikeDurationSeconds, 30);
      }
    });

    test('omits null fields and rejects unknown types', () {
      const profile = PerfLoadProfile(type: PerfLoadProfileType.spike);
      expect(profile.toJson(), {'type': 'spike'});
      expect(
        () => PerfLoadProfile.fromJson(const {'type': 'bogus'}),
        throwsFormatException,
      );
    });
  });
}
