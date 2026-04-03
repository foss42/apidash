import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mcp_dart/mcp_dart.dart';
import '../services/mcp_service.dart';
import '../services/mcp_host_service.dart';
import '../routes/dashbot_routes.dart';

/// MCP Inspector - Dashboard for managing MCP servers and their capabilities.
/// Shows server health, tools, resources, prompts, and roots.
class McpInspector extends ConsumerStatefulWidget {
  const McpInspector({super.key});

  @override
  ConsumerState<McpInspector> createState() => _McpInspectorState();
}

class _McpInspectorState extends ConsumerState<McpInspector>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connections = ref.watch(mcpConnectionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MCP Inspector'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Server',
            onPressed: () => _showAddServerDialog(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Servers'),
            Tab(text: 'Tools'),
            Tab(text: 'Resources'),
            Tab(text: 'Prompts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ServersTab(connections: connections),
          const _ToolsTab(),
          const _ResourcesTab(),
          const _PromptsTab(),
        ],
      ),
    );
  }

  void _showAddServerDialog(BuildContext context) {
    Navigator.of(context).pushNamed(DashbotRoutes.mcpAddServer);
  }
}

/// Servers Tab - Shows all connected MCP servers with health indicators
class _ServersTab extends ConsumerWidget {
  const _ServersTab({required this.connections});

  final Map<String, McpServerConnection> connections;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (connections.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dns, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text('No MCP servers configured', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Add a server to get started', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: connections.length,
      itemBuilder: (context, index) {
        final conn = connections.values.elementAt(index);
        return _ServerCard(
          connection: conn,
          onToggle: (enabled) {
            ref.read(mcpConnectionsProvider.notifier).toggleServer(conn.id, enabled);
          },
          onRemove: () {
            _showRemoveConfirmDialog(context, ref, conn.id);
          },
        );
      },
    );
  }

  void _showRemoveConfirmDialog(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Server'),
        content: const Text('Are you sure you want to remove this MCP server?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(mcpConnectionsProvider.notifier).removeServer(id);
              Navigator.of(context).pop();
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

/// Individual server card with health indicator and toggle
class _ServerCard extends StatelessWidget {
  const _ServerCard({
    required this.connection,
    required this.onToggle,
    required this.onRemove,
  });

  final McpServerConnection connection;
  final ValueChanged<bool> onToggle;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final isConnected = connection.client != null;
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isConnected ? Icons.check_circle : Icons.error,
                  color: isConnected ? Colors.green : theme.colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        connection.name,
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        _getTransportLabel(connection),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: connection.isEnabled,
                  onChanged: onToggle,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onRemove,
                  color: theme.colorScheme.error,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip(context, connection.transportType.name, Icons.cable),
                const SizedBox(width: 8),
                if (connection.transportType == TransportType.stdio) ...[
                  _buildInfoChip(context, connection.commandOrUrl, Icons.terminal),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTransportLabel(McpServerConnection conn) {
    if (conn.transportType == TransportType.stdio) {
      return 'STDIO: ${conn.commandOrUrl} ${conn.args.join(' ')}';
    }
    return 'SSE: ${conn.commandOrUrl}';
  }

  Widget _buildInfoChip(BuildContext context, String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(fontSize: 11),
        overflow: TextOverflow.ellipsis,
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Tools Tab - Shows all available tools from connected servers
class _ToolsTab extends ConsumerStatefulWidget {
  const _ToolsTab();

  @override
  ConsumerState<_ToolsTab> createState() => _ToolsTabState();
}

class _ToolsTabState extends ConsumerState<_ToolsTab> {
  List<Tool>? _tools;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTools();
  }

  Future<void> _loadTools() async {
    setState(() => _isLoading = true);
    try {
      final mcpService = ref.read(mcpHostServiceProvider);
      await mcpService.connect();
      final tools = await mcpService.discoverTools();
      if (mounted) {
        setState(() {
          _tools = tools;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_tools == null || _tools!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.build_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text('No tools available', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Connect to an MCP server to see tools', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadTools,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTools,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tools!.length,
        itemBuilder: (context, index) {
          final tool = _tools![index];
          return _ToolCard(tool: tool);
        },
      ),
    );
  }
}

/// Individual tool card
class _ToolCard extends StatelessWidget {
  const _ToolCard({required this.tool});

  final Tool tool;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: const Icon(Icons.extension),
        title: Text(tool.name),
        subtitle: (tool.description?.isNotEmpty ?? false) ? Text(tool.description!) : null,
        children: [
          if (tool.inputSchema.toJson().isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Input Schema:', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  _buildSchemaDisplay(context, tool.inputSchema.toJson()),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSchemaDisplay(BuildContext context, Map<String, dynamic> schema) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _formatSchema(schema),
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  String _formatSchema(Map<String, dynamic> schema, [int indent = 0]) {
    final prefix = '  ' * indent;
    final buffer = StringBuffer();

    if (schema.containsKey('type')) {
      buffer.writeln('${prefix}type: ${schema['type']}');
    }
    if (schema.containsKey('properties')) {
      final props = schema['properties'] as Map?;
      if (props != null && props.isNotEmpty) {
        buffer.writeln('${prefix}properties:');
        props.forEach((key, value) {
          buffer.writeln('$prefix  $key:');
          if (value is Map) {
            buffer.write(_formatSchema(value as Map<String, dynamic>, indent + 2));
          }
        });
      }
    }
    if (schema.containsKey('required')) {
      final required = schema['required'] as List?;
      if (required != null && required.isNotEmpty) {
        buffer.writeln('${prefix}required: ${required.join(', ')}');
      }
    }

    return buffer.toString();
  }
}

/// Resources Tab - Shows all available resources from connected servers
class _ResourcesTab extends ConsumerStatefulWidget {
  const _ResourcesTab();

  @override
  ConsumerState<_ResourcesTab> createState() => _ResourcesTabState();
}

class _ResourcesTabState extends ConsumerState<_ResourcesTab> {
  List<Resource>? _resources;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadResources();
  }

  Future<void> _loadResources() async {
    setState(() => _isLoading = true);
    try {
      final mcpService = ref.read(mcpHostServiceProvider);
      await mcpService.connect();
      final resources = await mcpService.discoverResources();
      if (mounted) {
        setState(() {
          _resources = resources;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_resources == null || _resources!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text('No resources available', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Connect to an MCP server to see resources', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadResources,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadResources,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _resources!.length,
        itemBuilder: (context, index) {
          final resource = _resources![index];
          return _ResourceCard(resource: resource);
        },
      ),
    );
  }
}

/// Individual resource card
class _ResourceCard extends StatelessWidget {
  const _ResourceCard({required this.resource});

  final Resource resource;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(_getResourceIcon(resource)),
        title: Text(resource.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (resource.description?.isNotEmpty ?? false) Text(resource.description!),
            Text(
              resource.uri,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.visibility),
          onPressed: () => _showResourceContent(context, resource),
          tooltip: 'View Content',
        ),
      ),
    );
  }

  IconData _getResourceIcon(Resource resource) {
    if (resource.uri.endsWith('.json')) return Icons.description;
    if (resource.uri.endsWith('.png') || resource.uri.endsWith('.jpg')) return Icons.image;
    if (resource.uri.endsWith('.html')) return Icons.code;
    return Icons.insert_drive_file;
  }

  void _showResourceContent(BuildContext context, Resource resource) {
    // TODO: Implement resource viewer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing resource: ${resource.uri}')),
    );
  }
}

/// Prompts Tab - Shows all available prompts from connected servers
class _PromptsTab extends ConsumerStatefulWidget {
  const _PromptsTab();

  @override
  ConsumerState<_PromptsTab> createState() => _PromptsTabState();
}

class _PromptsTabState extends ConsumerState<_PromptsTab> {
  List<Prompt>? _prompts;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPrompts();
  }

  Future<void> _loadPrompts() async {
    setState(() => _isLoading = true);
    try {
      final mcpService = ref.read(mcpHostServiceProvider);
      await mcpService.connect();
      final prompts = await mcpService.discoverPrompts();
      if (mounted) {
        setState(() {
          _prompts = prompts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_prompts == null || _prompts!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text('No prompts available', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Connect to an MCP server to see prompts', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadPrompts,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPrompts,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _prompts!.length,
        itemBuilder: (context, index) {
          final prompt = _prompts![index];
          return _PromptCard(prompt: prompt);
        },
      ),
    );
  }
}

/// Individual prompt card
class _PromptCard extends StatelessWidget {
  const _PromptCard({required this.prompt});

  final Prompt prompt;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: const Icon(Icons.chat_bubble_outline),
        title: Text(prompt.name),
        subtitle: (prompt.description?.isNotEmpty ?? false) ? Text(prompt.description!) : null,
        children: [
          if (prompt.arguments != null && prompt.arguments!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Arguments:', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  ...prompt.arguments!.map((arg) => _PromptArgumentWidget(argument: arg)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget to display a single prompt argument
class _PromptArgumentWidget extends StatelessWidget {
  const _PromptArgumentWidget({required this.argument});

  final PromptArgument argument;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              argument.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (argument.description?.isNotEmpty ?? false)
                  Text(argument.description!, style: Theme.of(context).textTheme.bodySmall),
                if (argument.required ?? false)
                  Text(
                    'Required',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}