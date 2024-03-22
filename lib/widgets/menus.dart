import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class RequestCardMenu extends StatelessWidget {
  const RequestCardMenu({
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

  final Function(RequestItemMenuOption)? onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<RequestItemMenuOption>(
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      splashRadius: splashRadius,
      iconSize: 14,
      offset: offset,
      onSelected: onSelected,
      shape: shape,
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<RequestItemMenuOption>>[
        const PopupMenuItem<RequestItemMenuOption>(
          value: RequestItemMenuOption.edit,
          child: Text('Rename'),
        ),
        const PopupMenuItem<RequestItemMenuOption>(
          value: RequestItemMenuOption.delete,
          child: Text('Delete'),
        ),
        const PopupMenuItem<RequestItemMenuOption>(
          value: RequestItemMenuOption.duplicate,
          child: Text('Duplicate'),
        ),
      ],
      child: child,
    );
  }
}
