import 'package:apidash/models/llm_models/llm_config.dart';
import 'package:apidash/models/llm_models/llm_model.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/providers/history_providers.dart';
import 'package:apidash/widgets/editor.dart';
import 'package:apidash_design_system/tokens/measurements.dart';
import 'package:apidash_design_system/widgets/textfield_outlined.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HisAIPromptsSection extends ConsumerWidget {
  const HisAIPromptsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedHistoryModel = ref.watch(selectedHistoryRequestModelProvider);
    final reqDetails = selectedHistoryModel!.extraDetails;

    final systemPrompt = reqDetails['system_prompt'];
    final userPrompt = reqDetails['user_prompt'];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'System Prompt',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          kVSpacer10,
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFieldEditor(
                key: Key(
                    "${selectedHistoryModel?.historyId}-aireq-sysprompt-body"),
                fieldKey:
                    "${selectedHistoryModel?.historyId}-aireq-sysprompt-body",
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
              style: TextStyle(color: Colors.white54),
            ),
          ),
          kVSpacer10,
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFieldEditor(
                key: Key(
                    "${selectedHistoryModel?.historyId}-aireq-userprompt-body"),
                fieldKey:
                    "${selectedHistoryModel?.historyId}-aireq-userprompt-body",
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

class HisAIAuthorizationSection extends ConsumerWidget {
  const HisAIAuthorizationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedHistoryModel = ref.watch(selectedHistoryRequestModelProvider);
    final reqDetails = selectedHistoryModel!.extraDetails;

    final iV = reqDetails['authorization_credential'];
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
                initialValue: iV,
                readOnly: true,
                hintText: 'credential',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HisAIConfigsSection extends ConsumerStatefulWidget {
  const HisAIConfigsSection({super.key});

  @override
  ConsumerState<HisAIConfigsSection> createState() =>
      _HisAIConfigsSectionState();
}

class _HisAIConfigsSectionState extends ConsumerState<HisAIConfigsSection> {
  @override
  Widget build(BuildContext context) {
    final selectedHistoryModel = ref.watch(selectedHistoryRequestModelProvider);
    final reqDetails = selectedHistoryModel!.extraDetails;

    final LLMModel model = reqDetails['model']!;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        key: ValueKey(selectedHistoryModel.historyId),
        children: [
          ...model.configurations.values
              .map(
                (el) => ListTile(
                  title: Text(el.configName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        el.configDescription,
                        style: TextStyle(color: Colors.white30),
                      ),
                      SizedBox(height: 5),
                      if (el.configType ==
                          LLMModelConfigurationType.boolean) ...[
                        Switch(
                          value: el.configValue.value as bool,
                          onChanged: (x) {},
                        )
                      ] else if (el.configType ==
                          LLMModelConfigurationType.numeric) ...[
                        ADOutlinedTextField(
                          initialValue: el.configValue.value.toString(),
                          readOnly: true,
                        )
                      ] else if (el.configType ==
                          LLMModelConfigurationType.text) ...[
                        ADOutlinedTextField(
                          initialValue: el.configValue.value.toString(),
                          readOnly: true,
                        )
                      ] else if (el.configType ==
                          LLMModelConfigurationType.slider) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                min: (el.configValue.value as (
                                  double,
                                  double,
                                  double
                                ))
                                    .$1,
                                value: (el.configValue.value as (
                                  double,
                                  double,
                                  double
                                ))
                                    .$2,
                                max: (el.configValue.value as (
                                  double,
                                  double,
                                  double
                                ))
                                    .$3,
                                onChanged: (x) {},
                              ),
                            ),
                            Text((el.configValue.value as (
                              double,
                              double,
                              double
                            ))
                                .$2
                                .toStringAsFixed(2)),
                          ],
                        )
                      ],
                      SizedBox(height: 10),
                      // Divider(color: Colors.white10),
                      // SizedBox(height: 10),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
