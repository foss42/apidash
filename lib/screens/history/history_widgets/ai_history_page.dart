import 'package:apidash/providers/history_providers.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/ai_request/widgets/ai_config_widgets.dart';
import 'package:apidash/widgets/editor.dart';
import 'package:apidash_design_system/tokens/measurements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genai/genai.dart';

class HisAIRequestPromptSection extends ConsumerWidget {
  const HisAIRequestPromptSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedHistoryModel =
        ref.watch(selectedHistoryRequestModelProvider)!;

    final aiReqM = selectedHistoryModel.aiRequestModel!;
    final payload = aiReqM.payload;
    final systemPrompt = payload.systemPrompt;
    final userPrompt = payload.userPrompt;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'System Prompt',
            ),
          ),
          kVSpacer10,
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFieldEditor(
                key: Key(
                    "${selectedHistoryModel.historyId}-aireq-sysprompt-body"),
                fieldKey:
                    "${selectedHistoryModel.historyId}-aireq-sysprompt-body",
                initialValue: systemPrompt,
                readOnly: true,
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'User Prompt / Input',
            ),
          ),
          kVSpacer10,
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFieldEditor(
                key: Key(
                    "${selectedHistoryModel.historyId}-aireq-userprompt-body"),
                fieldKey:
                    "${selectedHistoryModel.historyId}-aireq-userprompt-body",
                initialValue: userPrompt,
                readOnly: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HisAIRequestAuthorizationSection extends ConsumerWidget {
  const HisAIRequestAuthorizationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedHistoryModel =
        ref.watch(selectedHistoryRequestModelProvider)!;

    final aiReqM = selectedHistoryModel.aiRequestModel!;

    final payload = aiReqM.payload;

    final cred = payload.credential;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFieldEditor(
                key: Key(
                    "${selectedHistoryModel.historyId}-aireq-authvalue-body"),
                fieldKey:
                    "${selectedHistoryModel.historyId}-aireq-authvalue-body",
                initialValue: cred,
                readOnly: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HisAIRequestConfigSection extends ConsumerWidget {
  const HisAIRequestConfigSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedHistoryModel =
        ref.watch(selectedHistoryRequestModelProvider)!;

    final aiReqM = selectedHistoryModel.aiRequestModel!;

    final payload = aiReqM.payload;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        key: ValueKey(selectedHistoryModel.historyId),
        children: [
          ...payload.configMap.values.map(
            (el) => ListTile(
              title: Text(el.configName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    el.configDescription,
                  ),
                  SizedBox(height: 5),
                  if (el.configType == LLMModelConfigurationType.boolean) ...[
                    BooleanAIConfig(
                      readonly: true,
                      configuration: el,
                      onConfigUpdated: (x) {},
                    ),
                  ] else if (el.configType ==
                      LLMModelConfigurationType.numeric) ...[
                    WritableAIConfig(
                      configuration: el,
                      onConfigUpdated: (x) {},
                      readonly: true,
                      numeric: true,
                    ),
                  ] else if (el.configType ==
                      LLMModelConfigurationType.text) ...[
                    WritableAIConfig(
                      configuration: el,
                      onConfigUpdated: (x) {},
                      readonly: true,
                    ),
                  ] else if (el.configType ==
                      LLMModelConfigurationType.slider) ...[
                    SliderAIConfig(
                      configuration: el,
                      onSliderUpdated: (x) {},
                      readonly: true,
                    ),
                  ],
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
