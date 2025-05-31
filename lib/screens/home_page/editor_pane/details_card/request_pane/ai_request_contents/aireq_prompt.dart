import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/widgets/editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AIRequestPromptSection extends ConsumerWidget {
  const AIRequestPromptSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final reqDetails = ref
        .watch(collectionStateNotifierProvider
            .select((value) => value![ref.read(selectedIdStateProvider)!]))!
        .extraDetails;

    final systemPrompt = reqDetails['system_prompt'];
    final userPrompt = reqDetails['user_prompt'];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFieldEditor(
                key: Key("$selectedId-aireq-sysprompt-body"),
                fieldKey: "$selectedId-aireq-sysprompt-body",
                initialValue: systemPrompt,
                onChanged: (String value) {
                  ref.read(collectionStateNotifierProvider.notifier).update(
                    extraDetails: {...reqDetails, 'system_prompt': value},
                  );
                },
                hintText: 'Enter System Prompt',
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFieldEditor(
                key: Key("aireq-userprompt-body"),
                fieldKey: "aireq-userprompt-body",
                initialValue: userPrompt,
                onChanged: (String value) {
                  ref.read(collectionStateNotifierProvider.notifier).update(
                    extraDetails: {...reqDetails, 'user_prompt': value},
                  );
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
