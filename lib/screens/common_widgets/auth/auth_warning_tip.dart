import 'package:flutter/material.dart';

class AuthWarningTip extends StatelessWidget {
  final VoidCallback onTap;

  const AuthWarningTip({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final backgroundColor = colorScheme.surfaceContainerHighest.withValues(
      alpha: 0.3,
    );
    final borderColor = colorScheme.outlineVariant.withValues(alpha: 0.5);
    final iconColor = colorScheme.primary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, color: iconColor, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    children: [
                      const TextSpan(text: "Tip: Use "),
                      const TextSpan(
                        text: "secret variables",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: " for sensitive information. "),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
