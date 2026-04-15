import 'dart:convert';

import 'package:apidash_storage/apidash_storage.dart';
import 'package:apidash_mcp/src/ui/browse_collection_ui.dart';
import 'package:mcp_dart/mcp_dart.dart';

const resourceUriApp = 'apidash://apps/collection-browser';

Future<String> _getCollectionTreeJson(String workspacePath) async {
  final tree = await HisService.loadCollectionTree(workspacePath);
  return jsonEncode(tree);
}

void registerBrowserCollectionsTool(
  McpServer server, {
  required String workspacePath,
}) {
  Future<ReadResourceResult> buildBrowserResource(Uri uri) async {
    final initialTreeJson = await _getCollectionTreeJson(workspacePath);
    return ReadResourceResult(
      contents: [
        TextResourceContents(
          uri: uri.toString(),
          mimeType: mcpUiResourceMimeType,
          text:  buildBrowseCollectionsUi(initialTreeJson: initialTreeJson),
          meta: const McpUiResourceMeta(prefersBorder: false).toMeta(),
        ),
      ],
    );
  }

  registerAppResource(
    server,
    'Collection Browser',
    resourceUriApp,
    const McpUiAppResourceConfig(
      description: 'Browse and select saved API requests',
      meta: {
        'ui': {
          'csp': {'connectDomains': []},
          'prefersBorder': false,
          'layout': 'full',
          'size': 'large',
          'resizable': true,
          'allowHostMessaging': true,
        },
      },
    ),
    (uri, extra) => buildBrowserResource(uri),
  );

  registerAppTool(
    server,
    'browse_collections',
    McpUiAppToolConfig(
      description:
          'Opens the visual collection browser to find and select a saved request',
      inputSchema: JsonSchema.object(properties: {}, required: []),
      meta: const {
        'ui': {'resourceUri': resourceUriApp},
      },
    ),
    (args, extra) async {
      final treeJson = await _getCollectionTreeJson(workspacePath);
      final decoded = jsonDecode(treeJson);
      final tree = decoded is Map<String, dynamic>
          ? decoded
          : <String, dynamic>{'collections': const []};
      return CallToolResult(
        structuredContent: {'tree': tree},
        content: [
          TextContent(text: 'Opened collection browser'),
          ResourceLink(
            uri: resourceUriApp,
            name: 'Collection Browser',
            meta: const McpUiResourceMeta(
              prefersBorder: false,
            ).toMeta(),
            mimeType: mcpUiResourceMimeType,
          ),
        ],
      );
    },
  );
}
