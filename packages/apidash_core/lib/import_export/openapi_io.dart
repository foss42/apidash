import 'dart:convert';
import 'package:openapi_spec/openapi_spec.dart';
import 'package:apidash_core/apidash_core.dart' show 
  NameValueModel, 
  FormDataModel, 
  FormDataType,
  HTTPVerb,
  ContentType;
import '../consts.dart';
import '../models/models.dart';

/// A utility class for converting OpenAPI specifications to HTTP request models.
class OpenAPIIO {
  /// Parses OpenAPI content (JSON only) and returns a list of HTTP request models.
  /// Returns `null` if the content cannot be parsed.
  List<(String?, HttpRequestModel)>? parseOpenApiContent(String content) {
    content = content.trim();
    try {
      // Try parsing as JSON
      final jsonMap = jsonDecode(content) as Map<String, dynamic>;
      final openApi = OpenApi.fromJson(jsonMap);
      return _parseOpenApiSpec(openApi);
    } catch (e) {
      return null;
    }
  }

  List<(String?, HttpRequestModel)>? _parseOpenApiSpec(OpenApi openApi) {
    final requests = <(String?, HttpRequestModel)>[];
    
    final baseUrl = openApi.servers?.isNotEmpty == true 
        ? openApi.servers!.first.url ?? ''
        : '';

    openApi.paths?.forEach((path, pathItem) {
      _getOperations(pathItem).forEach((method, operation) {
        final request = _createRequestModel(
          method: method,
          baseUrl: baseUrl,
          path: path,
          operation: operation,
        );
        
        if (request != null) {
          requests.add(request);
        }
      });
    });

    return requests.isNotEmpty ? requests : null;
  }

  Map<HTTPVerb, Operation> _getOperations(PathItem pathItem) {
    return {
      if (pathItem.get != null) HTTPVerb.get: pathItem.get!,
      if (pathItem.post != null) HTTPVerb.post: pathItem.post!,
      if (pathItem.put != null) HTTPVerb.put: pathItem.put!,
      if (pathItem.delete != null) HTTPVerb.delete: pathItem.delete!,
      if (pathItem.patch != null) HTTPVerb.patch: pathItem.patch!,
      if (pathItem.head != null) HTTPVerb.head: pathItem.head!,
    };
  }

  (String?, HttpRequestModel)? _createRequestModel({
    required HTTPVerb method,
    required String baseUrl,
    required String path,
    required Operation operation,
  }) {
    try {
      final fullUrl = _combineUrls(baseUrl, path);
      
      final (headers, isHeaderEnabledList) = _convertParameters(
        operation.parameters,
        ['header', 'cookie']
      );
      final (params, isParamEnabledList) = _convertParameters(
        operation.parameters,
        ['query']
      );
      
      final (bodyContentType, body, formData) = 
          _convertRequestBody(operation.requestBody);

      final name = operation.summary ??
                  operation.description ??
                  '${method.name.toUpperCase()} $path';

      return (
        name,
        HttpRequestModel(
          method: method,
          url: fullUrl,
          headers: headers,
          params: params,
          isHeaderEnabledList: isHeaderEnabledList,
          isParamEnabledList: isParamEnabledList,
          bodyContentType: bodyContentType,
          body: body,
          formData: formData,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  String _combineUrls(String baseUrl, String path) {
    if (baseUrl.isEmpty) return path;
    
    final uri = Uri.parse(baseUrl);
    final pathUri = Uri.parse(path.startsWith('/') ? path : '/$path');
    
    return uri.replace(
      path: uri.path + pathUri.path,
      query: pathUri.query.isNotEmpty ? pathUri.query : uri.query,
    ).toString();
  }

  (List<NameValueModel>?, List<bool>?) _convertParameters(
    List<Parameter>? parameters, 
    List<String> parameterTypes,
  ) {
    if (parameters == null || parameters.isEmpty) {
      return (null, null);
    }
    
    final result = <NameValueModel>[];
    final enabledList = <bool>[];
    
    for (final param in parameters) {
      try {
        final paramIn = param is ParameterCookie ? 'cookie' : 
                       param is ParameterHeader ? 'header' :
                       param is ParameterQuery ? 'query' :
                       param is ParameterPath ? 'path' : '';
        
        if (parameterTypes.contains(paramIn)) {
          result.add(NameValueModel(
            name: param.name ?? '',
            value: _getParameterExample(param),
          ));
          enabledList.add(!(param.deprecated ?? false));
        }
      } catch (e) {
        continue;
      }
    }
    
    return (
      result.isNotEmpty ? result : null,
      enabledList.isNotEmpty ? enabledList : null
    );
  }

  String _getParameterExample(Parameter param) {
    if (param.example != null) return param.example.toString();
    if (param.schema != null) {
      if (param.schema!.defaultValue != null) {
        return param.schema!.defaultValue.toString();
      }
      return param.schema!.toString();
    }
    return '';
  }

  (ContentType, String?, List<FormDataModel>?) _convertRequestBody(
    RequestBody? requestBody,
  ) {
    if (requestBody?.content?.isEmpty ?? true) {
      return (kDefaultContentType, null, null);
    }

    try {
      final mediaType = requestBody!.content!.entries.first;
      final contentType = _determineContentType(mediaType.key);
      final schema = mediaType.value.schema;

      if (contentType == ContentType.formdata) {
        final formData = _parseFormData(schema);
        return (contentType, null, formData.isNotEmpty ? formData : null);
      } else {
        final example = _getRequestBodyExample(schema, mediaType.value);
        return (
          contentType, 
          example != null ? jsonEncode(example) : null, 
          null
        );
      }
    } catch (e) {
      return (kDefaultContentType, null, null);
    }
  }

  List<FormDataModel> _parseFormData(Schema? schema) {
    final formData = <FormDataModel>[];
    if (schema != null && schema is SchemaObject && schema.properties != null) {
      for (final prop in schema.properties!.entries) {
        formData.add(FormDataModel(
          name: prop.key,
          value: _getSchemaExampleValue(prop.value),
          type: FormDataType.text,
        ));
      }
    }
    return formData;
  }

  String _getSchemaExampleValue(Schema schema) {
    if (schema is SchemaObject && schema.properties != null) {
      final exampleMap = <String, dynamic>{};
      for (final prop in schema.properties!.entries) {
        exampleMap[prop.key] = _getSchemaExampleValue(prop.value);
      }
      return jsonEncode(exampleMap);
    }
    return schema.defaultValue?.toString() ?? schema.toString();
  }

  dynamic _getRequestBodyExample(Schema? schema, MediaType mediaType) {
    return mediaType.example ?? (schema);
  }

  ContentType _determineContentType(String mediaType) {
    final normalized = mediaType.toLowerCase();
    if (normalized.contains('json')) return ContentType.json;
    if (normalized.contains('form-data') || 
        normalized.contains('x-www-form-urlencoded')) {
      return ContentType.formdata;
    }
    return ContentType.text;
  }
}