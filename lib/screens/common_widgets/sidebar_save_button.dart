import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/utils.dart';

class SaveButton extends ConsumerWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savingData = ref.watch(saveDataStateProvider);
    final hasUnsavedChanges = ref.watch(hasUnsavedChangesProvider);
    return TextButton.icon(
      onPressed: (savingData || !hasUnsavedChanges)
          ? null
          : () async {
              await saveAndShowDialog(context, onSave: () async {
                await ref
                    .read(collectionStateNotifierProvider.notifier)
                    .saveData();
                await ref
                    .read(environmentsStateNotifierProvider.notifier)
                    .saveEnvironments();
              });
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
