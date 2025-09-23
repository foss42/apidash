import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'ai_model_selector_dialog.dart';

class AIModelSelectorButton extends StatelessWidget {
  final AIRequestModel? aiRequestModel;
  final bool readonly;
  final Function(AIRequestModel)? onModelUpdated;
  const AIModelSelectorButton({
    super.key,
    this.aiRequestModel,
    this.readonly = false,
    this.onModelUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: readonly
          ? null
          : () async {
              final newAIRequestModel = await showDialog(
                context: context,
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
              if (newAIRequestModel == null) return;
              onModelUpdated?.call(newAIRequestModel);
            },
      child: Text(aiRequestModel?.model ?? 'Select Model'),
    );
  }
}
