import 'dart:convert';

import 'package:apidash/models/workflow_node_data.dart';

class WorkflowGraphValidationResult {
  const WorkflowGraphValidationResult({
    required this.graphData,
    this.warnings = const [],
    this.errors = const [],
  });

  final Map<String, dynamic> graphData;
  final List<String> warnings;
  final List<String> errors;

  bool get isValid => errors.isEmpty;
}

class WorkflowGraphValidationService {
  const WorkflowGraphValidationService();

  WorkflowGraphValidationResult normalizeAndValidate(dynamic raw) {
    final warnings = <String>[];
    final errors = <String>[];

    final input = _coerceMap(raw);
    final nodesRaw = input['nodes'] is List ? input['nodes'] as List : const [];
    final connsRaw =
        input['connections'] is List ? input['connections'] as List : const [];

    final nodes = <Map<String, dynamic>>[];
    for (final item in nodesRaw.whereType<Map>()) {
      final m = item.map((k, v) => MapEntry(k.toString(), v));
      final dataRaw = _coerceMap(m['data']);
      final nodeTypeStr = (dataRaw['nodeType'] ?? m['type'] ?? 'start').toString();
      final nodeType = _parseNodeType(nodeTypeStr) ?? WorkflowNodeType.start;
      final id = (m['id'] ?? '').toString().trim();
      if (id.isEmpty) {
        warnings.add('A node is missing id; it was skipped.');
        continue;
      }
      nodes.add({
        'id': id,
        'type': (m['type'] ?? nodeType.name).toString(),
        'x': _toNum(m['x']) ?? 0,
        'y': _toNum(m['y']) ?? 0,
        'data': {
          ...dataRaw,
          'nodeType': nodeType.name,
          'label': (dataRaw['label'] ?? '').toString(),
        },
      });
    }

    final nodeIds = nodes.map((n) => n['id'] as String).toSet();
    if (nodeIds.length != nodes.length) {
      errors.add('Duplicate node ids found in generated graph.');
    }

    final connections = <Map<String, dynamic>>[];
    for (final item in connsRaw.whereType<Map>()) {
      final m = item.map((k, v) => MapEntry(k.toString(), v));
      final src = (m['sourceNodeId'] ?? '').toString();
      final dst = (m['targetNodeId'] ?? '').toString();
      if (src.isEmpty || dst.isEmpty) continue;
      if (!nodeIds.contains(src) || !nodeIds.contains(dst)) {
        warnings.add('A connection references missing node(s) and was dropped.');
        continue;
      }
      connections.add({
        'id': (m['id'] ?? '${src}_${m['sourcePortId']}_${dst}').toString(),
        'sourceNodeId': src,
        'sourcePortId': (m['sourcePortId'] ?? '').toString(),
        'targetNodeId': dst,
        'targetPortId': (m['targetPortId'] ?? 'in').toString(),
      });
    }

    final startNodes = nodes.where((n) {
      final data = _coerceMap(n['data']);
      return (data['nodeType']?.toString() ?? '') == WorkflowNodeType.start.name;
    }).toList();
    final endNodes = nodes.where((n) {
      final data = _coerceMap(n['data']);
      return (data['nodeType']?.toString() ?? '') == WorkflowNodeType.end.name;
    }).toList();

    if (startNodes.isEmpty) {
      warnings.add('No start node found. Added a default start node.');
      nodes.insert(0, _defaultStartNode(nodeIds));
      nodeIds.add(nodes.first['id'] as String);
    } else if (startNodes.length > 1) {
      errors.add('More than one start node found.');
    }
    if (endNodes.isEmpty) {
      warnings.add('No end node found. Added a default end node.');
      final end = _defaultEndNode(nodeIds);
      nodes.add(end);
      nodeIds.add(end['id'] as String);
    }

    final startId = nodes
        .firstWhere(
          (n) => _coerceMap(n['data'])['nodeType'] == WorkflowNodeType.start.name,
          orElse: () => nodes.first,
        )['id']
        .toString();

    final reachable = _reachableFrom(startId, connections);
    final unreachable = nodeIds.difference(reachable);
    if (unreachable.isNotEmpty) {
      warnings.add(
        'Dropped ${unreachable.length} unreachable node(s) from start.',
      );
      nodes.removeWhere((n) => unreachable.contains(n['id']));
      connections.removeWhere((c) =>
          unreachable.contains(c['sourceNodeId']) ||
          unreachable.contains(c['targetNodeId']));
    }

    // Port sanity: downgrade obvious invalid ports to defaults (best-effort).
    final nodeTypeById = <String, WorkflowNodeType>{};
    for (final n in nodes) {
      final id = n['id'] as String;
      final data = _coerceMap(n['data']);
      final nt = _parseNodeType(data['nodeType']?.toString()) ?? WorkflowNodeType.start;
      nodeTypeById[id] = nt;
    }
    for (final c in connections) {
      final src = c['sourceNodeId'] as String;
      final srcType = nodeTypeById[src] ?? WorkflowNodeType.start;
      final allowed = _allowedSourcePorts(srcType);
      final sp = (c['sourcePortId'] ?? '').toString();
      if (sp.isEmpty || !allowed.contains(sp)) {
        c['sourcePortId'] = _defaultSourcePort(srcType);
      }
      c['targetPortId'] = 'in';
    }

    final graphData = <String, dynamic>{
      'nodes': nodes,
      'connections': connections,
    };

    // Final structural check: ensure JSON encodable.
    try {
      jsonEncode(graphData);
    } catch (_) {
      errors.add('Generated graph is not JSON-encodable.');
    }

    return WorkflowGraphValidationResult(
      graphData: graphData,
      warnings: warnings,
      errors: errors,
    );
  }

  Map<String, dynamic> _coerceMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) {
      return raw.map((k, v) => MapEntry(k.toString(), v));
    }
    return const <String, dynamic>{};
  }

  num? _toNum(dynamic v) {
    if (v is num) return v;
    if (v is String) return num.tryParse(v);
    return null;
  }

  WorkflowNodeType? _parseNodeType(String? s) {
    if (s == null) return null;
    final t = s.trim().toLowerCase();
    for (final v in WorkflowNodeType.values) {
      if (v.name == t) return v;
    }
    return null;
  }

  Set<String> _reachableFrom(String startId, List<Map<String, dynamic>> conns) {
    final adj = <String, List<String>>{};
    for (final c in conns) {
      final s = c['sourceNodeId']?.toString() ?? '';
      final t = c['targetNodeId']?.toString() ?? '';
      if (s.isEmpty || t.isEmpty) continue;
      (adj[s] ??= []).add(t);
    }
    final seen = <String>{startId};
    final q = <String>[startId];
    while (q.isNotEmpty) {
      final v = q.removeAt(0);
      for (final w in adj[v] ?? const <String>[]) {
        if (seen.add(w)) q.add(w);
      }
    }
    return seen;
  }

  Map<String, dynamic> _defaultStartNode(Set<String> used) {
    var id = 'start-ai';
    var i = 1;
    while (used.contains(id)) {
      id = 'start-ai-${i++}';
    }
    return {
      'id': id,
      'type': 'start',
      'x': 80,
      'y': 140,
      'data': {
        'nodeType': WorkflowNodeType.start.name,
        'label': 'Start',
      },
    };
  }

  Map<String, dynamic> _defaultEndNode(Set<String> used) {
    var id = 'end-ai';
    var i = 1;
    while (used.contains(id)) {
      id = 'end-ai-${i++}';
    }
    return {
      'id': id,
      'type': 'end',
      'x': 520,
      'y': 140,
      'data': {
        'nodeType': WorkflowNodeType.end.name,
        'label': 'Stop',
      },
    };
  }

  Set<String> _allowedSourcePorts(WorkflowNodeType t) {
    switch (t) {
      case WorkflowNodeType.start:
        return const {'next'};
      case WorkflowNodeType.request:
        return const {'success', 'failure'};
      case WorkflowNodeType.condition:
        return const {'true', 'false'};
      case WorkflowNodeType.variable:
      case WorkflowNodeType.transform:
      case WorkflowNodeType.delay:
      case WorkflowNodeType.loop:
        return const {'out'};
      case WorkflowNodeType.end:
        return const <String>{};
    }
  }

  String _defaultSourcePort(WorkflowNodeType t) {
    switch (t) {
      case WorkflowNodeType.start:
        return 'next';
      case WorkflowNodeType.request:
        return 'success';
      case WorkflowNodeType.condition:
        return 'true';
      case WorkflowNodeType.variable:
      case WorkflowNodeType.transform:
      case WorkflowNodeType.delay:
      case WorkflowNodeType.loop:
        return 'out';
      case WorkflowNodeType.end:
        return '';
    }
  }
}

