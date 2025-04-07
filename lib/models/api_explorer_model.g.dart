// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_explorer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiExplorerModelImpl _$$ApiExplorerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ApiExplorerModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      source: json['source'] as String,
      description: json['description'] as String? ?? '',
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      path: json['path'] as String,
      method: $enumDecodeNullable(_$HTTPVerbEnumMap, json['method']) ??
          HTTPVerb.get,
      baseUrl: json['baseUrl'] as String? ?? '',
      operationId: json['operationId'] as String? ?? '',
      parameters: (json['parameters'] as List<dynamic>?)
              ?.map((e) => NameValueModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      headers: (json['headers'] as List<dynamic>?)
              ?.map((e) => NameValueModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      requestBody: json['requestBody'] as Map<String, dynamic>?,
      responses: json['responses'] as Map<String, dynamic>?,
      parameterSchemas:
          json['parameterSchemas'] as Map<String, dynamic>? ?? const {},
      headerSchemas: json['headerSchemas'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$ApiExplorerModelImplToJson(
        _$ApiExplorerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'source': instance.source,
      'description': instance.description,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'path': instance.path,
      'method': _$HTTPVerbEnumMap[instance.method]!,
      'baseUrl': instance.baseUrl,
      'operationId': instance.operationId,
      'parameters': instance.parameters.map((e) => e.toJson()).toList(),
      'headers': instance.headers.map((e) => e.toJson()).toList(),
      'requestBody': instance.requestBody,
      'responses': instance.responses,
      'parameterSchemas': instance.parameterSchemas,
      'headerSchemas': instance.headerSchemas,
    };

const _$HTTPVerbEnumMap = {
  HTTPVerb.get: 'get',
  HTTPVerb.head: 'head',
  HTTPVerb.post: 'post',
  HTTPVerb.put: 'put',
  HTTPVerb.patch: 'patch',
  HTTPVerb.delete: 'delete',
};
