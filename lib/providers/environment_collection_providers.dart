import 'package:apidash/models/environments_list_model.dart';
import 'package:apidash/services/services.dart';
import 'package:apidash/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final environmentCollectionStateNotifierProvider = StateNotifierProvider<
    EnvironmentCollectionStateNotifier, EnvironmentsListModel?>((ref) {
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
    extends StateNotifier<EnvironmentsListModel?> {
  final HiveHandler hiveHandler;
  final Ref ref;

  EnvironmentCollectionStateNotifier(
    this.ref,
    this.hiveHandler,
  ) : super(null) {
    List<String>? environmentIds = hiveHandler.getEnvironmentIds();
    if (environmentIds != null && environmentIds.isNotEmpty) {
      EnvironmentsListModel environmentsListModel =
          const EnvironmentsListModel(environments: []);
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
        environmentsListModel = environmentsListModel.copyWith(
          environments: [
            ...(environmentsListModel.environments),
            environmentModel
          ],
        );
        state = environmentsListModel;
      }
    } else {
      state = EnvironmentsListModel(
        environments: [
          EnvironmentModel(
            isActive: true,
            id: uuid.v1(),
            name: "Globals",
            variables: [],
            inEditMode: false,
          )
        ],
      );
    }
  }
  void createNewEnvironment() {
    String id = uuid.v1();
    ref
        .read(getEnvironmentsIdsProvider.notifier)
        .update((state) => [...state, id]);
    state = state?.copyWith(
      environments: [
        ...(state?.environments ?? []),
        EnvironmentModel(
          isActive: true,
          id: id,
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
    state = state?.copyWith(
      environments: [
        ...(state?.environments ?? []).map((e) {
          e = e.copyWith(isActive: e.id == environmentId);
          if (e.id == environmentId) {
            e = e.copyWith(
              name: name,
              inEditMode: false,
            );
          }
          return e;
        })
      ],
    );
  }

  void activateEnvironment({
    required String environmentId,
  }) {
    state = state?.copyWith(
      environments: [
        ...(state?.environments ?? []).map((e) {
          e = e.copyWith(
            isActive: e.id == environmentId,
          );
          return e;
        })
      ],
    );
  }

  void deleteEnvironment({
    required String environmentId,
  }) {
    List<EnvironmentModel> environmentsModel = [...(state?.environments ?? [])];
    environmentsModel.removeWhere((element) => element.id == environmentId);

    List<String> envIds = [
      ...ref.read(getEnvironmentsIdsProvider.notifier).state
    ];
    envIds.removeWhere((element) => element == environmentId);

    ref.read(getEnvironmentsIdsProvider.notifier).update((state) => envIds);
    state = state?.copyWith(
      environments: environmentsModel,
    );
  }

  void changeToEditMode({
    required String environmentId,
  }) {
    state = state?.copyWith(
      environments: [
        ...(state?.environments ?? []).map((e) {
          if (e.id == environmentId) {
            e = e.copyWith(
              inEditMode: true,
            );
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
    EnvironmentModel? activeEnvironment = state?.getActiveEnvironment;
    int? activeEnvironmentIndex = state?.getActiveEnvironmentIndex;
    List<EnvironmentModel> environmentsModel = [...(state?.environments ?? [])];
    if (activeEnvironment != null &&
        activeEnvironmentIndex != null &&
        activeEnvironmentIndex != -1) {
      List<EnvironmentVariableModel> environmentVariableModelList =
          activeEnvironment.variables;

      activeEnvironment = activeEnvironment.copyWith(
        variables: [
          ...environmentVariableModelList,
          emptyEnvironmentVariableModel
        ],
      );
      environmentsModel[activeEnvironmentIndex] = activeEnvironment;
      state = state?.copyWith(
        environments: environmentsModel,
      );
    }
  }

  set toggleEnvironmentVariableCheckBox(String environmentVariableIndexId) {
    EnvironmentModel? activeEnvironment = state?.getActiveEnvironment;
    int? activeEnvironmentIndex = state?.getActiveEnvironmentIndex;
    List<EnvironmentModel> environmentsModel = [...(state?.environments ?? [])];

    if (activeEnvironment != null &&
        activeEnvironmentIndex != null &&
        activeEnvironmentIndex != -1) {
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
      state = state?.copyWith(environments: environmentsModel);
    }
  }

  void removeEnvironmentVariableFromActiveEnvironment({
    required String environmentVariableIndexId,
  }) {
    EnvironmentModel? activeEnvironment = state?.getActiveEnvironment;
    int? activeEnvironmentIndex = state?.getActiveEnvironmentIndex;
    List<EnvironmentModel> environmentsModel = [...(state?.environments ?? [])];

    if (activeEnvironment != null &&
        activeEnvironmentIndex != null &&
        activeEnvironmentIndex != -1) {
      List<EnvironmentVariableModel> environmentVariableModels = [
        ...activeEnvironment.variables
      ];
      environmentVariableModels
          .removeWhere((element) => element.id == environmentVariableIndexId);

      activeEnvironment = activeEnvironment.copyWith(
        variables: environmentVariableModels,
      );
      environmentsModel[activeEnvironmentIndex] = activeEnvironment;
      state = state?.copyWith(environments: environmentsModel);
    }
  }

  void onEnvironmentVariableChanged({
    required String environmentVariableId,
    required String variable,
  }) {
    EnvironmentModel? activeEnvironment = state?.getActiveEnvironment;
    int? activeEnvironmentIndex = state?.getActiveEnvironmentIndex;
    List<EnvironmentModel> environmentsModel = [...(state?.environments ?? [])];

    if (activeEnvironment != null &&
        activeEnvironmentIndex != null &&
        activeEnvironmentIndex != -1) {
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
      state = state?.copyWith(environments: environmentsModel);
    }
  }

  void onEnvironmentValueChanged({
    required String environmentVariableId,
    required String value,
  }) {
    EnvironmentModel? activeEnvironment = state?.getActiveEnvironment;
    int? activeEnvironmentIndex = state?.getActiveEnvironmentIndex;
    List<EnvironmentModel> environmentsModel = [...(state?.environments ?? [])];

    if (activeEnvironment != null &&
        activeEnvironmentIndex != null &&
        activeEnvironmentIndex != -1) {
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
      state = state?.copyWith(environments: environmentsModel);
    }
  }
}
