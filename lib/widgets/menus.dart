import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class RequestCardMenu extends StatelessWidget {
  const RequestCardMenu({
    super.key,
    this.onSelected,
  });

  final Function(RequestItemMenuOption)? onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<RequestItemMenuOption>(
      padding: EdgeInsets.zero,
      splashRadius: 14,
      iconSize: 14,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<RequestItemMenuOption>>[
        const PopupMenuItem<RequestItemMenuOption>(
          value: RequestItemMenuOption.edit,
          child: Text(kLabelRename),
        ),
        const PopupMenuItem<RequestItemMenuOption>(
          value: RequestItemMenuOption.delete,
          child: Text(kLabelDelete),
        ),
        const PopupMenuItem<RequestItemMenuOption>(
          value: RequestItemMenuOption.duplicate,
          child: Text(kLabelDuplicate),
        ),
      ],
    );
  }
}
