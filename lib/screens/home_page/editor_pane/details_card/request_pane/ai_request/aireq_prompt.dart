import 'package:apidash/consts.dart';
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
    final systemPrompt = ref.watch(
      selectedRequestModelProvider.select(
        (value) => value?.aiRequestModel?.systemPrompt,
      ),
    );
    final userPrompt = ref.watch(
      selectedRequestModelProvider.select(
        (value) => value?.aiRequestModel?.userPrompt,
      ),
    );
    final aiRequestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(selectedId!)
        ?.aiRequestModel;
    if (aiRequestModel == null) {
      return kSizedBoxEmpty;
    }

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(kLabelSystemPrompt),
          ),
          kVSpacer10,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 150),
              child: TextFieldEditor(
                key: Key("$selectedId-aireq-sysprompt-body"),
                fieldKey: "$selectedId-aireq-sysprompt-body",
                initialValue: systemPrompt,
                expands: false,
                onChanged: (String value) {
                  ref
                      .read(collectionStateNotifierProvider.notifier)
                      .update(
                        aiRequestModel: aiRequestModel.copyWith(
                          systemPrompt: value,
                        ),
                      );
                },
                hintText: kHintEnterSystemPrompt,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(kLabelUserPromptInput),
          ),
          kVSpacer10,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 150),
              child: TextFieldEditor(
                key: Key("$selectedId-aireq-userprompt-body"),
                fieldKey: "$selectedId-aireq-userprompt-body",
                initialValue: userPrompt,
                expands: false,
                onChanged: (String value) {
                  ref
                      .read(collectionStateNotifierProvider.notifier)
                      .update(
                        aiRequestModel: aiRequestModel.copyWith(
                          userPrompt: value,
                        ),
                      );
                },
                hintText: kHintEnterUserPrompt,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
