import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/utils/file_utils.dart';
import 'package:apidash_core/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedAIRequestTypeProvider = StateProvider<AIVerb?>((ref) => null);
final aiRequestCollection =
    StateProvider<Map<String, AIRequestModel>>((ref) => {});

class AIRequestModel {
  final String id;
  final AIVerb aiVerb;

  AIRequestModel({
    required this.id,
    required this.aiVerb,
  });
}

final selectedAIRequestModelProvider = StateProvider<AIRequestModel?>((ref) {
  final selectedId = ref.watch(selectedIdStateProvider);
  final collection = ref.watch(aiRequestCollection);
  if (selectedId == null || collection.isEmpty) {
    return null;
  } else {
    return collection[selectedId];
  }
});
