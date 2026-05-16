import 'dart:async';

import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/file_utils.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../services/services.dart' show fileSystemHandler, FileSystemHandler;

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
  var ids = fileSystemHandler.getEnvironmentIds();
  return ids ?? [kGlobalEnvironmentId];
});

final StateNotifierProvider<
  EnvironmentsStateNotifier,
  Map<String, EnvironmentModel>?
>
environmentsStateNotifierProvider = StateNotifierProvider(
  (ref) {
    final notifier = EnvironmentsStateNotifier(ref, fileSystemHandler);
    ref.onDispose(notifier.cancelEnvironmentAutosaveTimer);
    return notifier;
  },
);

class EnvironmentsStateNotifier
    extends StateNotifier<Map<String, EnvironmentModel>?> {
  EnvironmentsStateNotifier(this.ref, this.fileSystemHandler) : super(null) {
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
  final FileSystemHandler fileSystemHandler;

  Timer? _envAutosaveTimer;

  void cancelEnvironmentAutosaveTimer() {
    _envAutosaveTimer?.cancel();
    _envAutosaveTimer = null;
  }

  void _scheduleEnvironmentAutosave() {
    ref.read(hasUnsavedChangesProvider.notifier).state = true;
    _envAutosaveTimer?.cancel();
    _envAutosaveTimer = Timer(kAutosaveDebounce, () {
      unawaited(_persistEnvironmentsDebounced());
    });
  }

  Future<void> _persistEnvironmentsDebounced() async {
    if (state == null) return;
    ref.read(saveDataStateProvider.notifier).state = true;
    try {
      final environmentIds = ref.read(environmentSequenceProvider);
      await fileSystemHandler.setEnvironmentIds(environmentIds);
      for (final environmentId in environmentIds) {
        await fileSystemHandler.setEnvironment(
          environmentId,
          state![environmentId]!.toJson(),
        );
      }
    } finally {
      ref.read(saveDataStateProvider.notifier).state = false;
    }
    ref.read(hasUnsavedChangesProvider.notifier).state = false;
  }

  bool loadEnvironments() {
    List<String>? environmentIds = fileSystemHandler.getEnvironmentIds();
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
        var jsonModel = fileSystemHandler.getEnvironment(environmentId);
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
    _scheduleEnvironmentAutosave();
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
    _scheduleEnvironmentAutosave();
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
    _scheduleEnvironmentAutosave();
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

    _scheduleEnvironmentAutosave();
  }

  void reorder(int oldIdx, int newIdx) {
    final environmentIds = ref.read(environmentSequenceProvider);
    final id = environmentIds.removeAt(oldIdx);
    environmentIds.insert(newIdx, id);
    ref.read(environmentSequenceProvider.notifier).state = [...environmentIds];
    _scheduleEnvironmentAutosave();
  }

  Future<void> saveEnvironments() async {
    cancelEnvironmentAutosaveTimer();
    if (state == null) return;
    ref.read(saveDataStateProvider.notifier).state = true;
    try {
      final environmentIds = ref.read(environmentSequenceProvider);
      await fileSystemHandler.setEnvironmentIds(environmentIds);
      for (var environmentId in environmentIds) {
        var environment = state![environmentId]!;
        await fileSystemHandler.setEnvironment(environmentId, environment.toJson());
      }
      await fileSystemHandler.removeUnused();
    } finally {
      ref.read(saveDataStateProvider.notifier).state = false;
    }
    ref.read(hasUnsavedChangesProvider.notifier).state = false;
  }

  /// Replaces/merges environments from a Git collection import.
  /// For MVP we merge remote values into existing ones, while keeping any
  /// locally existing environments that are not present in the remote.
  Future<void> importEnvironmentsFromGit({
    required Map<String, EnvironmentModel> environmentsById,
    required List<String> environmentOrder,
  }) async {
    cancelEnvironmentAutosaveTimer();
    final current = state ?? {};

    // Ensure global environment always exists (many parts assume it).
    final merged = <String, EnvironmentModel>{
      ...current,
      ...environmentsById,
    };
    merged.putIfAbsent(
      kGlobalEnvironmentId,
      () => const EnvironmentModel(id: kGlobalEnvironmentId, name: "Global", values: []),
    );

    final remoteIds = environmentOrder.where(merged.containsKey).toList();
    final currentIds = ref.read(environmentSequenceProvider);

    final mergedOrder = <String>[
      ...remoteIds,
      ...currentIds.where((id) => !remoteIds.contains(id)).where(merged.containsKey),
    ];

    state = merged;
    ref.read(environmentSequenceProvider.notifier).state = mergedOrder;
    ref.read(hasUnsavedChangesProvider.notifier).state = false;
    ref.read(saveDataStateProvider.notifier).state = true;

    await fileSystemHandler.setEnvironmentIds(mergedOrder);
    for (final id in mergedOrder) {
      await fileSystemHandler.setEnvironment(id, merged[id]!.toJson());
    }
    await fileSystemHandler.removeUnused();

    ref.read(saveDataStateProvider.notifier).state = false;
    ref.read(hasUnsavedChangesProvider.notifier).state = false;
  }
}
