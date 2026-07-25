import 'package:apidash/workflow/models/workflow_models.dart';

class WorkflowValidationResult {
  const WorkflowValidationResult({
    this.errors = const [],
    this.warnings = const [],
  });

  final List<String> errors;
  final List<String> warnings;

  bool get isValid => errors.isEmpty;
}

class WorkflowValidator {
  const WorkflowValidator();

  WorkflowValidationResult validate(WorkflowDocument workflow) {
    final errors = <String>[];
    final warnings = <String>[];

    if (workflow.id.trim().isEmpty) {
      errors.add('Workflow id is required.');
    }
    if (workflow.name.trim().isEmpty) {
      warnings.add('Workflow name is empty.');
    }

    final nodeIds = <String>{};
    for (final node in workflow.graph.nodes) {
      if (node.id.isEmpty) {
        errors.add('A node is missing an id.');
        continue;
      }
      if (!nodeIds.add(node.id)) {
        errors.add('Duplicate node id: ${node.id}');
      }
      switch (node.type) {
        case WorkflowNodeType.request:
          final request = node.requestModel();
          if (request == null) {
            errors.add('Request node "${node.label}" has no request payload.');
          } else if (request.httpRequestModel == null &&
              request.aiRequestModel == null) {
            warnings.add(
              'Request node "${node.label}" has no HTTP/AI request configured.',
            );
          }
        case WorkflowNodeType.condition:
          if ((node.conditionExpression ?? '').trim().isEmpty) {
            warnings.add('Condition node "${node.label}" has no expression.');
          }
        case WorkflowNodeType.loop:
          if (node.loopMode == WorkflowLoopMode.repeat) {
            if (node.loopMaxIterations == null || node.loopMaxIterations! <= 0) {
              warnings.add(
                'Loop node "${node.label}" needs a repeat count greater than 0.',
              );
            }
          } else if ((node.loopExpression ?? '').trim().isEmpty) {
            warnings.add('Loop node "${node.label}" has no list variable.');
          }
        case WorkflowNodeType.delay:
          if (node.delayMs == null || node.delayMs! <= 0) {
            warnings.add(
              'Delay node "${node.label}" needs a wait time greater than 0ms.',
            );
          }
        case WorkflowNodeType.manualStart:
          break;
      }
    }

    for (final edge in workflow.graph.edges) {
      if (!nodeIds.contains(edge.source)) {
        errors.add('Edge ${edge.id} references missing source node.');
      }
      if (!nodeIds.contains(edge.target)) {
        errors.add('Edge ${edge.id} references missing target node.');
      }
    }

    if (_hasCycle(workflow)) {
      errors.add('Workflow graph contains a cycle.');
    }

    final entryNodes = _entryNodes(workflow);
    if (workflow.graph.nodes.isNotEmpty && entryNodes.isEmpty) {
      errors.add('Workflow has no entry nodes.');
    }

    for (final node in workflow.graph.nodes) {
      if (node.type == WorkflowNodeType.loop) {
        final outgoing = workflow.graph.edges.where((e) => e.source == node.id);
        final hasBody = outgoing.any(
          (e) => e.sourceHandle == WorkflowEdgeHandle.next,
        );
        if (!hasBody) {
          warnings.add(
            'Loop node "${node.label}" should connect a body via the Each port.',
          );
        }
        final hasDone = outgoing.any(
          (e) => e.sourceHandle == WorkflowEdgeHandle.loopDone,
        );
        if (!hasDone) {
          warnings.add(
            'Loop node "${node.label}" should connect a Done port for post-loop steps.',
          );
        }
        continue;
      }
      if (node.type != WorkflowNodeType.condition) {
        continue;
      }
      final outgoing = workflow.graph.edges.where((e) => e.source == node.id);
      final hasThen = outgoing.any(
        (e) => e.sourceHandle == WorkflowEdgeHandle.then,
      );
      final hasElse = outgoing.any(
        (e) => e.sourceHandle == WorkflowEdgeHandle.elseBranch,
      );
      if (!hasThen || !hasElse) {
        warnings.add(
          'Condition node "${node.label}" should connect both True and False branches.',
        );
      }
    }

    final starts = [
      for (final node in workflow.graph.nodes)
        if (node.type == WorkflowNodeType.manualStart) node,
    ];
    if (starts.isNotEmpty) {
      final reachable = _reachableFrom(workflow, starts.map((n) => n.id));
      for (final node in workflow.graph.nodes) {
        if (node.type == WorkflowNodeType.manualStart) {
          continue;
        }
        if (!reachable.contains(node.id)) {
          final name = node.label.isNotEmpty ? node.label : node.id;
          warnings.add(
            'Node "$name" is not connected from Start and will be skipped.',
          );
        }
      }
    }

    return WorkflowValidationResult(errors: errors, warnings: warnings);
  }

  List<WorkflowGraphNode> entryNodes(WorkflowDocument workflow) =>
      _entryNodes(workflow);

  bool _hasCycle(WorkflowDocument workflow) {
    final adjacency = <String, List<String>>{};
    for (final edge in workflow.graph.edges) {
      adjacency.putIfAbsent(edge.source, () => []).add(edge.target);
    }
    final visiting = <String>{};
    final visited = <String>{};

    bool dfs(String nodeId) {
      if (visiting.contains(nodeId)) {
        return true;
      }
      if (visited.contains(nodeId)) {
        return false;
      }
      visiting.add(nodeId);
      for (final next in adjacency[nodeId] ?? const <String>[]) {
        if (dfs(next)) {
          return true;
        }
      }
      visiting.remove(nodeId);
      visited.add(nodeId);
      return false;
    }

    for (final node in workflow.graph.nodes) {
      if (dfs(node.id)) {
        return true;
      }
    }
    return false;
  }

  List<WorkflowGraphNode> _entryNodes(WorkflowDocument workflow) {
    final starts = [
      for (final node in workflow.graph.nodes)
        if (node.type == WorkflowNodeType.manualStart) node,
    ];
    // Prefer explicit Start node(s). Orphan/disconnected nodes must not run.
    if (starts.isNotEmpty) {
      return starts;
    }

    final incoming = <String>{};
    for (final edge in workflow.graph.edges) {
      incoming.add(edge.target);
    }
    return workflow.graph.nodes
        .where((node) => !incoming.contains(node.id))
        .toList();
  }

  Set<String> _reachableFrom(
    WorkflowDocument workflow,
    Iterable<String> roots,
  ) {
    final adjacency = <String, List<String>>{};
    for (final edge in workflow.graph.edges) {
      adjacency.putIfAbsent(edge.source, () => []).add(edge.target);
    }
    final reachable = <String>{};
    final queue = <String>[...roots];
    while (queue.isNotEmpty) {
      final id = queue.removeAt(0);
      if (!reachable.add(id)) {
        continue;
      }
      queue.addAll(adjacency[id] ?? const []);
    }
    return reachable;
  }
}
