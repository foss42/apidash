import 'dart:convert';
import 'dart:io';
import 'package:mcp_dart/mcp_dart.dart';
import 'package:path/path.dart' as path;
import '../ui/list_collection_ui.dart';


const resourceUri = 'ui://collections/list.html';

class CollectionSummary {
  const CollectionSummary({required this.id, required this.name});

  final String id;
  final String name;

  Map<String, String> toJson() => {
        'id': id,
        'name': name,
      };
}

Future<List<CollectionSummary>> listCollectionsFromWorkspace(
  String workspacePath,
) async {
  final collectionsDir = Directory(path.join(workspacePath, 'collections'));
  if (!await collectionsDir.exists()) {
    return const <CollectionSummary>[];
  }

  final entities = await collectionsDir.list(followLinks: false).toList();
  final collectionDirs = entities.whereType<Directory>().toList()
    ..sort((a, b) => path.basename(a.path).compareTo(path.basename(b.path)));

  final output = <CollectionSummary>[];

  for (final collectionDir in collectionDirs) {
    final id = path.basename(collectionDir.path);
    final collectionFile = File(path.join(collectionDir.path, 'collection.json'));

    String name = id;

    if (await collectionFile.exists()) {
      try {
        final raw = await collectionFile.readAsString();
        final decodedJson = jsonDecode(raw);
        if (decodedJson is Map<String, dynamic>) {
          final parsedName = decodedJson['name'];
          if (parsedName is String && parsedName.trim().isNotEmpty) {
            name = parsedName.trim();
          }
        }
      } catch (_) { }
    }

    output.add(CollectionSummary(id: id, name: name));
  }

  return output;
}

void registerListCollections(
  McpServer server, {
  required String workspacePath,
}) {

  registerAppResource(
    server,
    'Collections List UI',
    resourceUri,
    const McpUiAppResourceConfig(
      description: 'Display all collections in the API Dash workspace',
      meta: {
        'ui': {
          'csp': {
            'resourceDomains': [],
          },
        },
      },
    ),
    (uri, extra) async {
      final collections = await listCollectionsFromWorkspace(workspacePath);
      final html = buildListCollectionsHtml(
        collections: collections
            .map((c) => {'id': c.id, 'name': c.name})
            .toList(),
      );

      return ReadResourceResult(
        contents: [
          TextResourceContents(
            uri: uri.toString(),
            mimeType: mcpUiResourceMimeType,
            text: html,
          ),
        ],
      );
    },
  );

  registerAppTool(
    server,
    'list_collections',
    McpUiAppToolConfig(
      description: 'List all collections available in the API Dash HIS workspace',
      inputSchema: const ToolInputSchema(properties: {}),
      meta: const {
        'ui': {
          'resourceUri': resourceUri,
          'visibility': ['model', 'app'],
        }
      },
    ),
    (args, extra) async {
      return CallToolResult(
        content: [
          ResourceLink(
            uri: resourceUri,
            name: 'Collections',
            mimeType: mcpUiResourceMimeType,
          ),
        ],
      );
    },
  );
}