import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'models/workflow_node_model.dart';
import 'workflow_node.dart';
import 'workflow_providers.dart';
import 'models/workflow_model.dart';
import 'grid_painter.dart';
import 'connection_painter.dart';

class WorkflowCanvas extends ConsumerStatefulWidget {
  final String? workflowId;

  const WorkflowCanvas({
    super.key,
    required this.workflowId,
  });

  @override
  ConsumerState<WorkflowCanvas> createState() => _WorkflowCanvasState();
}

class _WorkflowCanvasState extends ConsumerState<WorkflowCanvas> {
  final TransformationController _transformationController =
      TransformationController();
  double _scale = 1.0;

  final GlobalKey _canvasKey = GlobalKey();

  String? _sourceNodeId;
  Offset? _connectionStart;
  Offset? _connectionEnd;

  String? _draggedNodeId;
  Offset? _lastDragPosition;

  @override
  void initState() {
    super.initState();
    _transformationController.value = Matrix4.identity()..translate(50.0, 50.0);
  }

  void _handleApiNodeAdded(WorkflowNodeModel newNode, Offset position) {
    try {
      if (widget.workflowId == null) return;

      final RenderBox? renderBox =
          _canvasKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final viewportCenter = _transformationController.toScene(
        Offset(
          renderBox.size.width / 2,
          renderBox.size.height / 2,
        ),
      );

      final finalPosition = position.dx == 0 && position.dy == 0
          ? Offset(viewportCenter.dx - 80,
              viewportCenter.dy - 40) // Center with offset
          : _transformationController.toScene(position);

      final node = newNode.copyWith(
        id: const Uuid().v4(),
        requestId: widget.workflowId!,
        position: finalPosition,
      );

      ref.read(workflowsNotifierProvider.notifier).addNode(
            widget.workflowId!,
            node,
          );
    } catch (e) {
      debugPrint('Error adding node: $e');
    }
  }

  void _startConnection(String nodeId, Offset position) {
    setState(() {
      _sourceNodeId = nodeId;
      _connectionStart = position;
      _connectionEnd = position;
    });
  }

  void _updateConnection(Offset position) {
    if (_sourceNodeId == null) return;

    setState(() {
      _connectionEnd = position;
    });
  }

  void _finishConnection(String? targetNodeId) {
    if (_sourceNodeId != null &&
        targetNodeId != null &&
        _sourceNodeId != targetNodeId) {
      ref.read(workflowsNotifierProvider.notifier).createConnection(
            widget.workflowId!,
            _sourceNodeId!,
            targetNodeId,
          );
    }

    setState(() {
      _sourceNodeId = null;
      _connectionStart = null;
      _connectionEnd = null;
    });
  }

  Offset? _dragOffsetFromNodeTopLeft;

  void _startNodeDrag(String nodeId, Offset globalPosition) {
    final scenePosition = _transformationController.toScene(globalPosition);

    final workflows = ref.read(workflowsNotifierProvider);
    final currentWorkflow = workflows.firstWhere(
      (workflow) => workflow.id == widget.workflowId,
      orElse: () => throw Exception('Workflow not found'),
    );

    final node = currentWorkflow.nodes.firstWhere(
      (node) => node.id == nodeId,
      orElse: () => throw Exception('Node not found'),
    );

    final offsetFromTopLeft = scenePosition - node.position;

    setState(() {
      _draggedNodeId = nodeId;
      _lastDragPosition = scenePosition;
      _dragOffsetFromNodeTopLeft = offsetFromTopLeft;
    });
  }

  void _updateNodeDrag(Offset globalPosition) {
    if (_draggedNodeId == null || _dragOffsetFromNodeTopLeft == null) return;

    final scenePosition = _transformationController.toScene(globalPosition);

    final newTopLeft = scenePosition - _dragOffsetFromNodeTopLeft!;

    ref.read(workflowsNotifierProvider.notifier).updateNodePosition(
          widget.workflowId!,
          _draggedNodeId!,
          newTopLeft,
        );

    setState(() {
      _lastDragPosition = scenePosition;
    });
  }

  void _finishNodeDrag() {
    setState(() {
      _draggedNodeId = null;
      _lastDragPosition = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final workflowId = widget.workflowId;
    if (workflowId == null) {
      return const Center(child: Text('No workflow selected'));
    }

    final currentWorkflow = ref.watch(
      activeWorkflowProvider,
    );

    if (currentWorkflow == null) {
      return const Center(child: Text('Workflow not found'));
    }

    final isConnectionMode = ref.watch(connectionModeProvider);

    final currentConnections = currentWorkflow.connections;

    final nodePositions = <String, Offset>{};
    for (final node in currentWorkflow.nodes) {
      nodePositions[node.id] = node.position;
    }

    final workflowExecutionState = ref.watch(workflowExecutionStateProvider);
    final runningNodeIds = workflowExecutionState.currentNodeId != null
        ? [workflowExecutionState.currentNodeId!]
        : <String>[];
    final completedNodeIds = workflowExecutionState.executedNodeIds.toList();

    return Stack(
      key: _canvasKey,
      children: [
        Container(
          color: const Color(0xFF121212),
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
            painter: GridPainter(
              gridColor: Colors.grey.shade800.withOpacity(0.3),
              gridWidth: 1.0,
              gridSpacing: 40 * _scale,
            ),
          ),
        ),

        InteractiveViewer(
          transformationController: _transformationController,
          minScale: 0.3,
          maxScale: 2.0,
          constrained: false,
          onInteractionUpdate: (details) {
            setState(() {
              _scale = _transformationController.value.getMaxScaleOnAxis();
            });
          },
          child: SizedBox(
            width: 3000,
            height: 2000,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTapDown: (details) {
                      if (isConnectionMode && _sourceNodeId != null) {
                        final scenePosition = _transformationController
                            .toScene(details.localPosition);
                        
                        final hitNodeId = _hitTestNodes(
                            scenePosition, currentWorkflow.nodes);
                            
                        if (hitNodeId == null) {
                          setState(() {
                            _sourceNodeId = null;
                            _connectionStart = null;
                            _connectionEnd = null;
                          });
                        }
                      }
                      
                      if (!isConnectionMode) {
                        ref.read(selectedNodeIdProvider.notifier).state = null;
                      }
                    },
                    onPanUpdate: (details) {
                      if (isConnectionMode && _sourceNodeId != null) {
                        _updateConnection(_transformationController
                            .toScene(details.localPosition));
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),

                CustomPaint(
                  painter: ConnectionPainter(
                    connections: currentConnections,
                    nodes: currentWorkflow.nodes,
                    nodePositions: nodePositions,
                    tempConnectionStart: _connectionStart,
                    tempConnectionEnd: _connectionEnd,
                    runningNodeIds: runningNodeIds,
                    completedNodeIds: completedNodeIds,
                  ),
                  size: const Size(3000, 2000),
                ),

                ...currentWorkflow.nodes.map(
                  (node) {
                    return Positioned(
                      left: node.position.dx,
                      top: node.position.dy,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.grab,
                        child: GestureDetector(
                          onTap: () {
                            ref.read(selectedNodeIdProvider.notifier).state =
                                node.id;

                            if (isConnectionMode) {
                              if (_sourceNodeId == null) {
                                final nodeCenter = Offset(
                                  node.position.dx + 80, // Half of node width
                                  node.position.dy + 40, // Half of node height
                                );
                                _startConnection(node.id, nodeCenter);
                              } else if (_sourceNodeId != node.id) {
                                _finishConnection(node.id);
                              } else {
                                setState(() {
                                  _sourceNodeId = null;
                                  _connectionStart = null;
                                  _connectionEnd = null;
                                });
                              }
                            }
                          },
                          onPanStart: (details) {
                            if (!isConnectionMode) {
                              _startNodeDrag(node.id, details.globalPosition);
                            }
                          },
                          onPanUpdate: (details) {
                            if (!isConnectionMode) {
                              _updateNodeDrag(details.globalPosition);
                            } else if (_sourceNodeId == node.id) {
                              final localPosition = _transformationController
                                  .toScene(details.localPosition);
                              _updateConnection(localPosition);
                            }
                          },
                          onPanEnd: (details) {
                            if (!isConnectionMode) {
                              _finishNodeDrag();
                            } else if (_sourceNodeId == node.id) {
                              setState(() {
                                _sourceNodeId = null;
                                _connectionStart = null;
                                _connectionEnd = null;
                              });
                            }
                          },
                          child: WorkflowNode(
                            node: node,
                            isSelected: node.id == ref.watch(selectedNodeIdProvider),
                            isRunning:
                                workflowExecutionState.currentNodeId == node.id,
                            isCompleted:
                                workflowExecutionState.executedNodeIds.contains(node.id),
                            hasError: workflowExecutionState.executionResults[node.id]
                                    ?['status'] ==
                                'error',
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),

                Positioned.fill(
                  child: DragTarget<WorkflowNodeModel>(
                    builder: (context, candidateData, rejectedData) {
                      return const SizedBox.expand();
                    },
                    onWillAccept: (data) => true,
                    onAccept: (data) {
                      final RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                      final localPosition = renderBox.globalToLocal(Offset.zero);
                      final position = _transformationController.toScene(localPosition);
                      
                      _handleApiNodeAdded(data, position);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          left: 16,
          bottom: 16,
          child: _buildCanvasControls(),
        ),

        Positioned(
          top: 16,
          right: 16,
          child: _buildCanvasInfo(currentWorkflow),
        ),
      ],
    );
  }

  Widget _buildCanvasControls() {
    return Card(
      color: Colors.black.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                _transformationController.value = Matrix4.identity()
                  ..translate(50.0, 50.0);
                setState(() {
                  _scale = 1.0;
                });
              },
              tooltip: 'Reset View',
            ),
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.white),
              onPressed: () {
                final scale =
                    _transformationController.value.getMaxScaleOnAxis();
                if (scale > 0.5) {
                  _transformationController.value.scale(0.8, 0.8, 0.8);
                  setState(() {
                    _scale =
                        _transformationController.value.getMaxScaleOnAxis();
                  });
                }
              },
              tooltip: 'Zoom Out',
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${(_scale * 100).toInt()}%',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                final scale =
                    _transformationController.value.getMaxScaleOnAxis();
                if (scale < 2.0) {
                  _transformationController.value.scale(1.25, 1.25, 1.25);
                  setState(() {
                    _scale =
                        _transformationController.value.getMaxScaleOnAxis();
                  });
                }
              },
              tooltip: 'Zoom In',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCanvasInfo(WorkflowModel workflow) {
    return Card(
      color: Colors.black.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              workflow.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${workflow.nodes.length} nodes · ${workflow.connections.length} connections',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _hitTestNodes(Offset position, List<WorkflowNodeModel> nodes) {
    for (final node in nodes) {
      final nodeRect = Rect.fromLTWH(
        node.position.dx,
        node.position.dy,
        160, 
        80, 
      );

      if (nodeRect.contains(position)) {
        return node.id;
      }
    }

    return null;
  }
}
