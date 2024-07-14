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
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ItemMenuOption>>[
        const PopupMenuItem<ItemMenuOption>(
          value: ItemMenuOption.edit,
          child: Text('Rename'),
        ),
        const PopupMenuItem<ItemMenuOption>(
          value: ItemMenuOption.delete,
          child: Text('Delete'),
        ),
        const PopupMenuItem<ItemMenuOption>(
          value: ItemMenuOption.duplicate,
          child: Text('Duplicate'),
        ),
      ],
      child: child,
    );
  }
}
