import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import '../lib/src/mcp_tools.dart';
import '../lib/src/mcp_resources.dart';

void main() async {
  final router = Router();

  // Health check
  router.get('/health', (Request req) {
    return Response.ok(
      jsonEncode({'status': 'ok', 'server': 'apidash-mcp'}),
      headers: {'Content-Type': 'application/json'},
    );
  });

  // Main MCP endpoint — VSCode posts all JSON-RPC here
  router.post('/mcp', (Request req) async {
    final body = await req.readAsString();
    final json = jsonDecode(body) as Map<String, dynamic>;

    final response = await _handleJsonRpc(json);

    return Response.ok(
      jsonEncode(response),
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      },
    );
  });

  // CORS preflight
  router.options('/mcp', (Request req) {
    return Response.ok('', headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'POST, GET, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
    });
  });

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.call);

  final port = int.parse(Platform.environment['PORT'] ?? '3000');
  final server = await io.serve(handler, 'localhost', port);

  print('MCP server running at http://${server.address.host}:${server.port}');
  print('VSCode MCP endpoint: http://localhost:$port/mcp');
  print('Test: curl -X POST http://localhost:$port/mcp -H "Content-Type: application/json" -d \'{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-11-21","capabilities":{},"clientInfo":{"name":"test","version":"1"}}}\' ');
}

// ── JSON-RPC dispatcher ─────────────────────────────────────────────────────

Future<Map<String, dynamic>> _handleJsonRpc(
    Map<String, dynamic> req) async {
  final id = req['id'];
  final method = req['method'] as String;
  final params = (req['params'] as Map<String, dynamic>?) ?? {};

  try {
    final result = await _dispatch(method, params);
    return {'jsonrpc': '2.0', 'id': id, 'result': result};
  } catch (e, st) {
    stderr.writeln('Error handling $method: $e\n$st');
    return {
      'jsonrpc': '2.0',
      'id': id,
      'error': {'code': -32603, 'message': e.toString()},
    };
  }
}

Future<Map<String, dynamic>> _dispatch(
    String method, Map<String, dynamic> params) async {
  return switch (method) {
    // MCP lifecycle
    'initialize' => _initialize(params),
    'notifications/initialized' => {},

    // Tools
    'tools/list' => {'tools': McpTools.manifest()},
    'tools/call' => await McpTools.call(
        params['name'] as String,
        (params['arguments'] as Map<String, dynamic>?) ?? {},
      ),

    // Resources
    'resources/list' => {'resources': McpResources.list()},
    'resources/read' => McpResources.read(
        params['uri'] as String,
      ),

    // MCP Apps UI messages (forwarded from the iframe postMessage)
    'ui/initialize' => {
        'protocolVersion': '2025-11-21',
        'capabilities': {},
        'serverInfo': {'name': 'apidash-mcp', 'version': '1.0.0'},
      },
    'ui/update-model-context' => {
        'success': true,
        // The structured content here gets injected into the model's context
        // by VSCode's MCP host — we just acknowledge receipt
        'structuredContent': params['structuredContent'],
      },

    _ => throw Exception('Method not found: $method'),
  };
}

Map<String, dynamic> _initialize(Map<String, dynamic> params) {
  return {
    'protocolVersion': '2025-11-21',
    'capabilities': {
      'tools': {'listChanged': false},
      'resources': {'subscribe': false, 'listChanged': false},
    },
    'serverInfo': {
      'name': 'apidash-mcp',
      'version': '1.0.0',
    },
  };
}