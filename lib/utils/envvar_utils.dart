import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';

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

  final regex = RegExp(r'{{(.*?)}}');
  String result = input.replaceAllMapped(regex, (match) {
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
        value: substituteVariables(header.value, envMap, activeEnvironmentId),
      );
    }).toList(),
    params: httpRequestModel.params?.map((param) {
      return param.copyWith(
        value: substituteVariables(param.value, envMap, activeEnvironmentId),
      );
    }).toList(),
  );
  return newRequestModel;
}
