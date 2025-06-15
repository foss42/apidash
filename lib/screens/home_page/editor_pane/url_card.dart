import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/ai_request/widgets/llm_selector.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:genai/genai.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';

import '../../common_widgets/common_widgets.dart';

class EditorPaneRequestURLCard extends ConsumerWidget {
  const EditorPaneRequestURLCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIdStateProvider);
    final apiType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.apiType));
    final aiHC = ref.watch(selectedRequestModelProvider
        .select((v) => v?.aiRequestModel?.hashCode));
    return Card(
      color: kColorTransparent,
      surfaceTintColor: kColorTransparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        borderRadius: kBorderRadius12,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: !context.isMediumWindow ? 20 : 6,
        ),
        child: context.isMediumWindow
            ? Row(
                children: [
                  switch (apiType) {
                    APIType.rest => const DropdownButtonHTTPMethod(),
                    APIType.graphql => kSizedBoxEmpty,
                    APIType.ai => const AIProviderSelector(),
                    null => kSizedBoxEmpty,
                  },
                  switch (apiType) {
                    APIType.rest => kHSpacer5,
                    _ => kHSpacer8,
                  },
                  Expanded(
                    child: URLTextField(
                      key: aiHC == null ? null : ValueKey(aiHC),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  switch (apiType) {
                    APIType.rest => const DropdownButtonHTTPMethod(),
                    APIType.graphql => kSizedBoxEmpty,
                    APIType.ai => const AIProviderSelector(),
                    null => kSizedBoxEmpty,
                  },
                  switch (apiType) {
                    APIType.rest => kHSpacer20,
                    _ => kHSpacer8,
                  },
                  Expanded(
                    child: URLTextField(
                      key: aiHC == null ? null : ValueKey(aiHC),
                    ),
                  ),
                  kHSpacer20,
                  const SizedBox(
                    height: 36,
                    child: SendRequestButton(),
                  )
                ],
              ),
      ),
    );
  }
}

class DropdownButtonHTTPMethod extends ConsumerWidget {
  const DropdownButtonHTTPMethod({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final method = ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel?.method));
    return DropdownButtonHttpMethod(
      method: method,
      onChanged: (HTTPVerb? value) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(method: value);
      },
    );
  }
}

class URLTextField extends ConsumerWidget {
  const URLTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);

    final reqM = ref.read(collectionStateNotifierProvider)![selectedId]!;
    final aiReqM = reqM.aiRequestModel;
    final payload = aiReqM?.payload;

    return EnvURLField(
      selectedId: selectedId!,
      initialValue: payload?.endpoint ??
          ref
              .read(collectionStateNotifierProvider.notifier)
              .getRequestModel(selectedId)
              ?.httpRequestModel
              ?.url,
      onChanged: (value) {
        final aim = ref
            .read(collectionStateNotifierProvider)![selectedId]!
            .aiRequestModel;
        if (aim != null) {
          aim.payload.endpoint = value;
          ref
              .read(collectionStateNotifierProvider.notifier)
              .update(aiRequestModel: aim.updatePayload(aim.payload));
        } else {
          ref.read(collectionStateNotifierProvider.notifier).update(url: value);
        }
      },
      onFieldSubmitted: (value) {
        ref.read(collectionStateNotifierProvider.notifier).sendRequest();
      },
    );
  }
}

class SendRequestButton extends ConsumerWidget {
  final Function()? onTap;
  const SendRequestButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIdStateProvider);
    final isWorking = ref.watch(
        selectedRequestModelProvider.select((value) => value?.isWorking));

    return SendButton(
      isWorking: isWorking ?? false,
      onTap: () {
        onTap?.call();
        ref.read(collectionStateNotifierProvider.notifier).sendRequest();
      },
      onCancel: () {
        ref.read(collectionStateNotifierProvider.notifier).cancelRequest();
      },
    );
  }
}

class AIProviderSelector extends ConsumerWidget {
  const AIProviderSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final req = ref.watch(collectionStateNotifierProvider)![selectedId]!;
    AIRequestModel? aiRequestModel = req.aiRequestModel;

    if (aiRequestModel == null) {
      return Container();
    }

    LLMSaveObject defaultLLMSO = LLMSaveObject(
      endpoint: aiRequestModel.payload.endpoint,
      credential: aiRequestModel.payload.credential,
      configMap: aiRequestModel.payload.configMap,
      selectedLLM: aiRequestModel.model,
      provider: aiRequestModel.provider,
    );

    return DefaultLLMSelectorButton(
      key: ValueKey(ref.watch(selectedIdStateProvider)),
      defaultLLM: defaultLLMSO,
      onDefaultLLMUpdated: (llmso) {
        ref.read(collectionStateNotifierProvider.notifier).update(
              aiRequestModel: AIRequestModel(
                model: llmso.selectedLLM,
                provider: llmso.provider,
                payload: LLMInputPayload(
                  endpoint: llmso.endpoint,
                  credential: llmso.credential,
                  systemPrompt: aiRequestModel.payload.systemPrompt,
                  userPrompt: aiRequestModel.payload.userPrompt,
                  configMap: llmso.configMap,
                ),
              ),
            );
      },
    );
  }
}
