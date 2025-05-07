import 'package:uuid/uuid.dart';

class WorkflowNode {
  final String id;
  final String name;
  final String type;
  final Map<String, dynamic> data;
  final List<String> inputs;
  final List<String> outputs;

  WorkflowNode({
    String? id,
    required this.name,
    required this.type,
    required this.data,
    List<String>? inputs,
    List<String>? outputs,
  })  : id = id ?? const Uuid().v4(),
        inputs = inputs ?? [],
        outputs = outputs ?? [];

  WorkflowNode copyWith({
    String? name,
    String? type,
    Map<String, dynamic>? data,
    List<String>? inputs,
    List<String>? outputs,
  }) {
    return WorkflowNode(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      data: data ?? this.data,
      inputs: inputs ?? this.inputs,
      outputs: outputs ?? this.outputs,
    );
  }
}

// In your workflow model class:
class WorkflowConnection {
  final String sourceNodeId;
  final String targetNodeId;
  final String sourcePort;
  final String targetPort;

  WorkflowConnection({
    required this.sourceNodeId,
    required this.targetNodeId,
    required this.sourcePort,
    required this.targetPort,
  });
}


class Workflow {
  final String id;
  final String name;
  final List<WorkflowNode> nodes;
  final List<WorkflowConnection> connections;

  Workflow({
    String? id,
    required this.name,
    List<WorkflowNode>? nodes,
    List<WorkflowConnection>? connections,
  })  : id = id ?? const Uuid().v4(),
        nodes = nodes ?? [],
        connections = connections ?? [];

  Workflow copyWith({
    String? name,
    List<WorkflowNode>? nodes,
    List<WorkflowConnection>? connections,
  }) {
    return Workflow(
      id: id,
      name: name ?? this.name,
      nodes: nodes ?? this.nodes,
      connections: connections ?? this.connections,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Workflow &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}
