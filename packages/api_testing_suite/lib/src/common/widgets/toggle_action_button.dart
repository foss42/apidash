import 'package:flutter/material.dart';

/// A reusable toggle action button that can be used across the application
class ToggleActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? textColor;
  final double? iconSize;
  final double? fontSize;

  const ToggleActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onPressed,
    this.activeColor,
    this.inactiveColor,
    this.textColor,
    this.iconSize,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveActiveColor = activeColor ?? theme.colorScheme.primary;
    final effectiveInactiveColor = inactiveColor ?? Colors.grey.shade600;
    final effectiveTextColor = textColor ?? Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isActive 
                ? Color(0xff171433).withValues(alpha: 0.1) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isActive ? effectiveActiveColor : effectiveInactiveColor,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: iconSize ?? 16,
                color: isActive ? effectiveActiveColor : effectiveInactiveColor,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? effectiveActiveColor : effectiveInactiveColor,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: fontSize ?? 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
