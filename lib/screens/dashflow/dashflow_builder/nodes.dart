import 'package:flutter/material.dart';

class NodeData {
  final int id;
  final Offset offset;
  final GlobalKey sizeKey = GlobalKey();

  NodeData({required this.id, required this.offset});

  NodeData copyWith({Offset? offset}) =>
      NodeData(id: id, offset: offset ?? this.offset);
}

class DraggableNode extends StatefulWidget {
  final NodeData node;
  final Function(int id, Offset newOffset) onDrag;
  final double gridSize; // Added for snap-to-grid

  const DraggableNode({super.key, required this.node, required this.onDrag,required this.gridSize,});

  @override
  State<DraggableNode> createState() => _DraggableNodeState();
}

class _DraggableNodeState extends State<DraggableNode> {
  late Offset offset;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    offset = widget.node.offset;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart:(_){
        setState((){
          isDragging =true;
        });
      },
      onPanUpdate: (details) {
        if(isDragging){
        final zoom = (context.findAncestorWidgetOfExactType<InteractiveViewer>()?.transformationController?.value.getMaxScaleOnAxis() ?? 1.0);
        final adjustedDelta = details.delta*zoom;
        offset += adjustedDelta;
        // Snap to grid
          final snappedOffset = Offset(
            (offset.dx / widget.gridSize).round() * widget.gridSize,
            (offset.dy / widget.gridSize).round() * widget.gridSize,
          );
        widget.onDrag(widget.node.id, snappedOffset);
        }
      },
      onPanEnd: (_){
        setState((){
          isDragging = false;
        });
      },
      child: Card(
        key: widget.node.sizeKey,
        elevation: isDragging ? 16 : 4,
        color: Colors.lightBlue[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Node ${widget.node.id}, this is the test node", style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
    );
  }
}

class ControlNode extends StatefulWidget {
  final Offset offset;
  final Function(Offset newOffset) onDrag;
  final double gridSize;

  const ControlNode({
    super.key,
    required this.offset,
    required this.onDrag,
    required this.gridSize,
  });

  @override
  State<ControlNode> createState() => _ControlNodeState();
}

class _ControlNodeState extends State<ControlNode> {
  late Offset offset;
  bool isDragging = false;

  void _runFlow(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Run Flow'),
        content: const Text('Workflow executed successfully (mock).'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _addAnnotation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Annotation'),
        content: const TextField(decoration: InputDecoration(hintText: 'Enter note')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _clearCanvas(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear Canvas'),
        content: const Text('This will reset all nodes. Proceed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    offset = widget.offset;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            offset += details.delta;
            final snappedOffset = Offset(
              (offset.dx / widget.gridSize).round() * widget.gridSize,
              (offset.dy / widget.gridSize).round() * widget.gridSize,
            );
            widget.onDrag(snappedOffset);
          });
        },
        child: Card(
          elevation: isDragging ? 8 : 4,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondaryContainer,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Controls',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.play_arrow, size: 20),
                        onPressed: () => _runFlow(context),
                        tooltip: 'Run Flow',
                      ),
                      IconButton(
                        icon: const Icon(Icons.note_add, size: 20),
                        onPressed: () => _addAnnotation(context),
                        tooltip: 'Add Annotation',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        onPressed: () => _clearCanvas(context),
                        tooltip: 'Clear Canvas',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}