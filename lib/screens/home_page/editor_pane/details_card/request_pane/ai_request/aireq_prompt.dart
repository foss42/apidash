import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AIRequestPromptSection extends ConsumerWidget {
  const AIRequestPromptSection({super.key});

  InputDecoration _promptDecoration(BuildContext context, String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Theme.of(context).colorScheme.outlineVariant,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: kBorderRadius8,
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: kBorderRadius8,
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
      ),
      filled: true,
      hoverColor: kColorTransparent,
      fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
    );
  }

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
        .read(activeCollectionProvider.notifier)
        .getRequestModel(selectedId!)
        ?.aiRequestModel;
    if (aiRequestModel == null) {
      return kSizedBoxEmpty;
    }

    final style = kCodeStyle.copyWith(
      fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(kLabelSystemPrompt),
          ),
          kVSpacer10,
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: EnvironmentTriggerField(
                keyId: "$selectedId-aireq-sysprompt-body",
                initialValue: systemPrompt,
                expands: true,
                style: style,
                decoration: _promptDecoration(context, kHintEnterSystemPrompt),
                onChanged: (String value) {
                  ref.read(activeCollectionProvider.notifier).update(
                        aiRequestModel: aiRequestModel.copyWith(
                          systemPrompt: value,
                        ),
                      );
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(kLabelUserPromptInput),
          ),
          kVSpacer10,
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: EnvironmentTriggerField(
                keyId: "$selectedId-aireq-userprompt-body",
                initialValue: userPrompt,
                expands: true,
                style: style,
                decoration: _promptDecoration(context, kHintEnterUserPrompt),
                onChanged: (String value) {
                  ref.read(activeCollectionProvider.notifier).update(
                        aiRequestModel: aiRequestModel.copyWith(
                          userPrompt: value,
                        ),
                      );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
