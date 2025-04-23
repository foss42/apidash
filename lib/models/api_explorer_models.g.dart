// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_explorer_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiCollectionImpl _$$ApiCollectionImplFromJson(Map<String, dynamic> json) =>
    _$ApiCollectionImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      endpoints: (json['endpoints'] as List<dynamic>)
          .map((e) => ApiEndpoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      sourceUrl: json['sourceUrl'] as String?,
    );

Map<String, dynamic> _$$ApiCollectionImplToJson(_$ApiCollectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'endpoints': instance.endpoints,
      'sourceUrl': instance.sourceUrl,
    };

_$ApiEndpointImpl _$$ApiEndpointImplFromJson(Map<String, dynamic> json) =>
    _$ApiEndpointImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      path: json['path'] as String,
      method: $enumDecode(_$HTTPVerbEnumMap, json['method']),
      baseUrl: json['baseUrl'] as String,
      parameters: (json['parameters'] as List<dynamic>?)
          ?.map((e) => ApiParameter.fromJson(e as Map<String, dynamic>))
          .toList(),
      requestBody: json['requestBody'] == null
          ? null
          : ApiRequestBody.fromJson(
              json['requestBody'] as Map<String, dynamic>),
      headers: (json['headers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, ApiHeader.fromJson(e as Map<String, dynamic>)),
      ),
      responses: (json['responses'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, ApiResponse.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$$ApiEndpointImplToJson(_$ApiEndpointImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'path': instance.path,
      'method': _$HTTPVerbEnumMap[instance.method]!,
      'baseUrl': instance.baseUrl,
      'parameters': instance.parameters,
      'requestBody': instance.requestBody,
      'headers': instance.headers,
      'responses': instance.responses,
    };

const _$HTTPVerbEnumMap = {
  HTTPVerb.get: 'get',
  HTTPVerb.head: 'head',
  HTTPVerb.post: 'post',
  HTTPVerb.put: 'put',
  HTTPVerb.patch: 'patch',
  HTTPVerb.delete: 'delete',
};

_$ApiParameterImpl _$$ApiParameterImplFromJson(Map<String, dynamic> json) =>
    _$ApiParameterImpl(
      name: json['name'] as String,
      inLocation: json['inLocation'] as String,
      description: json['description'] as String?,
      required: json['required'] as bool,
      schema: json['schema'] == null
          ? null
          : ApiSchema.fromJson(json['schema'] as Map<String, dynamic>),
      example: json['example'] as String?,
    );

Map<String, dynamic> _$$ApiParameterImplToJson(_$ApiParameterImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'inLocation': instance.inLocation,
      'description': instance.description,
      'required': instance.required,
      'schema': instance.schema,
      'example': instance.example,
    };

_$ApiRequestBodyImpl _$$ApiRequestBodyImplFromJson(Map<String, dynamic> json) =>
    _$ApiRequestBodyImpl(
      description: json['description'] as String?,
      content: (json['content'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, ApiContent.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$$ApiRequestBodyImplToJson(
        _$ApiRequestBodyImpl instance) =>
    <String, dynamic>{
      'description': instance.description,
      'content': instance.content,
    };

_$ApiHeaderImpl _$$ApiHeaderImplFromJson(Map<String, dynamic> json) =>
    _$ApiHeaderImpl(
      description: json['description'] as String?,
      required: json['required'] as bool,
      schema: json['schema'] == null
          ? null
          : ApiSchema.fromJson(json['schema'] as Map<String, dynamic>),
      example: json['example'] as String?,
    );

Map<String, dynamic> _$$ApiHeaderImplToJson(_$ApiHeaderImpl instance) =>
    <String, dynamic>{
      'description': instance.description,
      'required': instance.required,
      'schema': instance.schema,
      'example': instance.example,
    };

_$ApiResponseImpl _$$ApiResponseImplFromJson(Map<String, dynamic> json) =>
    _$ApiResponseImpl(
      description: json['description'] as String?,
      content: (json['content'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, ApiContent.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$$ApiResponseImplToJson(_$ApiResponseImpl instance) =>
    <String, dynamic>{
      'description': instance.description,
      'content': instance.content,
    };

_$ApiContentImpl _$$ApiContentImplFromJson(Map<String, dynamic> json) =>
    _$ApiContentImpl(
      schema: ApiSchema.fromJson(json['schema'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ApiContentImplToJson(_$ApiContentImpl instance) =>
    <String, dynamic>{
      'schema': instance.schema,
    };

_$ApiSchemaImpl _$$ApiSchemaImplFromJson(Map<String, dynamic> json) =>
    _$ApiSchemaImpl(
      type: json['type'] as String?,
      format: json['format'] as String?,
      description: json['description'] as String?,
      example: json['example'] as String?,
      items: json['items'] == null
          ? null
          : ApiSchema.fromJson(json['items'] as Map<String, dynamic>),
      properties: (json['properties'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, ApiSchema.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$$ApiSchemaImplToJson(_$ApiSchemaImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'format': instance.format,
      'description': instance.description,
      'example': instance.example,
      'items': instance.items,
      'properties': instance.properties,
    };
