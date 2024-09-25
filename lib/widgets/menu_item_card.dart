import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class ItemCardMenu extends StatelessWidget {
  const ItemCardMenu({
    super.key,
    this.onSelected,
    this.child,
    this.offset = Offset.zero,
    this.splashRadius = 14,
    this.tooltip,
    this.shape,
  });
  final Widget? child;
  final Offset offset;
  final double splashRadius;
  final String? tooltip;
  final ShapeBorder? shape;

  final Function(ItemMenuOption)? onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ItemMenuOption>(
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      splashRadius: splashRadius,
      iconSize: 14,
      offset: offset,
      onSelected: onSelected,
      shape: shape,
      itemBuilder: (BuildContext context) => ItemMenuOption.values
          .map<PopupMenuEntry<ItemMenuOption>>(
            (e) => PopupMenuItem<ItemMenuOption>(
              value: e,
              child: Text(e.label),
            ),
          )
          .toList(),
      child: child,
    );
  }
}
