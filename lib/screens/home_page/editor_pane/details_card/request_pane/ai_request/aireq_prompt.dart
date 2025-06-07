import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/widgets/editor.dart';
import 'package:apidash_core/models/ai_request_model.dart';
import 'package:apidash_design_system/tokens/measurements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AIRequestPromptSection extends ConsumerWidget {
  const AIRequestPromptSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final reqM = ref.read(collectionStateNotifierProvider)![selectedId]!;
    final aiReqM = reqM.genericRequestModel!.aiRequestModel!;
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
              style: TextStyle(color: Colors.white54),
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
                  final aim = ref
                      .read(collectionStateNotifierProvider)![selectedId]!
                      .genericRequestModel!
                      .aiRequestModel!;
                  aim.payload.systemPrompt = value;
                  ref
                      .read(collectionStateNotifierProvider.notifier)
                      .update(aiRequestModel: aim.updatePayload(aim.payload));
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
              style: TextStyle(color: Colors.white54),
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
                  final aim = ref
                      .read(collectionStateNotifierProvider)![selectedId]!
                      .genericRequestModel!
                      .aiRequestModel!;
                  aim.payload.userPrompt = value;
                  ref
                      .read(collectionStateNotifierProvider.notifier)
                      .update(aiRequestModel: aim.updatePayload(aim.payload));
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
