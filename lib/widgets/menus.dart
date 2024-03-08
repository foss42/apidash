import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequestCardMenu extends StatelessWidget {
  const RequestCardMenu({
    super.key,
    this.onSelected,
  });

  final Function(RequestItemMenuOption)? onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<RequestItemMenuOption>(
      padding: EdgeInsets.zero,
      splashRadius: 14,
      iconSize: 14,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<RequestItemMenuOption>>[
        PopupMenuItem<RequestItemMenuOption>(
          value: RequestItemMenuOption.edit,
          child: Text(l10n!.kLabelRename),
        ),
        PopupMenuItem<RequestItemMenuOption>(
          value: RequestItemMenuOption.delete,
          child: Text(l10n.kLabelDelete),
        ),
        PopupMenuItem<RequestItemMenuOption>(
          value: RequestItemMenuOption.duplicate,
          child: Text(l10n.kLabelDuplicate),
        ),
      ],
    );
  }
}
