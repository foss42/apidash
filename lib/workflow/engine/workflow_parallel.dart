import 'dart:async';

import 'package:apidash/workflow/engine/workflow_branch_context.dart';

/// Outgoing adjacency (any handle) for reachability / join expectations.
Map<String, List<String>> buildWorkflowOutAdjacency(
  Iterable<({String source, String target})> edges,
) {
  final map = <String, List<String>>{};
  for (final edge in edges) {
    map.putIfAbsent(edge.source, () => []).add(edge.target);
  }
  return map;
}

/// Whether [to] is reachable from [from] following directed edges.
bool workflowCanReach(
  Map<String, List<String>> adjacency, {
  required String from,
  required String to,
}) {
  if (from == to) {
    return true;
  }
  final visiting = <String>{};
  bool dfs(String nodeId) {
    if (!visiting.add(nodeId)) {
      return false;
    }
    for (final next in adjacency[nodeId] ?? const <String>[]) {
      if (next == to || dfs(next)) {
        return true;
      }
    }
    return false;
  }

  return dfs(from);
}

/// How many parallel sibling roots can still arrive at [joinNodeId].
///
/// Used so a join does not wait forever when some siblings never reach it
/// (they ended or took another path).
int workflowExpectedJoinArrivals(
  Map<String, List<String>> adjacency, {
  required List<String> siblingRoots,
  required String joinNodeId,
}) {
  var count = 0;
  for (final root in siblingRoots) {
    if (workflowCanReach(adjacency, from: root, to: joinNodeId)) {
      count += 1;
    }
  }
  return count;
}

/// Barrier for one AND-join under a parallel scope.
class WorkflowJoinBarrier {
  WorkflowJoinBarrier({required this.expected});

  final int expected;
  final List<WorkflowBranchContext> arrivals = [];
  final Completer<WorkflowBranchContext> _completer =
      Completer<WorkflowBranchContext>();

  bool get isComplete => _completer.isCompleted;

  Future<WorkflowBranchContext> get merged => _completer.future;

  /// Returns the merged context when this arrival completes the barrier;
  /// otherwise waits for the leader's merge.
  Future<WorkflowBranchContext> arrive(WorkflowBranchContext context) async {
    if (isComplete) {
      return merged;
    }
    arrivals.add(context);
    if (arrivals.length < expected) {
      return merged;
    }
    try {
      final result = mergeBranchContexts(arrivals);
      if (!_completer.isCompleted) {
        _completer.complete(result);
      }
      return result;
    } catch (error, stackTrace) {
      fail(error, stackTrace);
      rethrow;
    }
  }

  void fail(Object error, [StackTrace? stackTrace]) {
    if (!_completer.isCompleted) {
      _completer.completeError(error, stackTrace);
    }
  }
}
