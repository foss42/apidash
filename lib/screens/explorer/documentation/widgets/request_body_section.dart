import 'package:flutter/material.dart';
import 'package:apidash/models/api_explorer_models.dart';
import 'content_type_card.dart';

class RequestBodySection extends StatelessWidget {
  final ApiRequestBody requestBody;

  const RequestBodySection({super.key, required this.requestBody});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (requestBody.description != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              requestBody.description!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ...requestBody.content.entries.map(
          (entry) => ContentTypeCard(
            contentType: entry.key,
            content: entry.value,
          ),
        ),
      ],
    );
  }
}