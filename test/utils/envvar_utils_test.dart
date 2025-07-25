import 'dart:io';

import 'package:apidash/utils/envvar_utils.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/foundation.dart';
import 'package:test/test.dart';

const envVars = [
  EnvironmentVariableModel(
    key: "var1",
    value: "var1-value",
    type: EnvironmentVariableType.variable,
  ),
  EnvironmentVariableModel(
    key: "var2",
    value: "var2-value",
    type: EnvironmentVariableType.variable,
  ),
];
const envSecrets = [
  EnvironmentVariableModel(
    key: "secret1",
    value: "secret1-value",
    type: EnvironmentVariableType.secret,
  ),
  EnvironmentVariableModel(
    key: "secret2",
    value: "secret2-value",
    type: EnvironmentVariableType.secret,
  ),
];
const emptyEnvVar = EnvironmentVariableModel(
  key: "",
  value: "",
  type: EnvironmentVariableType.variable,
);
const emptyEnvSecret = EnvironmentVariableModel(
  key: "",
  value: "",
  type: EnvironmentVariableType.secret,
);
const environmentModel = EnvironmentModel(
    id: "id",
    name: "Testing",
    values: [...envVars, emptyEnvVar, ...envSecrets, emptyEnvSecret]);
const emptyEnvironmentModel =
    EnvironmentModel(id: "id", name: "Testing", values: []);
const globalVars = [
  EnvironmentVariableModel(key: "url", value: "api.foss42.com"),
  EnvironmentVariableModel(key: "num", value: "5670000"),
  EnvironmentVariableModel(key: "token", value: "token"),
];
final globalVarsMap = {for (var item in globalVars) item.key: item.value};
const activeEnvVars = [
  EnvironmentVariableModel(key: "url", value: "api.apidash.dev"),
  EnvironmentVariableModel(key: "num", value: "8940000"),
];
final activeEnvVarsMap = {for (var item in activeEnvVars) item.key: item.value};
final combinedEnvVarsMap = mergeMaps(globalVarsMap, activeEnvVarsMap);

void main() {
  group("Testing getEnvironmentTitle function", () {
    test("Testing getEnvironmentTitle with null", () {
      String? envName1;
      expect(getEnvironmentTitle(envName1), kUntitled);
    });

    test("Testing getEnvironmentTitle with empty string", () {
      String envName2 = "";
      expect(getEnvironmentTitle(envName2), kUntitled);
    });

    test("Testing getEnvironmentTitle with trimmable string", () {
      String envName3 = "   ";
      expect(getEnvironmentTitle(envName3), kUntitled);
    });

    test("Testing getEnvironmentTitle with non-empty string", () {
      String envName4 = "test";
      expect(getEnvironmentTitle(envName4), "test");
    });
  });

  group("Testing getEnvironmentVariables function", () {
    test("Testing getEnvironmentVariables with null", () {
      EnvironmentModel? environment;
      expect(getEnvironmentVariables(environment), []);
    });

    test("Testing getEnvironmentVariables with empty", () {
      expect(getEnvironmentVariables(emptyEnvironmentModel), []);
    });

    test("Testing getEnvironmentVariables with non-empty environmentModel", () {
      expect(
          getEnvironmentVariables(environmentModel), [...envVars, emptyEnvVar]);
    });

    test(
        "Testing getEnvironmentVariables with non-empty environmentModel and removeEmptyModels",
        () {
      expect(getEnvironmentVariables(environmentModel, removeEmptyModels: true),
          envVars);
    });
  });

  group("Testing getEnvironmentSecrets function", () {
    test("Testing getEnvironmentSecrets with null", () {
      EnvironmentModel? environment;
      expect(getEnvironmentSecrets(environment), []);
    });

    test("Testing getEnvironmentSecrets with empty", () {
      expect(getEnvironmentSecrets(emptyEnvironmentModel), []);
    });

    test("Testing getEnvironmentSecrets with non-empty environmentModel", () {
      expect(getEnvironmentSecrets(environmentModel),
          [...envSecrets, emptyEnvSecret]);
    });

    test(
        "Testing getEnvironmentSecrets with non-empty environmentModel and removeEmptyModels",
        () {
      expect(getEnvironmentSecrets(environmentModel, removeEmptyModels: true),
          envSecrets);
    });
  });

  group("Testing substituteVariables function", () {
    test("Testing substituteVariables with null", () {
      String? input;
      Map<String, String> envMap = {};
      expect(substituteVariables(input, envMap, null), null);
    });

    test("Testing substituteVariables with empty input", () {
      String input = "";
      Map<String, String> envMap = {};
      expect(substituteVariables(input, envMap, null), "");
    });

    test("Testing substituteVariables with empty envMap", () {
      String input = "{{url}}/humanize/social?num={{num}}";
      Map<String, String> envMap = {};
      String expected = "{{url}}/humanize/social?num={{num}}";
      expect(substituteVariables(input, envMap, null), expected);
    });

    test("Testing substituteVariables with empty activeEnvironmentId", () {
      String input = "{{url}}/humanize/social?num={{num}}";
      String expected = "api.foss42.com/humanize/social?num=5670000";
      expect(substituteVariables(input, globalVarsMap, null), expected);
    });

    test("Testing substituteVariables with non-empty activeEnvironmentId", () {
      String input = "{{url}}/humanize/social?num={{num}}";
      String expected = "api.apidash.dev/humanize/social?num=8940000";
      expect(substituteVariables(input, combinedEnvVarsMap, "activeEnvId"), expected);
    });

    test("Testing substituteVariables with incorrect paranthesis", () {
      String input = "{{url}}}/humanize/social?num={{num}}";
      String expected = "api.apidash.dev}/humanize/social?num=8940000";
      expect(substituteVariables(input, combinedEnvVarsMap, "activeEnvId"), expected);
    });

    test("Testing substituteVariables function with unavailable variables", () {
      String input = "{{url1}}/humanize/social?num={{num}}";
      String expected = "{{url1}}/humanize/social?num=8940000";
      expect(substituteVariables(input, combinedEnvVarsMap, "activeEnvId"), expected);
    });
  });

  group("Testing substituteHttpRequestModel function", () {
    test("Testing substituteHttpRequestModel with empty", () {
      const httpRequestModel = HttpRequestModel();
      Map<String?, List<EnvironmentVariableModel>> envMap = {};
      String? activeEnvironmentId;
      const expected = HttpRequestModel();
      expect(
          substituteHttpRequestModel(
              httpRequestModel, envMap, activeEnvironmentId),
          expected);
    });

    test("Testing substituteHttpRequestModel with non-empty", () {
      const httpRequestModel = HttpRequestModel(
        url: "{{url}}/humanize/social",
        headers: [
          NameValueModel(name: "Authorization", value: "Bearer {{token}}"),
        ],
        params: [
          NameValueModel(name: "num", value: "{{num}}"),
        ],
      );

      Map<String?, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: [
          const EnvironmentVariableModel(key: "token", value: "token"),
        ],
        "activeEnvId": [
          const EnvironmentVariableModel(key: "url", value: "api.apidash.dev"),
          const EnvironmentVariableModel(key: "num", value: "8940000"),
        ],
      };

      String? activeEnvironmentId = "activeEnvId";
      const expected = HttpRequestModel(
        url: "api.apidash.dev/humanize/social",
        headers: [
          NameValueModel(name: "Authorization", value: "Bearer token"),
        ],
        params: [
          NameValueModel(name: "num", value: "8940000"),
        ],
      );
      expect(
          substituteHttpRequestModel(
            httpRequestModel,
            envMap,
            activeEnvironmentId,
          ),
          expected);
    });

    test("Testing substituteHttpRequestModel with unavailable variables", () {
      const httpRequestModel = HttpRequestModel(
        url: "{{url1}}/humanize/social",
        headers: [
          NameValueModel(name: "Authorization", value: "Bearer {{token1}}"),
        ],
        params: [
          NameValueModel(name: "num", value: "{{num}}"),
        ],
      );
      
      Map<String?, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: [],
        "activeEnvId": [
          const EnvironmentVariableModel(key: "num", value: "8940000"),
        ],
      };
      
      String? activeEnvironmentId = "activeEnvId";
      const expected = HttpRequestModel(
        url: "{{url1}}/humanize/social",
        headers: [
          NameValueModel(name: "Authorization", value: "Bearer {{token1}}"),
        ],
        params: [
          NameValueModel(name: "num", value: "8940000"),
        ],
      );
      expect(
          substituteHttpRequestModel(
              httpRequestModel, envMap, activeEnvironmentId),
          expected);
    });

    test(
        "Testing substituteHttpRequestModel with environment variables in body",
        () {
      const httpRequestModel = HttpRequestModel(
        url: "{{url}}/humanize/social",
        headers: [
          NameValueModel(name: "Authorization", value: "Bearer {{token}}"),
        ],
        params: [
          NameValueModel(name: "num", value: "{{num}}"),
        ],
        body: "The API key is {{token}} and the number is {{num}}",
      );
      
      Map<String?, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: [
          const EnvironmentVariableModel(key: "token", value: "token"),
        ],
        "activeEnvId": [
          const EnvironmentVariableModel(key: "url", value: "api.apidash.dev"),
          const EnvironmentVariableModel(key: "num", value: "8940000"),
        ],
      };
      
      String? activeEnvironmentId = "activeEnvId";
      const expected = HttpRequestModel(
        url: "api.apidash.dev/humanize/social",
        headers: [
          NameValueModel(name: "Authorization", value: "Bearer token"),
        ],
        params: [
          NameValueModel(name: "num", value: "8940000"),
        ],
        body: "The API key is token and the number is 8940000",
      );
      expect(
          substituteHttpRequestModel(
              httpRequestModel, envMap, activeEnvironmentId),
          expected);
    });
  });

  group("Testing getEnvironmentTriggerSuggestions function", () {
    test("Testing getEnvironmentTriggerSuggestion with empty envMap", () {
      const query = "u";
      Map<String, List<EnvironmentVariableModel>> envMap = {};
      const activeEnvironmentId = "";
      expect(
          getEnvironmentTriggerSuggestions(query, envMap, activeEnvironmentId),
          []);
    });

    test("Testing getEnvironmentTriggerSuggestion with empty query", () {
      const query = "";
      Map<String, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: globalVars,
        "activeEnvId": activeEnvVars,
      };
      const activeEnvironmentId = "activeEnvId";
      expect(
          getEnvironmentTriggerSuggestions(query, envMap, activeEnvironmentId),
          const [
            EnvironmentVariableSuggestion(
                environmentId: activeEnvironmentId,
                variable: EnvironmentVariableModel(
                    key: "url", value: "api.apidash.dev")),
            EnvironmentVariableSuggestion(
                environmentId: activeEnvironmentId,
                variable:
                    EnvironmentVariableModel(key: "num", value: "8940000")),
            EnvironmentVariableSuggestion(
                environmentId: kGlobalEnvironmentId,
                variable:
                    EnvironmentVariableModel(key: "token", value: "token")),
          ]);
    });
  });

  group("Testing getVariableStatus function", () {
    test("Testing getVariableStatus with variable available in global", () {
      const query = "num";
      Map<String, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: globalVars,
      };
      const expected = EnvironmentVariableSuggestion(
          environmentId: kGlobalEnvironmentId,
          variable: EnvironmentVariableModel(key: "num", value: "5670000"));
      expect(getVariableStatus(query, envMap, null), expected);
    });

    test("Testing getVariableStatus with variable available in active", () {
      const query = "num";
      Map<String, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: globalVars,
        "activeEnvId": activeEnvVars,
      };
      const activeEnvironmentId = "activeEnvId";
      const expected = EnvironmentVariableSuggestion(
          environmentId: activeEnvironmentId,
          variable: EnvironmentVariableModel(key: "num", value: "8940000"));
      expect(getVariableStatus(query, envMap, activeEnvironmentId), expected);
    });

    test("Testing getVariableStatus with unavailable variable", () {
      const query = "path";
      Map<String, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: globalVars,
        "activeEnvId": activeEnvVars,
      };
      const activeEnvironmentId = "activeEnvId";
      const expected = EnvironmentVariableSuggestion(
          isUnknown: true,
          environmentId: "unknown",
          variable: EnvironmentVariableModel(key: query, value: "unknown"));
      expect(getVariableStatus(query, envMap, activeEnvironmentId), expected);
    });
  });
  
  group('getEnvironmentVariableValue tests', () {
    test('returns original value when fromOS is false', () {
      const variable = EnvironmentVariableModel(
        key: 'TEST_KEY',
        value: 'test_value',
        fromOS: false,
      );
      
      final combinedEnvVarMap = {'TEST_KEY': 'mapped_value'};
      final result = getEnvironmentVariableValue(variable, null, combinedEnvVarMap);
      expect(result, 'mapped_value');
    });
    
    test('returns original value when fromOS is false and not in map', () {
      const variable = EnvironmentVariableModel(
        key: 'TEST_KEY',
        value: 'test_value',
        fromOS: false,
      );
      
      final combinedEnvVarMap = <String, String>{};
      final result = getEnvironmentVariableValue(variable, null, combinedEnvVarMap);
      expect(result, 'test_value');
    });
    
    test('returns OS value when fromOS is true and OS variable exists', () {
      final testKey = Platform.environment.keys.firstWhere(
        (key) => Platform.environment[key]?.isNotEmpty ?? false,
        orElse: () => '',
      );
      
      if (testKey.isNotEmpty) {
        final osValue = Platform.environment[testKey];
        
        final variable = EnvironmentVariableModel(
          key: testKey,
          value: 'fallback_value',
          fromOS: true,
        );
        
        final combinedEnvVarMap = <String, String>{};
        final result = getEnvironmentVariableValue(variable, null, combinedEnvVarMap);
        expect(result, osValue);
      } else {
        if (kDebugMode) {
          print('Skipped test: No environment variables available for testing');
        }
      }
    });
    
    test('returns fallback value when fromOS is true but OS variable does not exist', () {
      const nonExistentKey = 'NON_EXISTENT_ENVIRONMENT_VARIABLE_12345';
      
      const variable = EnvironmentVariableModel(
        key: nonExistentKey,
        value: 'fallback_value',
        fromOS: true,
      );
      
      final combinedEnvVarMap = <String, String>{};
      final result = getEnvironmentVariableValue(variable, null, combinedEnvVarMap);
      expect(result, 'fallback_value');
    });
  });
  
  group('substituteHttpRequestModel with OS environment variables', () {
    test('correctly substitutes OS environment variables', () {
      const osKey = 'osVar';
      
      const httpRequestModel = HttpRequestModel(
        url: "{{osVar}}/test",
      );
      
      final osVariable = EnvironmentVariableModel(
        key: osKey,
        value: 'fallback_value',
        fromOS: true,
      );
      
      final Map<String?, List<EnvironmentVariableModel>> envMap = {
        'activeEnvId': [osVariable],
      };
      
      final result = substituteHttpRequestModel(
        httpRequestModel,
        envMap,
        'activeEnvId',
      );
      
      expect(result.url, 'fallback_value/test');
    });
  });
  
  group('substituteVariables with OS environment variables', () {
    test('substitutes OS environment variables when fromOS is true', () {
      final testKey = Platform.environment.keys.firstWhere(
        (key) => Platform.environment[key]?.isNotEmpty ?? false,
        orElse: () => '',
      );
      
      if (testKey.isNotEmpty) {
        final osValue = Platform.environment[testKey];
        
        final input = 'Value from OS: {{$testKey}}';
        
        Map<String, String> combinedEnvVarMap = {testKey: osValue ?? 'fallback_value'};
        
        final result = substituteVariables(input, combinedEnvVarMap, 'env1');
        final expected = 'Value from OS: ${osValue ?? 'fallback_value'}';
        
        expect(result, expected);
      } else {
        if (kDebugMode) {
          print('Skipped test: No environment variables available for testing');
        }
      }
    });
    
    test('falls back to stored value when OS variable not found and fromOS is true', () {
      const nonExistentKey = 'NON_EXISTENT_ENVIRONMENT_VARIABLE_12345';
      const input = 'Fallback value: {{NON_EXISTENT_ENVIRONMENT_VARIABLE_12345}}';
      
      Map<String, String> combinedEnvVarMap = {nonExistentKey: 'fallback_value'};
      
      final result = substituteVariables(input, combinedEnvVarMap, 'env1');
      const expected = 'Fallback value: fallback_value';
      
      expect(result, expected);
    });
  });
  
}
