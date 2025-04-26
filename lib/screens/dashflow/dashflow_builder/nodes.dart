import 'package:apidash/providers/ui_providers.dart';
import 'package:apidash/screens/dashflow/dashflow_builder/workflow_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NodeData {
  final int id;
  final Offset offset;
  final GlobalKey sizeKey = GlobalKey();
   final String title; // Added for settings
  final String url;   // Added for settings
  final Map<String, String> headers; // Added for settings


  NodeData({required this.id, required this.offset,
   GlobalKey? sizeKey,this.title = 'REST Call',
    this.url = '',
    this.headers = const {},});

NodeData copyWith({
    Offset? offset,
    String? title,
    String? url,
    Map<String, String>? headers,
  }) {
    return NodeData(
      id: id,
      offset: offset ?? this.offset,
      title: title ?? this.title,
      url: url ?? this.url,
      headers: headers ?? this.headers,
    );
  }
}

class DraggableNode extends ConsumerStatefulWidget {
  final NodeData node;
  final Function(int id, Offset newOffset) onDrag;
  final double gridSize; // Added for snap-to-grid

  const DraggableNode({
    super.key,
    required this.node,
    required this.onDrag,
    required this.gridSize,
  });

  @override
  ConsumerState<DraggableNode> createState() => _DraggableNodeState();
}

class _DraggableNodeState extends ConsumerState<DraggableNode> {
  late Offset offset;
  bool isDragging = false;
    Offset? _dragStart; // Added for connection dragging

  @override
  void initState() {
    super.initState();
    offset = widget.node.offset;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (_) {
        setState(() {
          isDragging = true;
        });
      },
      onPanUpdate: (details) {
        if (isDragging) {
          final zoom = (context
                  .findAncestorWidgetOfExactType<InteractiveViewer>()
                  ?.transformationController
                  ?.value
                  .getMaxScaleOnAxis() ??
              1.0);
          final adjustedDelta = details.delta * zoom;
          offset += adjustedDelta;
          // Snap to grid
          final snappedOffset = Offset(
            (offset.dx / widget.gridSize).round() * widget.gridSize,
            (offset.dy / widget.gridSize).round() * widget.gridSize,
          );
          widget.onDrag(widget.node.id, snappedOffset);
        }
      },
      onPanEnd: (_) {
        setState(() {
          isDragging = false;
        });
      },
      onTap: () {
            showDialog(
              context: context,
              builder: (_) => SettingsDialog(
                node: widget.node,
                onSave: (title, url, headers) {
                  ref.read(workflowProvider.notifier).updateNode(
                        widget.node.id,
                        title: title,
                        url: url,
                        headers: headers,
                      );
                },
              ),
            );
          },
          onLongPressStart: (details) {
            _dragStart = details.localPosition;
          },
          onLongPressEnd: (details) {
            final nodes = ref.read(workflowProvider);
            final endNode = nodes.firstWhere(
              (n) =>
                  (n.offset - (offset + details.localPosition)).distance < 50 &&
                  n.id != widget.node.id,
              orElse: () => widget.node,
            );
            if (endNode != widget.node) {
              ref.read(connectionListProvider.notifier).state = [
                ...ref.read(connectionListProvider),
                Connection(from: widget.node.id, to: endNode.id),
              ];
            }
            _dragStart = null;
          },
      child: Card(
        key: widget.node.sizeKey,
        elevation: isDragging ? 16 : 4,
        color: Colors.lightBlue[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Node ${widget.node.id}, this is the test node",
              style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
    );
  }
}

class ControlNode extends ConsumerStatefulWidget {
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
  ConsumerState<ControlNode> createState() => _ControlNodeState();
}

class _ControlNodeState extends ConsumerState<ControlNode> {
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
        content: const TextField(
            decoration: InputDecoration(hintText: 'Enter note')),
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
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.drag_indicator),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                      ref.read(workflowProvider.notifier).addNode(
                          NodeData(
                            id: DateTime.now().millisecondsSinceEpoch,
                            offset: Offset(
                              (100 / widget.gridSize).round() * widget.gridSize,
                              (100 / widget.gridSize).round() * widget.gridSize,
                            ),
                            title: 'REST Call',
                          ),
                        );
                  },
                  icon: const Icon(Icons.add, size: 20),
                  tooltip: 'Add node',
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                  label: const Text('Run'),
                  icon: const Icon(Icons.play_arrow, size: 20),
                  onPressed: () => _runFlow(context),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: const Icon(Icons.note_add, size: 20),
                  onPressed: () => _addAnnotation(context),
                  tooltip: 'Add Annotation',
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () => _clearCanvas(context),
                  tooltip: 'Clear Canvas',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Define Connection class for node connections
class Connection {
  final int from;
  final int to;

  Connection({required this.from, required this.to});
}