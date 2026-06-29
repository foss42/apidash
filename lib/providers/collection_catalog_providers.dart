import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../services/services.dart';
import 'active_collection_providers.dart';

final selectedCollectionIdStateProvider = StateProvider<String?>((ref) {
  final index = workspaceStorage.getCollectionsIndex();
  if (index.isNotEmpty) {
    return index.first.id;
  }
  return null;
});

final collectionSequenceProvider = Provider<List<String>>((ref) {
  ref.watch(collectionCatalogProvider);
  return ref.read(collectionCatalogProvider.notifier).collectionSequence;
});

final requestSequenceProvider = StateProvider<List<String>>((ref) => []);

final expandedCollectionIdsProvider = StateProvider<Set<String>>((ref) => {});

final StateNotifierProvider<CollectionCatalogNotifier, Map<String, CollectionModel>?>
collectionCatalogProvider = StateNotifierProvider(
  (ref) => CollectionCatalogNotifier(ref, workspaceStorage),
);

class CollectionCatalogNotifier
    extends StateNotifier<Map<String, CollectionModel>?> {
  CollectionCatalogNotifier(this.ref, this.workspaceStorage) : super(null) {
    final index = _readCollectionsIndex();
    collectionSequence = index.map((e) => e.id).toList();
    state = {
      for (final entry in index)
        entry.id: CollectionModel(id: entry.id, name: entry.name),
    };
    final active = ref.read(selectedCollectionIdStateProvider);
    if (active != null) {
      loadCollection(active);
    }
  }

  final Ref ref;
  final WorkspaceStorage workspaceStorage;
  List<String> collectionSequence = [];
  final Set<String> _loadedCollectionIds = {};

  List<({String id, String name})> _readCollectionsIndex() {
    return workspaceStorage.getCollectionsIndex();
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
    final requests = model.requests
        .where((r) => workspaceStorage.requestExistsOnDisk(collectionId, r.id))
        .toList();
    _loadedCollectionIds.add(collectionId);
    state = {
      ...state!,
      collectionId: model.copyWith(
        name: catalogName,
        requests: requests,
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

  bool _isCollectionIdTaken(String id, {String? excludeId}) {
    final target = id.toLowerCase();
    for (final existing in collectionSequence) {
      if (existing == excludeId) {
        continue;
      }
      if (existing.toLowerCase() == target) {
        return true;
      }
    }
    return false;
  }

  Future<void> addCollection() async {
    var next = state!.length + 1;
    var name = 'Collection $next';
    while (_isCollectionIdTaken(makeCollectionId(name))) {
      next++;
      name = 'Collection $next';
    }
    final id = makeCollectionId(name);
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
        .read(activeCollectionProvider.notifier)
        .ensureActive(id);
  }

  Future<bool> renameCollection(String id, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty ||
        state == null ||
        !state!.containsKey(id) ||
        collectionNameHasIllegalChars(trimmed)) {
      return false;
    }
    final newId = makeCollectionId(trimmed);
    if (newId == id) {
      state = {...state!, id: state![id]!.copyWith(name: trimmed)};
      await _persistIndex();
      return true;
    }
    if (_isCollectionIdTaken(newId, excludeId: id)) {
      return false;
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
    return true;
  }

  Future<void> deleteCollection(String id) async {
    if (state == null || !state!.containsKey(id)) {
      return;
    }
    final wasActive = ref.read(selectedCollectionIdStateProvider) == id;
    collectionSequence = [...collectionSequence]..remove(id);
    _loadedCollectionIds.remove(id);
    state = {...state!}..remove(id);
    ref.read(expandedCollectionIdsProvider.notifier).update((s) => {...s}..remove(id));
    await workspaceStorage.deleteCollection(id);
    await _persistIndex();

    if (wasActive) {
      final nextId =
          collectionSequence.isNotEmpty ? collectionSequence.first : null;
      await ref
          .read(activeCollectionProvider.notifier)
          .ensureActive(nextId);
    }
  }

  Future<void> saveCollections() async {
    await _persistIndex();
    final activeId = ref.read(selectedCollectionIdStateProvider);
    final activeSequence = ref.read(requestSequenceProvider);
    final collectionNotifier =
        ref.read(activeCollectionProvider.notifier);
    for (final entry in state!.entries) {
      if (!_loadedCollectionIds.contains(entry.key)) {
        continue;
      }

      final requests = entry.key == activeId
          ? collectionNotifier.summariesForSequence(entry.key, activeSequence)
          : entry.value.requests
              .where((r) =>
                  workspaceStorage.requestExistsOnDisk(entry.key, r.id))
              .toList();
      if (entry.key == activeId) {
        syncRequests(entry.key, requests);
      }
      final model = entry.value.copyWith(requests: requests);
      await workspaceStorage.setCollection(entry.key, model.toJson());
      if (entry.key != activeId) {
        state = {...state!, entry.key: model};
      }
    }
  }
}
