import 'package:apidash/consts.dart';
import 'package:apidash/sync/consts.dart';
import 'package:apidash/workflow/consts.dart';
import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/providers/workflow_providers.dart';
import 'package:apidash/workflow/providers/workflow_ui_providers.dart';
import 'package:apidash/workflow/utils/workflow_run_path.dart';
import 'package:apidash/workflow/widgets/workflow_add_node_sheet.dart';
import 'package:apidash/workflow/widgets/workflow_logic_node_editor.dart';
import 'package:apidash/workflow/widgets/workflow_node_layout.dart';
import 'package:apidash/workflow/widgets/workflow_request_node_card.dart';
import 'package:apidash/workflow/widgets/workflow_run_bar.dart';
import 'package:apidash/workflow/widgets/workflow_run_toast.dart';
import 'package:apidash/workflow/widgets/workflow_vyuh_adapter.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vyuh_node_flow/vyuh_node_flow.dart';

/// Vyuh editor host. Riverpod [WorkflowDocument] is SoT; Vyuh is ephemeral.
class WorkflowCanvas extends ConsumerStatefulWidget {
  const WorkflowCanvas({super.key});

  @override
  ConsumerState<WorkflowCanvas> createState() => _WorkflowCanvasState();
}

class _WorkflowCanvasState extends ConsumerState<WorkflowCanvas> {
  late final _controller = NodeFlowController<String, void>();
  String? _fingerprint;
  bool _writing = false;
  (String nodeId, String portId, Offset start)? _wire;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _load(WorkflowDocument doc) {
    final fp = WorkflowVyuhAdapter.structureFingerprint(doc);
    if (fp == _fingerprint) {
      return;
    }
    _fingerprint = fp;
    _writing = true;
    try {
      _controller.loadGraph(WorkflowVyuhAdapter.toGraph(doc));
    } finally {
      _writing = false;
    }
    _styleRunPath(doc);
  }

  void _styleRunPath(WorkflowDocument doc) {
    final results = ref.read(workflowNodeRunResultsProvider);
    final scheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final hasRun = results.isNotEmpty;
    final byId = {for (final e in doc.graph.edges) e.id: e};

    for (final connection in _controller.connections) {
      final edge = byId[connection.id];
      if (edge == null) {
        continue;
      }
      final base = WorkflowNodeLayout.edgeColor(edge.sourceHandle, scheme);
      if (!hasRun) {
        connection
          ..color = base
          ..strokeWidth = 2
          ..animated = false
          ..animationEffect = null;
        continue;
      }
      final style = workflowEdgeRunStyle(
        edge: edge,
        results: results,
        runInProgress: ref.read(workflowRunInProgressProvider),
      );
      final active = style == WorkflowRunEdgeStyle.active ||
          style == WorkflowRunEdgeStyle.upcoming;
      connection
        ..color = workflowRunEdgeColor(
          style: style,
          base: base.withValues(
            alpha: style == WorkflowRunEdgeStyle.idle ? 0.28 : 1,
          ),
          scheme: scheme,
          brightness: brightness,
        )
        ..strokeWidth = workflowRunEdgeStrokeWidth(style)
        ..animated = active
        ..animationEffect =
            active ? ConnectionEffects.flowingDashFast : null;
    }
  }

  Future<void> _afterWrite(Future<void> Function() write) async {
    if (_writing) {
      return;
    }
    await write();
    final doc = ref.read(activeWorkflowProvider);
    if (doc != null) {
      _fingerprint = WorkflowVyuhAdapter.structureFingerprint(doc);
    }
  }

  WorkflowGraphNode? _model(String id) {
    return ref
        .read(activeWorkflowProvider)
        ?.graph
        .nodes
        .where((n) => n.id == id)
        .firstOrNull;
  }

  Future<void> _deleteNode(WorkflowGraphNode node) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete node?'),
        content: Text(
          'Remove "${node.label.isEmpty ? node.type.name : node.label}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(kLabelCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(kLabelDelete),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      await ref.read(activeWorkflowProvider.notifier).deleteNode(node.id);
      ref.read(selectedWorkflowNodeIdProvider.notifier).state = null;
    }
  }

  NodeFlowTheme _theme(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final base = dark ? NodeFlowTheme.dark : NodeFlowTheme.light;
    return base.copyWith(
      backgroundColor: Color.alphaBlend(
        scheme.surfaceContainerLowest.withValues(alpha: 0.85),
        scheme.surface,
      ),
      gridTheme: base.gridTheme.copyWith(
        style: GridStyles.dots,
        color: scheme.outline.withValues(alpha: dark ? 0.18 : 0.12),
      ),
      // Cards draw their own chrome.
      nodeTheme: base.nodeTheme.copyWith(
        backgroundColor: Colors.transparent,
        selectedBackgroundColor: Colors.transparent,
        highlightBackgroundColor: Colors.transparent,
        borderColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        highlightBorderColor: Colors.transparent,
        borderWidth: 0,
        selectedBorderWidth: 0,
      ),
      connectionTheme: base.connectionTheme.copyWith(
        style: ConnectionStyles.bezier,
      ),
      temporaryConnectionTheme: base.temporaryConnectionTheme.copyWith(
        style: ConnectionStyles.bezier,
        color: scheme.primary.withValues(alpha: 0.85),
      ),
    );
  }

  Widget _card(WorkflowGraphNode node) {
    final selected = ref.watch(selectedWorkflowNodeIdProvider) == node.id;
    final runResult = ref.watch(workflowNodeRunResultsProvider)[node.id];
    void dup() => ref.read(activeWorkflowProvider.notifier).duplicateNode(node.id);
    void del() => _deleteNode(node);

    return switch (node.type) {
      WorkflowNodeType.manualStart => WorkflowStartNodeCard(
          node: node,
          selected: selected,
          runResult: runResult,
          onPlay: () => triggerWorkflowRun(context, ref),
        ),
      WorkflowNodeType.request => WorkflowRequestNodeCard(
          node: node,
          selected: selected,
          runResult: runResult,
          onDuplicate: dup,
          onDelete: del,
        ),
      WorkflowNodeType.loop => WorkflowLoopNodeCard(
          node: node,
          selected: selected,
          runResult: runResult,
          onDuplicate: dup,
          onDelete: del,
        ),
      WorkflowNodeType.condition => WorkflowConditionNodeCard(
          node: node,
          selected: selected,
          runResult: runResult,
          onDuplicate: dup,
          onDelete: del,
        ),
      WorkflowNodeType.delay => WorkflowDelayNodeCard(
          node: node,
          selected: selected,
          runResult: runResult,
          onDuplicate: dup,
          onDelete: del,
        ),
      WorkflowNodeType.sequence => WorkflowSequenceNodeCard(
          node: node,
          selected: selected,
          runResult: runResult,
          onDuplicate: dup,
          onDelete: del,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final workflow = ref.watch(activeWorkflowProvider);
    final runResults = ref.watch(workflowNodeRunResultsProvider);

    ref.listen(activeWorkflowProvider, (_, next) {
      if (next != null) {
        _load(next);
      }
    });
    ref.listen(workflowNodeRunResultsProvider, (_, _) {
      final doc = ref.read(activeWorkflowProvider);
      if (doc != null) {
        _styleRunPath(doc);
      }
    });

    if (workflow == null) {
      return const Center(child: Text('Select or create a workflow'));
    }
    if (_fingerprint !=
        WorkflowVyuhAdapter.structureFingerprint(workflow)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _load(workflow);
        }
      });
    }

    final showHint = workflow.description.isEmpty &&
        workflow.graph.nodes
                .where((n) => n.type != WorkflowNodeType.manualStart)
                .length <=
            1;

    return Stack(
      fit: StackFit.expand,
      children: [
        NodeFlowEditor<String, void>(
          controller: _controller,
          theme: _theme(context),
          labelBuilder: (context, connection, label, rect, onTap) {
            if (label.id != 'detach') {
              return Text(label.text);
            }
            final scheme = Theme.of(context).colorScheme;
            return Material(
              color: scheme.surfaceContainerHighest,
              elevation: 1,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => _afterWrite(
                  () => ref
                      .read(activeWorkflowProvider.notifier)
                      .disconnectEdge(connection.id),
                ),
                child: SizedBox(
                  width: rect.width.clamp(18, 24),
                  height: rect.height.clamp(18, 24),
                  child: Icon(
                    Icons.close,
                    size: 12,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          },
          nodeBuilder: (context, node) {
            final model = workflow.graph.nodes
                .where((n) => n.id == node.id)
                .firstOrNull;
            if (model == null) {
              return const SizedBox.shrink();
            }
            final result = runResults[model.id];
            final dim = runResults.isNotEmpty &&
                ref.watch(workflowRunInProgressProvider) &&
                (result == null ||
                    result.status == WorkflowNodeRunStatus.skipped);
            return Opacity(opacity: dim ? 0.58 : 1, child: _card(model));
          },
          events: NodeFlowEvents<String, void>(
            node: NodeEvents<String>(
              onTap: (n) =>
                  ref.read(selectedWorkflowNodeIdProvider.notifier).state =
                      n.id,
              onSelected: (n) =>
                  ref.read(selectedWorkflowNodeIdProvider.notifier).state =
                      n?.id,
              onDoubleTap: (n) {
                final model = _model(n.id);
                if (model == null) {
                  return;
                }
                ref.read(selectedWorkflowNodeIdProvider.notifier).state = n.id;
                openWorkflowNodeEditor(context, ref, node: model);
              },
              onDragStop: (n) => _afterWrite(
                () => ref
                    .read(activeWorkflowProvider.notifier)
                    .updateNodePosition(n.id, n.position.value),
              ),
            ),
            connection: ConnectionEvents<String, void>(
              onCreated: (c) {
                c.label = ConnectionLabel.center(text: '×', id: 'detach');
                _afterWrite(
                  () => ref.read(activeWorkflowProvider.notifier).connectNodes(
                        sourceId: c.sourceNodeId,
                        sourceHandle: workflowPortIdToHandle(c.sourcePortId),
                        targetId: c.targetNodeId,
                        edgeId: c.id,
                      ),
                );
              },
              onDeleted: (c) => _afterWrite(
                () => ref
                    .read(activeWorkflowProvider.notifier)
                    .disconnectEdge(c.id),
              ),
              onConnectStart: (node, port) {
                final y = port.offset.dy;
                final x = port.position == PortPosition.right
                    ? node.size.value.width
                    : 0.0;
                _wire = (node.id, port.id, node.position.value + Offset(x, y));
              },
              onConnectEnd: (target, _, pos) {
                final wire = _wire;
                _wire = null;
                if (target != null || wire == null) {
                  return;
                }
                final end = pos.offset;
                if ((end - wire.$3).distance < 48) {
                  return;
                }
                showWorkflowAddNodeSheet(
                  context,
                  ref,
                  connectFrom: WorkflowAddNodeConnectFrom(
                    sourceNodeId: wire.$1,
                    sourceHandle: workflowPortIdToHandle(wire.$2),
                    position: end,
                  ),
                );
              },
              onBeforeComplete: (ctx) {
                if (ctx.sourceNode.id == ctx.targetNode.id ||
                    ctx.targetNode.type ==
                        WorkflowNodeType.manualStart.name) {
                  return ConnectionValidationResult.deny();
                }
                return ConnectionValidationResult.allow();
              },
            ),
          ),
        ),
        const Positioned(right: 12, top: 12, child: WorkflowCanvasRunToast()),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 16,
          child: Center(child: WorkflowRunBar()),
        ),
        if (showHint)
          Positioned(
            left: 16,
            bottom: 16,
            child: _Hint(
              onHelp: () => launchUrl(Uri.parse(kLearnWorkflowsUrl)),
            ),
          ),
      ],
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.onHelp});

  final VoidCallback onHelp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 1,
      color: theme.colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.tips_and_updates_outlined,
              size: 18,
              color: theme.colorScheme.primary,
            ),
            kHSpacer8,
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: Text(
                'Drag a port to connect, or stretch into empty space to add a node.',
                style: theme.textTheme.bodySmall,
              ),
            ),
            IconButton(
              tooltip: kLabelWorkflowHelp,
              onPressed: onHelp,
              icon: const Icon(Icons.open_in_new, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
