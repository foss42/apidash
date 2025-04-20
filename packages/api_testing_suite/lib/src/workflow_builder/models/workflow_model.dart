import 'package:api_testing_suite/api_testing_suite.dart';
import 'package:apidash_core/apidash_core.dart';

import 'package:uuid/uuid.dart';

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
  }) = _WorkflowModel;

  factory WorkflowModel.fromJson(Map<String, dynamic> json) => 
      _$WorkflowModelFromJson(json);

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
    );
  }

  bool get hasStartNode => startNodeId != null;

  DateTime? get createdAt {
    if (metadata.containsKey('createdAt')) {
      final value = metadata['createdAt'];
      if (value is DateTime) return value;
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (_) {
          return null;
        }
      }
    }
    return null;
  }

  WorkflowNodeModel? getStartNode() {
    if (startNodeId == null) return null;
    return nodes.firstWhere((node) => node.id == startNodeId);
  }

  List<WorkflowNodeModel> getActiveNodes() {
    return nodes.where((node) => activeNodeIds.contains(node.id)).toList();
  }

  List<WorkflowNodeModel> getCompletedNodes() {
    return nodes.where((node) => completedNodeIds.contains(node.id)).toList();
  }

  WorkflowNodeModel? getNodeById(String nodeId) {
    return nodes.firstWhereOrNull((node) => node.id == nodeId);
  }

  List<WorkflowConnectionModel> getConnectionsFromNode(String nodeId) {
    return connections.where((conn) => conn.sourceId == nodeId).toList();
  }

  List<WorkflowConnectionModel> getConnectionsToNode(String nodeId) {
    return connections.where((conn) => conn.targetId == nodeId).toList();
  }
}
