import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class ItemCardMenu extends StatelessWidget {
  const ItemCardMenu({
    super.key,
    this.onSelected,
    this.availableOptions,
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
  final List<ItemMenuOption>? availableOptions;

  @override
  Widget build(BuildContext context) {
    final options = availableOptions ?? ItemMenuOption.values;
    return PopupMenuButton<ItemMenuOption>(
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      splashRadius: splashRadius,
      iconSize: 14,
      offset: offset,
      onSelected: onSelected,
      shape: shape,
      itemBuilder: (BuildContext context) => options
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

/// Open the item card menu where the right click has been released
Future<void> showItemCardMenu(
  BuildContext context,
  TapUpDetails details,
  List<ItemMenuOption> availableOptions,
  Function(ItemMenuOption)? onSelected,
) async {
  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      details.globalPosition.dx,
      details.globalPosition.dy,
      details.globalPosition.dx,
      details.globalPosition.dy,
    ),
    items: availableOptions
        .map<PopupMenuEntry<ItemMenuOption>>(
          (e) => PopupMenuItem<ItemMenuOption>(
            onTap: () => onSelected?.call(e),
            value: e,
            child: Text(e.label),
          ),
        )
        .toList(),
  );
}
