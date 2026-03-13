import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'previewer_json.dart';

class OpenResponsesStructuredViewer extends StatelessWidget {
  const OpenResponsesStructuredViewer({
    super.key,
    required this.root,
  });

  final Map<String, dynamic>? root;

  @override
  Widget build(BuildContext context) {
    final output = root?['output'];

    if (output is! List) {
      return const SelectableText(
        'Invalid OpenResponses payload: "output" is not a list.',
        // Use default code style via theme; non-const TextStyle cannot be used here
      );
    }

    if (output.isEmpty) {
      return const SelectableText(
        'No items in OpenResponses "output".',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: output.length,
      itemBuilder: (context, index) {
        final item = output[index];
        if (item is! Map) {
          return _buildUnknownCard(
            context,
            'Unknown item at index $index',
            item,
          );
        }

        final map = item.cast<String, dynamic>();
        final type = map['type']?.toString() ?? 'unknown';

        switch (type) {
          case 'reasoning':
            return _buildReasoningCard(context, map);
          case 'message':
            return _buildMessageCard(context, map);
          case 'function_call':
            return _buildFunctionCallCard(context, map);
          case 'function_call_output':
            return _buildFunctionCallOutputCard(context, map);
          default:
            return _buildUnknownCard(
              context,
              'Unknown type: $type',
              map,
            );
        }
      },
    );
  }

  Widget _buildReasoningCard(BuildContext context, Map<String, dynamic> item) {
    final content = item['content']?.toString() ?? '';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SelectableText(
          content.isEmpty ? '<no reasoning>' : content,
          style: kCodeStyle,
        ),
      ),
    );
  }

  Widget _buildMessageCard(BuildContext context, Map<String, dynamic> item) {
    final role = item['role']?.toString() ?? 'assistant';
    final content = item['content']?.toString() ?? '';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              role,
              style: kCodeStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            SelectableText(
              content.isEmpty ? '<no message>' : content,
              style: kCodeStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFunctionCallCard(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    final name = item['name']?.toString() ??
        item['function']?['name']?.toString() ??
        'function_call';
    final args = item['arguments'] ?? item['function']?['arguments'];

    Widget body;
    if (args is Map || args is List) {
      body = SizedBox(
        height: 200,
        child: JsonPreviewer(code: args),
      );
    } else {
      body = SelectableText(
        args?.toString() ?? '<no arguments>',
        style: kCodeStyle,
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: kCodeStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            body,
          ],
        ),
      ),
    );
  }

  Widget _buildFunctionCallOutputCard(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    final label = item['name']?.toString() ?? 'function_call_output';
    final result = item['output'] ?? item['result'] ?? item['value'];

    Widget body;
    if (result is Map || result is List) {
      body = SizedBox(
        height: 200,
        child: JsonPreviewer(code: result),
      );
    } else {
      body = SelectableText(
        result?.toString() ?? '<no output>',
        style: kCodeStyle,
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: kCodeStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            body,
          ],
        ),
      ),
    );
  }

  Widget _buildUnknownCard(
    BuildContext context,
    String title,
    Object? value,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: kCodeStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            if (value is Map || value is List)
              SizedBox(
                height: 200,
                child: JsonPreviewer(code: value),
              )
            else
              SelectableText(
                value?.toString() ?? '<no data>',
                style: kCodeStyle,
              ),
          ],
        ),
      ),
    );
  }
}
