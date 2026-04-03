import 'package:flutter/material.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:apidash/mcp_server/handlers/tool_handler.dart';

class McpAppViewer extends StatefulWidget {
  final String htmlContent;
  final String? script;

  const McpAppViewer({super.key, required this.htmlContent, this.script});

  @override
  State<McpAppViewer> createState() => _McpAppViewerState();
}

class _McpAppViewerState extends State<McpAppViewer> {
  late JavascriptRuntime _runtime;

  @override
  void initState() {
    super.initState();
    _runtime = getJavascriptRuntime();
    if (widget.script != null) {
      _runtime.evaluate(widget.script!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // In a real implementation with WebView support across platforms (macOS/Windows/Linux), 
    // a webview plugin like `webview_flutter` or `desktop_webview_window` would be used.
    // For now, this is a placeholder renderer that at least respects the structure.
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(minHeight: 200, minWidth: double.infinity),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.widgets_rounded, size: 16, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'MCP Interactive App Widget',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                widget.htmlContent.isNotEmpty 
                    ? 'Content Length: ${widget.htmlContent.length} chars (Requires WebView implementation to render interactive HTML properly)'
                    : 'No UI Content Provided',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant, 
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _runtime.dispose();
    super.dispose();
  }
}
