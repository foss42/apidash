import 'package:apidash_core/apidash_core.dart';
import 'package:collection/collection.dart';

part 'api_explorer_models.freezed.dart';
part 'api_explorer_models.g.dart';

// Main collection model with helper methods
@freezed
class ApiCollection with _$ApiCollection {
  const ApiCollection._(); // Private constructor for custom methods

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

  // Helper method to filter endpoints by search query
  ApiCollection filterEndpoints(String query) {
    if (query.isEmpty) return this;

    final filtered = endpoints.where((endpoint) =>
        endpoint.name.toLowerCase().contains(query.toLowerCase()) ||
        endpoint.path.toLowerCase().contains(query.toLowerCase())).toList();

    return copyWith(endpoints: filtered);
  }

  // Helper to get base URL for the collection
  String? getBaseUrl() {
    return baseUrl ?? (endpoints.isNotEmpty ? endpoints.first.baseUrl : null);
  }

  // Helper to get endpoint count text
  String get endpointCountText {
    final count = endpoints.length;
    return '$count ${count == 1 ? 'Endpoint' : 'Endpoints'}';
  }
}

// Endpoint model with helper methods
@freezed
class ApiEndpoint with _$ApiEndpoint {
  const ApiEndpoint._(); // Private constructor for custom methods

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

  // Get full URL
  String get fullUrl => '$baseUrl$path';

  // Get method display text
  String get methodText => method.name.toUpperCase();

// Create request model for this endpoint
HttpRequestModel toRequestModel() {
  //  headers to List<NameValueModel>
  final headerList = headers?.entries.map((entry) => 
    NameValueModel(name: entry.key, value: entry.value.example ?? '')).toList();

  //  query parameters to List<NameValueModel>
  final queryParamList = parameters
      ?.where((p) => p.inLocation == 'query')
      .map((p) => NameValueModel(name: p.name, value: p.example ?? ''))
      .toList();

  //  body content
  final bodyContent = requestBody?.content.values.firstOrNull?.schema?.example;

  //  conten type
  final contentType = requestBody?.content.keys.firstOrNull;
  final parsedContentType = contentType != null 
      ? ContentType.values.firstWhere(
          (type) => type.name.toLowerCase() == contentType.toLowerCase(),
          orElse: () => ContentType.json,
        )
      : ContentType.json;

  return HttpRequestModel(
    method: method,
    url: fullUrl,
    headers: headerList,
    params: queryParamList,
    bodyContentType: parsedContentType,
    body: bodyContent,
  );
}
  // map for UI compatibility
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
}

// Parameter model
@freezed
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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'in': inLocation,
      'description': description,
      'required': required,
      'schema': schema?.toMap(),
      'example': example,
    };
  }
}

// Request body model
@freezed
class ApiRequestBody with _$ApiRequestBody {
  const factory ApiRequestBody({
    String? description,
    required Map<String, ApiContent> content,
  }) = _ApiRequestBody;

  factory ApiRequestBody.fromJson(Map<String, dynamic> json) =>
      _$ApiRequestBodyFromJson(json);

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'content': content.map((key, value) => MapEntry(key, value.toMap())),
    };
  }
}

// Header model
@freezed
class ApiHeader with _$ApiHeader {
  const factory ApiHeader({
    String? description,
    @Default(false) bool required,
    ApiSchema? schema,
    String? example,
  }) = _ApiHeader;

  factory ApiHeader.fromJson(Map<String, dynamic> json) =>
      _$ApiHeaderFromJson(json);

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'required': required,
      'schema': schema?.toMap(),
      'example': example,
    };
  }
}

// Response model
@freezed
class ApiResponse with _$ApiResponse {
  const factory ApiResponse({
    String? description,
    Map<String, ApiContent>? content,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'content': content?.map((key, value) => MapEntry(key, value.toMap())),
    };
  }
}

// Content model
@freezed
class ApiContent with _$ApiContent {
  const factory ApiContent({
    required ApiSchema schema,
  }) = _ApiContent;

  factory ApiContent.fromJson(Map<String, dynamic> json) =>
      _$ApiContentFromJson(json);

  Map<String, dynamic> toMap() {
    return {
      'schema': schema.toMap(),
    };
  }
}

// Schema model
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

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'format': format,
      'description': description,
      'example': example,
      'items': items?.toMap(),
      'properties': properties?.map((key, value) => MapEntry(key, value.toMap())),
    };
  }
}

// Helper extension for collections
extension ApiCollectionHelpers on List<ApiCollection> {
  // Filter collections by search query
  List<ApiCollection> filterCollections(String query) {
    if (query.isEmpty) return this;

    return map((collection) => collection.filterEndpoints(query))
        .where((collection) => collection.endpoints.isNotEmpty)
        .toList();
  }

  // Find collection by ID
  ApiCollection? findById(String? id) {
    if (id == null) return null;
    return firstWhereOrNull((c) => c.id == id);
  }

  // Convert to list of maps for UI compatibility
  List<Map<String, dynamic>> toMapList() {
    return map((collection) => {
      'id': collection.id,
      'name': collection.name,
      'sourceUrl': collection.sourceUrl,
      'description': collection.description,
      'endpoints': collection.endpoints.map((e) => e.toMap()).toList(),
      'isExpanded': collection.isExpanded,
      'baseUrl': collection.baseUrl,
    }).toList();
  }
}

// Helper extension for endpoints
extension ApiEndpointHelpers on List<ApiEndpoint> {
  // Find endpoint by ID
  ApiEndpoint? findById(String? id) {
    if (id == null) return null;
    return firstWhereOrNull((e) => e.id == id);
  }

  // Get first 4 methods for display
  List<String> getFirstFourMethods() {
    return take(4).map((e) => e.methodText).toList();
  }
}