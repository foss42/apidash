import 'package:apidash/workflow/models/workflow_models.dart';

Map<String, String> upstreamExtractionVariables(
  WorkflowDocument workflow,
  String targetNodeId,
) {
  final predecessors = <String>{};
  final queue = <String>[targetNodeId];
  while (queue.isNotEmpty) {
    final current = queue.removeAt(0);
    for (final edge in workflow.graph.edges) {
      if (edge.target != current) {
        continue;
      }
      if (predecessors.add(edge.source)) {
        queue.add(edge.source);
      }
    }
  }

  final result = <String, String>{};
  for (final node in workflow.graph.nodes) {
    if (!predecessors.contains(node.id)) {
      continue;
    }
    if (node.type == WorkflowNodeType.request) {
      for (final extraction in node.extractions) {
        if (extraction.varName.isEmpty) {
          continue;
        }
        result.putIfAbsent(
          extraction.varName,
          () => '${node.label} · ${extraction.jsonPath}',
        );
      }
    } else if (node.type == WorkflowNodeType.loop) {
      final itemAs = node.loopItemAs?.trim();
      final itemField = node.loopItemField?.trim();
      if (itemAs != null &&
          itemAs.isNotEmpty &&
          itemField != null &&
          itemField.isNotEmpty) {
        result.putIfAbsent(
          itemAs,
          () => '${node.label} · $itemField',
        );
      }
    }
  }
  return result;
}
