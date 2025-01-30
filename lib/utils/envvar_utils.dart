import 'package:apidash/providers/environment_providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insomnia_collection/models/insomnia_environment.dart';

List<EnvironmentVariableModel> createNewEnvironment(WidgetRef ref, InsomniaEnvironment environment) {
  // Step 1: Add a new environment
  ref.read(environmentsStateNotifierProvider.notifier).addEnvironment();

  // Step 2: Get the ID of the newly created environment
  final newEnvironmentId =
      ref.read(selectedEnvironmentIdStateProvider.notifier).state;

  debugPrint('New id is $newEnvironmentId');

  // Step 3: Update the new environment with a name and variables
  if (newEnvironmentId != null) {
    if (environment.resources == null || environment.resources!.isEmpty) {
      debugPrint('No env variables found');
      return [];
    }
    List<EnvironmentVariableModel> variables = [];
    for (var env in environment.resources!) {
      variables.add(EnvironmentVariableModel(
        key: env.key,
        value: env.value,
        enabled: env.enabled ?? true,
        type: env.type == "secret"
            ? EnvironmentVariableType.secret
            : EnvironmentVariableType.variable,
      ));
    }
    ref.read(environmentsStateNotifierProvider.notifier).updateEnvironment(
          newEnvironmentId,
          name: environment.name ?? "Untitled",
          values: variables,
        );
    return variables;
  } else {
    debugPrint('No env id found');
    return [];
  }
}

String getEnvironmentTitle(String? name) {
  if (name == null || name.trim() == "") {
    return kUntitled;
  }
  return name;
}

List<EnvironmentVariableModel> getEnvironmentVariables(
    EnvironmentModel? environment,
    {bool removeEmptyModels = false}) {
  if (environment == null) {
    return [];
  }
  return environment.values
      .where((element) =>
          element.type == EnvironmentVariableType.variable &&
          (removeEmptyModels
              ? element != kEnvironmentVariableEmptyModel
              : true))
      .toList();
}

List<EnvironmentVariableModel> getEnvironmentSecrets(
    EnvironmentModel? environment,
    {bool removeEmptyModels = false}) {
  if (environment == null) {
    return [];
  }
  return environment.values
      .where((element) =>
          element.type == EnvironmentVariableType.secret &&
          (removeEmptyModels ? element != kEnvironmentSecretEmptyModel : true))
      .toList();
}

String? substituteVariables(
    String? input,
    Map<String?, List<EnvironmentVariableModel>> envMap,
    String? activeEnvironmentId) {
  if (input == null) return null;

  final Map<String, String> combinedMap = {};
  final activeEnv = envMap[activeEnvironmentId] ?? [];
  final globalEnv = envMap[kGlobalEnvironmentId] ?? [];

  for (var variable in globalEnv) {
    combinedMap[variable.key] = variable.value;
  }
  for (var variable in activeEnv) {
    combinedMap[variable.key] = variable.value;
  }

  String result = input.replaceAllMapped(kEnvVarRegEx, (match) {
    final key = match.group(1)?.trim() ?? '';
    return combinedMap[key] ?? '';
  });

  return result;
}

HttpRequestModel substituteHttpRequestModel(
    HttpRequestModel httpRequestModel,
    Map<String?, List<EnvironmentVariableModel>> envMap,
    String? activeEnvironmentId) {
  var newRequestModel = httpRequestModel.copyWith(
    url: substituteVariables(
      httpRequestModel.url,
      envMap,
      activeEnvironmentId,
    )!,
    headers: httpRequestModel.headers?.map((header) {
      return header.copyWith(
        name:
            substituteVariables(header.name, envMap, activeEnvironmentId) ?? "",
        value: substituteVariables(header.value, envMap, activeEnvironmentId),
      );
    }).toList(),
    params: httpRequestModel.params?.map((param) {
      return param.copyWith(
        name:
            substituteVariables(param.name, envMap, activeEnvironmentId) ?? "",
        value: substituteVariables(param.value, envMap, activeEnvironmentId),
      );
    }).toList(),
  );
  return newRequestModel;
}

List<EnvironmentVariableSuggestion>? getEnvironmentTriggerSuggestions(
    String query,
    Map<String, List<EnvironmentVariableModel>> envMap,
    String? activeEnvironmentId) {
  final suggestions = <EnvironmentVariableSuggestion>[];
  final Set<String> addedVariableKeys = {};

  if (activeEnvironmentId != null && envMap[activeEnvironmentId] != null) {
    for (final variable in envMap[activeEnvironmentId]!) {
      if ((query.isEmpty || variable.key.contains(query)) &&
          !addedVariableKeys.contains(variable.key)) {
        suggestions.add(EnvironmentVariableSuggestion(
            environmentId: activeEnvironmentId, variable: variable));
        addedVariableKeys.add(variable.key);
      }
    }
  }

  envMap[kGlobalEnvironmentId]?.forEach((variable) {
    if ((query.isEmpty || variable.key.contains(query)) &&
        !addedVariableKeys.contains(variable.key)) {
      suggestions.add(EnvironmentVariableSuggestion(
          environmentId: kGlobalEnvironmentId, variable: variable));
      addedVariableKeys.add(variable.key);
    }
  });

  return suggestions;
}

EnvironmentVariableSuggestion getVariableStatus(
    String key,
    Map<String, List<EnvironmentVariableModel>> envMap,
    String? activeEnvironmentId) {
  if (activeEnvironmentId != null) {
    final variable =
        envMap[activeEnvironmentId]!.firstWhereOrNull((v) => v.key == key);
    if (variable != null) {
      return EnvironmentVariableSuggestion(
        environmentId: activeEnvironmentId,
        variable: variable,
        isUnknown: false,
      );
    }
  }

  final globalVariable =
      envMap[kGlobalEnvironmentId]?.firstWhereOrNull((v) => v.key == key);
  if (globalVariable != null) {
    return EnvironmentVariableSuggestion(
      environmentId: kGlobalEnvironmentId,
      variable: globalVariable,
      isUnknown: false,
    );
  }

  return EnvironmentVariableSuggestion(
      isUnknown: true,
      environmentId: "unknown",
      variable: EnvironmentVariableModel(
          key: key, type: EnvironmentVariableType.variable, value: "unknown"));
}
