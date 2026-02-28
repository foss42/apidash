import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'ai_model_selector_dialog.dart';

class AIModelSelectorButton extends StatelessWidget {
  final AIRequestModel? aiRequestModel;
  final bool readonly;
  final Function(AIRequestModel)? onModelUpdated;
  final bool useRootNavigator;
  final VoidCallback? onDialogOpen;
  final VoidCallback? onDialogClose;

  const AIModelSelectorButton({
    super.key,
    this.aiRequestModel,
    this.readonly = false,
    this.onModelUpdated,
    this.useRootNavigator = true,
    this.onDialogOpen,
    this.onDialogClose,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: readonly
          ? null
          : () async {
              onDialogOpen?.call();
              final result = await showDialog<(AIRequestModel?, Map<String, String>?)>(
                context: context,
                useRootNavigator: useRootNavigator,
                builder: (context) {
                  return AlertDialog(
                    scrollable: true,
                    content: AIModelSelectorDialog(
                      aiRequestModel: aiRequestModel,
                    ),
                    contentPadding: kP10,
                  );
                },
              );
              onDialogClose?.call();
              if (result == null || result.$1 == null) return;
              final newAIRequestModel = result.$1!;
              final aiKeys = result.$2;
              onModelUpdated?.call(newAIRequestModel);
              if (aiKeys != null) {
                ref.read(settingsProvider.notifier).update(aiKeys: aiKeys);
              }
            },
      child: Text(aiRequestModel?.model ?? 'Select Model'),
    );
  }
}
