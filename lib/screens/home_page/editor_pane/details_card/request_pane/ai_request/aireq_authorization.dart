import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AIRequestAuthorizationSection extends ConsumerWidget {
  const AIRequestAuthorizationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final apiKey = ref.watch(selectedRequestModelProvider
        .select((value) => value?.aiRequestModel?.apiKey));
    final requestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(selectedId!);
    final aiReqM = requestModel?.aiRequestModel;
    if (aiReqM == null) {
      return kSizedBoxEmpty;
    }

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
                initialValue: apiKey,
                onChanged: (String value) {
                  ref
                      .read(collectionStateNotifierProvider.notifier)
                      .update(aiRequestModel: aiReqM.copyWith(apiKey: value));
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
