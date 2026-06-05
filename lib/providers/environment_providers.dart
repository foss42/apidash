import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/file_utils.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../services/services.dart'
    show environmentSecretsStorage, workspaceStorage, WorkspaceStorage;

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
    Future.microtask(() async {
      final status = await loadEnvironments();
      if (status) {
        ref.read(environmentSequenceProvider.notifier).state = [...state!.keys];
      }
      ref.read(selectedEnvironmentIdStateProvider.notifier).state =
          kGlobalEnvironmentId;
    });
  }

  final Ref ref;
  final WorkspaceStorage workspaceStorage;

  String get _workspacePath => workspaceStorage.rootPath;

  Future<List<EnvironmentVariableModel>> _hydrateSecretValues(
    String environmentId,
    List<EnvironmentVariableModel> values,
  ) async {
    final hydrated = <EnvironmentVariableModel>[];
    for (final variable in values) {
      if (variable.type != EnvironmentVariableType.secret ||
          variable.key.isEmpty) {
        hydrated.add(variable);
        continue;
      }

      final storedValue = await environmentSecretsStorage.readSecret(
        _workspacePath,
        environmentId,
        variable.key,
      );

      hydrated.add(variable.copyWith(value: storedValue ?? ''));
    }
    return hydrated;
  }

  Future<void> persistSecretValue(
    String environmentId,
    String variableKey,
    String value,
  ) {
    return environmentSecretsStorage.writeSecret(
      _workspacePath,
      environmentId,
      variableKey,
      value,
    );
  }

  Future<void> removeSecretValue(
    String environmentId,
    String variableKey,
  ) {
    return environmentSecretsStorage.deleteSecret(
      _workspacePath,
      environmentId,
      variableKey,
    );
  }

  Future<void> _cleanupRemovedSecrets(
    String environmentId,
    EnvironmentModel environment,
  ) async {
    final oldJson = workspaceStorage.getEnvironment(environmentId);
    if (oldJson == null) {
      return;
    }
    final oldEnvironment = EnvironmentModel.fromJson(
      Map<String, Object?>.from(oldJson),
    );
    final currentSecretKeys = environment.values
        .where(
          (v) =>
              v.type == EnvironmentVariableType.secret && v.key.isNotEmpty,
        )
        .map((v) => v.key)
        .toSet();
    for (final oldVariable in oldEnvironment.values) {
      if (oldVariable.type == EnvironmentVariableType.secret &&
          oldVariable.key.isNotEmpty &&
          !currentSecretKeys.contains(oldVariable.key)) {
        await environmentSecretsStorage.deleteSecret(
          _workspacePath,
          environmentId,
          oldVariable.key,
        );
      }
    }
  }

  EnvironmentModel _stripSecretsForDisk(EnvironmentModel environment) {
    return environment.copyWith(
      values: environment.values
          .map(
            (variable) => variable.type == EnvironmentVariableType.secret
                ? variable.copyWith(value: '')
                : variable,
          )
          .toList(),
    );
  }

  Future<bool> loadEnvironments() async {
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
          final hydratedValues = await _hydrateSecretValues(
            environmentId,
            environmentModelFromJson.values,
          );

          EnvironmentModel environmentModel = EnvironmentModel(
            id: environmentModelFromJson.id,
            name: environmentModelFromJson.name,
            values: hydratedValues,
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

    Future.microtask(() async {
      for (final variable in newEnvironment.values) {
        if (variable.type == EnvironmentVariableType.secret &&
            variable.key.isNotEmpty) {
          await environmentSecretsStorage.writeSecret(
            _workspacePath,
            newId,
            variable.key,
            variable.value,
          );
        }
      }
    });
  }

  void removeEnvironment(String id) {
    final environment = state![id];
    final secretKeys = environment?.values
            .where(
              (v) =>
                  v.type == EnvironmentVariableType.secret && v.key.isNotEmpty,
            )
            .map((v) => v.key)
            .toList() ??
        [];

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

    Future.microtask(() {
      environmentSecretsStorage.deleteAllForEnvironment(
        _workspacePath,
        id,
        secretKeys,
      );
    });
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
      for (final variable in environment.values) {
        if (variable.type == EnvironmentVariableType.secret &&
            variable.key.isNotEmpty) {
          await environmentSecretsStorage.writeSecret(
            _workspacePath,
            environmentId,
            variable.key,
            variable.value,
          );
        }
      }
      await _cleanupRemovedSecrets(environmentId, environment);
      await workspaceStorage.setEnvironment(
        environmentId,
        _stripSecretsForDisk(environment).toJson(),
      );
    }
    final collectionId = ref.read(selectedCollectionIdStateProvider);
    await workspaceStorage.removeUnused(collectionId);
    ref.read(saveDataStateProvider.notifier).state = false;
    ref.read(hasUnsavedChangesProvider.notifier).state = false;
  }
}
