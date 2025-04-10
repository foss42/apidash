import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'workflow_connection_model.freezed.dart';

/// Model representing a connection between nodes in a workflow
@freezed
class WorkflowConnectionModel with _$WorkflowConnectionModel {
  const factory WorkflowConnectionModel({
    required String id,
    required String sourceId,
    required String targetId,
    required String workflowId,
    @JsonKey(fromJson: _offsetFromJson, toJson: _offsetToJson) required Offset position,
    String? label,
    @Default(false) bool isConditional,
    String? condition,
  }) = _WorkflowConnectionModel;

  factory WorkflowConnectionModel.fromJson(Map<String, dynamic> json) =>
      _$WorkflowConnectionModelFromJson(json);

  factory WorkflowConnectionModel.create({
    required String sourceId,
    required String targetId,
    required String workflowId,
    required Offset position,
    String? label,
    bool isConditional = false,
    String? condition,
  }) =>
      WorkflowConnectionModel(
        id: const Uuid().v4(),
        sourceId: sourceId,
        targetId: targetId,
        workflowId: workflowId,
        position: position,
        label: label,
        isConditional: isConditional,
        condition: condition,
      );
}

Offset _offsetFromJson(Map<String, dynamic> json) {
  return Offset(json['dx'] as double, json['dy'] as double);
}

Map<String, dynamic> _offsetToJson(Offset offset) {
  return {'dx': offset.dx, 'dy': offset.dy};
}
