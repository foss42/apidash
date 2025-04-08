import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import 'workflow_node_model.dart';
import 'workflow_connection_model.dart';

part 'workflow_model.freezed.dart';
part 'workflow_model.g.dart';

/// Model representing an entire workflow
@freezed
class WorkflowModel with _$WorkflowModel {
  const WorkflowModel._();

  const factory WorkflowModel({
    required String id,
    @Default('New Workflow') String name,
    @Default('') String description,
    @Default([]) List<WorkflowNodeModel> nodes,
    @Default([]) List<WorkflowConnectionModel> connections,
  }) = _WorkflowModel;

  factory WorkflowModel.create() {
    return WorkflowModel(
      id: const Uuid().v4(),
    );
  }

  factory WorkflowModel.fromJson(Map<String, dynamic> json) => 
      _$WorkflowModelFromJson(json);
}
