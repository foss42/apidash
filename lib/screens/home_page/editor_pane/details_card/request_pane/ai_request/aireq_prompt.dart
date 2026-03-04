import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AIRequestPromptSection extends ConsumerWidget {
  const AIRequestPromptSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final aiRequestModel = ref.watch(
      selectedRequestModelProvider.select((value) => value?.aiRequestModel),
    );
    if (aiRequestModel == null) {
      return kSizedBoxEmpty;
    }
    final systemPrompt = aiRequestModel.systemPrompt;
    final userPrompt = aiRequestModel.userPrompt;

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
                key: Key("$selectedId-aireq-sysprompt-body"),
                fieldKey: "$selectedId-aireq-sysprompt-body",
                initialValue: systemPrompt,
                onChanged: (String value) {
                  final latestAiRequestModel = ref
                      .read(collectionStateNotifierProvider.notifier)
                      .getRequestModel(selectedId!)
                      ?.aiRequestModel;
                  if (latestAiRequestModel == null) return;
                  ref.read(collectionStateNotifierProvider.notifier).update(
                      aiRequestModel:
                          latestAiRequestModel.copyWith(systemPrompt: value));
                },
                hintText: 'Enter System Prompt',
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
                key: Key("$selectedId-aireq-userprompt-body"),
                fieldKey: "$selectedId-aireq-userprompt-body",
                initialValue: userPrompt,
                onChanged: (String value) {
                  final latestAiRequestModel = ref
                      .read(collectionStateNotifierProvider.notifier)
                      .getRequestModel(selectedId!)
                      ?.aiRequestModel;
                  if (latestAiRequestModel == null) return;
                  ref.read(collectionStateNotifierProvider.notifier).update(
                      aiRequestModel:
                          latestAiRequestModel.copyWith(userPrompt: value));
                },
                hintText: 'Enter User Prompt',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
