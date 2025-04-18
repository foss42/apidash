import 'package:api_testing_suite/api_testing_suite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class WorkflowNode extends ConsumerWidget {
  final WorkflowNodeModel node;
  final bool isSelected;
  final bool isRunning;
  final bool isCompleted;
  final bool hasError;
  final Function(String)? onTap;
  final Function(String, Offset)? onStartConnection;
  final Function(String, Offset)? onDragStart;
  final Function(Offset)? onDragUpdate;
  final Function()? onDragEnd;

  const WorkflowNode({
    super.key,
    required this.node,
    this.isSelected = false,
    this.isRunning = false,
    this.isCompleted = false,
    this.hasError = false,
    this.onTap,
    this.onStartConnection,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodeSize = _getNodeSize();
    final nodeColor = _getNodeColor();
    final borderColor = isSelected ? Colors.blue : Colors.transparent;
    final iconData = _getNodeIcon();
    final elevation = isSelected ? 8.0 : 4.0;
    
    return GestureDetector(
      onTap: onTap != null ? () => onTap!(node.id) : null,
      onPanStart: onDragStart != null ? (details) => onDragStart!(node.id, details.globalPosition) : null,
      onPanUpdate: onDragUpdate != null ? (details) => onDragUpdate!(details.globalPosition) : null,
      onPanEnd: onDragEnd != null ? (_) => onDragEnd!() : null,
      child: Material(
        elevation: elevation,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        shadowColor: isRunning 
            ? Colors.blue.withOpacity(0.6) 
            : isCompleted 
                ? Colors.green.withOpacity(0.6)
                : hasError
                    ? Colors.red.withOpacity(0.6)
                    : Colors.black.withOpacity(0.3),
        child: Container(
          width: nodeSize.width,
          height: nodeSize.height,
          decoration: BoxDecoration(
            color: nodeColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isRunning
                    ? Colors.blue.withOpacity(0.3)
                    : isCompleted
                        ? Colors.green.withOpacity(0.3)
                        : hasError
                            ? Colors.red.withOpacity(0.3)
                            : Colors.black.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          iconData,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            node.label.isEmpty
                                ? 'Node ${node.id.substring(0, 4)}'
                                : node.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (node.nodeType == NodeType.request)
                      _buildRequestDetails(),
                    if (node.nodeType == NodeType.condition)
                      _buildConditionDetails(),
                    if (node.nodeType == NodeType.action) 
                      _buildActionDetails(),
                    if (node.nodeType == NodeType.response) 
                      _buildResponseDetails(),
                  ],
                ),
              ),
              
              if (isRunning || isCompleted || hasError)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: isRunning
                          ? Colors.blue
                          : isCompleted
                              ? Colors.green
                              : Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      isRunning
                          ? Icons.update
                          : isCompleted
                              ? Icons.check
                              : Icons.error,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),

              if (onStartConnection != null)
                Positioned(
                  right: 0,
                  top: nodeSize.height / 2 - 6,
                  child: GestureDetector(
                    onPanStart: (details) {
                      onStartConnection!(
                        node.id,
                        details.globalPosition,
                      );
                    },
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestDetails() {
    final method = node.nodeData['method'] as String? ?? 'GET';
    final url = node.nodeData['url'] as String? ?? '';
    final methodColor = _getMethodColor(method);
    final shortUrl = url.length > 30 ? '${url.substring(0, 27)}...' : url;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: methodColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                method,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                shortUrl.isEmpty ? 'No URL set' : shortUrl,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 10,
                  fontStyle: shortUrl.isEmpty ? FontStyle.italic : FontStyle.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildConditionDetails() {
    final condition = node.nodeData['condition'] as String? ?? '';
    final shortCondition = condition.length > 30 ? '${condition.substring(0, 27)}...' : condition;
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        shortCondition.isEmpty ? 'No condition set' : shortCondition,
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 10,
          fontStyle: shortCondition.isEmpty ? FontStyle.italic : FontStyle.normal,
        ),
      ),
    );
  }
  
  Widget _buildActionDetails() {
    final actionType = node.nodeData['actionType'] as String? ?? 'transform';
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            actionType.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildResponseDetails() {
    final statusCode = node.nodeData['statusCode'] as int? ?? 200;
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: _getStatusCodeColor(statusCode),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Status: $statusCode',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  
  Size _getNodeSize() {
    switch (node.nodeType) {
      case NodeType.request:
        return const Size(160, 80);
      case NodeType.response:
        return const Size(160, 60);
      case NodeType.condition:
        return const Size(160, 60);
      case NodeType.action:
        return const Size(160, 60);
    }
  }
  
  Color _getNodeColor() {
    final baseColors = {
      NodeType.request: const Color(0xFF2d3748),
      NodeType.response: const Color(0xFF553C9A),
      NodeType.condition: const Color(0xFFb91c1c),
      NodeType.action: const Color(0xFF047857),
    };
    
    Color baseColor = baseColors[node.nodeType] ?? const Color(0xFF2d3748);
    
    if (isRunning) {
      return Color.lerp(baseColor, Colors.blue, 0.15) ?? baseColor;
    } else if (isCompleted) {
      return Color.lerp(baseColor, Colors.green, 0.15) ?? baseColor;
    } else if (hasError) {
      return Color.lerp(baseColor, Colors.red, 0.15) ?? baseColor;
    } else {
      return baseColor;
    }
  }
  
  IconData _getNodeIcon() {
    switch (node.nodeType) {
      case NodeType.request:
        return Icons.send;
      case NodeType.response:
        return Icons.call_received;
      case NodeType.condition:
        return Icons.fork_right;
      case NodeType.action:
        return Icons.settings;
    }
  }
  
  Color _getMethodColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return const Color(0xFF3182CE);
      case 'POST':
        return const Color(0xFF38A169);
      case 'PUT':
        return const Color(0xFFDD6B20);
      case 'DELETE':
        return const Color(0xFFE53E3E);
      case 'PATCH':
        return const Color(0xFF805AD5);
      default:
        return const Color(0xFF718096);
    }
  }
  
  Color _getStatusCodeColor(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return Colors.green;
    } else if (statusCode >= 300 && statusCode < 400) {
      return Colors.blue;
    } else if (statusCode >= 400 && statusCode < 500) {
      return Colors.orange;
    } else if (statusCode >= 500) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }
}
