import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class EditorTitleActions extends StatelessWidget {
  const EditorTitleActions({
    super.key,
    this.onRenamePressed,
    this.onDuplicatePressed,
    this.onDeletePressed,
    required this.scaleFactor,
  });

  final void Function()? onRenamePressed;
  final void Function()? onDuplicatePressed;
  final void Function()? onDeletePressed;
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    var verticalDivider = VerticalDivider(
      width: 2 * scaleFactor, // Adjust vertical divider width with scaling
      color: Theme.of(context).colorScheme.outlineVariant,
    );

    return ClipRRect(
      borderRadius: kBorderRadius20 * scaleFactor, // Scale the border radius
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 1 * scaleFactor, // Scale the border width
            ),
            borderRadius: kBorderRadius20 * scaleFactor, // Scale the border radius
          ),
          child: SizedBox(
            width: 144*scaleFactor,
            height: 32 * scaleFactor, // Scale the height of the widget
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  iconButton(
                    "Rename",
                    Icons.edit_rounded,
                    onRenamePressed,
                    padding: EdgeInsets.only(left: 4 * scaleFactor),
                  ),
                  verticalDivider,
                  iconButton(
                    "Delete",
                    Icons.delete_rounded,
                    onDeletePressed,
                  ),
                  verticalDivider,
                  iconButton(
                    "Duplicate",
                    Icons.copy_rounded,
                    onDuplicatePressed,
                    padding: EdgeInsets.only(right: 4 * scaleFactor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget iconButton(
      String tooltip, IconData iconData, void Function()? onPressed,
      {EdgeInsets padding = const EdgeInsets.all(0)}) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            EdgeInsets.all(0) + padding, // Apply custom padding
          ),
          // Scale the shape
          shape: MaterialStateProperty.all(
            ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(8 * scaleFactor),
            ),
          ),
        ),
        onPressed: onPressed,
        icon: Icon(
          iconData,
          size: 16 * scaleFactor, // Scale the icon size
        ),
      ),
    );
  }
}
