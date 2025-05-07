import 'package:apidash_core/consts.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_explorer_models.freezed.dart';
part 'api_explorer_models.g.dart';

@freezed
class ApiCollection with _$ApiCollection {
  const factory ApiCollection({
    required String id,
    required String name,
    String? description,
    required List<ApiEndpoint> endpoints,
    String? sourceUrl,
  }) = _ApiCollection;

  factory ApiCollection.fromJson(Map<String, dynamic> json) =>
      _$ApiCollectionFromJson(json);
}

@freezed
class ApiEndpoint with _$ApiEndpoint {
  const factory ApiEndpoint({
    required String id,
    required String name,
    String? description,
    required String path,
    required HTTPVerb method,
    required String baseUrl,
    List<ApiParameter>? parameters,
    ApiRequestBody? requestBody,
    Map<String, ApiHeader>? headers,
    Map<String, ApiResponse>? responses,
  }) = _ApiEndpoint;

  factory ApiEndpoint.fromJson(Map<String, dynamic> json) =>
      _$ApiEndpointFromJson(json);
}

@freezed
class ApiParameter with _$ApiParameter {
  const factory ApiParameter({
    required String name,
    required String inLocation,
    String? description,
    required bool required,
    ApiSchema? schema,
    String? example,
  }) = _ApiParameter;

  factory ApiParameter.fromJson(Map<String, dynamic> json) =>
      _$ApiParameterFromJson(json);
}

@freezed
class ApiRequestBody with _$ApiRequestBody {
  const factory ApiRequestBody({
    String? description,
    required Map<String, ApiContent> content,
  }) = _ApiRequestBody;

  factory ApiRequestBody.fromJson(Map<String, dynamic> json) =>
      _$ApiRequestBodyFromJson(json);
}

@freezed
class ApiHeader with _$ApiHeader {
  const factory ApiHeader({
    String? description,
    required bool required,
    ApiSchema? schema,
    String? example,
  }) = _ApiHeader;

  factory ApiHeader.fromJson(Map<String, dynamic> json) =>
      _$ApiHeaderFromJson(json);
}

@freezed
class ApiResponse with _$ApiResponse {
  const factory ApiResponse({
    String? description,
    Map<String, ApiContent>? content,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
}

@freezed
class ApiContent with _$ApiContent {
  const factory ApiContent({
    required ApiSchema schema,
  }) = _ApiContent;

  factory ApiContent.fromJson(Map<String, dynamic> json) =>
      _$ApiContentFromJson(json);
}

@freezed
class ApiSchema with _$ApiSchema {
  const factory ApiSchema({
    String? type,
    String? format,
    String? description,
    String? example,
    ApiSchema? items,
    Map<String, ApiSchema>? properties,
  }) = _ApiSchema;

  factory ApiSchema.fromJson(Map<String, dynamic> json) =>
      _$ApiSchemaFromJson(json);
}

