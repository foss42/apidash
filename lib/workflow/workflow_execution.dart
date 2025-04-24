import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/collection_providers.dart';
import 'models/workflow_model.dart';
import 'package:apidash_core/apidash_core.dart';
import 'workflow_provider.dart';

//  provider to access the workflow executor
final workflowExecutorProvider = Provider<WorkflowExecutor>((ref) {
  final workflow = ref.watch(workflowProvider);
  return WorkflowExecutor(
    workflow: workflow,
    ref: ref,
    onLogUpdate: (_) {},
    onNodeChange: (_) {},
    onExecutionFinished: () {},
    onExecutionStarted: () {},
  );
});

class WorkflowExecutor {
  // Callback functions to update UI
  final Function(String) onLogUpdate;
  final Function(WorkflowNode?) onNodeChange;
  final Function() onExecutionFinished;
  final Function() onExecutionStarted;

  // State variables
  bool _isExecuting = false;
  String _executionOutput = '';
  WorkflowNode? _currentExecutingNode;

  // Store execution context/data between nodes
  Map<String, dynamic> _executionContext = {};

  // Reference to Riverpod for accessing providers
  final Ref ref;

  // The workflow being executed
  final Workflow workflow;

  WorkflowExecutor({
    required this.workflow,
    required this.ref,
    required this.onLogUpdate,
    required this.onNodeChange,
    required this.onExecutionFinished,
    required this.onExecutionStarted,
  });

  bool get isExecuting => _isExecuting;
  String get executionOutput => _executionOutput;
  WorkflowNode? get currentExecutingNode => _currentExecutingNode;

  // Starts workflow execution from the start node
  void runWorkflow() {
    _isExecuting = true;
    _executionOutput = '> Starting workflow execution...\n';
    _currentExecutingNode = null;
    _executionContext = {}; // Reset execution context

    // Print workflow details
    _executionOutput += '> Workflow contains ${workflow.nodes.length} nodes and ${workflow.connections.length} connections\n';

    // List all nodes and connections for debugging
    _executionOutput += '> Nodes:\n';
    for (var node in workflow.nodes) {
      _executionOutput += '  - ${node.id}: ${node.name} (${node.type})\n';
    }

    _executionOutput += '> Connections:\n';
    for (var conn in workflow.connections) {
      _executionOutput += '  - ${conn.sourceNodeId} -> ${conn.targetNodeId} (${conn.sourcePort} -> ${conn.targetPort})\n';
    }

    // Notify listeners
    onExecutionStarted();
    onLogUpdate(_executionOutput);
    onNodeChange(_currentExecutingNode);

    try {
      // Find the start node
      final startNode = workflow.nodes.firstWhere(
            (node) => node.type == 'start',
        orElse: () => throw Exception('No start node found'),
      );

      _executionOutput += '> Found start node: ${startNode.id} (${startNode.name})\n';
      onLogUpdate(_executionOutput);

      // Begin execution from the start node
      executeNode(startNode);
    } catch (e) {
      _executionOutput += '> ERROR: ${e.toString()}\n';
      onLogUpdate(_executionOutput);
      stopExecution();
    }
  }

  // Stop the workflow execution
  void stopExecution() {
    _isExecuting = false;
    _executionOutput += '> Execution stopped.\n';
    _currentExecutingNode = null;

    // Notify listeners
    onLogUpdate(_executionOutput);
    onNodeChange(_currentExecutingNode);
    onExecutionFinished();
  }

  // Execute a single node and follow connections
  Future<void> executeNode(WorkflowNode node) async {
    if (!_isExecuting) return; // Stop if execution was canceled

    _currentExecutingNode = node;
    _executionOutput += '> Executing node: ${node.name}\n';

    // Notify UI
    onLogUpdate(_executionOutput);
    onNodeChange(_currentExecutingNode);

    // Add short delay for better visualization
    await Future.delayed(const Duration(milliseconds: 300));

    // Execute based on node type
    try {
      switch (node.type) {
        case 'start':
          _executionOutput += '  Workflow started\n';
          print('start');
          followConnection(node, 'output');
          break;

        case 'request':
          await executeRequestNode(node);
          break;

        case 'condition':
          executeConditionNode(node);
          break;

        case 'transform':
          executeTransformNode(node);
          break;

        default:
          _executionOutput += '  Unknown node type: ${node.type}\n';
          followConnection(node, 'output'); // Default connection
          break;
      }
    } catch (e) {
      _executionOutput += '  ERROR: ${e.toString()}\n';
      onLogUpdate(_executionOutput);
      followConnection(node, 'error'); // Try to follow error path if available
    }

    // If no more nodes to execute, finish workflow
    if (_currentExecutingNode == node && _isExecuting) {
      _executionOutput += '> Workflow execution completed.\n';
      onLogUpdate(_executionOutput);
      stopExecution();
    }
  }

  // Execute a request node using the CollectionStateNotifier
  Future<void> executeRequestNode(WorkflowNode node) async {
    final method = node.data['method'] ?? 'GET';
    final url = node.data['url'] ?? '';

    if (url.isEmpty) {
      _executionOutput += '  ERROR: URL is empty\n';
      followConnection(node, 'error');
      return;
    }

    _executionOutput += '  Making $method request to $url\n';
    onLogUpdate(_executionOutput);

    try {
      //  a temporary request model for this node
      final requestId = node.id;
      final httpRequestModel = HttpRequestModel(
        method: _convertToHTTPVerb(method),
        url: url,
        headers: _getHeadersFromNodeData(node),
        body: node.data['body'] as String? ?? '',
        bodyContentType: _getContentTypeFromNodeData(node),
      );

      // Store current selected ID
      final previousSelectedId = ref.read(selectedIdStateProvider);

      //  a temporary request in the collection
      final collectionNotifier = ref.read(collectionStateNotifierProvider.notifier);

      // Check if the request already exists and update it
      if (collectionNotifier.hasId(requestId)) {
        collectionNotifier.update(
          id: requestId,
          method: httpRequestModel.method,
          url: httpRequestModel.url,
          name: node.name,
          headers: httpRequestModel.headers,
          body: httpRequestModel.body,
          bodyContentType: httpRequestModel.bodyContentType,
        );
      } else {
        // Add the request model to the collection
        collectionNotifier.addRequestModel(
          httpRequestModel,
          name: node.name,
        );
      }

      // Select the node's request
      ref.read(selectedIdStateProvider.notifier).state = requestId;

      // Send the request
      _executionOutput += '  Sending request...\n';
      onLogUpdate(_executionOutput);

      await collectionNotifier.sendRequest();


      // Get the results
      final requestModel = collectionNotifier.getRequestModel(requestId);

      if (requestModel != null && requestModel.responseStatus != null) {
        // Store response in execution context
        _executionContext['lastResponse'] = {
          'status': requestModel.responseStatus,
          'body': requestModel.httpResponseModel?.body,
          'headers': requestModel.httpResponseModel?.headers,
        };

        _executionOutput += '  Request completed with status: ${requestModel.responseStatus}\n';

        if (requestModel.responseStatus! >= 200 && requestModel.responseStatus! < 300) {
          followConnection(node, 'success');
        } else {
          followConnection(node, 'error');
        }
      } else {
        _executionOutput += '  Request failed or was canceled\n';
        followConnection(node, 'error');
      }

      // Restore previous selected ID
      ref.read(selectedIdStateProvider.notifier).state = previousSelectedId;

    } catch (e) {
      _executionOutput += '  ERROR: ${e.toString()}\n';
      followConnection(node, 'error');
    }

    onLogUpdate(_executionOutput);
  }

  // Helper method to convert string to HTTPVerb
  HTTPVerb _convertToHTTPVerb(String method) {
    switch (method.toUpperCase()) {
      case 'GET': return HTTPVerb.get;
      case 'POST': return HTTPVerb.post;
      case 'PUT': return HTTPVerb.put;
      case 'DELETE': return HTTPVerb.delete;
      case 'PATCH': return HTTPVerb.patch;
      case 'HEAD': return HTTPVerb.head;
      // case 'OPTIONS': return HTTPVerb.options;
      default: return HTTPVerb.get;
    }
  }

  // Extract headers from node data
  List<NameValueModel> _getHeadersFromNodeData(WorkflowNode node) {
    final headers = <NameValueModel>[];

    // Extract headers from node.data if available
    if (node.data.containsKey('headers') && node.data['headers'] is List) {
      final headersList = node.data['headers'] as List;
      for (var header in headersList) {
        if (header is Map && header.containsKey('name') && header.containsKey('value')) {
          headers.add(NameValueModel(
            name: header['name'] as String,
            value: header['value'] as String,
          ));
        }
      }
    }

    return headers;
  }

  // Get content type from node data
  ContentType _getContentTypeFromNodeData(WorkflowNode node) {
    final contentTypeStr = node.data['contentType'] as String? ?? 'application/json';

    switch (contentTypeStr) {
      // case 'application/json': return ContentType.json;
      // case 'application/x-www-form-urlencoded': return ContentType.formUrlEncoded;
      // case 'multipart/form-data': return ContentType.multipartForm;
      // case 'application/xml': return ContentType.xml;
      case 'text/plain': return ContentType.text;
      default: return ContentType.json;
    }
  }

  // Execute a condition node
  void executeConditionNode(WorkflowNode node) {
    final condition = node.data['condition'] ?? '';

    if (condition.isEmpty) {
      _executionOutput += '  ERROR: Condition is empty\n';
      followConnection(node, 'false'); // Default to false path
      return;
    }

    _executionOutput += '  Evaluating condition: $condition\n';

    bool result = false;

    try {
      // Handle simple conditions referring to response status
      if (condition.contains('lastResponse') && _executionContext.containsKey('lastResponse')) {
        final lastResponse = _executionContext['lastResponse'] as Map<String, dynamic>;
        final status = lastResponse['status'] as int?;

        // Simple status code check
        if (condition.contains('status') && status != null) {
          if (condition.contains('status == 200')) {
            result = status == 200;
          } else if (condition.contains('status >= 200') && condition.contains('status < 300')) {
            result = status >= 200 && status < 300;
          } else if (condition.contains('status >= 400')) {
            result = status >= 400;
          }
        }
      } else {
        // For demo, allow simple true/false conditions
        result = condition.toLowerCase().contains('true');
      }

      _executionOutput += '  Result: ${result ? 'TRUE' : 'FALSE'}\n';
      followConnection(node, result ? 'true' : 'false');

    } catch (e) {
      _executionOutput += '  ERROR evaluating condition: ${e.toString()}\n';
      followConnection(node, 'false'); // Default to false on error
    }
  }

  // Execute a transform node
  void executeTransformNode(WorkflowNode node) {
    final transform = node.data['transform'] ?? '';

    if (transform.isEmpty) {
      _executionOutput += '  ERROR: Transform expression is empty\n';
      followConnection(node, 'output');
      return;
    }

    _executionOutput += '  Applying transformation: $transform\n';

    try {
      // Example transformation logic - parse JSON response if available
      if (transform.contains('parseJson') && _executionContext.containsKey('lastResponse')) {
        final lastResponse = _executionContext['lastResponse'] as Map<String, dynamic>;
        final responseBody = lastResponse['body'] as String?;

        if (responseBody != null && responseBody.isNotEmpty) {
          try {
            // This would be where you'd actually parse the JSON
            _executionOutput += '  Successfully parsed response JSON\n';
          } catch (e) {
            _executionOutput += '  Failed to parse JSON: ${e.toString()}\n';
          }
        } else {
          _executionOutput += '  No response body to transform\n';
        }
      } else {
        _executionOutput += '  Transformation applied (simulated)\n';
      }

      followConnection(node, 'output');

    } catch (e) {
      _executionOutput += '  ERROR in transformation: ${e.toString()}\n';
      followConnection(node, 'error');
    }
  }

  // Modify your followConnection method to log more details
  // Follow connection to the next node
  void followConnection(WorkflowNode sourceNode, String outputPort) {
    if (!_isExecuting) return;

    // Add debug prints
    _executionOutput += '  Looking for connections from node ${sourceNode.id} with output port: $outputPort\n';

    // Log all available connections for debugging
    _executionOutput += '  Available connections: ${workflow.connections.length}\n';
    for (var conn in workflow.connections) {
      _executionOutput += '    Connection: ${conn.sourceNodeId} -> ${conn.targetNodeId} (port: ${conn.sourcePort})\n';
    }

    // Find connection(s) from this node's output port
    final connections = workflow.connections.where(
            (conn) => conn.sourceNodeId == sourceNode.id && conn.sourcePort == outputPort
    ).toList();

    if (connections.isEmpty) {
      _executionOutput += '  No connection found from output: $outputPort\n';
      // Try with default port if specific port fails
      if (outputPort != 'output') {
        _executionOutput += '  Trying with default output port...\n';
        followConnection(sourceNode, 'output');
        return;
      }
      onLogUpdate(_executionOutput);
      return;
    }
    // For each connection, find the target node and execute it
    for (final conn in connections) {
      try {
        final targetNode = workflow.nodes.firstWhere(
              (node) => node.id == conn.targetNodeId,
          orElse: () => throw Exception('Target node not found for connection'),
        );

        executeNode(targetNode);
      } catch (e) {
        _executionOutput += '  ERROR: ${e.toString()}\n';
        onLogUpdate(_executionOutput);
      }
    }
  }


  // Clear execution logs
  void clearLogs() {
    _executionOutput = '';
    onLogUpdate(_executionOutput);
  }
}