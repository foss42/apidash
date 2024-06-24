import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import '../screens/common_widgets/common_widgets.dart';

String getEnvironmentTitle(String? name) {
  if (name == null || name.trim() == "") {
    return "untitled";
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

List<(String, Object?, Widget?)> getMentions(
    String? text,
    Map<String, List<EnvironmentVariableModel>> envMap,
    String? activeEnvironmentId) {
  if (text == null) {
    return [];
  }
  final mentions = <(String, Object?, Widget?)>[];

  final matches = kEnvVarRegEx.allMatches(text);

  for (final match in matches) {
    final variableName = match.group(1);
    EnvironmentVariableModel? variable;
    String? environmentId;

    for (final entry in envMap.entries) {
      variable = entry.value.firstWhereOrNull((v) => v.key == variableName);
      if (variable != null) {
        environmentId = entry.key;
        break;
      }
    }

    final suggestion = EnvironmentVariableSuggestion(
        environmentId: variable == null ? "unknown" : environmentId!,
        variable: variable ??
            kEnvironmentVariableEmptyModel.copyWith(
              key: variableName ?? "",
            ),
        isUnknown: variable == null);
    mentions.add((
      '{{${variable?.key ?? variableName}}}',
      suggestion,
      EnvVarSpan(suggestion: suggestion)
    ));
  }

  return mentions;
}

EnvironmentVariableSuggestion getCurrentVariableStatus(
    EnvironmentVariableSuggestion currentSuggestion,
    Map<String, List<EnvironmentVariableModel>> envMap,
    String? activeEnvironmentId) {
  if (activeEnvironmentId != null) {
    final variable = envMap[activeEnvironmentId]!
        .firstWhereOrNull((v) => v.key == currentSuggestion.variable.key);
    if (variable != null) {
      return currentSuggestion.copyWith(
        environmentId: activeEnvironmentId,
        variable: variable,
        isUnknown: false,
      );
    }
  }

  final globalVariable = envMap[kGlobalEnvironmentId]
      ?.firstWhereOrNull((v) => v.key == currentSuggestion.variable.key);
  if (globalVariable != null) {
    return currentSuggestion.copyWith(
      environmentId: kGlobalEnvironmentId,
      variable: globalVariable,
      isUnknown: false,
    );
  }

  return currentSuggestion.copyWith(
      isUnknown: true,
      variable: currentSuggestion.variable.copyWith(value: "unknown"));
}

List<EnvironmentVariableSuggestion>? getEnvironmentVariableSuggestions(
    String? query,
    Map<String, List<EnvironmentVariableModel>> envMap,
    String? activeEnvironmentId) {
  if (query == null || kEnvVarRegEx.hasMatch(query)) return null;

  query = query.substring(1);

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
    if ((query!.isEmpty || variable.key.contains(query)) &&
        !addedVariableKeys.contains(variable.key)) {
      suggestions.add(EnvironmentVariableSuggestion(
          environmentId: kGlobalEnvironmentId, variable: variable));
      addedVariableKeys.add(variable.key);
    }
  });

  return suggestions;
}
