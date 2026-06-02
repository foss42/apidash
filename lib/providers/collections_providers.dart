import 'dart:async';

import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../services/services.dart';
import 'collection_providers.dart';

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
    state = {
      for (final id in collectionSequence) id: _placeholderCollection(id),
    };
    loadCollection(ref.read(selectedCollectionIdStateProvider));
  }

  final Ref ref;
  final WorkspaceStorage workspaceStorage;
  List<String> collectionSequence = [];
  final Set<String> _loadedCollectionIds = {};

  List<String> _readCollectionIds() {
    var collectionIds = workspaceStorage.getCollectionIds();
    if (collectionIds == null || collectionIds.isEmpty) {
      collectionIds = [kDefaultCollectionId];
      unawaited(workspaceStorage.setCollectionIds(collectionIds));
    }
    return [...collectionIds];
  }

  CollectionModel _placeholderCollection(String id) {
    return CollectionModel(
      id: id,
      name: id == kDefaultCollectionId ? kDefaultCollectionName : id,
    );
  }

  void loadCollection(String collectionId) {
    if (_loadedCollectionIds.contains(collectionId)) {
      return;
    }
    final json = workspaceStorage.getCollection(collectionId);
    final model = json != null
        ? CollectionModel.fromJson(Map<String, Object?>.from(json))
        : _placeholderCollection(collectionId);
    final onDisk = workspaceStorage.existingRequestIds(collectionId).toSet();
    _loadedCollectionIds.add(collectionId);
    state = {
      ...state!,
      collectionId: model.copyWith(
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
    final id = getNewUuid();
    final name = 'Collection ${state!.length + 1}';
    final model = CollectionModel(id: id, name: name);
    collectionSequence = [...collectionSequence, id];
    _loadedCollectionIds.add(id);
    state = {...state!, id: model};
    await workspaceStorage.setCollection(id, model.toJson());
    await workspaceStorage.setCollectionIds(collectionSequence);
    ref.read(expandedCollectionIdsProvider.notifier).update(
          (ids) => {...ids, id},
        );
    await ref
        .read(collectionStateNotifierProvider.notifier)
        .ensureActive(id);
  }

  void renameCollection(String id, String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty || state == null) {
      return;
    }
    loadCollection(id);
    state = {...state!, id: state![id]!.copyWith(name: trimmed)};
  }

  Future<void> deleteCollection(String id) async {
    if (state == null || collectionSequence.length <= 1) {
      return;
    }
    final wasActive = ref.read(selectedCollectionIdStateProvider) == id;
    collectionSequence = [...collectionSequence]..remove(id);
    _loadedCollectionIds.remove(id);
    state = {...state!}..remove(id);
    await workspaceStorage.setCollectionIds(collectionSequence);
    ref.read(expandedCollectionIdsProvider.notifier).update((s) => {...s}..remove(id));
    if (wasActive) {
      await ref
          .read(collectionStateNotifierProvider.notifier)
          .ensureActive(collectionSequence.first);
    }
    await workspaceStorage.deleteCollection(id);
  }

  Future<void> saveCollections() async {
    await workspaceStorage.setCollectionIds(collectionSequence);
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
