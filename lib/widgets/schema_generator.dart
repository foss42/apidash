import 'dart:convert';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SchemaGenerator extends StatelessWidget {
  const SchemaGenerator({
    super.key,
    required this.jsonResponse,
  });

  final String jsonResponse;

  @override
  Widget build(BuildContext context) {
    final schema = _generateSchema();
    
    if (schema == null) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: kP12,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surfaceContainerLow,
            colorScheme.surface,
          ],
        ),
        border: Border.all(
          color: colorScheme.tertiary.withOpacity(0.3),
          width: 1.5,
        ),
        borderRadius: kBorderRadius12,
        boxShadow: [
          BoxShadow(
            color: colorScheme.tertiary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: kBorderRadius8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schema,
                      size: 16,
                      color: colorScheme.onTertiaryContainer,
                    ),
                    kHSpacer5,
                    Text(
                      'SCHEMA',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onTertiaryContainer,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: schema));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Schema copied to clipboard'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: colorScheme.tertiary,
                    ),
                  );
                },
                tooltip: 'Copy Schema',
                color: colorScheme.tertiary,
              ),
            ],
          ),
          kVSpacer10,
          Container(
            constraints: const BoxConstraints(maxHeight: 400),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: kBorderRadius8,
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.3),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: SelectableText(
                schema,
                style: kCodeStyle.copyWith(
                  fontSize: 12,
                  color: colorScheme.onSurface,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
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
