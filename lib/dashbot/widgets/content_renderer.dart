// lib/dashbot/widgets/content_renderer.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/monokai-sublime.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

Widget renderContent(BuildContext context, String text) {
  if (text.isEmpty) {
    return const Text("No content to display.");
  }

  final codeBlockPattern = RegExp(r'```(\w+)?\n([\s\S]*?)```', multiLine: true);
  final matches = codeBlockPattern.allMatches(text);

  if (matches.isEmpty) {
    return _renderMarkdown(context, text);
  }

  List<Widget> children = [];
  int lastEnd = 0;

  for (var match in matches) {
    if (match.start > lastEnd) {
      children
          .add(_renderMarkdown(context, text.substring(lastEnd, match.start)));
    }

    final language = match.group(1) ?? 'text';
    final code = match.group(2)!.trim();
    children.add(_renderCodeBlock(context, language, code));

    lastEnd = match.end;
  }

  if (lastEnd < text.length) {
    children.add(_renderMarkdown(context, text.substring(lastEnd)));
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: children,
  );
}

Widget _renderMarkdown(BuildContext context, String markdown) {
  return MarkdownBody(
    data: markdown,
    selectable: true,
    styleSheet: MarkdownStyleSheet(
      p: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    ),
  );
}

Widget _renderCodeBlock(BuildContext context, String language, String code) {
  if (language == 'json') {
    try {
      final prettyJson =
          const JsonEncoder.withIndent('  ').convert(jsonDecode(code));
      return Container(
        padding: const EdgeInsets.all(8),
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        child: SelectableText(
          prettyJson,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
        ),
      );
    } catch (e) {
      return _renderFallbackCode(context, code);
    }
  } else {
    try {
      return Container(
        padding: const EdgeInsets.all(8),
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        child: HighlightView(
          code,
          language: language,
          theme: monokaiSublimeTheme,
          textStyle: const TextStyle(fontFamily: 'monospace', fontSize: 12),
        ),
      );
    } catch (e) {
      return _renderFallbackCode(context, code);
    }
  }
}

Widget _renderFallbackCode(BuildContext context, String code) {
  return Container(
    padding: const EdgeInsets.all(8),
    color: Theme.of(context).colorScheme.surfaceContainerLow,
    child: SelectableText(
      code,
      style: const TextStyle(
          fontFamily: 'monospace', fontSize: 12, color: Colors.red),
    ),
  );
}
