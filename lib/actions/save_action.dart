import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/utils.dart';

/// Intent for the save action triggered by keyboard shortcut
class SaveIntent extends Intent {
  const SaveIntent();
}

/// Action that handles the save operation when triggered by keyboard shortcut
class SaveAction extends Action<SaveIntent> {
  SaveAction({
    required this.ref,
    required this.context,
  });

  final WidgetRef ref;
  final BuildContext context;

  @override
  Future<void> invoke(SaveIntent intent) async {
    // Check if there are unsaved changes
    final hasUnsavedChanges = ref.read(hasUnsavedChangesProvider);
    if (!hasUnsavedChanges) {
      return;
    }

    // Check if save is already in progress
    final savingData = ref.read(saveDataStateProvider);
    if (savingData) {
      return;
    }

    // Perform the save operation
    await saveAndShowDialog(context, onSave: () async {
      await ref.read(collectionStateNotifierProvider.notifier).saveData();
      await ref.read(environmentsStateNotifierProvider.notifier).saveEnvironments();
    });
  }
}
