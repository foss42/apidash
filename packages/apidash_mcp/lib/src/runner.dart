import 'dart:io';
import 'package:apidash_mcp/src/tools/execute_saved_request_tool.dart';
import 'package:mcp_dart/mcp_dart.dart';
import 'tools/browse_collections.dart';

Future<void> runServer() async {
  final workspacePath = Platform.environment['APIDASH_WORKSPACE_PATH'];

  if (workspacePath == null || workspacePath.trim().isEmpty) {
    stderr.writeln(
      'APIDASH_WORKSPACE_PATH is not set. '
      'Set it to your HIS workspace path before starting apidash_mcp.',
    );
    exitCode = 64;
    return;
  }

  final server = McpServer(
    const Implementation(name: 'apidash_mcp', version: '0.1.0'),
    options: McpServerOptions(
      capabilities: ServerCapabilities(
        tools:  const ServerCapabilitiesTools(),
        resources: const ServerCapabilitiesResources(),
        extensions: withMcpUiExtension(),
      ),
    ),
  );

  toolRegister(server, workspacePath);

  await server.connect(StdioServerTransport());
}


void toolRegister(McpServer server, String workspacePath) {
  registerBrowserCollectionsTool(server, workspacePath: workspacePath);
  registerExecuteSavedRequest(server, workspacePath: workspacePath);
}