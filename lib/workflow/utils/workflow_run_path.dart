import 'package:apidash/utils/utils.dart';
import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:flutter/material.dart';

/// Visual state of a connection during / after a run (matches inspector chip theme).
enum WorkflowRunEdgeStyle {
  idle,
  upcoming,
  active,
  completed,
  failed,
}

/// Whether [source] completed in a way that fires [handle].
bool workflowSourceFiredHandle(
  WorkflowNodeRunResult source,
  WorkflowEdgeHandle handle,
) {
  final branch = (source.branch ?? '').toLowerCase();
  switch (source.nodeType) {
    case WorkflowNodeType.condition:
      if (branch == 'true' || branch == 'then') {
        return handle == WorkflowEdgeHandle.then;
      }
      if (branch == 'false' || branch == 'else') {
        return handle == WorkflowEdgeHandle.elseBranch;
      }
      return false;
    case WorkflowNodeType.request:
      if (source.status == WorkflowNodeRunStatus.failed) {
        return handle == WorkflowEdgeHandle.failure;
      }
      if (source.status == WorkflowNodeRunStatus.success) {
        return handle == WorkflowEdgeHandle.success ||
            handle == WorkflowEdgeHandle.next;
      }
      return false;
    case WorkflowNodeType.loop:
      if (branch == 'done') {
        return handle == WorkflowEdgeHandle.loopDone;
      }
      if (branch == 'each') {
        return handle == WorkflowEdgeHandle.next;
      }
      return handle == WorkflowEdgeHandle.loopDone ||
          handle == WorkflowEdgeHandle.next;
    case WorkflowNodeType.manualStart:
    case WorkflowNodeType.delay:
    case WorkflowNodeType.sequence:
    case null:
      if (source.status == WorkflowNodeRunStatus.running) {
        return false;
      }
      if (source.status == WorkflowNodeRunStatus.failed) {
        return false;
      }
      return handle == WorkflowEdgeHandle.next ||
          handle == WorkflowEdgeHandle.success;
  }
}

String? workflowRunResultKeyForNode({
  required String nodeId,
  required Map<String, WorkflowNodeRunResult> results,
  required List<String> stepOrder,
}) {
  String? found;
  for (final key in stepOrder) {
    final result = results[key];
    if (result != null && result.nodeId == nodeId) {
      found = key;
    }
  }
  if (found != null) {
    return found;
  }
  if (results[nodeId] != null) {
    return nodeId;
  }
  return null;
}

WorkflowRunEdgeStyle workflowEdgeRunStyle({
  required WorkflowGraphEdge edge,
  required Map<String, WorkflowNodeRunResult> results,
  bool runInProgress = false,
}) {
  final source = results[edge.source];
  if (source == null) {
    return WorkflowRunEdgeStyle.idle;
  }
  if (!workflowSourceFiredHandle(source, edge.sourceHandle)) {
    return WorkflowRunEdgeStyle.idle;
  }

  final target = results[edge.target];
  if (target == null) {
    // Live next hop only while running. After the run, never-reached /
    // newly wired nodes stay idle (not "upcoming"/animated).
    return runInProgress
        ? WorkflowRunEdgeStyle.upcoming
        : WorkflowRunEdgeStyle.idle;
  }
  return switch (target.status) {
    WorkflowNodeRunStatus.running => WorkflowRunEdgeStyle.active,
    WorkflowNodeRunStatus.failed => WorkflowRunEdgeStyle.failed,
    WorkflowNodeRunStatus.success => WorkflowRunEdgeStyle.completed,
    WorkflowNodeRunStatus.pending => runInProgress
        ? WorkflowRunEdgeStyle.upcoming
        : WorkflowRunEdgeStyle.idle,
    WorkflowNodeRunStatus.skipped => WorkflowRunEdgeStyle.idle,
  };
}

Color workflowRunEdgeColor({
  required WorkflowRunEdgeStyle style,
  required Color base,
  required ColorScheme scheme,
  required Brightness brightness,
}) {
  // Canvas greens need higher chroma than status-code chips (toDark washes them out).
  final success = brightness == Brightness.dark
      ? Colors.green.shade400
      : Colors.green.shade600;
  return switch (style) {
    WorkflowRunEdgeStyle.idle => base,
    WorkflowRunEdgeStyle.upcoming => scheme.primary.withValues(alpha: 0.42),
    WorkflowRunEdgeStyle.active => scheme.primary.withValues(alpha: 0.9),
    WorkflowRunEdgeStyle.completed => success,
    WorkflowRunEdgeStyle.failed => scheme.error,
  };
}

double workflowRunEdgeStrokeWidth(WorkflowRunEdgeStyle style) {
  return switch (style) {
    WorkflowRunEdgeStyle.active => 2.75,
    WorkflowRunEdgeStyle.upcoming => 2.35,
    WorkflowRunEdgeStyle.completed || WorkflowRunEdgeStyle.failed => 2.5,
    WorkflowRunEdgeStyle.idle => 2,
  };
}

/// Node border color aligned with run inspector chips.
Color workflowNodeRunBorderColor({
  required WorkflowNodeRunResult? result,
  required bool selected,
  required ColorScheme scheme,
  required Brightness brightness,
  Color? selectedColor,
  Color? idleColor,
}) {
  final success = getResponseStatusCodeColor(200, brightness: brightness);
  return switch (result?.status) {
    WorkflowNodeRunStatus.running => scheme.primary,
    WorkflowNodeRunStatus.success => success,
    WorkflowNodeRunStatus.failed => scheme.error,
    _ => selected
        ? (selectedColor ?? scheme.primary)
        : (idleColor ?? scheme.outlineVariant),
  };
}
