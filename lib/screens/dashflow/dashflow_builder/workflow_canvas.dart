import 'package:apidash/screens/dashflow/dashflow_builder/grid.dart';
import 'package:apidash/screens/dashflow/dashflow_builder/node_connectors.dart';
import 'package:apidash/screens/dashflow/dashflow_builder/nodes.dart';
import 'package:flutter/material.dart';
import 'package:apidash/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkflowCanvas extends ConsumerStatefulWidget {
  const WorkflowCanvas({super.key});

  @override
  ConsumerState<WorkflowCanvas> createState() => _WorkflowCanvasState();
}

class _WorkflowCanvasState extends ConsumerState<WorkflowCanvas> {
  final TransformationController _controller = TransformationController();
  bool _needsRepaint = false;
  Offset _controlNodeOffset = const Offset(100, 100); // Initial position

  @override
  void initState() {
    super.initState();
    const canvasSize = 5000.0;
    _controller.value = Matrix4.identity()
      ..translate(-canvasSize / 2 + 100, -canvasSize / 2 + 100);
    _controller.addListener(_onTransformChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTransformChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTransformChanged() {
    if (!_needsRepaint) {
      _needsRepaint = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _needsRepaint = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final canvasSize = 5000.00;
    const double baseGridSize = 25;
    final nodes = ref.watch(workflowProvider);
    final hoveredNodeId = ref.watch(hoverNodeProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Dashflow 1")),
      body: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              colors: [
                Colors.black12,
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.center,
            ),
          ),
          child: Stack(children: [
            InteractiveViewer(
              transformationController: _controller,
              constrained: false,
              boundaryMargin: EdgeInsets.all(canvasSize / 2),
              minScale: 0.5,
              maxScale: 3,
              child: SizedBox(
                height: canvasSize,
                width: canvasSize,
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: ArrowPainter(
                        nodes: nodes,
                        canvasSize: canvasSize,
                        gridSize: baseGridSize,
                        hoveredNodeId:
                            hoveredNodeId, // Pass the hovered node ID
                      ),
                    ),
                    CustomPaint(
                      painter: GridPainter(
                        baseGridSize: baseGridSize,
                        canvasSize: canvasSize,
                        transformation: _controller.value,
                        viewportSize: mq,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: nodes.map((node) {
                          // Translate node positions to center of canvas
                          final centeredOffset = Offset(
                            node.offset.dx + canvasSize / 2,
                            node.offset.dy + canvasSize / 2,
                          );
                          return Positioned(
                            left: centeredOffset.dx,
                            top: centeredOffset.dy,
                            child: MouseRegion(
                              onEnter: (_) => ref
                                  .read(hoverNodeProvider.notifier)
                                  .state = node.id,
                              onExit: (_) => ref
                                  .read(hoverNodeProvider.notifier)
                                  .state = null,
                              child: DraggableNode(
                                gridSize: baseGridSize,
                                node: node,
                                onDrag: (id, offset) => ref
                                    .read(workflowProvider.notifier)
                                    .updateNodeOffset(id, offset),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Control node, always visible and draggable
            ControlNode(
              offset: _controlNodeOffset,
              onDrag: (newOffset) {
                setState(() {
                  _controlNodeOffset = newOffset;
                });
              },
              gridSize: baseGridSize,
            ),
          ]),
        ),
      ),
    );
  }
}
