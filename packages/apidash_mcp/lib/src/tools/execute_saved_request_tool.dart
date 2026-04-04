import 'dart:convert';
import 'dart:io';

import 'package:better_networking/better_networking.dart';
import 'package:mcp_dart/mcp_dart.dart';
import 'package:path/path.dart' as path;

const resourceUri = 'ui://collections/request.html';

Future<HttpRequestModel?> loadRequest(String workspacePath, String collectionId, String? folderId, String requestId) async {
  String requestPath;

 if (folderId != null && folderId.trim().isNotEmpty) {
    requestPath = path.join(
      workspacePath,
      'collections',
      collectionId,
      folderId,
      '$requestId.json',
    );
  } else {
    requestPath = path.join(
      workspacePath,
      'collections',
      collectionId,
      '$requestId.json',
    );
  }

 final requestFile = File(requestPath);

  if (!await requestFile.exists()) {
    return null;
  }

  try {
    final raw = await requestFile.readAsString();
    final decodedJson = jsonDecode(raw);

    if(decodedJson is Map<String, dynamic>) {
      return HttpRequestModel.fromJson(decodedJson);
    }
  } catch (e) {
    print('Error decoding request: $e');
  }

  return null;

}

Future<Map<String, dynamic>> executeRequest(String workspacePath, String collectionId, String? folderId, String requestId) async {

    final request = await loadRequest(workspacePath, collectionId, folderId, requestId);

    if (request == null){
      throw Exception('Request with id $requestId not found in collection $collectionId');
    }

    final (response, duration, error) = await sendHttpRequest(
      requestId,
      APIType.rest,
      request,
    );
    if (error != null || response == null) {
      throw Exception(error ?? 'Request failed');
    }
    return HttpResponseModel().fromResponse(response: response, time: duration).toJson();
}

void registerExecuteSavedRequest(
  McpServer server, {
  required String workspacePath,
}) {
    server.registerTool(
      "execute_saved_request",
      description: "Execute a saved request from a collection",
      inputSchema: ToolInputSchema(
          properties: {
            'collectionId': JsonSchema.string(),
            'folderId': JsonSchema.string(),
            'requestId': JsonSchema.string(),
          },
          required: ['collectionId', 'requestId']

      ),
      callback: (args, extra) async {
        final collectionId = args['collectionId'] as String;
        final folderId = args['folderId'] as String?;
        final requestId = args['requestId'] as String;

        final result = await executeRequest(workspacePath, collectionId, folderId, requestId);

        return CallToolResult(
          content: [
          TextContent(
            text: result.toString(),
          )
        ]);
        
      },
      );
}

