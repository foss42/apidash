import 'package:api_testing_suite/api_testing_suite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'canvas_styles.dart';
import 'canvas_ui_constants.dart';

class CanvasNodeLayer extends ConsumerWidget {
  final String workflowId;
  final Function(String, Offset) onNodeDragStart;
  final Function(Offset) onNodeDragUpdate;
  final VoidCallback onNodeDragEnd;
  final Function(String, Offset) onStartConnection;
  final Function(String, Offset) onNodeSelected;
  final String? draggedNodeId;
  final String? sourceNodeId;

  const CanvasNodeLayer({
    super.key,
    required this.workflowId,
    required this.onNodeDragStart,
    required this.onNodeDragUpdate,
    required this.onNodeDragEnd,
    required this.onStartConnection,
    required this.onNodeSelected,
    this.draggedNodeId,
    this.sourceNodeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflows = ref.watch(workflowsNotifierProvider);
    final workflow = workflows.firstWhere(
      (w) => w.id == workflowId,
      orElse: () => throw StateError('Workflow not found: $workflowId in CanvasNodeLayer'),
    );
    
    final isConnectionMode = ref.watch(connectionModeProvider);
        
    return Stack(
      children: workflow.nodes.map((node) {
        final nodeCenter = Offset(
          node.position.dx + CanvasUIConstants.nodeWidth, 
          node.position.dy + CanvasUIConstants.nodeHeight,  
        );
        
        return Positioned(
          left: node.position.dx,
          top: node.position.dy,
          child: GestureDetector(
            onTap: () {
              onNodeSelected(node.id, nodeCenter);
            },
            onPanStart: (details) {
              if (!isConnectionMode) {
                onNodeDragStart(node.id, details.globalPosition);
              }
            },
            onPanUpdate: (details) {
              if (!isConnectionMode) {
                onNodeDragUpdate(details.globalPosition);
              }
            },
            onPanEnd: (_) {
              if (!isConnectionMode) {
                onNodeDragEnd();
              }
            },
            onLongPress: () {
              if (isConnectionMode) {
                onStartConnection(node.id, nodeCenter);
              }
            },
            child: Opacity(
              opacity: draggedNodeId == node.id ? 0.7 : 1.0,
              child: Material(
                elevation: draggedNodeId == node.id ? 8 : 3,
                borderRadius: BorderRadius.circular(8),
                color: Colors.transparent,
                child: Container(
                  width: 200,
                  constraints: const BoxConstraints(minHeight: 80),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: sourceNodeId == node.id 
                          ? [Colors.blue[300]!, Colors.blue[100]!]
                          : (isConnectionMode 
                              ? [Colors.purple[100]!, Colors.purple[50]!]
                              : [Colors.white, const Color(0xFFF5F5F5)]),
                    ),
                    border: Border.all(
                      color: _getBorderColor(node.id, sourceNodeId, isConnectionMode),
                      width: isConnectionMode ? 2.5 : 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff171433).withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: node.nodeType == NodeType.request 
                              ? Colors.blue.shade700
                              : Colors.green.shade700,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              node.nodeType == NodeType.request 
                                  ? Icons.http
                                  : Icons.settings,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                node.label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isConnectionMode)                                 
                              const Icon(
                                Icons.cable_outlined,
                                color: Colors.white,
                                size: 16,
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (node.nodeType == NodeType.request && node.requestModel != null)
                              Row(
                                children: [
                                  _buildMethodBadge(node.requestModel!.method),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      node.requestModel!.url.isEmpty 
                                          ? 'No URL specified'
                                          : node.requestModel!.url,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Text(
                                'Node ID: ${node.id.substring(0, 6)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  Color _getBorderColor(String nodeId, String? sourceNodeId, bool isConnectionMode) {
    if (sourceNodeId == nodeId) {
      return Colors.blue;
    }
    
    if (isConnectionMode) {
      return Colors.purple;
    }
    
    return Colors.grey.shade300;
  }
  
  Widget _buildMethodBadge(String method) {
    return Container(
      padding: CanvasStyles.methodBadgePadding,
      decoration: BoxDecoration(
        color: CanvasStyles.methodBadgeColor(method),
        borderRadius: BorderRadius.circular(CanvasStyles.methodBadgeBorderRadius),
      ),
      child: Text(
        method.toUpperCase(),
        style: CanvasStyles.methodBadgeTextStyle,
      ),
    );
  }
}
