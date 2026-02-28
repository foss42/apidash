import 'package:flutter/material.dart';

/// A circular color indicator for environments
/// Shows a colored circle if color is set, or a gray circle if no color
class EnvironmentColorIndicator extends StatelessWidget {
  final int? color;
  final double size;

  const EnvironmentColorIndicator({
    super.key,
    this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (color == null) {
      // Default gray circle if no color set
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.grey[700] : Colors.grey[300],
          border: Border.all(
            color: isDark ? Colors.grey[600]! : Colors.grey[400]!,
            width: 1,
          ),
        ),
      );
    }

    // Colored circle with shadow
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(color!),
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
