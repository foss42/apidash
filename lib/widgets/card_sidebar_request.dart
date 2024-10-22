import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
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
          onSecondaryTapUp: (details) {
            onSecondaryTap?.call();
            showItemCardMenu(context, details, onMenuSelected);
          },
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
                              FocusScope.of(context).unfocus();
                              onTapOutsideNameEditor?.call();
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
