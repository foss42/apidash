import 'package:apidash/models/models.dart';
import 'package:apidash/screens/workflow/workflow_canvas_constants.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_node_flow/vyuh_node_flow.dart';

String linkedRequestPanelLabel(
  WorkflowNodeData data,
  Map<String, RequestModel> requests,
) {
  final id = data.linkedRequestId;
  if (id == null || id.isEmpty) return 'Find or create request';
  final req = requests[id];
  if (req == null) return id;
  final name = req.name.trim();
  return name.isEmpty ? id : name;
}

class WorkflowNodeWidget extends StatelessWidget {
  const WorkflowNodeWidget({
    super.key,
    required this.node,
    required this.availableRequests,
    required this.isRunning,
    required this.isSuccess,
    required this.isSelected,
    required this.onTap,
    required this.onDuplicate,
    required this.onDelete,
  });

  final Node<WorkflowNodeData> node;
  final Map<String, RequestModel> availableRequests;
  final bool isRunning;
  final bool? isSuccess;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final d = node.data;
    Color bg = theme.colorScheme.surfaceContainerHigh;
    IconData icon = Icons.circle;
    final label =
        d.label.isEmpty ? workflowDefaultNodeLabel(d.nodeType) : d.label;

    if (isRunning) {
      bg = theme.colorScheme.primaryContainer;
      icon = Icons.hourglass_empty;
    } else if (isSuccess == true) {
      bg = theme.colorScheme.primaryContainer;
      icon = Icons.check_circle;
    } else if (isSuccess == false) {
      bg = theme.colorScheme.errorContainer;
      icon = Icons.error;
    } else {
      switch (d.nodeType) {
        case WorkflowNodeType.start:
          bg = theme.colorScheme.tertiaryContainer;
          icon = Icons.play_arrow;
          break;
        case WorkflowNodeType.request:
          bg = theme.colorScheme.secondaryContainer;
          icon = Icons.http;
          break;
        case WorkflowNodeType.variable:
          bg = theme.colorScheme.primaryContainer;
          icon = Icons.data_object;
          break;
        case WorkflowNodeType.end:
          bg = theme.colorScheme.surfaceContainerHigh;
          icon = Icons.stop_circle;
          break;
        case WorkflowNodeType.condition:
          bg = theme.colorScheme.tertiaryContainer;
          icon = Icons.rule;
          break;
        case WorkflowNodeType.transform:
          bg = theme.colorScheme.secondaryContainer;
          icon = Icons.transform;
          break;
        case WorkflowNodeType.delay:
          bg = theme.colorScheme.surfaceContainerHighest;
          icon = Icons.timer_outlined;
          break;
        case WorkflowNodeType.loop:
          bg = theme.colorScheme.tertiaryContainer;
          icon = Icons.loop;
          break;
      }
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: node.size.value.width,
            height: node.size.value.height,
            child: Container(
              constraints: BoxConstraints(
                minWidth:
                    d.nodeType == WorkflowNodeType.request ? kRequestNodeWidth : 150,
                minHeight:
                    d.nodeType == WorkflowNodeType.request ? kRequestNodeHeight : 80,
              ),
              padding: d.nodeType == WorkflowNodeType.request
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : isRunning
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: isSelected || isRunning ? 2 : 1,
                ),
              ),
              child: d.nodeType == WorkflowNodeType.request
                  ? WorkflowHttpRequestNodeCard(
                      icon: icon,
                      title: label == 'Request' ? 'HTTP Request' : label,
                      linkedRequestLabel:
                          linkedRequestPanelLabel(d, availableRequests),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 22, color: theme.colorScheme.onSurface),
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: theme.textTheme.titleSmall,
                        ),
                      ],
                    ),
            ),
          ),
        ),
        if (isSelected)
          Positioned(
            top: 0,
            right: 6,
            child: Material(
              color: theme.colorScheme.surfaceContainerHighest,
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Duplicate',
                    iconSize: 14,
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    visualDensity: VisualDensity.compact,
                    onPressed: onDuplicate,
                    icon: const Icon(Icons.copy_outlined),
                  ),
                  IconButton(
                    tooltip: 'Delete',
                    iconSize: 14,
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    visualDensity: VisualDensity.compact,
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class WorkflowHttpRequestNodeCard extends StatelessWidget {
  const WorkflowHttpRequestNodeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.linkedRequestLabel,
  });

  final IconData icon;
  final String title;
  final String linkedRequestLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: kRequestNodeWidth,
      height: kRequestNodeHeight,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 20, color: theme.colorScheme.onSurface),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(fontSize: 8),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    linkedRequestLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 12,
            top: kRequestPortSendY - 8,
            child: Text(
              'Send',
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 8),
            ),
          ),
          Positioned(
            right: 12,
            top: kRequestPortSuccessY - 8,
            child: Text(
              'Success()',
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 8),
            ),
          ),
          Positioned(
            right: 12,
            top: kRequestPortFailY - 8,
            child: Text(
              'Fail()',
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 8),
            ),
          ),
        ],
      ),
    );
  }
}
