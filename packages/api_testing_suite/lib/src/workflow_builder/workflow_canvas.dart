import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/workflow_node_model.dart';
import '../models/workflow_connection_model.dart';
import '../models/workflow_connection.dart';
import 'workflow_providers.dart';

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
  late Offset _startPosition;
  bool _isDragging = false;
  WorkflowConnectionModel? _tempConnection;

  @override
  Widget build(BuildContext context) {
    final workflows = ref.watch(workflowsNotifierProvider);
    final currentWorkflow = workflows.firstWhere(
      (workflow) => workflow.id == widget.workflowId,
      orElse: () => throw Exception('Workflow not found'),
    );

    final nodePositions = Map.fromEntries(
      currentWorkflow.nodes.map((node) => MapEntry(node.id, node.position)),
    );

    return GestureDetector(
      onPanStart: (details) {
        _startPosition = details.localPosition;
      },
      onPanUpdate: (details) {
        setState(() {
          _isDragging = true;
          _tempConnection = WorkflowConnectionModel(
            id: const Uuid().v4(),
            sourceId: '',
            targetId: '',
            workflowId: widget.workflowId!,
            position: details.localPosition,
          );
        });
      },
      onPanEnd: (details) {
        setState(() {
          _isDragging = false;
          _tempConnection = null;
        });
      },
      child: Stack(
        children: [
          // Background grid
          CustomPaint(
            painter: _GridPainter(),
            size: const Size(double.infinity, double.infinity),
          ),
          // Nodes
          ...currentWorkflow.nodes.map((node) => Positioned(
            left: node.position.dx,
            top: node.position.dy,
            child: WorkflowNodeWidget(
              node: node,
              onNodeSelected: (nodeId) {
                ref.read(workflowsNotifierProvider.notifier).selectNode(nodeId);
              },
              onNodeMoved: (nodeId, newPosition) {
                // TODO: Implement node movement
              },
            ),
          )),
          // Connections
          CustomPaint(
            painter: _ConnectionPainter(
              connections: currentWorkflow.connections,
              tempConnection: _tempConnection,
              nodePositions: nodePositions,
            ),
            size: const Size(double.infinity, double.infinity),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ConnectionPainter extends CustomPainter {
  final List<WorkflowConnectionModel> connections;
  final WorkflowConnectionModel? tempConnection;
  final Map<String, Offset> nodePositions;
  final Color color;
  final double width;

  _ConnectionPainter({
    required this.connections,
    this.tempConnection,
    required this.nodePositions,
    this.color = Colors.blue,
    this.width = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    for (var connection in connections) {
      if (nodePositions.containsKey(connection.sourceId) &&
          nodePositions.containsKey(connection.targetId)) {
        final start = nodePositions[connection.sourceId]!;
        final end = nodePositions[connection.targetId]!;
        canvas.drawLine(start, end, paint);
      }
    }

    if (tempConnection != null) {
      final start = tempConnection!.position;
      final targetId = tempConnection!.targetId;
      
      if (targetId.isNotEmpty && nodePositions.containsKey(targetId)) {
        final end = nodePositions[targetId]!;
        canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WorkflowNodeWidget extends StatelessWidget {
  final WorkflowNodeModel node;
  final Function(String) onNodeSelected;
  final Function(String, Offset) onNodeMoved;

  WorkflowNodeWidget({
    required this.node,
    required this.onNodeSelected,
    required this.onNodeMoved,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable(
      maxSimultaneousDrags: 1,
      feedback: Container(
        width: 100,
        height: 50,
        color: Colors.blue.withOpacity(0.5),
        child: Center(
          child: Text(node.id),
        ),
      ),
      childWhenDragging: Container(
        width: 100,
        height: 50,
        color: Colors.grey,
        child: Center(
          child: Text(node.id),
        ),
      ),
      onDragEnd: (details) {
        onNodeMoved(node.id, details.offset);
      },
      child: Container(
        width: 100,
        height: 50,
        color: Colors.blue,
        child: Center(
          child: Text(node.id),
        ),
      ),
    );
  }
}
