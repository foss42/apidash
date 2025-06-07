import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/widgets/editor.dart';
import 'package:apidash_core/models/ai_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AIRequestAuthorizationSection extends ConsumerWidget {
  const AIRequestAuthorizationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final reqM = ref.read(collectionStateNotifierProvider)![selectedId]!;
    final aiReqM = reqM.genericRequestModel!.aiRequestModel!;
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
                key: Key("$selectedId-aireq-authvalue-body"),
                fieldKey: "$selectedId-aireq-authvalue-body",
                initialValue: cred,
                onChanged: (String value) {
                  final aim = ref
                      .read(collectionStateNotifierProvider)![selectedId]!
                      .genericRequestModel!
                      .aiRequestModel!;
                  aim.payload.credential = value;
                  ref
                      .read(collectionStateNotifierProvider.notifier)
                      .update(aiRequestModel: aim.updatePayload(aim.payload));
                },
                hintText: 'Enter API key or Authorization Credentials',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
