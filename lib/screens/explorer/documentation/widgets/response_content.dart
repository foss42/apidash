import 'package:flutter/material.dart';
import 'package:apidash/models/api_explorer_models.dart';
import 'code_block.dart';
import 'schema_view.dart';

class ResponseContent extends StatelessWidget {
  final String contentType;
  final ApiContent content;

  const ResponseContent({
    super.key,
    required this.contentType,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contentType,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          if (content.schema.example != null)
            CodeBlock(code: content.schema.example!),
          if (content.schema.properties != null)
            SchemaView(schema: content.schema),
        ],
      ),
    );
  }
}