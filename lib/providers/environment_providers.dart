import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/file_utils.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../services/services.dart' show workspaceStorage, WorkspaceStorage;

final selectedEnvironmentIdStateProvider = StateProvider<String?>(
  (ref) => null,
);

final selectedEnvironmentModelProvider = StateProvider<EnvironmentModel?>((
  ref,
) {
  final selectedId = ref.watch(selectedEnvironmentIdStateProvider);
  final environments = ref.watch(environmentsStateNotifierProvider);
  return selectedId != null ? environments![selectedId] : null;
});

final activeEnvironmentModelProvider = StateProvider<EnvironmentModel?>((ref) {
  final activeId = ref.watch(activeEnvironmentIdStateProvider);
  final environments = ref.watch(environmentsStateNotifierProvider);
  if (activeId != null && environments != null) {
    return environments[activeId];
  }
  return null;
});

final availableEnvironmentVariablesStateProvider =
    StateProvider<Map<String, List<EnvironmentVariableModel>>>((ref) {
      Map<String, List<EnvironmentVariableModel>> result = {};
      final environments = ref.watch(environmentsStateNotifierProvider);
      final activeEnviormentId = ref.watch(activeEnvironmentIdStateProvider);
      if (activeEnviormentId != null) {
        result[activeEnviormentId] =
            environments?[activeEnviormentId]?.values
                .where((element) => element.enabled)
                .toList() ??
            [];
      }
      result[kGlobalEnvironmentId] =
          environments?[kGlobalEnvironmentId]?.values
              .where((element) => element.enabled)
              .toList() ??
          [];
      return result;
    });

final environmentSequenceProvider = StateProvider<List<String>>((ref) {
  var ids = workspaceStorage.getEnvironmentIds();
  return ids ?? [kGlobalEnvironmentId];
});

final StateNotifierProvider<
  EnvironmentsStateNotifier,
  Map<String, EnvironmentModel>?
>
environmentsStateNotifierProvider = StateNotifierProvider(
  (ref) => EnvironmentsStateNotifier(ref, workspaceStorage),
);

class EnvironmentsStateNotifier
    extends StateNotifier<Map<String, EnvironmentModel>?> {
  EnvironmentsStateNotifier(this.ref, this.workspaceStorage) : super(null) {
    var status = loadEnvironments();
    Future.microtask(() {
      if (status) {
        ref.read(environmentSequenceProvider.notifier).state = [...state!.keys];
      }
      ref.read(selectedEnvironmentIdStateProvider.notifier).state =
          kGlobalEnvironmentId;
    });
  }

  final Ref ref;
  final WorkspaceStorage workspaceStorage;

  bool loadEnvironments() {
    List<String>? environmentIds = workspaceStorage.getEnvironmentIds();
    if (environmentIds == null || environmentIds.isEmpty) {
      const globalEnvironment = EnvironmentModel(
        id: kGlobalEnvironmentId,
        name: "Global",
        values: [],
      );
      state = {kGlobalEnvironmentId: globalEnvironment};
      return false;
    } else {
      Map<String, EnvironmentModel> environmentsMap = {};
      for (var environmentId in environmentIds) {
        var jsonModel = workspaceStorage.getEnvironment(environmentId);
        if (jsonModel != null) {
          var jsonMap = Map<String, Object?>.from(jsonModel);
          var environmentModelFromJson = EnvironmentModel.fromJson(jsonMap);

          EnvironmentModel environmentModel = EnvironmentModel(
            id: environmentModelFromJson.id,
            name: environmentModelFromJson.name,
            values: environmentModelFromJson.values,
          );
          environmentsMap[environmentId] = environmentModel;
        }
      }
      state = environmentsMap;
      return true;
    }
  }

  void addEnvironment() {
    final id = getNewUuid();
    final newEnvironmentModel = EnvironmentModel(id: id, values: []);
    state = {...state!, id: newEnvironmentModel};
    ref
        .read(environmentSequenceProvider.notifier)
        .update((state) => [...state, id]);
    ref.read(selectedEnvironmentIdStateProvider.notifier).state =
        newEnvironmentModel.id;
  }

  void updateEnvironment(
    String id, {
    String? name,
    List<EnvironmentVariableModel>? values,
  }) {
    final environment = state![id]!;
    final updatedEnvironment = environment.copyWith(
      name: name ?? environment.name,
      values: values ?? environment.values,
    );
    state = {...state!, id: updatedEnvironment};
  }

  void duplicateEnvironment(String id) {
    final newId = getNewUuid();
    final environment = state![id]!;

    final newEnvironment = environment.copyWith(
      id: newId,
      name: "${environment.name} Copy",
    );

    var environmentIds = ref.read(environmentSequenceProvider);
    final idx = environmentIds.indexOf(id);
    environmentIds.insert(idx + 1, newId);

    state = {...state!, newId: newEnvironment};

    ref
        .read(environmentSequenceProvider.notifier)
        .update((state) => [...environmentIds]);
    ref.read(selectedEnvironmentIdStateProvider.notifier).state = newId;
  }

  void removeEnvironment(String id) {
    final environmentIds = ref.read(environmentSequenceProvider);
    final idx = environmentIds.indexOf(id);
    environmentIds.remove(id);
    ref.read(environmentSequenceProvider.notifier).state = [...environmentIds];

    String? newId;
    if (idx == 0 && environmentIds.isNotEmpty) {
      newId = environmentIds[0];
    } else if (idx > 0) {
      newId = environmentIds[idx - 1];
    } else {
      newId = kGlobalEnvironmentId;
    }

    ref.read(selectedEnvironmentIdStateProvider.notifier).state = newId;

    state = {...state!}..remove(id);

  }

  void reorder(int oldIdx, int newIdx) {
    final environmentIds = ref.read(environmentSequenceProvider);
    final id = environmentIds.removeAt(oldIdx);
    environmentIds.insert(newIdx, id);
    ref.read(environmentSequenceProvider.notifier).state = [...environmentIds];
  }

  Future<void> saveEnvironments() async {
    ref.read(saveDataStateProvider.notifier).state = true;
    final environmentIds = ref.read(environmentSequenceProvider);
    await workspaceStorage.setEnvironmentIds(environmentIds);
    for (var environmentId in environmentIds) {
      var environment = state![environmentId]!;
      await workspaceStorage.setEnvironment(environmentId, environment.toJson());
    }
    final collectionId = ref.read(selectedCollectionIdStateProvider);
    await workspaceStorage.removeUnused(collectionId);
    ref.read(saveDataStateProvider.notifier).state = false;
    ref.read(hasUnsavedChangesProvider.notifier).state = false;
  }
}
