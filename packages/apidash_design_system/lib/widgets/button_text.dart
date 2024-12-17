import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

class ADTextButton extends StatelessWidget {
  const ADTextButton({
    super.key,
    this.icon,
    this.iconSize,
    this.label,
    this.onPressed,
  });

  final IconData? icon;
  final double? iconSize;
  final String? label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    var child = Text(
      label ?? "",
      style: kTextStyleButton,
    );
    return icon != null
        ? TextButton.icon(
            icon: Icon(
              icon,
              size: iconSize ?? kButtonIconSizeMedium,
            ),
            label: child,
            onPressed: onPressed,
          )
        : TextButton(
            onPressed: onPressed,
            child: child,
          );
  }
}
