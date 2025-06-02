import 'package:apidash/models/llm_models/all_models.dart';
import 'package:apidash/models/llm_models/google/gemini_20_flash.dart';
import 'package:apidash/models/llm_models/llm_model.dart';
import 'package:apidash_core/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';

class APITypeDropdown extends ConsumerWidget {
  const APITypeDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIdStateProvider);
    final apiType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.apiType));
    return APITypePopupMenu(
      apiType: apiType,
      onChanged: (type) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(apiType: type);

        if (type == APIType.ai) {
          //-------------------Setting Default Model--------------------
          final eD = ref
              .read(collectionStateNotifierProvider.select(
                  (value) => value![ref.read(selectedIdStateProvider)!]))!
              .extraDetails;

          final cDm = ref.read(settingsProvider).defaultLLMProvider;
          LLMModel? defaultModel;
          String? authCred;
          if (cDm.isEmpty) {
            defaultModel = Gemini20FlashModel(); //DEFAULT_MODEL
          } else {
            authCred = ref.read(settingsProvider).defaultLLMProviderCredentials;
            defaultModel = getLLMModelFromID(cDm)!;
          }
          //-------------------Setting Default Model--------------------
          ref.read(collectionStateNotifierProvider.notifier).update(
            extraDetails: {
              ...eD,
              'model': defaultModel,
              if (authCred != null) ...{
                'authorization_credential': authCred,
              }
            },
          );
          // Update the Internal URL to Model URL
          ref
              .read(collectionStateNotifierProvider.notifier)
              .update(url: defaultModel.specifics.endpoint);
          // print('setting url -> ${defaultModel.specifics.endpoint}');
        }
      },
    );
  }
}
