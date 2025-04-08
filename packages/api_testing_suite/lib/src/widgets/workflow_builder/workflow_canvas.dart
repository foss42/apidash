import 'package:api_testing_suite/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/workflow_model.dart';
import '../../providers/workflow_providers.dart';
import 'workflow_node.dart';
import 'workflow_connection.dart';

/// A widget that displays the workflow canvas where nodes can be placed and connected
class WorkflowCanvas extends ConsumerStatefulWidget {
  const WorkflowCanvas({
    Key? key,
    required this.workflowId,
  }) : super(key: key);

  final String workflowId;

  @override
  ConsumerState<WorkflowCanvas> createState() => _WorkflowCanvasState();
}

class _WorkflowCanvasState extends ConsumerState<WorkflowCanvas> {
  // For drag and drop functionality
  Offset _panPosition = Offset.zero;
  double _scale = 1.0;
  Offset? _startConnectingPosition;
  String? _startConnectingNodeId;
  String? _highlightNodeId;       // Target node being highlighted
  String? _highlightSourceId;     // Source node being highlighted
  Offset? _currentConnectingPosition;
  bool _isDraggingCanvas = false;
  bool _isConnectionModeActive = false;  // New variable to track if we're in connection mode
  
  @override
  Widget build(BuildContext context) {
    final workflow = ref.watch(activeWorkflowProvider);
    if (workflow == null) {
      return const Center(child: Text('No workflow selected'));
    }
    
    if (_isConnectionModeActive) {
      return RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) {
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            _resetConnectionMode();
          }
        },
        child: _buildMainCanvas(workflow),
      );
    }
    
    return _buildMainCanvas(workflow);
  }
  
  Widget _buildMainCanvas(WorkflowModel workflow) {
    return GestureDetector(
      onTap: () {
        if (_isConnectionModeActive) {
          _resetConnectionMode();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Connection cancelled'),
              duration: Duration(seconds: 1),
              backgroundColor: Colors.grey,
            ),
          );
        }
      },
      onSecondaryTapDown: (_) {
        if (_isConnectionModeActive) {
          _resetConnectionMode();
        } else {
          setState(() {
            _isDraggingCanvas = true;
          });
        }
      },
      onSecondaryTapUp: (_) {
        setState(() {
          _isDraggingCanvas = false;
        });
      },
      onScaleStart: (details) {
        setState(() {
          _isDraggingCanvas = true;
        });
      },
      onScaleUpdate: (details) {
        if (!_isDraggingCanvas && _startConnectingNodeId != null) {
          return;
        }
        setState(() {
          if (details.scale == 1.0) {
            _panPosition += details.focalPointDelta;
          } else {
            _scale = (_scale * details.scale).clamp(0.5, 2.0);
          }
        });
      },
      onScaleEnd: (_) {
        setState(() {
          _isDraggingCanvas = false;
        });
      },
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Stack(
          children: [
            CustomPaint(
              painter: GridPainter(offset: _panPosition, scale: _scale),
              size: MediaQuery.of(context).size,
            ),
            
            if (_startConnectingPosition != null && _currentConnectingPosition != null)
              CustomPaint(
                painter: ConnectionLinePainter(
                  start: _startConnectingPosition!,
                  end: _currentConnectingPosition!,
                  isPreview: true,
                ),
                size: MediaQuery.of(context).size,
              ),
            
            ...workflow.connections.map((connection) {
              final sourceNodeIndex = workflow.nodes.indexWhere((node) => node.id == connection.sourceId);
              final targetNodeIndex = workflow.nodes.indexWhere((node) => node.id == connection.targetId);
              
              if (sourceNodeIndex == -1 || targetNodeIndex == -1) {
                return const SizedBox.shrink(); // Connection refers to nodes that don't exist
              }
              
              final sourceNode = workflow.nodes[sourceNodeIndex];
              final targetNode = workflow.nodes[targetNodeIndex];
              
              final scaledSourcePosition = Offset(
                sourceNode.position.dx * _scale + _panPosition.dx + 120 * _scale, // Right edge of source node
                sourceNode.position.dy * _scale + _panPosition.dy + 40 * _scale,  // Middle of source node
              );
              
              final scaledTargetPosition = Offset(
                targetNode.position.dx * _scale + _panPosition.dx, // Left edge of target node
                targetNode.position.dy * _scale + _panPosition.dy + 40 * _scale, // Middle of target node
              );
              
              return Positioned.fill(
                child: WorkflowConnection(
                  connection: connection,
                  sourcePosition: scaledSourcePosition,
                  targetPosition: scaledTargetPosition,
                  isConditional: connection.isConditional,
                  scale: _scale,
                  onTap: () => _showConnectionDetails(connection),
                  onRemove: () => _removeConnection(connection.id),
                ),
              );
            }).toList(),
            
            // Workflow nodes
            ...workflow.nodes.map((node) {
              final isHighlighted = _highlightNodeId == node.id || _highlightSourceId == node.id;
              final canBeTarget = _startConnectingNodeId != null && 
                                 _startConnectingNodeId != node.id &&
                                 !workflow.connections.any((conn) => 
                                   conn.sourceId == _startConnectingNodeId && conn.targetId == node.id);
              
              final position = Offset(
                node.position.dx * _scale + _panPosition.dx,
                node.position.dy * _scale + _panPosition.dy
              );
              
              return Positioned(
                left: position.dx,
                top: position.dy,
                child: isHighlighted 
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.6),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: WorkflowNode(
                        node: node,
                        scale: _scale,
                        onDragUpdate: (delta) => _moveNode(node.id, delta),
                        onConnect: (position) => _startConnecting(node.id, position),
                        onConnectMove: _updateConnecting,
                        onConnectEnd: _finishConnecting,
                        onTap: () => _showNodeDetails(node),
                        onRemove: () => _removeNode(node.id),
                        isConnectionModeActive: _isConnectionModeActive && canBeTarget,
                        onConnectionTarget: canBeTarget ? () => _connectNodes(_startConnectingNodeId!, node.id) : null,
                      )
                  ) : WorkflowNode(
                    node: node,
                    scale: _scale,
                    onDragUpdate: (delta) => _moveNode(node.id, delta),
                    onConnect: (position) => _startConnecting(node.id, position),
                    onConnectMove: _updateConnecting,
                    onConnectEnd: _finishConnecting,
                    onTap: () => _showNodeDetails(node),
                    onRemove: () => _removeNode(node.id),
                    isConnectionModeActive: _isConnectionModeActive && canBeTarget,
                    onConnectionTarget: canBeTarget ? () => _connectNodes(_startConnectingNodeId!, node.id) : null,
                  ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _moveNode(String nodeId, Offset delta) {
    if (_isConnectionModeActive) return;
    
    ref.read(workflowsProvider.notifier).updateNodePosition(
      widget.workflowId,
      nodeId,
      Offset(
        (ref.read(activeWorkflowProvider)!.nodes
          .firstWhere((node) => node.id == nodeId).position.dx + delta.dx),
        (ref.read(activeWorkflowProvider)!.nodes
          .firstWhere((node) => node.id == nodeId).position.dy + delta.dy),
      ),
    );
  }

  void _startConnecting(String nodeId, Offset position) {
    setState(() {
      _startConnectingNodeId = nodeId;
      _startConnectingPosition = position;
      _currentConnectingPosition = position;
      _isConnectionModeActive = true;
      
      final workflow = ref.read(activeWorkflowProvider);
      if (workflow != null) {
        final existingConnections = workflow.connections.where(
          (conn) => conn.sourceId == nodeId
        ).toList();
        
        _highlightSourceId = nodeId;
        
        if (existingConnections.isNotEmpty) {
          _highlightNodeId = existingConnections.first.targetId;
        }
      }
    });
  }

  void _updateConnecting(Offset position) {
    setState(() {
      _currentConnectingPosition = position;
    });
  }

  void _resetConnectionMode() {
    setState(() {
      _startConnectingNodeId = null;
      _startConnectingPosition = null;
      _currentConnectingPosition = null;
      _highlightNodeId = null;
      _highlightSourceId = null;
      _isConnectionModeActive = false;
    });
  }
  
  void _connectNodes(String sourceId, String targetId) {
    final workflow = ref.read(activeWorkflowProvider);
    if (workflow == null) return;
    
    final existingConnection = workflow.connections.any(
      (conn) => conn.sourceId == sourceId && conn.targetId == targetId
    );
    
    if (existingConnection) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection already exists'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.orange,
        ),
      );
      _resetConnectionMode();
      return;
    }
    
    final connection = WorkflowConnectionModel.create(
      sourceId: sourceId,
      targetId: targetId,
    );
    
    ref.read(workflowsProvider.notifier).addConnection(
      widget.workflowId,
      connection,
    );
    
    final sourceNode = workflow.nodes.firstWhere((node) => node.id == sourceId);
    final updatedConnectedToIds = [...sourceNode.connectedToIds, targetId];
    
    ref.read(workflowsProvider.notifier).updateNode(
      widget.workflowId,
      sourceNode.copyWith(connectedToIds: updatedConnectedToIds),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nodes connected successfully'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
    
    _resetConnectionMode();
  }

  void _finishConnecting(Offset position) {
    // We'll TODO: @abhinavs1920 Implement hit detection here for connecting to another node
    _resetConnectionMode();
  }

  void _showNodeDetails(WorkflowNodeModel node) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Node Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${node.id}'),
            SizedBox(height: 8),
            Text('Label:'),
            TextFormField(
              initialValue: node.label,
              onChanged: (value) {
                final updatedNode = node.copyWith(label: value);
                ref.read(workflowsProvider.notifier).updateNode(
                  widget.workflowId,
                  updatedNode,
                );
              },
              decoration: InputDecoration(
                hintText: 'Enter node label',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text('Status: ${node.status.toString().split('.').last}'),
            SizedBox(height: 16),
            Text('Connected to: ${node.connectedToIds.join(', ')}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showConnectionDetails(WorkflowConnectionModel connection) {
    bool isConditional = connection.isConditional;
    String condition = connection.condition;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Connection Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('From: ${connection.sourceId}'),
            Text('To: ${connection.targetId}'),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Conditional Connection'),
              value: isConditional,
              onChanged: (value) {
                setState(() {
                  isConditional = value ?? false;
                });
              },
            ),
            if (isConditional) ...[
              SizedBox(height: 8),
              Text('Condition:'),
              TextFormField(
                initialValue: condition,
                onChanged: (value) {
                  condition = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter condition expression',
                  border: OutlineInputBorder(),
                  helperText: 'Example: response.status == 200',
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.delete, color: Colors.red),
            label: Text('Remove', style: TextStyle(color: Colors.red)),
            onPressed: () {
              _removeConnection(connection.id);
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final updatedConnection = connection.copyWith(
                isConditional: isConditional,
                condition: condition,
              );
              ref.read(workflowsProvider.notifier).updateConnection(
                widget.workflowId,
                updatedConnection,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _removeNode(String nodeId) {
    final workflow = ref.read(activeWorkflowProvider);
    if (workflow == null) return;
    
    ref.read(workflowsProvider.notifier).removeNode(
      workflow.id,
      nodeId,
    );
  }

  void _removeConnection(String connectionId) {
    final workflow = ref.read(activeWorkflowProvider);
    if (workflow == null) return;
    
    ref.read(workflowsProvider.notifier).removeConnection(
      workflow.id,
      connectionId,
    );
  }
}

class GridPainter extends CustomPainter {
  final Offset offset;
  final double scale;
  
  GridPainter({
    required this.offset,
    required this.scale,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;
    
    const gridSize = 40.0;
    
    final scaledGridSize = gridSize * scale;
    final startX = (offset.dx * scale) % scaledGridSize;
    final startY = (offset.dy * scale) % scaledGridSize;
    
    for (double x = startX; x <= size.width; x += scaledGridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    for (double y = startY; y <= size.height; y += scaledGridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return oldDelegate.offset != offset || oldDelegate.scale != scale;
  }
}

class ConnectionLinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final bool isPreview;
  
  ConnectionLinePainter({
    required this.start,
    required this.end,
    this.isPreview = false,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isPreview ? Colors.blue.withOpacity(0.7) : Colors.blue
      ..strokeWidth = isPreview ? 3 : 2
      ..style = PaintingStyle.stroke;
    
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        start.dx + (end.dx - start.dx) * 0.5,
        start.dy,
        start.dx + (end.dx - start.dx) * 0.5,
        end.dy,
        end.dx,
        end.dy,
      );
    
    canvas.drawPath(path, paint);
    
    // Draw arrow at the end
    final arrowSize = 10.0;
    final arrowPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(
        end.dx - arrowSize * 1.5 * (end.dx > start.dx ? 1 : -1),
        end.dy - arrowSize,
      )
      ..lineTo(
        end.dx - arrowSize * 1.5 * (end.dx > start.dx ? 1 : -1),
        end.dy + arrowSize,
      )
      ..close();
    
    canvas.drawPath(arrowPath, paint..style = PaintingStyle.fill);
  }
  
  @override
  bool shouldRepaint(covariant ConnectionLinePainter oldDelegate) {
    return oldDelegate.start != start || oldDelegate.end != end;
  }
}
