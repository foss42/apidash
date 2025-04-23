import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/color_picker_dialog.dart'; 

class EnvEditorTitleActions extends ConsumerWidget {
  const EnvEditorTitleActions({
    super.key,
    this.onRenamePressed,
    this.onDuplicatePressed,
    this.onDeletePressed,
  });

  final void Function()? onRenamePressed;
  final void Function()? onDuplicatePressed;
  final void Function()? onDeletePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var verticalDivider = VerticalDivider(
      width: 2,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
    final environmentId = ref.watch(selectedEnvironmentIdStateProvider);
    final environmentColor = ref
        .watch(selectedEnvironmentModelProvider.select((value) => value?.color));

    return ClipRRect(
      borderRadius: kBorderRadius20,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: kBorderRadius20,
          ),
          child: SizedBox(
            height: 32,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  iconButton(
                    "Rename",
                    Icons.edit_rounded,
                    onRenamePressed,
                    padding: const EdgeInsets.only(left: 4),
                  ),
                  verticalDivider,
                  iconButton(
                    "Pick Color",
                    Icons.color_lens_rounded,
                    environmentId != null
                        ? () async {
                            final initialColor = environmentColor != null
                                ? Color(int.parse(
                                    environmentColor.substring(1),
                                    radix: 16))
                                : null;
                            final selectedColor = await showColorPickerDialog(
                              context,
                              initialColor: initialColor,
                            );
                            if (selectedColor != null) {
                              ref
                                  .read(environmentsStateNotifierProvider.notifier)
                                  .updateEnvironment(
                                    environmentId,
                                    color: selectedColor,
                                  );
                            }
                          }
                        : null,
                    padding: const EdgeInsets.all(0),
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
                    padding: const EdgeInsets.only(right: 4),
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
          padding: WidgetStateProperty.all(const EdgeInsets.all(0) + padding),
          shape: WidgetStateProperty.all(const ContinuousRectangleBorder()),
        ),
        onPressed: onPressed,
        icon: Icon(
          iconData,
          size: 16,
        ),
      ),
    );
  }
}