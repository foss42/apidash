import 'dart:convert';
import 'dart:io' as io;

import 'package:apidash/models/models.dart';
import 'package:apidash/workflow/models/workflow_history_models.dart';
import 'package:apidash_core/apidash_core.dart';

import '../models/dashboard_models.dart';

bool isHttpSuccess(int status) => status >= 200 && status < 400;

int statusBucket(int status) {
  if (status >= 500) return 5;
  if (status >= 400) return 4;
  if (status >= 300) return 3;
  if (status >= 200) return 2;
  return 0;
}

int computeHealthScore({
  required int total,
  required int successCount,
  required int clientErrors,
  required int serverErrors,
}) {
  if (total <= 0) return 0;
  final successRate = successCount / total;
  final errorRatio = (clientErrors + serverErrors) / total;
  return ((successRate * 75) + ((1 - errorRatio) * 25)).round().clamp(0, 100);
}

int? percentileMs(List<int> sortedAsc, double p) {
  if (sortedAsc.isEmpty) return null;
  final idx = ((sortedAsc.length - 1) * p).round().clamp(0, sortedAsc.length - 1);
  return sortedAsc[idx];
}

int? averageMs(List<int> values) {
  if (values.isEmpty) return null;
  return (values.reduce((a, b) => a + b) / values.length).round();
}

List<HistoryMetaModel> filterHistoryMetas({
  required Iterable<HistoryMetaModel> metas,
  required DateTime? since,
  required String? collectionId,
  required Map<String, String> requestToCollection,
}) {
  return [
    for (final m in metas)
      if ((since == null || !m.timeStamp.isBefore(since)) &&
          (collectionId == null ||
              requestToCollection[m.requestId] == collectionId))
        m,
  ]..sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
}

CollectionDashboardMetrics buildCollectionDashboardMetrics({
  required List<HistoryMetaModel> metas,
  required Map<String, int> timingsMsByHistoryId,
}) {
  if (metas.isEmpty) return CollectionDashboardMetrics.empty;

  var s2 = 0, s3 = 0, s4 = 0, s5 = 0, success = 0;
  final methods = <HTTPVerb, int>{};
  final apiTypes = <APIType, int>{};
  final endpointCounts = <String, int>{};
  final endpointFail = <String, int>{};
  final endpointTimingSum = <String, int>{};
  final endpointTimingCount = <String, int>{};
  final timings = <int>[];
  final trend = <({DateTime at, int ms})>[];
  final timed = <TimedRequestStat>[];

  for (final m in metas) {
    final bucket = statusBucket(m.responseStatus);
    switch (bucket) {
      case 2:
        s2++;
        break;
      case 3:
        s3++;
        break;
      case 4:
        s4++;
        break;
      case 5:
        s5++;
        break;
    }
    if (isHttpSuccess(m.responseStatus)) success++;
    methods[m.method] = (methods[m.method] ?? 0) + 1;
    apiTypes[m.apiType] = (apiTypes[m.apiType] ?? 0) + 1;
    endpointCounts[m.url] = (endpointCounts[m.url] ?? 0) + 1;
    if (!isHttpSuccess(m.responseStatus)) {
      endpointFail[m.url] = (endpointFail[m.url] ?? 0) + 1;
    }

    final ms = timingsMsByHistoryId[m.historyId];
    if (ms != null) {
      timings.add(ms);
      trend.add((at: m.timeStamp, ms: ms));
      endpointTimingSum[m.url] = (endpointTimingSum[m.url] ?? 0) + ms;
      endpointTimingCount[m.url] = (endpointTimingCount[m.url] ?? 0) + 1;
      timed.add(
        TimedRequestStat(
          historyId: m.historyId,
          name: m.name,
          url: m.url,
          method: m.method,
          status: m.responseStatus,
          timeStamp: m.timeStamp,
          durationMs: ms,
        ),
      );
    }
  }

  final sortedTimings = [...timings]..sort();
  final topEndpoints = endpointCounts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final endpointStats = [
    for (final e in topEndpoints.take(8))
      EndpointStat(
        url: e.key,
        count: e.value,
        avgMs: endpointTimingCount[e.key] == null
            ? null
            : (endpointTimingSum[e.key]! / endpointTimingCount[e.key]!).round(),
        failCount: endpointFail[e.key] ?? 0,
      ),
  ];

  final slowest = [...timed]..sort((a, b) => b.durationMs.compareTo(a.durationMs));
  final errors = [
    for (final t in timed.reversed)
      if (!isHttpSuccess(t.status)) t,
  ].take(12).toList();

  final recentHealth = [
    for (final m in metas.reversed.take(24).toList().reversed)
      statusBucket(m.responseStatus),
  ];

  final total = metas.length;
  final fail = total - success;

  return CollectionDashboardMetrics(
    total: total,
    successCount: success,
    failCount: fail,
    status2xx: s2,
    status3xx: s3,
    status4xx: s4,
    status5xx: s5,
    methodCounts: methods,
    apiTypeCounts: apiTypes,
    uniqueEndpoints: endpointCounts.length,
    lastRunAt: metas.last.timeStamp,
    healthScore: computeHealthScore(
      total: total,
      successCount: success,
      clientErrors: s4,
      serverErrors: s5,
    ),
    successRate: total == 0 ? 0 : success / total,
    errorRatio: total == 0 ? 0 : (s4 + s5) / total,
    timingsMs: sortedTimings,
    avgMs: averageMs(sortedTimings),
    peakMs: sortedTimings.isEmpty ? null : sortedTimings.last,
    p50Ms: percentileMs(sortedTimings, 0.50),
    p95Ms: percentileMs(sortedTimings, 0.95),
    p99Ms: percentileMs(sortedTimings, 0.99),
    timingTrend: trend.length > 60 ? trend.sublist(trend.length - 60) : trend,
    recentHealth: recentHealth,
    topEndpoints: endpointStats,
    slowest: slowest.take(10).toList(),
    recentErrors: errors,
  );
}

WorkflowDashboardMetrics buildWorkflowDashboardMetrics({
  required List<FlowHistoryMeta> metas,
  Map<String, List<WorkflowNodeFailStat>> nodeFailuresByRun = const {},
}) {
  if (metas.isEmpty) return WorkflowDashboardMetrics.empty;

  final chronological = [...metas]..sort((a, b) => a.startedAt.compareTo(b.startedAt));
  var success = 0;
  final durations = <int>[];
  var stepSum = 0;
  final trend = <({DateTime at, int ms, bool success})>[];
  final nodeAgg = <String, ({int fails, int msSum, int msCount})>{};

  for (final m in chronological) {
    if (m.success) success++;
    durations.add(m.durationMs);
    stepSum += m.stepCount;
    trend.add((at: m.startedAt, ms: m.durationMs, success: m.success));
    final fails = nodeFailuresByRun[m.runId];
    if (fails != null) {
      for (final f in fails) {
        final prev = nodeAgg[f.label] ?? (fails: 0, msSum: 0, msCount: 0);
        nodeAgg[f.label] = (
          fails: prev.fails + f.failCount,
          msSum: prev.msSum + (f.avgMs ?? 0),
          msCount: prev.msCount + (f.avgMs == null ? 0 : 1),
        );
      }
    }
  }

  final fail = chronological.length - success;
  final recent = [...chronological].reversed.take(20).map((m) {
    return FlowRunRow(
      runId: m.runId,
      workflowName: m.workflowName,
      success: m.success,
      startedAt: m.startedAt,
      durationMs: m.durationMs,
      stepCount: m.stepCount,
      error: m.error,
    );
  }).toList();

  final nodeFailures = nodeAgg.entries
      .map(
        (e) => WorkflowNodeFailStat(
          label: e.key,
          failCount: e.value.fails,
          avgMs: e.value.msCount == 0
              ? null
              : (e.value.msSum / e.value.msCount).round(),
        ),
      )
      .toList()
    ..sort((a, b) => b.failCount.compareTo(a.failCount));

  return WorkflowDashboardMetrics(
    totalRuns: chronological.length,
    successCount: success,
    failCount: fail,
    successRate: chronological.isEmpty ? 0 : success / chronological.length,
    avgDurationMs: averageMs(durations),
    peakDurationMs: durations.isEmpty ? null : (durations.toList()..sort()).last,
    avgStepCount: chronological.isEmpty ? 0 : stepSum / chronological.length,
    lastRunAt: chronological.last.startedAt,
    durationTrend:
        trend.length > 40 ? trend.sublist(trend.length - 40) : trend,
    recentRuns: recent,
    nodeFailures: nodeFailures.take(8).toList(),
  );
}

/// Lightweight extract of response time from a history request JSON map.
int? timingMsFromHistoryJson(dynamic json) {
  if (json is! Map) return null;
  final resp = json['httpResponseModel'];
  if (resp is! Map) return null;
  final time = resp['time'];
  if (time is! num) return null;
  return Duration(microseconds: time.toInt()).inMilliseconds;
}

bool _nonEmptyScript(dynamic value) {
  if (value is! String) return false;
  return value.trim().isNotEmpty;
}

ScriptCoverage buildScriptCoverage(
  Iterable<({String collectionId, String requestId, Map<String, dynamic>? json})>
      rows,
) {
  final requests = <ScriptCoverageRequest>[];
  var pre = 0, post = 0, any = 0;
  for (final row in rows) {
    final json = row.json;
    final name = (json?['name'] as String?)?.trim();
    final hasPre = _nonEmptyScript(json?['preRequestScript']);
    final hasPost = _nonEmptyScript(json?['postRequestScript']);
    if (hasPre) pre++;
    if (hasPost) post++;
    if (hasPre || hasPost) any++;
    requests.add(
      ScriptCoverageRequest(
        collectionId: row.collectionId,
        requestId: row.requestId,
        name: (name == null || name.isEmpty) ? row.requestId : name,
        hasPre: hasPre,
        hasPost: hasPost,
      ),
    );
  }
  return ScriptCoverage(
    totalRequests: requests.length,
    withPreScript: pre,
    withPostScript: post,
    withAnyScript: any,
    requests: requests,
  );
}

List<ExecutionHistoryEntry> buildUnifiedExecutionHistory({
  required List<HistoryMetaModel> requestMetas,
  required Map<String, int> timingsMsByHistoryId,
  required List<FlowHistoryMeta> flowMetas,
  ExecutionHistoryFilter filter = ExecutionHistoryFilter.all,
  int limit = 80,
}) {
  final entries = <ExecutionHistoryEntry>[];
  if (filter != ExecutionHistoryFilter.workflows) {
    for (final m in requestMetas) {
      entries.add(
        ExecutionHistoryEntry(
          kind: ExecutionKind.request,
          id: m.historyId,
          title: m.name.isNotEmpty ? m.name : m.url,
          at: m.timeStamp,
          success: isHttpSuccess(m.responseStatus),
          durationMs: timingsMsByHistoryId[m.historyId],
          detail: '${m.responseStatus}',
          method: m.method,
          statusCode: m.responseStatus,
        ),
      );
    }
  }
  if (filter != ExecutionHistoryFilter.requests) {
    for (final m in flowMetas) {
      entries.add(
        ExecutionHistoryEntry(
          kind: ExecutionKind.workflow,
          id: m.runId,
          title: m.workflowName.isNotEmpty ? m.workflowName : m.workflowId,
          at: m.startedAt,
          success: m.success,
          durationMs: m.durationMs,
          detail: m.success
              ? '${m.stepCount} steps'
              : (m.error?.isNotEmpty == true ? m.error : 'Failed'),
        ),
      );
    }
  }
  entries.sort((a, b) => b.at.compareTo(a.at));
  if (entries.length <= limit) return entries;
  return entries.sublist(0, limit);
}

Map<String, dynamic> buildWebhookPayload({
  required String reportName,
  required DashboardTab tab,
  required CollectionDashboardMetrics collection,
  required WorkflowDashboardMetrics workflow,
  ScriptCoverage? coverage,
}) {
  final generatedAt = DateTime.now().toUtc().toIso8601String();
  if (tab == DashboardTab.workflows) {
    return {
      'reportName': reportName,
      'generatedAt': generatedAt,
      'type': 'workflow',
      'workflow': {
        'totalRuns': workflow.totalRuns,
        'successRate': workflow.successRate,
        'failures': workflow.failCount,
        'avgDurationMs': workflow.avgDurationMs,
        'peakDurationMs': workflow.peakDurationMs,
      },
    };
  }
  return {
    'reportName': reportName,
    'generatedAt': generatedAt,
    'type': 'collection',
    'collection': {
      'totalRequests': collection.total,
      'successRate': collection.successRate,
      'failures': collection.failCount,
      'healthScore': collection.healthScore,
      'p95Ms': collection.p95Ms,
      'status': {
        '2xx': collection.status2xx,
        '3xx': collection.status3xx,
        '4xx': collection.status4xx,
        '5xx': collection.status5xx,
      },
      if (coverage != null)
        'testCoverage': {
          'totalRequests': coverage.totalRequests,
          'withPostScript': coverage.withPostScript,
          'withPreScript': coverage.withPreScript,
          'coverage': coverage.testCoverage,
        },
    },
  };
}

Future<({int statusCode, String message})> postWebhookJson({
  required String url,
  required Map<String, dynamic> payload,
}) async {
  final uri = Uri.tryParse(url.trim());
  if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
    throw ArgumentError('URL must be http(s)');
  }
  final client = io.HttpClient();
  try {
    final req = await client.postUrl(uri);
    req.headers.contentType = io.ContentType.json;
    req.add(utf8.encode(jsonEncode(payload)));
    final res = await req.close();
    await res.drain<void>();
    return (statusCode: res.statusCode, message: 'Sent · HTTP ${res.statusCode}');
  } finally {
    client.close(force: true);
  }
}

