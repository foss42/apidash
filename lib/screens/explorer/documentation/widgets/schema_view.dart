import 'package:flutter/material.dart';
import 'package:apidash/models/api_explorer_models.dart';
import 'property_chip.dart';
import 'code_block.dart';
import 'properties_table.dart';

class SchemaView extends StatelessWidget {
  final ApiSchema schema;

  const SchemaView({super.key, required this.schema});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (schema.description != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              schema.description!,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (schema.type != null)
              PropertyChip(label: 'Type: ${schema.type}'),
            if (schema.format != null)
              PropertyChip(label: 'Format: ${schema.format}'),
          ],
        ),
        if (schema.example != null) ...[
          const SizedBox(height: 16),
          CodeBlock(code: schema.example!),
        ],
        if (schema.properties != null) ...[
          const SizedBox(height: 16),
          Text(
            'Properties',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          PropertiesTable(properties: schema.properties!),
        ],
      ],
    );
  }
}