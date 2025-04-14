import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../workflow_providers.dart';

class NodeDetailsPanel extends ConsumerWidget {
  final WorkflowNodeModel node;
  final String workflowId;

  const NodeDetailsPanel({
    Key? key,
    required this.node,
    required this.workflowId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 320,
      color: const Color(0xFF212121),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, ref),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNodeTypeSection(ref),
                  const SizedBox(height: 16),
                  _buildNodeDetailsSection(ref),
                  const SizedBox(height: 16),
                  if (node.nodeType == NodeType.request)
                    _buildRequestDetailsSection(ref),
                  if (node.nodeType == NodeType.condition)
                    _buildConditionDetailsSection(ref),
                  if (node.nodeType == NodeType.action)
                    _buildActionDetailsSection(ref),
                  if (node.nodeType == NodeType.response)
                    _buildResponseDetailsSection(ref),
                  const SizedBox(height: 24),
                  _buildDependenciesSection(ref),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: node.status.color.withOpacity(0.2),
        border: Border(
          bottom: BorderSide(
            color: node.status.color.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getNodeTypeIcon(),
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  node.label.isEmpty ? 'Node ${node.id.substring(0, 4)}' : node.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getNodeTypeText(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              ref.read(selectedNodeIdProvider.notifier).state = null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNodeTypeSection(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Node Type',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<NodeType>(
          value: node.nodeType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
          dropdownColor: Colors.grey[800],
          items: NodeType.values.map((type) {
            return DropdownMenuItem<NodeType>(
              value: type,
              child: Text(_getNodeTypeText(type)),
            );
          }).toList(),
          onChanged: (NodeType? newValue) {
            if (newValue != null) {
              ref.read(workflowsNotifierProvider.notifier).updateNode(
                    workflowId,
                    node.copyWith(nodeType: newValue),
                  );
            }
          },
        ),
      ],
    );
  }

  Widget _buildNodeDetailsSection(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Node Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: node.label,
          decoration: InputDecoration(
            labelText: 'Label',
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            labelStyle: TextStyle(color: Colors.grey[400]),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            ref.read(workflowsNotifierProvider.notifier).updateNode(
                  workflowId,
                  node.copyWith(label: value),
                );
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              'Status: ${_getStatusText(node.status)}',
              style: TextStyle(
                color: node.status.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                final nextStatus = _getNextStatus(node.status);
                ref.read(workflowsNotifierProvider.notifier).updateNodeStatus(
                      workflowId,
                      node.id,
                      nextStatus,
                    );
              },
              tooltip: 'Cycle status (testing only)',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRequestDetailsSection(WidgetRef ref) {
    final requestModel = node.requestModel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'API Request Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: requestModel?.method ?? 'GET',
          decoration: InputDecoration(
            labelText: 'Method',
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            labelStyle: TextStyle(color: Colors.grey[400]),
          ),
          style: const TextStyle(color: Colors.white),
          dropdownColor: Colors.grey[800],
          items: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'].map((method) {
            return DropdownMenuItem<String>(
              value: method,
              child: Text(method),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null && requestModel != null) {
              final updatedRequest = requestModel.copyWith(method: newValue);
              ref.read(workflowsNotifierProvider.notifier).updateNode(
                    workflowId,
                    node.copyWith(requestModel: updatedRequest),
                  );
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: requestModel?.url ?? '',
          decoration: InputDecoration(
            labelText: 'URL',
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            labelStyle: TextStyle(color: Colors.grey[400]),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            if (requestModel != null) {
              final updatedRequest = requestModel.copyWith(url: value);
              ref.read(workflowsNotifierProvider.notifier).updateNode(
                    workflowId,
                    node.copyWith(requestModel: updatedRequest),
                  );
            }
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(Icons.edit, size: 16),
          label: const Text('Edit Full Request'),
          onPressed: () {
            ScaffoldMessenger.of(ref.context).showSnackBar(
              const SnackBar(
                content: Text('Full request editor to be implemented'),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildConditionDetailsSection(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Condition Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: node.nodeData['condition'] as String? ?? '',
          decoration: InputDecoration(
            labelText: 'Condition Expression',
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            labelStyle: TextStyle(color: Colors.grey[400]),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            final updatedData = Map<String, dynamic>.from(node.nodeData);
            updatedData['condition'] = value;
            ref.read(workflowsNotifierProvider.notifier).updateNode(
                  workflowId,
                  node.copyWith(nodeData: updatedData),
                );
          },
        ),
        const SizedBox(height: 8),
        const Text(
          'Examples: statusCode == 200 | response.body.contains("success")',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActionDetailsSection(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Action Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: node.nodeData['actionType'] as String? ?? 'transform',
          decoration: InputDecoration(
            labelText: 'Action Type',
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            labelStyle: TextStyle(color: Colors.grey[400]),
          ),
          style: const TextStyle(color: Colors.white),
          dropdownColor: Colors.grey[800],
          items: ['transform', 'delay', 'notify', 'log'].map((actionType) {
            return DropdownMenuItem<String>(
              value: actionType,
              child: Text(actionType.toUpperCase()),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              final updatedData = Map<String, dynamic>.from(node.nodeData);
              updatedData['actionType'] = newValue;
              ref.read(workflowsNotifierProvider.notifier).updateNode(
                    workflowId,
                    node.copyWith(nodeData: updatedData),
                  );
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: node.nodeData['actionConfig'] as String? ?? '',
          decoration: InputDecoration(
            labelText: 'Action Configuration',
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            labelStyle: TextStyle(color: Colors.grey[400]),
          ),
          style: const TextStyle(color: Colors.white),
          maxLines: 3,
          onChanged: (value) {
            final updatedData = Map<String, dynamic>.from(node.nodeData);
            updatedData['actionConfig'] = value;
            ref.read(workflowsNotifierProvider.notifier).updateNode(
                  workflowId,
                  node.copyWith(nodeData: updatedData),
                );
          },
        ),
      ],
    );
  }

  Widget _buildResponseDetailsSection(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Response Simulation',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: node.simulatedStatusCode.toString(),
          decoration: InputDecoration(
            labelText: 'Simulated Status Code',
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            labelStyle: TextStyle(color: Colors.grey[400]),
          ),
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final statusCode = int.tryParse(value) ?? 200;
            ref.read(workflowsNotifierProvider.notifier).updateNode(
                  workflowId,
                  node.copyWith(simulatedStatusCode: statusCode),
                );
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: node.simulatedResponse['body'] as String? ?? '',
          decoration: InputDecoration(
            labelText: 'Simulated Response Body',
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            labelStyle: TextStyle(color: Colors.grey[400]),
          ),
          style: const TextStyle(color: Colors.white),
          maxLines: 5,
          onChanged: (value) {
            final updatedResponse = Map<String, dynamic>.from(node.simulatedResponse);
            updatedResponse['body'] = value;
            ref.read(workflowsNotifierProvider.notifier).updateNode(
                  workflowId,
                  node.copyWith(simulatedResponse: updatedResponse),
                );
          },
        ),
      ],
    );
  }

  Widget _buildDependenciesSection(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dependencies',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        node.connections.isEmpty
            ? const Text(
                'No connections',
                style: TextStyle(color: Colors.grey),
              )
            : Column(
                children: node.connections.map((connection) {
                  return _buildConnectionItem(ref, connection);
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildConnectionItem(WidgetRef ref, WorkflowConnectionModel connection) {
    final workflows = ref.watch(workflowsNotifierProvider);
    final workflowModel = workflows.firstWhere(
      (w) => w.id == workflowId,
      orElse: () => throw Exception('Workflow not found'),
    );

    String getNodeLabel(String nodeId) {
      try {
        final connectedNode = workflowModel.nodes.firstWhere(
          (n) => n.id == nodeId,
          orElse: () => throw Exception('Node not found'),
        );
        return connectedNode.label.isEmpty
            ? 'Node ${connectedNode.id.substring(0, 4)}'
            : connectedNode.label;
      } catch (e) {
        return 'Unknown Node';
      }
    }

    final sourceLabel = getNodeLabel(connection.sourceId);
    final targetLabel = getNodeLabel(connection.targetId);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.grey[850],
      child: ListTile(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: sourceLabel,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(
                text: ' ➝ ',
                style: TextStyle(color: Colors.grey),
              ),
              TextSpan(
                text: targetLabel,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            ref.read(workflowsNotifierProvider.notifier).removeConnection(
                  workflowId,
                  connection.id,
                );
          },
        ),
      ),
    );
  }

  IconData _getNodeTypeIcon() {
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

  String _getNodeTypeText([NodeType? type]) {
    final nodeType = type ?? node.nodeType;
    switch (nodeType) {
      case NodeType.request:
        return 'API Request';
      case NodeType.response:
        return 'Response Simulation';
      case NodeType.condition:
        return 'Conditional Logic';
      case NodeType.action:
        return 'Action Node';
    }
  }

  String _getStatusText(NodeStatus status) {
    switch (status) {
      case NodeStatus.inactive:
        return 'Inactive';
      case NodeStatus.running:
        return 'Running';
      case NodeStatus.success:
        return 'Success';
      case NodeStatus.failure:
        return 'Failed';
      case NodeStatus.pending:
        return 'Pending';
    }
  }

  NodeStatus _getNextStatus(NodeStatus current) {
    switch (current) {
      case NodeStatus.inactive:
        return NodeStatus.pending;
      case NodeStatus.pending:
        return NodeStatus.running;
      case NodeStatus.running:
        return NodeStatus.success;
      case NodeStatus.success:
        return NodeStatus.failure;
      case NodeStatus.failure:
        return NodeStatus.inactive;
    }
  }
}
