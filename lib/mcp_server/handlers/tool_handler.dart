import 'dart:async';
import 'package:hive_ce/hive.dart';
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
}
