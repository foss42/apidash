import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import 'core_models.dart';
import 'node_status.dart';

part 'workflow_node_model.freezed.dart';
part 'workflow_node_model.g.dart';

/// Custom JSON converter for Flutter's Offset class
class OffsetConverter implements JsonConverter<Offset, Map<String, dynamic>> {
  const OffsetConverter();

  @override
  Offset fromJson(Map<String, dynamic> json) {
    return Offset(
      (json['dx'] as num).toDouble(),
      (json['dy'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson(Offset offset) {
    return {
      'dx': offset.dx,
      'dy': offset.dy,
    };
  }
}

/// Custom JSON converter for RequestModel
class RequestModelConverter implements JsonConverter<RequestModel?, Map<String, dynamic>?> {
  const RequestModelConverter();

  @override
  RequestModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return RequestModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      method: json['method'] as String? ?? 'GET',
      url: json['url'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic>? toJson(RequestModel? requestModel) {
    if (requestModel == null) return null;
    return {
      'id': requestModel.id,
      'name': requestModel.name,
      'method': requestModel.method,
      'url': requestModel.url,
    };
  }
}

/// Model representing a node in a workflow
@freezed
class WorkflowNodeModel with _$WorkflowNodeModel {
  const WorkflowNodeModel._();

  const factory WorkflowNodeModel({
    required String id,
    required String requestId,
    @OffsetConverter() required Offset position,
    @Default('') String label,
    @Default(NodeStatus.inactive) NodeStatus status,
    @Default([]) List<String> connectedToIds,
    @RequestModelConverter() RequestModel? requestModel,
    @Default({}) Map<String, dynamic> simulatedResponse,
    @Default(200) int simulatedStatusCode,
  }) = _WorkflowNodeModel;

  factory WorkflowNodeModel.create({
    required String requestId,
    @OffsetConverter() required Offset position,
    required String label,
    RequestModel? requestModel,
  }) {
    return WorkflowNodeModel(
      id: const Uuid().v4(),
      requestId: requestId,
      position: position,
      label: label,
      requestModel: requestModel,
    );
  }

  factory WorkflowNodeModel.fromJson(Map<String, dynamic> json) => 
      _$WorkflowNodeModelFromJson(json);
}
