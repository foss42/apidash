import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/widgets/editor.dart';
import 'package:apidash_design_system/widgets/textfield_outlined.dart';
import 'package:genai/llm_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AIRequestConfigSection extends ConsumerStatefulWidget {
  const AIRequestConfigSection({super.key});

  @override
  ConsumerState<AIRequestConfigSection> createState() =>
      _AIRequestConfigSectionState();
}

class _AIRequestConfigSectionState
    extends ConsumerState<AIRequestConfigSection> {
  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final reqM = ref.read(collectionStateNotifierProvider)![selectedId]!;
    final aiReqM = reqM.genericRequestModel!.aiRequestModel!;
    final payload = aiReqM.payload;

    updateRequestModel(LLMModelConfiguration el) {
      final aim = ref
          .read(collectionStateNotifierProvider)![selectedId]!
          .genericRequestModel!
          .aiRequestModel!;
      aim.payload.configMap[el.configId] = el;
      ref.read(collectionStateNotifierProvider.notifier).update(
            aiRequestModel: aim.updatePayload(aim.payload),
          );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        key: ValueKey(selectedId),
        children: [
          ...payload.configMap.values.map(
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
                  if (el.configType == LLMModelConfigurationType.boolean) ...[
                    Switch(
                      value: el.configValue.value as bool,
                      onChanged: (x) {
                        el.configValue.value = x;
                        updateRequestModel(el);
                        setState(() {});
                      },
                    )
                  ] else if (el.configType ==
                      LLMModelConfigurationType.numeric) ...[
                    ADOutlinedTextField(
                      initialValue: el.configValue.value.toString(),
                      onChanged: (x) {
                        if (x.isEmpty) x = '0';
                        if (num.tryParse(x) == null) return;
                        el.configValue.value = num.parse(x);
                        updateRequestModel(el);
                        setState(() {});
                      },
                    )
                  ] else if (el.configType ==
                      LLMModelConfigurationType.text) ...[
                    ADOutlinedTextField(
                      initialValue: el.configValue.value.toString(),
                      onChanged: (x) {
                        el.configValue.value = x;
                        updateRequestModel(el);
                        setState(() {});
                      },
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
                            onChanged: (x) {
                              final z = el.configValue.value as (
                                double,
                                double,
                                double
                              );
                              el.configValue.value = (z.$1, x, z.$3);
                              updateRequestModel(el);
                              setState(() {});
                            },
                          ),
                        ),
                        Text((el.configValue.value as (double, double, double))
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
          ),
        ],
      ),
    );
  }
}
