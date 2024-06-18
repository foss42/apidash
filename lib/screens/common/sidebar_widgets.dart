import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class SidebarHeader extends ConsumerWidget {
  const SidebarHeader({super.key, this.onAddNew});
  final Function()? onAddNew;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mobileScaffoldKey = ref.read(mobileScaffoldKeyStateProvider);
    return Padding(
      padding: kPe8,
      child: Row(
        children: [
          const SaveButton(),
          const Spacer(),
          ElevatedButton(
            onPressed: onAddNew,
            child: const Text(
              kLabelPlusNew,
              style: kTextStyleButton,
            ),
          ),
          context.width <= kMinWindowSize.width
              ? IconButton(
                  style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(4),
                      minimumSize: const Size(30, 30)),
                  onPressed: () {
                    mobileScaffoldKey.currentState?.closeDrawer();
                  },
                  icon: const Icon(Icons.chevron_left),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class SidebarFilter extends StatelessWidget {
  const SidebarFilter({
    super.key,
    this.onFilterFieldChanged,
    this.filterHintText,
  });

  final Function(String)? onFilterFieldChanged;
  final String? filterHintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: kBorderRadius8,
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
      ),
      child: Row(
        children: [
          kHSpacer5,
          Icon(
            Icons.filter_alt,
            size: 18,
            color: Theme.of(context).colorScheme.secondary,
          ),
          kHSpacer5,
          Expanded(
            child: RawTextField(
              style: Theme.of(context).textTheme.bodyMedium,
              hintText: filterHintText ?? "Filter by name",
              onChanged: onFilterFieldChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class SaveButton extends ConsumerWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overlayWidget = OverlayWidgetTemplate(context: context);
    final savingData = ref.watch(saveDataStateProvider);
    final hasUnsavedChanges = ref.watch(hasUnsavedChangesProvider);
    return TextButton.icon(
      onPressed: (savingData || !hasUnsavedChanges)
          ? null
          : () async {
              overlayWidget.show(
                  widget: const SavingOverlay(saveCompleted: false));

              await ref
                  .read(collectionStateNotifierProvider.notifier)
                  .saveData();
              await ref
                  .read(environmentsStateNotifierProvider.notifier)
                  .saveEnvironments();
              overlayWidget.hide();
              overlayWidget.show(
                  widget: const SavingOverlay(saveCompleted: true));
              await Future.delayed(const Duration(seconds: 1));
              overlayWidget.hide();
            },
      icon: const Icon(
        Icons.save,
        size: 20,
      ),
      label: const Text(
        kLabelSave,
        style: kTextStyleButton,
      ),
    );
  }
}
