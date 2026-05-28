import 'dart:async';

import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../services/services.dart';

final selectedCollectionIdStateProvider = StateProvider<String>((ref) {
  final ids = workspaceStorage.getCollectionIds();
  if (ids != null && ids.isNotEmpty) {
    return ids.first;
  }
  return kDefaultCollectionId;
});

final collectionSequenceProvider = Provider<List<String>>((ref) {
  ref.watch(collectionsStateNotifierProvider);
  return ref.read(collectionsStateNotifierProvider.notifier).collectionSequence;
});

final requestSequenceProvider = StateProvider<List<String>>((ref) => []);

final expandedCollectionIdsProvider = StateProvider<Set<String>>((ref) => {});

final StateNotifierProvider<CollectionsStateNotifier, Map<String, CollectionModel>?>
collectionsStateNotifierProvider = StateNotifierProvider(
  (ref) => CollectionsStateNotifier(ref, workspaceStorage),
);

class CollectionsStateNotifier
    extends StateNotifier<Map<String, CollectionModel>?> {
  CollectionsStateNotifier(this.ref, this.workspaceStorage) : super(null) {
    collectionSequence = _readCollectionIds();
    state = _readCollectionsMap(collectionSequence);
  }

  final Ref ref;
  final WorkspaceStorage workspaceStorage;
  List<String> collectionSequence = [];

  List<String> _readCollectionIds() {
    var collectionIds = workspaceStorage.getCollectionIds();
    if (collectionIds == null || collectionIds.isEmpty) {
      collectionIds = [kDefaultCollectionId];
      unawaited(workspaceStorage.setCollectionIds(collectionIds));
    }
    return [...collectionIds];
  }

  Map<String, CollectionModel> _readCollectionsMap(List<String> collectionIds) {
    final map = <String, CollectionModel>{};
    for (final id in collectionIds) {
      final json = workspaceStorage.getCollection(id);
      if (json != null) {
        map[id] = CollectionModel.fromJson(Map<String, Object?>.from(json));
      } else {
        map[id] = CollectionModel(
          id: id,
          name: id == kDefaultCollectionId ? kDefaultCollectionName : id,
          requestIds: workspaceStorage.getIds(id) ?? [],
        );
      }
    }
    return map;
  }

  void syncRequestIds(String collectionId, List<String> requestIds) {
    if (state == null || !state!.containsKey(collectionId)) {
      return;
    }
    state = {
      ...state!,
      collectionId: state![collectionId]!.copyWith(requestIds: requestIds),
    };
  }

  void addCollection() {
    final id = getNewUuid();
    final name = 'Collection ${state!.length + 1}';
    final model = CollectionModel(id: id, name: name, requestIds: []);
    collectionSequence = [...collectionSequence, id];
    state = {...state!, id: model};
    unawaited(workspaceStorage.setCollection(id, model.toJson()));
    unawaited(workspaceStorage.setCollectionIds(collectionSequence));
    ref.read(selectedCollectionIdStateProvider.notifier).state = id;
  }

  void renameCollection(String id, String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty || state == null) {
      return;
    }
    state = {...state!, id: state![id]!.copyWith(name: trimmed)};
  }

  Future<void> deleteCollection(String id) async {
    if (state == null || collectionSequence.length <= 1) {
      return;
    }
    collectionSequence = [...collectionSequence]..remove(id);
    state = {...state!}..remove(id);
    await workspaceStorage.deleteCollection(id);
    await workspaceStorage.setCollectionIds(collectionSequence);
    ref.read(expandedCollectionIdsProvider.notifier).update((s) => {...s}..remove(id));
    if (ref.read(selectedCollectionIdStateProvider) == id) {
      ref.read(selectedCollectionIdStateProvider.notifier).state =
          collectionSequence.first;
    }
  }

  Future<void> saveCollections() async {
    await workspaceStorage.setCollectionIds(collectionSequence);
    final activeId = ref.read(selectedCollectionIdStateProvider);
    syncRequestIds(activeId, ref.read(requestSequenceProvider));
    for (final entry in state!.entries) {
      await workspaceStorage.setCollection(entry.key, entry.value.toJson());
    }
  }
}
