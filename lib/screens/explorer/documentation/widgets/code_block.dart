import 'package:flutter/material.dart';
import 'dart:convert';

class CodeBlock extends StatelessWidget {
  final String code;

  const CodeBlock({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SelectableText(
        _formatJson(code),
        style: const TextStyle(
          fontFamily: 'RobotoMono',
          fontSize: 13,
        ),
      ),
    );
  }

  String _formatJson(String jsonString) {
    try {
      final parsed = jsonDecode(jsonString);
      return JsonEncoder.withIndent('  ').convert(parsed);
    } catch (e) {
      return jsonString;
    }
  }
}