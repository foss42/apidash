import 'package:flutter/material.dart';
import 'card_title.dart';
import 'card_description.dart';


class TemplateCard extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final IconData? icon;
  final VoidCallback? onTap;

  const TemplateCard({
    Key? key,
    required this.id,
    required this.name,
    required this.description,
    this.icon,
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
                title: name,
                icon: icon ?? Icons.api, //currently no icons in the templates so icon always Icons.api
                iconColor: colorScheme.primary,
              ),
              const SizedBox(height: 8),
              CardDescription(
                description: description.isEmpty ? 'No description' : description,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}