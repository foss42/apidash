import 'package:flutter/material.dart';
import 'package:apidash/models/api_explorer_models.dart';
import 'schema_view.dart';

class ContentTypeCard extends StatelessWidget {
  final String contentType;
  final ApiContent content;

  const ContentTypeCard({
    super.key,
    required this.contentType,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          contentType,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SchemaView(schema: content.schema),
          ),
        ],
      ),
    );
  }
}