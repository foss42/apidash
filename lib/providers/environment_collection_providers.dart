import 'package:apidash/models/environments_model.dart';
import 'package:apidash/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final environmentCollectionStateNotifierProvider = StateNotifierProvider<
    EnvironmentCollectionStateNotifier, EnvironmentsModel?>((ref) {
  return EnvironmentCollectionStateNotifier(ref);
});

class EnvironmentCollectionStateNotifier
    extends StateNotifier<EnvironmentsModel> {
  final Ref ref;

  EnvironmentCollectionStateNotifier(this.ref)
      : super(
          EnvironmentsModel(
            activeEnvironmentId: uuid.v1(),
            environments: [
              EnvironmentModel(
                isActive: true,
                id: uuid.v1(),
                name: "Globals",
                variables: [],
                inEditMode: false,
              )
            ],
          ),
        ) {
    // TODO: handle hive db in future
  }
  void createNewEnvironment() {
    state = state.copyWith(
      environments: [
        ...state.environments,
        EnvironmentModel(
          isActive: true,
          id: uuid.v1(),
          name: "",
          variables: [],
          inEditMode: true,
        )
      ],
    );
  }

  void onEnvironmentNameChanged({
    required String environmentId,
    required String name,
  }) {
    state = state.copyWith(
      environments: [
        ...state.environments.map((e) {
          if (e.id == environmentId) {
            e = e.copyWith(name: name);
          }
          return e;
        })
      ],
    );
  }

  void addEmptyEnvironmentVariable() {
    EnvironmentVariableModel emptyEnvironmentVariableModel =
        EnvironmentVariableModel(
      id: uuid.v1(),
      variable: "",
      value: "",
      isActive: true,
    );
    EnvironmentModel? activeEnvironment = state.getActiveEnvironment;
    int activeEnvironmentIndex = state.getActiveEnvironmentIndex;
    List<EnvironmentModel> environmentsModel = [...state.environments];
    if (activeEnvironment != null && activeEnvironmentIndex != -1) {
      List<EnvironmentVariableModel> environmentVariableModelList =
          activeEnvironment.variables;

      activeEnvironment = activeEnvironment.copyWith(
        variables: [
          ...environmentVariableModelList,
          emptyEnvironmentVariableModel
        ],
      );
      environmentsModel[activeEnvironmentIndex] = activeEnvironment;
      state = state.copyWith(
        environments: environmentsModel,
      );
    }
  }

  set toggleEnvironmentVariableCheckBox(String environmentVariableIndexId) {
    EnvironmentModel? activeEnvironment = state.getActiveEnvironment;
    int activeEnvironmentIndex = state.getActiveEnvironmentIndex;
    List<EnvironmentModel> environmentsModel = [...state.environments];

    if (activeEnvironment != null && activeEnvironmentIndex != -1) {
      List<EnvironmentVariableModel> environmentVariableModels =
          [...activeEnvironment.variables].map((e) {
        if (e.id == environmentVariableIndexId) {
          e = e.copyWith(isActive: !e.isActive);
        }
        return e;
      }).toList();

      activeEnvironment = activeEnvironment.copyWith(
        variables: environmentVariableModels,
      );
      environmentsModel[activeEnvironmentIndex] = activeEnvironment;
      state = state.copyWith(environments: environmentsModel);
    }
  }

  void removeEnvironmentVariableFromActiveEnvironment({
    required String environmentVariableIndexId,
  }) {
    EnvironmentModel? activeEnvironment = state.getActiveEnvironment;
    int activeEnvironmentIndex = state.getActiveEnvironmentIndex;
    List<EnvironmentModel> environmentsModel = [...state.environments];

    if (activeEnvironment != null && activeEnvironmentIndex != -1) {
      List<EnvironmentVariableModel> environmentVariableModels = [
        ...activeEnvironment.variables
      ];
      environmentVariableModels
          .removeWhere((element) => element.id == environmentVariableIndexId);

      activeEnvironment = activeEnvironment.copyWith(
        variables: environmentVariableModels,
      );
      environmentsModel[activeEnvironmentIndex] = activeEnvironment;
      state = state.copyWith(environments: environmentsModel);
    }
  }

  void onEnvironmentVariableChanged({
    required String environmentVariableId,
    required String variable,
  }) {
    EnvironmentModel? activeEnvironment = state.getActiveEnvironment;
    int activeEnvironmentIndex = state.getActiveEnvironmentIndex;
    List<EnvironmentModel> environmentsModel = [...state.environments];

    if (activeEnvironment != null && activeEnvironmentIndex != -1) {
      List<EnvironmentVariableModel> environmentVariableModels =
          [...activeEnvironment.variables].map(
        (e) {
          if (e.id == environmentVariableId) {
            e = e.copyWith(variable: variable);
          }
          return e;
        },
      ).toList();

      activeEnvironment = activeEnvironment.copyWith(
        variables: environmentVariableModels,
      );
      environmentsModel[activeEnvironmentIndex] = activeEnvironment;
      state = state.copyWith(environments: environmentsModel);
    }
  }

  void onEnvironmentValueChanged({
    required String environmentVariableId,
    required String value,
  }) {
    EnvironmentModel? activeEnvironment = state.getActiveEnvironment;
    int activeEnvironmentIndex = state.getActiveEnvironmentIndex;
    List<EnvironmentModel> environmentsModel = [...state.environments];

    if (activeEnvironment != null && activeEnvironmentIndex != -1) {
      List<EnvironmentVariableModel> environmentVariableModels =
          [...activeEnvironment.variables].map(
        (e) {
          if (e.id == environmentVariableId) {
            e = e.copyWith(value: value);
          }
          return e;
        },
      ).toList();

      activeEnvironment = activeEnvironment.copyWith(
        variables: environmentVariableModels,
      );
      environmentsModel[activeEnvironmentIndex] = activeEnvironment;
      state = state.copyWith(environments: environmentsModel);
    }
  }
}
