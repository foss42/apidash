import 'package:api_testing_suite/api_testing_suite.dart';
import 'package:api_testing_suite/src/workflow_builder/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CanvasView extends ConsumerStatefulWidget {
  final String workflowId;
  const CanvasView({super.key, required this.workflowId});

  @override
  ConsumerState<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends ConsumerState<CanvasView>
    with CanvasEventHandlers<CanvasView> {
  void handleNodeDrop(WidgetRef ref, String workflowId, Object data, Offset position) {
    if (data is String) {
      final requestId = data;
      handleApiNodeAdded(ref, workflowId, requestId, position);
    }
  }
  
  final TransformationController _transformationController = TransformationController();
  double _scale = 1.0;

  @override
  TransformationController get transformationController => _transformationController;

  Offset? mouseMovePosition;

  @override
  Widget build(BuildContext context) {
    final workflows = ref.watch(workflowsNotifierProvider);
    final workflow = workflows.firstWhere(
      (w) => w.id == widget.workflowId,
      orElse: () => throw Exception('Workflow not found: ${widget.workflowId}'),
    );
    
    final isConnectionMode = ref.watch(connectionModeProvider);
    
    debugPrint('[CanvasView] Workflow nodes count: ${workflow.nodes.length}');
    for (final node in workflow.nodes) {
      debugPrint('[CanvasView] Node ID: ${node.id}, Position: ${node.position}, Label: ${node.label}');
    }
    
    final runningNodeIds = workflow.nodes
        .where((node) => node.status == NodeStatus.running)
        .map((node) => node.id)
        .toList();
    
    final completedNodeIds = workflow.nodes
        .where((node) => node.status == NodeStatus.success)
        .map((node) => node.id)
        .toList();
    
    final nodePositions = Map<String, Offset>.fromEntries(
      workflow.nodes.map((node) => MapEntry(node.id, node.position)),
    );

    return Stack(
      children: [
        if (isConnectionMode)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cable, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    sourceNodeId != null 
                        ? 'Now click another node to connect' 
                        : 'Click on a node to start connecting',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        MouseRegion(
          onHover: (event) {
            if (sourceNodeId != null && connectionStart != null) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final localPosition = box.globalToLocal(event.position);
              
              setState(() {
                connectionEnd = localPosition;
              });
            }
          },
          child: InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.2,
            maxScale: 2.0,
            onInteractionUpdate: (details) {
              setState(() {
                _scale = _transformationController.value.getMaxScaleOnAxis();
              });
            },
            child: CanvasDropTarget(
              transformationController: _transformationController,
              onAccept: (data, position) {
                handleNodeDrop(ref, widget.workflowId, data, position);
              },
              child: Stack(
                children: [
                  CanvasConnectionLayer(
                    workflow: workflow,
                    nodePositions: nodePositions,
                    sourceNodeId: sourceNodeId,
                    connectionStart: connectionStart,
                    connectionEnd: connectionEnd,
                    runningNodeIds: runningNodeIds,
                    completedNodeIds: completedNodeIds,
                  ),
                  CanvasNodeLayer(
                    workflowId: widget.workflowId,
                    onNodeDragStart: (nodeId, globalPosition) {
                      handleNodeDragStart(ref, widget.workflowId, nodeId, globalPosition);
                    },
                    onNodeDragUpdate: (globalPosition) {
                      handleNodeDragUpdate(ref, widget.workflowId, globalPosition);
                    },
                    onNodeDragEnd: () {
                      handleNodeDragEnd(ref, widget.workflowId);
                    },
                    onStartConnection: (nodeId, position) {
                      handleNodeTap(ref, widget.workflowId, nodeId, position);
                    },
                    onNodeSelected: (nodeId, position) {
                      handleNodeTap(ref, widget.workflowId, nodeId, position);
                    },
                    draggedNodeId: draggedNodeId,
                    sourceNodeId: sourceNodeId,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 16,
          top: 16,
          child: CanvasControls(
            transformationController: _transformationController,
            scale: _scale,
            onReset: () {
              _transformationController.value = Matrix4.identity();
              setState(() => _scale = 1.0);
            },
            onZoomIn: () {
              _transformationController.value.scale(1.2);
              setState(() => _scale = _transformationController.value.getMaxScaleOnAxis());
            },
            onZoomOut: () {
              _transformationController.value.scale(0.8);
              setState(() => _scale = _transformationController.value.getMaxScaleOnAxis());
            },
          ),
        ),
        Positioned(
          left: 16,
          top: isConnectionMode ? 70 : 16,
          child: CanvasInfoCard(workflow: workflow),
        ),
      ],
    );
  }
}
