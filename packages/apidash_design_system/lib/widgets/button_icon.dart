import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

class ADIconButton extends StatelessWidget {
  const ADIconButton({
    super.key,
    required this.icon,
    this.iconSize,
    this.onPressed,
    this.color,
    this.visualDensity,
    this.tooltip,
  });

  final IconData icon;
  final double? iconSize;
  final VoidCallback? onPressed;
  final Color? color;
  final VisualDensity? visualDensity;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      icon: Icon(
        icon,
        size: iconSize ?? kButtonIconSizeMedium,
      ),
      color: color,
      visualDensity: visualDensity,
      onPressed: onPressed,
    );
  }
}
