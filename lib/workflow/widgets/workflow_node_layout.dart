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
    };
  }

  static Offset portOffset(WorkflowGraphNode node, WorkflowEdgeHandle handle) {
    final size = sizeFor(node);
    const wireYNudge = 3.0;
    return switch (node.type) {
      WorkflowNodeType.manualStart => switch (handle) {
          WorkflowEdgeHandle.next =>
            Offset(size.width, kStartPortNextY + wireYNudge),
          _ => Offset(0, kStartPortNextY + wireYNudge),
        },
      WorkflowNodeType.request => switch (handle) {
          WorkflowEdgeHandle.inPort =>
            Offset(0, kRequestPortSendY + wireYNudge),
          WorkflowEdgeHandle.success =>
            Offset(size.width, kRequestPortSuccessY + wireYNudge),
          WorkflowEdgeHandle.failure =>
            Offset(size.width, kRequestPortFailY + wireYNudge),
          _ => Offset(size.width, kRequestPortSuccessY + wireYNudge),
        },
      WorkflowNodeType.condition => switch (handle) {
          WorkflowEdgeHandle.inPort =>
            Offset(0, kConditionPortInY + wireYNudge),
          WorkflowEdgeHandle.then =>
            Offset(size.width, kConditionPortThenY + wireYNudge),
          WorkflowEdgeHandle.elseBranch =>
            Offset(size.width, kConditionPortElseY + wireYNudge),
          _ => Offset(size.width, kConditionPortThenY + wireYNudge),
        },
      WorkflowNodeType.loop => switch (handle) {
          WorkflowEdgeHandle.inPort => Offset(0, kLoopPortInY + wireYNudge),
          WorkflowEdgeHandle.next =>
            Offset(size.width, kLoopPortEachY + wireYNudge),
          WorkflowEdgeHandle.loopDone =>
            Offset(size.width, kLoopPortDoneY + wireYNudge),
          _ => Offset(size.width, kLoopPortEachY + wireYNudge),
        },
      WorkflowNodeType.delay => switch (handle) {
          WorkflowEdgeHandle.inPort => Offset(0, kDelayPortInY + wireYNudge),
          WorkflowEdgeHandle.next =>
            Offset(size.width, kDelayPortNextY + wireYNudge),
          _ => Offset(size.width, kDelayPortNextY + wireYNudge),
        },
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

  static Path edgePath(Offset start, Offset end) {
    return Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        start.dx + 80,
        start.dy,
        end.dx - 80,
        end.dy,
        end.dx,
        end.dy,
      );
  }

  static Offset edgeMidpoint(Offset start, Offset end) {
    const t = 0.5;
    final p0 = start;
    final p1 = Offset(start.dx + 80, start.dy);
    final p2 = Offset(end.dx - 80, end.dy);
    final p3 = end;
    final mt = 1 - t;
    return Offset(
      mt * mt * mt * p0.dx +
          3 * mt * mt * t * p1.dx +
          3 * mt * t * t * p2.dx +
          t * t * t * p3.dx,
      mt * mt * mt * p0.dy +
          3 * mt * mt * t * p1.dy +
          3 * mt * t * t * p2.dy +
          t * t * t * p3.dy,
    );
  }
}
