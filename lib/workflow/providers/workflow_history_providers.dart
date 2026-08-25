import 'package:apidash/services/storage/workspace_storage.dart';
import 'package:apidash/utils/file_utils.dart';
import 'package:apidash/workflow/models/workflow_history_models.dart';
import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/providers/workflow_providers.dart';
import 'package:apidash/workflow/providers/workflow_ui_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final flowHistoryMetasProvider =
    StateNotifierProvider<FlowHistoryMetasNotifier, List<FlowHistoryMeta>>(
  (ref) => FlowHistoryMetasNotifier(),
);

class FlowHistoryMetasNotifier extends StateNotifier<List<FlowHistoryMeta>> {
  FlowHistoryMetasNotifier() : super(const []) {
    reload();
  }

  void reload() {
    if (!isWorkspaceStorageInitialized()) {
      state = const [];
      return;
    }
    final raw = workspaceStorage.getAllFlowHistoryMetas() ?? {};
    final metas = <FlowHistoryMeta>[];
    for (final entry in raw.entries) {
      try {
        metas.add(FlowHistoryMeta.fromJson(entry.value));
      } catch (_) {
        // Skip corrupt index rows.
      }
    }
    metas.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    state = metas;
  }

  Future<void> addRecord(FlowHistoryRecord record) async {
    if (!isWorkspaceStorageInitialized()) {
      return;
    }
    await workspaceStorage.setFlowHistoryRecord(
      record.meta.runId,
      record.toJson(),
    );
    await workspaceStorage.setFlowHistoryMeta(
      record.meta.runId,
      record.meta.toJson(),
    );
    reload();
  }

  Future<void> deleteRun(String runId) async {
    if (!isWorkspaceStorageInitialized()) {
      return;
    }
    await workspaceStorage.deleteFlowHistoryRecord(runId);
    reload();
  }

  Future<FlowHistoryRecord?> loadRecord(String runId) async {
    if (!isWorkspaceStorageInitialized()) {
      return null;
    }
    final json = await workspaceStorage.getFlowHistoryRecord(runId);
    if (json == null) {
      return null;
    }
    try {
      return FlowHistoryRecord.fromJson(json);
    } catch (_) {
      return null;
    }
  }
}

final flowHistoryForActiveWorkflowProvider =
    Provider<List<FlowHistoryMeta>>((ref) {
  final workflowId = ref.watch(activeWorkflowProvider)?.id;
  final all = ref.watch(flowHistoryMetasProvider);
  if (workflowId == null) {
    return const [];
  }
  return [
    for (final meta in all)
      if (meta.workflowId == workflowId) meta,
  ];
});

/// When set, the inspector is showing a persisted run (not the live run).
final viewingFlowHistoryRunIdProvider = StateProvider<String?>((ref) => null);

Future<void> persistWorkflowRunHistory({
  required WidgetRef ref,
  required WorkflowDocument workflow,
  required WorkflowRunResult result,
}) async {
  final runId = makeHistoryId(
    timeStamp: result.endedAt,
    name: workflow.name.isNotEmpty ? workflow.name : workflow.id,
  );
  final record = FlowHistoryRecord.fromRunResult(
    runId: runId,
    workflowName: workflow.name.isNotEmpty ? workflow.name : workflow.id,
    result: result,
  );
  await ref.read(flowHistoryMetasProvider.notifier).addRecord(record);
}

Future<void> openFlowHistoryInInspector({
  required WidgetRef ref,
  required String runId,
}) async {
  if (ref.read(workflowRunInProgressProvider)) {
    return;
  }
  final record =
      await ref.read(flowHistoryMetasProvider.notifier).loadRecord(runId);
  if (record == null) {
    return;
  }

  final workflowId = record.meta.workflowId.trim();
  if (workflowId.isNotEmpty) {
    ref.read(selectedWorkflowIdStateProvider.notifier).state = workflowId;
    final activeId = ref.read(activeWorkflowProvider)?.id;
    if (activeId != workflowId) {
      await ref.read(activeWorkflowProvider.notifier).load(workflowId);
    }
  }

  final byKey = <String, WorkflowNodeRunResult>{};
  final order = <String>[];
  for (final step in record.nodeResults) {
    final key = step.loopIndex != null
        ? '${step.nodeId}#${step.loopIndex}'
        : step.nodeId;
    byKey[step.nodeId] = step;
    byKey[key] = step;
    if (!order.contains(key)) {
      order.add(key);
    }
  }
  ref.read(workflowNodeRunResultsProvider.notifier).state = byKey;
  ref.read(workflowRunStepOrderProvider.notifier).state = order;
  ref.read(selectedWorkflowRunResultKeyProvider.notifier).state =
      order.isNotEmpty ? order.last : null;
  ref.read(viewingFlowHistoryRunIdProvider.notifier).state = runId;
  ref.read(workflowRunInspectorExpandedProvider.notifier).state = true;
}
