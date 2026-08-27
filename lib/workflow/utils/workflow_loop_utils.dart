import 'dart:convert';

String? parseLoopListVariableName(String? raw) {
  var value = raw?.trim() ?? '';
  if (value.isEmpty) {
    return null;
  }
  if (value.startsWith('var:')) {
    value = value.substring(4).trim();
  }
  final mustache = RegExp(r'^\{\{\s*(.+?)\s*\}\}$');
  final match = mustache.firstMatch(value);
  if (match != null) {
    value = match.group(1)!.trim();
  }
  if (value.isEmpty) {
    return null;
  }
  return value;
}

/// Display / edit form for a list variable reference.
String formatLoopListVariableRef(String? name) {
  final parsed = parseLoopListVariableName(name);
  if (parsed == null) {
    return '';
  }
  return '{{$parsed}}';
}

String encodeLoopListExpression(String? raw) {
  final name = parseLoopListVariableName(raw);
  if (name == null) {
    return '';
  }
  return 'var:$name';
}

String? formatLoopItemExtractionPreview({
  required String? listRaw,
  required String? pathRaw,
  String? asRaw,
}) {
  final listName = parseLoopListVariableName(listRaw);
  final path = pathRaw?.trim() ?? '';
  final asName = parseLoopListVariableName(asRaw) ?? asRaw?.trim() ?? '';
  if (listName == null) {
    return null;
  }
  if (path.isEmpty) {
    if (asName.isEmpty) {
      return null;
    }
    return 'each {{$listName}} item → {{$asName}}';
  }
  if (asName.isEmpty) {
    return '{{$listName}}.$path';
  }
  return '{{$listName}}.$path → {{$asName}}';
}

String stringifyLoopItem(dynamic item) {
  if (item == null) {
    return '';
  }
  if (item is String) {
    return item;
  }
  if (item is num || item is bool) {
    return item.toString();
  }
  return jsonEncode(item);
}

List<String> resolveLoopItemList(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) {
    return const [];
  }
  try {
    final decoded = jsonDecode(trimmed);
    if (decoded is List) {
      return decoded.map(stringifyLoopItem).toList();
    }
  } catch (_) {
    return trimmed
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
  return const [];
}

/// Clears previous `loop.item` / `loop.item.*` / `loop.index` bindings.
void clearLoopScopedVariables(
  Map<String, String> scopedVariables, {
  String? itemAs,
}) {
  scopedVariables.removeWhere(
    (key, _) =>
        key == 'loop.item' ||
        key == 'loop.index' ||
        key.startsWith('loop.item.'),
  );
  final alias = itemAs?.trim();
  if (alias != null && alias.isNotEmpty) {
    scopedVariables.remove(alias);
  }
}

void applyLoopScopedVariables(
  Map<String, String> scopedVariables, {
  required String? loopItem,
  required String? loopIndex,
  String? itemField,
  String? itemAs,
}) {
  clearLoopScopedVariables(scopedVariables, itemAs: itemAs);
  if (loopIndex != null) {
    scopedVariables['loop.index'] = loopIndex;
  }
  if (loopItem == null) {
    return;
  }
  scopedVariables['loop.item'] = loopItem;
  _flattenLoopItemFields(scopedVariables, loopItem, 'loop.item');

  final field = itemField?.trim();
  final alias = itemAs?.trim();
  if (alias == null || alias.isEmpty) {
    return;
  }
  // Path empty → whole item (List strings). Path set → object field (JSON/JSONL).
  if (field == null || field.isEmpty) {
    scopedVariables[alias] = loopItem;
    return;
  }
  final value = scopedVariables['loop.item.$field'];
  if (value != null) {
    scopedVariables[alias] = value;
  }
}

void _flattenLoopItemFields(
  Map<String, String> scopedVariables,
  String rawItem,
  String prefix,
) {
  try {
    final decoded = jsonDecode(rawItem);
    if (decoded is Map) {
      _flattenMap(scopedVariables, decoded, prefix);
    }
  } catch (_) {
    // Primitive / non-JSON loop items only expose `loop.item`.
  }
}

void _flattenMap(
  Map<String, String> scopedVariables,
  Map<dynamic, dynamic> map,
  String prefix,
) {
  for (final entry in map.entries) {
    final key = entry.key?.toString();
    if (key == null || key.isEmpty) {
      continue;
    }
    final path = '$prefix.$key';
    final value = entry.value;
    if (value == null) {
      continue;
    }
    if (value is Map) {
      _flattenMap(scopedVariables, value, path);
      continue;
    }
    if (value is List) {
      scopedVariables[path] = jsonEncode(value);
      for (var i = 0; i < value.length; i++) {
        final elem = value[i];
        final indexPath = '$path.$i';
        if (elem == null) {
          continue;
        }
        if (elem is Map) {
          _flattenMap(scopedVariables, elem, indexPath);
        } else if (elem is List) {
          scopedVariables[indexPath] = jsonEncode(elem);
        } else {
          scopedVariables[indexPath] = stringifyLoopItem(elem);
        }
      }
      continue;
    }
    scopedVariables[path] = stringifyLoopItem(value);
  }
}
