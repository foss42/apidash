import 'package:apidash_core/apidash_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_explorer_models.freezed.dart';
part 'api_explorer_models.g.dart';

@freezed
@JsonSerializable(explicitToJson: true, anyMap: true)
class ApiCollection with _$ApiCollection {
  const ApiCollection._();

  @JsonSerializable(explicitToJson: true)
  const factory ApiCollection({
    required String id,
    required String name,
    String? sourceUrl,
    String? description,
    required List<ApiEndpoint> endpoints,
    @Default(false) bool isExpanded,
    String? baseUrl,
  }) = _ApiCollection;

  factory ApiCollection.fromJson(Map<String, dynamic> json) =>
      _$ApiCollectionFromJson(json);

  // Convert to map for UI components
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sourceUrl': sourceUrl,
      'description': description,
      'endpoints': endpoints.map((e) => e.toMap()).toList(),
      'isExpanded': isExpanded,
      'baseUrl': baseUrl,
    };
  }

  // Helper methods
  ApiCollection filterEndpoints(String query) {
    if (query.isEmpty) return this;
    final filtered = endpoints.where((e) =>
        e.name.toLowerCase().contains(query.toLowerCase()) ||
        e.path.toLowerCase().contains(query.toLowerCase())).toList();
    return copyWith(endpoints: filtered);
  }

  String get endpointCountText =>
      '${endpoints.length} ${endpoints.length == 1 ? 'Endpoint' : 'Endpoints'}';
}

@freezed
@JsonSerializable(explicitToJson: true, anyMap: true)
class ApiEndpoint with _$ApiEndpoint {
  const ApiEndpoint._();

  @JsonSerializable(explicitToJson: true)
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

  // UI-compatible map conversion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'path': path,
      'method': method.name,
      'baseUrl': baseUrl,
      'parameters': parameters?.map((p) => p.toMap()).toList(),
      'requestBody': requestBody?.toMap(),
      'headers': headers?.map((key, value) => MapEntry(key, value.toMap())),
      'responses': responses?.map((key, value) => MapEntry(key, value.toMap())),
    };
  }

  // For MethodCard and ApiExplorerURLCard
  String get fullUrl => '$baseUrl$path';
  String get methodText => method.name.toUpperCase();

  // For HttpRequestModel conversion
  HttpRequestModel toRequestModel() {
    return HttpRequestModel(
      method: method,
      url: fullUrl,
      headers: headers?.entries
          .map((e) => NameValueModel(name: e.key, value: e.value.example ?? ''))
          .toList(),
      params: parameters
          ?.where((p) => p.inLocation == 'query')
          .map((p) => NameValueModel(name: p.name, value: p.example ?? ''))
          .toList(),
      body: requestBody?.content.values.firstOrNull?.schema?.example,
      bodyContentType: _getContentType(),
    );
  }

  ContentType _getContentType() {
    final contentType = requestBody?.content.keys.firstOrNull;
    if (contentType == null) return ContentType.json;
    return ContentType.values.firstWhere(
      (e) => e.name.toLowerCase() == contentType.toLowerCase(),
      orElse: () => ContentType.json,
    );
  }
}

@freezed
@JsonSerializable(explicitToJson: true)
class ApiParameter with _$ApiParameter {
  const factory ApiParameter({
    required String name,
    @JsonKey(name: 'in') required String inLocation,
    String? description,
    @Default(false) bool required,
    ApiSchema? schema,
    String? example,
  }) = _ApiParameter;

  factory ApiParameter.fromJson(Map<String, dynamic> json) =>
      _$ApiParameterFromJson(json);

  Map<String, dynamic> toMap() => {
        'name': name,
        'in': inLocation,
        'description': description,
        'required': required,
        'schema': schema?.toMap(),
        'example': example,
      };
}

@freezed
@JsonSerializable(explicitToJson: true)
class ApiRequestBody with _$ApiRequestBody {
  const factory ApiRequestBody({
    String? description,
    required Map<String, ApiContent> content,
  }) = _ApiRequestBody;

  factory ApiRequestBody.fromJson(Map<String, dynamic> json) =>
      _$ApiRequestBodyFromJson(json);

  Map<String, dynamic> toMap() => {
        'description': description,
        'content': content.map((k, v) => MapEntry(k, v.toMap())),
      };
}

@freezed
@JsonSerializable(explicitToJson: true)
class ApiHeader with _$ApiHeader {
  const factory ApiHeader({
    String? description,
    @Default(false) bool required,
    ApiSchema? schema,
    String? example,
  }) = _ApiHeader;

  factory ApiHeader.fromJson(Map<String, dynamic> json) =>
      _$ApiHeaderFromJson(json);

  Map<String, dynamic> toMap() => {
        'description': description,
        'required': required,
        'schema': schema?.toMap(),
        'example': example,
      };
}

@freezed
@JsonSerializable(explicitToJson: true)
class ApiResponse with _$ApiResponse {
  const factory ApiResponse({
    String? description,
    Map<String, ApiContent>? content,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);

  Map<String, dynamic> toMap() => {
        'description': description,
        'content': content?.map((k, v) => MapEntry(k, v.toMap())),
      };
}

@freezed
@JsonSerializable(explicitToJson: true)
class ApiContent with _$ApiContent {
  const factory ApiContent({
    required ApiSchema schema,
  }) = _ApiContent;

  factory ApiContent.fromJson(Map<String, dynamic> json) =>
      _$ApiContentFromJson(json);

  Map<String, dynamic> toMap() => {'schema': schema.toMap()};
}

@freezed
@JsonSerializable(explicitToJson: true)
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

  Map<String, dynamic> toMap() => {
        'type': type,
        'format': format,
        'description': description,
        'example': example,
        'items': items?.toMap(),
        'properties': properties?.map((k, v) => MapEntry(k, v.toMap())),
      };
}

// Helper extensions
extension ApiCollectionListX on List<ApiCollection> {
  List<ApiCollection> filterCollections(String query) {
    if (query.isEmpty) return this;
    return map((c) => c.filterEndpoints(query))
        .where((c) => c.endpoints.isNotEmpty)
        .toList();
  }

  ApiCollection? findById(String? id) =>
      id == null ? null : firstWhereOrNull((c) => c.id == id);
}

extension ApiEndpointListX on List<ApiEndpoint> {
  ApiEndpoint? findById(String? id) =>
      id == null ? null : firstWhereOrNull((e) => e.id == id);
}