import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';
import 'menu_item_card.dart';
import 'environment_color_indicator.dart';
import 'environment_color_picker.dart';

class SidebarEnvironmentCard extends StatelessWidget {
  const SidebarEnvironmentCard({
    super.key,
    required this.id,
    this.isGlobal = false,
    this.isActive = false,
    this.name,
    this.selectedId,
    this.editRequestId,
    this.color,
    this.setActive,
    this.onTap,
    this.onDoubleTap,
    this.onSecondaryTap,
    this.onChangedNameEditor,
    this.focusNode,
    this.onTapOutsideNameEditor,
    this.onMenuSelected,
    this.onColorChange,
  });

  final String id;
  final bool isGlobal;
  final bool isActive;
  final String? name;
  final String? selectedId;
  final String? editRequestId;
  final int? color;
  final void Function(bool?)? setActive;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onSecondaryTap;
  final Function(String)? onChangedNameEditor;
  final FocusNode? focusNode;
  final Function()? onTapOutsideNameEditor;
  final Function(ItemMenuOption)? onMenuSelected;
  final Function(int?)? onColorChange;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color cardColor =
        isGlobal ? colorScheme.secondaryContainer : colorScheme.surface;
    final Color colorVariant = colorScheme.surfaceContainer;
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
                : cardColor
            : cardColor,
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: kBorderRadius8,
          hoverColor: colorVariant,
          focusColor: colorVariant,
          onTap: inEditMode ? null : onTap,
          // onSecondaryTap: onSecondaryTap,
          onSecondaryTapUp: (isGlobal)
              ? null
              : (details) {
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
                  // Color indicator (only show for non-global environments)
                  if (!isGlobal) ...[
                    EnvironmentColorIndicator(
                      color: color,
                      size: 20,
                    ),
                    kHSpacer8,
                  ] else
                    kHSpacer4,
                  Expanded(
                    child: inEditMode
                        ? TextFormField(
                            key: ValueKey("$id-name"),
                            initialValue: name,
                            focusNode: focusNode,
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
                  // Color picker button (only show when selected and not in edit mode)
                  if (isSelected && !inEditMode && !isGlobal)
                    SizedBox(
                      width: 28,
                      child: IconButton(
                        icon: const Icon(Icons.palette, size: 16),
                        tooltip: 'Change Color',
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => EnvironmentColorPicker(
                              currentColor: color,
                              onColorSelected: (newColor) {
                                onColorChange?.call(newColor);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  Visibility(
                    visible: isSelected && !inEditMode && !isGlobal,
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
