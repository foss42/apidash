import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/consts.dart';

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
    authModel:
        substituteAuthModel(httpRequestModel.authModel, combinedEnvVarMap),
  );
  return newRequestModel;
}

AuthModel? substituteAuthModel(
    AuthModel? authModel, Map<String, String> envVarMap) {
  if (authModel == null) return null;

  switch (authModel.type) {
    case APIAuthType.basic:
      if (authModel.basic != null) {
        final basic = authModel.basic!;
        return authModel.copyWith(
          basic: basic.copyWith(
            username: substituteVariables(basic.username, envVarMap) ??
                basic.username,
            password: substituteVariables(basic.password, envVarMap) ??
                basic.password,
          ),
        );
      }
      break;
    case APIAuthType.bearer:
      if (authModel.bearer != null) {
        final bearer = authModel.bearer!;
        return authModel.copyWith(
          bearer: bearer.copyWith(
            token: substituteVariables(bearer.token, envVarMap) ?? bearer.token,
          ),
        );
      }
      break;
    case APIAuthType.apiKey:
      if (authModel.apikey != null) {
        final apiKey = authModel.apikey!;
        return authModel.copyWith(
          apikey: apiKey.copyWith(
            key: substituteVariables(apiKey.key, envVarMap) ?? apiKey.key,
            name: substituteVariables(apiKey.name, envVarMap) ?? apiKey.name,
          ),
        );
      }
      break;
    case APIAuthType.jwt:
      if (authModel.jwt != null) {
        final jwt = authModel.jwt!;
        return authModel.copyWith(
          jwt: jwt.copyWith(
            secret: substituteVariables(jwt.secret, envVarMap) ?? jwt.secret,
            privateKey: substituteVariables(jwt.privateKey, envVarMap) ??
                jwt.privateKey,
            payload: substituteVariables(jwt.payload, envVarMap) ?? jwt.payload,
          ),
        );
      }
      break;
    case APIAuthType.digest:
      if (authModel.digest != null) {
        final digest = authModel.digest!;
        return authModel.copyWith(
          digest: digest.copyWith(
            username: substituteVariables(digest.username, envVarMap) ??
                digest.username,
            password: substituteVariables(digest.password, envVarMap) ??
                digest.password,
            realm: substituteVariables(digest.realm, envVarMap) ?? digest.realm,
            nonce: substituteVariables(digest.nonce, envVarMap) ?? digest.nonce,
            qop: substituteVariables(digest.qop, envVarMap) ?? digest.qop,
            opaque:
                substituteVariables(digest.opaque, envVarMap) ?? digest.opaque,
          ),
        );
      }
      break;
    case APIAuthType.oauth1:
      if (authModel.oauth1 != null) {
        final oauth1 = authModel.oauth1!;
        return authModel.copyWith(
          oauth1: oauth1.copyWith(
            consumerKey: substituteVariables(oauth1.consumerKey, envVarMap) ??
                oauth1.consumerKey,
            consumerSecret:
                substituteVariables(oauth1.consumerSecret, envVarMap) ??
                    oauth1.consumerSecret,
            credentialsFilePath:
                substituteVariables(oauth1.credentialsFilePath, envVarMap) ??
                    oauth1.credentialsFilePath,
            accessToken: substituteVariables(oauth1.accessToken, envVarMap) ??
                oauth1.accessToken,
            tokenSecret: substituteVariables(oauth1.tokenSecret, envVarMap) ??
                oauth1.tokenSecret,
            parameterLocation:
                substituteVariables(oauth1.parameterLocation, envVarMap) ??
                    oauth1.parameterLocation,
            version: substituteVariables(oauth1.version, envVarMap) ??
                oauth1.version,
            realm: substituteVariables(oauth1.realm, envVarMap) ?? oauth1.realm,
            callbackUrl: substituteVariables(oauth1.callbackUrl, envVarMap) ??
                oauth1.callbackUrl,
            verifier: substituteVariables(oauth1.verifier, envVarMap) ??
                oauth1.verifier,
            nonce: substituteVariables(oauth1.nonce, envVarMap) ?? oauth1.nonce,
            timestamp: substituteVariables(oauth1.timestamp, envVarMap) ??
                oauth1.timestamp,
          ),
        );
      }
      break;
    case APIAuthType.oauth2:
      if (authModel.oauth2 != null) {
        final oauth2 = authModel.oauth2!;
        return authModel.copyWith(
          oauth2: oauth2.copyWith(
            authorizationUrl:
                substituteVariables(oauth2.authorizationUrl, envVarMap) ??
                    oauth2.authorizationUrl,
            accessTokenUrl:
                substituteVariables(oauth2.accessTokenUrl, envVarMap) ??
                    oauth2.accessTokenUrl,
            clientId: substituteVariables(oauth2.clientId, envVarMap) ??
                oauth2.clientId,
            clientSecret: substituteVariables(oauth2.clientSecret, envVarMap) ??
                oauth2.clientSecret,
            credentialsFilePath:
                substituteVariables(oauth2.credentialsFilePath, envVarMap) ??
                    oauth2.credentialsFilePath,
            redirectUrl: substituteVariables(oauth2.redirectUrl, envVarMap) ??
                oauth2.redirectUrl,
            scope: substituteVariables(oauth2.scope, envVarMap) ?? oauth2.scope,
            state: substituteVariables(oauth2.state, envVarMap) ?? oauth2.state,
            codeChallengeMethod:
                substituteVariables(oauth2.codeChallengeMethod, envVarMap) ??
                    oauth2.codeChallengeMethod,
            codeVerifier: substituteVariables(oauth2.codeVerifier, envVarMap) ??
                oauth2.codeVerifier,
            codeChallenge:
                substituteVariables(oauth2.codeChallenge, envVarMap) ??
                    oauth2.codeChallenge,
            username: substituteVariables(oauth2.username, envVarMap) ??
                oauth2.username,
            password: substituteVariables(oauth2.password, envVarMap) ??
                oauth2.password,
            refreshToken: substituteVariables(oauth2.refreshToken, envVarMap) ??
                oauth2.refreshToken,
            identityToken:
                substituteVariables(oauth2.identityToken, envVarMap) ??
                    oauth2.identityToken,
            accessToken: substituteVariables(oauth2.accessToken, envVarMap) ??
                oauth2.accessToken,
          ),
        );
      }
      break;
    case APIAuthType.none:
      break;
  }

  return authModel;
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
