import 'package:apidash/consts.dart';
import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/providers/workflow_providers.dart';
import 'package:apidash/workflow/providers/workflow_ui_providers.dart';
import 'package:apidash/workflow/utils/workflow_run_path.dart';
import 'package:apidash/workflow/widgets/workflow_add_node_sheet.dart';
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
    required this.start,
    required this.end,
  });

  final String sourceNodeId;
  final WorkflowEdgeHandle handle;
  final Offset start;
  final Offset end;
}

class WorkflowCanvas extends ConsumerStatefulWidget {
  const WorkflowCanvas({super.key});

  @override
  ConsumerState<WorkflowCanvas> createState() => _WorkflowCanvasState();
}

class _WorkflowCanvasState extends ConsumerState<WorkflowCanvas>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformController = TransformationController();
  final GlobalKey _sceneKey = GlobalKey();
  final Map<String, Offset> _dragOffsets = {};
  _ActiveWire? _activeWire;
  String? _hoverInputNodeId;
  int? _activeWirePointer;
  PointerRoute? _wirePointerRoute;
  late final AnimationController _flowController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  );

  static const double _inputHitRadius = 28;
  static const double _minStretchToAddNode = 48;

  @override
  void dispose() {
    _stopWirePointerTracking();
    _flowController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  void _scheduleFlowSync() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _syncFlowAnimation(
        runInProgress: ref.read(workflowRunInProgressProvider),
      );
    });
  }

  void _syncFlowAnimation({
    required bool runInProgress,
  }) {
    if (runInProgress) {
      if (!_flowController.isAnimating) {
        _flowController.repeat();
      }
    } else if (_flowController.isAnimating || _flowController.value != 0) {
      _flowController
        ..stop()
        ..value = 0;
    }
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
        start: _activeWire!.start,
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
        start: start,
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
      final stretched =
          (wire.end - wire.start).distance >= _minStretchToAddNode;
      if (stretched && mounted) {
        await showWorkflowAddNodeSheet(
          context,
          ref,
          connectFrom: WorkflowAddNodeConnectFrom(
            sourceNodeId: wire.sourceNodeId,
            sourceHandle: wire.handle,
            position: wire.end,
          ),
        );
      }
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
    final runInProgress = ref.watch(workflowRunInProgressProvider);
    final scheme = Theme.of(context).colorScheme;

    ref.listen<bool>(workflowRunInProgressProvider, (_, _) {
      _scheduleFlowSync();
    });
    ref.listen<Map<String, WorkflowNodeRunResult>>(
      workflowNodeRunResultsProvider,
      (_, _) {
        _scheduleFlowSync();
      },
    );
    _scheduleFlowSync();

    if (workflow == null) {
      return const Center(child: Text('Select or create a workflow'));
    }

    final hasRun = runResults.isNotEmpty;

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRect(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(
                      color: Color.alphaBlend(
                        scheme.surfaceContainerLowest.withValues(alpha: 0.85),
                        scheme.surface,
                      ),
                    ),
                    ListenableBuilder(
                      listenable: _transformController,
                      builder: (context, _) {
                        final matrix = _transformController.value;
                        return CustomPaint(
                          painter: _InfiniteWorkflowGridPainter(
                            scale: matrix.getMaxScaleOnAxis(),
                            tx: matrix.storage[12],
                            ty: matrix.storage[13],
                            gridColor: scheme.outline.withValues(
                              alpha: scheme.brightness == Brightness.dark
                                  ? 0.10
                                  : 0.08,
                            ),
                            dotColor: scheme.outline.withValues(
                              alpha: scheme.brightness == Brightness.dark
                                  ? 0.22
                                  : 0.16,
                            ),
                          ),
                        );
                      },
                    ),
                    InteractiveViewer(
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
                        child: AnimatedBuilder(
                          animation: _flowController,
                          builder: (context, _) {
                            return CustomPaint(
                              painter: _WorkflowEdgePainter(
                                workflow: workflow,
                                dragOffsets: _dragOffsets,
                                scheme: scheme,
                                brightness: Theme.of(context).brightness,
                                activeWire: _activeWire,
                                runResults: runResults,
                                flowPhase: runInProgress
                                    ? _flowController.value
                                    : 0,
                                animateFlow: runInProgress,
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
                                      child: AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 220),
                                        opacity: _nodeRunOpacity(
                                          hasRun: hasRun,
                                          runInProgress: runInProgress,
                                          result: runResults[node.id],
                                        ),
                                        child: _buildNode(
                                          node: node,
                                          workflow: workflow,
                                          selected:
                                              node.id == selectedNodeId,
                                          runResult: runResults[node.id],
                                          hoverInput:
                                              _hoverInputNodeId == node.id,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
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
            left: 88,
            bottom: kWorkflowRunBarFabClearance + 56,
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

  double _nodeRunOpacity({
    required bool hasRun,
    required bool runInProgress,
    required WorkflowNodeRunResult? result,
  }) {
    if (!hasRun || !runInProgress) {
      return 1;
    }
    if (result == null) {
      return 0.58;
    }
    return switch (result.status) {
      WorkflowNodeRunStatus.skipped => 0.58,
      WorkflowNodeRunStatus.pending => 0.82,
      _ => 1,
    };
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
    final branch = (runResult?.branch ?? '').toLowerCase();
    switch (node.type) {
      case WorkflowNodeType.manualStart:
        return WorkflowStartNodeCard(
          node: node,
          selected: selected,
          runResult: runResult,
          highlightNext: runResult?.status == WorkflowNodeRunStatus.success,
          onTap: () => _selectNode(node.id),
          onPlay: () => triggerWorkflowRun(context, ref),
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
          highlightSuccess: runResult?.status == WorkflowNodeRunStatus.success,
          highlightFailure: runResult?.status == WorkflowNodeRunStatus.failed,
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
          runResult: runResult,
          highlightInput: hoverInput,
          highlightBody: branch == 'each',
          highlightDone: branch == 'done',
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
          runResult: runResult,
          highlightInput: hoverInput,
          highlightThen: branch == 'true' || branch == 'then',
          highlightElse: branch == 'false' || branch == 'else',
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
          runResult: runResult,
          highlightInput: hoverInput,
          highlightNext: runResult?.status == WorkflowNodeRunStatus.success,
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

class _InfiniteWorkflowGridPainter extends CustomPainter {
  const _InfiniteWorkflowGridPainter({
    required this.scale,
    required this.tx,
    required this.ty,
    required this.gridColor,
    required this.dotColor,
  });

  final double scale;
  final double tx;
  final double ty;
  final Color gridColor;
  final Color dotColor;

  static const double _dotSpacing = 24;
  static const double _majorSpacing = 120;

  @override
  void paint(Canvas canvas, Size size) {
    if (scale <= 0) {
      return;
    }

    final spacingPx = _dotSpacing * scale;
    final majorPx = _majorSpacing * scale;
    if (spacingPx < 4) {
      // Zoomed out: only draw major lines to avoid dense noise.
      _paintLines(canvas, size, majorPx, tx, ty, gridColor);
      return;
    }

    _paintLines(canvas, size, majorPx, tx, ty, gridColor);
    _paintDots(canvas, size, spacingPx, majorPx, tx, ty, dotColor);
  }

  void _paintLines(
    Canvas canvas,
    Size size,
    double spacingPx,
    double tx,
    double ty,
    Color color,
  ) {
    if (spacingPx < 8) {
      return;
    }
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    var x = tx % spacingPx;
    if (x > 0) {
      x -= spacingPx;
    }
    for (; x <= size.width; x += spacingPx) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    var y = ty % spacingPx;
    if (y > 0) {
      y -= spacingPx;
    }
    for (; y <= size.height; y += spacingPx) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _paintDots(
    Canvas canvas,
    Size size,
    double spacingPx,
    double majorPx,
    double tx,
    double ty,
    Color color,
  ) {
    final paint = Paint()..color = color;
    var x = tx % spacingPx;
    if (x > 0) {
      x -= spacingPx;
    }
    for (; x <= size.width; x += spacingPx) {
      final onMajorX = _nearMultiple(x - tx, majorPx);
      var y = ty % spacingPx;
      if (y > 0) {
        y -= spacingPx;
      }
      for (; y <= size.height; y += spacingPx) {
        final onMajorY = _nearMultiple(y - ty, majorPx);
        if (onMajorX || onMajorY) {
          continue;
        }
        canvas.drawCircle(Offset(x, y), 1.1, paint);
      }
    }
  }

  bool _nearMultiple(double value, double step) {
    if (step <= 0) {
      return false;
    }
    final r = value % step;
    return r.abs() < 0.5 || (step - r).abs() < 0.5;
  }

  @override
  bool shouldRepaint(covariant _InfiniteWorkflowGridPainter oldDelegate) {
    return oldDelegate.scale != scale ||
        oldDelegate.tx != tx ||
        oldDelegate.ty != ty ||
        oldDelegate.gridColor != gridColor ||
        oldDelegate.dotColor != dotColor;
  }
}

class _WorkflowEdgePainter extends CustomPainter {
  _WorkflowEdgePainter({
    required this.workflow,
    required this.dragOffsets,
    required this.scheme,
    required this.brightness,
    required this.runResults,
    required this.flowPhase,
    required this.animateFlow,
    this.activeWire,
  });

  final WorkflowDocument workflow;
  final Map<String, Offset> dragOffsets;
  final ColorScheme scheme;
  final Brightness brightness;
  final Map<String, WorkflowNodeRunResult> runResults;
  final double flowPhase;
  final bool animateFlow;
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
    final hasRun = runResults.isNotEmpty;

    final idleEdges = <WorkflowGraphEdge>[];
    final pathEdges = <({WorkflowGraphEdge edge, WorkflowRunEdgeStyle style})>[];

    for (final edge in workflow.graph.edges) {
      var style = workflowEdgeRunStyle(edge: edge, results: runResults);
      // After Stop / finished run, freeze — no "in flight" dashes.
      if (!animateFlow &&
          (style == WorkflowRunEdgeStyle.active ||
              style == WorkflowRunEdgeStyle.upcoming)) {
        style = WorkflowRunEdgeStyle.idle;
      }
      if (style == WorkflowRunEdgeStyle.idle) {
        idleEdges.add(edge);
      } else {
        pathEdges.add((edge: edge, style: style));
      }
    }

    void drawGraphEdge(WorkflowGraphEdge edge, WorkflowRunEdgeStyle style) {
      final source = nodeById[edge.source];
      final target = nodeById[edge.target];
      if (source == null || target == null) {
        return;
      }

      final base = WorkflowNodeLayout.edgeColor(edge.sourceHandle, scheme);
      var color = workflowRunEdgeColor(
        style: style,
        base: base,
        scheme: scheme,
        brightness: brightness,
      );
      if (hasRun && style == WorkflowRunEdgeStyle.idle) {
        color = color.withValues(alpha: 0.35);
      }
      final strokeWidth = hasRun
          ? workflowRunEdgeStrokeWidth(style)
          : 2.0;
      final flowing = animateFlow &&
          (style == WorkflowRunEdgeStyle.active ||
              style == WorkflowRunEdgeStyle.upcoming);

      _drawEdge(
        canvas,
        start: _nodeOrigin(source) +
            WorkflowNodeLayout.portOffset(source, edge.sourceHandle),
        end: _nodeOrigin(target) +
            WorkflowNodeLayout.portOffset(target, WorkflowEdgeHandle.inPort),
        color: color,
        strokeWidth: strokeWidth,
        style: style,
        flowing: flowing,
      );
    }

    for (final edge in idleEdges) {
      drawGraphEdge(edge, WorkflowRunEdgeStyle.idle);
    }
    for (final entry in pathEdges) {
      drawGraphEdge(entry.edge, entry.style);
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
          strokeWidth: 2.5,
          style: WorkflowRunEdgeStyle.idle,
          flowing: false,
          forceDashed: true,
        );
      }
    }
  }

  void _drawEdge(
    Canvas canvas, {
    required Offset start,
    required Offset end,
    required Color color,
    double strokeWidth = 2,
    required WorkflowRunEdgeStyle style,
    bool flowing = false,
    bool forceDashed = false,
  }) {
    final path = WorkflowNodeLayout.edgePath(start, end);
    final isActive = style == WorkflowRunEdgeStyle.active;
    final isUpcoming = style == WorkflowRunEdgeStyle.upcoming;
    final dashed = forceDashed || flowing;

    if (flowing && isActive) {
      final glow = Paint()
        ..color = color.withValues(alpha: 0.12)
        ..strokeWidth = strokeWidth + 4
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawPath(path, glow);
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (dashed) {
      canvas.drawPath(
        _dashPath(
          path,
          dashArray: const [10.0, 8.0],
          phase: flowing ? flowPhase : 0,
        ),
        paint,
      );
    } else {
      canvas.drawPath(path, paint);
    }

    if (flowing) {
      _drawFlowParticles(
        canvas,
        path,
        color: color,
        particleCount: 1,
        radius: isActive ? 3.5 : 2.75,
      );
    }

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final radius = strokeWidth >= 3 ? 4.5 : 4.0;
    canvas.drawCircle(start, radius, dotPaint);
    canvas.drawCircle(end, radius, dotPaint);

    if (isActive || isUpcoming) {
      final ring = Paint()
        ..color = color.withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(end, radius + 2.5, ring);
    }
  }

  void _drawFlowParticles(
    Canvas canvas,
    Path path, {
    required Color color,
    required int particleCount,
    required double radius,
  }) {
    for (final metric in path.computeMetrics()) {
      final length = metric.length;
      if (length <= 0) {
        continue;
      }
      for (var i = 0; i < particleCount; i++) {
        final t = (flowPhase + i / particleCount) % 1.0;
        final tangent = metric.getTangentForOffset(t * length);
        if (tangent == null) {
          continue;
        }
        final pos = tangent.position;
        canvas.drawCircle(
          pos,
          radius * 1.8,
          Paint()
            ..color = color.withValues(alpha: 0.12)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
        );
        canvas.drawCircle(
          pos,
          radius,
          Paint()..color = color.withValues(alpha: 0.85),
        );
        canvas.drawCircle(
          pos,
          radius * 0.4,
          Paint()..color = Colors.white.withValues(alpha: 0.55),
        );
      }
    }
  }

  Path _dashPath(
    Path source, {
    required List<double> dashArray,
    double phase = 0,
  }) {
    final dashed = Path();
    final period = dashArray[0] + dashArray[1];
    final phaseOffset = period <= 0 ? 0.0 : (phase * period) % period;

    for (final metric in source.computeMetrics()) {
      var distance = -phaseOffset;
      var draw = true;
      while (distance < metric.length) {
        final length = dashArray[draw ? 0 : 1];
        final next = distance + length;
        if (draw) {
          final start = distance.clamp(0.0, metric.length);
          final end = next.clamp(0.0, metric.length);
          if (end > start) {
            dashed.addPath(
              metric.extractPath(start, end),
              Offset.zero,
            );
          }
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
        oldDelegate.brightness != brightness ||
        oldDelegate.runResults != runResults ||
        oldDelegate.flowPhase != flowPhase ||
        oldDelegate.animateFlow != animateFlow ||
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
