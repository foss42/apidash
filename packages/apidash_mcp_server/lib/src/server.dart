import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'mcp_handlers.dart';

/// Builds and returns the shelf Handler for the MCP server.
Handler buildMcpServer() {
  final router = Router();

  // MCP discovery endpoint — Claude/VS Code calls this first
  router.get('/mcp', (Request req) {
    return Response.ok(
      jsonEncode(mcpManifest()),
      headers: {'content-type': 'application/json'},
    );
  });

  // Tool call dispatcher
  router.post('/mcp/call', (Request req) async {
    final body = await req.readAsString();
    final Map<String, dynamic> payload = jsonDecode(body);

    final toolName = payload['tool'] as String?;
    final args = payload['arguments'] as Map<String, dynamic>? ?? {};

    if (toolName == null) {
      return Response(400, body: jsonEncode({'error': 'Missing tool name'}));
    }

    try {
      final result = await dispatchTool(toolName, args);
      return Response.ok(
        jsonEncode({'result': result}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response(500,
          body: jsonEncode({'error': e.toString()}),
          headers: {'content-type': 'application/json'});
    }
  });

  // Health check
  router.get('/health', (Request req) {
    return Response.ok(jsonEncode({'status': 'ok', 'server': 'apidash_mcp_server'}),
        headers: {'content-type': 'application/json'});
  });

  return Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsMiddleware())
      .addHandler(router.call);
}

/// Adds CORS headers so Claude desktop can reach the server.
Middleware _corsMiddleware() {
  return (Handler inner) {
    return (Request req) async {
      if (req.method == 'OPTIONS') {
        return Response.ok('', headers: _corsHeaders);
      }
      final response = await inner(req);
      return response.change(headers: _corsHeaders);
    };
  };
}

const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};