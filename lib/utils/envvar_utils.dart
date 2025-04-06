import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/consts.dart';
import 'fake_data_provider.dart';

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
) {
  if (input == null) return null;

  String result = input;

  if (envVarMap.keys.isNotEmpty) {
    final envVarRegex = RegExp("{{(${envVarMap.keys.join('|')})}}");
    result = result.replaceAllMapped(envVarRegex, (match) {
      final key = match.group(1)?.trim() ?? '';
      return envVarMap[key] ?? '{{$key}}';
    });
  }

  final fakeDataRegex = RegExp(r'{{(\$[a-zA-Z0-9]+)}}');
  result = result.replaceAllMapped(fakeDataRegex, (match) {
    final key = match.group(1)?.trim().substring(1) ?? '';
    return FakeDataProvider.processFakeDataTag(key);
  });

  return result;
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
    combinedEnvVarMap[variable.key] = variable.value;
  }
  for (var variable in activeEnv) {
    combinedEnvVarMap[variable.key] = variable.value;
  }

  var newRequestModel = httpRequestModel.copyWith(
    url: substituteVariables(httpRequestModel.url, combinedEnvVarMap)!,
    headers: httpRequestModel.headers?.map((header) {
      return header.copyWith(
        name: substituteVariables(header.name, combinedEnvVarMap) ?? "",
        value: substituteVariables(header.value, combinedEnvVarMap),
      );
    }).toList(),
    params: httpRequestModel.params?.map((param) {
      return param.copyWith(
        name: substituteVariables(param.name, combinedEnvVarMap) ?? "",
        value: substituteVariables(param.value, combinedEnvVarMap),
      );
    }).toList(),
    formData: httpRequestModel.formData?.map((formData) {
      return formData.copyWith(
        name: substituteVariables(formData.name, combinedEnvVarMap) ?? "",
        value: substituteVariables(formData.value, combinedEnvVarMap) ?? "",
      );
    }).toList(),
    body: substituteVariables(httpRequestModel.body, combinedEnvVarMap),
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

  // If not found in environments check if it's a random data generator
  if (key.startsWith('\$')) {
    final generatorType = key.substring(1);
    final generator = FakeDataProvider.processFakeDataTag(generatorType);
    if (generator != '{{generatorType}}') {
      return EnvironmentVariableSuggestion(
        environmentId: "Random",
        variable: EnvironmentVariableModel(
          key: key,
          type: EnvironmentVariableType.variable,
          value: generator,
          enabled: true,
        ),
        isUnknown: false,
      );
    }
  }

  return EnvironmentVariableSuggestion(
    isUnknown: true,
    environmentId: "unknown",
    variable: EnvironmentVariableModel(
      key: key,
      type: EnvironmentVariableType.variable,
      value: "unknown",
      // enabled: false,
    ),
  );
}
