import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';
import 'menus.dart' show RequestCardMenu;
import 'texts.dart' show MethodBox;

class SidebarRequestCard extends StatelessWidget {
  const SidebarRequestCard({
    super.key,
    required this.id,
    required this.method,
    this.name,
    this.url,
    this.activeRequestId,
    this.editRequestId,
    this.onTap,
    this.onDoubleTap,
    this.onSecondaryTap,
    this.onChangedNameEditor,
    // this.controller,
    this.focusNode,
    this.onTapOutsideNameEditor,
    this.onMenuSelected,
  });

  final String id;
  final String? name;
  final String? url;
  final HTTPVerb method;
  final String? activeRequestId;
  final String? editRequestId;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onSecondaryTap;
  final Function(String)? onChangedNameEditor;
  // final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function()? onTapOutsideNameEditor;
  final Function(RequestItemMenuOption)? onMenuSelected;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.surface;
    final Color colorVariant =
        Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5);
    final Color surfaceTint = Theme.of(context).colorScheme.primary;
    bool isActiveId = activeRequestId == id;
    bool inEditMode = editRequestId == id;
    String nm = (name != null && name!.trim().isNotEmpty)
        ? name!
        : getRequestTitleFromUrl(url);
    return Tooltip(
      message: nm,
      waitDuration: const Duration(seconds: 1),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: kBorderRadius8,
        ),
        elevation: isActiveId ? 1 : 0,
        surfaceTintColor: isActiveId ? surfaceTint : null,
        color: isActiveId
            ? Theme.of(context).colorScheme.brightness == Brightness.dark
                ? colorVariant
                : color
            : color,
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: kBorderRadius8,
          hoverColor: colorVariant,
          focusColor: colorVariant.withOpacity(0.5),
          onTap: inEditMode ? null : onTap,
          // onDoubleTap: inEditMode ? null : onDoubleTap,
          onSecondaryTap: onSecondaryTap,
          child: Padding(
            padding: EdgeInsets.only(
              left: 6,
              right: isActiveId ? 6 : 10,
              top: 5,
              bottom: 5,
            ),
            child: SizedBox(
              height: 20,
              child: Row(
                children: [
                  MethodBox(method: method),
                  kHSpacer4,
                  Expanded(
                    child: inEditMode
                        ? TextFormField(
                            key: ValueKey("$id-name"),
                            initialValue: name,
                            // controller: controller,
                            focusNode: focusNode,
                            //autofocus: true,
                            style: Theme.of(context).textTheme.bodyMedium,
                            onTapOutside: (_) {
                              onTapOutsideNameEditor?.call();
                              //FocusScope.of(context).unfocus();
                            },
                            onChanged: onChangedNameEditor,
                            decoration: const InputDecoration(
                              isCollapsed: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                          )
                        : Text(
                            nm,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          ),
                  ),
                  Visibility(
                    visible: isActiveId && !inEditMode,
                    child: SizedBox(
                      width: 28,
                      child: RequestCardMenu(
                        onSelected: onMenuSelected,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RequestDetailsCard extends StatelessWidget {
  const RequestDetailsCard({super.key, this.child});

  final Widget? child;
  @override
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
      child: child,
    );
  }
}
