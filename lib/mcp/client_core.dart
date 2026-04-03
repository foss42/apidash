import 'dart:async';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:stream_channel/stream_channel.dart';
import 'transport.dart';
import 'models.dart';

class ClientCore {
  final Transport transport;
  late final json_rpc.Client _client;

  ClientCore(this.transport) {
    final channel = StreamChannel<String>(
      transport.stream,
      StreamController<String>()..stream.listen(transport.send),
    );
    _client = json_rpc.Client(channel);
  }

  Future<void> start() async {
    unawaited(_client.listen() as Future<void>);
  }

  Future<Map<String, dynamic>> initialize() async {
    final result = await _client.sendRequest('initialize', {
      'protocolVersion': '2024-11-05',
      'capabilities': {},
      'clientInfo': {
        'name': 'apidash-mcp-client',
        'version': '1.0.0',
      },
    });
    _client.sendNotification('initialized');
    return result as Map<String, dynamic>;
  }

  Future<List<ToolDescriptor>> listTools() async {
    try {
      final result = await _client.sendRequest('tools/list');
      final tools = (result as Map)['tools'] as List;
      return tools.map((t) => ToolDescriptor.fromJson(t as Map<String, dynamic>)).toList();
    } catch (_) {
      final result = await _client.sendRequest('listTools');
      return (result as List).map((t) => ToolDescriptor.fromJson(t as Map<String, dynamic>)).toList();
    }
  }

  Future<ToolResponse> callTool(String name, Map<String, dynamic> arguments) async {
    try {
      final result = await _client.sendRequest('tools/call', {
        'name': name,
        'arguments': arguments,
      });
      final content = (result as Map)['content'] as List;
      final text = content.map((c) => c['text']).join('\n');
      return ToolResponse(result: text, error: (result)['isError'] == true ? text : null);
    } catch (_) {
      final result = await _client.sendRequest('invokeTool', {
        'name': name,
        'parameters': arguments,
      });
      return ToolResponse.fromJson(result as Map<String, dynamic>);
    }
  }

  Future<List<ResourceDescriptor>> listResources() async {
    try {
      final result = await _client.sendRequest('resources/list');
      final resources = (result as Map)['resources'] as List;
      return resources.map((r) => ResourceDescriptor.fromJson(r as Map<String, dynamic>)).toList();
    } catch (_) {
      final result = await _client.sendRequest('listResources');
      return (result as List).map((r) => ResourceDescriptor.fromJson(r as Map<String, dynamic>)).toList();
    }
  }

  Future<Map<String, dynamic>> readResource(String uri) async {
    try {
      final result = await _client.sendRequest('resources/read', {'uri': uri});
      return result as Map<String, dynamic>;
    } catch (_) {
      final result = await _client.sendRequest('getResource', {'id': uri});
      return result as Map<String, dynamic>;
    }
  }

  Future<void> close() => _client.close();
}
