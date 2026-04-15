import 'dart:convert';
import 'dart:io';

import 'package:apidash_storage/apidash_storage.dart';
import 'package:mcp_dart/mcp_dart.dart';
import 'package:path/path.dart' as path;

Future<void> _syncRequestAndIndexFiles(Map<String, dynamic> payload) async {
  final requestObject = payload['request'];
  if (requestObject is! Map) return;

  final request = requestObject.map(
    (key, value) => MapEntry(key.toString(), value),
  );

  final requestPath = request['path'].toString().trim();
  final requestFileName = request['file'].toString().trim();
  final requestData = request['data'];
  final requestId = request['id'].toString().trim();
  final collectionId = request['collectionId'].toString().trim();
  final folderId = request['folderId'].toString().trim();

  if (requestPath.isNotEmpty && requestData is Map) {
    try {
      final file = File(requestPath);
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(requestData),
      );
    } catch (_) {}
  }

  if (requestId.isEmpty || collectionId.isEmpty) return;

  final methodFromRequestData = requestData is Map
      ? requestData['method'].toString().trim().toUpperCase()
      : request['method'].toString().trim().toUpperCase();

  final urlFromRequestData = requestData is Map
      ? requestData['url'].toString().trim()
      : request['url'].toString().trim();

  if (methodFromRequestData.isEmpty) return;

  final indexPath = folderId.isNotEmpty
      ? path.join(
          path.dirname(path.dirname(requestPath)),
          folderId,
          'folder.json',
        )
      : path.join(path.dirname(requestPath), 'collection.json');

  try {
    final file = File(indexPath);
    if (!await file.exists()) return;

    final decoded = jsonDecode(await file.readAsString());
    if (decoded is! Map<String, dynamic>) return;

    final requests = decoded['requests'];
    if (requests is! List) return;

    var changed = false;

    for (var i = 0; i < requests.length; i++) {
      final entry = requests[i];
      if (entry is! Map<String, dynamic>) continue;
      final sanitized = <String, dynamic>{...entry}..remove('url');
      if (sanitized.length != entry.length) {
        requests[i] = sanitized;
        changed = true;
      }

      final normalizedEntry = requests[i];
      if (normalizedEntry is! Map<String, dynamic>) continue;
      final entryId = normalizedEntry['id'].toString().trim();
      final entryFile = normalizedEntry['file'].toString().trim();

      final isMatch =
          entryId == requestId ||
          (requestFileName.isNotEmpty && entryFile == requestFileName);
      if (!isMatch) continue;

      final currentName = normalizedEntry['name'].toString().trim();
      final computedName = currentName.isNotEmpty
          ? currentName
          : (urlFromRequestData.isNotEmpty
                ? '$methodFromRequestData $urlFromRequestData'
                : requestId);

      final updated = <String, dynamic>{
        ...normalizedEntry,
        'method': methodFromRequestData,
        'name': computedName,
      };

      requests[i] = updated;
      changed = true;
      break;
    }

    if (!changed) return;

    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(decoded),
    );
  } catch (_) {}
}

void registerExecuteSavedRequest(
  McpServer server, {
  required String workspacePath,
}) {
  final requestService = RequestService(workspacePath: workspacePath);

  server.registerTool(
    'execute_request',
    description:
        'Executes a saved API request by id, resolving it from HIS storage across all collections',
    inputSchema: ToolInputSchema(
      properties: {
        'id': JsonSchema.fromJson({
          'type': 'string',
          'description': 'The ID of the request to execute',
        }),
      },
      required: ['id'],
    ),
    callback: (args, extra) async {
      final requestId = args['id'] is String
          ? (args['id'] as String).trim()
          : null;

      if (requestId == null || requestId.isEmpty) {
        return CallToolResult.fromContent([
          TextContent(
            text: jsonEncode({'ok': false, 'error': 'Request id is required.'}),
          ),
        ]);
      }

      try {
        final payload = await requestService.executeStoredRequestById(
          requestId: requestId,
        );

        await _syncRequestAndIndexFiles(payload);

        return CallToolResult.fromContent([
          TextContent(text: jsonEncode(payload)),
        ]);
      } catch (e) {
        final now = DateTime.now().toUtc();

        final errorPayload = {
          'ok': false,
          'id': requestId,
          'error': e.toString(),
          'executedAt': now.toIso8601String(),
        };

        return CallToolResult.fromContent([
          TextContent(text: jsonEncode(errorPayload)),
        ]);
      }
    },
  );
}
