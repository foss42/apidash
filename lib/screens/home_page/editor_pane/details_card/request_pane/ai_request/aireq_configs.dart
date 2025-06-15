import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/ai_request/widgets/ai_config_widgets.dart';
import 'package:genai/genai.dart';
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
    final aiReqM = reqM.aiRequestModel!;
    final payload = aiReqM.payload;

    updateRequestModel(LLMModelConfiguration el) {
      final aim = ref
          .read(collectionStateNotifierProvider)![selectedId]!
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
                  ),
                  SizedBox(height: 5),
                  if (el.configType == LLMModelConfigurationType.boolean) ...[
                    BooleanAIConfig(
                      configuration: el,
                      onConfigUpdated: (x) {
                        updateRequestModel(el);
                        setState(() {});
                      },
                    ),
                  ] else if (el.configType ==
                      LLMModelConfigurationType.numeric) ...[
                    WritableAIConfig(
                      configuration: el,
                      onConfigUpdated: (x) {
                        updateRequestModel(el);
                        setState(() {});
                      },
                      numeric: true,
                    ),
                  ] else if (el.configType ==
                      LLMModelConfigurationType.text) ...[
                    WritableAIConfig(
                      configuration: el,
                      onConfigUpdated: (x) {
                        updateRequestModel(el);
                        setState(() {});
                      },
                    ),
                  ] else if (el.configType ==
                      LLMModelConfigurationType.slider) ...[
                    SliderAIConfig(
                      configuration: el,
                      onSliderUpdated: (x) {
                        updateRequestModel(x);
                        setState(() {});
                      },
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
