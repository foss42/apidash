import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vyuh_node_flow/vyuh_node_flow.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/file_system_handler.dart';
import 'package:apidash/services/workflow_execution_service.dart';
import 'package:apidash/screens/workflow/workflow_canvas_constants.dart';
import 'package:apidash/screens/workflow/workflow_metric_chip.dart';
import 'package:apidash/screens/workflow/workflow_node_inspector.dart';
import 'package:apidash/screens/workflow/workflow_node_surface.dart';
import 'package:apidash/screens/workflow/workflow_page_local_models.dart';
import 'package:apidash/screens/workflow/workflow_run_delegate_bridge.dart';

class WorkflowPage extends ConsumerStatefulWidget {
  const WorkflowPage({super.key});

  @override
  ConsumerState<WorkflowPage> createState() => _WorkflowPageState();
}

class _WorkflowPageState extends ConsumerState<WorkflowPage> {
  late final NodeFlowController<WorkflowNodeData, dynamic> _controller;
  final WorkflowExecutionService _executionService = const WorkflowExecutionService();
  bool _isRunning = false;
  String? _runningNodeId;
  final Map<String, bool?> _nodeSuccess = {};
  final Map<String, WorkflowNodeRunOutput> _nodeOutputs = {};
  final List<WorkflowRunEvent> _runEvents = [];
  bool _logsPaneVisible = false;

  List<WorkflowRunEvent> _runEventsForDisplay() =>
      _runEvents.where((e) => e.message != 'Started').toList();
  int _nodeCounter = 100;
  String? _selectedNodeId;
  String? _pendingConnectSourceNodeId;
  String? _pendingConnectSourcePortId;
  String? _workflowId;
  DateTime? _lastHydratedModifiedAt;
  final List<WorkflowRunRecord> _runHistory = [];

  @override
  void initState() {
    super.initState();
    _controller = NodeFlowController<WorkflowNodeData, dynamic>(
      nodes: _defaultNodes(),
      connections: _defaultConnections(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrapWorkflowState());
  }

  List<Node<WorkflowNodeData>> _defaultNodes() {
    return [
      Node<WorkflowNodeData>(
        id: 'start-1',
        type: 'start',
        position: const Offset(80, 120),
        size: const Size(170, 96),
        data: const WorkflowNodeData(
          nodeType: WorkflowNodeType.start,
          label: 'Start',
        ),
        ports: [
          Port(
            id: 'next',
            name: 'Next',
            position: PortPosition.right,
            type: PortType.output,
            offset: const Offset(0, 50),
          ),
        ],
      ),
      Node<WorkflowNodeData>(
        id: 'end-1',
        type: 'end',
        position: const Offset(320, 120),
        size: const Size(170, 96),
        data: const WorkflowNodeData(
          nodeType: WorkflowNodeType.end,
          label: 'Stop',
        ),
        ports: [
          Port(
            id: 'in',
            name: 'In',
            position: PortPosition.left,
            type: PortType.input,
            offset: const Offset(0, 50),
          ),
        ],
      ),
    ];
  }

  List<Connection<dynamic>> _defaultConnections() {
    return <Connection<dynamic>>[];
  }

  Node<WorkflowNodeData> _createNode({
    required WorkflowNodeType nodeType,
    required Offset position,
    String? id,
  }) {
    final nodeId = id ?? '${nodeType.name}-${_nodeCounter++}';

    final ports = switch (nodeType) {
      WorkflowNodeType.start => [
        Port(
          id: 'next',
          name: 'Next',
          position: PortPosition.right,
          type: PortType.output,
          offset: const Offset(0, 50),
        ),
      ],
      WorkflowNodeType.request => [
        Port(
          id: 'trigger',
          name: '',
          position: PortPosition.left,
          type: PortType.input,
          offset: const Offset(0, kRequestPortSendY),
        ),
        Port(
          id: 'success',
          name: 'Success()',
          position: PortPosition.right,
          type: PortType.output,
          offset: const Offset(0, kRequestPortSuccessY),
        ),
        Port(
          id: 'failure',
          name: 'Fail()',
          position: PortPosition.right,
          type: PortType.output,
          offset: const Offset(0, kRequestPortFailY),
        ),
      ],
      WorkflowNodeType.variable => [
        Port(
          id: 'in',
          name: 'In',
          position: PortPosition.left,
          type: PortType.input,
          offset: const Offset(0, 50),
        ),
        Port(
          id: 'out',
          name: 'Out',
          position: PortPosition.right,
          type: PortType.output,
          offset: const Offset(0, 50),
        ),
      ],
      WorkflowNodeType.condition ||
      WorkflowNodeType.transform ||
      WorkflowNodeType.delay ||
      WorkflowNodeType.loop => [
        Port(
          id: 'in',
          name: 'In',
          position: PortPosition.left,
          type: PortType.input,
          offset: const Offset(0, 50),
        ),
        if (nodeType == WorkflowNodeType.condition) ...[
          Port(
            id: 'true',
            name: 'True',
            position: PortPosition.right,
            type: PortType.output,
            offset: const Offset(-12, 36),
          ),
          Port(
            id: 'false',
            name: 'False',
            position: PortPosition.right,
            type: PortType.output,
            offset: const Offset(12, 64),
          ),
        ] else
          Port(
            id: 'out',
            name: 'Out',
            position: PortPosition.right,
            type: PortType.output,
            offset: const Offset(0, 50),
          ),
      ],
      WorkflowNodeType.end => [
        Port(
          id: 'in',
          name: 'In',
          position: PortPosition.left,
          type: PortType.input,
          offset: const Offset(0, 50),
        ),
      ],
    };

    final nodeSize = switch (nodeType) {
      WorkflowNodeType.request => const Size(kRequestNodeWidth, kRequestNodeHeight),
      WorkflowNodeType.start || WorkflowNodeType.end => const Size(170, 96),
      _ => const Size(210, 110),
    };

    return Node<WorkflowNodeData>(
      id: nodeId,
      type: nodeType.name,
      position: position,
      size: nodeSize,
      data: WorkflowNodeData(
        nodeType: nodeType,
        label: workflowDefaultNodeLabel(nodeType),
      ),
      ports: ports,
    );
  }

  void _addNode(WorkflowNodeType type) {
    final center = _controller.getViewportCenter();
    final node = _createNode(nodeType: type, position: center.offset);
    _controller.addNode(node);
    setState(() => _selectedNodeId = node.id);
    _saveWorkflowSnapshot();
  }

  Future<void> _openGuidedNextNodeFlow({
    String? fromNodeId,
    String? sourcePortId,
    Offset? preferredPosition,
  }) async {
    final resolvedFromNodeId = fromNodeId ?? _selectedNodeId;
    final selectedType = await showDialog<WorkflowNodeType>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("What's your next node?"),
        content: SizedBox(
          width: 360,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _nodeChoiceChip(context, WorkflowNodeType.request),
              _nodeChoiceChip(context, WorkflowNodeType.variable),
              _nodeChoiceChip(context, WorkflowNodeType.condition),
              _nodeChoiceChip(context, WorkflowNodeType.delay),
              _nodeChoiceChip(context, WorkflowNodeType.loop),
              _nodeChoiceChip(context, WorkflowNodeType.end),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    if (selectedType == null) return;

    final center = _controller.getViewportCenter();
    final node = _createNode(
      nodeType: selectedType,
      position: preferredPosition ?? center.offset,
    );

    WorkflowNodeData nodeData = node.data;
    if (selectedType == WorkflowNodeType.request) {
      final picked = await _pickRequestForNode();
      if (picked == null) return;
      nodeData = nodeData.copyWith(
        linkedRequestId: picked.requestId,
        linkedCollectionId: picked.collectionId,
      );
    }

    _controller.addNode(
      Node<WorkflowNodeData>(
        id: node.id,
        type: node.type,
        position: node.position.value,
        data: nodeData,
        ports: node.ports,
        size: node.size.value,
      ),
    );

    if (resolvedFromNodeId != null &&
        _controller.nodes.containsKey(resolvedFromNodeId)) {
      final sourceNode = _controller.nodes[resolvedFromNodeId]!;
      final sourcePort =
          sourcePortId ?? _defaultOutputPortForNode(sourceNode.data.nodeType);
      final targetPort = _defaultInputPortForNode(nodeData.nodeType);
      if (sourcePort != null && targetPort != null) {
        _controller.addConnection(
          Connection(
            id: 'c-${DateTime.now().microsecondsSinceEpoch}',
            sourceNodeId: resolvedFromNodeId,
            sourcePortId: sourcePort,
            targetNodeId: node.id,
            targetPortId: targetPort,
          ),
        );
      }
    }

    setState(() => _selectedNodeId = node.id);
    _saveWorkflowSnapshot();
  }

  NodeFlowEvents<WorkflowNodeData, dynamic> _editorEvents() {
    return NodeFlowEvents(
      node: NodeEvents<WorkflowNodeData>(
        onTap: (node) => setState(() => _selectedNodeId = node.id),
        onDragStop: (_) => _saveWorkflowSnapshot(),
      ),
      connection: ConnectionEvents<WorkflowNodeData, dynamic>(
        onCreated: (_) => _saveWorkflowSnapshot(),
        onConnectStart: (sourceNode, sourcePort) {
          _pendingConnectSourceNodeId = sourceNode.id;
          _pendingConnectSourcePortId = sourcePort.id;
        },
        onConnectEnd: (targetNode, _, position) {
          final sourceNodeId = _pendingConnectSourceNodeId;
          final sourcePortId = _pendingConnectSourcePortId;
          _pendingConnectSourceNodeId = null;
          _pendingConnectSourcePortId = null;
          if (targetNode != null) return;
          if (sourceNodeId == null || sourcePortId == null) return;
          _openGuidedNextNodeFlow(
            fromNodeId: sourceNodeId,
            sourcePortId: sourcePortId,
            preferredPosition: Offset(position.dx, position.dy),
          );
        },
      ),
    );
  }

  Widget _nodeChoiceChip(BuildContext context, WorkflowNodeType type) {
    return ActionChip(
      label: Text(workflowDefaultNodeLabel(type)),
      onPressed: () => Navigator.of(context).pop(type),
    );
  }

  Future<({String collectionId, String requestId})?> _pickRequestForNode() async {
    final collections = ref.read(collectionsStateProvider);
    final activeCollectionId = ref.read(activeCollectionIdStateProvider);
    if (collections.isEmpty || activeCollectionId == null) return null;
    final selectedCollectionId = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick collection'),
        content: SizedBox(
          width: 420,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: collections.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = collections.entries.elementAt(index);
              return ListTile(
                title: Text(item.value.name),
                subtitle: Text('Requests: ${item.value.requestIds.length}'),
                onTap: () => Navigator.of(context).pop(item.key),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    if (selectedCollectionId == null) return null;

    final notifier = ref.read(collectionStateNotifierProvider.notifier);
    if (ref.read(activeCollectionIdStateProvider) != selectedCollectionId) {
      await notifier.switchCollection(selectedCollectionId);
    }
    final activeCollection = ref.read(collectionsStateProvider)[selectedCollectionId];
    if (activeCollection == null) return null;
    final requestMap = ref.read(collectionStateNotifierProvider) ?? {};
    final requestIds = activeCollection.requestIds
        .where(requestMap.containsKey)
        .toList(growable: false);
    if (requestIds.isEmpty) return null;

    final requestId = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick request'),
        content: SizedBox(
          width: 760,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Request',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        'URL',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Variables',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: requestIds.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final id = requestIds[index];
                    final req = requestMap[id]!;
                    final name = req.name.trim().isEmpty ? id : req.name.trim();
                    final variableNames = _variableNamesForRequest(req);
                    final variablesLabel = variableNames.isEmpty
                        ? 'None'
                        : '${variableNames.length}: ${variableNames.take(3).join(', ')}${variableNames.length > 3 ? ', ...' : ''}';
                    return InkWell(
                      onTap: () => Navigator.of(context).pop(id),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                req.httpRequestModel?.url ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                variablesLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    if (requestId == null) return null;
    return (collectionId: selectedCollectionId, requestId: requestId);
  }

  List<String> _variableNamesForRequest(RequestModel request) {
    final http = request.httpRequestModel;
    if (http == null) return const <String>[];
    final regex = RegExp(r'\{\{\s*([^}]+?)\s*\}\}');
    final set = <String>{};
    void scanText(String part) {
      for (final match in regex.allMatches(part)) {
        final key = match.group(1)?.trim();
        if (key != null && key.isNotEmpty) {
          set.add(key);
        }
      }
    }

    void scanAny(dynamic value) {
      if (value == null) return;
      if (value is String) {
        scanText(value);
        return;
      }
      if (value is Map) {
        for (final entry in value.entries) {
          scanAny(entry.key);
          scanAny(entry.value);
        }
        return;
      }
      if (value is Iterable) {
        for (final item in value) {
          scanAny(item);
        }
      }
    }

    scanText(http.url);
    scanText(http.body ?? '');
    scanText(http.query ?? '');
    for (final h in http.headers ?? const []) {
      scanText(h.name);
      scanText(h.value ?? '');
    }
    for (final p in http.params ?? const []) {
      scanText(p.name);
      scanText(p.value ?? '');
    }
    for (final f in http.formData ?? const []) {
      scanText(f.name);
      scanAny(f.value);
    }
    scanAny(http.authModel?.toJson());

    return set.toList()..sort();
  }

  String? _defaultOutputPortForNode(WorkflowNodeType type) {
    switch (type) {
      case WorkflowNodeType.start:
        return 'next';
      case WorkflowNodeType.request:
        return 'success';
      case WorkflowNodeType.variable:
      case WorkflowNodeType.transform:
      case WorkflowNodeType.delay:
      case WorkflowNodeType.loop:
        return 'out';
      case WorkflowNodeType.condition:
        return 'true';
      case WorkflowNodeType.end:
        return null;
    }
  }

  String? _defaultInputPortForNode(WorkflowNodeType type) {
    switch (type) {
      case WorkflowNodeType.start:
        return null;
      case WorkflowNodeType.request:
        return 'trigger';
      case WorkflowNodeType.end:
      case WorkflowNodeType.condition:
      case WorkflowNodeType.variable:
      case WorkflowNodeType.transform:
      case WorkflowNodeType.delay:
      case WorkflowNodeType.loop:
        return 'in';
    }
  }

  void _updateNodeData(String nodeId, WorkflowNodeData data) {
    final existing = _controller.nodes[nodeId];
    if (existing == null) return;
    final replacement = Node<WorkflowNodeData>(
      id: existing.id,
      type: existing.type,
      position: existing.position.value,
      data: data,
      ports: existing.ports,
      size: existing.size.value,
      initialZIndex: existing.zIndex.value,
      theme: existing.theme,
      widgetBuilder: existing.widgetBuilder,
    );
    _controller.addNode(replacement);
    setState(() {});
    _saveWorkflowSnapshot();
  }

  Future<void> _saveWorkflowSnapshot() async {
    final workflowId = _workflowId;
    if (workflowId == null) return;
    await ref.read(workflowsStateProvider.notifier).saveGraph(
          workflowId: workflowId,
          graphData: _serializeGraph(),
        );
  }

  Map<String, dynamic> _serializeGraph() {
    return <String, dynamic>{
      'nodes': _controller.nodes.values
          .map(
            (node) => <String, dynamic>{
              'id': node.id,
              'type': node.type,
              'x': node.position.value.dx,
              'y': node.position.value.dy,
              'data': node.data.toJson(),
            },
          )
          .toList(growable: false),
      'connections': _controller.connections
          .map(
            (c) => <String, dynamic>{
              'id': c.id,
              'sourceNodeId': c.sourceNodeId,
              'sourcePortId': c.sourcePortId,
              'targetNodeId': c.targetNodeId,
              'targetPortId': c.targetPortId,
            },
          )
          .toList(growable: false),
    };
  }

  void _hydrateFromGraph(Map<String, dynamic> graphData) {
    final nodesRaw = graphData['nodes'];
    final connectionsRaw = graphData['connections'];
    final nodesList = nodesRaw is List ? nodesRaw : <dynamic>[];
    final connectionsList = connectionsRaw is List ? connectionsRaw : <dynamic>[];

    if (nodesList.isEmpty) {
      for (final key in _controller.nodes.keys.toList()) {
        _controller.removeNode(key);
      }
      for (final c in _controller.connections.toList()) {
        _controller.removeConnection(c.id);
      }
      for (final n in _defaultNodes()) {
        _controller.addNode(n);
      }
      return;
    }

    final nodes = <Node<WorkflowNodeData>>[];
    for (final item in nodesList.whereType<Map>()) {
      final json = item.map((k, v) => MapEntry(k.toString(), v));
      final type = WorkflowNodeData.fromJson(
        (json['data'] as Map?)?.map((k, v) => MapEntry(k.toString(), v)) ??
            const <String, dynamic>{'nodeType': 'start'},
      ).nodeType;
      final node = _createNode(
        nodeType: type,
        position: Offset(
          (json['x'] as num?)?.toDouble() ?? 0,
          (json['y'] as num?)?.toDouble() ?? 0,
        ),
        id: json['id'] as String?,
      );
      final dataMap = (json['data'] as Map?)?.map((k, v) => MapEntry(k.toString(), v));
      final hydrated = Node<WorkflowNodeData>(
        id: node.id,
        type: node.type,
        position: node.position.value,
        size: node.size.value,
        data: dataMap == null ? node.data : WorkflowNodeData.fromJson(dataMap),
        ports: node.ports,
      );
      nodes.add(hydrated);
    }
    final conns = <Connection<dynamic>>[];
    for (final item in connectionsList.whereType<Map>()) {
      final json = item.map((k, v) => MapEntry(k.toString(), v));
      conns.add(
        Connection(
          id: json['id'] as String,
          sourceNodeId: json['sourceNodeId'] as String,
          sourcePortId: json['sourcePortId'] as String,
          targetNodeId: json['targetNodeId'] as String,
          targetPortId: json['targetPortId'] as String,
        ),
      );
    }
    for (final key in _controller.nodes.keys.toList()) {
      _controller.removeNode(key);
    }
    for (final node in nodes) {
      _controller.addNode(node);
    }
    for (final c in _controller.connections.toList()) {
      _controller.removeConnection(c.id);
    }
    for (final c in conns) {
      _controller.addConnection(c);
    }
  }

  void _syncNodeCounterFromGraph() {
    var maxSuffix = 0;
    for (final id in _controller.nodes.keys) {
      final parts = id.split('-');
      if (parts.isEmpty) continue;
      final n = int.tryParse(parts.last);
      if (n != null && n > maxSuffix) maxSuffix = n;
    }
    _nodeCounter = maxSuffix >= 100 ? maxSuffix + 1 : 100;
  }

  Future<void> _switchWorkflow(String workflowId) async {
    if (_workflowId == workflowId) return;
    await _saveWorkflowSnapshot();
    ref.read(workflowsStateProvider.notifier).setActive(workflowId);
    _workflowId = workflowId;
    final workflow = ref.read(workflowsStateProvider)[workflowId];
    if (workflow != null) {
      _hydrateFromGraph(workflow.graphData);
      _syncNodeCounterFromGraph();
      _lastHydratedModifiedAt = workflow.modifiedAt;
    }
    _runEvents.clear();
    _nodeSuccess.clear();
    _nodeOutputs.clear();
    _selectedNodeId = null;
    _runningNodeId = null;
    _isRunning = false;
    unawaited(_loadRunHistoryFromHive(workflowId));
    if (mounted) setState(() {});
  }

  Future<void> _createNewWorkflow() async {
    await _saveWorkflowSnapshot();
    final model = await ref.read(workflowsStateProvider.notifier).createDefault();
    _workflowId = model.id;
    _hydrateFromGraph(model.graphData);
    _syncNodeCounterFromGraph();
    _lastHydratedModifiedAt = model.modifiedAt;
    _runEvents.clear();
    _nodeSuccess.clear();
    _nodeOutputs.clear();
    _selectedNodeId = null;
    _runningNodeId = null;
    _isRunning = false;
    unawaited(_loadRunHistoryFromHive(model.id));
    if (mounted) setState(() {});
  }

  String _workflowPickerLabel(int index, String name) {
    final normalized = name.trim().isEmpty ? 'Untitled' : name.trim();
    return 'Flow ${index + 1} — $normalized';
  }

  Future<void> _bootstrapWorkflowState() async {
    final workflowNotifier = ref.read(workflowsStateProvider.notifier);
    if (ref.read(workflowsStateProvider).isEmpty) {
      await workflowNotifier.createDefault();
    }
    var activeWorkflowId = ref.read(workflowIdStateProvider);
    if (activeWorkflowId == null) {
      await Future<void>.delayed(Duration.zero);
      activeWorkflowId = ref.read(workflowIdStateProvider);
    }
    if (activeWorkflowId == null) return;
    _workflowId = activeWorkflowId;
    final workflow = ref.read(workflowsStateProvider)[activeWorkflowId];
    if (workflow != null) {
      _hydrateFromGraph(workflow.graphData);
      _syncNodeCounterFromGraph();
      _lastHydratedModifiedAt = workflow.modifiedAt;
    }
    unawaited(_loadRunHistoryFromHive(activeWorkflowId));
    if (mounted) setState(() {});
  }

  void _openWorkflowAnalytics() {
    final id = _workflowId;
    if (id == null) return;
    ref.read(dashboardOpenIntentProvider.notifier).state = DashboardOpenIntent(
      tab: DashboardMainTab.workflows,
      workflowId: id,
    );
    ref.read(navRailIndexStateProvider.notifier).state = 5;
  }

  Future<void> _loadRunHistoryFromHive(String workflowId) async {
    final raw = await fileSystemHandler.getWorkflowRunHistory(workflowId);
    _runHistory.clear();
    if (raw is! List) return;
    _runHistory.addAll(
      raw.whereType<Map>().map(
            (m) => WorkflowRunRecord.fromJson(
              m.map((k, v) => MapEntry(k.toString(), v)),
            ),
          ),
    );
  }

  String _nodeShortLabel(String nodeId) {
    final n = _controller.nodes[nodeId];
    if (n == null) return nodeId;
    final l = n.data.label.trim();
    return l.isEmpty ? nodeId : l;
  }

  String _requestNameForNode(String nodeId, Map<String, RequestModel> requests) {
    final node = _controller.nodes[nodeId];
    if (node == null) return '';
    if (node.data.nodeType != WorkflowNodeType.request) return '';
    final rid = node.data.linkedRequestId;
    if (rid == null || rid.isEmpty) return '—';
    final req = requests[rid];
    final name = req?.name.trim() ?? '';
    return name.isNotEmpty ? name : rid;
  }

  List<String> _topologicalOrderForLayout() {
    final ids = _controller.nodes.keys.toList();
    if (ids.isEmpty) return ids;
    final adj = <String, List<String>>{};
    final inDegree = <String, int>{};
    for (final id in ids) {
      adj[id] = [];
      inDegree[id] = 0;
    }
    for (final c in _controller.connections.toList()) {
      final from = c.sourceNodeId;
      final to = c.targetNodeId;
      if (!adj.containsKey(from) || !inDegree.containsKey(to)) continue;
      adj[from]!.add(to);
      inDegree[to] = (inDegree[to] ?? 0) + 1;
    }
    bool isStart(String id) =>
        _controller.nodes[id]?.data.nodeType == WorkflowNodeType.start;
    void sortReady(List<String> ready) {
      ready.sort((a, b) {
        final aS = isStart(a);
        final bS = isStart(b);
        if (aS != bS) return aS ? -1 : 1;
        return a.compareTo(b);
      });
    }

    final result = <String>[];
    final q = <String>[];
    for (final id in ids) {
      if (inDegree[id] == 0) q.add(id);
    }
    sortReady(q);
    while (q.isNotEmpty) {
      final v = q.removeAt(0);
      result.add(v);
      for (final w in adj[v] ?? const <String>[]) {
        inDegree[w] = inDegree[w]! - 1;
        if (inDegree[w] == 0) {
          q.add(w);
          sortReady(q);
        }
      }
    }
    if (result.length != ids.length) {
      final remaining = ids.where((id) => !result.contains(id)).toList();
      remaining.sort(
        (a, b) => _controller.nodes[a]!.position.value.dx.compareTo(
              _controller.nodes[b]!.position.value.dx,
            ),
      );
      return [...result, ...remaining];
    }
    return result;
  }

  void _autoOrganizeNodes() {
    final ids = _controller.nodes.keys.toList();
    if (ids.isEmpty) return;
    final ordered = _topologicalOrderForLayout();
    var sumY = 0.0;
    for (final id in ids) {
      sumY += _controller.nodes[id]!.position.value.dy;
    }
    final y = sumY / ids.length;
    const x0 = 80.0;
    const gap = 40.0;
    var x = x0;
    for (final id in ordered) {
      final n = _controller.nodes[id]!;
      _controller.setNodePosition(id, Offset(x, y));
      x += n.size.value.width + gap;
    }
    _saveWorkflowSnapshot();
    setState(() {});
  }

  Future<void> _persistRunHistory() async {
    final workflowId = _workflowId ?? ref.read(workflowIdStateProvider);
    if (workflowId == null) return;
    _workflowId ??= workflowId;
    final runs = _runHistory.map((r) => r.toJson()).toList(growable: false);
    await fileSystemHandler.setWorkflowRunHistory(workflowId, runs);
    ref.read(workflowRunHistoryRevisionProvider.notifier).state++;
  }

  Future<void> _runWorkflow() async {
    if (_isRunning) return;
    _workflowId ??= ref.read(workflowIdStateProvider);
    setState(() {
      _isRunning = true;
      _runningNodeId = null;
      _nodeSuccess.clear();
      _nodeOutputs.clear();
      _runEvents.clear();
    });
    final previousSelectedId = ref.read(selectedIdStateProvider);
    try {
      final result = await _executionService.run(
        nodes: _controller.nodes,
        connections: _controller.connections.toList(),
        delegate: WorkflowRunDelegateBridge(
          runRequestById: _runRequestById,
        ),
        onNodeUpdate: (nodeId, nodeResult) {
          if (!mounted) return;
          setState(() {
            _runningNodeId =
                nodeResult.status == WorkflowNodeRunStatus.running ? nodeId : null;
            _nodeSuccess[nodeId] = _statusToBool(nodeResult.status);
            if (nodeResult.message != null) {
              _nodeOutputs[nodeId] = WorkflowNodeRunOutput(
                requestId: _controller.nodes[nodeId]?.data.linkedRequestId ?? '',
                statusCode: null,
                timeMs: null,
                responseBody: nodeResult.message,
              );
            }
          });
        },
        onEvent: (event) {
          if (!mounted) return;
          setState(() => _runEvents.insert(0, event));
        },
      );
      final record = WorkflowRunRecord(
        startedAt: result.startedAt,
        endedAt: result.endedAt,
        success: result.isSuccess,
        error: result.error,
        nodeCount: result.nodeResults.length,
      );
      _runHistory.insert(0, record);
      if (_runHistory.length > 20) {
        _runHistory.removeRange(20, _runHistory.length);
      }
      await _persistRunHistory();
      if (mounted && result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workflow run complete')),
        );
      }
    } finally {
      ref.read(selectedIdStateProvider.notifier).state = previousSelectedId;
      setState(() => _isRunning = false);
    }
  }

  bool? _statusToBool(WorkflowNodeRunStatus status) {
    switch (status) {
      case WorkflowNodeRunStatus.success:
        return true;
      case WorkflowNodeRunStatus.failed:
        return false;
      default:
        return null;
    }
  }

  Future<WorkflowRequestResult> _runRequestById({
    required String nodeId,
    required String requestId,
    required WorkflowExecutionContext context,
  }) async {
    final previousCollectionId = ref.read(activeCollectionIdStateProvider);
    final targetCollectionId =
        _controller.nodes[nodeId]?.data.linkedCollectionId ?? previousCollectionId;
    if (targetCollectionId != null &&
        targetCollectionId != ref.read(activeCollectionIdStateProvider)) {
      await ref
          .read(collectionStateNotifierProvider.notifier)
          .switchCollection(targetCollectionId);
    }

    final collection = ref.read(collectionStateNotifierProvider);
    if (collection == null || collection.isEmpty) {
      return const WorkflowRequestResult(
        ok: false,
        message: 'Add at least one request in the collection.',
      );
    }
    String linkedId = requestId;
    if (linkedId.isEmpty || !collection.containsKey(linkedId)) {
      linkedId = collection.keys.first;
    }
    if (!collection.containsKey(linkedId)) {
      return const WorkflowRequestResult(
        ok: false,
        message: 'Linked request not found in collection.',
      );
    }

    ref.read(selectedIdStateProvider.notifier).state = linkedId;
    try {
      final templateApplied = await _applyTemplateToRequest(
        requestId: linkedId,
        context: context,
        requestVariableOverrides: _controller
                .nodes[nodeId]
                ?.data
                .requestVariableValues ??
            const <String, String>{},
      );
      await ref.read(collectionStateNotifierProvider.notifier).sendRequest();
      final col = ref.read(collectionStateNotifierProvider);
      final req = col != null ? col[linkedId] : null;
      final status = req?.responseStatus;
      final timeMs = req?.httpResponseModel?.time?.inMilliseconds;
      final body =
          req?.httpResponseModel?.formattedBody ?? req?.httpResponseModel?.body;
      final bodyForTransform =
          req?.httpResponseModel?.body ?? req?.httpResponseModel?.formattedBody;
      final ok = status != null && status >= 200 && status < 300;
      _nodeOutputs[nodeId] = WorkflowNodeRunOutput(
        requestId: linkedId,
        statusCode: status,
        timeMs: timeMs,
        responseBody: body,
      );
      if (templateApplied != null) {
        await _restoreRequestTemplate(requestId: linkedId, previous: templateApplied);
      }
      if (previousCollectionId != null &&
          previousCollectionId != ref.read(activeCollectionIdStateProvider)) {
        await ref
            .read(collectionStateNotifierProvider.notifier)
            .switchCollection(previousCollectionId);
      }
      return WorkflowRequestResult(
        ok: ok,
        statusCode: status,
        message: body != null && body.length > 600 ? '${body.substring(0, 600)}...' : body,
        responseBody: bodyForTransform,
        extra: <String, dynamic>{
          'requestId': linkedId,
          if (timeMs != null) 'timeMs': timeMs,
        },
      );
    } catch (e) {
      if (previousCollectionId != null &&
          previousCollectionId != ref.read(activeCollectionIdStateProvider)) {
        await ref
            .read(collectionStateNotifierProvider.notifier)
            .switchCollection(previousCollectionId);
      }
      return WorkflowRequestResult(
        ok: false,
        message: 'Error: $e',
      );
    }
  }

  Future<({String? url, String? body, String? query})?> _applyTemplateToRequest({
    required String requestId,
    required WorkflowExecutionContext context,
    required Map<String, String> requestVariableOverrides,
  }) async {
    final collection = ref.read(collectionStateNotifierProvider);
    final req = collection?[requestId];
    final http = req?.httpRequestModel;
    if (http == null) return null;
    final original = (url: http.url, body: http.body, query: http.query);
    final replacedUrl = _resolveTemplateString(
      http.url,
      context,
      requestVariableOverrides,
    );
    final replacedBody = _resolveTemplateString(
      http.body,
      context,
      requestVariableOverrides,
    );
    final replacedQuery = _resolveTemplateString(
      http.query,
      context,
      requestVariableOverrides,
    );
    ref.read(collectionStateNotifierProvider.notifier).update(
          id: requestId,
          url: replacedUrl,
          body: replacedBody,
          query: replacedQuery,
        );
    return original;
  }

  Future<void> _restoreRequestTemplate({
    required String requestId,
    required ({String? url, String? body, String? query}) previous,
  }) async {
    ref.read(collectionStateNotifierProvider.notifier).update(
          id: requestId,
          url: previous.url ?? '',
          body: previous.body,
          query: previous.query,
        );
  }

  String? _resolveTemplateString(
    String? input,
    WorkflowExecutionContext context,
    Map<String, String> requestVariableOverrides,
  ) {
    if (input == null || input.isEmpty) return input;
    return input.replaceAllMapped(RegExp(r'\{\{([^}]+)\}\}'), (m) {
      final key = m.group(1)?.trim() ?? '';
      if (key.isEmpty) return '';
      if (requestVariableOverrides.containsKey(key)) {
        return _resolveRequestOverrideValue(
          requestVariableOverrides[key] ?? '',
          context,
        );
      }
      if (context.variables.containsKey(key)) {
        return '${context.variables[key] ?? ''}';
      }
      return '';
    });
  }

  String _resolveRequestOverrideValue(
    String rawValue,
    WorkflowExecutionContext context,
  ) {
    final source = rawValue.trim();
    if (!source.startsWith('json:')) {
      return rawValue;
    }
    final path = source.substring(5).trim();
    if (path.isEmpty) return '';
    final lastResult = context.results.values.isNotEmpty
        ? context.results.values.last
        : null;
    if (lastResult is! Map<String, dynamic>) return '';
    final body = lastResult['responseBody'];
    if (body is! String || body.trim().isEmpty) return '';
    try {
      dynamic current = jsonDecode(body.trim());
      for (final segment in path.split('.').where((e) => e.isNotEmpty)) {
        if (current is Map && current.containsKey(segment)) {
          current = current[segment];
        } else {
          return '';
        }
      }
      return current?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }

  Future<void> _exportWorkflowJson() async {
    final workflowId = _workflowId;
    if (workflowId == null) return;
    final source = ref.read(workflowsStateProvider.notifier).exportToJson(workflowId);
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Workflow Export JSON'),
        content: SizedBox(
          width: 680,
          child: SelectableText(source),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _importWorkflowJson() async {
    final controller = TextEditingController();
    final source = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Workflow JSON'),
        content: SizedBox(
          width: 680,
          child: TextField(
            controller: controller,
            minLines: 10,
            maxLines: 20,
            decoration: const InputDecoration(
              hintText: 'Paste workflow JSON',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Import'),
          ),
        ],
      ),
    );
    if (source == null || source.isEmpty) return;
    try {
      await ref.read(workflowsStateProvider.notifier).importFromJson(source);
      final workflowId = ref.read(workflowIdStateProvider);
      if (workflowId != null) {
        _workflowId = workflowId;
        final workflow = ref.read(workflowsStateProvider)[workflowId];
        if (workflow != null) {
          _hydrateFromGraph(workflow.graphData);
        }
        unawaited(_loadRunHistoryFromHive(workflowId));
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workflow imported')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final nodeFlowTheme = isDark ? NodeFlowTheme.dark : NodeFlowTheme.light;
    final collection = ref.watch(collectionStateNotifierProvider) ?? {};
    final workflows = ref.watch(workflowsStateProvider);
    final workflowIds = workflows.keys.toList(growable: false);
    final dropdownWorkflowId = _workflowId != null && workflows.containsKey(_workflowId)
        ? _workflowId!
        : (workflowIds.isNotEmpty ? workflowIds.first : null);

    if (!_isRunning && dropdownWorkflowId != null) {
      final w = workflows[dropdownWorkflowId];
      if (w != null &&
          (_lastHydratedModifiedAt == null || w.modifiedAt != _lastHydratedModifiedAt)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _hydrateFromGraph(w.graphData);
          _syncNodeCounterFromGraph();
          _lastHydratedModifiedAt = w.modifiedAt;
          setState(() {});
        });
      }
    }

    final selectedNode =
        _selectedNodeId == null ? null : _controller.nodes[_selectedNodeId!];
    final displayRunEvents = _runEventsForDisplay().reversed.toList();
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(
                  'Workflow',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(width: 12),
                if (workflowIds.isNotEmpty && dropdownWorkflowId != null) ...[
                  SizedBox(
                    width: 280,
                    child: DropdownButtonFormField<String>(
                      value: dropdownWorkflowId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Open workflow',
                        isDense: true,
                      ),
                      items: workflowIds.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final id = entry.value;
                        final name = workflows[id]!.name;
                        return DropdownMenuItem<String>(
                          value: id,
                          child: Text(
                            _workflowPickerLabel(idx, name),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        _switchWorkflow(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    tooltip: 'New workflow',
                    onPressed: _createNewWorkflow,
                    icon: const Icon(Icons.add_rounded),
                  ),
                  const SizedBox(width: 12),
                ],
                const Spacer(),
                OutlinedButton(
                  onPressed: _saveWorkflowSnapshot,
                  child: const Text('Save'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _importWorkflowJson,
                  child: const Text('Import'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _exportWorkflowJson,
                  child: const Text('Export'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: _workflowId == null ? null : _openWorkflowAnalytics,
                  icon: const Icon(Icons.analytics_outlined, size: 20),
                  label: const Text('Show analytics'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    MetricChip(
                      label: 'Runs',
                      value: '${_runHistory.length}',
                    ),
                    const SizedBox(width: 8),
                    MetricChip(
                      label: 'Success()',
                      value:
                          '${_runHistory.where((r) => r.success).length}/${_runHistory.length}',
                    ),
                    const SizedBox(width: 8),
                    MetricChip(
                      label: 'Avg Duration',
                      value: _runHistory.isEmpty
                          ? '-'
                          : '${(_runHistory.map((r) => r.durationMs).reduce((a, b) => a + b) / _runHistory.length).round()}ms',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            NodeFlowEditor<WorkflowNodeData, dynamic>(
                              controller: _controller,
                              theme: nodeFlowTheme,
                              events: _editorEvents(),
                              nodeBuilder: (context, node) => WorkflowNodeWidget(
                                node: node,
                                availableRequests: collection,
                                isRunning: _runningNodeId == node.id,
                                isSuccess: _nodeSuccess[node.id],
                                isSelected: _selectedNodeId == node.id,
                                onTap: () => setState(() => _selectedNodeId = node.id),
                                onDuplicate: () {
                                  _controller.duplicateNode(node.id);
                                  _saveWorkflowSnapshot();
                                  setState(() {});
                                },
                                onDelete: () {
                                  _controller.removeNode(node.id);
                                  if (_selectedNodeId == node.id) {
                                    _selectedNodeId = null;
                                  }
                                  _saveWorkflowSnapshot();
                                  setState(() {});
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: _logsPaneVisible ? 8 : 16,
                                ),
                                child: Material(
                                  color: theme.colorScheme.surfaceContainerHigh,
                                  elevation: 2,
                                  shadowColor: theme.shadowColor.withValues(alpha: 0.35),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: theme.colorScheme.outline.withValues(alpha: 0.25),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FilledButton.icon(
                                          onPressed: _isRunning ? null : _runWorkflow,
                                          icon: _isRunning
                                              ? const SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child: CircularProgressIndicator(strokeWidth: 2),
                                                )
                                              : const Icon(Icons.play_arrow, size: 20),
                                          label: Text(_isRunning ? 'Running...' : 'Run'),
                                        ),
                                        const SizedBox(width: 8),
                                        PopupMenuButton<WorkflowNodeType>(
                                          tooltip: 'Add node',
                                          onSelected: _addNode,
                                          itemBuilder: (context) => const [
                                            PopupMenuItem(
                                              value: WorkflowNodeType.request,
                                              child: Text('Add Request node'),
                                            ),
                                            PopupMenuItem(
                                              value: WorkflowNodeType.variable,
                                              child: Text('Add Variable node'),
                                            ),
                                            PopupMenuItem(
                                              value: WorkflowNodeType.condition,
                                              child: Text('Add Condition node'),
                                            ),
                                            PopupMenuItem(
                                              value: WorkflowNodeType.delay,
                                              child: Text('Add Delay node'),
                                            ),
                                            PopupMenuItem(
                                              value: WorkflowNodeType.loop,
                                              child: Text('Add Loop node'),
                                            ),
                                            PopupMenuItem(
                                              value: WorkflowNodeType.end,
                                              child: Text('Add End node'),
                                            ),
                                          ],
                                          child: const Chip(label: Text('Add Node')),
                                        ),
                                        const SizedBox(width: 8),
                                        Tooltip(
                                          message:
                                              'Arrange nodes in a horizontal line following flow connections',
                                          child: OutlinedButton(
                                            onPressed: _autoOrganizeNodes,
                                            child: const Text('Auto organize'),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        OutlinedButton.icon(
                                          onPressed: () => setState(
                                            () => _logsPaneVisible = !_logsPaneVisible,
                                          ),
                                          icon: Badge(
                                            isLabelVisible:
                                                displayRunEvents.isNotEmpty,
                                            label: Text(
                                              displayRunEvents.length > 99
                                                  ? '99+'
                                                  : '${displayRunEvents.length}',
                                            ),
                                            child: const Icon(
                                              Icons.list_alt_outlined,
                                              size: 18,
                                            ),
                                          ),
                                          label: Text(
                                            _logsPaneVisible ? 'Hide logs' : 'View logs',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_logsPaneVisible)
                        SizedBox(
                          height: 300,
                          child: Material(
                            elevation: 2,
                            color: theme.colorScheme.surfaceContainerLow,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                              side: BorderSide.none,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 6, 4, 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.terminal,
                                        size: 18,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Run log',
                                        style: theme.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${displayRunEvents.length} events',
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      IconButton(
                                        tooltip: 'Hide logs',
                                        icon: const Icon(Icons.close, size: 20),
                                        onPressed: () =>
                                            setState(() => _logsPaneVisible = false),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                                ),
                                Expanded(
                                  child: displayRunEvents.isEmpty
                                      ? Center(
                                          child: Text(
                                            'No log entries yet. Run the workflow to see live events.',
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: theme.colorScheme.onSurfaceVariant,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : ListView.separated(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          itemCount: displayRunEvents.length,
                                          separatorBuilder: (_, _) =>
                                              Divider(
                                            height: 12,
                                            color: theme.colorScheme.outline
                                                .withValues(alpha: 0.12),
                                          ),
                                          itemBuilder: (context, i) {
                                            final e = displayRunEvents[i];
                                            final n = _controller.nodes[e.nodeId];
                                            final isRequest =
                                                n?.data.nodeType == WorkflowNodeType.request;
                                            final reqName =
                                                _requestNameForNode(e.nodeId, collection);
                                            return Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2),
                                                  child: Icon(
                                                    e.isError
                                                        ? Icons.error_outline
                                                        : Icons
                                                            .check_circle_outline,
                                                    size: 16,
                                                    color: e.isError
                                                        ? theme.colorScheme.error
                                                        : theme.colorScheme.primary,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        _nodeShortLabel(e.nodeId),
                                                        style: theme.textTheme.labelLarge
                                                            ?.copyWith(
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      if (isRequest)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(top: 2),
                                                          child: Text(
                                                            'Request: $reqName',
                                                            style: theme
                                                                .textTheme.bodySmall
                                                                ?.copyWith(
                                                              color: theme.colorScheme
                                                                  .tertiary,
                                                            ),
                                                          ),
                                                        ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        e.message,
                                                        style: theme.textTheme.bodySmall,
                                                      ),
                                                      Text(
                                                        kWorkflowRunTimeOnly
                                                            .format(e.at.toLocal()),
                                                        style: theme.textTheme.labelSmall
                                                            ?.copyWith(
                                                          color: theme.colorScheme
                                                              .onSurfaceVariant,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (selectedNode != null)
                  SizedBox(
                    width: 320,
                    child: WorkflowNodeInspector(
                      node: selectedNode,
                      availableRequests: collection,
                      output: _nodeOutputs[selectedNode.id],
                      runHistory: _runHistory,
                      templateVariablesForRequest: () {
                        final requestId = selectedNode.data.linkedRequestId;
                        if (requestId == null || requestId.isEmpty) return const <String>[];
                        final request = collection[requestId];
                        if (request == null) return const <String>[];
                        return _variableNamesForRequest(request);
                      }(),
                      requestVariableValues:
                          selectedNode.data.requestVariableValues ??
                          const <String, String>{},
                      onRequestVariableValueChanged: (key, value) {
                        final current = selectedNode.data.requestVariableValues ??
                            const <String, String>{};
                        final updated = Map<String, String>.from(current);
                        updated[key] = value;
                        _updateNodeData(
                          selectedNode.id,
                          selectedNode.data.copyWith(
                            requestVariableValues: updated,
                          ),
                        );
                      },
                      onUpdate: (data) => _updateNodeData(selectedNode.id, data),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
