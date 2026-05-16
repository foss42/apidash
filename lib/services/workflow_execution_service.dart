import 'dart:convert';

import 'package:apidash/models/workflow_node_data.dart';
import 'package:vyuh_node_flow/vyuh_node_flow.dart';

enum WorkflowNodeRunStatus { pending, running, success, failed, skipped }

class WorkflowRunEvent {
  const WorkflowRunEvent({
    required this.nodeId,
    required this.message,
    required this.at,
    this.isError = false,
  });

  final String nodeId;
  final String message;
  final DateTime at;
  final bool isError;
}

class WorkflowNodeRunResult {
  const WorkflowNodeRunResult({
    required this.status,
    this.message,
    this.startedAt,
    this.endedAt,
  });

  final WorkflowNodeRunStatus status;
  final String? message;
  final DateTime? startedAt;
  final DateTime? endedAt;

  int? get durationMs {
    if (startedAt == null || endedAt == null) return null;
    return endedAt!.difference(startedAt!).inMilliseconds;
  }
}

class WorkflowRunResult {
  const WorkflowRunResult({
    required this.isSuccess,
    required this.nodeResults,
    this.error,
    required this.startedAt,
    required this.endedAt,
    required this.context,
    this.events = const <WorkflowRunEvent>[],
  });

  final bool isSuccess;
  final Map<String, WorkflowNodeRunResult> nodeResults;
  final String? error;
  final DateTime startedAt;
  final DateTime endedAt;
  final WorkflowExecutionContext context;
  final List<WorkflowRunEvent> events;

  int get durationMs => endedAt.difference(startedAt).inMilliseconds;
}

class WorkflowRequestResult {
  const WorkflowRequestResult({
    required this.ok,
    this.statusCode,
    this.message,
    this.responseBody,
    this.extra = const <String, dynamic>{},
  });

  final bool ok;
  final int? statusCode;
  final String? message;
  final String? responseBody;
  final Map<String, dynamic> extra;
}

class WorkflowExecutionContext {
  WorkflowExecutionContext({
    Map<String, dynamic>? variables,
    Map<String, dynamic>? results,
  })  : variables = variables ?? <String, dynamic>{},
        results = results ?? <String, dynamic>{};

  final Map<String, dynamic> variables;
  final Map<String, dynamic> results;
}

abstract class WorkflowExecutionDelegate {
  Future<WorkflowRequestResult> runRequest({
    required String nodeId,
    required String requestId,
    required WorkflowExecutionContext context,
  });
}

class WorkflowExecutionService {
  const WorkflowExecutionService();

  String? validate({
    required Map<String, Node<WorkflowNodeData>> nodes,
    required List<Connection<dynamic>> connections,
  }) {
    if (nodes.isEmpty) return 'Workflow has no nodes';
    final startNodes =
        nodes.values.where((n) => n.data.nodeType == WorkflowNodeType.start).toList();
    if (startNodes.length != 1) return 'Workflow must have exactly one Start node';
    final endNodes =
        nodes.values.where((n) => n.data.nodeType == WorkflowNodeType.end).toList();
    if (endNodes.isEmpty) return 'Workflow must have at least one End node';

    final adjacency = _adjacency(connections);
    for (final node in nodes.values) {
      if (node.data.nodeType == WorkflowNodeType.condition) {
        final edges = adjacency[node.id] ?? const <_WorkflowEdge>[];
        final hasTrue = edges.any((e) => e.sourcePortId == 'true');
        final hasFalse = edges.any((e) => e.sourcePortId == 'false');
        if (!hasTrue || !hasFalse) {
          return 'Condition node "${node.data.label}" must connect true and false branches';
        }
      }
    }
    final reachable = <String>{};
    void dfs(String id) {
      if (reachable.contains(id)) return;
      reachable.add(id);
      for (final edge in adjacency[id] ?? const <_WorkflowEdge>[]) {
        dfs(edge.targetNodeId);
      }
    }

    dfs(startNodes.first.id);
    final unreachable = nodes.keys.where((id) => !reachable.contains(id)).toList();
    if (unreachable.isNotEmpty) {
      return 'Workflow has unreachable nodes';
    }

    final inStack = <String>{};
    final visited = <String>{};
    bool hasCycle(String id) {
      if (inStack.contains(id)) return true;
      if (visited.contains(id)) return false;
      visited.add(id);
      inStack.add(id);
      for (final edge in adjacency[id] ?? const <_WorkflowEdge>[]) {
        if (hasCycle(edge.targetNodeId)) return true;
      }
      inStack.remove(id);
      return false;
    }

    if (hasCycle(startNodes.first.id)) return 'Workflow contains a cycle';
    return null;
  }

  Future<WorkflowRunResult> run({
    required Map<String, Node<WorkflowNodeData>> nodes,
    required List<Connection<dynamic>> connections,
    required WorkflowExecutionDelegate delegate,
    Map<String, dynamic>? initialVariables,
    void Function(String nodeId, WorkflowNodeRunResult result)? onNodeUpdate,
    void Function(WorkflowRunEvent event)? onEvent,
  }) async {
    final runStartedAt = DateTime.now();
    final validation = validate(nodes: nodes, connections: connections);
    if (validation != null) {
      return WorkflowRunResult(
        isSuccess: false,
        nodeResults: const {},
        error: validation,
        startedAt: runStartedAt,
        endedAt: DateTime.now(),
        context: WorkflowExecutionContext(),
      );
    }

    final nodeResults = <String, WorkflowNodeRunResult>{};
    final events = <WorkflowRunEvent>[];
    final adjacency = _adjacency(connections);
    final context = WorkflowExecutionContext(variables: initialVariables);
    final startNode =
        nodes.values.firstWhere((n) => n.data.nodeType == WorkflowNodeType.start);
    final queue = <String>[startNode.id];
    int? lastStatusCode;

    while (queue.isNotEmpty) {
      final currentId = queue.removeAt(0);
      final node = nodes[currentId];
      if (node == null) continue;

      final nodeStartedAt = DateTime.now();
      final running = WorkflowNodeRunResult(
        status: WorkflowNodeRunStatus.running,
        startedAt: nodeStartedAt,
      );
      nodeResults[currentId] = running;
      onNodeUpdate?.call(currentId, running);
      final startEvent = WorkflowRunEvent(
        nodeId: currentId,
        message: 'Started',
        at: nodeStartedAt,
      );
      events.add(startEvent);
      onEvent?.call(startEvent);

      WorkflowNodeRunResult result;
      switch (node.data.nodeType) {
        case WorkflowNodeType.start:
          result = const WorkflowNodeRunResult(status: WorkflowNodeRunStatus.success);
          break;
        case WorkflowNodeType.request:
          final requestId = node.data.linkedRequestId;
          if (requestId == null || requestId.isEmpty) {
            result = WorkflowNodeRunResult(
              status: WorkflowNodeRunStatus.failed,
              message: 'Request node has no linked request',
              startedAt: nodeStartedAt,
              endedAt: DateTime.now(),
            );
            break;
          }
          final req = await delegate.runRequest(
            nodeId: node.id,
            requestId: requestId,
            context: context,
          );
          lastStatusCode = req.statusCode;
          context.results[node.id] = <String, dynamic>{
            'ok': req.ok,
            'statusCode': req.statusCode,
            'message': req.message,
            'responseBody': req.responseBody,
            ...req.extra,
          };
          result = WorkflowNodeRunResult(
            status: req.ok
                ? WorkflowNodeRunStatus.success
                : WorkflowNodeRunStatus.failed,
            message: req.message,
            startedAt: nodeStartedAt,
            endedAt: DateTime.now(),
          );
          break;
        case WorkflowNodeType.variable:
          final key = node.data.variableKey?.trim();
          if (key == null || key.isEmpty) {
            result = WorkflowNodeRunResult(
              status: WorkflowNodeRunStatus.failed,
              message: 'Variable node key is empty',
              startedAt: nodeStartedAt,
              endedAt: DateTime.now(),
            );
            break;
          }
          final source = node.data.variableSource?.trim();
          if (source != null && source.isNotEmpty && source.startsWith('json:')) {
            final extracted = _extractFromContextJson(
              source.substring(5).trim(),
              context,
            );
            context.variables[key] = extracted;
          } else {
            context.variables[key] = node.data.variableValue;
          }
          result = WorkflowNodeRunResult(
            status: WorkflowNodeRunStatus.success,
            startedAt: nodeStartedAt,
            endedAt: DateTime.now(),
          );
          break;
        case WorkflowNodeType.condition:
          final ok = _evaluateCondition(
            node.data.conditionExpression,
            lastStatusCode: lastStatusCode,
            context: context,
          );
          result = WorkflowNodeRunResult(
            status: ok ? WorkflowNodeRunStatus.success : WorkflowNodeRunStatus.failed,
            message: ok ? null : 'Condition evaluated to false',
            startedAt: nodeStartedAt,
            endedAt: DateTime.now(),
          );
          break;
        case WorkflowNodeType.transform:
          _applyTransform(node.data.transformScript, context);
          result = WorkflowNodeRunResult(
            status: WorkflowNodeRunStatus.success,
            startedAt: nodeStartedAt,
            endedAt: DateTime.now(),
          );
          break;
        case WorkflowNodeType.delay:
          final delayMs = node.data.delayMs ?? 0;
          if (delayMs > 0) {
            await Future.delayed(Duration(milliseconds: delayMs));
          }
          result = WorkflowNodeRunResult(
            status: WorkflowNodeRunStatus.success,
            startedAt: nodeStartedAt,
            endedAt: DateTime.now(),
          );
          break;
        case WorkflowNodeType.loop:
          final loopItems = _resolveLoopItems(
            expression: node.data.loopExpression,
            context: context,
          );
          if (loopItems.isEmpty) {
            result = WorkflowNodeRunResult(
              status: WorkflowNodeRunStatus.success,
              message: 'Loop has no items',
              startedAt: nodeStartedAt,
              endedAt: DateTime.now(),
            );
            break;
          }
          final childEdges = (adjacency[currentId] ?? const <_WorkflowEdge>[])
              .where((e) => e.sourcePortId != 'true' && e.sourcePortId != 'false')
              .toList();
          if (childEdges.isNotEmpty) {
            for (final item in loopItems) {
              context.variables['loop.item'] = item;
              queue.insert(0, childEdges.first.targetNodeId);
            }
          }
          result = WorkflowNodeRunResult(
            status: WorkflowNodeRunStatus.success,
            startedAt: nodeStartedAt,
            endedAt: DateTime.now(),
          );
          break;
        case WorkflowNodeType.end:
          result = WorkflowNodeRunResult(
            status: WorkflowNodeRunStatus.success,
            startedAt: nodeStartedAt,
            endedAt: DateTime.now(),
          );
          break;
      }

      nodeResults[currentId] = result;
      onNodeUpdate?.call(currentId, result);
      final doneEvent = WorkflowRunEvent(
        nodeId: currentId,
        message: result.message ?? result.status.name,
        at: DateTime.now(),
        isError: result.status == WorkflowNodeRunStatus.failed,
      );
      events.add(doneEvent);
      onEvent?.call(doneEvent);
      if (result.status == WorkflowNodeRunStatus.failed) {
        return WorkflowRunResult(
          isSuccess: false,
          nodeResults: nodeResults,
          error: result.message ?? 'Workflow failed',
          startedAt: runStartedAt,
          endedAt: DateTime.now(),
          context: context,
          events: events,
        );
      }

      if (node.data.nodeType == WorkflowNodeType.end) {
        break;
      }
      if (node.data.nodeType == WorkflowNodeType.condition ||
          node.data.nodeType == WorkflowNodeType.request) {
        final branchPassed = result.status == WorkflowNodeRunStatus.success;
        final preferredPort = node.data.nodeType == WorkflowNodeType.condition
            ? (branchPassed ? 'true' : 'false')
            : (branchPassed ? 'success' : 'failure');
        final branch = (adjacency[currentId] ?? const <_WorkflowEdge>[])
            .where((e) => e.sourcePortId == preferredPort)
            .map((e) => e.targetNodeId)
            .toList();
        if (branch.isNotEmpty) {
          queue.addAll(branch);
          continue;
        }
      }
      queue.addAll(
        (adjacency[currentId] ?? const <_WorkflowEdge>[])
            .where(
              (e) =>
                  e.sourcePortId != 'true' &&
                  e.sourcePortId != 'false' &&
                  e.sourcePortId != 'success' &&
                  e.sourcePortId != 'failure',
            )
            .map((e) => e.targetNodeId),
      );
    }

    return WorkflowRunResult(
      isSuccess: true,
      nodeResults: nodeResults,
      startedAt: runStartedAt,
      endedAt: DateTime.now(),
      context: context,
      events: events,
    );
  }

  bool _evaluateCondition(
    String? expression, {
    required int? lastStatusCode,
    required WorkflowExecutionContext context,
  }) {
    final exp = expression?.trim().toLowerCase();
    if (exp == null || exp.isEmpty || exp == 'true') return true;
    if (exp == 'false') return false;
    if (exp.startsWith('var:')) {
      final key = exp.substring(4).trim();
      final val = context.variables[key];
      if (val is bool) return val;
      return val != null && val.toString().toLowerCase() == 'true';
    }
    if (lastStatusCode == null) return false;
    if (exp == 'status>=200') return lastStatusCode >= 200;
    if (exp == 'status<400') return lastStatusCode < 400;
    if (exp == 'status>=200&&status<300') {
      return lastStatusCode >= 200 && lastStatusCode < 300;
    }
    return false;
  }

  void _applyTransform(String? script, WorkflowExecutionContext context) {
    final source = script?.trim();
    if (source == null || source.isEmpty) return;
    final lines = source
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    for (final line in lines) {
      final parts = line.split('=');
      if (parts.length != 2) continue;
      final key = parts.first.trim();
      final valueExpr = parts.last.trim();
      if (key.isEmpty) continue;
      if (valueExpr.startsWith('json:')) {
        final path = valueExpr.substring(5).trim();
        final extracted = _extractFromContextJson(path, context);
        context.variables[key] = extracted;
      } else {
        context.variables[key] = valueExpr;
      }
    }
  }

  dynamic _extractFromContextJson(String path, WorkflowExecutionContext context) {
    final lastResult = context.results.values.isNotEmpty
        ? context.results.values.last as Map<String, dynamic>
        : null;
    final body = lastResult?['responseBody'];
    if (body is! String || body.isEmpty) return null;
    try {
      dynamic value = body;
      if (value is String) {
        final normalized = value.trimLeft();
        value = normalized.startsWith('{') || normalized.startsWith('[')
            ? _safeJsonDecode(normalized)
            : null;
      }
      if (value == null) return null;
      final parts = path.split('.').where((p) => p.isNotEmpty).toList();
      dynamic current = value;
      for (final part in parts) {
        if (current is Map && current.containsKey(part)) {
          current = current[part];
        } else {
          return null;
        }
      }
      return current;
    } catch (_) {
      return null;
    }
  }

  dynamic _safeJsonDecode(String input) {
    try {
      return jsonDecode(input);
    } catch (_) {
      return null;
    }
  }

  List<dynamic> _resolveLoopItems({
    required String? expression,
    required WorkflowExecutionContext context,
  }) {
    final expr = expression?.trim();
    if (expr == null || expr.isEmpty) return const <dynamic>[];
    if (expr.startsWith('var:')) {
      final key = expr.substring(4).trim();
      final value = context.variables[key];
      if (value is List) return value;
      return const <dynamic>[];
    }
    return const <dynamic>[];
  }

  Map<String, List<_WorkflowEdge>> _adjacency(
    List<Connection<dynamic>> connections,
  ) {
    final map = <String, List<_WorkflowEdge>>{};
    for (final c in connections) {
      map.putIfAbsent(c.sourceNodeId, () => <_WorkflowEdge>[]).add(
            _WorkflowEdge(
              sourcePortId: c.sourcePortId,
              targetNodeId: c.targetNodeId,
            ),
          );
    }
    return map;
  }
}

class _WorkflowEdge {
  const _WorkflowEdge({
    required this.sourcePortId,
    required this.targetNodeId,
  });

  final String sourcePortId;
  final String targetNodeId;
}
