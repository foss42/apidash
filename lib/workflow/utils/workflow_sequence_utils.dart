import 'dart:convert';

import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/utils/workflow_loop_utils.dart';

/// Resolve Sequence node → list of item strings (same shape For each / {{vars}} expect).
List<String> resolveSequenceItems({
  required WorkflowSequenceSource source,
  required String? value,
}) {
  final raw = value?.trim() ?? '';
  if (raw.isEmpty) {
    return const [];
  }
  switch (source) {
    case WorkflowSequenceSource.list:
      return _parseBracketCommaList(raw);
    case WorkflowSequenceSource.json:
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          return decoded.map(stringifyLoopItem).toList();
        }
      } catch (_) {}
      return const [];
    case WorkflowSequenceSource.jsonl:
      final items = <String>[];
      for (final line in raw.split('\n')) {
        final trimmed = line.trim();
        if (trimmed.isEmpty) {
          continue;
        }
        try {
          items.add(stringifyLoopItem(jsonDecode(trimmed)));
        } catch (_) {
          items.add(trimmed);
        }
      }
      return items;
  }
}

/// `[alice, bob, carol]` or `["a", "b"]` — brackets + comma-separated.
List<String> _parseBracketCommaList(String raw) {
  var body = raw.trim();
  if (body.startsWith('[') && body.endsWith(']')) {
    body = body.substring(1, body.length - 1).trim();
  }
  if (body.isEmpty) {
    return const [];
  }
  // Real JSON string array — prefer proper decode when quoted.
  if (raw.trim().startsWith('[') && raw.contains('"')) {
    try {
      final decoded = jsonDecode(raw.trim());
      if (decoded is List) {
        return decoded.map(stringifyLoopItem).toList();
      }
    } catch (_) {}
  }
  return [
    for (final part in body.split(','))
      if (_stripListItem(part).isNotEmpty) _stripListItem(part),
  ];
}

String _stripListItem(String raw) {
  var item = raw.trim();
  if (item.length >= 2) {
    final start = item[0];
    final end = item[item.length - 1];
    if ((start == '"' && end == '"') || (start == "'" && end == "'")) {
      item = item.substring(1, item.length - 1);
    }
  }
  return item.trim();
}

/// Store as a JSON array string so For each / [resolveLoopItemList] / {{as}} work.
String encodeSequenceVariable(List<String> items) {
  return jsonEncode([
    for (final item in items) _decodeOrString(item),
  ]);
}

dynamic _decodeOrString(String item) {
  try {
    return jsonDecode(item);
  } catch (_) {
    return item;
  }
}

String sequenceSourceSubtitle(WorkflowGraphNode node) {
  final asName = node.loopItemAs?.trim();
  final asLabel =
      (asName != null && asName.isNotEmpty) ? '{{$asName}}' : 'set as';
  return switch (node.sequenceSource) {
    WorkflowSequenceSource.list => 'List → $asLabel',
    WorkflowSequenceSource.json => 'JSON → $asLabel',
    WorkflowSequenceSource.jsonl => 'JSONL → $asLabel',
  };
}
