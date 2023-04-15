import 'package:apidash/providers/state_notifiers/collection_state_notifier.dart';
import 'package:apidash/providers/state_notifiers/theme_state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../services/services.dart';

final hiveHandler = HiveHandler();

final activeIdStateProvider = StateProvider<String?>((ref) => null);
final sentRequestIdStateProvider = StateProvider<String?>((ref) => null);
final codePaneVisibleStateProvider = StateProvider<bool>((ref) => false);
final saveDataStateProvider = StateProvider<bool>((ref) => false);
final clearDataStateProvider = StateProvider<bool>((ref) => false);

final activeRequestModelProvider = StateProvider<RequestModel?>((ref) {
  final activeId = ref.watch(activeIdStateProvider);
  final collection = ref.watch(collectionStateNotifierProvider);
  if (activeId == null || collection == null) {
    return null;
  }
  final idIdx = collection.indexWhere((m) => m.id == activeId);
  if (idIdx.isNegative) {
    return null;
  } else {
    return collection[idIdx];
  }
});

final darkModeProvider = StateNotifierProvider<ThemeStateNotifier, bool>(
    (ref) => ThemeStateNotifier(hiveHandler));

final collectionStateNotifierProvider =
    StateNotifierProvider<CollectionStateNotifier, List<RequestModel>?>(
        (ref) => CollectionStateNotifier(ref, hiveHandler));
