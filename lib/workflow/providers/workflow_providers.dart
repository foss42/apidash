import 'package:apidash/workflow/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/settings_providers.dart';
import 'package:apidash/services/storage/workspace_storage.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/workflow/engine/workflow_auto_arrange.dart';
import 'package:apidash/workflow/engine/workflow_runner.dart';
import 'package:apidash/workflow/models/workflow_request_codec.dart';
import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/providers/workflow_history_providers.dart';
import 'package:apidash/workflow/providers/workflow_ui_providers.dart';
import 'package:apidash/workflow/utils/workflow_variable_utils.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final selectedWorkflowIdStateProvider = StateProvider<String?>((ref) => null);

final workflowRunInProgressProvider = StateProvider<bool>((ref) => false);

final workflowNodeRunResultsProvider =
    StateProvider<Map<String, WorkflowNodeRunResult>>((ref) => {});

final workflowRunStepOrderProvider = StateProvider<List<String>>((ref) => []);

final workflowCatalogProvider =
    AsyncNotifierProvider<WorkflowCatalogNotifier, List<WorkflowSummary>>(
  WorkflowCatalogNotifier.new,
);

final activeWorkflowProvider =
    NotifierProvider<ActiveWorkflowNotifier, WorkflowDocument?>(
  ActiveWorkflowNotifier.new,
);

/// Upstream extractions available to the selected workflow node (`{{name}}` → source).
final workflowChainedVariablesProvider = Provider<Map<String, String>>((ref) {
  final workflow = ref.watch(activeWorkflowProvider);
  final nodeId = ref.watch(selectedWorkflowNodeIdProvider);
  if (workflow == null || nodeId == null) {
    return const {};
  }
  return upstreamExtractionVariables(workflow, nodeId);
});

class WorkflowSummary {
  const WorkflowSummary({
    required this.id,
    required this.name,
    required this.stepCount,
  });

  final String id;
  final String name;
  final int stepCount;
}

class WorkflowCatalogNotifier extends AsyncNotifier<List<WorkflowSummary>> {
  @override
  Future<List<WorkflowSummary>> build() async {
    if (!isWorkspaceStorageInitialized()) {
      return const [];
    }
    return _loadSummaries();
  }

  List<WorkflowSummary> _loadSummaries() {
    final summaries = <WorkflowSummary>[
      for (final name in workspaceStorage.getKnownWorkflowIds())
        _summaryFor(name),
    ];
    summaries.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return summaries;
  }

  WorkflowSummary _summaryFor(String name) {
    final json = workspaceStorage.getWorkflow(name);
    if (json == null) {
      return WorkflowSummary(
        id: name,
        name: name,
        stepCount: 0,
      );
    }
    final workflow = WorkflowDocument.fromJson(json);
    final workflowName = workflow.name.trim().isNotEmpty ? workflow.name : name;
    return WorkflowSummary(
      id: workflowName,
      name: workflowName,
      stepCount: workflow.graph.requestNodeCount,
    );
  }

  Future<void> reloadFromDisk() async {
    state = AsyncData(_loadSummaries());
  }

  Future<WorkflowDocument> createWorkflow({
    String? name,
  }) async {
    final baseName = name?.trim().isNotEmpty == true
        ? name!.trim()
        : 'Workflow ${(state.value?.length ?? 0) + 1}';
    final workflowName = _uniqueWorkflowName(baseName);
    final workflow = _defaultWorkflow(name: workflowName);
    await _persistWorkflow(workflow);
    await reloadFromDisk();
    ref.read(selectedWorkflowIdStateProvider.notifier).state = workflowName;
    ref.read(activeWorkflowProvider.notifier).load(workflowName);
    return workflow;
  }

  Future<void> deleteWorkflow(String workflowName) async {
    await workspaceStorage.deleteWorkflow(workflowName);
    final remaining = workspaceStorage
        .getWorkflowsIndex()
        .where((name) => name != workflowName)
        .toList();
    await workspaceStorage.setWorkflowsIndex(remaining);
    await reloadFromDisk();
    if (ref.read(selectedWorkflowIdStateProvider) == workflowName) {
      ref.read(selectedWorkflowIdStateProvider.notifier).state =
          remaining.isNotEmpty ? remaining.first : null;
      if (remaining.isNotEmpty) {
        await ref.read(activeWorkflowProvider.notifier).load(remaining.first);
      } else {
        ref.read(activeWorkflowProvider.notifier).clear();
      }
    }
  }

  Future<void> renameWorkflow(String workflowName, String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty || trimmed == workflowName) {
      return;
    }
    final uniqueName = _uniqueWorkflowName(trimmed, except: workflowName);
    await workspaceStorage.renameWorkflow(workflowName, uniqueName);
    if (ref.read(selectedWorkflowIdStateProvider) == workflowName) {
      ref.read(selectedWorkflowIdStateProvider.notifier).state = uniqueName;
    }
    await ref.read(activeWorkflowProvider.notifier).load(uniqueName);
    await reloadFromDisk();
  }

  String _uniqueWorkflowName(String baseName, {String? except}) {
    final existing = workspaceStorage.getWorkflowsIndex().toSet();
    if (except != null) {
      existing.remove(except);
    }
    if (!existing.contains(baseName)) {
      return baseName;
    }
    var suffix = 2;
    while (existing.contains('$baseName ($suffix)')) {
      suffix += 1;
    }
    return '$baseName ($suffix)';
  }

  Future<void> _persistWorkflow(WorkflowDocument workflow) async {
    await workspaceStorage.setWorkflow(workflow.id, workflow.toJson());
    final index = workspaceStorage.getWorkflowsIndex().toList();
    if (!index.contains(workflow.id)) {
      index.add(workflow.id);
    }
    await workspaceStorage.setWorkflowsIndex(index);
  }

  Future<bool> applyExternalWorkflowRemoved(String workflowId) async {
    final catalog = state.value ?? const <WorkflowSummary>[];
    final index = workspaceStorage.getWorkflowsIndex();
    final wasKnown =
        catalog.any((summary) => summary.id == workflowId) ||
            index.contains(workflowId);
    final wasSelected =
        ref.read(selectedWorkflowIdStateProvider) == workflowId;
    if (!wasKnown && !wasSelected) {
      return false;
    }

    if (index.contains(workflowId)) {
      await workspaceStorage.setWorkflowsIndex([
        for (final name in index)
          if (name != workflowId) name,
      ]);
    }

    await reloadFromDisk();
    if (wasSelected) {
      final remaining = state.value ?? const <WorkflowSummary>[];
      final nextId = remaining.isNotEmpty ? remaining.first.id : null;
      ref.read(selectedWorkflowIdStateProvider.notifier).state = nextId;
      ref.read(selectedWorkflowNodeIdProvider.notifier).state = null;
      if (nextId != null) {
        await ref.read(activeWorkflowProvider.notifier).load(nextId);
      } else {
        ref.read(activeWorkflowProvider.notifier).clear();
      }
    }
    return true;
  }

  Future<bool> applyExternalWorkflowAdded(String workflowId) async {
    if (!workspaceStorage.workflowExistsOnDisk(workflowId)) {
      return false;
    }
    final catalog = state.value ?? const <WorkflowSummary>[];
    final alreadyListed = catalog.any((summary) => summary.id == workflowId);
    final index = workspaceStorage.getWorkflowsIndex().toList();
    if (!index.contains(workflowId)) {
      index.add(workflowId);
      await workspaceStorage.setWorkflowsIndex(index);
    }
    await reloadFromDisk();
    return !alreadyListed;
  }

  Future<bool> applyExternalWorkflowContentChanged(String workflowId) async {
    if (!workspaceStorage.workflowExistsOnDisk(workflowId)) {
      return false;
    }
    final index = workspaceStorage.getWorkflowsIndex().toList();
    if (!index.contains(workflowId)) {
      index.add(workflowId);
      await workspaceStorage.setWorkflowsIndex(index);
    }
    await reloadFromDisk();
    if (ref.read(selectedWorkflowIdStateProvider) == workflowId) {
      await ref.read(activeWorkflowProvider.notifier).load(workflowId);
    }
    return true;
  }

  Future<bool> applyExternalWorkflowIndexChanged() async {
    await reloadFromDisk();
    final selected = ref.read(selectedWorkflowIdStateProvider);
    final remaining = state.value ?? const <WorkflowSummary>[];
    final ids = {for (final summary in remaining) summary.id};
    if (selected != null && !ids.contains(selected)) {
      final nextId = remaining.isNotEmpty ? remaining.first.id : null;
      ref.read(selectedWorkflowIdStateProvider.notifier).state = nextId;
      ref.read(selectedWorkflowNodeIdProvider.notifier).state = null;
      if (nextId != null) {
        await ref.read(activeWorkflowProvider.notifier).load(nextId);
      } else {
        ref.read(activeWorkflowProvider.notifier).clear();
      }
    }
    return true;
  }
}

class ActiveWorkflowNotifier extends Notifier<WorkflowDocument?> {
  @override
  WorkflowDocument? build() => null;

  Future<void> load(String workflowId) async {
    final json = workspaceStorage.getWorkflow(workflowId);
    if (json == null) {
      state = null;
      return;
    }
    state = WorkflowDocument.fromJson(json);
  }

  void clear() => state = null;

  Future<void> save(WorkflowDocument workflow) async {
    final name = workflow.name.trim().isNotEmpty ? workflow.name.trim() : workflow.id;
    final updated = workflow.copyWith(
      id: name,
      name: name,
    );
    state = updated;
    await workspaceStorage.setWorkflow(updated.id, updated.toJson());
    final index = workspaceStorage.getWorkflowsIndex().toList();
    if (!index.contains(updated.id)) {
      index.add(updated.id);
    }
    await workspaceStorage.setWorkflowsIndex(index);
    await ref.read(workflowCatalogProvider.notifier).reloadFromDisk();
  }

  Future<String?> addRequestStep({
    Offset position = const Offset(280, 180),
    String? afterNodeId,
    WorkflowEdgeHandle? sourceHandle,
    APIType apiType = APIType.rest,
  }) async {
    final current = state;
    if (current == null) {
      return null;
    }
    final requestId = getNewUuid();
    final label = apiType == APIType.ai
        ? 'AI Request ${current.graph.requestNodeCount + 1}'
        : 'Request ${current.graph.requestNodeCount + 1}';
    final RequestModel requestModel;
    if (apiType == APIType.ai) {
      final defaultModel = ref.read(settingsProvider).defaultAIModel;
      requestModel = RequestModel(
        id: requestId,
        name: label,
        apiType: APIType.ai,
        aiRequestModel: defaultModel == null
            ? const AIRequestModel()
            : AIRequestModel.fromJson(defaultModel),
      );
    } else {
      requestModel = RequestModel(
        id: requestId,
        name: label,
        apiType: APIType.rest,
        httpRequestModel: const HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://',
        ),
      );
    }
    final nodeId = 'node_${getNewUuid().substring(0, 8)}';
    final nodes = [...current.graph.nodes];
    final edges = [...current.graph.edges];
    final newNode = WorkflowGraphNode(
      id: nodeId,
      type: WorkflowNodeType.request,
      label: label,
      position: WorkflowPosition(x: position.dx, y: position.dy),
      request: encodeWorkflowRequest(requestModel),
    );
    nodes.add(newNode);
    if (afterNodeId != null) {
      edges.add(
        WorkflowGraphEdge(
          id: 'edge_${getNewUuid().substring(0, 8)}',
          source: afterNodeId,
          sourceHandle:
              sourceHandle ?? _sourceHandleForNode(current, afterNodeId),
          target: nodeId,
        ),
      );
    }
    await save(
      current.copyWith(
        graph: current.graph.copyWith(nodes: nodes, edges: edges),
      ),
    );
    ref.read(selectedWorkflowNodeIdProvider.notifier).state = nodeId;
    return nodeId;
  }

  Future<String?> addLoopNode({
    Offset position = const Offset(320, 240),
    String? afterNodeId,
    WorkflowEdgeHandle? sourceHandle,
  }) async {
    final current = state;
    if (current == null) {
      return null;
    }
    final nodeId = 'node_${getNewUuid().substring(0, 8)}';
    const label = 'For each';
    final nodes = [...current.graph.nodes];
    final edges = [...current.graph.edges];
    nodes.add(
      WorkflowGraphNode(
        id: nodeId,
        type: WorkflowNodeType.loop,
        label: label,
        position: WorkflowPosition(x: position.dx, y: position.dy),
        loopExpression: 'var:items',
      ),
    );
    if (afterNodeId != null) {
      edges.add(
        WorkflowGraphEdge(
          id: 'edge_${getNewUuid().substring(0, 8)}',
          source: afterNodeId,
          sourceHandle:
              sourceHandle ?? _sourceHandleForNode(current, afterNodeId),
          target: nodeId,
        ),
      );
    }
    await save(
      current.copyWith(
        graph: current.graph.copyWith(nodes: nodes, edges: edges),
      ),
    );
    ref.read(selectedWorkflowNodeIdProvider.notifier).state = nodeId;
    return nodeId;
  }

  Future<String?> addConditionNode({
    Offset position = const Offset(320, 240),
    String? afterNodeId,
    WorkflowEdgeHandle? sourceHandle,
  }) async {
    final current = state;
    if (current == null) {
      return null;
    }
    final nodeId = 'node_${getNewUuid().substring(0, 8)}';
    const label = 'Condition';
    final nodes = [...current.graph.nodes];
    final edges = [...current.graph.edges];
    nodes.add(
      WorkflowGraphNode(
        id: nodeId,
        type: WorkflowNodeType.condition,
        label: label,
        position: WorkflowPosition(x: position.dx, y: position.dy),
        conditionExpression: 'status>=200',
      ),
    );
    if (afterNodeId != null) {
      edges.add(
        WorkflowGraphEdge(
          id: 'edge_${getNewUuid().substring(0, 8)}',
          source: afterNodeId,
          sourceHandle:
              sourceHandle ?? _sourceHandleForNode(current, afterNodeId),
          target: nodeId,
        ),
      );
    }
    await save(
      current.copyWith(
        graph: current.graph.copyWith(nodes: nodes, edges: edges),
      ),
    );
    ref.read(selectedWorkflowNodeIdProvider.notifier).state = nodeId;
    return nodeId;
  }

  Future<String?> addDelayNode({
    Offset position = const Offset(320, 240),
    String? afterNodeId,
    WorkflowEdgeHandle? sourceHandle,
    int delayMs = 1000,
  }) async {
    final current = state;
    if (current == null) {
      return null;
    }
    final nodeId = 'node_${getNewUuid().substring(0, 8)}';
    const label = kLabelWorkflowDelay;
    final nodes = [...current.graph.nodes];
    final edges = [...current.graph.edges];
    nodes.add(
      WorkflowGraphNode(
        id: nodeId,
        type: WorkflowNodeType.delay,
        label: label,
        position: WorkflowPosition(x: position.dx, y: position.dy),
        delayMs: delayMs,
      ),
    );
    if (afterNodeId != null) {
      edges.add(
        WorkflowGraphEdge(
          id: 'edge_${getNewUuid().substring(0, 8)}',
          source: afterNodeId,
          sourceHandle:
              sourceHandle ?? _sourceHandleForNode(current, afterNodeId),
          target: nodeId,
        ),
      );
    }
    await save(
      current.copyWith(
        graph: current.graph.copyWith(nodes: nodes, edges: edges),
      ),
    );
    ref.read(selectedWorkflowNodeIdProvider.notifier).state = nodeId;
    return nodeId;
  }

  Future<String?> duplicateRequestStep(String nodeId) async {
    final current = state;
    if (current == null) {
      return null;
    }
    final node = current.nodeById(nodeId);
    if (node == null || node.type != WorkflowNodeType.request) {
      return null;
    }

    final newNodeId = 'node_${getNewUuid().substring(0, 8)}';
    final requestId = getNewUuid();
    final baseLabel = node.label.isNotEmpty ? node.label : 'Request';
    final copyLabel = '$baseLabel copy';
    final sourceRequest = node.requestModel() ??
        RequestModel(id: requestId, name: copyLabel);
    final newNode = WorkflowGraphNode(
      id: newNodeId,
      type: WorkflowNodeType.request,
      label: copyLabel,
      position: WorkflowPosition(
        x: node.position.x + 36,
        y: node.position.y + 36,
      ),
      request: encodeWorkflowRequest(
        sourceRequest.copyWith(
          id: requestId,
          name: copyLabel,
          httpResponseModel: null,
          responseStatus: null,
          message: null,
          isWorking: false,
          isStreaming: false,
        ),
      ),
      inheritFrom: node.inheritFrom,
      extractions: [...node.extractions],
    );

    await save(
      current.copyWith(
        graph: current.graph.copyWith(
          nodes: [...current.graph.nodes, newNode],
        ),
      ),
    );
    return newNodeId;
  }

  Future<String?> duplicateNode(String nodeId) async {
    final current = state;
    if (current == null) {
      return null;
    }
    final node = current.graph.nodes
        .where((candidate) => candidate.id == nodeId)
        .cast<WorkflowGraphNode?>()
        .firstWhere((candidate) => candidate != null, orElse: () => null);
    if (node == null || node.type == WorkflowNodeType.manualStart) {
      return null;
    }
    if (node.type == WorkflowNodeType.request) {
      return duplicateRequestStep(nodeId);
    }

    final newNodeId = 'node_${getNewUuid().substring(0, 8)}';
    final baseLabel = node.label.isNotEmpty
        ? node.label
        : switch (node.type) {
            WorkflowNodeType.loop => kLabelWorkflowLoop,
            WorkflowNodeType.condition => kLabelWorkflowCondition,
            WorkflowNodeType.delay => kLabelWorkflowDelay,
            _ => 'Node',
          };
    final newNode = node.copyWith(
      id: newNodeId,
      label: '$baseLabel copy',
      position: WorkflowPosition(
        x: node.position.x + 36,
        y: node.position.y + 36,
      ),
    );

    await save(
      current.copyWith(
        graph: current.graph.copyWith(
          nodes: [...current.graph.nodes, newNode],
        ),
      ),
    );
    ref.read(selectedWorkflowNodeIdProvider.notifier).state = newNodeId;
    return newNodeId;
  }

  Future<String?> importRequestFromCollection({
    required String collectionId,
    required String requestId,
    Offset position = const Offset(280, 180),
    String? afterNodeId,
    WorkflowEdgeHandle? sourceHandle,
  }) async {
    final json = workspaceStorage.getRequestModel(collectionId, requestId);
    if (json == null) {
      return null;
    }
    final request = RequestModel.fromJson(Map<String, Object?>.from(json));
    final current = state;
    if (current == null) {
      return null;
    }
    final nodeId = 'node_${getNewUuid().substring(0, 8)}';
    final label = request.name.isNotEmpty ? request.name : 'Imported request';
    final nodes = [...current.graph.nodes];
    final edges = [...current.graph.edges];
    nodes.add(
      WorkflowGraphNode(
        id: nodeId,
        type: WorkflowNodeType.request,
        label: label,
        position: WorkflowPosition(x: position.dx, y: position.dy),
        request: encodeWorkflowRequest(
          request.copyWith(
            id: getNewUuid(),
            httpResponseModel: null,
            responseStatus: null,
            message: null,
            isWorking: false,
            isStreaming: false,
          ),
        ),
        inheritFrom: WorkflowInheritFrom(
          collectionId: collectionId,
          requestId: requestId,
        ),
      ),
    );
    if (afterNodeId != null) {
      edges.add(
        WorkflowGraphEdge(
          id: 'edge_${getNewUuid().substring(0, 8)}',
          source: afterNodeId,
          sourceHandle:
              sourceHandle ?? _sourceHandleForNode(current, afterNodeId),
          target: nodeId,
        ),
      );
    }
    await save(
      current.copyWith(
        graph: current.graph.copyWith(nodes: nodes, edges: edges),
      ),
    );
    ref.read(selectedWorkflowNodeIdProvider.notifier).state = nodeId;
    return nodeId;
  }

  Future<void> updateNodePosition(String nodeId, Offset position) async {
    final current = state;
    if (current == null) {
      return;
    }
    final nodes = [
      for (final node in current.graph.nodes)
        if (node.id == nodeId)
          node.copyWith(
            position: WorkflowPosition(x: position.dx, y: position.dy),
          )
        else
          node,
    ];
    await save(current.copyWith(graph: current.graph.copyWith(nodes: nodes)));
  }

  Future<void> autoArrangeGraph() async {
    final current = state;
    if (current == null) {
      return;
    }
    final positions = computeWorkflowAutoArrangePositions(current.graph);
    if (positions.isEmpty) {
      return;
    }
    final nodes = [
      for (final node in current.graph.nodes)
        if (positions.containsKey(node.id))
          node.copyWith(
            position: WorkflowPosition(
              x: positions[node.id]!.dx,
              y: positions[node.id]!.dy,
            ),
          )
        else
          node,
    ];
    await save(current.copyWith(graph: current.graph.copyWith(nodes: nodes)));
  }

  Future<void> updateSelectedNode(WorkflowGraphNode node) async {
    final current = state;
    if (current == null) {
      return;
    }
    final nodes = [
      for (final existing in current.graph.nodes)
        if (existing.id == node.id) node else existing,
    ];
    await save(
      current.copyWith(
        graph: current.graph.copyWith(nodes: nodes),
      ),
    );
  }

  Future<void> updateNodeRequest(String nodeId, RequestModel request) async {
    final current = state;
    final node = current?.nodeById(nodeId);
    if (current == null || node == null || node.type != WorkflowNodeType.request) {
      return;
    }
    final label = request.name.isNotEmpty ? request.name : node.label;
    await save(
      current.copyWith(
        graph: current.graph.copyWith(
          nodes: [
            for (final existing in current.graph.nodes)
              if (existing.id == nodeId)
                existing.copyWith(
                  label: label,
                  request: encodeWorkflowRequest(request),
                )
              else
                existing,
          ],
        ),
      ),
    );
  }

  Future<void> connectNodes({
    required String sourceId,
    required WorkflowEdgeHandle sourceHandle,
    required String targetId,
  }) async {
    final current = state;
    if (current == null) {
      return;
    }
    final edge = WorkflowGraphEdge(
      id: 'edge_${getNewUuid().substring(0, 8)}',
      source: sourceId,
      sourceHandle: sourceHandle,
      target: targetId,
    );
    await save(
      current.copyWith(
        graph: current.graph.copyWith(
          edges: [...current.graph.edges, edge],
        ),
      ),
    );
  }

  Future<void> disconnectEdge(String edgeId) async {
    final current = state;
    if (current == null) {
      return;
    }
    await save(
      current.copyWith(
        graph: current.graph.copyWith(
          edges: current.graph.edges.where((edge) => edge.id != edgeId).toList(),
        ),
      ),
    );
  }

  Future<void> deleteNode(String nodeId) async {
    final current = state;
    if (current == null) {
      return;
    }
    final node = current.nodeById(nodeId);
    if (node == null) {
      return;
    }
    await save(
      current.copyWith(
        graph: current.graph.copyWith(
          nodes: current.graph.nodes.where((n) => n.id != nodeId).toList(),
          edges: current.graph.edges
              .where((edge) => edge.source != nodeId && edge.target != nodeId)
              .toList(),
        ),
      ),
    );
  }
}

WorkflowDocument _defaultWorkflow({
  required String name,
}) {
  final requestId = getNewUuid();
  final nodeId = 'node_${getNewUuid().substring(0, 8)}';
  const label = 'Request 1';
  return WorkflowDocument(
    id: name,
    name: name,
    graph: WorkflowGraph(
      nodes: [
        const WorkflowGraphNode(
          id: 'start',
          type: WorkflowNodeType.manualStart,
          label: 'Start',
          position: WorkflowPosition(x: 80, y: 180),
        ),
        WorkflowGraphNode(
          id: nodeId,
          type: WorkflowNodeType.request,
          label: label,
          position: const WorkflowPosition(x: 320, y: 180),
          request: encodeWorkflowRequest(
            RequestModel(
              id: requestId,
              name: label,
              httpRequestModel: const HttpRequestModel(
                method: HTTPVerb.get,
                url: 'https://',
              ),
            ),
          ),
        ),
      ],
      edges: [
        WorkflowGraphEdge(
          id: 'edge_start',
          source: 'start',
          sourceHandle: WorkflowEdgeHandle.next,
          target: nodeId,
        ),
      ],
    ),
  );
}

WorkflowEdgeHandle _sourceHandleForNode(
  WorkflowDocument workflow,
  String sourceNodeId,
) {
  for (final node in workflow.graph.nodes) {
    if (node.id == sourceNodeId) {
      return switch (node.type) {
        WorkflowNodeType.manualStart => WorkflowEdgeHandle.next,
        WorkflowNodeType.loop => WorkflowEdgeHandle.next,
        WorkflowNodeType.delay => WorkflowEdgeHandle.next,
        WorkflowNodeType.condition => WorkflowEdgeHandle.then,
        _ => WorkflowEdgeHandle.success,
      };
    }
  }
  return WorkflowEdgeHandle.success;
}

final workflowRunnerProvider = Provider<WorkflowRunner>((ref) {
  return const WorkflowRunner();
});

Future<WorkflowRunResult?> runActiveWorkflow(WidgetRef ref) async {
  final workflow = ref.read(activeWorkflowProvider);
  if (workflow == null) {
    return null;
  }
  ref.read(workflowRunInProgressProvider.notifier).state = true;
  ref.read(workflowNodeRunResultsProvider.notifier).state = {};
  ref.read(workflowRunStepOrderProvider.notifier).state = [];
  ref.read(selectedWorkflowRunResultKeyProvider.notifier).state = null;
  ref.read(viewingFlowHistoryRunIdProvider.notifier).state = null;
  final runner = ref.read(workflowRunnerProvider);
  try {
    final result = await runner.run(
      ref: ref,
      workflow: workflow,
      storage: workspaceStorage,
      onNodeUpdate: (nodeResult) {
        // Ignore late updates after Stop so the canvas doesn't re-animate.
        if (!ref.read(workflowRunInProgressProvider) &&
            nodeResult.status == WorkflowNodeRunStatus.running) {
          return;
        }
        final iterationKey = nodeResult.loopIndex != null
            ? '${nodeResult.nodeId}#${nodeResult.loopIndex}'
            : nodeResult.nodeId;
        ref.read(workflowNodeRunResultsProvider.notifier).state = {
          ...ref.read(workflowNodeRunResultsProvider),
          // Latest status for the node card on the canvas.
          nodeResult.nodeId: nodeResult,
          // Distinct key so loop iterations all appear in the timeline.
          iterationKey: nodeResult,
        };
        final order = ref.read(workflowRunStepOrderProvider);
        if (!order.contains(iterationKey)) {
          ref.read(workflowRunStepOrderProvider.notifier).state = [
            ...order,
            iterationKey,
          ];
        }
      },
      shouldStop: () => !ref.read(workflowRunInProgressProvider),
    );
    await persistWorkflowRunHistory(
      ref: ref,
      workflow: workflow,
      result: result,
    );
    return result;
  } finally {
    ref.read(workflowRunInProgressProvider.notifier).state = false;
    settleInterruptedWorkflowRunResults(ref);
  }
}

/// Mark in-flight canvas steps as skipped after Stop / abort.
void settleInterruptedWorkflowRunResults(WidgetRef ref) {
  final current = ref.read(workflowNodeRunResultsProvider);
  var changed = false;
  final settled = <String, WorkflowNodeRunResult>{};
  for (final entry in current.entries) {
    if (entry.value.status == WorkflowNodeRunStatus.running) {
      settled[entry.key] = entry.value.copyWith(
        status: WorkflowNodeRunStatus.skipped,
        message: entry.value.message ?? 'Stopped',
      );
      changed = true;
    } else {
      settled[entry.key] = entry.value;
    }
  }
  if (changed) {
    ref.read(workflowNodeRunResultsProvider.notifier).state = settled;
  }
}
