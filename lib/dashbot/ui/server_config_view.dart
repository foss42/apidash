import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import '../services/mcp_service.dart';
import 'package:uuid/uuid.dart';

/// Server Configuration View - Form to add MCP servers
class ServerConfigView extends ConsumerStatefulWidget {
  const ServerConfigView({super.key});

  @override
  ConsumerState<ServerConfigView> createState() => _ServerConfigViewState();
}

class _ServerConfigViewState extends ConsumerState<ServerConfigView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _commandController = TextEditingController();
  final _argsController = TextEditingController();
  final _urlController = TextEditingController();
  TransportType _selectedTransport = TransportType.stdio;

  @override
  void dispose() {
    _nameController.dispose();
    _commandController.dispose();
    _argsController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add MCP Server'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTransportSelector(),
            const SizedBox(height: 16),
            _buildNameField(),
            const SizedBox(height: 16),
            if (_selectedTransport == TransportType.stdio) ...[
              _buildCommandField(),
              const SizedBox(height: 16),
              _buildArgsField(),
            ] else ...[
              _buildUrlField(),
            ],
            const SizedBox(height: 24),
            _buildSubmitButton(),
            const SizedBox(height: 16),
            _buildExampleServers(),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportSelector() {
    return SegmentedButton<TransportType>(
      segments: const [
        ButtonSegment(
          value: TransportType.stdio,
          label: Text('STDIO'),
          icon: Icon(Icons.terminal),
        ),
        ButtonSegment(
          value: TransportType.sse,
          label: Text('SSE'),
          icon: Icon(Icons.cloud),
        ),
      ],
      selected: {_selectedTransport},
      onSelectionChanged: (Set<TransportType> selected) {
        setState(() => _selectedTransport = selected.first);
      },
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Server Name',
        hintText: 'e.g., My Custom Server',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a server name';
        }
        return null;
      },
    );
  }

  Widget _buildCommandField() {
    return TextFormField(
      controller: _commandController,
      decoration: InputDecoration(
        labelText: 'Command',
        hintText: Platform.isWindows ? 'python' : 'python3',
        helperText: 'The executable to run (e.g., python, node, dart)',
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (_selectedTransport == TransportType.stdio &&
            (value == null || value.trim().isEmpty)) {
          return 'Please enter a command';
        }
        return null;
      },
    );
  }

  Widget _buildArgsField() {
    return TextFormField(
      controller: _argsController,
      decoration: const InputDecoration(
        labelText: 'Arguments',
        hintText: '-m mcp_server',
        helperText: 'Space-separated arguments for the command',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildUrlField() {
    return TextFormField(
      controller: _urlController,
      decoration: const InputDecoration(
        labelText: 'Server URL',
        hintText: 'https://example.com/sse',
        helperText: 'The SSE endpoint URL',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (_selectedTransport == TransportType.sse &&
            (value == null || value.trim().isEmpty)) {
          return 'Please enter a URL';
        }
        if (value != null && value.trim().isNotEmpty) {
          try {
            Uri.parse(value.trim());
          } catch (e) {
            return 'Please enter a valid URL';
          }
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton.icon(
      onPressed: _submitForm,
      icon: const Icon(Icons.add),
      label: const Text('Add Server'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildExampleServers() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Example Servers',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _ExampleServerTile(
              name: 'Filesystem Server',
              transport: TransportType.stdio,
              command: 'npx',
              args: '-y @modelcontextprotocol/server-filesystem',
              onUse: () => _fillExample(
                name: 'Filesystem Server',
                command: 'npx',
                args: '-y @modelcontextprotocol/server-filesystem',
              ),
            ),
            const Divider(),
            _ExampleServerTile(
              name: 'GitHub Server',
              transport: TransportType.stdio,
              command: 'npx',
              args: '-y @modelcontextprotocol/server-github',
              onUse: () => _fillExample(
                name: 'GitHub Server',
                command: 'npx',
                args: '-y @modelcontextprotocol/server-github',
              ),
            ),
            const Divider(),
            _ExampleServerTile(
              name: 'Brave Search Server',
              transport: TransportType.stdio,
              command: 'npx',
              args: '-y @modelcontextprotocol/server-brave-search',
              onUse: () => _fillExample(
                name: 'Brave Search Server',
                command: 'npx',
                args: '-y @modelcontextprotocol/server-brave-search',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fillExample({
    required String name,
    required String command,
    required String args,
  }) {
    setState(() {
      _selectedTransport = TransportType.stdio;
      _nameController.text = name;
      _commandController.text = command;
      _argsController.text = args;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final id = const Uuid().v4();
    final notifier = ref.read(mcpConnectionsProvider.notifier);

    try {
      if (_selectedTransport == TransportType.stdio) {
        final command = _commandController.text.trim();
        final args = _argsController.text
            .trim()
            .split(RegExp(r'\s+'))
            .where((arg) => arg.isNotEmpty)
            .toList();

        await notifier.addStdioServer(id, name, command, args);
      } else {
        final url = _urlController.text.trim();
        await notifier.addSseServer(id, name, url);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server "$name" added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add server: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

/// Widget for displaying an example server tile with quick-fill option
class _ExampleServerTile extends StatelessWidget {
  const _ExampleServerTile({
    required this.name,
    required this.transport,
    required this.command,
    required this.args,
    required this.onUse,
  });

  final String name;
  final TransportType transport;
  final String command;
  final String args;
  final VoidCallback onUse;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onUse,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              transport == TransportType.stdio ? Icons.terminal : Icons.cloud,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    '$command $args',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: onUse,
              icon: const Icon(Icons.play_arrow, size: 16),
              label: const Text('Use'),
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
      ),
    );
  }
}