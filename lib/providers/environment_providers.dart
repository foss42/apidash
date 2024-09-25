import 'package:apidash/consts.dart';
import 'package:apidash/models/environment_model.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/file_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/services.dart' show hiveHandler, HiveHandler;

final selectedEnvironmentIdStateProvider =
    StateProvider<String?>((ref) => null);

final selectedEnvironmentModelProvider =
    StateProvider<EnvironmentModel?>((ref) {
  final selectedId = ref.watch(selectedEnvironmentIdStateProvider);
  final environments = ref.watch(environmentsStateNotifierProvider);
  return selectedId != null ? environments![selectedId] : null;
});

final availableEnvironmentVariablesStateProvider =
    StateProvider<Map<String, List<EnvironmentVariableModel>>>((ref) {
  Map<String, List<EnvironmentVariableModel>> result = {};
  final environments = ref.watch(environmentsStateNotifierProvider);
  final activeEnviormentId = ref.watch(activeEnvironmentIdStateProvider);
  if (activeEnviormentId != null) {
    result[activeEnviormentId] = environments?[activeEnviormentId]
            ?.values
            .where((element) => element.enabled)
            .toList() ??
        [];
  }
  result[kGlobalEnvironmentId] = environments?[kGlobalEnvironmentId]
          ?.values
          .where((element) => element.enabled)
          .toList() ??
      [];
  return result;
});

final StateNotifierProvider<EnvironmentsStateNotifier,
        Map<String, EnvironmentModel>?> environmentsStateNotifierProvider =
    StateNotifierProvider((ref) => EnvironmentsStateNotifier(ref, hiveHandler));

final environmentSequenceProvider = StateProvider<List<String>>((ref) {
  var ids = hiveHandler.getEnvironmentIds();
  return ids ?? [kGlobalEnvironmentId];
});

class EnvironmentsStateNotifier
    extends StateNotifier<Map<String, EnvironmentModel>?> {
  EnvironmentsStateNotifier(this.ref, this.hiveHandler) : super(null) {
    var status = loadEnvironments();
    Future.microtask(() {
      if (status) {
        ref.read(environmentSequenceProvider.notifier).state = [
          ...state!.keys,
        ];
      }
      ref.read(selectedEnvironmentIdStateProvider.notifier).state =
          kGlobalEnvironmentId;
    });
  }

  final Ref ref;
  final HiveHandler hiveHandler;

  bool loadEnvironments() {
    List<String>? environmentIds = hiveHandler.getEnvironmentIds();
    if (environmentIds == null || environmentIds.isEmpty) {
      String globalId = kGlobalEnvironmentId;
      const globalEnvironment = EnvironmentModel(
        id: kGlobalEnvironmentId,
        name: "Global",
        values: [],
      );
      state = {
        globalId: globalEnvironment,
      };
      return false;
    } else {
      Map<String, EnvironmentModel> environmentsMap = {};
      for (var environmentId in environmentIds) {
        var jsonModel = hiveHandler.getEnvironment(environmentId);
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
    final newEnvironmentModel = EnvironmentModel(
      id: id,
      values: [],
    );
    state = {
      ...state!,
      id: newEnvironmentModel,
    };
    ref
        .read(environmentSequenceProvider.notifier)
        .update((state) => [id, ...state]);
    ref.read(selectedEnvironmentIdStateProvider.notifier).state =
        newEnvironmentModel.id;
    ref.read(hasUnsavedChangesProvider.notifier).state = true;
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
    state = {
      ...state!,
      id: updatedEnvironment,
    };
    ref.read(hasUnsavedChangesProvider.notifier).state = true;
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

    state = {
      ...state!,
      newId: newEnvironment,
    };

    ref
        .read(environmentSequenceProvider.notifier)
        .update((state) => [...environmentIds]);
    ref.read(selectedEnvironmentIdStateProvider.notifier).state = newId;
    ref.read(hasUnsavedChangesProvider.notifier).state = true;
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

    state = {
      ...state!,
    }..remove(id);

    ref.read(hasUnsavedChangesProvider.notifier).state = true;
  }

  void reorder(int oldIdx, int newIdx) {
    final environmentIds = ref.read(environmentSequenceProvider);
    final id = environmentIds.removeAt(oldIdx);
    environmentIds.insert(newIdx, id);
    ref.read(environmentSequenceProvider.notifier).state = [...environmentIds];
    ref.read(hasUnsavedChangesProvider.notifier).state = true;
  }

  Future<void> saveEnvironments() async {
    ref.read(saveDataStateProvider.notifier).state = true;
    final environmentIds = ref.read(environmentSequenceProvider);
    await hiveHandler.setEnvironmentIds(environmentIds);
    for (var environmentId in environmentIds) {
      var environment = state![environmentId]!;
      await hiveHandler.setEnvironment(environmentId, environment.toJson());
    }
    await hiveHandler.removeUnused();
    ref.read(saveDataStateProvider.notifier).state = false;
    ref.read(hasUnsavedChangesProvider.notifier).state = false;
  }
}
