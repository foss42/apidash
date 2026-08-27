import 'package:apidash/services/secure_storage.dart';
import 'package:apidash/services/storage/workspace_storage.dart';
import 'package:apidash/workflow/models/workflow_models.dart';

/// Persist AI apiKeys for workflow request nodes to secure storage and strip
/// them from the JSON written to `workflows/*.json` (same idea as collection
/// `request.json`).
Future<Map<String, dynamic>> prepareWorkflowJsonForDisk({
  required String workflowId,
  required Map<String, dynamic> json,
}) async {
  if (!isWorkspaceStorageInitialized()) {
    return _stripAllWorkflowApiKeys(json);
  }
  final root = workspaceStorage.rootPath;
  final nodesRaw = json['nodes'];
  if (nodesRaw is! List) {
    return json;
  }

  final activeRequestIds = <String>{};
  final nodes = <Map<String, dynamic>>[];
  for (final entry in nodesRaw) {
    if (entry is! Map) {
      continue;
    }
    final node = Map<String, dynamic>.from(entry);
    final request = node['request'];
    if (request is Map) {
      final requestJson = Map<String, dynamic>.from(request);
      final requestId = requestJson['id']?.toString() ?? '';
      if (requestId.isNotEmpty) {
        activeRequestIds.add(requestId);
        final apiKey = AiRequestSecretsStorage.apiKeyFromJson(requestJson);
        if (apiKey != null && apiKey.isNotEmpty) {
          await aiRequestSecretsStorage.writeWorkflowApiKey(
            root,
            workflowId,
            requestId,
            apiKey,
          );
        } else {
          await aiRequestSecretsStorage.deleteWorkflowApiKey(
            root,
            workflowId,
            requestId,
          );
        }
      }
      node['request'] =
          AiRequestSecretsStorage.stripApiKeyFromJson(requestJson);
    }
    nodes.add(node);
  }

  await aiRequestSecretsStorage.deleteOrphansForWorkflow(
    root,
    workflowId,
    activeRequestIds,
  );

  return {
    ...json,
    'nodes': nodes,
  };
}

/// Restore AI apiKeys from secure storage into an in-memory workflow document.
Future<WorkflowDocument> hydrateWorkflowAiApiKeys(
  WorkflowDocument workflow,
) async {
  if (!isWorkspaceStorageInitialized()) {
    return workflow;
  }
  final root = workspaceStorage.rootPath;
  final nodes = <WorkflowGraphNode>[];
  var changed = false;

  for (final node in workflow.graph.nodes) {
    final request = node.request;
    if (request == null) {
      nodes.add(node);
      continue;
    }
    final requestId = request['id']?.toString() ?? '';
    if (requestId.isEmpty) {
      nodes.add(node);
      continue;
    }
    final apiKey = await aiRequestSecretsStorage.readWorkflowApiKey(
      root,
      workflow.id,
      requestId,
    );
    if (apiKey == null || apiKey.isEmpty) {
      nodes.add(node);
      continue;
    }
    final ai = request['aiRequestModel'];
    if (ai is! Map) {
      nodes.add(node);
      continue;
    }
    final requestCopy = Map<String, dynamic>.from(request);
    final aiCopy = Map<String, dynamic>.from(ai);
    aiCopy['apiKey'] = apiKey;
    requestCopy['aiRequestModel'] = aiCopy;
    nodes.add(node.copyWith(request: requestCopy));
    changed = true;
  }

  if (!changed) {
    return workflow;
  }
  return workflow.copyWith(
    graph: workflow.graph.copyWith(nodes: nodes),
  );
}

Map<String, dynamic> _stripAllWorkflowApiKeys(Map<String, dynamic> json) {
  final nodesRaw = json['nodes'];
  if (nodesRaw is! List) {
    return json;
  }
  final nodes = <dynamic>[];
  for (final entry in nodesRaw) {
    if (entry is! Map) {
      nodes.add(entry);
      continue;
    }
    final node = Map<String, dynamic>.from(entry);
    final request = node['request'];
    if (request is Map) {
      node['request'] = AiRequestSecretsStorage.stripApiKeyFromJson(
        Map<String, dynamic>.from(request),
      );
    }
    nodes.add(node);
  }
  return {...json, 'nodes': nodes};
}
