import 'package:flutter/material.dart';
import 'package:apidash/models/models.dart';
import 'card_title.dart';
import 'card_description.dart';

class TemplateCard extends StatelessWidget {
  final ApiTemplate template;
  final VoidCallback? onTap;

  const TemplateCard({
    Key? key,
    required this.template,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      color: colorScheme.surface,
      elevation: 0.5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardTitle(
                title: template.info.title,
                icon: Icons.api, //currently no icons in the templates so icon always Icons.api
                iconColor: colorScheme.primary,
              ),
              const SizedBox(height: 8),
              CardDescription(
                description: template.info.description.isEmpty ? 'No description' : template.info.description,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}