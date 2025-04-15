import 'package:apidash/screens/dashflow/dashflow_builder/grid.dart';
import 'package:apidash/screens/dashflow/dashflow_builder/nodes.dart';
import 'package:flutter/material.dart';

class WorkflowCanvas extends StatefulWidget {
  const WorkflowCanvas({super.key});

  @override
  State<WorkflowCanvas> createState() => _WorkflowCanvasState();
}

class _WorkflowCanvasState extends State<WorkflowCanvas> {
  final TransformationController _controller = TransformationController();

  List<NodeData> nodes = [
    NodeData(id: 1, offset: Offset(100,100)),
    NodeData(id: 2, offset: Offset(150,150)),
  ];

  void _onNodeDrag(int id, Offset newOffset) {
    final index = nodes.indexWhere((n) => n.id == id);
    if (index != -1) {
      setState(() {
        nodes[index] = nodes[index].copyWith(offset: newOffset);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("New Dashflow")),
      body: Padding(
        padding: const EdgeInsets.only(left: 5,right: 5,bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
            color: const Color.fromARGB(255, 229, 247, 255),
          ),
          child: InteractiveViewer(
            transformationController: _controller,
            constrained: false,
            boundaryMargin: EdgeInsets.all(double.infinity),
            minScale: 0.5,
            maxScale: 3,
            child: SizedBox(
              height: mq.width,
              width: mq.width,
              child: CustomPaint(
                painter: GridPainter(
                  transformation: _controller.value,
                  viewportSize: MediaQuery.of(context).size,
                ),
                child: Stack(
                  children: nodes.map((node) {
                    return Positioned(
                      left: node.offset.dx,
                      top: node.offset.dy,
                      child: DraggableNode(
                        node: node,
                        onDrag: _onNodeDrag,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

