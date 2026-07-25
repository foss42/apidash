import 'dart:convert';

import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/storage/workspace_storage.dart';
import 'package:apidash/workflow/engine/extraction_service.dart';
import 'package:apidash/workflow/engine/workflow_request_executor.dart';
import 'package:apidash/workflow/engine/workflow_validator.dart';
import 'package:apidash/workflow/models/workflow_request_codec.dart';
import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _QueueEntry {
  const _QueueEntry(
    this.node, {
    this.loopItem,
    this.loopIndex,
    this.loopCompletionId,
  });

  final WorkflowGraphNode node;
  final String? loopItem;
  final String? loopIndex;
  final String? loopCompletionId;
}

RequestModel resolveWorkflowNodeRequest({
  required WorkflowGraphNode node,
  required WorkspaceStorage storage,
}) {
  var payload = Map<String, dynamic>.from(node.request ?? const {});
  final inheritFrom = node.inheritFrom;
  if (inheritFrom != null) {
    final inherited = storage.getRequestModel(
      inheritFrom.collectionId,
      inheritFrom.requestId,
    );
    if (inherited != null) {
      payload = {
        ...inherited,
        ...payload,
      };
    }
  }
  return decodeWorkflowRequest(payload);
}

class WorkflowRunner {
  const WorkflowRunner({
    this.validator = const WorkflowValidator(),
    this.extractionService = const WorkflowExtractionService(),
  });

  final WorkflowValidator validator;
  final WorkflowExtractionService extractionService;

  Future<WorkflowRunResult> run({
    required WidgetRef ref,
    required WorkflowDocument workflow,
    required WorkspaceStorage storage,
    void Function(WorkflowNodeRunResult result)? onNodeUpdate,
    bool Function()? shouldStop,
  }) async {
    final startedAt = DateTime.now();
    final validation = validator.validate(workflow);
    if (!validation.isValid) {
      return WorkflowRunResult(
        workflowId: workflow.id,
        success: false,
        startedAt: startedAt,
        endedAt: DateTime.now(),
        nodeResults: const [],
        error: validation.errors.first,
      );
    }

    final scopedVariables = <String, String>{};
    final nodeResults = <WorkflowNodeRunResult>[];
    final queue = [
      for (final node in validator.entryNodes(workflow)) _QueueEntry(node),
    ];
    final adjacency = _buildAdjacency(workflow);
    final visited = <String>{};
    final loopIterationsRemaining = <String, int>{};
    final loopDoneTargets = <String, List<String>>{};
    final loopItems = <String, List<String>>{};
    final loopBodyStarts = <String, String>{};
    int? lastStatusCode;

    while (queue.isNotEmpty) {
      if (shouldStop?.call() ?? false) {
        return WorkflowRunResult(
          workflowId: workflow.id,
          success: false,
          startedAt: startedAt,
          endedAt: DateTime.now(),
          nodeResults: nodeResults,
          error: 'Workflow stopped',
          scopedVariables: scopedVariables,
        );
      }

      final entry = queue.removeAt(0);
      final node = entry.node;
      var loopCompletionId = entry.loopCompletionId;
      if (entry.loopItem != null) {
        scopedVariables['loop.item'] = entry.loopItem!;
      }
      if (entry.loopIndex != null) {
        scopedVariables['loop.index'] = entry.loopIndex!;
      }

      final visitKey = _visitKey(entry);
      if (!visited.add(visitKey)) {
        continue;
      }
      final nodeStartedAt = DateTime.now();
      var running = WorkflowNodeRunResult(
        nodeId: node.id,
        label: node.label,
        nodeType: node.type,
        status: WorkflowNodeRunStatus.running,
        loopIndex: entry.loopIndex,
      );
      onNodeUpdate?.call(running);

      WorkflowNodeRunResult result;
      var branchHandle = WorkflowEdgeHandle.success;
      var skipDefaultEnqueue = false;

      switch (node.type) {
        case WorkflowNodeType.manualStart:
          result = WorkflowNodeRunResult(
            nodeId: node.id,
            label: node.label,
            nodeType: node.type,
            status: WorkflowNodeRunStatus.success,
            message: 'Workflow started',
            durationMs: 0,
          );
          branchHandle = WorkflowEdgeHandle.next;
        case WorkflowNodeType.delay:
          final delayMs = node.delayMs ?? 0;
          final clampedDelay = delayMs < 0 ? 0 : delayMs;
          if (clampedDelay > 0) {
            const slice = Duration(milliseconds: 100);
            var remaining = clampedDelay;
            while (remaining > 0) {
              if (shouldStop?.call() ?? false) {
                return WorkflowRunResult(
                  workflowId: workflow.id,
                  success: false,
                  startedAt: startedAt,
                  endedAt: DateTime.now(),
                  nodeResults: nodeResults,
                  error: 'Workflow stopped',
                  scopedVariables: scopedVariables,
                );
              }
              final waitMs = remaining < slice.inMilliseconds
                  ? remaining
                  : slice.inMilliseconds;
              await Future<void>.delayed(Duration(milliseconds: waitMs));
              remaining -= waitMs;
            }
          }
          result = WorkflowNodeRunResult(
            nodeId: node.id,
            label: node.label,
            nodeType: node.type,
            status: WorkflowNodeRunStatus.success,
            message: clampedDelay <= 0
                ? 'No delay configured'
                : 'Waited ${clampedDelay}ms',
            durationMs: DateTime.now().difference(nodeStartedAt).inMilliseconds,
          );
          branchHandle = WorkflowEdgeHandle.next;
        case WorkflowNodeType.condition:
          final expression = (node.conditionExpression ?? '').trim();
          final passed = _evaluateCondition(
            node.conditionExpression,
            scopedVariables: scopedVariables,
            lastStatusCode: lastStatusCode,
          );
          result = WorkflowNodeRunResult(
            nodeId: node.id,
            label: node.label,
            nodeType: node.type,
            status: WorkflowNodeRunStatus.success,
            message: passed ? 'True' : 'False',
            detail: expression.isEmpty ? null : expression,
            branch: passed ? 'true' : 'false',
            durationMs: DateTime.now().difference(nodeStartedAt).inMilliseconds,
          );
          branchHandle =
              passed ? WorkflowEdgeHandle.then : WorkflowEdgeHandle.elseBranch;
        case WorkflowNodeType.loop:
          final maxIterations = node.loopMaxIterations;
          final environmentVariables = _environmentVariables(ref);
          final allItems = node.loopMode == WorkflowLoopMode.repeat
              ? _repeatLoopItems(maxIterations)
              : _resolveLoopItems(
                  node.loopExpression,
                  scopedVariables,
                  environmentVariables,
                );
          final items = node.loopMode == WorkflowLoopMode.repeat
              ? allItems
              : maxIterations != null && maxIterations > 0
                  ? allItems.take(maxIterations).toList()
                  : allItems;
          final loopSource = node.loopMode == WorkflowLoopMode.repeat
              ? 'repeat ${maxIterations ?? 0}'
              : (node.loopExpression ?? '').trim();
          result = WorkflowNodeRunResult(
            nodeId: node.id,
            label: node.label,
            nodeType: node.type,
            status: WorkflowNodeRunStatus.success,
            message: items.isEmpty
                ? node.loopMode == WorkflowLoopMode.repeat
                    ? 'Set a repeat count greater than 0'
                    : 'Loop has no items'
                : node.loopMode == WorkflowLoopMode.repeat
                    ? 'Repeat ${items.length} times'
                    : maxIterations != null && maxIterations > 0
                        ? 'Loop ${items.length} of ${allItems.length} items'
                        : 'Loop ${items.length} items',
            detail: loopSource.isEmpty ? null : loopSource,
            branch: items.isEmpty ? 'done' : 'each',
            durationMs: DateTime.now().difference(nodeStartedAt).inMilliseconds,
          );
          final doneTargetIds = (adjacency[node.id] ?? const <_WorkflowEdgeRef>[])
              .where((edge) => edge.sourceHandle == WorkflowEdgeHandle.loopDone)
              .map((edge) => edge.targetId)
              .toList();
          final bodyStarts = (adjacency[node.id] ?? const <_WorkflowEdgeRef>[])
              .where((edge) => edge.sourceHandle == WorkflowEdgeHandle.next)
              .map((edge) => edge.targetId)
              .toList();
          if (items.isEmpty) {
            _enqueueTargetIds(queue, workflow, doneTargetIds);
          } else if (bodyStarts.isEmpty) {
            _enqueueTargetIds(queue, workflow, doneTargetIds);
          } else {
            loopIterationsRemaining[node.id] = items.length;
            loopDoneTargets[node.id] = doneTargetIds;
            loopItems[node.id] = items;
            loopBodyStarts[node.id] = bodyStarts.first;
            final bodyNode = workflow.graph.nodes
                .where((candidate) => candidate.id == bodyStarts.first)
                .cast<WorkflowGraphNode?>()
                .firstWhere(
                  (candidate) => candidate != null,
                  orElse: () => null,
                );
            if (bodyNode != null) {
              // Run iterations sequentially: queue only the first body start.
              queue.insert(
                0,
                _QueueEntry(
                  bodyNode,
                  loopItem: items.first,
                  loopIndex: '0',
                  loopCompletionId: node.id,
                ),
              );
            }
          }
          skipDefaultEnqueue = true;
        case WorkflowNodeType.request:
          if (node.request == null || node.request!.isEmpty) {
            result = WorkflowNodeRunResult(
              nodeId: node.id,
              label: node.label,
              nodeType: node.type,
              status: WorkflowNodeRunStatus.failed,
              message: 'Missing request on node',
            );
            branchHandle = WorkflowEdgeHandle.failure;
            nodeResults.add(result);
            onNodeUpdate?.call(result);
            return WorkflowRunResult(
              workflowId: workflow.id,
              success: false,
              startedAt: startedAt,
              endedAt: DateTime.now(),
              nodeResults: nodeResults,
              error: 'Missing request on node',
              scopedVariables: scopedVariables,
            );
          }
          final requestModel = resolveWorkflowNodeRequest(
            node: node,
            storage: storage,
          );
          final execution = await executeWorkflowRequest(
            ref: ref,
            requestModel: requestModel,
            scopedVariables: scopedVariables,
            logLabel: '${workflow.id}/${node.id}',
          );
          lastStatusCode = execution.statusCode;
          final extracted = <String, String>{};
          for (final extraction in node.extractions) {
            final value = extractionService.extract(
              source: extraction.source,
              jsonPath: extraction.jsonPath,
              response: execution.httpResponseModel,
              statusCode: execution.statusCode,
            );
            if (value != null && extraction.varName.isNotEmpty) {
              scopedVariables[extraction.varName] = value;
              extracted[extraction.varName] = value;
            }
          }
          final substituted = execution.substitutedRequest;
          final ok = execution.ok;
          result = WorkflowNodeRunResult(
            nodeId: node.id,
            label: node.label,
            nodeType: node.type,
            status: ok
                ? WorkflowNodeRunStatus.success
                : WorkflowNodeRunStatus.failed,
            message: execution.message,
            statusCode: execution.statusCode,
            durationMs: execution.duration?.inMilliseconds ??
                DateTime.now().difference(nodeStartedAt).inMilliseconds,
            apiType: execution.apiType,
            method: substituted?.method,
            url: substituted?.url,
            requestHeaders: substituted?.enabledHeadersMap,
            requestBody: substituted?.body,
            httpResponseModel: execution.httpResponseModel,
            extractedVariables: extracted,
            branch: ok ? 'success' : 'failure',
          );
          branchHandle =
              ok ? WorkflowEdgeHandle.success : WorkflowEdgeHandle.failure;
          if (!ok) {
            nodeResults.add(result);
            onNodeUpdate?.call(result);
            return WorkflowRunResult(
              workflowId: workflow.id,
              success: false,
              startedAt: startedAt,
              endedAt: DateTime.now(),
              nodeResults: nodeResults,
              error: execution.message ?? 'Request step failed',
              scopedVariables: scopedVariables,
            );
          }
      }

      nodeResults.add(result);
      onNodeUpdate?.call(
        result.copyWith(loopIndex: entry.loopIndex),
      );

      if (skipDefaultEnqueue) {
        continue;
      }

      final nextIds = (adjacency[node.id] ?? const <_WorkflowEdgeRef>[])
          .where((edge) => edge.sourceHandle == branchHandle)
          .map((edge) => edge.targetId)
          .toList();
      if (nextIds.isEmpty && node.type == WorkflowNodeType.request) {
        final fallback = (adjacency[node.id] ?? const <_WorkflowEdgeRef>[])
            .where(
              (edge) =>
                  edge.sourceHandle != WorkflowEdgeHandle.then &&
                  edge.sourceHandle != WorkflowEdgeHandle.elseBranch &&
                  edge.sourceHandle != WorkflowEdgeHandle.success &&
                  edge.sourceHandle != WorkflowEdgeHandle.failure &&
                  edge.sourceHandle != WorkflowEdgeHandle.loopDone,
            )
            .map((edge) => edge.targetId);
        nextIds.addAll(fallback);
      }

      for (final nextId in nextIds) {
        final nextNode = workflow.graph.nodes
            .where((candidate) => candidate.id == nextId)
            .cast<WorkflowGraphNode?>()
            .firstWhere((candidate) => candidate != null, orElse: () => null);
        if (nextNode != null) {
          queue.add(
            _QueueEntry(
              nextNode,
              loopItem: entry.loopItem,
              loopIndex: entry.loopIndex,
              loopCompletionId: loopCompletionId,
            ),
          );
        }
      }

      if (loopCompletionId != null && nextIds.isEmpty) {
        _completeLoopIteration(
          loopId: loopCompletionId,
          loopIterationsRemaining: loopIterationsRemaining,
          loopDoneTargets: loopDoneTargets,
          loopItems: loopItems,
          loopBodyStarts: loopBodyStarts,
          queue: queue,
          workflow: workflow,
          scopedVariables: scopedVariables,
        );
      }
    }

    final failed = nodeResults.any(
      (result) => result.status == WorkflowNodeRunStatus.failed,
    );
    return WorkflowRunResult(
      workflowId: workflow.id,
      success: !failed,
      startedAt: startedAt,
      endedAt: DateTime.now(),
      nodeResults: nodeResults,
      scopedVariables: scopedVariables,
      error: failed ? 'One or more steps failed' : null,
    );
  }

  String _visitKey(_QueueEntry entry) {
    final node = entry.node;
    // Loop body iterations must be distinct even for the same node id.
    if (entry.loopCompletionId != null && entry.loopIndex != null) {
      return '${node.id}@${entry.loopCompletionId}:${entry.loopIndex}';
    }
    return node.id;
  }

  Map<String, String> _environmentVariables(WidgetRef ref) {
    final envMap = ref.read(availableEnvironmentVariablesStateProvider);
    final activeEnvId = ref.read(activeEnvironmentIdProvider);
    final merged = <String, String>{};
    void addAll(String? environmentId) {
      if (environmentId == null) {
        return;
      }
      for (final variable in envMap[environmentId] ?? const []) {
        if (variable.key.isEmpty) {
          continue;
        }
        merged[variable.key] = variable.value;
      }
    }

    addAll(kGlobalEnvironmentId);
    addAll(activeEnvId);
    return merged;
  }

  List<String> _repeatLoopItems(int? count) {
    if (count == null || count <= 0) {
      return const [];
    }
    return List.generate(count, (index) => '$index');
  }

  List<String> _resolveLoopItems(
    String? expression,
    Map<String, String> scopedVariables,
    Map<String, String> environmentVariables,
  ) {
    final expr = expression?.trim();
    if (expr == null || expr.isEmpty) {
      return const [];
    }
    if (!expr.startsWith('var:')) {
      return const [];
    }
    final key = expr.substring(4).trim();
    if (key.isEmpty) {
      return const [];
    }
    final raw = scopedVariables[key] ?? environmentVariables[key];
    if (raw == null || raw.trim().isEmpty) {
      return const [];
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((item) => item.toString()).toList();
      }
    } catch (_) {
      return raw
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return const [];
  }

  bool _evaluateCondition(
    String? expression, {
    required Map<String, String> scopedVariables,
    required int? lastStatusCode,
  }) {
    final exp = expression?.trim().toLowerCase();
    if (exp == null || exp.isEmpty || exp == 'true') {
      return true;
    }
    if (exp == 'false') {
      return false;
    }
    if (exp.startsWith('var:')) {
      final key = exp.substring(4).trim();
      final value = scopedVariables[key];
      return value != null && value.isNotEmpty;
    }
    if (lastStatusCode == null) {
      return false;
    }
    if (exp == 'status>=200') {
      return lastStatusCode >= 200;
    }
    if (exp == 'status<400') {
      return lastStatusCode < 400;
    }
    if (exp == 'status>=200&&status<300') {
      return lastStatusCode >= 200 && lastStatusCode < 300;
    }
    return false;
  }

  Map<String, List<_WorkflowEdgeRef>> _buildAdjacency(WorkflowDocument workflow) {
    final map = <String, List<_WorkflowEdgeRef>>{};
    for (final edge in workflow.graph.edges) {
      map.putIfAbsent(edge.source, () => []).add(
            _WorkflowEdgeRef(
              targetId: edge.target,
              sourceHandle: edge.sourceHandle,
            ),
          );
    }
    return map;
  }

  void _enqueueTargetIds(
    List<_QueueEntry> queue,
    WorkflowDocument workflow,
    List<String> targetIds,
  ) {
    for (final targetId in targetIds) {
      final nextNode = workflow.graph.nodes
          .where((candidate) => candidate.id == targetId)
          .cast<WorkflowGraphNode?>()
          .firstWhere((candidate) => candidate != null, orElse: () => null);
      if (nextNode != null) {
        queue.add(_QueueEntry(nextNode));
      }
    }
  }

  void _completeLoopIteration({
    required String loopId,
    required Map<String, int> loopIterationsRemaining,
    required Map<String, List<String>> loopDoneTargets,
    required Map<String, List<String>> loopItems,
    required Map<String, String> loopBodyStarts,
    required List<_QueueEntry> queue,
    required WorkflowDocument workflow,
    required Map<String, String> scopedVariables,
  }) {
    final remaining = loopIterationsRemaining[loopId];
    if (remaining == null) {
      return;
    }
    final nextRemaining = remaining - 1;
    if (nextRemaining <= 0) {
      loopIterationsRemaining.remove(loopId);
      loopItems.remove(loopId);
      loopBodyStarts.remove(loopId);
      final doneTargets = loopDoneTargets.remove(loopId) ?? const [];
      scopedVariables.remove('loop.item');
      scopedVariables.remove('loop.index');
      _enqueueTargetIds(queue, workflow, doneTargets);
      return;
    }

    loopIterationsRemaining[loopId] = nextRemaining;
    final items = loopItems[loopId];
    final bodyStartId = loopBodyStarts[loopId];
    if (items == null || bodyStartId == null) {
      return;
    }
    final nextIndex = items.length - nextRemaining;
    if (nextIndex < 0 || nextIndex >= items.length) {
      return;
    }
    final bodyNode = workflow.graph.nodes
        .where((candidate) => candidate.id == bodyStartId)
        .cast<WorkflowGraphNode?>()
        .firstWhere((candidate) => candidate != null, orElse: () => null);
    if (bodyNode == null) {
      return;
    }
    queue.insert(
      0,
      _QueueEntry(
        bodyNode,
        loopItem: items[nextIndex],
        loopIndex: '$nextIndex',
        loopCompletionId: loopId,
      ),
    );
  }
}

class _WorkflowEdgeRef {
  const _WorkflowEdgeRef({
    required this.targetId,
    required this.sourceHandle,
  });

  final String targetId;
  final WorkflowEdgeHandle sourceHandle;
}
