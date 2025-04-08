import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'workflow_connection_model.freezed.dart';
part 'workflow_connection_model.g.dart';

/// Model representing a connection between nodes in a workflow
@freezed
class WorkflowConnectionModel with _$WorkflowConnectionModel {
  const WorkflowConnectionModel._();

  const factory WorkflowConnectionModel({
    required String id,
    required String sourceId,
    required String targetId,
    @Default('') String label,
    @Default(false) bool isConditional,
    @Default('') String condition,
  }) = _WorkflowConnectionModel;

  factory WorkflowConnectionModel.create({
    required String sourceId,
    required String targetId,
    String label = '',
    bool isConditional = false,
    String condition = '',
  }) {
    return WorkflowConnectionModel(
      id: const Uuid().v4(),
      sourceId: sourceId,
      targetId: targetId,
      label: label,
      isConditional: isConditional,
      condition: condition,
    );
  }

  factory WorkflowConnectionModel.fromJson(Map<String, dynamic> json) => 
      _$WorkflowConnectionModelFromJson(json);
}
