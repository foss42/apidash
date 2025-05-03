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
      final jsonMap = jsonDecode(content) as Map<String, dynamic>;
      final openApi = OpenApi.fromJson(jsonMap);
      return parseOpenApiSpec(openApi);
    } catch (e) {
      return null;
    }
  }

  List<(String?, HttpRequestModel)>? parseOpenApiSpec(OpenApi openApi) {
    final requests = <(String?, HttpRequestModel)>[];
    final baseUrl = openApi.servers?.isNotEmpty == true 
        ? openApi.servers!.first.url ?? ''
        : '';

    openApi.paths?.forEach((path, pathItem) {
      getOperations(pathItem).forEach((method, operation) {
        final request = createRequestModel(
          method: method,
          baseUrl: baseUrl,
          path: path,
          operation: operation,
        );
        if (request != null) requests.add(request);
      });
    });

    return requests.isNotEmpty ? requests : null;
  }

  Map<HTTPVerb, Operation> getOperations(PathItem pathItem) => {
    if (pathItem.get != null) HTTPVerb.get: pathItem.get!,
    if (pathItem.post != null) HTTPVerb.post: pathItem.post!,
    if (pathItem.put != null) HTTPVerb.put: pathItem.put!,
    if (pathItem.delete != null) HTTPVerb.delete: pathItem.delete!,
    if (pathItem.patch != null) HTTPVerb.patch: pathItem.patch!,
    if (pathItem.head != null) HTTPVerb.head: pathItem.head!,
  };

  (String?, HttpRequestModel)? createRequestModel({
    required HTTPVerb method,
    required String baseUrl,
    required String path,
    required Operation operation,
  }) {
    try {
      final fullUrl = combineUrls(baseUrl, path);
      final (headers, headerEnabled) = convertParameters(
        operation.parameters,
        ['header', 'cookie']
      );
      final (params, paramEnabled) = convertParameters(
        operation.parameters,
        ['query']
      );
      final (bodyContentType, body, formData) = 
          convertRequestBody(operation.requestBody);

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
          isHeaderEnabledList: headerEnabled,
          isParamEnabledList: paramEnabled,
          bodyContentType: bodyContentType,
          body: body,
          formData: formData,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  String combineUrls(String baseUrl, String path) {
    if (baseUrl.isEmpty) return path;
    final uri = Uri.parse(baseUrl);
    final pathUri = Uri.parse(path.startsWith('/') ? path : '/$path');
    return uri.replace(
      path: uri.path + pathUri.path,
      query: pathUri.query.isNotEmpty ? pathUri.query : uri.query,
    ).toString();
  }

  (List<NameValueModel>?, List<bool>?) convertParameters(
    List<Parameter>? parameters, 
    List<String> parameterTypes,
  ) {
    if (parameters == null || parameters.isEmpty) return (null, null);
    
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
            value: getParameterExample(param),
          ));
          enabledList.add(!(param.deprecated ?? false));
        }
      } catch (_) {
        continue;
      }
    }
    
    return (
      result.isNotEmpty ? result : null,
      enabledList.isNotEmpty ? enabledList : null
    );
  }

  String getParameterExample(Parameter param) {
    if (param.example != null) return param.example.toString();
    if (param.schema?.defaultValue != null) return param.schema!.defaultValue.toString();
    return param.schema?.toString() ?? '';
  }

  (ContentType, String?, List<FormDataModel>?) convertRequestBody(
    RequestBody? requestBody,
  ) {
    if (requestBody?.content?.isEmpty ?? true) {
      return (kDefaultContentType, null, null);
    }

    try {
      final mediaType = requestBody!.content!.entries.first;
      final contentType = determineContentType(mediaType.key);
      final schema = mediaType.value.schema;

      if (contentType == ContentType.formdata) {
        final formData = parseFormData(schema);
        return (contentType, null, formData.isNotEmpty ? formData : null);
      }
      final example = getRequestBodyExample(schema, mediaType.value);
      return (contentType, example != null ? jsonEncode(example) : null, null);
    } catch (_) {
      return (kDefaultContentType, null, null);
    }
  }

  List<FormDataModel> parseFormData(Schema? schema) {
    if (schema == null || schema is! SchemaObject || schema.properties == null) {
      return [];
    }
    return schema.properties!.entries.map((prop) => FormDataModel(
      name: prop.key,
      value: getSchemaExampleValue(prop.value),
      type: FormDataType.text,
    )).toList();
  }

  String getSchemaExampleValue(Schema schema) {
    if (schema is SchemaObject && schema.properties != null) {
      return jsonEncode(Map.fromEntries(
        schema.properties!.entries.map((e) => 
          MapEntry(e.key, getSchemaExampleValue(e.value)))
      ));
    }
    return schema.defaultValue?.toString() ?? schema.toString();
  }

  dynamic getRequestBodyExample(Schema? schema, MediaType mediaType) =>
      mediaType.example ?? schema;

  ContentType determineContentType(String mediaType) {
    final normalized = mediaType.toLowerCase();
    if (normalized.contains('json')) return ContentType.json;
    if (normalized.contains('form-data') || normalized.contains('x-www-form-urlencoded')) {
      return ContentType.formdata;
    }
    return ContentType.text;
  }
}