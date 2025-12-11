import 'dart:convert';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SchemaDialog extends StatelessWidget {
  const SchemaDialog({
    super.key,
    required this.jsonResponse,
  });

  final String jsonResponse;

  @override
  Widget build(BuildContext context) {
    final schema = _generateSchema();
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: colorScheme.surface,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: kP20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schema,
                  color: colorScheme.primary,
                  size: 24,
                ),
                kHSpacer10,
                Text(
                  'Generated Schema',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Close',
                ),
              ],
            ),
            kVSpacer10,
            const Divider(),
            kVSpacer10,
            if (schema != null) ...[
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: schema));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Schema copied to clipboard'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: colorScheme.primary,
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy Schema'),
                  ),
                ],
              ),
              kVSpacer10,
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: kBorderRadius12,
                    border: Border.all(
                      color: colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      schema,
                      style: kCodeStyle.copyWith(
                        fontSize: 14,
                        color: colorScheme.onSurface,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              ),
            ] else ...[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: colorScheme.error,
                      ),
                      kVSpacer10,
                      Text(
                        'Failed to generate schema',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      kVSpacer5,
                      Text(
                        'The response is not valid JSON',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String? _generateSchema() {
    try {
      final json = jsonDecode(jsonResponse);
      return _buildSchemaString(json, 0);
    } catch (e) {
      return null;
    }
  }

  String _buildSchemaString(dynamic data, int indent) {
    final indentStr = '  ' * indent;
    final nextIndentStr = '  ' * (indent + 1);

    if (data is Map) {
      if (data.isEmpty) return '{}';

      final buffer = StringBuffer('{\n');
      final entries = data.entries.toList();

      for (var i = 0; i < entries.length; i++) {
        final entry = entries[i];
        final isLast = i == entries.length - 1;
        final valueType = _getTypeString(entry.value);

        buffer.write('$nextIndentStr"${entry.key}": $valueType');
        if (!isLast) buffer.write(',');
        buffer.write('\n');
      }

      buffer.write('$indentStr}');
      return buffer.toString();
    } else if (data is List && data.isNotEmpty) {
      final itemType = _getTypeString(data.first);
      return '[$itemType]';
    } else {
      return _getTypeString(data);
    }
  }

  String _getTypeString(dynamic value) {
    if (value == null) {
      return 'null';
    } else if (value is bool) {
      return 'boolean';
    } else if (value is int) {
      return 'number';
    } else if (value is double) {
      return 'number';
    } else if (value is String) {
      return 'string';
    } else if (value is List) {
      if (value.isEmpty) {
        return '[]';
      }
      final itemType = _getTypeString(value.first);
      return '[$itemType]';
    } else if (value is Map) {
      if (value.isEmpty) return '{}';

      final buffer = StringBuffer('{\n');
      final entries = value.entries.toList();

      for (var i = 0; i < entries.length; i++) {
        final entry = entries[i];
        final isLast = i == entries.length - 1;
        final valueType = _getTypeString(entry.value);

        buffer.write('    "${entry.key}": $valueType');
        if (!isLast) buffer.write(',');
        buffer.write('\n');
      }

      buffer.write('  }');
      return buffer.toString();
    }
    return 'any';
  }
}
