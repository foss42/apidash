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
              opacity: draggedNodeId == node.id 
                  ? CanvasUIConstants.nodeOpacityDragged 
                  : CanvasUIConstants.nodeOpacityDefault,
              child: Material(
                elevation: draggedNodeId == node.id 
                    ? CanvasUIConstants.nodeElevationDragged 
                    : CanvasUIConstants.nodeElevationDefault,
                borderRadius: CanvasStyles.nodeBorderRadius,
                color: Colors.transparent,
                child: Container(
                  width: CanvasUIConstants.nodeWidth * 2,
                  constraints: const BoxConstraints(minHeight: CanvasUIConstants.nodeHeight * 2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: CanvasStyles.getNodeGradient(node.id, sourceNodeId, isConnectionMode),
                    ),
                    border: Border.all(
                      color: CanvasStyles.getBorderColor(node.id, sourceNodeId, isConnectionMode),
                      width: isConnectionMode 
                          ? CanvasUIConstants.nodeBorderWidthActive 
                          : CanvasUIConstants.nodeBorderWidthDefault,
                    ),
                    borderRadius: CanvasStyles.nodeBorderRadius,
                    boxShadow: [CanvasStyles.nodeShadow],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: CanvasUIConstants.nodeHeaderPaddingHorizontal, 
                          vertical: CanvasUIConstants.nodeHeaderPaddingVertical
                        ),
                        decoration: node.nodeType == NodeType.request 
                            ? CanvasStyles.requestHeaderDecoration
                            : CanvasStyles.processingHeaderDecoration,
                        child: Row(
                          children: [
                            Icon(
                              node.nodeType == NodeType.request 
                                  ? Icons.http
                                  : Icons.settings,
                              color: Colors.white,
                              size: CanvasUIConstants.nodeHeaderIconSize,
                            ),
                            SizedBox(width: CanvasUIConstants.nodeHeaderSpacing),
                            Expanded(
                              child: Text(
                                node.label,
                                style: CanvasStyles.nodeHeaderTextStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isConnectionMode)                                 
                              const Icon(
                                Icons.cable_outlined,
                                color: Colors.white,
                                size: CanvasUIConstants.nodeHeaderIconSize,
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(CanvasUIConstants.nodeContentPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (node.nodeType == NodeType.request && node.requestModel != null)
                              Row(
                                children: [
                                  _buildMethodBadge(node.requestModel!.method),
                                  SizedBox(width: CanvasUIConstants.nodeContentSpacing),
                                  Expanded(
                                    child: Text(
                                      node.requestModel!.url.isEmpty 
                                          ? 'No URL specified'
                                          : node.requestModel!.url,
                                      style: CanvasStyles.nodeContentTextStyle,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Text(
                                'Node ID: ${node.id.substring(0, 6)}',
                                style: CanvasStyles.nodeContentTextStyle,
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
  
  Widget _buildMethodBadge(String method) {
    return Container(
      padding: CanvasStyles.methodBadgePadding,
      decoration: BoxDecoration(
        color: CanvasStyles.methodBadgeColor(method),
        borderRadius: CanvasStyles.methodBadgeBorderRadius,
      ),
      child: Text(
        method.toUpperCase(),
        style: CanvasStyles.methodBadgeTextStyle,
      ),
    );
  }
}
