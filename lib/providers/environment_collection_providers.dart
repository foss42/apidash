import 'package:apidash/models/environments_list_model.dart';
import 'package:apidash/services/services.dart';
import 'package:apidash/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeEnvironmentIdProvider = StateProvider<String?>((ref) {
  return null;
});
final selectedEnvironmentIdProvider = StateProvider<String?>((ref) {
  return null;
});

final environmentsStateNotifierProvider = StateNotifierProvider<
    EnvironmentsStateNotifier, Map<String, EnvironmentModel>>((ref) {
  return EnvironmentsStateNotifier(
    ref,
    hiveHandler,
  );
});

final getEnvironmentsIdsProvider = StateProvider<List<String>>((ref) {
  var ids = hiveHandler.getEnvironmentIds();
  return ids ?? [];
});

class EnvironmentsStateNotifier
    extends StateNotifier<Map<String, EnvironmentModel>> {
  final HiveHandler hiveHandler;
  final Ref ref;

  EnvironmentModel? get selectedEnvModelData {
    final selectedId = ref.read(selectedEnvironmentIdProvider);

    if (selectedId == null) {
      return state.values.first;
    } else {
      return state[selectedId];
    }
  }

  EnvironmentModel? get activeEnvModelData {
    final activeId = ref.read(activeEnvironmentIdProvider);

    if (activeId == null) {
      return state.values.first;
    } else {
      return state[activeId];
    }
  }

  EnvironmentsStateNotifier(
    this.ref,
    this.hiveHandler,
  ) : super({}) {
    loadInitialData();
  }

  void loadInitialData() {
    List<String>? environmentIds = hiveHandler.getEnvironmentIds();
    if (environmentIds != null && environmentIds.isNotEmpty) {
      Map<String, EnvironmentModel> environmentsMap = {};
      for (var environmentId in environmentIds) {
        var environmentVariables = hiveHandler.getEnvironment(environmentId);
        EnvironmentModel environmentModelFromJson = EnvironmentModel.fromJson(
          environmentVariables,
        );

        EnvironmentModel environmentModel = EnvironmentModel(
          id: environmentId,
          name: environmentModelFromJson.name,
          variables: environmentModelFromJson.variables,
          inEditMode: environmentModelFromJson.inEditMode,
        );
        environmentsMap[environmentId] = environmentModel;
      }

      state = environmentsMap;
    } else {
      String id = uuid.v1();
      var initialGlobalState = EnvironmentModel(
        id: id,
        name: "Globals",
        variables: {},
        inEditMode: false,
      );

      Future.delayed(Duration.zero, () {
        ref.read(selectedEnvironmentIdProvider.notifier).update((state) => id);
      });
      state = {
        id: initialGlobalState,
      };
    }
  }

  void create() {
    Map<String, EnvironmentModel> environmentsMap = {...state};

    String id = uuid.v1();
    ref
        .read(getEnvironmentsIdsProvider.notifier)
        .update((state) => [...state, id]);
    environmentsMap[id] = EnvironmentModel(
      id: id,
      name: "untitled",
      variables: {},
      inEditMode: true,
    );
    ref.read(selectedEnvironmentIdProvider.notifier).update((state) => id);

    state = environmentsMap;
    print(state.length);
  }

  void update(
    String id, {
    String? name,
    bool? isActive,
    bool? inEditMode,
    Map<String, EnvironmentVariableModel>? variables,
    bool? isSelect,
  }) {
    if (!(state.containsKey(id))) {
      return;
    }

    final envModel = state[id]!.copyWith(
      inEditMode: inEditMode,
      name: name,
      variables: variables,
    );
    var envs = {...state};
    envs[id] = envModel;
    state = envs;
    ref
        .read(getEnvironmentsIdsProvider.notifier)
        .update((state) => [...state, id]);

    if (isSelect ?? false) {
      ref.read(selectedEnvironmentIdProvider.notifier).update((state) => id);
    }
  }

  void delete(String id) {
    if (!(state.containsKey(id))) {
      return;
    }
    var envs = {...state};
    envs.remove(id);
    state = envs;
  }

  // variable flow
  void addVariable() {
    String id = uuid.v1();
    EnvironmentVariableModel emptyEnvironmentVariableModel =
        EnvironmentVariableModel(
      id: id,
      variable: "",
      value: "",
      isActive: true,
    );
    Map<String, EnvironmentModel> environmentsMap = {...state};
    EnvironmentModel? activeEnvironmentModel = selectedEnvModelData;
    if (activeEnvironmentModel != null) {
      activeEnvironmentModel.variables.addEntries(
        [
          MapEntry(
            id,
            emptyEnvironmentVariableModel,
          ),
        ],
      );
      environmentsMap[activeEnvironmentModel.id] = activeEnvironmentModel;
      state = environmentsMap;
    }
  }

  void removeVariable({
    required String environmentVariableIndexId,
  }) {
    Map<String, EnvironmentModel> environmentsMap = {...state};
    EnvironmentModel? activeEnvironmentModel = selectedEnvModelData;
    if (activeEnvironmentModel != null) {
      activeEnvironmentModel.variables.remove(environmentVariableIndexId);
      state = environmentsMap;
    }
  }

  void updateEnvironmentVariable(
    String? environmentVariableId, {
    String? variable,
    String? value,
    bool? isActive,
  }) {
    Map<String, EnvironmentModel> environmentsMap = {...state};
    EnvironmentModel? activeEnvironmentModel = selectedEnvModelData;
    if (activeEnvironmentModel != null) {
      EnvironmentVariableModel environmentVariableModel =
          activeEnvironmentModel.variables[environmentVariableId]!;

      activeEnvironmentModel.variables[environmentVariableId!] =
          environmentVariableModel.copyWith(
        variable: variable,
        value: value,
        isActive: isActive,
      );
      environmentsMap[activeEnvironmentModel.id] = activeEnvironmentModel;
      state = environmentsMap;
    }
  }
}
