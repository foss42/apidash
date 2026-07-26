import 'package:apidash/consts.dart';
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
    final laidOut = _ensureLayout(
      document.copyWith(id: uniqueName, name: uniqueName),
    );

    return WorkflowApplyResult(
      document: laidOut,
      message: 'Created workflow "$uniqueName"',
    );
  }

  Map<String, dynamic>? _asStringKeyedMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
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

  WorkflowDocument _ensureLayout(WorkflowDocument document) {
    final nodes = document.graph.nodes;
    final needsLayout = nodes.every(
      (n) => n.position.x == 0 && n.position.y == 0,
    );
    if (!needsLayout) {
      return document;
    }

    final start = nodes.where((n) => n.type == WorkflowNodeType.manualStart);
    final others = nodes.where((n) => n.type != WorkflowNodeType.manualStart);
    final ordered = [...start, ...others];
    final laidOut = <WorkflowGraphNode>[
      for (var i = 0; i < ordered.length; i++)
        ordered[i].copyWith(
          position: WorkflowPosition(x: 80 + i * 240, y: 180),
        ),
    ];
    return document.copyWith(
      graph: document.graph.copyWith(nodes: laidOut),
    );
  }
}
