import 'dart:convert';

/// Parses Agent-to-UI (A2UI) JSONL payloads into components and data model.
///
/// The A2UI protocol streams newline-delimited JSON events:
///   createSurface       — surface metadata (id, title, layout)
///   updateComponents    — component tree nodes
///   updateDataModel     — data bindings
///   closeSurface        — surface teardown (ignored, no state needed)
class A2UIParser {
  static bool isA2UIPayload(String body) {
    for (final line in body.split('\n')) {
      final t = line.trim();
      if (t.isEmpty) continue;
      try {
        final json = jsonDecode(t);
        if (json is Map &&
            (json.containsKey('createSurface') ||
                json.containsKey('updateComponents'))) {
          return true;
        }
      } catch (_) {}
    }
    return false;
  }

  static ({
    Map<String, dynamic> components,
    Map<String, dynamic> dataModel,
    String? surfaceTitle,
  })? parse(String body) {
    final Map<String, dynamic> components = {};
    final Map<String, dynamic> dataModel = {};
    String? surfaceTitle;

    for (final line in body.split('\n')) {
      final t = line.trim();
      if (t.isEmpty) continue;
      try {
        final json = jsonDecode(t);
        if (json is! Map<String, dynamic>) continue;

        if (json.containsKey('createSurface')) {
          final msg = json['createSurface'] as Map<String, dynamic>?;
          surfaceTitle = msg?['title'] as String?;
        }

        if (json.containsKey('updateComponents')) {
          final msg = json['updateComponents'] as Map<String, dynamic>?;
          for (final c in (msg?['components'] as List? ?? [])) {
            final comp = c as Map<String, dynamic>;
            final id = comp['id'] as String?;
            if (id != null) components[id] = comp;
          }
        }

        if (json.containsKey('updateDataModel')) {
          final msg = json['updateDataModel'] as Map<String, dynamic>?;
          final path = msg?['path'] as String?;
          if (path != null && path.startsWith('/')) {
            dataModel[path.substring(1)] = msg?['value'];
          }
        }
      } catch (_) {}
    }

    return components.isEmpty
        ? null
        : (
            components: components,
            dataModel: dataModel,
            surfaceTitle: surfaceTitle,
          );
  }
}
