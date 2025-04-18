import 'package:api_testing_suite/src/workflow_builder/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/workflow_node_model.dart';
import '../models/node_type.dart';

/// Node execution settings
class NodeExecutionSettings {
  final bool parallel;
  final int retries;
  final Duration timeout;

  const NodeExecutionSettings({
    this.parallel = false,
    this.retries = 0,
    this.timeout = const Duration(seconds: 30),
  });
}

class NodeDetailsPanel extends ConsumerWidget {
  final WorkflowNodeModel node;
  final String workflowId;

  const NodeDetailsPanel({
    super.key,
    required this.node,
    required this.workflowId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 300,
      decoration: const BoxDecoration(
        color: Color(0xFF212121),
        border: Border(
          left: BorderSide(color: Color(0xFF333333)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(ref),
          Expanded(
            child: _buildNodeEditor(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(WidgetRef ref) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF272727),
        border: Border(bottom: BorderSide(color: Color(0xFF333333))),
      ),
      child: Row(
        children: [
          const Text(
            'Node Properties',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white54, size: 20),
            onPressed: () {
              ref.read(selectedNodeIdProvider.notifier).state = null;
            },
            tooltip: 'Close panel',
          ),
        ],
      ),
    );
  }

  Widget _buildNodeEditor(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(workflowsNotifierProvider.notifier);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Basic Information'),
            _buildTextField(
              label: 'Label',
              initialValue: node.label,
              onChanged: (value) {
                notifier.updateNode(
                  workflowId,
                  node.copyWith(label: value),
                );
              },
            ),
            const SizedBox(height: 16),
            if (node.nodeType == NodeType.request) ...[
              _buildSectionTitle('Request Details'),
              _buildRequestEditor(context, ref),
            ] else if (node.nodeType == NodeType.condition) ...[
              _buildSectionTitle('Condition Settings'),
              _buildConditionEditor(context, ref),
            ] else if (node.nodeType == NodeType.action) ...[
              _buildSectionTitle('Action Settings'),
              _buildActionEditor(context, ref),
            ],
            const SizedBox(height: 24),
            _buildSectionTitle('Execution Settings'),
            _buildExecutionSettings(context, ref),
            const SizedBox(height: 24),
            _buildDependenciesSection(ref),
            const SizedBox(height: 24),
            _buildResponseDetailsSection(ref),
            const SizedBox(height: 24),
            _buildDeleteButton(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
    bool isMultiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            initialValue: initialValue,
            onChanged: onChanged,
            maxLines: isMultiline ? 5 : 1,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF333333),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide.none,
              ),
              hintStyle: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestEditor(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: 'URL',
          initialValue: node.nodeData['url'] ?? '',
          onChanged: (value) {
            final updatedNodeData = Map<String, dynamic>.from(node.nodeData);
            updatedNodeData['url'] = value;
            final notifier = ref.read(workflowsNotifierProvider.notifier);
            notifier.updateNode(
              workflowId,
              node.copyWith(nodeData: updatedNodeData),
            );
          },
        ),
        _buildDropdown(
          label: 'Method',
          value: node.nodeData['method'] ?? 'GET',
          items: const ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'HEAD'],
          onChanged: (value) {
            final notifier = ref.read(workflowsNotifierProvider.notifier);
            final updatedNodeData = Map<String, dynamic>.from(node.nodeData);
            updatedNodeData['method'] = value;
            notifier.updateNode(
              workflowId,
              node.copyWith(nodeData: updatedNodeData),
            );
          },
        ),
        _buildTextField(
          label: 'Request Body',
          initialValue: node.nodeData['body'] ?? '',
          onChanged: (value) {
            final notifier = ref.read(workflowsNotifierProvider.notifier);
            final updatedNodeData = Map<String, dynamic>.from(node.nodeData);
            updatedNodeData['body'] = value;
            notifier.updateNode(
              workflowId,
              node.copyWith(nodeData: updatedNodeData),
            );
          },
          isMultiline: true,
        ),
      ],
    );
  }

  Widget _buildConditionEditor(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: 'Condition Expression',
          initialValue: node.nodeData['condition'] ?? '',
          onChanged: (value) {
            final notifier = ref.read(workflowsNotifierProvider.notifier);
            final updatedNodeData = Map<String, dynamic>.from(node.nodeData);
            updatedNodeData['condition'] = value;
            notifier.updateNode(
              workflowId,
              node.copyWith(nodeData: updatedNodeData),
            );
          },
          isMultiline: true,
        ),
      ],
    );
  }

  Widget _buildActionEditor(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdown(
          label: 'Action Type',
          value: node.nodeData['actionType'] ?? 'transform',
          items: const ['transform', 'dataStore', 'logger'],
          onChanged: (value) {
            final notifier = ref.read(workflowsNotifierProvider.notifier);
            final updatedNodeData = Map<String, dynamic>.from(node.nodeData);
            updatedNodeData['actionType'] = value;
            notifier.updateNode(
              workflowId,
              node.copyWith(nodeData: updatedNodeData),
            );
          },
        ),
        _buildTextField(
          label: 'Action Configuration',
          initialValue: node.nodeData['actionConfig'] ?? '',
          onChanged: (value) {
            final notifier = ref.read(workflowsNotifierProvider.notifier);
            final updatedNodeData = Map<String, dynamic>.from(node.nodeData);
            updatedNodeData['actionConfig'] = value;
            notifier.updateNode(
              workflowId,
              node.copyWith(nodeData: updatedNodeData),
            );
          },
          isMultiline: true,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                onChanged: onChanged,
                isExpanded: true,
                dropdownColor: const Color(0xFF333333),
                style: const TextStyle(color: Colors.white),
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExecutionSettings(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdown(
          label: 'Retry Strategy',
          value: node.nodeData['retryStrategy'] ?? 'none',
          items: const ['none', 'fixed', 'exponential'],
          onChanged: (value) {
            final notifier = ref.read(workflowsNotifierProvider.notifier);
            final updatedNodeData = Map<String, dynamic>.from(node.nodeData);
            updatedNodeData['retryStrategy'] = value;
            notifier.updateNode(
              workflowId,
              node.copyWith(nodeData: updatedNodeData),
            );
          },
        ),
        if (node.nodeData['retryStrategy'] != 'none')
          _buildTextField(
            label: 'Max Retries',
            initialValue: node.nodeData['maxRetries']?.toString() ?? '3',
            onChanged: (value) {
              final notifier = ref.read(workflowsNotifierProvider.notifier);
              final updatedNodeData = Map<String, dynamic>.from(node.nodeData);
              updatedNodeData['maxRetries'] = int.tryParse(value) ?? 3;
              notifier.updateNode(
                workflowId,
                node.copyWith(nodeData: updatedNodeData),
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
        _buildTextField(
          label: 'Dependent Nodes',
          initialValue: (node.nodeData['dependencies'] as List<String>?)?.join(', ') ?? '',
          onChanged: (value) {
            final notifier = ref.read(workflowsNotifierProvider.notifier);
            final updatedData = Map<String, dynamic>.from(node.nodeData);
            updatedData['dependencies'] = value.split(',').map((e) => e.trim()).toList();
            notifier.updateNode(
              workflowId,
              node.copyWith(nodeData: updatedData),
            );
          },
          isMultiline: true,
        ),
      ],
    );
  }

  Widget _buildResponseDetailsSection(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Response Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          label: 'Response Handler',
          initialValue: node.nodeData['handler'] as String? ?? '',
          onChanged: (value) {
            final notifier = ref.read(workflowsNotifierProvider.notifier);
            final updatedData = Map<String, dynamic>.from(node.nodeData);
            updatedData['handler'] = value;
            notifier.updateNode(
              workflowId,
              node.copyWith(nodeData: updatedData),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDeleteButton(BuildContext context, WidgetRef ref) {
    return Center(
      child: TextButton.icon(
        icon: const Icon(Icons.delete, color: Colors.red),
        label: const Text('Delete Node', style: TextStyle(color: Colors.red)),
        onPressed: () {
          ref.read(workflowsNotifierProvider.notifier).removeNode(
                workflowId,
                node.id,
              );
          ref.read(selectedNodeIdProvider.notifier).state = null;
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}
