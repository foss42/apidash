import 'package:apidash/consts.dart';
import 'package:apidash/workflow/engine/workflow_auto_arrange.dart';
import 'package:apidash/workflow/models/workflow_models.dart';

class WorkflowApplyException implements Exception {
  WorkflowApplyException(this.message);
  final String message;

  @override
  String toString() => message;
}

class WorkflowApplyResult {
  const WorkflowApplyResult({
    required this.document,
    required this.message,
  });

  final WorkflowDocument document;
  final String message;
}

/// Validates lean workflow JSON from Dashbot and prepares it for disk.
class WorkflowApplyService {
  const WorkflowApplyService();

  WorkflowApplyResult prepare(
    dynamic value, {
    required Iterable<String> existingNames,
  }) {
    final map = _asStringKeyedMap(value);
    if (map == null) {
      throw WorkflowApplyException('Workflow payload is missing or invalid.');
    }
    _normalizeEdgeKey(map);

    final document = WorkflowDocument.fromJson(map);
    final name = document.name.trim();
    if (name.isEmpty || name == kUntitled) {
      throw WorkflowApplyException('Workflow name is required.');
    }

    final nodes = document.graph.nodes;
    if (nodes.isEmpty) {
      throw WorkflowApplyException('Workflow has no nodes.');
    }

    final startNodes = nodes
        .where((n) => n.type == WorkflowNodeType.manualStart)
        .toList();
    if (startNodes.length != 1) {
      throw WorkflowApplyException(
        'Workflow must contain exactly one start node.',
      );
    }
    if (nodes.length < 2) {
      throw WorkflowApplyException(
        'Workflow must include at least one step after Start.',
      );
    }

    final nodeIds = {for (final n in nodes) n.id};
    if (nodeIds.contains('')) {
      throw WorkflowApplyException('Every node must have a non-empty id.');
    }
    if (nodeIds.length != nodes.length) {
      throw WorkflowApplyException('Node ids must be unique.');
    }

    for (final edge in document.graph.edges) {
      if (edge.id.isEmpty) {
        throw WorkflowApplyException(
          'Every connection must have a non-empty id.',
        );
      }
      if (!nodeIds.contains(edge.source) || !nodeIds.contains(edge.target)) {
        throw WorkflowApplyException(
          'Connection "${edge.id}" references unknown node(s).',
        );
      }
    }

    final uniqueName = _uniqueWorkflowName(name, existingNames);
    final connected = _ensureConnections(
      document.copyWith(id: uniqueName, name: uniqueName),
    );
    final laidOut = _autoArrange(connected);

    return WorkflowApplyResult(
      document: laidOut,
      message: 'Created workflow "$uniqueName"',
    );
  }

  void _normalizeEdgeKey(Map<String, dynamic> map) {
    final edges = map['edges'];
    final edgesEmpty = edges == null || (edges is List && edges.isEmpty);
    if (edgesEmpty && map['connections'] is List) {
      map['edges'] = map['connections'];
    }
  }

  Map<String, dynamic>? _asStringKeyedMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Map<String, dynamic>.from(value);
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  String _uniqueWorkflowName(String baseName, Iterable<String> existingNames) {
    final existing = existingNames.toSet();
    if (!existing.contains(baseName)) {
      return baseName;
    }
    var suffix = 2;
    while (existing.contains('$baseName ($suffix)')) {
      suffix += 1;
    }
    return '$baseName ($suffix)';
  }

  /// When Dashbot returns nodes without edges, wire a left-to-right chain.
  WorkflowDocument _ensureConnections(WorkflowDocument document) {
    if (document.graph.edges.isNotEmpty) {
      return document;
    }

    final start = document.graph.nodes.firstWhere(
      (n) => n.type == WorkflowNodeType.manualStart,
    );
    final rest = document.graph.nodes
        .where((n) => n.type != WorkflowNodeType.manualStart)
        .toList();
    final ordered = [start, ...rest];
    final edges = <WorkflowGraphEdge>[
      for (var i = 0; i < ordered.length - 1; i++)
        WorkflowGraphEdge(
          id: 'edge_${i + 1}',
          source: ordered[i].id,
          target: ordered[i + 1].id,
          sourceHandle: _defaultOutFor(ordered[i]),
        ),
    ];
    return document.copyWith(
      graph: document.graph.copyWith(edges: edges),
    );
  }

  WorkflowEdgeHandle _defaultOutFor(WorkflowGraphNode source) {
    return switch (source.type) {
      WorkflowNodeType.request => WorkflowEdgeHandle.success,
      WorkflowNodeType.condition => WorkflowEdgeHandle.then,
      _ => WorkflowEdgeHandle.next,
    };
  }

  WorkflowDocument _autoArrange(WorkflowDocument document) {
    final positions = computeWorkflowAutoArrangePositions(document.graph);
    if (positions.isEmpty) {
      return document;
    }
    final nodes = [
      for (final node in document.graph.nodes)
        if (positions[node.id] case final pos?)
          node.copyWith(
            position: WorkflowPosition(x: pos.dx, y: pos.dy),
          )
        else
          node,
    ];
    return document.copyWith(
      graph: document.graph.copyWith(nodes: nodes),
    );
  }
}
