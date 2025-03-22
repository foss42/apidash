
import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:yaml/yaml.dart';
import 'package:seed/models/name_value_model.dart';

class OpenApiIO {
  List<(String?, HttpRequestModel)>? getHttpRequestModelList(String content)  {
    try {
      // Try to parse the content as JSON first
      Map<String, dynamic> jsonData;
      
      try {
        // Try JSON format
        jsonData = json.decode(content) as Map<String, dynamic>;
      } catch (e) {
        try {
          // If JSON fails, try YAML format
          final yamlMap = loadYaml(content) as Map;
          // Convert YAML to JSON format
          jsonData = json.decode(json.encode(yamlMap)) as Map<String, dynamic>;
        } catch (e) {
          print('Error parsing YAML: $e');
          return null;
        }
      }

      // Basic validation to check if it's an OpenAPI spec
      if (!jsonData.containsKey('paths')) {
        print('Not a valid OpenAPI spec: missing paths');
        return null;
      }

      final List<(String?, HttpRequestModel)> result = [];
      
      // Get base URL from servers if available
      String baseUrl = 'https://example.com';
      if (jsonData.containsKey('servers') && 
          jsonData['servers'] is List && 
          (jsonData['servers'] as List).isNotEmpty &&
          (jsonData['servers'][0] is Map) &&
          (jsonData['servers'][0] as Map).containsKey('url')) {
        baseUrl = jsonData['servers'][0]['url'] as String;
      }
      
      // Process paths and operations
      final paths = jsonData['paths'] as Map<String, dynamic>;
      paths.forEach((path, pathData) {
        if (pathData is Map<String, dynamic>) {
          // Only use the HTTP methods we support
          for (final methodStr in ['get', 'post', 'put', 'delete', 'patch', 'head']) {
            if (pathData.containsKey(methodStr)) {
              final operation = pathData[methodStr] as Map<String, dynamic>;
              
              // Convert string method to HTTPVerb enum
              final HTTPVerb method = _stringToHttpVerb(methodStr);
              
              // Create a name for the request
              final name = operation.containsKey('summary') && operation['summary'] != null
                  ? operation['summary'] as String
                  : operation.containsKey('operationId') && operation['operationId'] != null
                      ? operation['operationId'] as String
                      : '${methodStr.toUpperCase()} $path';
              
              // Build the request model
              final requestModel = _createRequestModel(
                method,
                path,
                baseUrl,
                operation,
              );
              
              result.add((name, requestModel));
            }
          }
        }
      });

      return result;
    } catch (e) {
      print('Error parsing OpenAPI/Swagger: $e');
      return null;
    }
  }
  
  /// Converts a string HTTP method to the HTTPVerb enum
  HTTPVerb _stringToHttpVerb(String method) {
    switch (method.toLowerCase()) {
      case 'get': return HTTPVerb.get;
      case 'post': return HTTPVerb.post;
      case 'put': return HTTPVerb.put;
      case 'delete': return HTTPVerb.delete;
      case 'patch': return HTTPVerb.patch;
      case 'head': return HTTPVerb.head;
      // Remove OPTIONS since it's not available in your HTTPVerb enum
      default: return HTTPVerb.get;
    }
  }

  /// Creates a basic HttpRequestModel from operation data
  HttpRequestModel _createRequestModel(
    HTTPVerb method,
    String path,
    String baseUrl,
    Map<String, dynamic> operation,
  ) {
    // Basic URL construction
    String url = baseUrl;
    if (!url.endsWith('/') && !path.startsWith('/')) {
      url += '/';
    } else if (url.endsWith('/') && path.startsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    url += path;
    
    // Replace path parameters with example values
    final RegExp pathParamRegex = RegExp(r'\{([^}]+)\}');
    final matches = pathParamRegex.allMatches(url);
    for (final match in matches) {
      final paramName = match.group(1)!;
      url = url.replaceAll('{$paramName}', 'example');
    }
    
    // Extract headers
    final List<NameValueModel> headers = [
      NameValueModel(name: 'Accept', value: 'application/json')
    ];
    
    // Extract query parameters
    final List<NameValueModel> params = [];
    if (operation.containsKey('parameters')) {
      final parameters = operation['parameters'] as List<dynamic>?;
      if (parameters != null) {
        for (final param in parameters) {
          if (param is Map<String, dynamic> && 
              param.containsKey('in') && 
              param['in'] == 'query' &&
              param.containsKey('name')) {
            params.add(NameValueModel(
              name: param['name'] as String,
              value: 'example'
            ));
          }
        }
      }
    }
    
    // Basic request body for POST/PUT/PATCH
    String body = '';
    ContentType bodyContentType = ContentType.json;
    
    if (['post', 'put', 'patch'].contains(method.name.toLowerCase()) && 
        operation.containsKey('requestBody')) {
      
      if (operation['requestBody'] is Map<String, dynamic> &&
          operation['requestBody'].containsKey('content')) {
        
        final content = operation['requestBody']['content'] as Map<String, dynamic>?;
        if (content != null) {
          if (content.containsKey('application/json')) {
            bodyContentType = ContentType.json;
            body = '{}';  // Default empty JSON
            
            // Try to extract a sample from the schema
            final jsonContent = content['application/json'] as Map<String, dynamic>?;
            if (jsonContent != null && jsonContent.containsKey('example')) {
              body = json.encode(jsonContent['example']);
            }
          } else if (content.containsKey('multipart/form-data')) {
            bodyContentType = ContentType.formdata;
            // Form data is handled via formData property
          } else if (content.containsKey('text/plain')) {
            bodyContentType = ContentType.text;
            body = '';
          }
        }
      }
    }
    
 
    return HttpRequestModel(
      method: method,
      url: url,
      headers: headers,
      params: params,
      body: body,
      bodyContentType: bodyContentType,
    );
  }
}