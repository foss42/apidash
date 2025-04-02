import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/consts.dart';

import '../services/services.dart';

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
  Map<String, String> envVarMap,
  String? activeEnvironmentId,
) {
  if (input == null) return null;
  if (envVarMap.keys.isEmpty) {
    return input;
  }
  final regex = RegExp("{{(${envVarMap.keys.join('|')})}}");

  String result = input.replaceAllMapped(regex, (match) {
    final key = match.group(1)?.trim() ?? '';
    return envVarMap[key] ?? '{{$key}}';
  });

  return result;
}

String getEnvironmentVariableValue(EnvironmentVariableModel variable, String? activeEnvironmentId, Map<String, String> combinedEnvVarMap) {
  if (variable.fromOS) {
    final osValue = osEnvironmentService.getOSEnvironmentVariable(variable.key);
    return osValue ?? variable.value;
  }
  return combinedEnvVarMap[variable.key] ?? variable.value;
}

HttpRequestModel substituteHttpRequestModel(
  HttpRequestModel httpRequestModel,
  Map<String?, List<EnvironmentVariableModel>> envMap,
  String? activeEnvironmentId,
) {
  final Map<String, String> combinedEnvVarMap = {};
  final activeEnv = envMap[activeEnvironmentId] ?? [];
  final globalEnv = envMap[kGlobalEnvironmentId] ?? [];

  for (var variable in globalEnv) {
    combinedEnvVarMap[variable.key] = getEnvironmentVariableValue(variable, activeEnvironmentId, combinedEnvVarMap);
  }
  for (var variable in activeEnv) {
    combinedEnvVarMap[variable.key] = getEnvironmentVariableValue(variable, activeEnvironmentId, combinedEnvVarMap);
  }

  var newRequestModel = httpRequestModel.copyWith(
    url: substituteVariables(
      httpRequestModel.url,
      combinedEnvVarMap,
      activeEnvironmentId,
    )!,
    headers: httpRequestModel.headers?.map((header) {
      return header.copyWith(
        name:
            substituteVariables(header.name, combinedEnvVarMap, activeEnvironmentId) ?? "",
        value: substituteVariables(header.value, combinedEnvVarMap, activeEnvironmentId),
      );
    }).toList(),
    params: httpRequestModel.params?.map((param) {
      return param.copyWith(
        name:
            substituteVariables(param.name, combinedEnvVarMap, activeEnvironmentId) ?? "",
        value: substituteVariables(param.value, combinedEnvVarMap, activeEnvironmentId),
      );
    }).toList(),
    formData: httpRequestModel.formData?.map((formData) {
      return formData.copyWith(
        name: substituteVariables(formData.name, combinedEnvVarMap, activeEnvironmentId) ?? "",
        value: substituteVariables(formData.value, combinedEnvVarMap, activeEnvironmentId) ?? "",
      );
    }).toList(),
    body: substituteVariables(
      httpRequestModel.body,
      combinedEnvVarMap,
      activeEnvironmentId,
    ),
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