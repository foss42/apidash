import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import '../lib/src/mcp_protocol.dart';

void main() async {
  final router = Router();

  router.get('/health', (_) => Response.ok('{"status":"ok"}',
      headers: {'Content-Type': 'application/json'}));

  // mcp-remote probes GET /mcp first — must return 405, not 404
  router.get('/mcp', (_) => Response(405,
      headers: {'Allow': 'POST', 'Access-Control-Allow-Origin': '*'},
      body: '{"error":"Use POST"}'));

  router.post('/mcp', (Request req) async {
    final body = await req.readAsString();
    stderr.writeln('📨 REQUEST: $body');

    dynamic decoded;
    try {
      decoded = jsonDecode(body);
    } catch (e) {
      return Response(400,
          body: '{"error":"Invalid JSON"}',
          headers: {'Content-Type': 'application/json'});
    }

    // Handle both single request (Map) and batched requests (List)
    String responseStr;
    if (decoded is List) {
      // Batch: process each, skip notifications (no id)
      final responses = <Map<String, dynamic>>[];
      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          final hasId = item.containsKey('id') && item['id'] != null;
          if (hasId) {
            final resp = await McpProtocol.handle(item);
            responses.add(resp);
          } else {
            // Notification — handle silently, no response
            await McpProtocol.handleNotification(item);
          }
        }
      }
      responseStr = jsonEncode(responses);
    } else if (decoded is Map<String, dynamic>) {
      // Single request
      final hasId = decoded.containsKey('id') && decoded['id'] != null;
      if (!hasId) {
        // Pure notification — no response body needed
        await McpProtocol.handleNotification(decoded);
        responseStr = '';
      } else {
        final resp = await McpProtocol.handle(decoded);
        responseStr = jsonEncode(resp);
      }
    } else {
      return Response(400,
          body: '{"error":"Unexpected body type"}',
          headers: {'Content-Type': 'application/json'});
    }

    stderr.writeln('📤 RESPONSE: $responseStr');

    if (responseStr.isEmpty) {
      return Response(204, headers: {'Access-Control-Allow-Origin': '*'});
    }

    return Response.ok(responseStr, headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    });
  });

  router.options('/mcp', (_) => Response.ok('', headers: {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  }));

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.call);

  final server = await shelf_io.serve(handler, '127.0.0.1', 3000);
  stderr.writeln('🚀 APIDash MCP server running at http://${server.address.host}:${server.port}');
  stderr.writeln('📡 MCP endpoint: http://localhost:3000/mcp');
}