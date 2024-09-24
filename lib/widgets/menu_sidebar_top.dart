import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_providers.dart';

class SidebarTopMenu extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    double scaleFactor = settings.scaleFactor;

    return PopupMenuButton<SidebarMenuOption>(
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      splashRadius: splashRadius,
      icon: const Icon(Icons.more_vert),
      iconSize: 14*scaleFactor,
      offset: offset,
      onSelected: onSelected,
      shape: shape,
      itemBuilder: (BuildContext context) => SidebarMenuOption.values
          .map<PopupMenuEntry<SidebarMenuOption>>(
            (e) => PopupMenuItem<SidebarMenuOption>(
              value: e,
              child: Text(e.label,style: TextStyle(fontSize:14*scaleFactor),),
            ),
          )
          .toList(),
      child: child,
    );
  }
}
