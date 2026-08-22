import 'dart:convert';
import 'dart:isolate';
import 'dart:io';
import 'tools/tool_handler.dart';
import 'resources/resource_handler.dart';

void runMcpEngine(SendPort uiSendPort) {
  final engineReceivePort = ReceivePort();
  uiSendPort.send(engineReceivePort.sendPort);

  engineReceivePort.listen((message) async {
    if (message is! String) return;

    try {
      final requestJson = jsonDecode(message);
      final id = requestJson['id'];
      final rpcMethod = requestJson['method'];

      // Notifications don't have IDs, so we can ignore them
      if (id == null) return;

      void sendResponse(Map<String, dynamic> result) {
        uiSendPort.send(jsonEncode({"jsonrpc": "2.0", "id": id, "result": result}));
      }

      // NEW: Added an error responder so the host never hangs
      void sendError(int code, String errMsg) {
        uiSendPort.send(jsonEncode({
          "jsonrpc": "2.0",
          "id": id,
          "error": {"code": code, "message": errMsg}
        }));
      }

      try {
        switch (rpcMethod) {
          case 'initialize':
            sendResponse({
              "protocolVersion": "2025-11-25",
              "capabilities": {
                "tools": {},
                "resources": {},
                "extensions": {"io.modelcontextprotocol/ui": {"mimeTypes": ["text/html;profile=mcp-app"]}},
              },
              "serverInfo": {"name": "apidash-agentic-engine", "version": "6.0.0"},
            });
            break;

          case 'resources/list':
            sendResponse(ResourceHandler.listResources());
            break;

          case 'resources/read':
            final uri = requestJson['params']?['uri']?.toString() ?? '';
            sendResponse(ResourceHandler.readResource(uri));
            break;

          case 'tools/list':
            sendResponse(ToolHandler.listTools());
            break;

          case 'tools/call':
            final name = requestJson['params']['name'];
            final args = requestJson['params']['arguments'] ?? {};
            final result = await ToolHandler.executeTool(name, args, id.toString());
            sendResponse(result);
            break;

          default:
            stderr.writeln("⚠️ Unhandled MCP Method: $rpcMethod");
            // FIXED: If the host pings an unknown method, tell it we don't know it
            sendError(-32601, "Method not found: $rpcMethod");
        }
      } catch (e) {
        stderr.writeln("❌ Server Execution Error: $e");
        // FIXED: If Dart throws an exception, tell the host instead of silently dropping it!
        sendError(-32603, "Internal server error: $e");
      }
    } catch (e) {
      stderr.writeln("❌ MCP Protocol Parse Error: $e");
    }
  });
}