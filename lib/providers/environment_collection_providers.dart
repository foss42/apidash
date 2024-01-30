import 'package:apidash/models/environments_list_model.dart';
import 'package:apidash/services/services.dart';
import 'package:apidash/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeEnvironmentIdProvider = StateProvider<String?>((ref) {
  return null;
});

final environmentCollectionStateNotifierProvider = StateNotifierProvider<
    EnvironmentCollectionStateNotifier, EnvironmentsMapModel?>((ref) {
  return EnvironmentCollectionStateNotifier(
    ref,
    hiveHandler,
  );
});

final getEnvironmentsIdsProvider = StateProvider<List<String>>((ref) {
  var ids = hiveHandler.getEnvironmentIds();
  return ids ?? [];
});

class EnvironmentCollectionStateNotifier
    extends StateNotifier<EnvironmentsMapModel?> {
  final HiveHandler hiveHandler;
  final Ref ref;

  EnvironmentModel? get activeEnvModelData =>
      state?.environments?[ref.read(activeEnvironmentIdProvider)];
  EnvironmentCollectionStateNotifier(
    this.ref,
    this.hiveHandler,
  ) : super(null) {
    List<String>? environmentIds = hiveHandler.getEnvironmentIds();
    if (environmentIds != null && environmentIds.isNotEmpty) {
      EnvironmentsMapModel environmentsListModel = const EnvironmentsMapModel();
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
          isActive: environmentModelFromJson.isActive,
          inEditMode: environmentModelFromJson.inEditMode,
        );
        environmentsMap[environmentId] = environmentModel;
      }
      environmentsListModel.copyWith(environments: environmentsMap);
      state = environmentsListModel;
    } else {
      String id = uuid.v1();
      var initialGlobalState = EnvironmentModel(
        isActive: true,
        id: id,
        name: "Globals",
        variables: {},
        inEditMode: false,
      );
      EnvironmentsMapModel environmentsListModel = EnvironmentsMapModel(
        environments: {
          id: initialGlobalState,
        },
      );
      Future.delayed(Duration.zero, () {
        ref.read(activeEnvironmentIdProvider.notifier).update((state) => id);
      });
      state = environmentsListModel;
    }
  }
  List<EnvironmentModel> get environmentModels =>
      state?.environments?.values.toList().cast<EnvironmentModel>() ?? [];

  void createNewEnvironment() {
    Map<String, EnvironmentModel> environmentsMap = state?.environments ?? {};

    String id = uuid.v1();
    ref
        .read(getEnvironmentsIdsProvider.notifier)
        .update((state) => [...state, id]);
    environmentsMap[id] = EnvironmentModel(
      isActive: true,
      id: id,
      name: "",
      variables: {},
      inEditMode: true,
    );
    state = state?.copyWith(environments: environmentsMap);
    ref.read(activeEnvironmentIdProvider.notifier).update((state) => id);
  }

  void onEnvironmentNameChanged({
    required String environmentId,
    required String name,
  }) {
    Map<String, EnvironmentModel> environmentsMap = state?.environments ?? {};
    if (environmentsMap.containsKey(environmentId)) {
      environmentsMap[environmentId] =
          environmentsMap[environmentId]!.copyWith(name: name);
      state = state?.copyWith(environments: environmentsMap);
    }
  }

  void activateEnvironment({
    required String environmentId,
  }) {
    Map<String, EnvironmentModel> environmentsMap = state?.environments ?? {};
    if (environmentsMap.containsKey(environmentId)) {
      ref
          .read(activeEnvironmentIdProvider.notifier)
          .update((state) => environmentId);
    }
  }

  void deleteEnvironment({
    required String environmentId,
  }) {
    Map<String, EnvironmentModel> environmentsMap = state?.environments ?? {};
    if (environmentsMap.containsKey(environmentId)) {
      environmentsMap.remove(environmentId);
      state = state?.copyWith(environments: environmentsMap);
    }
  }

  void changeToEditMode({
    required String environmentId,
  }) {
    Map<String, EnvironmentModel> environmentsMap = state?.environments ?? {};
    if (environmentsMap.containsKey(environmentId)) {
      environmentsMap[environmentId] =
          environmentsMap[environmentId]!.copyWith(inEditMode: true);
      state = state?.copyWith(
        environments: environmentsMap,
      );
    }
  }

  void addEmptyEnvironmentVariable() {
    String id = uuid.v1();
    EnvironmentVariableModel emptyEnvironmentVariableModel =
        EnvironmentVariableModel(
      id: id,
      variable: "",
      value: "",
      isActive: true,
    );
    Map<String, EnvironmentModel> environmentsMap = state?.environments ?? {};
    EnvironmentModel? activeEnvironmentModel = activeEnvModelData;
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
      state = state?.copyWith(environments: environmentsMap);
    }
  }

  set toggleEnvironmentVariableCheckBox(String environmentVariableIndexId) {
    Map<String, EnvironmentModel> environmentsMap = state?.environments ?? {};
    EnvironmentModel? activeEnvironmentModel = activeEnvModelData;
    if (activeEnvironmentModel != null) {
      EnvironmentVariableModel environmentVariableModel =
          activeEnvironmentModel.variables[environmentVariableIndexId]!;

      activeEnvironmentModel.variables[environmentVariableIndexId] =
          environmentVariableModel.copyWith(
        isActive: !environmentVariableModel.isActive,
      );
      environmentsMap[activeEnvironmentModel.id] = activeEnvironmentModel;
      state = state?.copyWith(environments: environmentsMap);
    }
  }

  void removeEnvironmentVariableFromActiveEnvironment({
    required String environmentVariableIndexId,
  }) {
    Map<String, EnvironmentModel> environmentsMap = state?.environments ?? {};
    EnvironmentModel? activeEnvironmentModel = activeEnvModelData;
    if (activeEnvironmentModel != null) {
      activeEnvironmentModel.variables.remove(environmentVariableIndexId);
      state = state?.copyWith(environments: environmentsMap);
    }
  }

  void onEnvironmentVariableChanged({
    required String environmentVariableId,
    required String variable,
  }) {
    Map<String, EnvironmentModel> environmentsMap = state?.environments ?? {};
    EnvironmentModel? activeEnvironmentModel = activeEnvModelData;
    if (activeEnvironmentModel != null) {
      EnvironmentVariableModel environmentVariableModel =
          activeEnvironmentModel.variables[environmentVariableId]!;

      activeEnvironmentModel.variables[environmentVariableId] =
          environmentVariableModel.copyWith(
        variable: variable,
      );
      environmentsMap[activeEnvironmentModel.id] = activeEnvironmentModel;
      state = state?.copyWith(environments: environmentsMap);
    }
  }

  void onEnvironmentValueChanged({
    required String environmentVariableId,
    required String value,
  }) {
    Map<String, EnvironmentModel> environmentsMap = state?.environments ?? {};
    EnvironmentModel? activeEnvironmentModel = activeEnvModelData;
    if (activeEnvironmentModel != null) {
      EnvironmentVariableModel environmentVariableModel =
          activeEnvironmentModel.variables[environmentVariableId]!;

      activeEnvironmentModel.variables[environmentVariableId] =
          environmentVariableModel.copyWith(
        isActive: !environmentVariableModel.isActive,
      );
      environmentsMap[activeEnvironmentModel.id] = activeEnvironmentModel;
      state = state?.copyWith(environments: environmentsMap);
    }
  }
}
