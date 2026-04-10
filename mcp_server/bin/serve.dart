import 'dart:io';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:apidash_mcp_server/src/mcp_protocol.dart';

void main() async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '8765') ?? 8765;
  final router = Router();

  // ── Single MCP endpoint (Streamable HTTP transport) ──────────────────────
  // VS Code / Claude Desktop POSTs all JSON-RPC here
  router.post('/mcp', (Request req) async {
    final body = await req.readAsString();
    final rpc = jsonDecode(body) as Map<String, dynamic>;
    final response = await McpProtocol.handle(rpc);
    return Response.ok(
      jsonEncode(response),
      headers: {'content-type': 'application/json'},
    );
  });

  // ── Health ────────────────────────────────────────────────────────────────
  router.get('/health', (_) => Response.ok(
    jsonEncode({'status': 'ok', 'server': 'apidash_mcp_server'}),
    headers: {'content-type': 'application/json'},
  ));

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_cors())
      .addHandler(router.call);

  final server = await io.serve(handler, InternetAddress.loopbackIPv4, port);
  print('[apidash_mcp_server] Listening on http://localhost:${server.port}');
  print('[apidash_mcp_server] MCP endpoint: http://localhost:${server.port}/mcp');
  print('[apidash_mcp_server] Test: npx @modelcontextprotocol/inspector http://localhost:${server.port}/mcp');
}

Middleware _cors() => (Handler inner) => (Request req) async {
  if (req.method == 'OPTIONS') return Response.ok('', headers: _h);
  return (await inner(req)).change(headers: _h);
};

const _h = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};