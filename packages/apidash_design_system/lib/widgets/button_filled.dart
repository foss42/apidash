import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

class ADFilledButton extends StatelessWidget {
  const ADFilledButton({
    super.key,
    this.icon,
    this.iconSize,
    this.label,
    this.items,
    this.isTonal = false,
    this.visualDensity,
    this.onPressed,
  });

  final IconData? icon;
  final double? iconSize;
  final String? label;
  final List<Widget>? items;
  final bool isTonal;
  final VisualDensity? visualDensity;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    Widget child = Text(
      label ?? "",
      style: kTextStyleButton,
    );
    if (items != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: items ?? [],
      );
    }

    return (icon != null && items == null)
        ? (isTonal
            ? FilledButton.tonalIcon(
                icon: Icon(
                  icon,
                  size: iconSize ?? kButtonIconSizeMedium,
                ),
                label: child,
                onPressed: onPressed,
              )
            : FilledButton.icon(
                icon: Icon(
                  icon,
                  size: iconSize ?? kButtonIconSizeMedium,
                ),
                label: child,
                onPressed: onPressed,
              ))
        : (isTonal
            ? FilledButton.tonal(
                onPressed: onPressed,
                child: child,
              )
            : FilledButton(
                onPressed: onPressed,
                child: child,
              ));
  }
}
