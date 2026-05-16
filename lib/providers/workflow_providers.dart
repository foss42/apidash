import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/screens/dashboard/workflow_dashboard_analytics.dart';
import 'package:apidash/services/file_system_handler.dart';
import 'package:apidash/utils/utils.dart';

final workflowIdStateProvider = StateProvider<String?>((ref) => null);

final workflowRunHistoryRevisionProvider = StateProvider<int>((ref) => 0);

final workflowDashboardDataProvider =
    FutureProvider.family<WorkflowDashboardData, String>((ref, workflowId) async {
  ref.keepAlive();
  ref.watch(workflowRunHistoryRevisionProvider);
  final model =
      ref.watch(workflowsStateProvider.select((m) => m[workflowId]));
  if (model == null) {
    throw StateError('Workflow not found: $workflowId');
  }
  return buildWorkflowDashboardData(workflowId, model);
});

final workflowsStateProvider =
    StateNotifierProvider<WorkflowStateNotifier, Map<String, WorkflowModel>>(
  (ref) => WorkflowStateNotifier(ref, fileSystemHandler),
);

class WorkflowStateNotifier extends StateNotifier<Map<String, WorkflowModel>> {
  WorkflowStateNotifier(this.ref, this.fileSystemHandler) : super(const {}) {
    unawaited(_load());
  }

  final Ref ref;
  final FileSystemHandler fileSystemHandler;

  String? get activeWorkflowId => ref.read(workflowIdStateProvider);

  Future<void> _load() async {
    final storedIdsRaw = await fileSystemHandler.getWorkflowIds();
    final storedIds =
        (storedIdsRaw as List?)?.whereType<String>().toList() ??
            const <String>[];
    final activeId = await fileSystemHandler.getActiveWorkflowId();
    final ids = storedIds.isNotEmpty
        ? storedIds
        : <String>[
            if (activeId != null && activeId.isNotEmpty) activeId,
          ];
    final workflows = <String, WorkflowModel>{};
    for (final id in ids) {
      final raw = await fileSystemHandler.getWorkflow(id);
      if (raw is Map) {
        final json = raw.map((k, v) => MapEntry(k.toString(), v));
        try {
          workflows[id] = WorkflowModel.fromJson(json);
        } catch (_) {
          workflows[id] = _fallbackWorkflowFromLegacyJson(id, json);
        }
      }
    }
    state = workflows;
    final savedActive = activeId;
    final loaded = Map<String, WorkflowModel>.from(workflows);
    Future.microtask(() {
      if (savedActive != null && loaded.containsKey(savedActive)) {
        ref.read(workflowIdStateProvider.notifier).state = savedActive;
      } else if (loaded.isNotEmpty) {
        ref.read(workflowIdStateProvider.notifier).state = loaded.keys.first;
      }
    });
  }

  Future<WorkflowModel> createDefault() async {
    final now = DateTime.now();
    final id = getNewUuid();
    final model = WorkflowModel(
      id: id,
      name: 'Workflow ${state.length + 1}',
      createdAt: now,
      modifiedAt: now,
      graphData: const <String, dynamic>{},
    );
    state = {...state, id: model};
    await _persistWorkflows();
    setActive(id);
    return model;
  }

  void setActive(String workflowId) {
    if (!state.containsKey(workflowId)) return;
    ref.read(workflowIdStateProvider.notifier).state = workflowId;
    unawaited(fileSystemHandler.setActiveWorkflowId(workflowId));
  }

  Future<void> saveGraph({
    required String workflowId,
    required Map<String, dynamic> graphData,
  }) async {
    final existing = state[workflowId];
    if (existing == null) return;
    final updated = existing.copyWith(
      graphData: graphData,
      modifiedAt: DateTime.now(),
    );
    state = {...state, workflowId: updated};
    await fileSystemHandler.setWorkflow(workflowId, updated.toJson());
  }

  Future<void> importFromJson(String source) async {
    final decoded = jsonDecode(source);
    if (decoded is! Map) {
      throw const FormatException('Workflow JSON must be an object');
    }
    final model = WorkflowModel.fromJson(
      decoded.map((k, v) => MapEntry(k.toString(), v)),
    );
    state = {...state, model.id: model};
    await _persistWorkflows();
    setActive(model.id);
  }

  String exportToJson(String workflowId) {
    final model = state[workflowId];
    if (model == null) {
      throw StateError('Workflow not found');
    }
    return const JsonEncoder.withIndent('  ').convert(model.toJson());
  }

  Future<void> _persistWorkflows() async {
    final ids = state.keys.toList(growable: false);
    await fileSystemHandler.setWorkflowIds(ids);
    for (final entry in state.entries) {
      await fileSystemHandler.setWorkflow(entry.key, entry.value.toJson());
    }
  }
}

WorkflowModel _fallbackWorkflowFromLegacyJson(
  String id,
  Map<String, dynamic> json,
) {
  final now = DateTime.now();
  DateTime parseDate(dynamic value) {
    final text = value?.toString();
    if (text == null || text.isEmpty) return now;
    return DateTime.tryParse(text) ?? now;
  }

  final graphRaw = json['graphData'];
  final graph = graphRaw is Map
      ? graphRaw.map((k, v) => MapEntry(k.toString(), v))
      : const <String, dynamic>{};
  return WorkflowModel(
    id: json['id']?.toString().isNotEmpty == true ? json['id'].toString() : id,
    name: json['name']?.toString().isNotEmpty == true
        ? json['name'].toString()
        : 'Untitled Workflow',
    description: json['description']?.toString() ?? '',
    schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
    createdAt: parseDate(json['createdAt']),
    modifiedAt: parseDate(json['modifiedAt']),
    graphData: graph,
  );
}
