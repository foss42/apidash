import 'package:api_testing_suite/src/models/models.dart';
import 'package:flutter/material.dart';

/// A widget that displays a single node in a workflow
class WorkflowNode extends StatefulWidget {
  const WorkflowNode({
    Key? key,
    required this.node,
    this.scale = 1.0,
    required this.onDragUpdate,
    required this.onConnect,
    required this.onConnectMove,
    required this.onConnectEnd,
    required this.onTap,
    required this.onRemove,
    this.isConnectionModeActive = false,
    this.onConnectionTarget,
  }) : super(key: key);

  final WorkflowNodeModel node;
  final double scale;
  final Function(Offset) onDragUpdate;
  final Function(Offset) onConnect;
  final Function(Offset) onConnectMove;
  final Function(Offset) onConnectEnd;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final bool isConnectionModeActive;
  final VoidCallback? onConnectionTarget; 
  @override
  State<WorkflowNode> createState() => _WorkflowNodeState();
}

class _WorkflowNodeState extends State<WorkflowNode> {
  bool _isDragging = false; 
  bool _isHovering = false;
  bool _isOutputPortHovering = false;
  bool _isInputPortHovering = false;

  @override
  Widget build(BuildContext context) {
    final nodeWidth = 120.0 * widget.scale;
    final nodeHeight = 80.0 * widget.scale;

    Color nodeColor;
    Color borderColor;
    
    switch (widget.node.status) {
      case NodeStatus.running:
        nodeColor = Colors.blue.withOpacity(0.7);
        borderColor = Colors.blue;
        break;
      case NodeStatus.success:
        nodeColor = Colors.green.withOpacity(0.7);
        borderColor = Colors.green;
        break;
      case NodeStatus.failure:
        nodeColor = Colors.red.withOpacity(0.7);
        borderColor = Colors.red;
        break;
      case NodeStatus.pending:
        nodeColor = Colors.orange.withOpacity(0.7);
        borderColor = Colors.orange;
        break;
      default:
        nodeColor = Theme.of(context).cardColor;
        borderColor = Theme.of(context).dividerColor;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () {
          if (widget.isConnectionModeActive && widget.onConnectionTarget != null) {
            widget.onConnectionTarget!();
          } else {
            widget.onTap();
          }
        },
        onPanStart: (details) {
          setState(() => _isDragging = true);
        },
        onPanUpdate: (details) {
          widget.onDragUpdate(details.delta / widget.scale);
        },
        onPanEnd: (details) {
          setState(() => _isDragging = false);
        },
        child: Stack(
          children: [
            Positioned(
              left: -8 * widget.scale,
              top: nodeHeight / 2 - (8 * widget.scale),
              child: MouseRegion(
                onEnter: (_) => setState(() { _isInputPortHovering = true; }),
                onExit: (_) => setState(() { _isInputPortHovering = false; }),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 16 * widget.scale,
                      height: 16 * widget.scale,
                      decoration: BoxDecoration(
                        color: _isInputPortHovering ? Colors.green.shade700 : Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2 * widget.scale,
                        ),
                        boxShadow: _isInputPortHovering || _isHovering ? [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.5),
                            blurRadius: 4,
                            spreadRadius: 2,
                          )
                        ] : null,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 10 * widget.scale,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Container(
              width: nodeWidth,
              height: nodeHeight,
              decoration: BoxDecoration(
                color: nodeColor,
                borderRadius: BorderRadius.circular(8 * widget.scale),
                border: Border.all(
                  color: borderColor,
                  width: 2 * widget.scale,
                ),
                boxShadow: _isDragging || _isHovering 
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4 * widget.scale,
                          spreadRadius: 1 * widget.scale,
                          offset: Offset(0, 2 * widget.scale),
                        ),
                      ]
                    : null,
              ),
              child: Padding(
                padding: EdgeInsets.all(8 * widget.scale),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.node.label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12 * widget.scale,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4 * widget.scale),
                    Text(
                      'ID: ${widget.node.id.substring(0, 4)}...',
                      style: TextStyle(
                        fontSize: 9 * widget.scale,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Remove button
            if (_isHovering)
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: widget.onRemove,
                  child: Container(
                    padding: EdgeInsets.all(4 * widget.scale),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 12 * widget.scale,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            
            Positioned(
              right: -8 * widget.scale,
              top: nodeHeight / 2 - (8 * widget.scale),
              child: MouseRegion(
                onEnter: (_) => setState(() { _isOutputPortHovering = true; }),
                onExit: (_) => setState(() { _isOutputPortHovering = false; }),
                child: GestureDetector(
                  onTap: () {
                    final globalPosition = Offset(
                      widget.node.position.dx + nodeWidth / 2,
                      widget.node.position.dy + nodeHeight / 2,
                    );
                    widget.onConnect(globalPosition);
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 16 * widget.scale,
                        height: 16 * widget.scale,
                        decoration: BoxDecoration(
                          color: _isOutputPortHovering ? Colors.blue.shade700 : Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2 * widget.scale,
                          ),
                          boxShadow: _isOutputPortHovering || _isHovering ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              blurRadius: 4,
                              spreadRadius: 2,
                            )
                          ] : null,
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 10 * widget.scale,
                        ),
                      ),
                      if (_isOutputPortHovering)
                        Positioned(
                          top: -20 * widget.scale,
                          right: 8 * widget.scale,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6 * widget.scale,
                              vertical: 3 * widget.scale,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4 * widget.scale),
                            ),
                            child: Text(
                              'Drag to connect',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10 * widget.scale,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
