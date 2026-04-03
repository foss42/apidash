import 'dart:async';
import 'dart:convert';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:stream_channel/stream_channel.dart';
import 'transport.dart';
import 'models.dart';

abstract class ResourceHandler {
  Future<List<ResourceDescriptor>> listResources();
  Future<Resource?> getResource(String id);
}

abstract class ToolHandler {
  Future<List<ToolDescriptor>> listTools();
  Future<ToolResponse> invokeTool(String name, Map<String, dynamic> parameters);
}

class ServerCore {
  final Transport transport;
  late final json_rpc.Server _server;
  ResourceHandler? _resourceHandler;
  ToolHandler? _toolHandler;
  
  final List<ToolDescriptor> _registeredTools = [];
  final Map<String, Future<ToolResponse> Function(Map<String, dynamic>)> _toolCallbacks = {};

  void Function()? onConnect;
  void Function()? onDisconnect;

  ServerCore(this.transport) {
    final channel = StreamChannel<String>(
      transport.stream,
      StreamController<String>()..stream.listen(transport.send),
    );
    _server = json_rpc.Server(channel);

    _server.registerMethod('ping', () => {'ok': true});

    _server.registerMethod('initialize', (parameters) {
      if (onConnect != null) onConnect!();
      return {
        'protocolVersion': '2024-11-05',
        'capabilities': {
          'resources': {'listChanged': true},
          'tools': {'listChanged': true},
        },
        'serverInfo': {
          'name': 'apidash-mcp-server',
          'version': '1.0.0',
        },
      };
    });

    _server.registerMethod('listResources', () async {
      if (_resourceHandler == null) return [];
      final resources = await _resourceHandler!.listResources();
      return resources.map((r) => r.toJson()).toList();
    });

    _server.registerMethod('resources/list', () async {
      if (_resourceHandler == null) return {'resources': []};
      final resources = await _resourceHandler!.listResources();
      return {'resources': resources.map((r) => r.toJson()).toList()};
    });

    _server.registerMethod('getResource', (parameters) async {
      if (_resourceHandler == null) throw json_rpc.RpcException(-32601, 'No resource handler');
      final id = parameters['id'].asString;
      final resource = await _resourceHandler!.getResource(id);
      if (resource == null) throw json_rpc.RpcException(404, 'Resource not found');
      return resource.toJson();
    });

    _server.registerMethod('resources/read', (parameters) async {
      if (_resourceHandler == null) throw json_rpc.RpcException(-32601, 'No resource handler');
      final uri = parameters['uri'].asString;
      final resource = await _resourceHandler!.getResource(uri);
      if (resource == null) throw json_rpc.RpcException(404, 'Resource not found');
      return {'contents': [resource.toJson()]};
    });

    _server.registerMethod('listTools', () async {
      final tools = <ToolDescriptor>[];
      if (_toolHandler != null) {
        tools.addAll(await _toolHandler!.listTools());
      }
      tools.addAll(_registeredTools);
      return tools.map((t) => t.toJson()).toList();
    });

    _server.registerMethod('tools/list', () async {
      final tools = <ToolDescriptor>[];
      if (_toolHandler != null) {
        tools.addAll(await _toolHandler!.listTools());
      }
      tools.addAll(_registeredTools);
      return {'tools': tools.map((t) => t.toJson()).toList()};
    });

    _server.registerMethod('invokeTool', (parameters) async {
      final name = parameters['name'].asString;
      final params = parameters['parameters'].asMap.cast<String, dynamic>();
      
      if (_toolCallbacks.containsKey(name)) {
        final response = await _toolCallbacks[name]!(params);
        return response.toJson();
      }

      if (_toolHandler == null) throw json_rpc.RpcException(-32601, 'No tool handler');
      final response = await _toolHandler!.invokeTool(name, params);
      return response.toJson();
    });

    _server.registerMethod('tools/call', (parameters) async {
      final name = parameters['name'].asString;
      final args = (parameters['arguments'].value as Map? ?? {}).cast<String, dynamic>();
      
      Future<ToolResponse> invoke() async {
        if (_toolCallbacks.containsKey(name)) {
          return await _toolCallbacks[name]!(args);
        }
        if (_toolHandler == null) throw json_rpc.RpcException(-32601, 'No tool handler');
        return await _toolHandler!.invokeTool(name, args);
      }

      try {
        final response = await invoke();
        if (response.error != null) {
          return {
            'isError': true,
            'content': [
              {'type': 'text', 'text': 'Error: ${response.error}'}
            ]
          };
        }
        
        final resultText = response.result is String 
            ? response.result as String 
            : jsonEncode(response.result);
            
        return {
          'content': [
            {'type': 'text', 'text': resultText}
          ]
        };
      } catch (e) {
        return {
          'isError': true,
          'content': [
            {'type': 'text', 'text': 'Exception: $e'}
          ]
        };
      }
    });
  }

  void registerTool(ToolDescriptor tool, Future<ToolResponse> Function(Map<String, dynamic>) callback) {
    _registeredTools.add(tool);
    _toolCallbacks[tool.name] = callback;
  }

  void setResourceHandler(ResourceHandler handler) {
    _resourceHandler = handler;
  }

  void setToolHandler(ToolHandler handler) {
    _toolHandler = handler;
  }

  Future<void> start() async {
    await _server.listen();
    if (onDisconnect != null) onDisconnect!();
  }
}
