import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'workflow_node_model.dart';
import 'workflow_connection_model.dart';

part 'workflow_model.freezed.dart';
part 'workflow_model.g.dart';

/// Model representing a workflow
@freezed
class WorkflowModel with _$WorkflowModel {
  const WorkflowModel._();

  const factory WorkflowModel({
    required String id,
    required String name,
    @Default('') String description,
    required List<WorkflowNodeModel> nodes,
    required List<WorkflowConnectionModel> connections,
    @Default(false) bool isConnectionModeActive,
    @Default(null) String? selectedNodeId,
    @Default(null) String? startNodeId,
    @Default([]) List<String> activeNodeIds,
    @Default([]) List<String> completedNodeIds,
    @Default({}) Map<String, dynamic> metadata,
    DateTime? createdAt,
  }) = _WorkflowModel;

  factory WorkflowModel.fromJson(Map<String, dynamic> json) => 
      _$WorkflowModelFromJson(json);

  /// Create a new workflow with a unique ID
  factory WorkflowModel.create({
    required String name,
    String description = '',
    List<WorkflowNodeModel> nodes = const [],
    List<WorkflowConnectionModel> connections = const [],
    Map<String, dynamic> metadata = const {},
  }) {
    return WorkflowModel(
      id: const Uuid().v4(),
      name: name,
      description: description,
      nodes: nodes,
      connections: connections,
      metadata: metadata,
      createdAt: DateTime.now(),
    );
  }

  /// Returns whether a start node has been set for this workflow
  bool get hasStartNode => startNodeId != null;

  WorkflowNodeModel? getStartNode() {
    if (startNodeId == null) return null;
    try {
      return nodes.firstWhere((node) => node.id == startNodeId);
    } catch (e) {
      return null; 
    }
  }

  List<WorkflowNodeModel> getActiveNodes() {
    return nodes.where((node) => activeNodeIds.contains(node.id)).toList();
  }

  List<WorkflowNodeModel> getCompletedNodes() {
    return nodes.where((node) => completedNodeIds.contains(node.id)).toList();
  }

  /// Find a node by its ID
  ///
  /// Returns null if the node is not found
  WorkflowNodeModel? getNodeById(String nodeId) {
    try {
      return nodes.firstWhere((node) => node.id == nodeId);
    } catch (e) {
      return null; 
    }
  }

  List<WorkflowConnectionModel> getConnectionsFromNode(String nodeId) {
    return connections.where((conn) => conn.sourceId == nodeId).toList();
  }

  List<WorkflowConnectionModel> getConnectionsToNode(String nodeId) {
    return connections.where((conn) => conn.targetId == nodeId).toList();
  }
}
