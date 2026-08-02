import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/storage/workspace_storage.dart';
import 'package:apidash/workflow/engine/extraction_service.dart';
import 'package:apidash/workflow/engine/workflow_branch_context.dart';
import 'package:apidash/workflow/engine/workflow_parallel.dart';
import 'package:apidash/workflow/engine/workflow_request_executor.dart';
import 'package:apidash/workflow/engine/workflow_validator.dart';
import 'package:apidash/workflow/models/workflow_request_codec.dart';
import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/utils/workflow_error_utils.dart';
import 'package:apidash/workflow/utils/workflow_loop_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Active parallel fan-out region (AND-split). Nested splits push a child scope.
class _ParallelScope {
  _ParallelScope({
    required this.id,
    required this.siblingRoots,
    this.parent,
  });

  final String id;
  final List<String> siblingRoots;
  final _ParallelScope? parent;
}

class _QueueEntry {
  _QueueEntry(
    this.node, {
    WorkflowBranchContext? context,
    this.parallel,
    this.parallelRootId,
    this.loopItem,
    this.loopIndex,
    this.loopCompletionId,
    this.loopItemField,
    this.loopItemAs,
  }) : context = context ?? WorkflowBranchContext();

  final WorkflowGraphNode node;
  final WorkflowBranchContext context;
  final _ParallelScope? parallel;
  /// Sibling-root node id for the active parallel fan-out (for join absents).
  final String? parallelRootId;
  final String? loopItem;
  final String? loopIndex;
  final String? loopCompletionId;
  final String? loopItemField;
  final String? loopItemAs;

  _QueueEntry copyWith({
    WorkflowGraphNode? node,
    WorkflowBranchContext? context,
    _ParallelScope? parallel,
    bool clearParallel = false,
    String? parallelRootId,
    bool clearParallelRootId = false,
    String? loopItem,
    String? loopIndex,
    String? loopCompletionId,
    String? loopItemField,
    String? loopItemAs,
  }) {
    return _QueueEntry(
      node ?? this.node,
      context: context ?? this.context,
      parallel: clearParallel ? null : (parallel ?? this.parallel),
      parallelRootId: clearParallelRootId
          ? null
          : (parallelRootId ?? this.parallelRootId),
      loopItem: loopItem ?? this.loopItem,
      loopIndex: loopIndex ?? this.loopIndex,
      loopCompletionId: loopCompletionId ?? this.loopCompletionId,
      loopItemField: loopItemField ?? this.loopItemField,
      loopItemAs: loopItemAs ?? this.loopItemAs,
    );
  }
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

    final session = _WorkflowRunSession(
      ref: ref,
      workflow: workflow,
      storage: storage,
      extractionService: extractionService,
      onNodeUpdate: onNodeUpdate,
      shouldStop: shouldStop,
      startedAt: startedAt,
    );

    try {
      await Future.wait([
        for (final node in validator.entryNodes(workflow))
          session.drive(_QueueEntry(node)),
      ]);
    } on _WorkflowAbort catch (abort) {
      return session.result(
        success: false,
        error: abort.message,
      );
    } catch (error) {
      return session.result(
        success: false,
        error: error.toString(),
      );
    }

    if (shouldStop?.call() ?? false) {
      return session.result(success: false, error: 'Workflow stopped');
    }

    final failedResults = session.nodeResults
        .where((result) => result.status == WorkflowNodeRunStatus.failed)
        .toList();
    return session.result(
      success: failedResults.isEmpty,
      error: failedResults.isEmpty
          ? null
          : formatWorkflowFailedStepsError([
              for (final result in failedResults)
                (nodeId: result.nodeId, label: result.label),
            ]),
    );
  }
}

class _WorkflowAbort implements Exception {
  _WorkflowAbort(this.message);
  final String message;
}

class _WorkflowRunSession {
  _WorkflowRunSession({
    required this.ref,
    required this.workflow,
    required this.storage,
    required this.extractionService,
    required this.onNodeUpdate,
    required this.shouldStop,
    required this.startedAt,
  })  : adjacency = _buildAdjacency(workflow),
        outAdjacency = buildWorkflowOutAdjacency([
          for (final edge in workflow.graph.edges)
            (source: edge.source, target: edge.target),
        ]);

  final WidgetRef ref;
  final WorkflowDocument workflow;
  final WorkspaceStorage storage;
  final WorkflowExtractionService extractionService;
  final void Function(WorkflowNodeRunResult result)? onNodeUpdate;
  final bool Function()? shouldStop;
  final DateTime startedAt;

  final Map<String, List<_WorkflowEdgeRef>> adjacency;
  final Map<String, List<String>> outAdjacency;

  final resultScopedVariables = <String, String>{};
  final nodeResults = <WorkflowNodeRunResult>[];
  final visited = <String>{};
  final joinBarriers = <String, WorkflowJoinBarrier>{};
  final loopIterationsRemaining = <String, int>{};
  final loopDoneTargets = <String, List<String>>{};
  final loopItems = <String, List<String>>{};
  final loopBodyStarts = <String, String>{};
  final loopContexts = <String, WorkflowBranchContext>{};
  final loopParallels = <String, _ParallelScope?>{};
  final loopParallelRootIds = <String, String?>{};
  final parallelRootAbsents = <String, Set<String>>{};

  int _parallelSeq = 0;
  Object? _abortError;

  WorkflowRunResult result({required bool success, String? error}) {
    return WorkflowRunResult(
      workflowId: workflow.id,
      success: success,
      startedAt: startedAt,
      endedAt: DateTime.now(),
      nodeResults: nodeResults,
      scopedVariables: resultScopedVariables,
      error: error,
    );
  }

  void _abort(String message) {
    _abortError ??= message;
    final error = _WorkflowAbort(message);
    for (final barrier in joinBarriers.values) {
      barrier.fail(error);
    }
  }

  void _throwIfAborted() {
    final stop = shouldStop?.call() ?? false;
    if (stop) {
      _abort('Workflow stopped');
    }
    final err = _abortError;
    if (err != null) {
      throw _WorkflowAbort(err.toString());
    }
  }

  /// Drive one token from arrival through execution and successors.
  Future<void> drive(_QueueEntry entry) async {
    _throwIfAborted();
    final prepared = await _prepareArrival(entry);
    if (prepared == null) {
      return;
    }
    await _execute(prepared);
  }

  Future<_QueueEntry?> _prepareArrival(_QueueEntry entry) async {
    _throwIfAborted();
    final scope = entry.parallel;
    if (scope == null) {
      if (!visited.add(_visitKey(entry))) {
        return null;
      }
      return entry;
    }

    final expected = workflowExpectedJoinArrivals(
      outAdjacency,
      siblingRoots: scope.siblingRoots,
      joinNodeId: entry.node.id,
    );

    if (expected <= 1) {
      if (!visited.add(_visitKey(entry))) {
        return null;
      }
      return entry;
    }

    final joinKey =
        '${entry.node.id}@${scope.id}@${entry.loopCompletionId ?? ''}:${entry.loopIndex ?? ''}';
    final absents = parallelRootAbsents[scope.id] ?? const <String>{};
    var initialAbsent = 0;
    for (final rootId in scope.siblingRoots) {
      if (!absents.contains(rootId)) {
        continue;
      }
      if (workflowCanReach(
        outAdjacency,
        from: rootId,
        to: entry.node.id,
      )) {
        initialAbsent += 1;
      }
    }
    final barrier = joinBarriers.putIfAbsent(
      joinKey,
      () => WorkflowJoinBarrier(
        expected: expected,
        initialAbsent: initialAbsent,
      ),
    );

    try {
      final merged = await barrier.arrive(entry.context);
      _throwIfAborted();
      // Only one sibling executes the joined node.
      if (!visited.add(_visitKey(entry))) {
        return null;
      }
      return entry.copyWith(
        context: merged,
        parallel: scope.parent,
        clearParallel: scope.parent == null,
        clearParallelRootId: scope.parent == null,
        parallelRootId: scope.parent == null ? null : entry.parallelRootId,
      );
    } on WorkflowMergeConflict catch (conflict) {
      final message = formatWorkflowNodeError(
        conflict.toString(),
        nodeLabel: entry.node.label,
        nodeId: entry.node.id,
      );
      _abort(message);
      throw _WorkflowAbort(message);
    }
  }

  Future<void> _execute(_QueueEntry entry) async {
    _throwIfAborted();
    final node = entry.node;
    final scopedVariables = entry.context.scopedVariables;
    final loopCompletionId = entry.loopCompletionId;

    if (entry.loopItem != null || entry.loopIndex != null) {
      applyLoopScopedVariables(
        scopedVariables,
        loopItem: entry.loopItem,
        loopIndex: entry.loopIndex,
        itemField: entry.loopItemField,
        itemAs: entry.loopItemAs,
      );
    }

    final nodeStartedAt = DateTime.now();
    onNodeUpdate?.call(
      WorkflowNodeRunResult(
        nodeId: node.id,
        label: node.label,
        nodeType: node.type,
        status: WorkflowNodeRunStatus.running,
        loopIndex: entry.loopIndex,
      ),
    );

    WorkflowNodeRunResult result;
    var branchHandle = WorkflowEdgeHandle.success;
    var skipDefaultEnqueue = false;
    final pendingDrives = <_QueueEntry>[];

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
            _throwIfAborted();
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
          lastStatusCode: entry.context.lastStatusCode,
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
        final environmentVariables = _environmentVariables();
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
        final doneTargetIds =
            (adjacency[node.id] ?? const <_WorkflowEdgeRef>[])
                .where((edge) => edge.sourceHandle == WorkflowEdgeHandle.loopDone)
                .map((edge) => edge.targetId)
                .toList();
        final bodyStarts = (adjacency[node.id] ?? const <_WorkflowEdgeRef>[])
            .where((edge) => edge.sourceHandle == WorkflowEdgeHandle.next)
            .map((edge) => edge.targetId)
            .toList();
        if (items.isEmpty || bodyStarts.isEmpty) {
          pendingDrives.addAll(
            _entriesForTargets(
              doneTargetIds,
              context: entry.context,
              parallel: entry.parallel,
              parallelRootId: entry.parallelRootId,
            ),
          );
        } else {
          loopIterationsRemaining[node.id] = items.length;
          loopDoneTargets[node.id] = doneTargetIds;
          loopItems[node.id] = items;
          loopBodyStarts[node.id] = bodyStarts.first;
          loopContexts[node.id] = entry.context;
          loopParallels[node.id] = entry.parallel;
          loopParallelRootIds[node.id] = entry.parallelRootId;
          final bodyNode = _nodeById(bodyStarts.first);
          if (bodyNode != null) {
            // Loop iterations stay sequential; share context on this branch.
            pendingDrives.add(
              _QueueEntry(
                bodyNode,
                context: entry.context,
                parallel: entry.parallel,
                parallelRootId: entry.parallelRootId,
                loopItem: items.first,
                loopIndex: '0',
                loopCompletionId: node.id,
                loopItemField: node.loopItemField,
                loopItemAs: node.loopItemAs,
              ),
            );
          }
        }
        skipDefaultEnqueue = true;
      case WorkflowNodeType.request:
        if (node.request == null || node.request!.isEmpty) {
          final message = formatWorkflowNodeError(
            'Missing request on node',
            nodeLabel: node.label,
            nodeId: node.id,
          );
          result = WorkflowNodeRunResult(
            nodeId: node.id,
            label: node.label,
            nodeType: node.type,
            status: WorkflowNodeRunStatus.failed,
            message: message,
            branch: 'failure',
          );
          branchHandle = WorkflowEdgeHandle.failure;
          break;
        }
        final requestModel = resolveWorkflowNodeRequest(
          node: node,
          storage: storage,
        );
        late final WorkflowStepExecutionResult execution;
        try {
          execution = await executeWorkflowRequest(
            ref: ref,
            requestModel: requestModel,
            scopedVariables: scopedVariables,
            logLabel: '${workflow.id}/${node.id}',
          );
        } catch (error) {
          final message = formatWorkflowNodeError(
            error.toString(),
            nodeLabel: node.label,
            nodeId: node.id,
          );
          result = WorkflowNodeRunResult(
            nodeId: node.id,
            label: node.label,
            nodeType: node.type,
            status: WorkflowNodeRunStatus.failed,
            message: message,
            apiType: requestModel.apiType,
            branch: 'failure',
          );
          branchHandle = WorkflowEdgeHandle.failure;
          break;
        }
        _throwIfAborted();
        entry.context.lastStatusCode = execution.statusCode;
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
        final failureMessage = ok
            ? null
            : formatWorkflowNodeError(
                execution.message ?? 'Request step failed',
                nodeLabel: node.label,
                nodeId: node.id,
              );
        result = WorkflowNodeRunResult(
          nodeId: node.id,
          label: node.label,
          nodeType: node.type,
          status: ok
              ? WorkflowNodeRunStatus.success
              : WorkflowNodeRunStatus.failed,
          message: ok ? execution.message : failureMessage,
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
    }

    resultScopedVariables.addAll(scopedVariables);
    nodeResults.add(result);
    onNodeUpdate?.call(result.copyWith(loopIndex: entry.loopIndex));

    if (!skipDefaultEnqueue) {
      final nextIds = _nextTargetIds(node, branchHandle);
      pendingDrives.addAll(
        _entriesForTargets(
          nextIds,
          context: entry.context,
          parallel: entry.parallel,
          parallelRootId: entry.parallelRootId,
          loopItem: entry.loopItem,
          loopIndex: entry.loopIndex,
          loopCompletionId: loopCompletionId,
          loopItemField: entry.loopItemField,
          loopItemAs: entry.loopItemAs,
        ),
      );

      if (loopCompletionId != null && nextIds.isEmpty) {
        pendingDrives.addAll(
          _completeLoopIteration(loopId: loopCompletionId),
        );
      }
    }

    if (pendingDrives.isEmpty) {
      _noteParallelBranchEnded(entry);
    }
    await _driveSuccessors(pendingDrives, parentParallel: entry.parallel);
  }

  /// When a parallel token dies (no successors), free joins waiting on that root.
  void _noteParallelBranchEnded(_QueueEntry entry) {
    final scope = entry.parallel;
    final rootId = entry.parallelRootId;
    if (scope == null || rootId == null || rootId.isEmpty) {
      return;
    }
    final absents = parallelRootAbsents.putIfAbsent(scope.id, () => <String>{});
    if (!absents.add(rootId)) {
      return;
    }
    for (final mapEntry in joinBarriers.entries) {
      final key = mapEntry.key;
      final scopeMarker = '@${scope.id}@';
      final scopeIdx = key.indexOf(scopeMarker);
      if (scopeIdx <= 0) {
        continue;
      }
      final joinNodeId = key.substring(0, scopeIdx);
      if (!workflowCanReach(
        outAdjacency,
        from: rootId,
        to: joinNodeId,
      )) {
        continue;
      }
      mapEntry.value.markAbsent();
    }
  }

  Future<void> _driveSuccessors(
    List<_QueueEntry> successors, {
    required _ParallelScope? parentParallel,
  }) async {
    if (successors.isEmpty) {
      return;
    }
    if (successors.length == 1) {
      await drive(successors.single);
      return;
    }

    // AND-split: run sibling trees concurrently with forked contexts.
    final scope = _ParallelScope(
      id: 'p${_parallelSeq++}',
      siblingRoots: [for (final e in successors) e.node.id],
      parent: parentParallel,
    );
    final parallelEntries = [
      for (final e in successors)
        e.copyWith(
          parallel: scope,
          parallelRootId: e.node.id,
        ),
    ];
    await Future.wait(
      [for (final e in parallelEntries) drive(e)],
      eagerError: false,
    );
  }

  List<String> _nextTargetIds(
    WorkflowGraphNode node,
    WorkflowEdgeHandle branchHandle,
  ) {
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
    return nextIds;
  }

  List<_QueueEntry> _entriesForTargets(
    List<String> targetIds, {
    required WorkflowBranchContext context,
    _ParallelScope? parallel,
    String? parallelRootId,
    String? loopItem,
    String? loopIndex,
    String? loopCompletionId,
    String? loopItemField,
    String? loopItemAs,
  }) {
    if (targetIds.isEmpty) {
      return const [];
    }
    final contexts = contextsForSuccessors(context, count: targetIds.length);
    final entries = <_QueueEntry>[];
    for (var i = 0; i < targetIds.length; i++) {
      final nextNode = _nodeById(targetIds[i]);
      if (nextNode == null) {
        continue;
      }
      entries.add(
        _QueueEntry(
          nextNode,
          context: contexts[i],
          parallel: parallel,
          parallelRootId: parallelRootId,
          loopItem: loopItem,
          loopIndex: loopIndex,
          loopCompletionId: loopCompletionId,
          loopItemField: loopItemField,
          loopItemAs: loopItemAs,
        ),
      );
    }
    return entries;
  }

  List<_QueueEntry> _completeLoopIteration({required String loopId}) {
    final remaining = loopIterationsRemaining[loopId];
    if (remaining == null) {
      return const [];
    }
    final context = loopContexts[loopId] ?? WorkflowBranchContext();
    final parallel = loopParallels[loopId];
    final parallelRootId = loopParallelRootIds[loopId];
    final nextRemaining = remaining - 1;
    if (nextRemaining <= 0) {
      loopIterationsRemaining.remove(loopId);
      loopItems.remove(loopId);
      loopBodyStarts.remove(loopId);
      loopContexts.remove(loopId);
      loopParallels.remove(loopId);
      loopParallelRootIds.remove(loopId);
      final doneTargets = loopDoneTargets.remove(loopId) ?? const [];
      final loopNode = _nodeById(loopId);
      clearLoopScopedVariables(
        context.scopedVariables,
        itemAs: loopNode?.loopItemAs,
      );
      return _entriesForTargets(
        doneTargets,
        context: context,
        parallel: parallel,
        parallelRootId: parallelRootId,
      );
    }

    loopIterationsRemaining[loopId] = nextRemaining;
    final items = loopItems[loopId];
    final bodyStartId = loopBodyStarts[loopId];
    if (items == null || bodyStartId == null) {
      return const [];
    }
    final nextIndex = items.length - nextRemaining;
    if (nextIndex < 0 || nextIndex >= items.length) {
      return const [];
    }
    final bodyNode = _nodeById(bodyStartId);
    if (bodyNode == null) {
      return const [];
    }
    final loopNode = _nodeById(loopId);
    return [
      _QueueEntry(
        bodyNode,
        context: context,
        parallel: parallel,
        parallelRootId: parallelRootId,
        loopItem: items[nextIndex],
        loopIndex: '$nextIndex',
        loopCompletionId: loopId,
        loopItemField: loopNode?.loopItemField,
        loopItemAs: loopNode?.loopItemAs,
      ),
    ];
  }

  WorkflowGraphNode? _nodeById(String id) {
    return workflow.graph.nodes
        .where((candidate) => candidate.id == id)
        .cast<WorkflowGraphNode?>()
        .firstWhere((candidate) => candidate != null, orElse: () => null);
  }

  String _visitKey(_QueueEntry entry) {
    final node = entry.node;
    if (entry.loopCompletionId != null && entry.loopIndex != null) {
      return '${node.id}@${entry.loopCompletionId}:${entry.loopIndex}';
    }
    return node.id;
  }

  Map<String, String> _environmentVariables() {
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
    final key = parseLoopListVariableName(expression);
    if (key == null) {
      return const [];
    }
    final raw = scopedVariables[key] ?? environmentVariables[key];
    if (raw == null || raw.trim().isEmpty) {
      return const [];
    }
    return resolveLoopItemList(raw);
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

  static Map<String, List<_WorkflowEdgeRef>> _buildAdjacency(
    WorkflowDocument workflow,
  ) {
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
}

class _WorkflowEdgeRef {
  const _WorkflowEdgeRef({
    required this.targetId,
    required this.sourceHandle,
  });

  final String targetId;
  final WorkflowEdgeHandle sourceHandle;
}
