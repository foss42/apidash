import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';
import 'menu_item_card.dart';
import 'texts.dart' show MethodBox;

class SidebarRequestCard extends StatelessWidget {
  const SidebarRequestCard({
    super.key,
    required this.id,
    required this.method,
    this.name,
    this.url,
    this.selectedId,
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
  final String? selectedId;
  final String? editRequestId;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onSecondaryTap;
  final Function(String)? onChangedNameEditor;

  // final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function()? onTapOutsideNameEditor;
  final Function(ItemMenuOption)? onMenuSelected;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.surface;
    final Color colorVariant =
        Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5);
    final Color surfaceTint = Theme.of(context).colorScheme.primary;
    bool isSelected = selectedId == id;
    bool inEditMode = editRequestId == id;
    String nm = (name != null && name!.trim().isNotEmpty)
        ? name!
        : getRequestTitleFromUrl(url);
    return Tooltip(
      message: nm,
      triggerMode: TooltipTriggerMode.manual,
      waitDuration: const Duration(seconds: 1),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: kBorderRadius8,
        ),
        elevation: isSelected ? 1 : 0,
        surfaceTintColor: isSelected ? surfaceTint : null,
        color: isSelected
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
              right: isSelected ? 6 : 10,
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
                            onFieldSubmitted: (value) {
                              onTapOutsideNameEditor?.call();
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
                    visible: isSelected && !inEditMode,
                    child: SizedBox(
                      width: 28,
                      child: ItemCardMenu(
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

class TabRequestCard extends StatelessWidget {
  const TabRequestCard({
    super.key,
    required this.id,
    required this.method,
    this.name,
    this.url,
    this.selectedId,
    this.editRequestId,
    this.onTap,
    this.onClose,
  });

  final String id;
  final String? name;
  final String? url;
  final HTTPVerb method;
  final String? selectedId;
  final String? editRequestId;
  final void Function()? onTap;
  final void Function()? onClose;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.surface;
    final Color colorVariant =
        Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5);
    final Color surfaceTint = Theme.of(context).colorScheme.primary;
    bool isSelected = selectedId == id;
    bool inEditMode = editRequestId == id;
    String nm = (name != null && name!.trim().isNotEmpty)
        ? name!
        : getRequestTitleFromUrl(url);
    return Tooltip(
      message: nm,
      waitDuration: const Duration(seconds: 1),
      child: Card(
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(8),
        //     topRight: Radius.circular(8),
        //   ),
        // ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        elevation: isSelected ? 1 : 0,
        surfaceTintColor: isSelected ? surfaceTint : null,
        color: isSelected
            ? Theme.of(context).colorScheme.brightness == Brightness.dark
                ? colorVariant
                : color
            : color,
        margin: EdgeInsets.zero,
        child: InkWell(
          // borderRadius: const BorderRadius.only(
          //   topLeft: Radius.circular(8),
          //   topRight: Radius.circular(8),
          // ),
          borderRadius: BorderRadius.zero,
          hoverColor: colorVariant,
          focusColor: colorVariant.withOpacity(0.5),
          onTap: inEditMode ? null : onTap,
          child: Container(
            padding: EdgeInsets.only(
              left: 6,
              right: isSelected ? 6 : 10,
              top: 2,
              bottom: 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MethodBox(method: method),
                kHSpacer4,
                Expanded(
                  child: Text(
                    nm,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
                kHSpacer4,
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(
                    Icons.close,
                    size: 12,
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
