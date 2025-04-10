import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

part 'workflow_connection.freezed.dart';

/// Model representing a connection between two nodes in a workflow
@freezed
class WorkflowConnection with _$WorkflowConnection {
  const WorkflowConnection._();

  const factory WorkflowConnection({
    required String id,
    required String sourceId,
    required String targetId,
    required String workflowId,
    required Offset position,
    @Default(ConnectionType.standard) ConnectionType type,
    @Default([]) List<String> labels,
    @Default({}) Map<String, dynamic> metadata,
  }) = _WorkflowConnection;

  factory WorkflowConnection.fromJson(Map<String, dynamic> json) => 
      _$WorkflowConnectionFromJson(json);

  factory WorkflowConnection.create({
    required String sourceId,
    required String targetId,
    required String workflowId,
    required Offset position,
    ConnectionType type = ConnectionType.standard,
    List<String> labels = const [],
    Map<String, dynamic> metadata = const {},
  }) {
    return WorkflowConnection(
      id: const Uuid().v4(),
      sourceId: sourceId,
      targetId: targetId,
      workflowId: workflowId,
      position: position,
      type: type,
      labels: labels,
      metadata: metadata,
    );
  }

}

enum ConnectionType {
  standard,
  conditional,
  error,
}

extension ConnectionTypeExtension on ConnectionType {
  Color get color {
    switch (this) {
      case ConnectionType.standard:
        return Colors.blue;
      case ConnectionType.conditional:
        return Colors.orange;
      case ConnectionType.error:
        return Colors.red;
    }
  }
}
