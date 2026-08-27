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
  required CollectionDashboardMetrics collection,
  required WorkflowDashboardMetrics workflow,
  required String timeRangeLabel,
  String? collectionFilter,
  String? workflowFilter,
  ScriptCoverage? coverage,
  WebhookPayloadFormat format = WebhookPayloadFormat.raw,
}) {
  final raw = _buildRawWebhookPayload(
    reportName: reportName,
    collection: collection,
    workflow: workflow,
    timeRangeLabel: timeRangeLabel,
    collectionFilter: collectionFilter,
    workflowFilter: workflowFilter,
    coverage: coverage,
  );
  return switch (format) {
    WebhookPayloadFormat.raw => raw,
    WebhookPayloadFormat.slack => _buildSlackWebhookPayload(raw),
    WebhookPayloadFormat.discord => _buildDiscordWebhookPayload(raw),
  };
}

Map<String, dynamic> _collectionWebhookMap(
  CollectionDashboardMetrics collection,
  ScriptCoverage? coverage,
) {
  return {
    'totalRequests': collection.total,
    'successCount': collection.successCount,
    'failures': collection.failCount,
    'successRate': collection.successRate,
    'healthScore': collection.healthScore,
    'errorRatio': collection.errorRatio,
    'uniqueEndpoints': collection.uniqueEndpoints,
    'avgMs': collection.avgMs,
    'peakMs': collection.peakMs,
    'p50Ms': collection.p50Ms,
    'p95Ms': collection.p95Ms,
    'p99Ms': collection.p99Ms,
    'lastRunAt': collection.lastRunAt?.toUtc().toIso8601String(),
    'status': {
      '2xx': collection.status2xx,
      '3xx': collection.status3xx,
      '4xx': collection.status4xx,
      '5xx': collection.status5xx,
    },
    'methods': {
      for (final e in collection.methodCounts.entries) e.key.name: e.value,
    },
    'apiTypes': {
      for (final e in collection.apiTypeCounts.entries) e.key.name: e.value,
    },
    'topEndpoints': [
      for (final e in collection.topEndpoints.take(10))
        {
          'url': e.url,
          'calls': e.count,
          'avgMs': e.avgMs,
          'fails': e.failCount,
        },
    ],
    'recentErrors': [
      for (final e in collection.recentErrors.take(10))
        {
          'name': e.name,
          'url': e.url,
          'method': e.method.name,
          'status': e.status,
          'durationMs': e.durationMs,
          'at': e.timeStamp.toUtc().toIso8601String(),
        },
    ],
    if (coverage != null)
      'testCoverage': {
        'totalRequests': coverage.totalRequests,
        'withPostScript': coverage.withPostScript,
        'withPreScript': coverage.withPreScript,
        'withAnyScript': coverage.withAnyScript,
        'coverage': coverage.testCoverage,
        'scriptCoverage': coverage.scriptCoverage,
      },
  };
}

Map<String, dynamic> _workflowWebhookMap(WorkflowDashboardMetrics workflow) {
  return {
    'totalRuns': workflow.totalRuns,
    'successCount': workflow.successCount,
    'failures': workflow.failCount,
    'successRate': workflow.successRate,
    'avgDurationMs': workflow.avgDurationMs,
    'peakDurationMs': workflow.peakDurationMs,
    'avgStepCount': workflow.avgStepCount,
    'lastRunAt': workflow.lastRunAt?.toUtc().toIso8601String(),
    'failingNodes': [
      for (final n in workflow.nodeFailures)
        {
          'label': n.label,
          'failCount': n.failCount,
          'avgMs': n.avgMs,
        },
    ],
    'recentRuns': [
      for (final r in workflow.recentRuns.take(10))
        {
          'runId': r.runId,
          'workflowName': r.workflowName,
          'success': r.success,
          'startedAt': r.startedAt.toUtc().toIso8601String(),
          'durationMs': r.durationMs,
          'stepCount': r.stepCount,
          if (r.error != null && r.error!.isNotEmpty) 'error': r.error,
        },
    ],
  };
}

Map<String, dynamic> _buildRawWebhookPayload({
  required String reportName,
  required CollectionDashboardMetrics collection,
  required WorkflowDashboardMetrics workflow,
  required String timeRangeLabel,
  String? collectionFilter,
  String? workflowFilter,
  ScriptCoverage? coverage,
}) {
  return {
    'reportName': reportName,
    'generatedAt': DateTime.now().toUtc().toIso8601String(),
    'type': 'dashboard',
    'scope': {
      'timeRange': timeRangeLabel,
      'collectionId': collectionFilter ?? 'all',
      'workflowId': workflowFilter ?? 'all',
    },
    'collection': _collectionWebhookMap(collection, coverage),
    'workflow': _workflowWebhookMap(workflow),
  };
}

String _pct(num? rate) {
  if (rate == null) return '—';
  return '${(rate.toDouble() * 100).toStringAsFixed(1)}%';
}

String _ms(num? ms) {
  if (ms == null) return '—';
  final v = ms.round();
  if (v < 1000) return '${v}ms';
  return '${(v / 1000).toStringAsFixed(v >= 10000 ? 0 : 1)}s';
}

List<({String label, String value})> _collectionSummaryFields(
  Map<String, dynamic> raw,
) {
  final scope = raw['scope'];
  final range = scope is Map ? '${scope['timeRange'] ?? '—'}' : '—';
  final c = raw['collection'];
  final m = c is Map ? c : const <String, dynamic>{};
  final cov = m['testCoverage'];
  final covMap = cov is Map ? cov : null;
  return [
    (label: 'Range', value: range),
    (label: 'Health', value: '${m['healthScore'] ?? 0}'),
    (label: 'Requests', value: '${m['totalRequests'] ?? 0}'),
    (label: 'Success', value: _pct(m['successRate'] as num?)),
    (label: 'Failures', value: '${m['failures'] ?? 0}'),
    (label: 'P95', value: _ms(m['p95Ms'] as num?)),
    if (covMap != null)
      (label: 'Test coverage', value: _pct(covMap['coverage'] as num?)),
  ];
}

List<({String label, String value})> _workflowSummaryFields(
  Map<String, dynamic> raw,
) {
  final scope = raw['scope'];
  final range = scope is Map ? '${scope['timeRange'] ?? '—'}' : '—';
  final w = raw['workflow'];
  final m = w is Map ? w : const <String, dynamic>{};
  return [
    (label: 'Range', value: range),
    (label: 'Runs', value: '${m['totalRuns'] ?? 0}'),
    (label: 'Success', value: _pct(m['successRate'] as num?)),
    (label: 'Failures', value: '${m['failures'] ?? 0}'),
    (label: 'Avg duration', value: _ms(m['avgDurationMs'] as num?)),
    (label: 'Peak duration', value: _ms(m['peakDurationMs'] as num?)),
  ];
}

String _combinedFallbackText(Map<String, dynamic> raw) {
  final title = (raw['reportName'] as String?)?.trim().isNotEmpty == true
      ? raw['reportName'] as String
      : 'API Dash Health Report';
  final scope = raw['scope'];
  final range = scope is Map ? '${scope['timeRange'] ?? '—'}' : '—';
  final c = raw['collection'];
  final cm = c is Map ? c : const <String, dynamic>{};
  final w = raw['workflow'];
  final wm = w is Map ? w : const <String, dynamic>{};
  return '$title · $range · '
      'Collections health ${cm['healthScore'] ?? 0} '
      '(${_pct(cm['successRate'] as num?)}) · '
      'Workflows ${wm['totalRuns'] ?? 0} runs '
      '(${_pct(wm['successRate'] as num?)})';
}

List<Map<String, dynamic>> _slackFieldSections(
  List<({String label, String value})> fields,
) {
  final blocks = <Map<String, dynamic>>[];
  for (var i = 0; i < fields.length; i += 2) {
    final slice = fields.skip(i).take(2).toList();
    blocks.add({
      'type': 'section',
      'fields': [
        for (final f in slice)
          {
            'type': 'mrkdwn',
            'text': '*${f.label}*\n${f.value}',
          },
      ],
    });
  }
  return blocks;
}

/// Slack Incoming Webhooks: `text` + Block Kit (collections + workflows).
Map<String, dynamic> _buildSlackWebhookPayload(Map<String, dynamic> raw) {
  final title = (raw['reportName'] as String?)?.trim().isNotEmpty == true
      ? raw['reportName'] as String
      : 'API Dash Health Report';
  final header = title.length > 150 ? '${title.substring(0, 147)}...' : title;
  return {
    'text': _combinedFallbackText(raw),
    'blocks': [
      {
        'type': 'header',
        'text': {
          'type': 'plain_text',
          'text': header,
          'emoji': true,
        },
      },
      {
        'type': 'section',
        'text': {
          'type': 'mrkdwn',
          'text': '*Collections*',
        },
      },
      ..._slackFieldSections(_collectionSummaryFields(raw)),
      {'type': 'divider'},
      {
        'type': 'section',
        'text': {
          'type': 'mrkdwn',
          'text': '*Workflows*',
        },
      },
      ..._slackFieldSections(_workflowSummaryFields(raw)),
      {
        'type': 'context',
        'elements': [
          {
            'type': 'mrkdwn',
            'text': 'Sent from API Dash Dashboard',
          },
        ],
      },
    ],
  };
}

/// Discord webhooks: two embeds (collections + workflows).
Map<String, dynamic> _buildDiscordWebhookPayload(Map<String, dynamic> raw) {
  final title = (raw['reportName'] as String?)?.trim().isNotEmpty == true
      ? raw['reportName'] as String
      : 'API Dash Health Report';
  return {
    'content': _combinedFallbackText(raw),
    'embeds': [
      {
        'title': '$title · Collections',
        'color': 0x57F287,
        'fields': [
          for (final f in _collectionSummaryFields(raw))
            {
              'name': f.label,
              'value': f.value,
              'inline': true,
            },
        ],
        'footer': {'text': 'API Dash Dashboard'},
      },
      {
        'title': '$title · Workflows',
        'color': 0x5865F2,
        'fields': [
          for (final f in _workflowSummaryFields(raw))
            {
              'name': f.label,
              'value': f.value,
              'inline': true,
            },
        ],
        'footer': {'text': 'API Dash Dashboard'},
      },
    ],
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

