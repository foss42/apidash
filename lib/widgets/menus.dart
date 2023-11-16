import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class RequestCardMenu extends StatefulWidget {
  const RequestCardMenu({
    super.key,
    this.onSelected,
  });

  final Function(RequestItemMenuOption)? onSelected;

  @override
  State<RequestCardMenu> createState() => _RequestCardMenuState();
}

class _RequestCardMenuState extends State<RequestCardMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<RequestItemMenuOption>(
      padding: EdgeInsets.zero,
      splashRadius: 14,
      iconSize: 14,
      onSelected: widget.onSelected,
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<RequestItemMenuOption>>[
        const PopupMenuItem<RequestItemMenuOption>(
          value: RequestItemMenuOption.edit,
          child: Text('Edit Name'),
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
    );
  }
}
