import 'dart:convert';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class A2UIRenderer extends StatelessWidget {
  const A2UIRenderer({
    super.key,
    required this.components,
    required this.dataModel,
  });

  final Map<String, dynamic> components;
  final Map<String, dynamic> dataModel;

  @override
  Widget build(BuildContext context) {
    if (!components.containsKey('root')) {
      return const _A2UIError(message: 'No root component');
    }
    return _renderComponent(context, 'root');
  }

  Widget _renderComponent(BuildContext context, String id) {
    final node = components[id];
    if (node is! Map<String, dynamic>) return const SizedBox.shrink();

    return switch (node['component'] as String? ?? '') {
      'Text' => _buildText(context, node),
      'Button' => _buildButton(context, node),
      'Card' => _buildCard(context, node),
      'Row' => _buildRow(context, node),
      'Column' => _buildColumn(context, node),
      'Image' => _buildImage(node),
      'Icon' => _buildIcon(node),
      'Divider' => const Divider(),
      'List' => _buildList(context, node),
      'Tabs' => _buildTabs(context, node),
      final t => _A2UIError(message: 'Unknown: $t'),
    };
  }

  String _resolve(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is Map) {
      final path = value['path'] as String?;
      if (path != null) return _dataAt(path)?.toString() ?? '';
      return value['literalString'] as String? ?? '';
    }
    return value.toString();
  }

  dynamic _dataAt(String path) {
    if (!path.startsWith('/')) return null;
    final segments = path.substring(1).split('/');
    dynamic cursor = dataModel;
    for (final seg in segments) {
      if (cursor is Map) {
        cursor = cursor[seg];
      } else if (cursor is List) {
        final i = int.tryParse(seg);
        cursor = (i != null && i < cursor.length) ? cursor[i] : null;
      } else {
        return null;
      }
    }
    return cursor;
  }

  List<String> _children(dynamic raw) =>
      raw is List ? raw.cast<String>() : [];

  Widget _buildText(BuildContext context, Map<String, dynamic> n) {
    final style = switch (n['variant'] as String? ?? 'body') {
      'h1' => Theme.of(context).textTheme.headlineSmall,
      'h2' => Theme.of(context).textTheme.titleLarge,
      'h3' => Theme.of(context).textTheme.titleMedium,
      'caption' => Theme.of(context).textTheme.bodySmall,
      _ => Theme.of(context).textTheme.bodyMedium,
    };
    return SelectableText(_resolve(n['text']), style: style);
  }

  Widget _buildButton(BuildContext context, Map<String, dynamic> n) {
    final label = _resolve(n['text']);
    return switch (n['variant'] as String? ?? 'text') {
      'primary' => FilledButton(onPressed: () {}, child: Text(label)),
      'outlined' => OutlinedButton(onPressed: () {}, child: Text(label)),
      _ => TextButton(onPressed: () {}, child: Text(label)),
    };
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> n) => Card(
        child: Padding(
          padding: kP8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _children(n['children'])
                .map((id) => _renderComponent(context, id))
                .toList(),
          ),
        ),
      );

  Widget _buildRow(BuildContext context, Map<String, dynamic> n) => Row(
        mainAxisAlignment: switch (n['justify'] as String? ?? 'start') {
          'center' => MainAxisAlignment.center,
          'end' => MainAxisAlignment.end,
          'spaceBetween' => MainAxisAlignment.spaceBetween,
          'spaceAround' => MainAxisAlignment.spaceAround,
          _ => MainAxisAlignment.start,
        },
        children: _children(n['children'])
            .map((id) => _renderComponent(context, id))
            .toList(),
      );

  Widget _buildColumn(BuildContext context, Map<String, dynamic> n) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _children(n['children'])
            .map((id) => _renderComponent(context, id))
            .toList(),
      );

  Widget _buildImage(Map<String, dynamic> n) {
    final src = _resolve(n['src'] ?? n['url'] ?? '');
    if (src.isEmpty) return const Icon(Icons.broken_image_rounded);
    return Image.network(
      src,
      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_rounded),
    );
  }

  Widget _buildIcon(Map<String, dynamic> n) {
    final name = n['name'] as String? ?? '';
    return Icon(_iconFor(name), size: 24);
  }

  Widget _buildList(BuildContext context, Map<String, dynamic> n) =>
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _children(n['children']).length,
        itemBuilder: (_, i) =>
            _renderComponent(context, _children(n['children'])[i]),
      );

  Widget _buildTabs(BuildContext context, Map<String, dynamic> n) {
    final ids = _children(n['children']);
    if (ids.isEmpty) return const SizedBox.shrink();
    return DefaultTabController(
      length: ids.length,
      child: Column(children: [
        TabBar(tabs: ids.map((id) => Tab(text: id)).toList()),
        SizedBox(
          height: 200,
          child: TabBarView(
            children: ids.map((id) => _renderComponent(context, id)).toList(),
          ),
        ),
      ]),
    );
  }

  IconData _iconFor(String name) => switch (name.toLowerCase()) {
        'home' => Icons.home_rounded,
        'search' => Icons.search_rounded,
        'settings' => Icons.settings_rounded,
        'person' => Icons.person_rounded,
        'check' => Icons.check_rounded,
        'close' => Icons.close_rounded,
        'add' => Icons.add_rounded,
        'edit' => Icons.edit_rounded,
        'delete' => Icons.delete_rounded,
        'info' => Icons.info_rounded,
        'warning' => Icons.warning_rounded,
        'error' => Icons.error_rounded,
        _ => Icons.widgets_rounded,
      };
}

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

  static ({Map<String, dynamic> components, Map<String, dynamic> dataModel})?
      parse(String body) {
    final Map<String, dynamic> components = {};
    final Map<String, dynamic> dataModel = {};

    for (final line in body.split('\n')) {
      final t = line.trim();
      if (t.isEmpty) continue;
      try {
        final json = jsonDecode(t);
        if (json is! Map<String, dynamic>) continue;

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
        : (components: components, dataModel: dataModel);
  }
}

class _A2UIError extends StatelessWidget {
  const _A2UIError({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Padding(
        padding: kP8,
        child: Text(
          message,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      );
}
