// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grpc_request_model.dart';

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

_GrpcRequestModel _$GrpcRequestModelFromJson(Map json) => _GrpcRequestModel(
  url: json['url'] as String? ?? "",
  service: json['service'] as String?,
  method: json['method'] as String?,
  protoFile: json['protoFile'] as String?,
  useTLS: json['useTLS'] as bool? ?? false,
  streamingType:
      $enumDecodeNullable(_$GrpcStreamingTypeEnumMap, json['streamingType']) ??
      GrpcStreamingType.unary,
  messageHistory:
      (json['messageHistory'] as List<dynamic>?)
          ?.map(
            (e) =>
                WebSocketMessage.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList() ??
      const [],
  requestBody: json['requestBody'] as String? ?? "",
  useReflection: json['useReflection'] as bool? ?? false,
  metadata:
      (json['metadata'] as List<dynamic>?)
          ?.map(
            (e) => NameValueModel.fromJson(Map<String, Object?>.from(e as Map)),
          )
          .toList() ??
      const [],
  isMetadataEnabled:
      (json['isMetadataEnabled'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList() ??
      const [],
  authModel: json['authModel'] == null
      ? null
      : AuthModel.fromJson(Map<String, dynamic>.from(json['authModel'] as Map)),
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
          ?.map(
            (e) => GrpcParameterModel.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$GrpcRequestModelToJson(_GrpcRequestModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'service': instance.service,
      'method': instance.method,
      'protoFile': instance.protoFile,
      'useTLS': instance.useTLS,
      'streamingType': _$GrpcStreamingTypeEnumMap[instance.streamingType]!,
      'messageHistory': instance.messageHistory.map((e) => e.toJson()).toList(),
      'requestBody': instance.requestBody,
      'useReflection': instance.useReflection,
      'metadata': instance.metadata?.map((e) => e.toJson()).toList(),
      'isMetadataEnabled': instance.isMetadataEnabled,
      'authModel': instance.authModel?.toJson(),
      'availableServices': instance.availableServices,
      'availableMethods': instance.availableMethods,
      'parameters': instance.parameters.map((e) => e.toJson()).toList(),
    };

const _$GrpcStreamingTypeEnumMap = {
  GrpcStreamingType.unary: 'unary',
  GrpcStreamingType.client: 'client',
  GrpcStreamingType.server: 'server',
  GrpcStreamingType.bidi: 'bidi',
};
