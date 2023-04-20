import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';
import 'menus.dart' show RequestCardMenu;
import 'texts.dart' show MethodBox;

class SidebarRequestCard extends StatefulWidget {
  const SidebarRequestCard({
    super.key,
    required this.id,
    required this.activeRequestId,
    required this.url,
    required this.method,
    this.onTap,
    this.onMenuSelected,
  });

  final String id;
  final String? activeRequestId;
  final String url;
  final HTTPVerb method;
  final void Function()? onTap;
  final Function(RequestItemMenuOption)? onMenuSelected;

  @override
  State<SidebarRequestCard> createState() => _SidebarRequestCardState();
}

class _SidebarRequestCardState extends State<SidebarRequestCard> {
  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.surface;
    final Color surfaceTint = Theme.of(context).colorScheme.primary;
    bool isActiveId = widget.activeRequestId == widget.id;
    return Material(
      borderRadius: kBorderRadius12,
      elevation: isActiveId ? 1 : 0,
      surfaceTintColor: isActiveId ? surfaceTint : null,
      color: color,
      type: MaterialType.card,
      child: InkWell(
        borderRadius: kBorderRadius12,
        onTap: widget.onTap,
        child: Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: isActiveId ? 0 : 20,
            top: 5,
            bottom: 5,
          ),
          child: SizedBox(
            height: 20,
            child: Row(
              children: [
                MethodBox(method: widget.method),
                kHSpacer5,
                Expanded(
                  child: Text(
                    getRequestTitleFromUrl(widget.url),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
                Visibility(
                  visible: isActiveId,
                  child: RequestCardMenu(
                    onSelected: widget.onMenuSelected,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RequestDetailsCard extends StatefulWidget {
  const RequestDetailsCard({super.key, this.child});

  final Widget? child;
  @override
  State<RequestDetailsCard> createState() => _RequestDetailsCardState();
}

class _RequestDetailsCardState extends State<RequestDetailsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        borderRadius: kBorderRadius12,
      ),
      elevation: 0,
      child: widget.child,
    );
  }
}
