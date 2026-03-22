import 'package:flutter/material.dart';

class SimpleText extends StatelessWidget {
  const SimpleText({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
  });

  final String? title;
  final String? subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 36, color: theme.colorScheme.outline),
            const SizedBox(height: 8),
          ],
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
          ],
          if (subtitle != null)
            Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
