import 'package:apidash_design_system/ui/design_system_provider.dart';
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
    final ds = DesignSystemProvider.of(context);
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 36*ds.scaleFactor, color: theme.colorScheme.outline),
            SizedBox(height: 8*ds.scaleFactor),
          ],
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6*ds.scaleFactor),
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
