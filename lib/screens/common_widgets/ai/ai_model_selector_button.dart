import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
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
              final newAIRequestModel = await showDialog<AIRequestModel>(
                context: context,
                useRootNavigator: useRootNavigator,
                builder: (context) {
                  final screenSize = MediaQuery.sizeOf(context);
                  final useCompactDialog =
                      useCompactAiModelSelectorDialogLayout(screenSize);

                  if (useCompactDialog) {
                    final isPortrait = screenSize.width < screenSize.height;
                    return Dialog(
                      insetPadding: EdgeInsets.symmetric(
                        horizontal: isPortrait ? 16 : 20,
                        vertical: isPortrait ? 20 : 16,
                      ),
                      child: SizedBox(
                        width: screenSize.width * (isPortrait ? 0.9 : 0.92),
                        height: screenSize.height * 0.9,
                        child: AIModelSelectorDialog(
                          aiRequestModel: aiRequestModel,
                        ),
                      ),
                    );
                  }

                  return Dialog(
                    insetPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: AIModelSelectorDialog(
                      aiRequestModel: aiRequestModel,
                    ),
                  );
                },
              );
              onDialogClose?.call();
              if (newAIRequestModel == null) return;
              onModelUpdated?.call(newAIRequestModel);
            },
      child: Text(aiRequestModel?.model ?? kLabelSelectModel),
    );
  }
}
