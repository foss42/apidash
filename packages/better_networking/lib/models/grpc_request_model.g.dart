// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grpc_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GrpcMetadataEntry _$GrpcMetadataEntryFromJson(Map<String, dynamic> json) =>
    GrpcMetadataEntry(
      key: json['key'] as String? ?? "",
      value: json['value'] as String? ?? "",
    );

Map<String, dynamic> _$GrpcMetadataEntryToJson(GrpcMetadataEntry instance) =>
    <String, dynamic>{'key': instance.key, 'value': instance.value};

GrpcRequestModel _$GrpcRequestModelFromJson(Map json) => GrpcRequestModel(
  host: json['host'] as String? ?? "",
  port: (json['port'] as num?)?.toInt() ?? 50051,
  useTls: json['useTls'] as bool? ?? false,
  selectedService: json['selectedService'] as String?,
  selectedMethod: json['selectedMethod'] as String?,
  requestBody: json['requestBody'] as String? ?? "{}",
  metadata:
      (json['metadata'] as List<dynamic>?)
          ?.map(
            (e) =>
                GrpcMetadataEntry.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList() ??
      const <GrpcMetadataEntry>[],
  useReflection: json['useReflection'] as bool? ?? true,
  descriptorFileBytes: _uint8ListFromJson(
    json['descriptorFileBytes'] as String?,
  ),
);

Map<String, dynamic> _$GrpcRequestModelToJson(GrpcRequestModel instance) =>
    <String, dynamic>{
      'host': instance.host,
      'port': instance.port,
      'useTls': instance.useTls,
      'selectedService': instance.selectedService,
      'selectedMethod': instance.selectedMethod,
      'requestBody': instance.requestBody,
      'metadata': instance.metadata.map((e) => e.toJson()).toList(),
      'useReflection': instance.useReflection,
      'descriptorFileBytes': _uint8ListToJson(instance.descriptorFileBytes),
    };
