import 'dart:convert';

import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/models/workflow_request_codec.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

import 'git_diff_chrome.dart';
import 'git_diff_side_by_side_shell.dart';
import 'git_json_fallback_column.dart';
import 'git_request_visual_diff.dart';

WorkflowDocument? parseWorkflowDocument(Map<String, Object?>? json) {
  if (json == null) return null;
  try {
    return WorkflowDocument.fromJson(Map<String, dynamic>.from(json));
  } catch (_) {
    return null;
  }
}

class GitWorkflowVisualDiff extends StatelessWidget {
  const GitWorkflowVisualDiff({
    super.key,
    required this.original,
    required this.current,
    this.originalRaw,
    this.currentRaw,
  });

  final WorkflowDocument? original;
  final WorkflowDocument? current;
  final String? originalRaw;
  final String? currentRaw;

  @override
  Widget build(BuildContext context) {
    return GitDiffSideBySideShell(
      original: _WorkflowDiffColumn(
        model: original,
        otherModel: current,
        side: _DiffSide.original,
        raw: originalRaw,
        fieldKey: 'git-diff-workflow-original',
      ),
      current: _WorkflowDiffColumn(
        model: current,
        otherModel: original,
        side: _DiffSide.current,
        raw: currentRaw,
        fieldKey: 'git-diff-workflow-current',
      ),
    );
  }
}

enum _DiffSide { original, current }

class _WorkflowDiffSlots {
  const _WorkflowDiffSlots({
    required this.showName,
    required this.showDescription,
    required this.nodeIds,
    required this.edgeIds,
  });

  final bool showName;
  final bool showDescription;
  final List<String> nodeIds;
  final List<String> edgeIds;

  bool get hasAny =>
      showName || showDescription || nodeIds.isNotEmpty || edgeIds.isNotEmpty;

  factory _WorkflowDiffSlots.compare(
    WorkflowDocument? model,
    WorkflowDocument? otherModel,
  ) {
    final oneMissing = model == null || otherModel == null;

    bool changed(Object? a, Object? b) {
      if (oneMissing) {
        return _hasDiffValue(a) || _hasDiffValue(b);
      }
      return !_diffValueEquals(a, b);
    }

    final modelNodes = {
      for (final node in model?.graph.nodes ?? const <WorkflowGraphNode>[])
        node.id: node,
    };
    final otherNodes = {
      for (final node in otherModel?.graph.nodes ?? const <WorkflowGraphNode>[])
        node.id: node,
    };
    final nodeIds = <String>{
      ...modelNodes.keys,
      ...otherNodes.keys,
    }.where((id) {
      if (oneMissing) return true;
      return !_nodesEqual(modelNodes[id], otherNodes[id]);
    }).toList()
      ..sort();

    final modelEdges = {
      for (final edge in model?.graph.edges ?? const <WorkflowGraphEdge>[])
        edge.id: edge,
    };
    final otherEdges = {
      for (final edge in otherModel?.graph.edges ?? const <WorkflowGraphEdge>[])
        edge.id: edge,
    };
    final edgeIds = <String>{
      ...modelEdges.keys,
      ...otherEdges.keys,
    }.where((id) {
      if (oneMissing) return true;
      return !_edgesEqual(modelEdges[id], otherEdges[id]);
    }).toList()
      ..sort();

    return _WorkflowDiffSlots(
      showName: changed(model?.name, otherModel?.name),
      showDescription: changed(model?.description, otherModel?.description),
      nodeIds: nodeIds,
      edgeIds: edgeIds,
    );
  }
}

class _NodeDiffSlots {
  const _NodeDiffSlots({
    required this.showType,
    required this.showLabel,
    required this.showPosition,
    required this.showRequest,
    required this.showInheritFrom,
    required this.showExtractions,
    required this.showCondition,
    required this.showLoopItems,
    required this.showLoopMax,
    required this.showLoopMode,
    required this.showDelay,
  });

  final bool showType;
  final bool showLabel;
  final bool showPosition;
  final bool showRequest;
  final bool showInheritFrom;
  final bool showExtractions;
  final bool showCondition;
  final bool showLoopItems;
  final bool showLoopMax;
  final bool showLoopMode;
  final bool showDelay;

  bool get hasAny =>
      showType ||
      showLabel ||
      showPosition ||
      showRequest ||
      showInheritFrom ||
      showExtractions ||
      showCondition ||
      showLoopItems ||
      showLoopMax ||
      showLoopMode ||
      showDelay;

  factory _NodeDiffSlots.compare(
    WorkflowGraphNode? node,
    WorkflowGraphNode? other,
  ) {
    final oneMissing = node == null || other == null;
    final effectiveType = node?.type ?? other?.type;

    bool changed(Object? a, Object? b) {
      if (oneMissing) {
        return _hasDiffValue(a) || _hasDiffValue(b);
      }
      return !_diffValueEquals(a, b);
    }

    return _NodeDiffSlots(
      showType: changed(
        node == null ? null : _nodeTypeLabel(node.type),
        other == null ? null : _nodeTypeLabel(other.type),
      ),
      showLabel: changed(node?.label, other?.label),
      showPosition: oneMissing
          ? (node != null || other != null)
          : !_positionsEqual(node!.position, other!.position),
      showRequest: effectiveType == WorkflowNodeType.request &&
          (oneMissing
              ? ((node?.request?.isNotEmpty ?? false) ||
                  (other?.request?.isNotEmpty ?? false))
              : !_requestMapsEqual(node.request, other.request)),
      showInheritFrom: effectiveType == WorkflowNodeType.request &&
          (oneMissing
              ? (node?.inheritFrom != null || other?.inheritFrom != null)
              : !_inheritEquals(node.inheritFrom, other.inheritFrom)),
      showExtractions: effectiveType == WorkflowNodeType.request &&
          (oneMissing
              ? ((node?.extractions.isNotEmpty ?? false) ||
                  (other?.extractions.isNotEmpty ?? false))
              : !_extractionsEqual(node.extractions, other.extractions)),
      showCondition: effectiveType == WorkflowNodeType.condition &&
          changed(node?.conditionExpression, other?.conditionExpression),
      showLoopItems:
          effectiveType == WorkflowNodeType.loop &&
          changed(node?.loopExpression, other?.loopExpression),
      showLoopMax: effectiveType == WorkflowNodeType.loop &&
          changed(node?.loopMaxIterations, other?.loopMaxIterations),
      showLoopMode: effectiveType == WorkflowNodeType.loop &&
          changed(
            node?.loopMode.toJson(),
            other?.loopMode.toJson(),
          ),
      showDelay: effectiveType == WorkflowNodeType.delay &&
          changed(node?.delayMs, other?.delayMs),
    );
  }
}

class _WorkflowDiffColumn extends StatelessWidget {
  const _WorkflowDiffColumn({
    required this.model,
    required this.otherModel,
    required this.side,
    required this.raw,
    required this.fieldKey,
  });

  final WorkflowDocument? model;
  final WorkflowDocument? otherModel;
  final _DiffSide side;
  final String? raw;
  final String fieldKey;

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      if (raw != null && raw!.trim().isNotEmpty) {
        return GitJsonFallbackColumn(raw: raw, fieldKey: fieldKey);
      }
      if (otherModel != null) {
        return _WorkflowNoContentColumn(
          slots: _WorkflowDiffSlots.compare(null, otherModel),
        );
      }
      return const GitDiffEmptyState();
    }

    final slots = _WorkflowDiffSlots.compare(model, otherModel);
    if (!slots.hasAny) {
      return const GitDiffEmptyState();
    }

    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final nodesById = {for (final n in model!.graph.nodes) n.id: n};
    final otherNodesById = {
      for (final n in otherModel?.graph.nodes ?? const <WorkflowGraphNode>[])
        n.id: n,
    };
    final edgesById = {for (final e in model!.graph.edges) e.id: e};
    final otherEdgesById = {
      for (final e in otherModel?.graph.edges ?? const <WorkflowGraphEdge>[])
        e.id: e,
    };

    Widget field(String label, Widget child, {GitDiffChangeKind? change}) {
      return GitDiffField(label: label, change: change, child: child);
    }

    return SingleChildScrollView(
      padding: kP12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (slots.showName)
            field(
              'Name',
              model!.name.trim().isEmpty
                  ? const _GitDiffNoContentBox()
                  : Text(
                      model!.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              change: _fieldChangeKind(model!.name, otherModel?.name, side),
            ),
          if (slots.showDescription)
            field(
              'Description',
              model!.description.trim().isEmpty
                  ? const _GitDiffNoContentBox()
                  : Text(
                      model!.description,
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
              change: _fieldChangeKind(
                model!.description,
                otherModel?.description,
                side,
              ),
            ),
          for (final nodeId in slots.nodeIds)
            _NodeDiffCard(
              node: nodesById[nodeId],
              otherNode: otherNodesById[nodeId],
              side: side,
            ),
          for (final edgeId in slots.edgeIds)
            _EdgeDiffCard(
              edge: edgesById[edgeId],
              otherEdge: otherEdgesById[edgeId],
              nodesById: nodesById,
              side: side,
            ),
        ],
      ),
    );
  }
}

class _WorkflowNoContentColumn extends StatelessWidget {
  const _WorkflowNoContentColumn({
    required this.slots,
  });

  final _WorkflowDiffSlots slots;

  @override
  Widget build(BuildContext context) {
    if (!slots.hasAny) {
      return const GitDiffEmptyState();
    }

    return SingleChildScrollView(
      padding: kP12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (slots.showName) const GitDiffField(
            label: 'Name',
            child: _GitDiffNoContentBox(),
          ),
          if (slots.showDescription) const GitDiffField(
            label: 'Description',
            child: _GitDiffNoContentBox(),
          ),
          // Nodes/edges only render on the side where they exist.
        ],
      ),
    );
  }
}

class _NodeDiffCard extends StatelessWidget {
  const _NodeDiffCard({
    required this.node,
    required this.otherNode,
    required this.side,
  });

  final WorkflowGraphNode? node;
  final WorkflowGraphNode? otherNode;
  final _DiffSide side;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final slots = _NodeDiffSlots.compare(node, otherNode);
    final cardChange = _entityChangeKind(
      present: node != null,
      otherPresent: otherNode != null,
      modified: node != null && otherNode != null && !_nodesEqual(node, otherNode),
      side: side,
    );

    if (node == null) {
      // Added on the other side — don't show an empty placeholder here.
      return const SizedBox.shrink();
    }

    if (!slots.hasAny) {
      return const SizedBox.shrink();
    }

    final title = _nodeDisplayTitle(node!);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GitDiffHighlightBox(
        change: cardChange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
            kVSpacer8,
            if (slots.showType)
              GitDiffField(
                label: 'Type',
                change: _fieldChangeKind(
                  _nodeTypeLabel(node!.type),
                  otherNode == null ? null : _nodeTypeLabel(otherNode!.type),
                  side,
                ),
                child: Text(_nodeTypeLabel(node!.type)),
              ),
            if (slots.showLabel)
              GitDiffField(
                label: 'Label',
                change: _fieldChangeKind(node!.label, otherNode?.label, side),
                child: node!.label.trim().isEmpty
                    ? const _GitDiffNoContentBox()
                    : Text(node!.label),
              ),
            if (slots.showPosition)
              GitDiffField(
                label: 'Position',
                change: _fieldChangeKind(
                  _positionSignature(node!.position),
                  otherNode == null
                      ? null
                      : _positionSignature(otherNode!.position),
                  side,
                ),
                child: Text(
                  _positionLabel(node!.position),
                  style: kCodeStyle.copyWith(fontSize: 12),
                ),
              ),
            if (slots.showRequest)
              GitDiffField(
                label: 'Request',
                change: _requestChangeKind(node!.request, otherNode?.request, side),
                child: _RequestSummaryBlock(request: node!.request),
              ),
            if (slots.showInheritFrom)
              GitDiffField(
                label: 'Inherit',
                change: _fieldChangeKind(
                  _inheritSignature(node!.inheritFrom),
                  _inheritSignature(otherNode?.inheritFrom),
                  side,
                ),
                child: node!.inheritFrom == null
                    ? const _GitDiffNoContentBox()
                    : Text(
                        '${node!.inheritFrom!.collectionId}/'
                        '${node!.inheritFrom!.requestId}',
                        style: kCodeStyle.copyWith(fontSize: 12),
                      ),
              ),
            if (slots.showExtractions)
              GitDiffField(
                label: 'Extract',
                change: _extractionsChangeKind(
                  node!.extractions,
                  otherNode?.extractions ?? const [],
                  side,
                ),
                child: node!.extractions.isEmpty
                    ? const _GitDiffNoContentBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final extraction in node!.extractions)
                            GitDiffKvRow(
                              keyText: extraction.varName.isEmpty
                                  ? '—'
                                  : extraction.varName,
                              value: Text(
                                extraction.jsonPath.isEmpty
                                    ? '—'
                                    : extraction.jsonPath,
                                style: kCodeStyle.copyWith(fontSize: 12),
                              ),
                              change: _extractionRowChange(
                                extraction,
                                otherNode?.extractions ?? const [],
                                side,
                              ),
                            ),
                        ],
                      ),
              ),
            if (slots.showCondition)
              GitDiffField(
                label: 'Expr',
                change: _fieldChangeKind(
                  node!.conditionExpression,
                  otherNode?.conditionExpression,
                  side,
                ),
                child: (node!.conditionExpression ?? '').trim().isEmpty
                    ? const _GitDiffNoContentBox()
                    : Text(
                        node!.conditionExpression!,
                        style: kCodeStyle.copyWith(fontSize: 12),
                      ),
              ),
            if (slots.showLoopItems)
              GitDiffField(
                label: 'Items',
                change: _fieldChangeKind(
                  node!.loopExpression,
                  otherNode?.loopExpression,
                  side,
                ),
                child: (node!.loopExpression ?? '').trim().isEmpty
                    ? const _GitDiffNoContentBox()
                    : Text(
                        node!.loopExpression!,
                        style: kCodeStyle.copyWith(fontSize: 12),
                      ),
              ),
            if (slots.showLoopMax)
              GitDiffField(
                label: 'Max',
                change: _fieldChangeKind(
                  node!.loopMaxIterations,
                  otherNode?.loopMaxIterations,
                  side,
                ),
                child: Text('${node!.loopMaxIterations ?? '—'}'),
              ),
            if (slots.showLoopMode)
              GitDiffField(
                label: 'Mode',
                change: _fieldChangeKind(
                  node!.loopMode.toJson(),
                  otherNode?.loopMode.toJson(),
                  side,
                ),
                child: Text(node!.loopMode.toJson()),
              ),
            if (slots.showDelay)
              GitDiffField(
                label: 'Delay',
                change: _fieldChangeKind(node!.delayMs, otherNode?.delayMs, side),
                child: Text('${node!.delayMs ?? 0} ms'),
              ),
          ],
        ),
      ),
    );
  }
}

class _EdgeDiffCard extends StatelessWidget {
  const _EdgeDiffCard({
    required this.edge,
    required this.otherEdge,
    required this.nodesById,
    required this.side,
  });

  final WorkflowGraphEdge? edge;
  final WorkflowGraphEdge? otherEdge;
  final Map<String, WorkflowGraphNode> nodesById;
  final _DiffSide side;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cardChange = _entityChangeKind(
      present: edge != null,
      otherPresent: otherEdge != null,
      modified: edge != null && otherEdge != null && !_edgesEqual(edge, otherEdge),
      side: side,
    );

    if (edge == null) {
      // Added on the other side — don't show an empty placeholder here.
      return const SizedBox.shrink();
    }

    final fromLabel = _nodeRefLabel(nodesById[edge!.source], edge!.source);
    final toLabel = _nodeRefLabel(nodesById[edge!.target], edge!.target);
    final outLabel = _handleLabel(edge!.sourceHandle);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GitDiffField(
        label: 'Edge',
        change: cardChange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$fromLabel → $toLabel',
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (outLabel != null) ...[
              kVSpacer5,
              Text(
                'out: $outLabel',
                style: kCodeStyle.copyWith(fontSize: 12),
              ),
            ],
            if (edge!.label.trim().isNotEmpty) ...[
              kVSpacer5,
              Text(edge!.label, style: textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}

class _RequestSummaryBlock extends StatelessWidget {
  const _RequestSummaryBlock({required this.request});

  final Map<String, dynamic>? request;

  @override
  Widget build(BuildContext context) {
    if (request == null || request!.isEmpty) {
      return const _GitDiffNoContentBox();
    }

    try {
      final model = decodeWorkflowRequest(request!);
      final http = model.httpRequestModel;
      final lines = <String>[];
      if (model.apiType != APIType.rest) {
        lines.add(model.apiType.label);
      }
      if (model.apiType == APIType.rest && http != null) {
        lines.add(http.method.name.toUpperCase());
        if (http.url.trim().isNotEmpty) {
          lines.add(http.url.trim());
        }
      } else if (model.name.trim().isNotEmpty) {
        lines.add(model.name.trim());
      }
      if (lines.isEmpty) {
        lines.add(const JsonEncoder.withIndent('  ').convert(request));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                line,
                style: kCodeStyle.copyWith(fontSize: 12),
              ),
            ),
        ],
      );
    } catch (_) {
      return Text(
        const JsonEncoder.withIndent('  ').convert(request),
        style: kCodeStyle.copyWith(fontSize: 12),
      );
    }
  }
}

class _GitDiffNoContentBox extends StatelessWidget {
  const _GitDiffNoContentBox();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(minHeight: 36),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Text(
        '—',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
      ),
    );
  }
}

String _nodeDisplayTitle(WorkflowGraphNode node) {
  final label = node.label.trim();
  if (label.isNotEmpty) return label;
  return _nodeTypeLabel(node.type);
}

String _nodeTypeLabel(WorkflowNodeType type) => switch (type) {
      WorkflowNodeType.manualStart => 'Start',
      WorkflowNodeType.request => 'Request',
      WorkflowNodeType.condition => 'Condition',
      WorkflowNodeType.loop => 'Loop',
      WorkflowNodeType.delay => 'Delay',
    };

String _nodeRefLabel(WorkflowGraphNode? node, String fallbackId) {
  if (node == null) return fallbackId;
  final label = node.label.trim();
  if (label.isNotEmpty) return label;
  return _nodeTypeLabel(node.type);
}

String? _handleLabel(WorkflowEdgeHandle handle) {
  return switch (handle) {
    WorkflowEdgeHandle.success => null,
    WorkflowEdgeHandle.elseBranch => 'else',
    WorkflowEdgeHandle.inPort => 'in',
    WorkflowEdgeHandle.loopDone => 'done',
    _ => handle.name,
  };
}

bool _nodesEqual(WorkflowGraphNode? a, WorkflowGraphNode? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return false;
  if (a.type != b.type) return false;
  if (a.label != b.label) return false;
  if (!_positionsEqual(a.position, b.position)) return false;
  if (!_requestMapsEqual(a.request, b.request)) return false;
  if (!_inheritEquals(a.inheritFrom, b.inheritFrom)) return false;
  if (!_extractionsEqual(a.extractions, b.extractions)) return false;
  if (a.conditionExpression != b.conditionExpression) return false;
  if (a.loopExpression != b.loopExpression) return false;
  if (a.loopMaxIterations != b.loopMaxIterations) return false;
  if (a.loopMode != b.loopMode) return false;
  if (a.delayMs != b.delayMs) return false;
  return true;
}

bool _positionsEqual(WorkflowPosition? a, WorkflowPosition? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return a == b;
  return a.x == b.x && a.y == b.y;
}

String _positionSignature(WorkflowPosition position) =>
    '${position.x},${position.y}';

String _positionLabel(WorkflowPosition position) {
  final x = _formatCoord(position.x);
  final y = _formatCoord(position.y);
  return 'x: $x, y: $y';
}

String _formatCoord(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }
  return value.toStringAsFixed(1);
}

bool _edgesEqual(WorkflowGraphEdge? a, WorkflowGraphEdge? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return false;
  return a.source == b.source &&
      a.target == b.target &&
      a.sourceHandle == b.sourceHandle &&
      a.label == b.label;
}

bool _requestMapsEqual(Map<String, dynamic>? a, Map<String, dynamic>? b) {
  if (identical(a, b)) return true;
  if (a == null || a.isEmpty) return b == null || b.isEmpty;
  if (b == null || b.isEmpty) return false;
  return jsonEncode(_stableJson(a)) == jsonEncode(_stableJson(b));
}

bool _inheritEquals(WorkflowInheritFrom? a, WorkflowInheritFrom? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return a == b;
  return a.collectionId == b.collectionId && a.requestId == b.requestId;
}

String? _inheritSignature(WorkflowInheritFrom? value) {
  if (value == null) return null;
  return '${value.collectionId}/${value.requestId}';
}

bool _extractionsEqual(
  List<WorkflowExtraction> a,
  List<WorkflowExtraction> b,
) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i].varName != b[i].varName ||
        a[i].jsonPath != b[i].jsonPath ||
        a[i].source != b[i].source) {
      return false;
    }
  }
  return true;
}

Object? _stableJson(Object? value) {
  if (value is Map) {
    final keys = value.keys.map((k) => k.toString()).toList()..sort();
    return {
      for (final key in keys) key: _stableJson(value[key]),
    };
  }
  if (value is List) {
    return [for (final item in value) _stableJson(item)];
  }
  return value;
}

GitDiffChangeKind? _entityChangeKind({
  required bool present,
  required bool otherPresent,
  required bool modified,
  required _DiffSide side,
}) {
  if (!present && !otherPresent) return null;
  if (present && !otherPresent) {
    return side == _DiffSide.current
        ? GitDiffChangeKind.added
        : GitDiffChangeKind.removed;
  }
  if (!present && otherPresent) return null;
  return modified ? GitDiffChangeKind.modified : null;
}

GitDiffChangeKind? _fieldChangeKind(
  Object? value,
  Object? otherValue,
  _DiffSide side,
) {
  if (_diffValueEquals(value, otherValue)) return null;

  final hasValue = _hasDiffValue(value);
  final hasOtherValue = _hasDiffValue(otherValue);
  if (!hasValue && !hasOtherValue) return null;
  if (!hasOtherValue && hasValue) {
    return side == _DiffSide.current
        ? GitDiffChangeKind.added
        : GitDiffChangeKind.removed;
  }
  if (hasOtherValue && !hasValue) {
    return null;
  }
  return GitDiffChangeKind.modified;
}

GitDiffChangeKind? _requestChangeKind(
  Map<String, dynamic>? value,
  Map<String, dynamic>? otherValue,
  _DiffSide side,
) {
  if (_requestMapsEqual(value, otherValue)) return null;
  final hasValue = value != null && value.isNotEmpty;
  final hasOther = otherValue != null && otherValue.isNotEmpty;
  if (!hasOther && hasValue) {
    return side == _DiffSide.current
        ? GitDiffChangeKind.added
        : GitDiffChangeKind.removed;
  }
  if (hasOther && !hasValue) return null;
  return GitDiffChangeKind.modified;
}

GitDiffChangeKind? _extractionsChangeKind(
  List<WorkflowExtraction> value,
  List<WorkflowExtraction> otherValue,
  _DiffSide side,
) {
  if (_extractionsEqual(value, otherValue)) return null;
  if (otherValue.isEmpty && value.isNotEmpty) {
    return side == _DiffSide.current
        ? GitDiffChangeKind.added
        : GitDiffChangeKind.removed;
  }
  if (otherValue.isNotEmpty && value.isEmpty) return null;
  return GitDiffChangeKind.modified;
}

GitDiffChangeKind? _extractionRowChange(
  WorkflowExtraction extraction,
  List<WorkflowExtraction> other,
  _DiffSide side,
) {
  WorkflowExtraction? match;
  for (final candidate in other) {
    if (candidate.varName == extraction.varName) {
      match = candidate;
      break;
    }
  }
  if (match == null) {
    return side == _DiffSide.current
        ? GitDiffChangeKind.added
        : GitDiffChangeKind.removed;
  }
  if (match.jsonPath == extraction.jsonPath &&
      match.source == extraction.source) {
    return null;
  }
  return GitDiffChangeKind.modified;
}

bool _diffValueEquals(Object? a, Object? b) {
  if (a is String || b is String) {
    return (a?.toString() ?? '') == (b?.toString() ?? '');
  }
  return a == b;
}

bool _hasDiffValue(Object? value) {
  if (value == null) return false;
  if (value is String) return value.trim().isNotEmpty;
  if (value is Iterable) return value.isNotEmpty;
  if (value is Map) return value.isNotEmpty;
  return true;
}
