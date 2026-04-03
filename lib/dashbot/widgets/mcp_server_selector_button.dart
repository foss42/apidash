import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import '../services/mcp_service.dart';
import '../providers/providers.dart';
import '../routes/dashbot_routes.dart';

class McpServerSelectorButton extends ConsumerWidget {
  const McpServerSelectorButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connections = ref.watch(mcpConnectionsProvider);
    final connectedCount = connections.values.where((c) => c.client != null).length;
    final totalCount = connections.length;

    return ElevatedButton.icon(
      onPressed: () {
        ref.read(dashbotActiveRouteProvider.notifier).setRoute(DashbotRoutes.mcpInspector);
      },
      icon: Icon(
        Icons.layers,
        size: 18,
        color: connectedCount > 0 
            ? Theme.of(context).colorScheme.primary 
            : Theme.of(context).colorScheme.outline,
      ),
      label: Text(
        totalCount == 0 ? 'MCP' : 'MCP ($connectedCount/$totalCount)',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}
