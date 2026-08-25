import 'package:apidash/dashboard/models/dashboard_models.dart';
import 'package:apidash/dashboard/utils/dashboard_metrics.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/workflow/models/workflow_history_models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_test/flutter_test.dart';

HistoryMetaModel _meta({
  required String id,
  String requestId = 'r1',
  APIType apiType = APIType.rest,
  String name = 'Req',
  String url = 'https://api.example/a',
  HTTPVerb method = HTTPVerb.get,
  int status = 200,
  required DateTime at,
}) {
  return HistoryMetaModel(
    historyId: id,
    requestId: requestId,
    apiType: apiType,
    name: name,
    url: url,
    method: method,
    responseStatus: status,
    timeStamp: at,
  );
}

FlowHistoryMeta _flow({
  required String runId,
  String workflowId = 'w1',
  String workflowName = 'Flow',
  required bool success,
  required DateTime started,
  int durationSec = 1,
  int stepCount = 2,
  String? error,
}) {
  return FlowHistoryMeta(
    runId: runId,
    workflowId: workflowId,
    workflowName: workflowName,
    success: success,
    startedAt: started,
    endedAt: started.add(Duration(seconds: durationSec)),
    stepCount: stepCount,
    error: error,
  );
}

void main() {
  group('helpers', () {
    test('isHttpSuccess treats 2xx and 3xx as success', () {
      expect(isHttpSuccess(200), isTrue);
      expect(isHttpSuccess(301), isTrue);
      expect(isHttpSuccess(399), isTrue);
      expect(isHttpSuccess(400), isFalse);
      expect(isHttpSuccess(500), isFalse);
    });

    test('statusBucket maps status classes', () {
      expect(statusBucket(204), 2);
      expect(statusBucket(301), 3);
      expect(statusBucket(404), 4);
      expect(statusBucket(503), 5);
      expect(statusBucket(100), 0);
    });

    test('percentileMs and averageMs', () {
      expect(percentileMs(const [], 0.5), isNull);
      expect(averageMs(const []), isNull);
      expect(percentileMs([10, 20, 30, 40, 50], 0.5), 30);
      expect(averageMs([100, 200, 300]), 200);
    });

    test('timingMsFromHistoryJson reads microseconds', () {
      expect(timingMsFromHistoryJson(null), isNull);
      expect(timingMsFromHistoryJson({'httpResponseModel': {}}), isNull);
      expect(
        timingMsFromHistoryJson({
          'httpResponseModel': {'time': 1500000},
        }),
        1500,
      );
    });

    test('DashboardTimeRange labels and since', () {
      expect(DashboardTimeRange.hours24.label, '24h');
      expect(DashboardTimeRange.days7.label, '7d');
      expect(DashboardTimeRange.days30.label, '30d');
      expect(DashboardTimeRange.all.label, 'All');
      expect(DashboardTimeRange.all.since, isNull);
      final since7 = DashboardTimeRange.days7.since!;
      expect(DateTime.now().difference(since7).inDays, inInclusiveRange(6, 7));
    });
  });

  group('filterHistoryMetas', () {
    final metas = [
      _meta(id: '1', requestId: 'a', at: DateTime(2026, 1, 1)),
      _meta(id: '2', requestId: 'b', at: DateTime(2026, 1, 10)),
      _meta(id: '3', requestId: 'a', at: DateTime(2026, 1, 5)),
    ];

    test('filters by since and sorts ascending', () {
      final out = filterHistoryMetas(
        metas: metas,
        since: DateTime(2026, 1, 4),
        collectionId: null,
        requestToCollection: const {},
      );
      expect(out.map((m) => m.historyId), ['3', '2']);
    });

    test('filters by collection via request map', () {
      final out = filterHistoryMetas(
        metas: metas,
        since: null,
        collectionId: 'colA',
        requestToCollection: const {'a': 'colA', 'b': 'colB'},
      );
      expect(out.map((m) => m.historyId), ['1', '3']);
    });
  });

  group('buildCollectionDashboardMetrics', () {
    test('returns empty for no metas', () {
      final m = buildCollectionDashboardMetrics(
        metas: const [],
        timingsMsByHistoryId: const {},
      );
      expect(m.total, 0);
      expect(m.healthScore, 0);
    });

    test('aggregates status methods api types endpoints and latency', () {
      final metas = [
        _meta(
          id: '1',
          method: HTTPVerb.get,
          apiType: APIType.rest,
          status: 200,
          at: DateTime(2026, 1, 1),
        ),
        _meta(
          id: '2',
          method: HTTPVerb.post,
          apiType: APIType.ai,
          status: 500,
          url: 'https://api.example/a',
          at: DateTime(2026, 1, 2),
        ),
        _meta(
          id: '3',
          method: HTTPVerb.get,
          apiType: APIType.graphql,
          status: 404,
          url: 'https://api.example/b',
          at: DateTime(2026, 1, 3),
        ),
      ];
      final m = buildCollectionDashboardMetrics(
        metas: metas,
        timingsMsByHistoryId: const {'1': 100, '2': 400, '3': 200},
      );
      expect(m.total, 3);
      expect(m.status2xx, 1);
      expect(m.status4xx, 1);
      expect(m.status5xx, 1);
      expect(m.successCount, 1);
      expect(m.failCount, 2);
      expect(m.methodCounts[HTTPVerb.get], 2);
      expect(m.methodCounts[HTTPVerb.post], 1);
      expect(m.apiTypeCounts[APIType.rest], 1);
      expect(m.apiTypeCounts[APIType.ai], 1);
      expect(m.apiTypeCounts[APIType.graphql], 1);
      expect(m.uniqueEndpoints, 2);
      expect(m.avgMs, 233);
      expect(m.peakMs, 400);
      expect(m.p50Ms, isNotNull);
      expect(m.recentErrors.length, greaterThanOrEqualTo(1));
      expect(m.slowest.first.durationMs, 400);
      expect(m.topEndpoints.first.url, 'https://api.example/a');
      expect(m.healthScore, inInclusiveRange(0, 100));
      expect(m.timingTrend.length, 3);
    });
  });

  group('buildWorkflowDashboardMetrics', () {
    test('empty metas', () {
      final m = buildWorkflowDashboardMetrics(metas: const []);
      expect(m.totalRuns, 0);
      expect(m.successRate, 0);
      expect(m.nodeFailures, isEmpty);
    });

    test('success rate durations and node failures', () {
      final metas = [
        _flow(runId: 'a', success: true, started: DateTime(2026, 1, 1), durationSec: 1),
        _flow(
          runId: 'b',
          success: false,
          started: DateTime(2026, 1, 2),
          durationSec: 3,
          error: 'boom',
        ),
      ];
      final m = buildWorkflowDashboardMetrics(
        metas: metas,
        nodeFailuresByRun: {
          'b': const [
            WorkflowNodeFailStat(label: 'Login', failCount: 2, avgMs: 50),
            WorkflowNodeFailStat(label: 'Fetch', failCount: 1, avgMs: 10),
          ],
        },
      );
      expect(m.totalRuns, 2);
      expect(m.successCount, 1);
      expect(m.failCount, 1);
      expect(m.successRate, 0.5);
      expect(m.avgDurationMs, 2000);
      expect(m.peakDurationMs, 3000);
      expect(m.nodeFailures.first.label, 'Login');
      expect(m.nodeFailures.first.failCount, 2);
      expect(m.recentRuns.length, 2);
      expect(m.recentRuns.any((r) => r.error == 'boom'), isTrue);
    });
  });

  group('buildScriptCoverage', () {
    test('handles missing json and whitespace scripts', () {
      final c = buildScriptCoverage([
        (collectionId: 'c', requestId: 'r1', json: null),
        (
          collectionId: 'c',
          requestId: 'r2',
          json: {
            'name': '  ',
            'preRequestScript': '   ',
            'postRequestScript': 'ok',
          },
        ),
      ]);
      expect(c.totalRequests, 2);
      expect(c.withPostScript, 1);
      expect(c.withPreScript, 0);
      expect(c.withAnyScript, 1);
      expect(c.requests.first.name, 'r1');
      expect(c.uncoveredTests.length, 1);
      expect(c.scriptCoverage, 0.5);
    });
  });

  group('buildUnifiedExecutionHistory', () {
    final request = _meta(id: 'h1', at: DateTime(2026, 1, 1, 12));
    final flow = _flow(
      runId: 'run1',
      success: false,
      started: DateTime(2026, 1, 1, 13),
    );

    test('merges and sorts newest first', () {
      final entries = buildUnifiedExecutionHistory(
        requestMetas: [request],
        timingsMsByHistoryId: const {'h1': 50},
        flowMetas: [flow],
      );
      expect(entries.length, 2);
      expect(entries.first.kind, ExecutionKind.workflow);
      expect(entries.last.kind, ExecutionKind.request);
      expect(entries.last.durationMs, 50);
    });

    test('filter requests only', () {
      final entries = buildUnifiedExecutionHistory(
        requestMetas: [request],
        timingsMsByHistoryId: const {},
        flowMetas: [flow],
        filter: ExecutionHistoryFilter.requests,
      );
      expect(entries.length, 1);
      expect(entries.single.kind, ExecutionKind.request);
    });

    test('filter workflows only', () {
      final entries = buildUnifiedExecutionHistory(
        requestMetas: [request],
        timingsMsByHistoryId: const {},
        flowMetas: [flow],
        filter: ExecutionHistoryFilter.workflows,
      );
      expect(entries.length, 1);
      expect(entries.single.kind, ExecutionKind.workflow);
    });

    test('respects limit', () {
      final many = [
        for (var i = 0; i < 5; i++)
          _meta(id: 'h$i', at: DateTime(2026, 1, 1).add(Duration(hours: i))),
      ];
      final entries = buildUnifiedExecutionHistory(
        requestMetas: many,
        timingsMsByHistoryId: const {},
        flowMetas: const [],
        limit: 3,
      );
      expect(entries.length, 3);
    });
  });

  group('buildWebhookPayload', () {
    final collection = buildCollectionDashboardMetrics(
      metas: [
        _meta(id: '1', status: 200, at: DateTime(2026, 1, 1)),
        _meta(id: '2', status: 500, method: HTTPVerb.post, at: DateTime(2026, 1, 2)),
      ],
      timingsMsByHistoryId: const {'1': 100, '2': 200},
    );
    final workflow = buildWorkflowDashboardMetrics(
      metas: [
        _flow(runId: 'a', success: true, started: DateTime(2026, 1, 1)),
        _flow(runId: 'b', success: false, started: DateTime(2026, 1, 2)),
      ],
    );
    final coverage = buildScriptCoverage([
      (
        collectionId: 'c',
        requestId: 'r1',
        json: {'name': 'T', 'postRequestScript': 'x'},
      ),
    ]);

    test('raw combined payload includes collection and workflow', () {
      final payload = buildWebhookPayload(
        reportName: 'Health',
        collection: collection,
        workflow: workflow,
        timeRangeLabel: '7d',
        collectionFilter: null,
        workflowFilter: 'w1',
        coverage: coverage,
        format: WebhookPayloadFormat.raw,
      );
      expect(payload['type'], 'dashboard');
      expect(payload['reportName'], 'Health');
      expect(payload['scope'], {
        'timeRange': '7d',
        'collectionId': 'all',
        'workflowId': 'w1',
      });
      final c = payload['collection'] as Map;
      expect(c['totalRequests'], 2);
      expect(c['healthScore'], isA<int>());
      expect(c['testCoverage'], isA<Map>());
      final w = payload['workflow'] as Map;
      expect(w['totalRuns'], 2);
      expect(w['failures'], 1);
      expect(w.containsKey('recentRuns'), isTrue);
    });

    test('slack payload has text and blocks for both sides', () {
      final payload = buildWebhookPayload(
        reportName: 'Health',
        collection: collection,
        workflow: workflow,
        timeRangeLabel: '24h',
        format: WebhookPayloadFormat.slack,
      );
      expect(payload['text'], contains('Collections'));
      expect(payload['text'], contains('Workflows'));
      final blocks = payload['blocks'] as List;
      expect(blocks, isNotEmpty);
      final texts = blocks
          .whereType<Map>()
          .map((b) => b['text'])
          .whereType<Map>()
          .map((t) => t['text'])
          .whereType<String>()
          .join(' ');
      expect(texts, contains('Collections'));
      expect(texts, contains('Workflows'));
    });

    test('discord payload has content and two embeds', () {
      final payload = buildWebhookPayload(
        reportName: 'Health',
        collection: collection,
        workflow: workflow,
        timeRangeLabel: '30d',
        format: WebhookPayloadFormat.discord,
      );
      expect(payload['content'], contains('Health'));
      final embeds = payload['embeds'] as List;
      expect(embeds.length, 2);
      expect((embeds[0] as Map)['title'], contains('Collections'));
      expect((embeds[1] as Map)['title'], contains('Workflows'));
      expect((embeds[0] as Map)['fields'], isA<List>());
    });
  });
}
