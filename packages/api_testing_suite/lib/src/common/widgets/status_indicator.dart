import 'package:flutter/material.dart';

/// A reusable status indicator widget that displays status with icon, color and text
class StatusIndicator extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final double? size;
  final bool showText;

  const StatusIndicator({
    super.key,
    required this.icon,
    required this.color,
    required this.text,
    this.size,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: size ?? 16),
          if (showText) ...[
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: size != null ? size! * 0.75 : 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
