import 'package:apidash/consts.dart';
import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/providers/workflow_providers.dart';
import 'package:apidash/workflow/providers/workflow_ui_providers.dart';
import 'package:apidash/workflow/widgets/workflow_logic_node_editor.dart';
import 'package:apidash/workflow/widgets/workflow_run_bar.dart';
import 'package:apidash/workflow/consts.dart';
import 'package:apidash/workflow/widgets/workflow_node_layout.dart';
import 'package:apidash/workflow/widgets/workflow_request_node_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class _ActiveWire {
  const _ActiveWire({
    required this.sourceNodeId,
    required this.handle,
    required this.end,
  });

  final String sourceNodeId;
  final WorkflowEdgeHandle handle;
  final Offset end;
}

class WorkflowCanvas extends ConsumerStatefulWidget {
  const WorkflowCanvas({super.key});

  @override
  ConsumerState<WorkflowCanvas> createState() => _WorkflowCanvasState();
}

class _WorkflowCanvasState extends ConsumerState<WorkflowCanvas> {
  final TransformationController _transformController = TransformationController();
  final GlobalKey _sceneKey = GlobalKey();
  final Map<String, Offset> _dragOffsets = {};
  _ActiveWire? _activeWire;
  String? _hoverInputNodeId;
  int? _activeWirePointer;
  PointerRoute? _wirePointerRoute;

  static const double _inputHitRadius = 28;

  @override
  void dispose() {
    _stopWirePointerTracking();
    _transformController.dispose();
    super.dispose();
  }

  Offset _globalToScene(Offset global) {
    final box = _sceneKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      return global;
    }
    return box.globalToLocal(global);
  }

  void _stopWirePointerTracking() {
    final route = _wirePointerRoute;
    final pointer = _activeWirePointer;
    if (route != null && pointer != null) {
      GestureBinding.instance.pointerRouter.removeRoute(pointer, route);
    }
    _wirePointerRoute = null;
    _activeWirePointer = null;
  }

  void _beginWirePointerTracking(PointerDownEvent event) {
    _stopWirePointerTracking();
    _activeWirePointer = event.pointer;

    void route(PointerEvent pointerEvent) {
      if (pointerEvent.pointer != _activeWirePointer) {
        return;
      }
      if (pointerEvent is PointerMoveEvent) {
        _updateWireAtGlobal(pointerEvent.position);
      } else if (pointerEvent is PointerUpEvent) {
        _finishWire();
        _stopWirePointerTracking();
      } else if (pointerEvent is PointerCancelEvent) {
        _cancelWire();
        _stopWirePointerTracking();
      }
    }

    _wirePointerRoute = route;
    GestureBinding.instance.pointerRouter.addRoute(event.pointer, route);
    _updateWireAtGlobal(event.position);
  }

  void _updateWireAtGlobal(Offset globalPosition) {
    if (_activeWire == null) {
      return;
    }
    final scenePoint = _globalToScene(globalPosition);
    final workflow = ref.read(activeWorkflowProvider);
    final hoverId = workflow == null
        ? null
        : _hitTestInputPort(scenePoint, workflow);
    setState(() {
      _activeWire = _ActiveWire(
        sourceNodeId: _activeWire!.sourceNodeId,
        handle: _activeWire!.handle,
        end: scenePoint,
      );
      _hoverInputNodeId = hoverId;
    });
  }

  Offset _nodeOrigin(WorkflowGraphNode node) {
    final drag = _dragOffsets[node.id] ?? Offset.zero;
    return Offset(node.position.x + drag.dx, node.position.y + drag.dy);
  }

  Offset _portScenePosition(WorkflowGraphNode node, WorkflowEdgeHandle handle) {
    return _nodeOrigin(node) + WorkflowNodeLayout.portOffset(node, handle);
  }

  String? _hitTestInputPort(Offset scenePoint, WorkflowDocument workflow) {
    String? closestId;
    var closestDistance = double.infinity;

    for (final node in workflow.graph.nodes) {
      if (node.type == WorkflowNodeType.manualStart) {
        continue;
      }
      final port = _portScenePosition(node, WorkflowEdgeHandle.inPort);
      final distance = (scenePoint - port).distance;
      if (distance <= _inputHitRadius && distance < closestDistance) {
        closestDistance = distance;
        closestId = node.id;
      }
    }
    return closestId;
  }

  void _onOutputPortPointerDown(
    PointerDownEvent event,
    String nodeId,
    WorkflowEdgeHandle handle,
  ) {
    final workflow = ref.read(activeWorkflowProvider);
    if (workflow == null) {
      return;
    }
    final node = workflow.graph.nodes
        .where((candidate) => candidate.id == nodeId)
        .firstOrNull;
    if (node == null) {
      return;
    }
    final start = _portScenePosition(node, handle);
    setState(() {
      _activeWire = _ActiveWire(
        sourceNodeId: nodeId,
        handle: handle,
        end: start,
      );
      _hoverInputNodeId = null;
    });
    _beginWirePointerTracking(event);
  }

  void _cancelWire() {
    setState(() {
      _activeWire = null;
      _hoverInputNodeId = null;
    });
  }

  Future<void> _finishWire() async {
    final wire = _activeWire;
    if (wire == null) {
      return;
    }

    final targetId = _hoverInputNodeId;
    setState(() {
      _activeWire = null;
      _hoverInputNodeId = null;
    });

    if (targetId == null || targetId == wire.sourceNodeId) {
      return;
    }

    await ref.read(activeWorkflowProvider.notifier).connectNodes(
          sourceId: wire.sourceNodeId,
          sourceHandle: wire.handle,
          targetId: targetId,
        );
  }

  void _selectNode(String nodeId) {
    ref.read(selectedWorkflowNodeIdProvider.notifier).state = nodeId;
  }

  Future<void> _confirmDeleteNode(WorkflowGraphNode node) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete node'),
        content: Text('Remove "${node.label}" from this workflow?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(kLabelCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(kTooltipDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    await ref.read(activeWorkflowProvider.notifier).deleteNode(node.id);
    ref.read(selectedWorkflowNodeIdProvider.notifier).state = null;
  }

  Future<void> _duplicateNode(WorkflowGraphNode node) async {
    final newId =
        await ref.read(activeWorkflowProvider.notifier).duplicateNode(node.id);
    if (newId != null) {
      ref.read(selectedWorkflowNodeIdProvider.notifier).state = newId;
    }
  }

  GestureDragUpdateCallback _nodeDragHandler(String nodeId) {
    return (details) {
      if (_activeWire != null) {
        return;
      }
      setState(() {
        final current = _dragOffsets[nodeId] ?? Offset.zero;
        _dragOffsets[nodeId] = current + details.delta;
      });
    };
  }

  GestureDragEndCallback _nodeDragEndHandler(WorkflowGraphNode node) {
    return (_) async {
      if (_activeWire != null) {
        return;
      }
      final drag = _dragOffsets.remove(node.id);
      if (drag == null) {
        return;
      }
      setState(() {});
      await ref.read(activeWorkflowProvider.notifier).updateNodePosition(
            node.id,
            Offset(
              node.position.x + drag.dx,
              node.position.y + drag.dy,
            ),
          );
    };
  }

  void Function(PointerDownEvent event, WorkflowEdgeHandle handle)
      _onOutputPortPointerDownHandler(String nodeId) {
    return (event, handle) =>
        _onOutputPortPointerDown(event, nodeId, handle);
  }

  List<Widget> _edgeDetachButtons(
    WorkflowDocument workflow,
    ColorScheme scheme,
  ) {
    final nodeById = {
      for (final node in workflow.graph.nodes) node.id: node,
    };
    const buttonSize = 24.0;

    return [
      for (final edge in workflow.graph.edges)
        if (_edgeEndpoints(edge, nodeById, scheme) case final endpoints?)
          Positioned(
            left: endpoints.midpoint.dx - buttonSize / 2,
            top: endpoints.midpoint.dy - buttonSize / 2,
            child: Tooltip(
              message: 'Detach connection',
              child: Material(
                elevation: 1,
                color: scheme.surfaceContainerHighest,
                shape: CircleBorder(
                  side: BorderSide(
                    color: endpoints.color.withValues(alpha: 0.6),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => ref
                      .read(activeWorkflowProvider.notifier)
                      .disconnectEdge(edge.id),
                  child: SizedBox(
                    width: buttonSize,
                    height: buttonSize,
                    child: Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
    ];
  }

  ({Offset midpoint, Color color})? _edgeEndpoints(
    WorkflowGraphEdge edge,
    Map<String, WorkflowGraphNode> nodeById,
    ColorScheme scheme,
  ) {
    final source = nodeById[edge.source];
    final target = nodeById[edge.target];
    if (source == null || target == null) {
      return null;
    }
    final start = _portScenePosition(source, edge.sourceHandle);
    final end = _portScenePosition(target, WorkflowEdgeHandle.inPort);
    return (
      midpoint: WorkflowNodeLayout.edgeMidpoint(start, end),
      color: WorkflowNodeLayout.edgeColor(edge.sourceHandle, scheme),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workflow = ref.watch(activeWorkflowProvider);
    final selectedNodeId = ref.watch(selectedWorkflowNodeIdProvider);
    final runResults = ref.watch(workflowNodeRunResultsProvider);
    final scheme = Theme.of(context).colorScheme;

    if (workflow == null) {
      return const Center(child: Text('Select or create a workflow'));
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRect(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: scheme.surface),
                  child: InteractiveViewer(
                    transformationController: _transformController,
                    constrained: false,
                    minScale: 0.25,
                    maxScale: 3,
                    boundaryMargin: const EdgeInsets.all(double.infinity),
                    clipBehavior: Clip.hardEdge,
                    panEnabled: _activeWire == null,
                    scaleEnabled: _activeWire == null,
                    child: SizedBox(
                      key: _sceneKey,
                      width: kWorkflowCanvasMinWidth,
                      height: kWorkflowCanvasMinHeight,
                      child: CustomPaint(
                        painter: _WorkflowCanvasBackgroundPainter(
                          color: scheme.surface,
                          dotColor: scheme.outline.withValues(alpha: 0.18),
                        ),
                        child: CustomPaint(
                          painter: _WorkflowEdgePainter(
                            workflow: workflow,
                            dragOffsets: _dragOffsets,
                            scheme: scheme,
                            activeWire: _activeWire,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              if (_activeWire == null)
                                ..._edgeDetachButtons(workflow, scheme),
                              for (final node in workflow.graph.nodes)
                                Positioned(
                                  left: node.position.x +
                                      (_dragOffsets[node.id]?.dx ?? 0),
                                  top: node.position.y +
                                      (_dragOffsets[node.id]?.dy ?? 0),
                                  child: _buildNode(
                                    node: node,
                                    workflow: workflow,
                                    selected: node.id == selectedNodeId,
                                    runResult: runResults[node.id],
                                    hoverInput: _hoverInputNodeId == node.id,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: WorkflowRunBar(),
        ),
        if (_showGettingStartedHint(workflow))
          Positioned(
            left: 16,
            bottom: 72,
            right: 200,
            child: _WorkflowGettingStartedHint(
              onShowHelp: () {
                launchUrl(Uri.parse(kLearnWorkflowsUrl));
              },
            ),
          ),
      ],
    );
  }

  bool _showGettingStartedHint(WorkflowDocument workflow) {
    if (workflow.description.isNotEmpty) {
      return false;
    }
    final nonStartNodes = workflow.graph.nodes
        .where((node) => node.type != WorkflowNodeType.manualStart)
        .length;
    return nonStartNodes <= 1;
  }

  Future<void> _openNodeEditor(WorkflowGraphNode node) async {
    _selectNode(node.id);
    await openWorkflowNodeEditor(context, ref, node: node);
  }

  Widget _buildNode({
    required WorkflowGraphNode node,
    required WorkflowDocument workflow,
    required bool selected,
    required WorkflowNodeRunResult? runResult,
    required bool hoverInput,
  }) {
    switch (node.type) {
      case WorkflowNodeType.manualStart:
        return WorkflowStartNodeCard(
          node: node,
          selected: selected,
          onTap: () => _selectNode(node.id),
          onDragPanUpdate: _nodeDragHandler(node.id),
          onDragPanEnd: _nodeDragEndHandler(node),
          onWirePointerDown: _onOutputPortPointerDownHandler(node.id),
        );
      case WorkflowNodeType.request:
        return WorkflowRequestNodeCard(
          node: node,
          selected: selected,
          runResult: runResult,
          highlightInput: hoverInput,
          onTap: () => _selectNode(node.id),
          onDoubleTap: () => _openNodeEditor(node),
          onDuplicate: () => _duplicateNode(node),
          onDelete: () => _confirmDeleteNode(node),
          onDragPanUpdate: _nodeDragHandler(node.id),
          onDragPanEnd: _nodeDragEndHandler(node),
          onWirePointerDown: _onOutputPortPointerDownHandler(node.id),
        );
      case WorkflowNodeType.loop:
        return WorkflowLoopNodeCard(
          node: node,
          selected: selected,
          highlightInput: hoverInput,
          onTap: () => _selectNode(node.id),
          onDoubleTap: () => _openNodeEditor(node),
          onDuplicate: () => _duplicateNode(node),
          onDelete: () => _confirmDeleteNode(node),
          onDragPanUpdate: _nodeDragHandler(node.id),
          onDragPanEnd: _nodeDragEndHandler(node),
          onWirePointerDown: _onOutputPortPointerDownHandler(node.id),
        );
      case WorkflowNodeType.condition:
        return WorkflowConditionNodeCard(
          node: node,
          selected: selected,
          highlightInput: hoverInput,
          onTap: () => _selectNode(node.id),
          onDoubleTap: () => _openNodeEditor(node),
          onDuplicate: () => _duplicateNode(node),
          onDelete: () => _confirmDeleteNode(node),
          onDragPanUpdate: _nodeDragHandler(node.id),
          onDragPanEnd: _nodeDragEndHandler(node),
          onWirePointerDown: _onOutputPortPointerDownHandler(node.id),
        );
      case WorkflowNodeType.delay:
        return WorkflowDelayNodeCard(
          node: node,
          selected: selected,
          highlightInput: hoverInput,
          onTap: () => _selectNode(node.id),
          onDoubleTap: () => _openNodeEditor(node),
          onDuplicate: () => _duplicateNode(node),
          onDelete: () => _confirmDeleteNode(node),
          onDragPanUpdate: _nodeDragHandler(node.id),
          onDragPanEnd: _nodeDragEndHandler(node),
          onWirePointerDown: _onOutputPortPointerDownHandler(node.id),
        );
    }
  }
}

class _WorkflowCanvasBackgroundPainter extends CustomPainter {
  const _WorkflowCanvasBackgroundPainter({
    required this.color,
    required this.dotColor,
  });

  final Color color;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = color);

    const spacing = 24.0;
    final dotPaint = Paint()..color = dotColor;
    for (var x = 0.0; x < size.width; x += spacing) {
      for (var y = 0.0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WorkflowCanvasBackgroundPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.dotColor != dotColor;
  }
}

class _WorkflowEdgePainter extends CustomPainter {
  _WorkflowEdgePainter({
    required this.workflow,
    required this.dragOffsets,
    required this.scheme,
    this.activeWire,
  });

  final WorkflowDocument workflow;
  final Map<String, Offset> dragOffsets;
  final ColorScheme scheme;
  final _ActiveWire? activeWire;

  Offset _nodeOrigin(WorkflowGraphNode node) {
    final drag = dragOffsets[node.id] ?? Offset.zero;
    return Offset(node.position.x + drag.dx, node.position.y + drag.dy);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final nodeById = {
      for (final node in workflow.graph.nodes) node.id: node,
    };

    for (final edge in workflow.graph.edges) {
      final source = nodeById[edge.source];
      final target = nodeById[edge.target];
      if (source == null || target == null) {
        continue;
      }

      final color = WorkflowNodeLayout.edgeColor(edge.sourceHandle, scheme);
      _drawEdge(
        canvas,
        start: _nodeOrigin(source) +
            WorkflowNodeLayout.portOffset(source, edge.sourceHandle),
        end: _nodeOrigin(target) +
            WorkflowNodeLayout.portOffset(target, WorkflowEdgeHandle.inPort),
        color: color,
      );
    }

    final wire = activeWire;
    if (wire != null) {
      final source = nodeById[wire.sourceNodeId];
      if (source != null) {
        final color = WorkflowNodeLayout.edgeColor(wire.handle, scheme);
        _drawEdge(
          canvas,
          start: _nodeOrigin(source) +
              WorkflowNodeLayout.portOffset(source, wire.handle),
          end: wire.end,
          color: color.withValues(alpha: 0.75),
          dashed: true,
        );
      }
    }
  }

  void _drawEdge(
    Canvas canvas, {
    required Offset start,
    required Offset end,
    required Color color,
    bool dashed = false,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = dashed ? 2.5 : 2
      ..style = PaintingStyle.stroke;

    final path = WorkflowNodeLayout.edgePath(start, end);

    if (dashed) {
      canvas.drawPath(
        _dashPath(path, dashArray: const [8, 6]),
        paint,
      );
    } else {
      canvas.drawPath(path, paint);
    }

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(start, 4, dotPaint);
    canvas.drawCircle(end, 4, dotPaint);
  }

  Path _dashPath(Path source, {required List<double> dashArray}) {
    final dashed = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      var draw = true;
      while (distance < metric.length) {
        final length = dashArray[draw ? 0 : 1];
        final next = distance + length;
        if (draw) {
          dashed.addPath(
            metric.extractPath(distance, next.clamp(0, metric.length)),
            Offset.zero,
          );
        }
        distance = next;
        draw = !draw;
      }
    }
    return dashed;
  }

  @override
  bool shouldRepaint(covariant _WorkflowEdgePainter oldDelegate) {
    return oldDelegate.workflow != workflow ||
        oldDelegate.dragOffsets != dragOffsets ||
        oldDelegate.scheme != scheme ||
        oldDelegate.activeWire?.end != activeWire?.end ||
        oldDelegate.activeWire?.sourceNodeId != activeWire?.sourceNodeId;
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      return null;
    }
    return iterator.current;
  }
}

class _WorkflowGettingStartedHint extends StatelessWidget {
  const _WorkflowGettingStartedHint({
    required this.onShowHelp,
  });

  final VoidCallback onShowHelp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 1,
      color: theme.colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('New to workflows?', style: theme.textTheme.titleSmall),
            const SizedBox(height: 6),
            Text(
              'Chain requests, branch on results, or repeat steps. Read the short guide to get started.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onShowHelp,
              child: const Text(kLabelWorkflowHelp),
            ),
          ],
        ),
      ),
    );
  }
}
