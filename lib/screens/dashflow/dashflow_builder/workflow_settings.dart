import 'package:apidash/screens/dashflow/dashflow_builder/nodes.dart';
import 'package:flutter/material.dart';

class SettingsDialog extends StatefulWidget {
  final NodeData node;
  final Function(String title, String url, Map<String, String> headers) onSave;

  const SettingsDialog({super.key, required this.node, required this.onSave});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late TextEditingController _titleController;
  late TextEditingController _urlController;
  late TextEditingController _headersController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.node.title);
    _urlController = TextEditingController(text: widget.node.url);
    _headersController = TextEditingController(
      text: widget.node.headers.entries.map((e) => '${e.key}: ${e.value}').join('\n'),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _headersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Node Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(labelText: 'URL'),
          ),
          TextField(
            controller: _headersController,
            decoration: const InputDecoration(labelText: 'Headers (key: value)'),
            maxLines: 4,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final headers = _headersController.text
                .split('\n')
                .fold<Map<String, String>>({}, (map, line) {
              final parts = line.split(': ');
              if (parts.length == 2) map[parts[0]] = parts[1];
              return map;
            });
            widget.onSave(
              _titleController.text,
              _urlController.text,
              headers,
            );
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}