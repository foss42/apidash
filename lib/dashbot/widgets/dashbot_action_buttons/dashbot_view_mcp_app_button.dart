import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../ui/mcp_app_viewer.dart';
import '../dashbot_action.dart';

class DashbotViewMcpAppButton extends ConsumerWidget with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotViewMcpAppButton({super.key, required this.action});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () {
        final html = action.value?['html']?.toString() ?? '';
        final script = action.value?['script']?.toString();
        
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) => Column(
              children: [
                AppBar(
                  title: const Text('Interactive MCP App'),
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Expanded(
                  child: McpAppViewer(
                    htmlContent: html,
                    script: script,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      icon: const Icon(Icons.open_in_new, size: 16),
      label: const Text('View App'),
    );
  }
}
