// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grpc_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GrpcParameterModel _$GrpcParameterModelFromJson(Map<String, dynamic> json) =>
    _GrpcParameterModel(
      name: json['name'] as String,
      tag: (json['tag'] as num?)?.toInt(),
      type: json['type'] as String? ?? "string",
      value: json['value'] as String? ?? "",
      enabled: json['enabled'] as bool? ?? true,
      enumValues: (json['enumValues'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$GrpcParameterModelToJson(_GrpcParameterModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'tag': instance.tag,
      'type': instance.type,
      'value': instance.value,
      'enabled': instance.enabled,
      'enumValues': instance.enumValues,
    };

_GrpcRequestModel _$GrpcRequestModelFromJson(
  Map<String, dynamic> json,
) => _GrpcRequestModel(
  host: json['host'] as String,
  port: (json['port'] as num?)?.toInt() ?? 50051,
  service: json['service'] as String?,
  method: json['method'] as String?,
  protoFile: json['protoFile'] as String?,
  useTLS: json['useTLS'] as bool? ?? false,
  streamingType:
      $enumDecodeNullable(_$GrpcStreamingTypeEnumMap, json['streamingType']) ??
      GrpcStreamingType.unary,
  messageHistory:
      (json['messageHistory'] as List<dynamic>?)
          ?.map((e) => WebSocketMessage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  requestBody: json['requestBody'] as String? ?? "",
  useReflection: json['useReflection'] as bool? ?? false,
  metadata:
      (json['metadata'] as List<dynamic>?)
          ?.map((e) => NameValueModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isMetadataEnabled:
      (json['isMetadataEnabled'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList() ??
      const [],
  availableServices:
      (json['availableServices'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  availableMethods:
      (json['availableMethods'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  parameters:
      (json['parameters'] as List<dynamic>?)
          ?.map((e) => GrpcParameterModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$GrpcRequestModelToJson(_GrpcRequestModel instance) =>
    <String, dynamic>{
      'host': instance.host,
      'port': instance.port,
      'service': instance.service,
      'method': instance.method,
      'protoFile': instance.protoFile,
      'useTLS': instance.useTLS,
      'streamingType': _$GrpcStreamingTypeEnumMap[instance.streamingType]!,
      'messageHistory': instance.messageHistory,
      'requestBody': instance.requestBody,
      'useReflection': instance.useReflection,
      'metadata': instance.metadata,
      'isMetadataEnabled': instance.isMetadataEnabled,
      'availableServices': instance.availableServices,
      'availableMethods': instance.availableMethods,
      'parameters': instance.parameters,
    };

const _$GrpcStreamingTypeEnumMap = {
  GrpcStreamingType.unary: 'unary',
  GrpcStreamingType.client: 'client',
  GrpcStreamingType.server: 'server',
  GrpcStreamingType.bidi: 'bidi',
};
