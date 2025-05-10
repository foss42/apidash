import 'package:flutter/material.dart';

/// A reusable styled card widget for consistent UI appearance
class StyledCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final VoidCallback? onTap;

  const StyledCard({
    super.key,
    required this.child,
    this.color,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? 1.0,
      margin: margin ?? const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        side: borderColor != null
            ? BorderSide(color: borderColor!, width: borderWidth ?? 1.0)
            : BorderSide.none,
      ),
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(12),
          child: child,
        ),
      ),
    );
  }
}
