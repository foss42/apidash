String formatWorkflowNodeError(
  String message, {
  required String nodeLabel,
  String? nodeId,
}) {
  final label = nodeLabel.trim().isNotEmpty
      ? nodeLabel.trim()
      : (nodeId != null && nodeId.trim().isNotEmpty ? nodeId.trim() : 'node');
  final trimmed = message.trim();
  final suffix = '[$label]';
  if (trimmed.isEmpty) {
    return suffix;
  }
  if (trimmed.endsWith(suffix)) {
    return trimmed;
  }
  return '$trimmed $suffix';
}

String formatWorkflowFailedStepsError(
  Iterable<({String nodeId, String label})> failedNodes,
) {
  final labels = <String>[];
  final seen = <String>{};
  for (final node in failedNodes) {
    final label = node.label.trim().isNotEmpty ? node.label.trim() : node.nodeId;
    if (label.isEmpty || !seen.add(label)) {
      continue;
    }
    labels.add(label);
  }
  if (labels.isEmpty) {
    return 'One or more steps failed';
  }
  return 'One or more steps failed [${labels.join(', ')}]';
}
