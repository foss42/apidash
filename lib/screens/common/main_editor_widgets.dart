import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class ScaffoldTitle extends StatelessWidget {
  const ScaffoldTitle({
    super.key,
    required this.title,
    this.showMenu = true,
    this.onSelected,
  });
  final String title;
  final bool showMenu;
  final Function(ItemMenuOption)? onSelected;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !showMenu,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Colors.transparent,
          child: ItemCardMenu(
            offset: const Offset(0, 40),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            splashRadius: 0,
            tooltip: title,
            onSelected: onSelected,
            child: Ink(
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.3),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 1,
                    ),
                  ),
                  showMenu
                      ? const Icon(
                          Icons.more_vert_rounded,
                          size: 20,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EnvironmentDropdown extends ConsumerWidget {
  const EnvironmentDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environments = ref.watch(environmentsStateNotifierProvider);
    final environmentsList = environments?.values.toList();
    environmentsList
        ?.removeWhere((element) => element.id == kGlobalEnvironmentId);
    final activeEnvironment = ref.watch(activeEnvironmentIdStateProvider);
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          borderRadius: kBorderRadius8,
        ),
        child: EnvironmentPopupMenu(
          activeEnvironment: environments?[activeEnvironment],
          environments: environmentsList,
          onChanged: (value) {
            ref.read(activeEnvironmentIdStateProvider.notifier).state =
                value?.id;
            ref
                .read(settingsProvider.notifier)
                .update(activeEnvironmentId: value?.id);
            ref.read(hasUnsavedChangesProvider.notifier).state = true;
          },
        ));
  }
}

class TitleActionsArray extends StatelessWidget {
  const TitleActionsArray({
    super.key,
    this.onRenamePressed,
    this.onDuplicatePressed,
    this.onDeletePressed,
  });

  final void Function()? onRenamePressed;
  final void Function()? onDuplicatePressed;
  final void Function()? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    var verticalDivider = VerticalDivider(
      width: 2,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
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
          padding: MaterialStateProperty.all(const EdgeInsets.all(0) + padding),
          shape: MaterialStateProperty.all(const ContinuousRectangleBorder()),
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

showRenameDialog(
  BuildContext context,
  String dialogTitle,
  String? name,
  Function(String) onRename,
) {
  showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: name ?? "");
        controller.selection =
            TextSelection(baseOffset: 0, extentOffset: controller.text.length);
        return AlertDialog(
          title: Text(dialogTitle),
          content: TextField(
            autofocus: true,
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter new name"),
          ),
          actions: <Widget>[
            OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL')),
            FilledButton(
                onPressed: () {
                  final val = controller.text.trim();
                  onRename(val);
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 100), () {
                    controller.dispose();
                  });
                },
                child: const Text('OK')),
          ],
        );
      });
}
