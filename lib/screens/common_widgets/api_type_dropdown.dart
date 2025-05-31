import 'package:apidash/models/llm_models/google/gemini_20_flash.dart';
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
          //Setting Default Model
          final eD = ref
              .read(collectionStateNotifierProvider.select(
                  (value) => value![ref.read(selectedIdStateProvider)!]))!
              .extraDetails;
          ref.read(collectionStateNotifierProvider.notifier).update(
            extraDetails: {
              ...eD,
              'model': Gemini20FlashModel() //DEFAULT_MODEL
            },
          );
        }
      },
    );
  }
}
