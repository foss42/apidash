import 'dart:convert';

import 'package:apidash_core/apidash_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_explorer_model.freezed.dart';
part 'api_explorer_model.g.dart';

@freezed
class ApiExplorerModel with _$ApiExplorerModel {
  const ApiExplorerModel._();

  @JsonSerializable(explicitToJson: true)
  const factory ApiExplorerModel({
    /// Core identification
    required String id,
    required String name,
    required String source,
    @Default('') String description,
    required DateTime updatedAt,

    /// Endpoint configuration
    required String path,
    @Default(HTTPVerb.get) HTTPVerb method,
    @Default('') String baseUrl,
    @Default('') String operationId,

    /// Request components
    @Default([]) List<NameValueModel> parameters,
    @Default([]) List<NameValueModel> headers,
    Map<String, dynamic>? requestBody,
    Map<String, dynamic>? responses,

    /// Parameter metadata
    @Default({}) Map<String, dynamic> parameterSchemas,
    @Default({}) Map<String, dynamic> headerSchemas,
  }) = _ApiExplorerModel;

  factory ApiExplorerModel.fromJson(Map<String, dynamic> json) =>
      _$ApiExplorerModelFromJson(json);

  /// Returns the full URL by properly combining baseUrl and path
  String get fullUrl {
    if (baseUrl.isEmpty) return path;
    
    try {
      final uri = Uri.parse(baseUrl);
      if (path.isEmpty) return uri.toString();
      
      // Handle cases where path might already contain query parameters
      final pathUri = Uri.tryParse(path) ?? Uri(path: path);
      
      return uri.replace(
        path: uri.path + (uri.path.endsWith('/') || path.startsWith('/') ? '' : '/') + pathUri.path,
        query: pathUri.hasQuery ? pathUri.query : uri.query,
      ).toString();
    } catch (e) {
      return baseUrl + (baseUrl.endsWith('/') ? path.substring(1) : path);
    }
  }

  /// Gets query parameters from the parameters list
  List<NameValueModel> get queryParameters => parameters
      .where((p) => _getParamLocation(p) == 'query')
      .toList();

  /// Gets path parameters from the parameters list
  List<NameValueModel> get pathParameters => parameters
      .where((p) => _getParamLocation(p) == 'path')
      .toList();

  /// Converts the model to an HttpRequestModel
  HttpRequestModel toHttpRequestModel() {
    return HttpRequestModel(
      method: method,
      url: fullUrl,
      headers: headers,
      params: queryParameters,
      bodyContentType: _determineContentType(),
      body: _getRequestBody(),
    );
  }

  /// Determines the content type from the request body
  ContentType _determineContentType() {
    final content = requestBody?['content'];
    if (content == null || content is! Map) return ContentType.json;

    if (content.containsKey('application/json')) return ContentType.json;
    if (content.containsKey('text/plain')) return ContentType.text;
    if (content.containsKey('application/form-data')) {
      return ContentType.formdata;
    }
    return ContentType.json;
  }

  /// Extracts the request body content
  String? _getRequestBody() {
    final content = requestBody?['content'];
    if (content == null || content is! Map) return null;

    if (content['application/json'] != null) {
      try {
        return jsonEncode(content['application/json']['example']);
      } catch (e) {
        return null;
      }
    }

    if (content['text/plain'] != null) {
      return content['text/plain']['example']?.toString();
    }

    if (content['application/x-www-form-urlencoded'] != null) {
      try {
        final params = content['application/x-www-form-urlencoded'] as Map?;
        return params?.entries
            .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
            .join('&');
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  /// Helper method to get parameter location
  String _getParamLocation(NameValueModel param) {
    try {
      final location = parameterSchemas[param.name]?['in']?.toString().toLowerCase();
      return location ?? 'query';
    } catch (e) {
      return 'query';
    }
  }
}