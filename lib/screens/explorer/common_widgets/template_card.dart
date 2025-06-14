import 'package:flutter/material.dart';
import 'package:apidash/models/models.dart';
import 'card_title.dart';
import 'card_description.dart';
import 'chip.dart';

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

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 384),
      child: Card(
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        color: colorScheme.surface,
        elevation: 0.8,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 600 ? 16 : 12,
              vertical: MediaQuery.of(context).size.width > 600 ? 16 : 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: CardTitle(
                    title: template.info.title,
                    icon: Icons.api,  // //currently no icons in the templates so icon always Icons.api
                    iconColor: colorScheme.primary,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: CardDescription(
                    description: template.info.description.isEmpty
                        ? 'No description'
                        : template.info.description,
                    maxLines: 5,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: template.info.tags
                          .take(5)
                          .map((tag) => CustomChip.tag(tag, colorScheme))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}