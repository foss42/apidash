import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/workflow/models/workflow_request_codec.dart';
import 'package:apidash_core/apidash_core.dart';

enum WorkflowNodeType { request, condition, manualStart, loop, delay }

enum WorkflowLoopMode {
  forEach,
  repeat;

  static WorkflowLoopMode fromJson(String? value) {
    if (value == 'repeat') {
      return WorkflowLoopMode.repeat;
    }
    return WorkflowLoopMode.forEach;
  }

  String toJson() => this == WorkflowLoopMode.repeat ? 'repeat' : 'forEach';
}

enum WorkflowEdgeHandle {
  next,
  loopDone,
  success,
  failure,
  then,
  elseBranch,
  inPort,
}

class WorkflowPosition {
  const WorkflowPosition({this.x = 0, this.y = 0});

  final double x;
  final double y;

  Map<String, dynamic> toJson() => {'x': x, 'y': y};

  factory WorkflowPosition.fromJson(Map<String, dynamic> json) =>
      WorkflowPosition(
        x: (json['x'] as num?)?.toDouble() ?? 0,
        y: (json['y'] as num?)?.toDouble() ?? 0,
      );
}

class WorkflowInheritFrom {
  const WorkflowInheritFrom({
    required this.collectionId,
    required this.requestId,
  });

  final String collectionId;
  final String requestId;

  Map<String, dynamic> toJson() => {
        'collectionId': collectionId,
        'requestId': requestId,
      };

  factory WorkflowInheritFrom.fromJson(Map<String, dynamic> json) =>
      WorkflowInheritFrom(
        collectionId: json['collectionId']?.toString() ?? '',
        requestId: json['requestId']?.toString() ?? '',
      );
}

class WorkflowExtraction {
  const WorkflowExtraction({
    required this.varName,
    required this.jsonPath,
    this.source = 'response.body',
  });

  final String varName;
  final String source;
  final String jsonPath;

  Map<String, dynamic> toJson() => {
        'var': varName,
        'path': jsonPath,
        if (source != 'response.body') 'source': source,
      };

  factory WorkflowExtraction.fromJson(Map<String, dynamic> json) =>
      WorkflowExtraction(
        varName: json['var']?.toString() ?? '',
        source: json['source']?.toString() ?? 'response.body',
        jsonPath: (json['path'] ?? json['jsonPath'])?.toString() ?? '',
      );
}

class WorkflowGraphNode {
  const WorkflowGraphNode({
    required this.id,
    required this.type,
    required this.position,
    this.label = '',
    this.request,
    this.inheritFrom,
    this.conditionExpression,
    this.loopExpression,
    this.loopMaxIterations,
    this.loopMode = WorkflowLoopMode.forEach,
    this.delayMs,
    this.extractions = const [],
  });

  final String id;
  final WorkflowNodeType type;
  final WorkflowPosition position;
  final String label;
  final Map<String, dynamic>? request;
  final WorkflowInheritFrom? inheritFrom;
  final String? conditionExpression;
  final String? loopExpression;
  final int? loopMaxIterations;
  final WorkflowLoopMode loopMode;
  final int? delayMs;
  final List<WorkflowExtraction> extractions;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'type': _nodeTypeToJson(type),
      'position': position.toJson(),
    };
    if (label.isNotEmpty) {
      json['label'] = label;
    }
    if (type == WorkflowNodeType.request) {
      if (request != null && request!.isNotEmpty) {
        json['request'] = request;
      }
      if (inheritFrom != null) {
        json['inheritFrom'] = inheritFrom!.toJson();
      }
      if (extractions.isNotEmpty) {
        json['extract'] = extractions.map((e) => e.toJson()).toList();
      }
    }
    if (conditionExpression != null && conditionExpression!.isNotEmpty) {
      json['expr'] = conditionExpression;
    }
    if (loopExpression != null && loopExpression!.isNotEmpty) {
      json['items'] = loopExpression;
    }
    if (loopMaxIterations != null && loopMaxIterations! > 0) {
      json['max'] = loopMaxIterations;
    }
    if (loopMode != WorkflowLoopMode.forEach) {
      json['mode'] = loopMode.toJson();
    }
    if (delayMs != null && delayMs! > 0) {
      json['ms'] = delayMs;
    }
    return json;
  }

  factory WorkflowGraphNode.fromJson(Map<String, dynamic> json) {
    final type = _nodeTypeFromJson(json['type']?.toString());
    final extractRaw = json['extract'] ?? json['extractions'];
    final maxRaw = json['max'] ?? json['loopMaxIterations'];
    final msRaw = json['ms'] ?? json['delayMs'];
    return WorkflowGraphNode(
      id: json['id']?.toString() ?? '',
      type: type,
      position: json['position'] is Map
          ? WorkflowPosition.fromJson(
              Map<String, dynamic>.from(json['position'] as Map),
            )
          : const WorkflowPosition(),
      label: json['label']?.toString() ?? '',
      request: json['request'] is Map
          ? Map<String, dynamic>.from(json['request'] as Map)
          : null,
      inheritFrom: json['inheritFrom'] is Map
          ? WorkflowInheritFrom.fromJson(
              Map<String, dynamic>.from(json['inheritFrom'] as Map),
            )
          : null,
      conditionExpression:
          (json['expr'] ?? json['conditionExpression'])?.toString(),
      loopExpression: (json['items'] ?? json['loopExpression'])?.toString(),
      loopMaxIterations: maxRaw is num ? maxRaw.toInt() : null,
      loopMode: WorkflowLoopMode.fromJson(
        (json['mode'] ?? json['loopMode'])?.toString(),
      ),
      delayMs: msRaw is num ? msRaw.toInt() : null,
      extractions: extractRaw is List
          ? [
              for (final item in extractRaw)
                if (item is Map)
                  WorkflowExtraction.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
            ]
          : const [],
    );
  }

  WorkflowGraphNode copyWith({
    String? id,
    WorkflowNodeType? type,
    WorkflowPosition? position,
    String? label,
    Map<String, dynamic>? request,
    bool clearRequest = false,
    WorkflowInheritFrom? inheritFrom,
    bool clearInheritFrom = false,
    String? conditionExpression,
    bool clearConditionExpression = false,
    String? loopExpression,
    bool clearLoopExpression = false,
    int? loopMaxIterations,
    bool clearLoopMaxIterations = false,
    WorkflowLoopMode? loopMode,
    int? delayMs,
    bool clearDelayMs = false,
    List<WorkflowExtraction>? extractions,
  }) =>
      WorkflowGraphNode(
        id: id ?? this.id,
        type: type ?? this.type,
        position: position ?? this.position,
        label: label ?? this.label,
        request: clearRequest ? null : (request ?? this.request),
        inheritFrom:
            clearInheritFrom ? null : (inheritFrom ?? this.inheritFrom),
        conditionExpression: clearConditionExpression
            ? null
            : (conditionExpression ?? this.conditionExpression),
        loopExpression: clearLoopExpression
            ? null
            : (loopExpression ?? this.loopExpression),
        loopMaxIterations: clearLoopMaxIterations
            ? null
            : (loopMaxIterations ?? this.loopMaxIterations),
        loopMode: loopMode ?? this.loopMode,
        delayMs: clearDelayMs ? null : (delayMs ?? this.delayMs),
        extractions: extractions ?? this.extractions,
      );

  RequestModel? requestModel() {
    if (type != WorkflowNodeType.request || request == null) {
      return null;
    }
    return decodeWorkflowRequest(request!);
  }
}

class WorkflowGraphEdge {
  const WorkflowGraphEdge({
    required this.id,
    required this.source,
    required this.target,
    this.sourceHandle = WorkflowEdgeHandle.success,
    this.targetHandle = WorkflowEdgeHandle.inPort,
    this.label = '',
  });

  final String id;
  final String source;
  final String target;
  final WorkflowEdgeHandle sourceHandle;
  final WorkflowEdgeHandle targetHandle;
  final String label;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'from': source,
      'to': target,
    };
    // Omit only request-default `success`. Keep `next`/`then`/`else`/… explicit.
    if (sourceHandle != WorkflowEdgeHandle.success) {
      json['out'] = _handleToJson(sourceHandle);
    }
    if (label.isNotEmpty) {
      json['label'] = label;
    }
    return json;
  }

  factory WorkflowGraphEdge.fromJson(
    Map<String, dynamic> json, {
    WorkflowEdgeHandle defaultSourceHandle = WorkflowEdgeHandle.success,
  }) {
    final hasExplicitOut =
        json.containsKey('out') || json.containsKey('sourceHandle');
    final rawOut = json['out']?.toString() ?? json['sourceHandle']?.toString();
    return WorkflowGraphEdge(
      id: json['id']?.toString() ?? '',
      source: (json['from'] ?? json['source'])?.toString() ?? '',
      target: (json['to'] ?? json['target'])?.toString() ?? '',
      sourceHandle: hasExplicitOut
          ? _parseHandle(rawOut, defaultSourceHandle)
          : defaultSourceHandle,
      targetHandle: _parseHandle(
        json['targetHandle']?.toString(),
        WorkflowEdgeHandle.inPort,
      ),
      label: json['label']?.toString() ?? '',
    );
  }
}

String _nodeTypeToJson(WorkflowNodeType type) => switch (type) {
      WorkflowNodeType.manualStart => 'start',
      _ => type.name,
    };

WorkflowNodeType _nodeTypeFromJson(String? raw) {
  if (raw == 'start' || raw == 'manualStart') {
    return WorkflowNodeType.manualStart;
  }
  return WorkflowNodeType.values.firstWhere(
    (value) => value.name == raw,
    orElse: () => WorkflowNodeType.request,
  );
}

WorkflowEdgeHandle _defaultOutForSource(WorkflowGraphNode? source) {
  return switch (source?.type) {
    WorkflowNodeType.request => WorkflowEdgeHandle.success,
    WorkflowNodeType.condition => WorkflowEdgeHandle.then,
    _ => WorkflowEdgeHandle.next,
  };
}

String _handleToJson(WorkflowEdgeHandle handle) {
  return switch (handle) {
    WorkflowEdgeHandle.elseBranch => 'else',
    WorkflowEdgeHandle.inPort => 'in',
    WorkflowEdgeHandle.loopDone => 'done',
    _ => handle.name,
  };
}

WorkflowEdgeHandle _parseHandle(String? raw, WorkflowEdgeHandle fallback) {
  if (raw == null || raw.isEmpty) {
    return fallback;
  }
  if (raw == 'else') {
    return WorkflowEdgeHandle.elseBranch;
  }
  if (raw == 'in') {
    return WorkflowEdgeHandle.inPort;
  }
  if (raw == 'done') {
    return WorkflowEdgeHandle.loopDone;
  }
  return WorkflowEdgeHandle.values.firstWhere(
    (value) => value.name == raw,
    orElse: () => fallback,
  );
}

class WorkflowGraph {
  const WorkflowGraph({
    this.nodes = const [],
    this.edges = const [],
  });

  final List<WorkflowGraphNode> nodes;
  final List<WorkflowGraphEdge> edges;

  factory WorkflowGraph.fromJson({
    required List<dynamic>? nodesRaw,
    required List<dynamic>? edgesRaw,
  }) {
    final nodes = [
      for (final item in nodesRaw ?? const [])
        if (item is Map)
          WorkflowGraphNode.fromJson(Map<String, dynamic>.from(item)),
    ];
    final nodesById = {for (final node in nodes) node.id: node};
    return WorkflowGraph(
      nodes: nodes,
      edges: [
        for (final item in edgesRaw ?? const [])
          if (item is Map)
            WorkflowGraphEdge.fromJson(
              Map<String, dynamic>.from(item),
              defaultSourceHandle: _defaultOutForSource(
                nodesById[(item['from'] ?? item['source'])?.toString()],
              ),
            ),
      ],
    );
  }

  WorkflowGraph copyWith({
    List<WorkflowGraphNode>? nodes,
    List<WorkflowGraphEdge>? edges,
  }) =>
      WorkflowGraph(
        nodes: nodes ?? this.nodes,
        edges: edges ?? this.edges,
      );

  int get requestNodeCount =>
      nodes.where((node) => node.type == WorkflowNodeType.request).length;
}

/// Lean on-disk / Dashbot workflow document.
class WorkflowDocument {
  const WorkflowDocument({
    required this.id,
    required this.name,
    required this.modifiedAt,
    this.description = '',
    this.graph = const WorkflowGraph(),
  });

  final String id;
  final String name;
  final String description;
  final DateTime modifiedAt;
  final WorkflowGraph graph;

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description.isNotEmpty) 'description': description,
        'modifiedAt': modifiedAt.toIso8601String(),
        'nodes': graph.nodes.map((node) => node.toJson()).toList(),
        'edges': graph.edges.map((edge) => edge.toJson()).toList(),
      };

  factory WorkflowDocument.fromJson(Map<String, dynamic> json) {
    final name = json['name']?.toString() ?? kUntitled;
    final graphRaw = json['graph'];
    final List<dynamic>? nodesRaw;
    final List<dynamic>? edgesRaw;
    if (graphRaw is Map) {
      nodesRaw = graphRaw['nodes'] as List?;
      edgesRaw = graphRaw['edges'] as List?;
    } else {
      nodesRaw = json['nodes'] as List?;
      edgesRaw = json['edges'] as List?;
    }
    final idRaw = json['id']?.toString() ?? '';
    return WorkflowDocument(
      id: idRaw.isNotEmpty ? idRaw : name,
      name: name,
      description: json['description']?.toString() ?? '',
      modifiedAt: DateTime.tryParse(json['modifiedAt']?.toString() ?? '') ??
          DateTime.now(),
      graph: WorkflowGraph.fromJson(nodesRaw: nodesRaw, edgesRaw: edgesRaw),
    );
  }

  WorkflowDocument copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? modifiedAt,
    WorkflowGraph? graph,
  }) =>
      WorkflowDocument(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        modifiedAt: modifiedAt ?? this.modifiedAt,
        graph: graph ?? this.graph,
      );

  WorkflowGraphNode? nodeById(String nodeId) {
    for (final node in graph.nodes) {
      if (node.id == nodeId) {
        return node;
      }
    }
    return null;
  }
}

enum WorkflowNodeRunStatus { pending, running, success, failed, skipped }

class WorkflowNodeRunResult {
  const WorkflowNodeRunResult({
    required this.nodeId,
    required this.status,
    this.label = '',
    this.message,
    this.durationMs,
    this.statusCode,
    this.loopIndex,
    this.nodeType,
    this.detail,
    this.branch,
    this.apiType,
    this.method,
    this.url,
    this.requestHeaders,
    this.requestBody,
    this.httpResponseModel,
    this.extractedVariables = const {},
  });

  final String nodeId;
  final String label;
  final WorkflowNodeRunStatus status;
  final String? message;
  final int? durationMs;
  final int? statusCode;
  final String? loopIndex;
  final WorkflowNodeType? nodeType;
  final String? detail;
  final String? branch;
  final APIType? apiType;
  final HTTPVerb? method;
  final String? url;
  final Map<String, String>? requestHeaders;
  final String? requestBody;
  final HttpResponseModel? httpResponseModel;
  final Map<String, String> extractedVariables;

  bool get hasHttpExchange =>
      method != null ||
      (url != null && url!.trim().isNotEmpty) ||
      httpResponseModel != null;

  bool get isRequestStep =>
      nodeType == WorkflowNodeType.request || hasHttpExchange;

  WorkflowNodeRunResult copyWith({
    String? nodeId,
    String? label,
    WorkflowNodeRunStatus? status,
    String? message,
    int? durationMs,
    int? statusCode,
    String? loopIndex,
    bool clearLoopIndex = false,
    WorkflowNodeType? nodeType,
    String? detail,
    String? branch,
    APIType? apiType,
    HTTPVerb? method,
    String? url,
    Map<String, String>? requestHeaders,
    String? requestBody,
    HttpResponseModel? httpResponseModel,
    Map<String, String>? extractedVariables,
  }) =>
      WorkflowNodeRunResult(
        nodeId: nodeId ?? this.nodeId,
        label: label ?? this.label,
        status: status ?? this.status,
        message: message ?? this.message,
        durationMs: durationMs ?? this.durationMs,
        statusCode: statusCode ?? this.statusCode,
        loopIndex: clearLoopIndex ? null : (loopIndex ?? this.loopIndex),
        nodeType: nodeType ?? this.nodeType,
        detail: detail ?? this.detail,
        branch: branch ?? this.branch,
        apiType: apiType ?? this.apiType,
        method: method ?? this.method,
        url: url ?? this.url,
        requestHeaders: requestHeaders ?? this.requestHeaders,
        requestBody: requestBody ?? this.requestBody,
        httpResponseModel: httpResponseModel ?? this.httpResponseModel,
        extractedVariables: extractedVariables ?? this.extractedVariables,
      );

  RequestModel? asRequestModel() {
    if (!hasHttpExchange) {
      return null;
    }
    return RequestModel(
      id: nodeId,
      name: label,
      apiType: apiType ?? APIType.rest,
      httpRequestModel: HttpRequestModel(
        method: method ?? HTTPVerb.get,
        url: url ?? '',
        body: requestBody,
      ),
      responseStatus: statusCode,
      message: message,
      httpResponseModel: httpResponseModel,
    );
  }
}

class WorkflowRunResult {
  const WorkflowRunResult({
    required this.workflowId,
    required this.success,
    required this.startedAt,
    required this.endedAt,
    required this.nodeResults,
    this.error,
    this.scopedVariables = const {},
  });

  final String workflowId;
  final bool success;
  final DateTime startedAt;
  final DateTime endedAt;
  final List<WorkflowNodeRunResult> nodeResults;
  final String? error;
  final Map<String, String> scopedVariables;

  int get durationMs => endedAt.difference(startedAt).inMilliseconds;
}
