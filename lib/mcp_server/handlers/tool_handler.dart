import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';
import '../../mcp/models.dart';
import '../../mcp/server_core.dart';

class ApidashToolHandler implements ToolHandler {
  ApidashToolHandler();

  Future<void> init() async {
    // Shared initialization is now handled by ApidashMcpServer
  }

  @override
  Future<List<ToolDescriptor>> listTools() async {
    return [
      ToolDescriptor(
        name: 'get_request_details',
        description: 'Get the full details of an API Dash request, including URL, headers, and body.',
        inputSchema: {
          'type': 'object',
          'properties': {
            'requestId': {
              'type': 'string',
              'description': 'The UUID of the request to fetch.',
            }
          },
          'required': ['requestId'],
        },
      ),
      ToolDescriptor(
        name: 'get_environment_variables',
        description: 'Get all the variables from a specific environment, or list all environments if no ID is provided.',
        inputSchema: {
          'type': 'object',
          'properties': {
            'environmentId': {
              'type': 'string',
              'description': 'The optional UUID of the environment. If omitted, lists available environments.',
            }
          },
        },
      ),
      ToolDescriptor(
        name: 'debug',
        description: 'Get debug information about the internal Hive database and initialization status.',
        inputSchema: {
          'type': 'object',
          'properties': {
            'requestId': {
              'type': 'string',
              'description': 'Optional request ID to output specific request data.',
            }
          },
        },
      ),
      ToolDescriptor(
        name: 'status',
        description: 'Get the overall status of the API Dash MCP server connection and total request count.',
        inputSchema: {
          'type': 'object',
          'properties': {},
        },
      ),
      ToolDescriptor(
        name: 'create_request',
        description: 'Programmatically adds a new request to the local collection.',
        inputSchema: {
          'type': 'object',
          'properties': {
            'name': {'type': 'string', 'description': 'The name of the request'},
            'url': {'type': 'string', 'description': 'The URL of the request'},
            'method': {'type': 'string', 'description': 'The HTTP method (GET, POST, etc.)'}
          },
          'required': ['url'],
        },
      ),
      ToolDescriptor(
        name: 'replay_request',
        description: 'Re-executes a saved request directly through the API Dash engine.',
        inputSchema: {
          'type': 'object',
          'properties': {
            'requestId': {
              'type': 'string',
              'description': 'The UUID of the request to replay.',
            }
          },
          'required': ['requestId'],
        },
      ),
      ToolDescriptor(
        name: 'http_request',
        description: 'Generic HTTP execution tool for external agent orchestration.',
        inputSchema: {
          'type': 'object',
          'properties': {
            'url': {'type': 'string', 'description': 'The URL to request'},
            'method': {'type': 'string', 'description': 'The HTTP method (GET, POST, etc.)'},
            'headers': {
              'type': 'object',
              'additionalProperties': {'type': 'string'},
              'description': 'Optional HTTP headers'
            },
            'body': {'type': 'string', 'description': 'Optional request body'}
          },
          'required': ['url'],
        },
      ),
      ToolDescriptor(
        name: 'graphql_query',
        description: 'Specialized GraphQL execution tool.',
        inputSchema: {
          'type': 'object',
          'properties': {
            'url': {'type': 'string', 'description': 'The GraphQL endpoint'},
            'query': {'type': 'string', 'description': 'The GraphQL query string'},
            'variables': {'type': 'object', 'description': 'GraphQL variables'},
            'headers': {
              'type': 'object',
              'additionalProperties': {'type': 'string'},
              'description': 'Optional HTTP headers'
            }
          },
          'required': ['url', 'query'],
        },
      ),
      ToolDescriptor(
        name: 'ai_api_test',
        description: 'Autonomous multi-step validation and report generation (basic proxy).',
        inputSchema: {
          'type': 'object',
          'properties': {
            'requestId': {'type': 'string', 'description': 'The request UUID to test'},
            'prompt': {'type': 'string', 'description': 'The goal of the test'}
          },
          'required': ['requestId', 'prompt'],
        },
      ),
    ];
  }

  @override
  Future<ToolResponse> invokeTool(String name, Map<String, dynamic> parameters) async {
    await init();
    
    switch (name) {
      case 'get_request_details':
        return _handleGetRequestDetails(parameters);
      case 'get_environment_variables':
        return _handleGetEnvironmentVariables(parameters);
      case 'debug':
        return _handleDebug(parameters);
      case 'status':
        return _handleStatus(parameters);
      case 'create_request':
        return _handleCreateRequest(parameters);
      case 'replay_request':
        return _handleReplayRequest(parameters);
      case 'http_request':
        return _handleHttpRequest(parameters);
      case 'graphql_query':
        return _handleGraphqlQuery(parameters);
      case 'ai_api_test':
        return _handleAiApiTest(parameters);
      default:
        return ToolResponse(error: 'Tool not found: $name');
    }
  }

  Future<ToolResponse> _handleGetRequestDetails(Map<String, dynamic> parameters) async {
    final dataBox = Hive.box('apidash-data');
    final requestId = parameters['requestId'] as String?;
    
    if (requestId == null) {
      return ToolResponse(error: 'requestId parameter is required');
    }
    
    final req = dataBox.get(requestId);
    if (req == null) {
      return ToolResponse(error: 'Request with ID $requestId not found');
    }
    
    // We try to cast the map for safety before sending
    return ToolResponse(result: Map<String, dynamic>.from(req));
  }

  Future<ToolResponse> _handleGetEnvironmentVariables(Map<String, dynamic> parameters) async {
    final envBox = Hive.box('apidash-environments');
    final envId = parameters['environmentId'] as String?;
    
    if (envId != null) {
      final env = envBox.get(envId);
      if (env == null) {
        return ToolResponse(error: 'Environment with ID $envId not found');
      }
      return ToolResponse(result: Map<String, dynamic>.from(env));
    } else {
      // List all environments instead
      final ids = envBox.get('environmentIds') as List<dynamic>? ?? [];
      final list = [];
      for (var id in ids) {
        final env = envBox.get(id);
        if (env != null) list.add(Map<String, dynamic>.from(env));
      }
      return ToolResponse(result: {'environments': list});
    }
  }

  Future<ToolResponse> _handleDebug(Map<String, dynamic> parameters) async {
    final dataBox = Hive.box('apidash-data');
    final requestId = parameters['requestId'] as String?;
    
    if (requestId != null) {
      final req = dataBox.get(requestId);
      return ToolResponse(result: {
        'requestId': requestId,
        'data': req,
      });
    }

    return ToolResponse(result: {
      'boxNames': ['apidash-data', 'apidash-environments', 'apidash-history-meta', 'apidash-history-lazy'],
      'isInitialized': true,
    });
  }

  Future<ToolResponse> _handleStatus(Map<String, dynamic> parameters) async {
    final dataBox = Hive.box('apidash-data');
    final ids = dataBox.get('ids') as List<dynamic>?;
    
    return ToolResponse(result: {
      'totalRequests': ids?.length ?? 0,
      'status': 'connected',
    });
  }

  Future<ToolResponse> _handleCreateRequest(Map<String, dynamic> parameters) async {
    final dataBox = Hive.box('apidash-data');
    final url = parameters['url'] as String?;
    if (url == null) return ToolResponse(error: 'url parameter is required');
    
    final id = const Uuid().v4();
    final name = parameters['name'] as String? ?? 'MCP Request';
    final method = parameters['method'] as String? ?? 'GET';
    
    final requestModel = {
      'id': id,
      'name': name,
      'description': '',
      'apiType': 'rest',
      'requestTabIndex': 0,
      'httpRequestModel': {
        'method': method.toLowerCase(),
        'url': url,
        'headers': [],
        'params': [],
        'isHeaderEnabledList': [],
        'isParamEnabledList': [],
        'bodyContentType': 'json',
        'body': '',
        'formData': []
      }
    };
    
    await dataBox.put(id, requestModel);
    
    var ids = dataBox.get('ids') as List<dynamic>? ?? [];
    List<dynamic> newIds = List.from(ids);
    newIds.insert(0, id);
    await dataBox.put('ids', newIds);
    
    return ToolResponse(result: {
      'status': 'success',
      'id': id,
      'message': 'Request created successfully'
    });
  }

  Future<ToolResponse> _handleReplayRequest(Map<String, dynamic> parameters) async {
    final dataBox = Hive.box('apidash-data');
    final requestId = parameters['requestId'] as String?;
    
    if (requestId == null) return ToolResponse(error: 'requestId is required');
    final req = dataBox.get(requestId);
    if (req == null) return ToolResponse(error: 'Request with ID $requestId not found');
    
    try {
      final httpRequest = req['httpRequestModel'] as Map?;
      if (httpRequest == null) return ToolResponse(error: 'Request has no valid httpRequestModel');
      
      final url = httpRequest['url'] as String? ?? '';
      if (url.isEmpty) return ToolResponse(error: 'Request URL is empty');
      
      final method = (httpRequest['method'] as String? ?? 'GET').toUpperCase();
      
      final headersList = httpRequest['headers'] as List<dynamic>? ?? [];
      final headerEnabledList = httpRequest['isHeaderEnabledList'] as List<dynamic>? ?? [];
      final headers = <String, String>{};
      
      for (int i = 0; i < headersList.length; i++) {
        var isEnabled = true;
        if (i < headerEnabledList.length) {
          isEnabled = headerEnabledList[i] as bool? ?? true;
        }
        if (isEnabled) {
          var header = headersList[i] as Map?;
          var name = header?['name'] as String?;
          var value = header?['value'] as String?;
          if (name != null && name.isNotEmpty && value != null) {
            headers[name] = value;
          }
        }
      }

      return await _executeHttpRequest(url, method, headers, httpRequest['body'] as String?);
    } catch (e) {
      return ToolResponse(error: 'Replay request failed: $e');
    }
  }

  Future<ToolResponse> _handleHttpRequest(Map<String, dynamic> parameters) async {
    final url = parameters['url'] as String?;
    if (url == null) return ToolResponse(error: 'url is required');
    
    final method = (parameters['method'] as String? ?? 'GET').toUpperCase();
    final headersMap = parameters['headers'] as Map? ?? {};
    final headers = headersMap.cast<String, String>();
    final body = parameters['body'] as String?;
    
    try {
      return await _executeHttpRequest(url, method, headers, body);
    } catch (e) {
      return ToolResponse(error: 'HTTP Request failed: $e');
    }
  }

  Future<ToolResponse> _handleGraphqlQuery(Map<String, dynamic> parameters) async {
    final url = parameters['url'] as String?;
    final query = parameters['query'] as String?;
    if (url == null) return ToolResponse(error: 'url is required');
    if (query == null) return ToolResponse(error: 'query is required');
    
    final headersMap = parameters['headers'] as Map? ?? {};
    final headers = headersMap.cast<String, String>();
    final variables = parameters['variables'] as Map? ?? {};
    
    headers['Content-Type'] = 'application/json';
    
    final body = jsonEncode({
      'query': query,
      'variables': variables,
    });
    
    try {
      return await _executeHttpRequest(url, 'POST', headers, body);
    } catch (e) {
      return ToolResponse(error: 'GraphQL Request failed: $e');
    }
  }

  Future<ToolResponse> _handleAiApiTest(Map<String, dynamic> parameters) async {
    final requestId = parameters['requestId'] as String?;
    final prompt = parameters['prompt'] as String?;
    
    if (requestId == null) return ToolResponse(error: 'requestId is required');
    if (prompt == null) return ToolResponse(error: 'prompt is required');
    
    // As a proxy, run the replay_request to fetch the actual result
    final replayResult = await _handleReplayRequest({'requestId': requestId});
    if (replayResult.error != null) {
      return ToolResponse(error: 'Test execution failed: ${replayResult.error}');
    }
    
    return ToolResponse(result: {
      'status': 'test_report_generated',
      'instruction': 'LLM, analyze the following execution result against the given prompt.',
      'user_prompt': prompt,
      'execution_data': replayResult.result,
    });
  }
  
  Future<ToolResponse> _executeHttpRequest(String url, String method, Map<String, String> headers, String? body) async {
    final client = HttpClient();
    try {
      final req = await client.openUrl(method, Uri.parse(url));
      
      headers.forEach((key, value) {
        req.headers.set(key, value);
      });
      
      if (body != null && body.isNotEmpty) {
        req.write(body);
      }
      
      final res = await req.close();
      final resBodyBytes = await res.fold<List<int>>(<int>[], (prev, iter) => prev..addAll(iter));
      String resBody;
      try {
        resBody = utf8.decode(resBodyBytes);
      } catch (_) {
        resBody = "Binary Data (Cannot Decode)";
      }
      
      final resHeaders = <String, String>{};
      res.headers.forEach((name, values) {
        resHeaders[name] = values.join(',');
      });
      
      return ToolResponse(result: {
        'statusCode': res.statusCode,
        'headers': resHeaders,
        'body': resBody,
      });
    } finally {
      client.close();
    }
  }
}
