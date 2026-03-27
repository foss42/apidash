import 'package:apidash/widgets/error_message.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'previewer_json.dart';
import 'a2ui_viewer.dart';

class OpenResponsesStructuredViewer extends StatelessWidget {
  const OpenResponsesStructuredViewer({super.key, required this.root});

  final Map<String, dynamic>? root;

  @override
  Widget build(BuildContext context) {
    if (root == null) {
      return const ErrorMessage(message: 'Invalid OpenResponses payload.');
    }

    final output = root!['output'];

    if (output is! List) {
      return const ErrorMessage(
        message: 'Invalid OpenResponses payload: "output" is not a list.',
      );
    }

    if (output.isEmpty) {
      return const ErrorMessage(
        message: 'No OpenResponses items.',
        showIssueButton: false,
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
        final type = map['type']?.toString().toLowerCase().trim() ?? 'unknown';

        switch (type) {
          case 'reasoning':
            return _buildReasoningCard(context, map);
          case 'message':
            return _buildMessageCard(context, map);
          case 'function_call':
            return _buildFunctionCallCard(context, map);
          case 'function_call_output':
            return _buildFunctionCallOutputCard(context, map);
          case 'a2ui':
            return _buildA2uiCard(context, map);
          default:
            return _buildUnknownCard(context, 'Unsupported component', map);
        }
      },
    );
  }

  Widget _buildReasoningCard(BuildContext context, Map<String, dynamic> item) {
    final summary = _collectTypedText(item['summary'], 'summary_text');
    final content =
        _collectTypedText(item['content'], 'output_text') ??
        item['content']?.toString() ??
        '';
    final encrypted = item['encrypted_content'];

    final body = (content.isNotEmpty)
        ? SelectableText(content, style: kCodeStyle)
        : (encrypted != null
              ? SelectableText('<encrypted reasoning>', style: kCodeStyle)
              : const SizedBox());

    return _buildCard(
      title: 'Reasoning',
      children: [
        if (summary != null && summary.isNotEmpty) ...[
          const SizedBox(height: 4),
          SelectableText(summary, style: kCodeStyle),
        ],
        ...[const SizedBox(height: 6), body],
      ],
    );
  }

  Widget _buildMessageCard(BuildContext context, Map<String, dynamic> item) {
    final role = item['role']?.toString() ?? 'assistant';
    final dynamic rawContent = item['content'];
    String content = '';

    if (rawContent is String) {
      content = rawContent;
    } else if (rawContent is List) {
      final buffer = StringBuffer();
      for (final part in rawContent) {
        if (part is Map && part['type'] == 'output_text') {
          final text = part['text']?.toString();
          if (text != null && text.isNotEmpty) {
            if (buffer.isNotEmpty) {
              buffer.writeln();
            }
            buffer.write(text);
          }
        }
      }
      content = buffer.toString();
    }
    return _buildCard(
      title: role,
      children: [
        const SizedBox(height: 4),
        SelectableText(
          content.isEmpty ? '<no message>' : content,
          style: kCodeStyle,
        ),
      ],
    );
  }

  Widget _buildFunctionCallCard(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    final name =
        item['name']?.toString() ??
        item['function']?['name']?.toString() ??
        'function_call';
    final args = item['arguments'] ?? item['function']?['arguments'];
    final callId = item['call_id']?.toString() ?? item['callId']?.toString();

    final Widget argsWidget;
    if (args is Map || args is List) {
      argsWidget = SizedBox(height: 200, child: JsonPreviewer(code: args));
    } else if (args is String) {
      final parsed = _tryParseJson(args);
      argsWidget = parsed == null
          ? SelectableText(
              args.isEmpty ? '<no arguments>' : args,
              style: kCodeStyle,
            )
          : SizedBox(height: 200, child: JsonPreviewer(code: parsed));
    } else {
      argsWidget = SelectableText(
        args?.toString() ?? '<no arguments>',
        style: kCodeStyle,
      );
    }

    final children = <Widget>[
      const SizedBox(height: 4),
      if (callId != null && callId.isNotEmpty)
        SelectableText('call_id: $callId', style: kCodeStyle),
      const SizedBox(height: 4),
      argsWidget,
    ];

    return _buildCard(title: 'Tool call: $name', children: children);
  }

  Widget _buildFunctionCallOutputCard(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    final label = item['name']?.toString() ?? 'function_call_output';
    final result = item['output'] ?? item['result'] ?? item['value'];
    final callId = item['call_id']?.toString() ?? item['callId']?.toString();

    final Widget bodyWidget;
    if (result is Map || result is List) {
      bodyWidget = SizedBox(height: 200, child: JsonPreviewer(code: result));
    } else if (result is String) {
      final parsed = _tryParseJson(result);
      bodyWidget = parsed == null
          ? SelectableText(
              result.isEmpty ? '<no output>' : result,
              style: kCodeStyle,
            )
          : SizedBox(height: 200, child: JsonPreviewer(code: parsed));
    } else {
      bodyWidget = SelectableText(
        result?.toString() ?? '<no output>',
        style: kCodeStyle,
      );
    }

    final children = <Widget>[
      if (callId != null && callId.isNotEmpty)
        SelectableText('call_id: $callId', style: kCodeStyle),
      const SizedBox(height: 4),
      bodyWidget,
    ];

    return _buildCard(title: 'Tool output: $label', children: children);
  }

  String? _collectTypedText(dynamic raw, String partType) {
    if (raw is! List) return null;
    final buffer = StringBuffer();
    for (final part in raw) {
      if (part is Map && part['type'] == partType) {
        final text = part['text']?.toString();
        if (text != null && text.isNotEmpty) {
          if (buffer.isNotEmpty) buffer.writeln();
          buffer.write(text);
        }
      }
    }
    return buffer.toString();
  }

  dynamic _tryParseJson(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    if (!(trimmed.startsWith('{') || trimmed.startsWith('['))) return null;
    try {
      return jsonDecode(trimmed);
    } catch (_) {
      return null;
    }
  }

  Widget _buildA2uiCard(BuildContext context, Map<String, dynamic> item) {
    final dynamic rawSpec = item['ui'] ?? item['spec'] ?? item;
    Map<String, dynamic>? specMap;

    if (rawSpec is Map) {
      specMap = rawSpec.cast<String, dynamic>();
    } else if (rawSpec is List) {
      specMap = <String, dynamic>{'type': 'column', 'children': rawSpec};
    }
    final uiSpec =
        specMap ??
        <String, dynamic>{'type': 'text', 'text': rawSpec.toString()};
    return _buildCard(
      title: 'UI',
      children: [A2UIViewer(uiSpec: uiSpec)],
    );
  }

  Widget _buildUnknownCard(BuildContext context, String title, Object? value) {
    final display = (value is Map || value is List)
        ? value.toString()
        : (value?.toString() ?? '<no data>');
    return _buildCard(
      title: title,
      children: [SelectableText(display, style: kCodeStyle)],
    );
  }

  // Small helper to keep Card layout consistent across builders
  Widget _buildCard({required String title, required List<Widget> children}) {
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
            ...children,
          ],
        ),
      ),
    );
  }
}
