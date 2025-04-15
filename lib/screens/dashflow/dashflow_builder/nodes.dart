import 'package:flutter/material.dart';

class NodeData {
  final int id;
  final Offset offset;

  NodeData({required this.id, required this.offset});

  NodeData copyWith({Offset? offset}) =>
      NodeData(id: id, offset: offset ?? this.offset);
}

class DraggableNode extends StatefulWidget {
  final NodeData node;
  final Function(int id, Offset newOffset) onDrag;

  const DraggableNode({super.key, required this.node, required this.onDrag});

  @override
  State<DraggableNode> createState() => _DraggableNodeState();
}

class _DraggableNodeState extends State<DraggableNode> {
  Offset offset = Offset.zero;

  @override
  void initState() {
    super.initState();
    offset = widget.node.offset;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        offset += details.delta;
        widget.onDrag(widget.node.id, offset);
      },
      child: Card(
        elevation: 4,
        color: Colors.lightBlue[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Node ${widget.node.id}"),
        ),
      ),
    );
  }
}
