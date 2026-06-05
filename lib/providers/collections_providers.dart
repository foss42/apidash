import 'dart:async';

import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../services/services.dart';
import 'collection_providers.dart';

final selectedCollectionIdStateProvider = StateProvider<String>((ref) {
  final index = workspaceStorage.getCollectionsIndex();
  if (index.isNotEmpty) {
    return index.first.id;
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
    final index = _readCollectionsIndex();
    collectionSequence = index.map((e) => e.id).toList();
    state = {
      for (final entry in index)
        entry.id: CollectionModel(id: entry.id, name: entry.name),
    };
    loadCollection(ref.read(selectedCollectionIdStateProvider));
  }

  final Ref ref;
  final WorkspaceStorage workspaceStorage;
  List<String> collectionSequence = [];
  final Set<String> _loadedCollectionIds = {};

  List<({String id, String name})> _readCollectionsIndex() {
    var index = workspaceStorage.getCollectionsIndex();
    if (index.isEmpty) {
      index = [(id: kDefaultCollectionId, name: kDefaultCollectionName)];
      unawaited(workspaceStorage.setCollectionsIndex(index));
    }
    return index;
  }

  Future<void> _persistIndex() async {
    await workspaceStorage.setCollectionsIndex([
      for (final id in collectionSequence)
        (id: id, name: state![id]!.name),
    ]);
  }

  void loadCollection(String collectionId) {
    if (_loadedCollectionIds.contains(collectionId)) {
      return;
    }
    final json = workspaceStorage.getCollection(collectionId);
    final catalogName = state![collectionId]!.name;
    final model = json != null
        ? CollectionModel.fromJson(Map<String, Object?>.from(json))
        : CollectionModel(id: collectionId, name: catalogName);
    final onDisk = workspaceStorage.existingRequestIds(collectionId).toSet();
    _loadedCollectionIds.add(collectionId);
    state = {
      ...state!,
      collectionId: model.copyWith(
        name: catalogName,
        requests: model.requests.where((r) => onDisk.contains(r.id)).toList(),
      ),
    };
  }

  void syncRequests(String collectionId, List<RequestSummary> requests) {
    if (state == null || !state!.containsKey(collectionId)) {
      return;
    }
    _loadedCollectionIds.add(collectionId);
    state = {
      ...state!,
      collectionId: state![collectionId]!.copyWith(requests: requests),
    };
  }

  Future<void> addCollection() async {
    final name = 'Collection ${state!.length + 1}';
    final id = makeStorageId(name);
    final model = CollectionModel(id: id, name: name);
    collectionSequence = [...collectionSequence, id];
    _loadedCollectionIds.add(id);
    state = {...state!, id: model};
    await workspaceStorage.setCollection(id, model.toJson());
    await _persistIndex();
    ref.read(expandedCollectionIdsProvider.notifier).update(
          (ids) => {...ids, id},
        );
    await ref
        .read(collectionStateNotifierProvider.notifier)
        .ensureActive(id);
  }

  Future<void> renameCollection(String id, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty || state == null) {
      return;
    }
    final newId = renameStorageId(id, trimmed);
    if (newId == id) {
      state = {...state!, id: state![id]!.copyWith(name: trimmed)};
      await _persistIndex();
      return;
    }

    await workspaceStorage.renameCollection(id, newId);

    final model = CollectionModel(
      id: newId,
      name: trimmed,
      requests: state![id]!.requests,
    );
    final seqIdx = collectionSequence.indexOf(id);
    collectionSequence = [...collectionSequence];
    collectionSequence[seqIdx] = newId;
    _loadedCollectionIds.remove(id);
    _loadedCollectionIds.add(newId);

    state = {...state!}..remove(id);
    state![newId] = model;

    if (ref.read(selectedCollectionIdStateProvider) == id) {
      ref.read(selectedCollectionIdStateProvider.notifier).state = newId;
    }
    ref.read(expandedCollectionIdsProvider.notifier).update((expanded) {
      final next = {...expanded};
      if (next.remove(id)) {
        next.add(newId);
      }
      return next;
    });

    await _persistIndex();
  }

  Future<void> deleteCollection(String id) async {
    if (state == null || collectionSequence.length <= 1) {
      return;
    }
    final wasActive = ref.read(selectedCollectionIdStateProvider) == id;
    collectionSequence = [...collectionSequence]..remove(id);
    _loadedCollectionIds.remove(id);
    state = {...state!}..remove(id);
    await _persistIndex();
    ref.read(expandedCollectionIdsProvider.notifier).update((s) => {...s}..remove(id));
    if (wasActive) {
      await ref
          .read(collectionStateNotifierProvider.notifier)
          .ensureActive(collectionSequence.first);
    }
    await workspaceStorage.deleteCollection(id);
  }

  Future<void> saveCollections() async {
    await _persistIndex();
    final activeId = ref.read(selectedCollectionIdStateProvider);
    final activeSequence = ref.read(requestSequenceProvider);
    final collectionNotifier =
        ref.read(collectionStateNotifierProvider.notifier);
    for (final entry in state!.entries) {
      if (!_loadedCollectionIds.contains(entry.key)) {
        continue;
      }
      final onDisk = workspaceStorage.existingRequestIds(entry.key).toSet();
      final requests = entry.key == activeId
          ? collectionNotifier.summariesForSequence(entry.key, activeSequence)
          : entry.value.requests.where((r) => onDisk.contains(r.id)).toList();
      if (entry.key == activeId) {
        syncRequests(activeId, requests);
      }
      final model = entry.value.copyWith(requests: requests);
      await workspaceStorage.setCollection(entry.key, model.toJson());
      if (entry.key != activeId) {
        state = {...state!, entry.key: model};
      }
    }
  }
}
