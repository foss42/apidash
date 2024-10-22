import 'package:apidash/models/models.dart';
import 'package:apidash/utils/envvar_utils.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
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
const activeEnvVars = [
  EnvironmentVariableModel(key: "url", value: "api.apidash.dev"),
  EnvironmentVariableModel(key: "num", value: "8940000"),
];

void main() {
  group("Testing getEnvironmentTitle function", () {
    String titleUntitled = "untitled";
    test("Testing getEnvironmentTitle with null", () {
      String? envName1;
      expect(getEnvironmentTitle(envName1), titleUntitled);
    });

    test("Testing getEnvironmentTitle with empty string", () {
      String envName2 = "";
      expect(getEnvironmentTitle(envName2), titleUntitled);
    });

    test("Testing getEnvironmentTitle with trimmable string", () {
      String envName3 = "   ";
      expect(getEnvironmentTitle(envName3), titleUntitled);
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
      Map<String?, List<EnvironmentVariableModel>> envMap = {};
      String? activeEnvironmentId;
      expect(substituteVariables(input, envMap, activeEnvironmentId), null);
    });

    test("Testing substituteVariables with empty input", () {
      String input = "";
      Map<String?, List<EnvironmentVariableModel>> envMap = {};
      String? activeEnvironmentId;
      expect(substituteVariables(input, envMap, activeEnvironmentId), "");
    });

    test("Testing substituteVariables with empty envMap", () {
      String input = "{{url}}/humanize/social?num={{num}}";
      Map<String?, List<EnvironmentVariableModel>> envMap = {};
      String? activeEnvironmentId;
      String expected = "/humanize/social?num=";
      expect(substituteVariables(input, envMap, activeEnvironmentId), expected);
    });

    test("Testing substituteVariables with empty activeEnvironmentId", () {
      String input = "{{url}}/humanize/social?num={{num}}";
      Map<String?, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: globalVars,
      };
      String expected = "api.foss42.com/humanize/social?num=5670000";
      expect(substituteVariables(input, envMap, null), expected);
    });

    test("Testing substituteVariables with non-empty activeEnvironmentId", () {
      String input = "{{url}}/humanize/social?num={{num}}";
      Map<String?, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: globalVars,
        "activeEnvId": activeEnvVars,
      };
      String? activeEnvId = "activeEnvId";
      String expected = "api.apidash.dev/humanize/social?num=8940000";
      expect(substituteVariables(input, envMap, activeEnvId), expected);
    });

    test("Testing substituteVariables with incorrect paranthesis", () {
      String input = "{{url}}}/humanize/social?num={{num}}";
      Map<String?, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: globalVars,
        "activeEnvId": activeEnvVars,
      };
      String? activeEnvId = "activeEnvId";
      String expected = "api.apidash.dev}/humanize/social?num=8940000";
      expect(substituteVariables(input, envMap, activeEnvId), expected);
    });

    test("Testing substituteVariables function with unavailable variables", () {
      String input = "{{url1}}/humanize/social?num={{num}}";
      Map<String?, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: globalVars,
        "activeEnvId": activeEnvVars,
      };
      String? activeEnvironmentId = "activeEnvId";
      String expected = "/humanize/social?num=8940000";
      expect(substituteVariables(input, envMap, activeEnvironmentId), expected);
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
        kGlobalEnvironmentId: globalVars,
        "activeEnvId": activeEnvVars,
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
              httpRequestModel, envMap, activeEnvironmentId),
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
        kGlobalEnvironmentId: globalVars,
        "activeEnvId": activeEnvVars,
      };
      String? activeEnvironmentId = "activeEnvId";
      const expected = HttpRequestModel(
        url: "/humanize/social",
        headers: [
          NameValueModel(name: "Authorization", value: "Bearer "),
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
}
