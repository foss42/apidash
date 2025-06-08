import 'package:apidash_core/apidash_core.dart';

import 'package:genai/llm_input_payload.dart';
import 'package:genai/llm_saveobject.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:genai/providers/gemini/gemini.dart';
import 'package:genai/providers/gemini/models.dart';
import 'package:genai/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';

class APITypeDropdown extends ConsumerWidget {
  const APITypeDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIdStateProvider);
    final apiType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.apiType));
    return APITypePopupMenu(
      apiType: apiType,
      onChanged: (type) {
        if (type == APIType.ai) {
          initializeAIRequest(ref);
        }
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(apiType: type);
      },
    );
  }
}

initializeAIRequest(WidgetRef ref) {
  final selectedId = ref.watch(selectedIdStateProvider);
  final req = ref.watch(collectionStateNotifierProvider)![selectedId]!;
  AIRequestModel? aiRequestModel = req.genericRequestModel?.aiRequestModel;
  LLMSaveObject? defaultLLMSO = ref
      .watch(settingsProvider.notifier)
      .settingsModel
      ?.defaultLLMSaveObject; //Settings Default

  if (aiRequestModel == null) {
    // Creating the AIRequest Model initially
    final gmC = GeminiModelController.instance;
    final newAIRM = AIRequestModel(
      model: defaultLLMSO?.selectedLLM ?? GeminiModel.gemini_20_flash,
      provider: defaultLLMSO?.provider ?? LLMProvider.gemini,
      payload: LLMInputPayload(
        endpoint: defaultLLMSO?.endpoint ?? gmC.inputPayload.endpoint,
        credential: defaultLLMSO?.credential ?? '',
        systemPrompt: '',
        userPrompt: '',
        configMap: defaultLLMSO?.configMap ?? gmC.inputPayload.configMap,
      ),
    );
    ref.read(collectionStateNotifierProvider.notifier).update(
          aiRequestModel: newAIRM,
        );
  }
}
