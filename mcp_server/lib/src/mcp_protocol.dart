import 'mcp_tools.dart';
import 'mcp_resources.dart';

/// Handles MCP JSON-RPC 2.0 protocol messages.
/// Supports: initialize, tools/list, tools/call, resources/list, resources/read
class McpProtocol {
  static Future<Map<String, dynamic>> handle(
      Map<String, dynamic> rpc) async {
    final id     = rpc['id'];
    final method = rpc['method'] as String? ?? '';
    final params = rpc['params'] as Map<String, dynamic>? ?? {};

    try {
      final result = await _dispatch(method, params);
      return {'jsonrpc': '2.0', 'id': id, 'result': result};
    } catch (e) {
      return {
        'jsonrpc': '2.0',
        'id': id,
        'error': {'code': -32603, 'message': e.toString()},
      };
    }
  }

  static Future<Map<String, dynamic>> _dispatch(
      String method, Map<String, dynamic> params) async {
    switch (method) {
      // ── Lifecycle ──────────────────────────────────────────────────────
      case 'initialize':
        return {
          'protocolVersion': '2025-03-26',
          'capabilities': {
            'tools': {},
            'resources': {},
          },
          'serverInfo': {
            'name': 'apidash_mcp_server',
            'version': '0.1.0',
          },
        };

      case 'notifications/initialized':
        return {};

      // ── Tools ──────────────────────────────────────────────────────────
      case 'tools/list':
        return {'tools': McpTools.manifest()};

      case 'tools/call':
        final name    = params['name'] as String;
        final args    = params['arguments'] as Map<String, dynamic>? ?? {};
        return McpTools.call(name, args);

      // ── Resources ─────────────────────────────────────────────────────
      case 'resources/list':
        return {'resources': McpResources.list()};

      case 'resources/read':
        final uri = params['uri'] as String;
        return McpResources.read(uri);

      default:
        throw UnimplementedError('Method not supported: $method');
    }
  }
}