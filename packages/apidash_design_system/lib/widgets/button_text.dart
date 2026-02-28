import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

class ADTextButton extends StatelessWidget {
  const ADTextButton({
    super.key,
    this.icon,
    this.iconSize,
    this.showLabel = true,
    this.label,
    this.labelTextStyle,
    this.onPressed,
  });

  final IconData? icon;
  final double? iconSize;
  final bool showLabel;
  final String? label;
  final TextStyle? labelTextStyle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    var child = Text(
      label ?? "",
      style: labelTextStyle ?? kTextStyleButton,
    );
    return icon != null
        ? showLabel
            ? TextButton.icon(
                icon: Icon(
                  icon,
                  size: iconSize ?? kButtonIconSizeMedium,
                ),
                label: child,
                onPressed: onPressed,
              )
            : IconButton(
                onPressed: onPressed,
                icon: Icon(
                  icon,
                  size: iconSize ?? kButtonIconSizeMedium,
                ),
              )
        : TextButton(
            onPressed: onPressed,
            child: child,
          );
  }
}
