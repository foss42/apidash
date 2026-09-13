import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/ai_provider_utils.dart';
import 'ai_model_selector_button.dart';

class AIModelSelector extends ConsumerWidget {
  final AIRequestModel? readOnlyModel;

  const AIModelSelector({
    super.key,
    this.readOnlyModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AIRequestModel? aiRequestModel;
    if (readOnlyModel == null) {
      ref.watch(selectedIdStateProvider);
      aiRequestModel = ref.watch(selectedRequestModelProvider
          .select((value) => value?.aiRequestModel));
    } else {
      aiRequestModel = readOnlyModel;
    }

    if (aiRequestModel == null && readOnlyModel != null) {
      return const SizedBox.shrink();
    }

    final settings = ref.watch(settingsProvider);
    final base = aiRequestModel ?? const AIRequestModel();
    final displayModel = applyProviderCredentials(
      base,
      settings.aiProviders,
      preferStored: false,
    );

    return AIModelSelectorButton(
      readonly: readOnlyModel != null,
      key: ValueKey(ref.watch(selectedIdStateProvider)),
      aiRequestModel: displayModel,
      showAddWhenEmpty: true,
      onModelUpdated: (newAIRequestModel) {
        final withCreds = applyProviderCredentials(
          newAIRequestModel,
          settings.aiProviders,
        );
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(aiRequestModel: withCreds.copyWith());
      },
    );
  }
}
