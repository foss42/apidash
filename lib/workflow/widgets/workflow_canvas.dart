import 'package:flutter/material.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workflow_model.dart';
import '../workflow_provider.dart';
import '../workflow_execution.dart';

class WorkflowCanvas extends ConsumerStatefulWidget {
  final Workflow workflow;
  final Function(Workflow) onWorkflowChanged;

  const WorkflowCanvas({
    Key? key,
    required this.workflow,
    required this.onWorkflowChanged,
  }) : super(key: key);

  @override
  ConsumerState<WorkflowCanvas> createState() => _WorkflowCanvasState();
}

class _WorkflowCanvasState extends ConsumerState<WorkflowCanvas> {
  late Dashboard _dashboard;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _methodController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _transformController = TextEditingController();

  // Workflow executor
   late WorkflowExecutor _executor;

  // Map to track node IDs to FlowElements
  final Map<String, FlowElement> _nodeToElementMap = {};

  @override
  void initState() {
    super.initState();
    _initializeExecutor();
    _initializeDashboard();
  }


  void _initializeExecutor() {

    // Since we can't directly pass WidgetRef to WorkflowExecutor, we'll create a
    // custom factory method in our widget to handle this incompatibility

    final workflow = widget.workflow;

    // Create an adapter function to handle the ref mismatch
    _executor = createWorkflowExecutor(
      workflow: workflow,
      widgetRef: ref,
      onLogUpdate: (log) {
        setState(() {});
      },
      onNodeChange: (node) {
        setState(() {
          if (node != null) {
            // Refresh dashboard to update node appearance
            _initializeDashboard();
          }
        });
      },
      onExecutionFinished: () {
        setState(() {
          // Reset dashboard to clear highlighting
          _initializeDashboard();
        });
      },
       onExecutionStarted: () {
      //   setState(() {});
       },
    );
  }

  // Factory method to bridge the gap between WidgetRef and Ref<Object?>
  WorkflowExecutor createWorkflowExecutor({
    required Workflow workflow,
    required WidgetRef widgetRef,
    required Function(String) onLogUpdate,
    required Function(WorkflowNode?) onNodeChange,
    required Function() onExecutionFinished,
    required Function() onExecutionStarted,
  }) {
    // This is where you would access any providers you need via widgetRef
    // and then create the WorkflowExecutor without passing the ref directly

    return WorkflowExecutor(
      workflow: workflow,
      ref: widgetRef.read(workflowExecutorProvider).ref,
      onLogUpdate: onLogUpdate,
      onNodeChange: onNodeChange,
      onExecutionFinished: onExecutionFinished,
      onExecutionStarted: onExecutionStarted,
    );
  }


  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _methodController.dispose();
    _conditionController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(WorkflowCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("UPDATED WIDGET: old nodes: ${oldWidget.workflow.nodes.length}, new nodes: ${widget.workflow.nodes.length}");

    // Update the executor with the new workflow when it changes

    if (widget.workflow != oldWidget.workflow) {
      _initializeExecutor();
    }

    // Print the full details of each node
    print("New workflow nodes details:");
    for (var node in widget.workflow.nodes) {
      print("Node ID: ${node.id}, Name: ${node.name}, Type: ${node.type}, Position: ${node.data['position']}");
    }

    // Check if the workflow actually changed by comparing IDs of nodes
    bool hasChanged = false;
    if (widget.workflow.nodes.length != oldWidget.workflow.nodes.length) {
      hasChanged = true;
      print("Node count changed - reinitializing dashboard");
    } else {
      // Check if any node has been modified
      for (int i = 0; i < widget.workflow.nodes.length; i++) {
        if (widget.workflow.nodes[i].id != oldWidget.workflow.nodes[i].id) {
          hasChanged = true;
          print("Node ID changed at index $i - reinitializing dashboard");
          break;
        }
      }
    }

    if (hasChanged) {
      _initializeDashboard();
      setState(() {});
      print('Canvas updated with ${_dashboard.elements.length} elements');

      // Print dashboard elements for debugging
      print("Dashboard elements:");
      for (var element in _dashboard.elements) {
        print("Element Text: ${element.text}");
        // Print the associated node ID if we can find it
        final nodeId = _findNodeIdForElement(element);
        if (nodeId != null) {
          print("  -> Associated Node ID: $nodeId");
        }
      }
    }
  }

  void _updateNodePosition(WorkflowNode node, Offset position) {
    final updatedNode = node.copyWith(
      data: {
        ...node.data,
        'position': {'x': position.dx, 'y': position.dy}
      },
    );

    // Update in provider
    ref.read(workflowProvider.notifier).updateNode(updatedNode);

    // Recreate the element with new position
    _recreateElementForNode(updatedNode);
  }

  String? _findNodeIdForElement(FlowElement element) {
    for (var entry in _nodeToElementMap.entries) {
      if (entry.value == element) {
        return entry.key;
      }
    }
    return null;
  }

  void _initializeDashboard() {
    // Create a new dashboard
    _dashboard = Dashboard(
      defaultArrowStyle: ArrowStyle.curve,
      minimumZoomFactor: 1.25,
    );

    // Clear the map
    _nodeToElementMap.clear();

    print("INITIALIZING DASHBOARD: Adding ${widget.workflow.nodes.length} elements");

    // Add elements from workflow model
    for (final node in widget.workflow.nodes) {
      final element = _createFlowElement(node);
      print("Adding element for node: ID=${node.id}, Name=${node.name}, Position=${node.data['position']}");
      _dashboard.addElement(element);

      // Store the mapping
      _nodeToElementMap[node.id] = element;
    }

    // Add connections from workflow model
    for (final conn in widget.workflow.connections) {
      print(widget.workflow.connections);
      _addConnectionToDashboard(conn);
    }

    // Verify elements were added
    print("Dashboard now has ${_dashboard.elements.length} elements");
    print("Element map has ${_nodeToElementMap.length} entries");
    print(_nodeToElementMap);
  }

  FlowElement _createFlowElement(WorkflowNode node) {
    final position = node.data.containsKey('position')
        ? Offset(
      (node.data['position'] as Map)['x'] ?? 100.0,
      (node.data['position'] as Map)['y'] ?? 100.0,
    )
        : const Offset(100, 100);



    return FlowElement(
      position: position,
      size: const Size(180, 80),
      text: node.name,
      kind: _getElementKindForNode(node),
      data: node, // Store node in the data field
      handlers: _getHandlersForNode(node),
      handlerSize: 20,
      backgroundColor: Colors.white,
      borderColor: Colors.blue,
      borderThickness: 2,
    );
  }

  void _addConnectionToDashboard(WorkflowConnection conn) {
    try {
      print("Adding connection: ${conn.sourceNodeId} -> ${conn.targetNodeId}");

      final sourceElement = _nodeToElementMap[conn.sourceNodeId];
      if (sourceElement == null) {
        print("Source element not found with ID: ${conn.sourceNodeId}");
        print("Available node IDs: ${_nodeToElementMap.keys.toList()}");
        return;
      }

      final targetElement = _nodeToElementMap[conn.targetNodeId];
      if (targetElement == null) {
        print("Target element not found with ID: ${conn.targetNodeId}");
        print("Available node IDs: ${_nodeToElementMap.keys.toList()}");
        return;
      }

      // Use the direct element reference instead of ID
      _dashboard.addNextById(
        sourceElement,
        targetElement.id,
        ArrowParams(
          thickness: 2,
          color: Colors.blue,
          startArrowPosition: Alignment.centerRight,
          endArrowPosition: Alignment.centerLeft,
        ),
      );

      print("Connection added successfully");
    } catch (e) {
      print('Error adding connection: $e');
    }
  }

  List<Handler> _getHandlersForNode(WorkflowNode node) {
    List<Handler> handlers = [];

    if (node.inputs.isNotEmpty) {
      handlers.add(Handler.leftCenter);
    }

    if (node.outputs.isNotEmpty) {
      handlers.add(Handler.rightCenter);
    }

    // Add top and bottom handlers
    if (node.type == 'condition') {
      handlers.add(Handler.topCenter);
      handlers.add(Handler.bottomCenter);
    }

    return handlers;
  }

  ElementKind _getElementKindForNode(WorkflowNode node) {
    switch (node.type) {
      case 'start':
        return ElementKind.oval;
      case 'request':
        return ElementKind.rectangle;
      case 'condition':
        return ElementKind.diamond;
      case 'group':
        return ElementKind.hexagon;
      case 'transform':
        return ElementKind.rectangle;
      default:
        return ElementKind.rectangle;
    }
  }

  @override
  Widget build(BuildContext context) {

    final selectedNode = ref.watch(selectedNodeProvider);

    // Update controller values when selected node changes
    if (selectedNode != null) {
      _updateControllers(selectedNode);
    }

    return Expanded(
      child: Stack(
        children: [
          Positioned.fill(
            child: FlowChart(
              dashboard: _dashboard,
              onElementPressed: (context, position, element) {
                if (element.data is WorkflowNode) {
                  final node = element.data as WorkflowNode;

                  if (node.data.containsKey('position')) {
                    Map posMap = node.data['position'] as Map;
                    Offset currentPos = Offset(posMap['x'] ?? 0.0, posMap['y'] ?? 0.0);
                    if (currentPos != element.position) {
                      _updateNodePosition(node, element.position);
                    }
                  }

                  ref.read(selectedNodeProvider.notifier).state = node;
                }
              },
              onDashboardTapped: (context, position) {
                ref.read(selectedNodeProvider.notifier).state = null;
              },
              onNewConnection: _handleConnectionCreated,
            ),
          ),
          if (selectedNode != null) _buildPropertiesPanel(selectedNode),


          Positioned(
            right: 16,
            top: 16,
            child: ElevatedButton.icon(
              icon: Icon(_executor.isExecuting ? Icons.stop : Icons.play_arrow),
              label: Text(_executor.isExecuting ? 'Stop' : 'Run Workflow'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _executor.isExecuting ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: _executor.isExecuting ? _stopExecution : _runWorkflow,
            ),
          ),


          // Execution output panel

          if (_executor.isExecuting || _executor.executionOutput.isNotEmpty)
            Positioned(
              left: 16,
              bottom: 16,
              right: 16,
              child: Container(
                height: 120,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Execution Log',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            _executor.clearLogs();
                            setState(() {});
                          },
                          iconSize: 16,
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          _executor.executionOutput,
                          style: TextStyle(color: Colors.green, fontFamily: 'monospace'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),


          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              mini: true,
              onPressed: _dashboard.recenter,
              child: const Icon(Icons.center_focus_strong),
            ),
          ),

          // Debug refresh button
          Positioned(
            right: 16,
            bottom: 80,
            child: FloatingActionButton(
              mini: true,
              onPressed: () {
                // Force refresh the dashboard
                setState(() {
                  _initializeDashboard();
                });
                print("Dashboard refreshed manually");
              },
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }

  // Update controller values when the selected node changes
  void _updateControllers(WorkflowNode node) {
    // Only update if text is different to avoid cursor jumping
    if (_nameController.text != node.name) {
      _nameController.text = node.name;
    }

    // Update other controllers based on node type
    if (node.type == 'request') {
      final url = node.data['url'] as String? ?? '';
      final method = node.data['method'] as String? ?? 'GET';

      if (_urlController.text != url) {
        _urlController.text = url;
      }

      if (_methodController.text != method) {
        _methodController.text = method;
      }
    } else if (node.type == 'condition') {
      final condition = node.data['condition'] as String? ?? '';
      if (_conditionController.text != condition) {
        _conditionController.text = condition;
      }
    } else if (node.type == 'transform') {
      final transform = node.data['transform'] as String? ?? '';
      if (_transformController.text != transform) {
        _transformController.text = transform;
      }
    }
  }

  Widget _buildPropertiesPanel(WorkflowNode node) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Node Properties',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => ref.read(selectedNodeProvider.notifier).state = null,
                ),
              ],
            ),
            const Divider(),
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              controller: _nameController,
              onChanged: (value) => ref.read(workflowProvider.notifier).updateNode(
                node.copyWith(name: value),
              ),
            ),
            const SizedBox(height: 16),
            if (node.type == 'request') _buildRequestFields(node),
            if (node.type == 'condition') _buildConditionField(node),
            if (node.type == 'transform') _buildTransformField(node),
          ],
        ),
      ),
    );
  }



  Widget _buildRequestFields(WorkflowNode node) {
    final data = node.data;

    // Default URL options for now
    //later user can input the URLs
    final defaultUrls = [
      'https://onnstage.in/api/section',
      'https://onnstage.in/api/artist/info/136',
      'https://onnstage.in/api/artist/info/138',
      'https://onnstage.in/api/sections'
    ];

    return Column(
      children: [
        // HTTP Method Dropdown
        DropdownButtonFormField<String>(
          value: data['method'] ?? 'GET',
          items: ['GET', 'POST', 'PUT', 'DELETE'].map((m) =>
              DropdownMenuItem(value: m, child: Text(m))
          ).toList(),
          onChanged: (value) {
            final updatedNode = node.copyWith(data: {...data, 'method': value});
            _updateNodeAndUI(updatedNode);
          },
          decoration: const InputDecoration(labelText: 'HTTP Method'),
        ),

        const SizedBox(height: 16),


        // URL Dropdown
        DropdownButtonFormField<String>(
          value: defaultUrls.contains(data['url']) ? data['url'] : null,
          isExpanded: true,
          items: [
            ...defaultUrls.map((url) => DropdownMenuItem(
              value: url,
              child: Text(
                url,
                overflow: TextOverflow.ellipsis,
              ),
            )),
            const DropdownMenuItem(value: null, child: Text('Custom URL...'))
          ],
          onChanged: (value) {

            if (value != null) {

            _urlController.text = value;

            // Update the node
            final updatedNode = node.copyWith(
            name: "${node.name.split(' - ')[0]} - ${value}",
            data: {...data, 'url': value}
            );
             // _updateNodeAndUI(updatedNode);
          }
          },
          decoration: const InputDecoration(labelText: 'Predefined URLs'),
        ),

        const SizedBox(height: 16),

      ],
    );
  }

  // Helper method to update node and refresh UI
  void _updateNodeAndUI(WorkflowNode updatedNode) {

    ref.read(workflowProvider.notifier).updateNode(updatedNode);

    // Recreate the element with new data
    _recreateElementForNode(updatedNode);

    // Force rebuild
    setState(() {});
  }

  void _recreateElementForNode(WorkflowNode updatedNode) {
    // Create a new flow element with the updated node data
    final newElement = _createFlowElement(updatedNode);

    // Find the existing element in the dashboard
    final existingElement = _nodeToElementMap[updatedNode.id];
    if (existingElement != null) {
      // Remove the old element from the dashboard
      _dashboard.removeElement(existingElement);

      // Add the new element to the dashboard
      _dashboard.addElement(newElement);

      // Update our mapping
      _nodeToElementMap[updatedNode.id] = newElement;

      // Recreate connections for this node
      _recreateConnectionsForNode(updatedNode.id);
    }
  }
  // Helper method to recreate connections for a node
  void _recreateConnectionsForNode(String nodeId) {
    // Find all connections involving this node
    final connections = widget.workflow.connections.where(
            (conn) => conn.sourceNodeId == nodeId || conn.targetNodeId == nodeId
    ).toList();

    // Recreate each connection
    for (final conn in connections) {
      _addConnectionToDashboard(conn);
    }
  }



  // Update other field builders similarly
  Widget _buildConditionField(WorkflowNode node) {
    final data = node.data;
    return TextField(
      controller: _conditionController,
      onChanged: (value) {
        final updatedNode = node.copyWith(data: {...data, 'condition': value});
        _updateNodeAndUI(updatedNode);
      },
      decoration: const InputDecoration(labelText: 'Condition Expression'),
      maxLines: 3,
    );
  }


  Widget _buildTransformField(WorkflowNode node) {
    final data = node.data;
    return TextField(
      controller: _transformController,
      onChanged: (value) {
        final updatedNode = node.copyWith(data: {...data, 'transform': value});
        _updateNodeAndUI(updatedNode);
      },
      decoration: const InputDecoration(labelText: 'Transform Expression'),
      maxLines: 3,
    );
  }

  void _handleConnectionCreated(dynamic params, _) {
    print('Connection params: $params');

    try {
      // Extract the source and target elements
      final sourceElement = params['source'] as FlowElement;
      final targetElement = params['target'] as FlowElement;

      if (sourceElement.data is WorkflowNode && targetElement.data is WorkflowNode) {
        final sourceNode = sourceElement.data as WorkflowNode;
        final targetNode = targetElement.data as WorkflowNode;

        // Create a connection with standard ports
        final connection = WorkflowConnection(
          sourceNodeId: sourceNode.id,
          targetNodeId: targetNode.id,
          sourcePort: 'output',
          targetPort: 'input',
        );

        // Add the connection to the workflow
        ref.read(workflowProvider.notifier).addConnection(connection);

        print('Added connection from ${sourceNode.name} to ${targetNode.name}');
        print('Connection details: sourcePort=${connection.sourcePort}, targetPort=${connection.targetPort}');
      }
    } catch (e) {
      print('Error creating connection: $e');
    }
  }

  // Workflow execution methods
  void _runWorkflow() {
    _executor.runWorkflow();
  }

  void _stopExecution() {
    _executor.stopExecution();
  }
}