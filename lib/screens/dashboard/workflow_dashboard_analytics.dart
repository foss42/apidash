import 'package:apidash/models/models.dart';
import 'package:apidash/services/file_system_handler.dart';

class WorkflowDashboardData {
  const WorkflowDashboardData({
    required this.totalNodes,
    required this.totalRuns,
    required this.successRuns,
    required this.failedRuns,
    required this.avgMs,
    required this.durations,
    required this.recentRuns,
  });

  final int totalNodes;
  final int totalRuns;
  final int successRuns;
  final int failedRuns;
  final int avgMs;
  final List<int> durations;
  final List<WorkflowDashboardRunRow> recentRuns;

  double get successRate => totalRuns == 0 ? 0 : successRuns / totalRuns;
  String get successRateLabel =>
      totalRuns == 0 ? '—' : '${(successRate * 100).toStringAsFixed(1)}%';
}

class WorkflowDashboardRunRow {
  const WorkflowDashboardRunRow({
    required this.startedAt,
    required this.success,
    required this.durationMs,
  });

  final DateTime? startedAt;
  final bool success;
  final int durationMs;
}

class _WorkflowRunHistoryEntry {
  const _WorkflowRunHistoryEntry({
    required this.success,
    required this.startedAt,
    required this.durationMs,
  });

  final bool success;
  final DateTime? startedAt;
  final int durationMs;
}

Future<WorkflowDashboardData> buildWorkflowDashboardData(
  String workflowId,
  WorkflowModel workflow,
) async {
  final nodes = workflow.graphData['nodes'];
  final nodeCount = nodes is List ? nodes.length : 0;
  final raw = await fileSystemHandler.getWorkflowRunHistory(workflowId);
  final runs = raw is List ? raw.whereType<Map>().toList(growable: false) : const <Map>[];

  final entries = <_WorkflowRunHistoryEntry>[];
  for (final run in runs) {
    final json = run.map((k, v) => MapEntry(k.toString(), v));
    final ok = json['success'] as bool? ?? false;
    final start = DateTime.tryParse(json['startedAt']?.toString() ?? '');
    final end = DateTime.tryParse(json['endedAt']?.toString() ?? '');
    final duration = start != null && end != null ? end.difference(start).inMilliseconds : 0;
    entries.add(
      _WorkflowRunHistoryEntry(
        success: ok,
        startedAt: start,
        durationMs: duration,
      ),
    );
  }

  entries.sort(
    (a, b) => (a.startedAt ?? DateTime.fromMillisecondsSinceEpoch(0))
        .compareTo(b.startedAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
  );

  var success = 0;
  var failed = 0;
  final durations = <int>[];
  for (final e in entries) {
    if (e.success) {
      success += 1;
    } else {
      failed += 1;
    }
    durations.add(e.durationMs);
  }

  final recentRuns = entries.reversed
      .map(
        (e) => WorkflowDashboardRunRow(
          startedAt: e.startedAt,
          success: e.success,
          durationMs: e.durationMs,
        ),
      )
      .toList(growable: false);

  final avg = durations.isEmpty ? 0 : (durations.reduce((a, b) => a + b) / durations.length).round();
  return WorkflowDashboardData(
    totalNodes: nodeCount,
    totalRuns: runs.length,
    successRuns: success,
    failedRuns: failed,
    avgMs: avg,
    durations: durations,
    recentRuns: recentRuns,
  );
}
