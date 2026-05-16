import 'package:apidash/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import 'dashbot_prompts.dart';

const int _kMaxRequestsInPrompt = 30;
const int _kMaxNodePreview = 24;

/// Full system prompt for DashBot “generate workflow”: app context + task template + optional history.
///
/// [formatHistory] comes from [PromptBuilder.buildHistoryBlock] so prompts stay independent of `services/agent`.
String buildWorkflowGenerationSystemPrompt({
  required Ref ref,
  required List<ChatMessage> history,
  required String Function(List<ChatMessage>) formatHistory,
}) {
  final task = DashbotPrompts().generateWorkflowPrompt(
    workflowContextText: _workflowContextText(ref),
    requestsContextText: _requestsContextText(ref),
  );
  final historyBlock = formatHistory(history);
  return [
    task,
    if (historyBlock.isNotEmpty) historyBlock,
  ].join('\n\n');
}

String _requestsContextText(Ref ref) {
  final requestsById = ref.read(collectionStateNotifierProvider) ?? {};
  final sequence = ref.read(requestSequenceProvider);
  final orderedIds = [
    ...sequence.where((id) => requestsById.containsKey(id)),
    ...requestsById.keys.where((id) => !sequence.contains(id)),
  ];

  if (orderedIds.isEmpty) {
    return '(no requests in collection)';
  }

  final buf = StringBuffer();
  var i = 0;
  for (final id in orderedIds.take(_kMaxRequestsInPrompt)) {
    final r = requestsById[id];
    final http = r?.httpRequestModel;
    i += 1;
    buf.writeln(
      '$i. id=$id | name=${r?.name ?? ''} | method=${http?.method.name.toUpperCase() ?? ''} | url=${http?.url ?? ''}',
    );
  }
  return buf.toString().trimRight();
}

String _workflowContextText(Ref ref) {
  final buf = StringBuffer();
  final activeWorkflowId = ref.read(workflowIdStateProvider);
  final workflow = activeWorkflowId == null
      ? null
      : ref.read(workflowsStateProvider)[activeWorkflowId];

  buf.writeln('activeWorkflowId: $activeWorkflowId');
  buf.writeln('activeWorkflowName: ${workflow?.name}');
  buf.writeln('activeWorkflowDescription: ${workflow?.description}');

  final graphData = workflow?.graphData ?? const <String, dynamic>{};
  if (graphData.isEmpty) {
    buf.writeln('existingGraphData: (empty)');
    return buf.toString().trimRight();
  }

  final nodesRaw = graphData['nodes'];
  final connsRaw = graphData['connections'];
  final nodes = nodesRaw is List ? nodesRaw : const [];
  final conns = connsRaw is List ? connsRaw : const [];

  buf.writeln(
    'existingGraphSummary: nodes=${nodes.length}, connections=${conns.length}',
  );
  if (nodes.isNotEmpty) {
    buf.writeln('existingNodes (id → nodeType):');
    for (final raw in nodes.take(_kMaxNodePreview)) {
      if (raw is! Map) continue;
      final m = raw.map((k, v) => MapEntry(k.toString(), v));
      final id = m['id']?.toString() ?? '?';
      final data = m['data'];
      var type = '?';
      if (data is Map) {
        type = data['nodeType']?.toString() ?? '?';
      }
      buf.writeln('  - $id → $type');
    }
    if (nodes.length > _kMaxNodePreview) {
      buf.writeln('  … and ${nodes.length - _kMaxNodePreview} more node(s)');
    }
  }

  return buf.toString().trimRight();
}
