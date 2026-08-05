import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/consts.dart';
import 'package:flutter/material.dart';

class WorkflowNodeLayout {
  const WorkflowNodeLayout._();

  static Size sizeFor(WorkflowGraphNode node) {
    return switch (node.type) {
      WorkflowNodeType.manualStart => const Size(
          kWorkflowStartNodeWidth,
          kWorkflowStartNodeHeight,
        ),
      WorkflowNodeType.request => const Size(
          kWorkflowRequestNodeWidth,
          kWorkflowRequestNodeHeight,
        ),
      WorkflowNodeType.condition => const Size(
          kWorkflowConditionNodeWidth,
          kWorkflowConditionNodeHeight,
        ),
      WorkflowNodeType.loop => const Size(
          kWorkflowLoopNodeWidth,
          kWorkflowLoopNodeHeight,
        ),
      WorkflowNodeType.delay => const Size(
          kWorkflowDelayNodeWidth,
          kWorkflowDelayNodeHeight,
        ),
      WorkflowNodeType.sequence => const Size(
          kWorkflowSequenceNodeWidth,
          kWorkflowSequenceNodeHeight,
        ),
    };
  }

  static Color edgeColor(WorkflowEdgeHandle handle, ColorScheme scheme) {
    return switch (handle) {
      WorkflowEdgeHandle.success ||
      WorkflowEdgeHandle.then ||
      WorkflowEdgeHandle.loopDone =>
        Colors.green.shade600,
      WorkflowEdgeHandle.failure || WorkflowEdgeHandle.elseBranch =>
        scheme.error,
      WorkflowEdgeHandle.next => scheme.primary,
      _ => scheme.outline,
    };
  }
}
