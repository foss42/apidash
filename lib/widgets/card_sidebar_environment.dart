import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';
import 'menu_item_card.dart';

class SidebarEnvironmentCard extends StatelessWidget {
  const SidebarEnvironmentCard({
    super.key,
    required this.id,
    this.isGlobal = false,
    this.isActive = false,
    this.name,
    this.selectedId,
    this.editRequestId,
    this.setActive,
    this.onTap,
    this.onDoubleTap,
    this.onSecondaryTap,
    this.onChangedNameEditor,
    this.focusNode,
    this.onTapOutsideNameEditor,
    this.onMenuSelected,
  });

  final String id;
  final bool isGlobal;
  final bool isActive;
  final String? name;
  final String? selectedId;
  final String? editRequestId;
  final void Function(bool?)? setActive;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onSecondaryTap;
  final Function(String)? onChangedNameEditor;
  final FocusNode? focusNode;
  final Function()? onTapOutsideNameEditor;
  final Function(ItemMenuOption)? onMenuSelected;

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    final colorScheme = Theme.of(context).colorScheme;
    final Color color =
    isGlobal ? colorScheme.secondaryContainer : colorScheme.surface;
    final Color colorVariant =
    colorScheme.surfaceContainerHighest.withOpacity(0.5);
    final Color surfaceTint = colorScheme.primary;
    bool isSelected = selectedId == id;
    bool inEditMode = editRequestId == id;
    String nm = getEnvironmentTitle(name);

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
        color: isSelected && !isGlobal
            ? colorScheme.brightness == Brightness.dark
            ? colorVariant
            : color
            : color,
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: kBorderRadius8,
          hoverColor: colorVariant,
          focusColor: colorVariant.withOpacity(0.5),
          onTap: inEditMode ? null : onTap,
          onSecondaryTap: onSecondaryTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 6 * scaleFactor, // Scale horizontal padding
              vertical: 5 * scaleFactor,   // Scale vertical padding
            ),
            child: SizedBox(
              height: 20 * scaleFactor,    // Scale height of the card
              child: Row(
                children: [
                  SizedBox(width: 4 * scaleFactor), // Scale spacer width
                  Expanded(
                    child: inEditMode
                        ? TextFormField(
                      key: ValueKey("$id-name"),
                      initialValue: name,
                      focusNode: focusNode,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14 * scaleFactor, // Scale text size
                      ),
                      onTapOutside: (_) {
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
                      style: TextStyle(
                        fontSize: 14 * scaleFactor, // Scale text size
                      ),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  Visibility(
                    visible: isSelected && !inEditMode && !isGlobal,
                    child: SizedBox(
                      width: 28 * scaleFactor, // Scale the width of the menu
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
