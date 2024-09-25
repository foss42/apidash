import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class SidebarTopMenu extends StatelessWidget {
  const SidebarTopMenu({
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

  final Function(SidebarMenuOption)? onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SidebarMenuOption>(
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      splashRadius: splashRadius,
      icon: const Icon(Icons.more_vert),
      iconSize: 14,
      offset: offset,
      onSelected: onSelected,
      shape: shape,
      itemBuilder: (BuildContext context) => SidebarMenuOption.values
          .map<PopupMenuEntry<SidebarMenuOption>>(
            (e) => PopupMenuItem<SidebarMenuOption>(
              value: e,
              child: Text(e.label),
            ),
          )
          .toList(),
      child: child,
    );
  }
}
