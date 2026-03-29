import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class A2UIRenderer extends StatefulWidget {
  const A2UIRenderer({
    super.key,
    required this.components,
    required this.dataModel,
  });

  final Map<String, dynamic> components;
  final Map<String, dynamic> dataModel;

  @override
  State<A2UIRenderer> createState() => _A2UIRendererState();
}

class _A2UIRendererState extends State<A2UIRenderer> {
  final Map<String, dynamic> _localState = {};

  @override
  Widget build(BuildContext context) {
    if (!widget.components.containsKey('root')) {
      return const _A2UIError(message: 'No root component');
    }
    return _renderComponent(context, 'root');
  }

  Widget _renderComponent(BuildContext context, String id) {
    final node = widget.components[id];
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
      'TextField' => _buildTextField(context, node),
      'Checkbox' => _buildCheckbox(context, node),
      'Switch' => _buildSwitch(context, node),
      'Progress' => _buildProgress(context, node),
      'Chip' => _buildChip(context, node),
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
    dynamic cursor = widget.dataModel;
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
    final action = n['action'] as String? ?? label;
    void onPressed() {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Action: $action'),
            duration: const Duration(seconds: 1),
          ),
        );
    }

    return switch (n['variant'] as String? ?? 'text') {
      'primary' => FilledButton(onPressed: onPressed, child: Text(label)),
      'outlined' => OutlinedButton(onPressed: onPressed, child: Text(label)),
      _ => TextButton(onPressed: onPressed, child: Text(label)),
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

  Widget _buildTextField(BuildContext context, Map<String, dynamic> n) {
    final id = n['id'] as String? ?? '';
    final label = _resolve(n['label'] ?? n['text'] ?? '');
    final hint = _resolve(n['hint'] ?? '');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: TextEditingController(
          text: _localState[id] as String? ?? '',
        ),
        decoration: InputDecoration(
          labelText: label.isNotEmpty ? label : null,
          hintText: hint.isNotEmpty ? hint : null,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        onChanged: (v) => _localState[id] = v,
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context, Map<String, dynamic> n) {
    final id = n['id'] as String? ?? '';
    final label = _resolve(n['label'] ?? n['text'] ?? '');
    final checked = _localState[id] as bool? ?? (n['checked'] == true);
    return CheckboxListTile(
      title: Text(label),
      value: checked,
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      onChanged: (v) => setState(() => _localState[id] = v ?? false),
    );
  }

  Widget _buildSwitch(BuildContext context, Map<String, dynamic> n) {
    final id = n['id'] as String? ?? '';
    final label = _resolve(n['label'] ?? n['text'] ?? '');
    final on = _localState[id] as bool? ?? (n['value'] == true);
    return SwitchListTile(
      title: Text(label),
      value: on,
      dense: true,
      contentPadding: EdgeInsets.zero,
      onChanged: (v) => setState(() => _localState[id] = v),
    );
  }

  Widget _buildProgress(BuildContext context, Map<String, dynamic> n) {
    final value = (n['value'] as num?)?.toDouble();
    final label = _resolve(n['label'] ?? '');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
        value != null
            ? LinearProgressIndicator(value: value.clamp(0.0, 1.0))
            : const LinearProgressIndicator(),
      ],
    );
  }

  Widget _buildChip(BuildContext context, Map<String, dynamic> n) {
    final label = _resolve(n['label'] ?? n['text'] ?? '');
    return Chip(label: Text(label));
  }

  Widget _buildTabs(BuildContext context, Map<String, dynamic> n) {
    final ids = _children(n['children']);
    if (ids.isEmpty) return const SizedBox.shrink();

    final labels = n['labels'] is List
        ? (n['labels'] as List).cast<String>()
        : ids;

    return DefaultTabController(
      length: ids.length,
      child: Column(children: [
        TabBar(
          tabs: labels.map((l) => Tab(text: l)).toList(),
        ),
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
