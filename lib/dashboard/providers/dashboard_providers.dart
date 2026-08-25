import 'dart:async';

import 'package:apidash/models/models.dart';
import 'package:apidash/providers/collection_catalog_providers.dart';
import 'package:apidash/providers/history_providers.dart';
import 'package:apidash/services/services.dart';
import 'package:apidash/workflow/models/workflow_history_models.dart';
import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/providers/workflow_history_providers.dart';
import 'package:apidash/workflow/providers/workflow_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/dashboard_models.dart';
import '../utils/dashboard_metrics.dart';

final dashboardTabProvider =
    StateProvider<DashboardTab>((ref) => DashboardTab.collections);

final dashboardTimeRangeProvider =
    StateProvider<DashboardTimeRange>((ref) => DashboardTimeRange.days7);

/// `null` = all collections.
final dashboardCollectionFilterProvider = StateProvider<String?>((ref) => null);

/// `null` = all workflows.
final dashboardWorkflowFilterProvider = StateProvider<String?>((ref) => null);

final dashboardRequestCollectionMapProvider =
    Provider<Map<String, String>>((ref) {
  ref.watch(collectionCatalogProvider);
  if (!isWorkspaceStorageInitialized()) return const {};
  final map = <String, String>{};
  for (final entry in workspaceStorage.getCollectionsIndex()) {
    for (final requestId in workspaceStorage.listRequestIdsOnDisk(entry.id)) {
      map[requestId] = entry.id;
    }
  }
  return map;
});

final filteredHistoryMetasProvider = Provider<List<HistoryMetaModel>>((ref) {
  final metas = ref.watch(historyMetaStateNotifier);
  final since = ref.watch(dashboardTimeRangeProvider).since;
  final collectionId = ref.watch(dashboardCollectionFilterProvider);
  final map = ref.watch(dashboardRequestCollectionMapProvider);
  if (metas == null || metas.isEmpty) return const [];
  return filterHistoryMetas(
    metas: metas.values,
    since: since,
    collectionId: collectionId,
    requestToCollection: map,
  );
});

final filteredHistoryIdsKeyProvider = Provider<String>((ref) {
  final metas = ref.watch(filteredHistoryMetasProvider);
  if (metas.isEmpty) return '';
  return metas.map((m) => m.historyId).join('\u0000');
});

final historyTimingsProvider =
    FutureProvider.autoDispose<Map<String, int>>((ref) async {
  // Watch a String key so equal ID sets do not retrigger mid-build.
  final idsKey = ref.watch(filteredHistoryIdsKeyProvider);
  if (idsKey.isEmpty || !isWorkspaceStorageInitialized()) {
    return const {};
  }
  final metas = ref.read(filteredHistoryMetasProvider);
  final out = <String, int>{};
  const batch = 24;
  for (var i = 0; i < metas.length; i += batch) {
    final slice = metas.skip(i).take(batch).toList();
    final results = await Future.wait([
      for (final m in slice) workspaceStorage.getHistoryRequest(m.historyId),
    ]);
    for (var j = 0; j < slice.length; j++) {
      final ms = timingMsFromHistoryJson(results[j]);
      if (ms != null) out[slice[j].historyId] = ms;
    }
  }
  return out;
});

final collectionDashboardProvider =
    Provider<AsyncValue<CollectionDashboardMetrics>>((ref) {
  final metas = ref.watch(filteredHistoryMetasProvider);
  final timingsAsync = ref.watch(historyTimingsProvider);
  return timingsAsync.when(
    data: (timings) => AsyncValue.data(
      buildCollectionDashboardMetrics(
        metas: metas,
        timingsMsByHistoryId: timings,
      ),
    ),
    loading: () => metas.isEmpty
        ? const AsyncValue.data(CollectionDashboardMetrics.empty)
        : const AsyncValue.loading(),
    error: (e, st) => AsyncValue.data(
      buildCollectionDashboardMetrics(metas: metas, timingsMsByHistoryId: const {}),
    ),
  );
});

final filteredFlowHistoryProvider = Provider<List<FlowHistoryMeta>>((ref) {
  final all = ref.watch(flowHistoryMetasProvider);
  final since = ref.watch(dashboardTimeRangeProvider).since;
  final workflowId = ref.watch(dashboardWorkflowFilterProvider);
  return [
    for (final m in all)
      if ((since == null || !m.startedAt.isBefore(since)) &&
          (workflowId == null || m.workflowId == workflowId))
        m,
  ];
});

/// Node failure rollup — loads full records only for failed runs (capped).
final workflowNodeFailuresProvider = FutureProvider.autoDispose<
    Map<String, List<WorkflowNodeFailStat>>>((ref) async {
  final metas = ref.watch(filteredFlowHistoryProvider);
  final failed = metas.where((m) => !m.success).take(30).toList();
  if (failed.isEmpty || !isWorkspaceStorageInitialized()) {
    return const {};
  }
  final out = <String, List<WorkflowNodeFailStat>>{};
  for (final meta in failed) {
    final record =
        await ref.read(flowHistoryMetasProvider.notifier).loadRecord(meta.runId);
    if (record == null) continue;
    final byLabel = <String, ({int fails, int msSum, int n})>{};
    for (final step in record.nodeResults) {
      if (step.status != WorkflowNodeRunStatus.failed) continue;
      final label = step.label.isNotEmpty ? step.label : step.nodeId;
      final prev = byLabel[label] ?? (fails: 0, msSum: 0, n: 0);
      byLabel[label] = (
        fails: prev.fails + 1,
        msSum: prev.msSum + (step.durationMs ?? 0),
        n: prev.n + (step.durationMs == null ? 0 : 1),
      );
    }
    out[meta.runId] = [
      for (final e in byLabel.entries)
        WorkflowNodeFailStat(
          label: e.key,
          failCount: e.value.fails,
          avgMs: e.value.n == 0 ? null : (e.value.msSum / e.value.n).round(),
        ),
    ];
  }
  return out;
});

final workflowDashboardProvider =
    Provider<AsyncValue<WorkflowDashboardMetrics>>((ref) {
  final metas = ref.watch(filteredFlowHistoryProvider);
  final nodesAsync = ref.watch(workflowNodeFailuresProvider);
  return nodesAsync.when(
    data: (nodes) => AsyncValue.data(
      buildWorkflowDashboardMetrics(metas: metas, nodeFailuresByRun: nodes),
    ),
    loading: () => AsyncValue.data(buildWorkflowDashboardMetrics(metas: metas)),
    error: (_, _) => AsyncValue.data(buildWorkflowDashboardMetrics(metas: metas)),
  );
});

final dashboardCollectionOptionsProvider =
    Provider<List<({String id, String name})>>((ref) {
  ref.watch(collectionCatalogProvider);
  if (!isWorkspaceStorageInitialized()) return const [];
  return workspaceStorage.getCollectionsIndex();
});

final dashboardWorkflowOptionsProvider = Provider<List<String>>((ref) {
  ref.watch(workflowCatalogProvider);
  if (!isWorkspaceStorageInitialized()) return const [];
  return workspaceStorage.getWorkflowsIndex();
});

/// Script / test coverage from on-disk collection requests (not history).
final scriptCoverageProvider =
    FutureProvider.autoDispose<ScriptCoverage>((ref) async {
  ref.watch(collectionCatalogProvider);
  final collectionFilter = ref.watch(dashboardCollectionFilterProvider);
  if (!isWorkspaceStorageInitialized()) {
    return ScriptCoverage.empty;
  }
  final collections = workspaceStorage.getCollectionsIndex();
  final scoped = collectionFilter == null
      ? collections
      : collections.where((c) => c.id == collectionFilter);
  final rows =
      <({String collectionId, String requestId, Map<String, dynamic>? json})>[];
  for (final c in scoped) {
    for (final requestId in workspaceStorage.listRequestIdsOnDisk(c.id)) {
      rows.add((
        collectionId: c.id,
        requestId: requestId,
        json: workspaceStorage.getRequestModel(c.id, requestId),
      ));
    }
  }
  return buildScriptCoverage(rows);
});

final webhookAutoSendProvider =
    StateNotifierProvider<WebhookAutoSendNotifier, WebhookAutoSendState>(
  (ref) => WebhookAutoSendNotifier(ref),
);

class WebhookAutoSendNotifier extends StateNotifier<WebhookAutoSendState> {
  WebhookAutoSendNotifier(this.ref) : super(const WebhookAutoSendState());

  final Ref ref;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void updateUrl(String url) => state = state.copyWith(url: url);

  void updateReportName(String name) =>
      state = state.copyWith(reportName: name);

  void updateInterval(WebhookInterval interval) {
    state = state.copyWith(interval: interval);
    if (state.active) {
      _restartTimer();
    }
  }

  Future<void> sendNow() async {
    final url = state.url.trim();
    if (url.isEmpty) {
      state = state.copyWith(lastStatus: 'Enter a webhook URL');
      return;
    }
    try {
      final payload = _currentPayload();
      final result = await postWebhookJson(url: url, payload: payload);
      state = state.copyWith(
        lastSentAt: DateTime.now(),
        lastStatus: result.message,
        nextSendAt: state.active
            ? DateTime.now().add(Duration(minutes: state.interval.minutes))
            : state.nextSendAt,
      );
    } catch (e) {
      state = state.copyWith(lastStatus: 'Failed: $e');
    }
  }

  void startAutoSend() {
    if (state.url.trim().isEmpty) {
      state = state.copyWith(lastStatus: 'Enter a webhook URL first');
      return;
    }
    state = state.copyWith(
      active: true,
      nextSendAt: DateTime.now().add(Duration(minutes: state.interval.minutes)),
      lastStatus: 'Auto-send started · every ${state.interval.label}',
    );
    _restartTimer();
  }

  void stopAutoSend() {
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(
      active: false,
      clearNext: true,
      lastStatus: 'Auto-send stopped',
    );
  }

  void _restartTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(minutes: state.interval.minutes),
      (_) => sendNow(),
    );
  }

  Map<String, dynamic> _currentPayload() {
    final tab = ref.read(dashboardTabProvider);
    final collection = ref.read(collectionDashboardProvider).value ??
        CollectionDashboardMetrics.empty;
    final workflow =
        ref.read(workflowDashboardProvider).value ?? WorkflowDashboardMetrics.empty;
    final coverage = ref.read(scriptCoverageProvider).value;
    final name = state.reportName.trim().isEmpty
        ? 'API Dash Health Report'
        : state.reportName.trim();
    return buildWebhookPayload(
      reportName: name,
      tab: tab,
      collection: collection,
      workflow: workflow,
      coverage: coverage,
    );
  }

  Map<String, dynamic> previewPayload() => _currentPayload();

  void markCopied() {
    state = state.copyWith(lastStatus: 'Payload copied');
  }
}
