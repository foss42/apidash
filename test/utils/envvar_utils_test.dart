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
  values: [...envVars, emptyEnvVar, ...envSecrets, emptyEnvSecret],
);
const emptyEnvironmentModel = EnvironmentModel(
  id: "id",
  name: "Testing",
  values: [],
);
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
      expect(getEnvironmentVariables(environmentModel), [
        ...envVars,
        emptyEnvVar,
      ]);
    });

    test(
      "Testing getEnvironmentVariables with non-empty environmentModel and removeEmptyModels",
      () {
        expect(
          getEnvironmentVariables(environmentModel, removeEmptyModels: true),
          envVars,
        );
      },
    );
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
      expect(getEnvironmentSecrets(environmentModel), [
        ...envSecrets,
        emptyEnvSecret,
      ]);
    });

    test(
      "Testing getEnvironmentSecrets with non-empty environmentModel and removeEmptyModels",
      () {
        expect(
          getEnvironmentSecrets(environmentModel, removeEmptyModels: true),
          envSecrets,
        );
      },
    );
  });

  group("Testing substituteVariables function", () {
    test("Testing substituteVariables with null", () {
      String? input;
      Map<String, String> envMap = {};
      expect(substituteVariables(input, envMap), null);
    });

    test("Testing substituteVariables with empty input", () {
      String input = "";
      Map<String, String> envMap = {};
      expect(substituteVariables(input, envMap), "");
    });

    test("Testing substituteVariables with empty envMap", () {
      String input = "{{url}}/humanize/social?num={{num}}";
      Map<String, String> envMap = {};
      String expected = "{{url}}/humanize/social?num={{num}}";
      expect(substituteVariables(input, envMap), expected);
    });

    test("Testing substituteVariables with empty activeEnvironmentId", () {
      String input = "{{url}}/humanize/social?num={{num}}";
      String expected = "api.foss42.com/humanize/social?num=5670000";
      expect(substituteVariables(input, globalVarsMap), expected);
    });

    test("Testing substituteVariables with non-empty activeEnvironmentId", () {
      String input = "{{url}}/humanize/social?num={{num}}";
      String expected = "api.apidash.dev/humanize/social?num=8940000";
      expect(substituteVariables(input, combinedEnvVarsMap), expected);
    });

    test("Testing substituteVariables with incorrect parenthesis", () {
      String input = "{{url}}}/humanize/social?num={{num}}";
      String expected = "api.apidash.dev}/humanize/social?num=8940000";
      expect(substituteVariables(input, combinedEnvVarsMap), expected);
    });

    test("Testing substituteVariables function with unavailable variables", () {
      String input = "{{url1}}/humanize/social?num={{num}}";
      String expected = "{{url1}}/humanize/social?num=8940000";
      expect(substituteVariables(input, combinedEnvVarsMap), expected);
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
          httpRequestModel,
          envMap,
          activeEnvironmentId,
        ),
        expected,
      );
    });

    test("Testing substituteHttpRequestModel with non-empty", () {
      const httpRequestModel = HttpRequestModel(
        url: "{{url}}/humanize/social",
        headers: [
          NameValueModel(name: "Authorization", value: "Bearer {{token}}"),
        ],
        params: [NameValueModel(name: "num", value: "{{num}}")],
      );

      Map<String?, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: globalVars,
        "activeEnvId": activeEnvVars,
      };

      String? activeEnvironmentId = "activeEnvId";
      const expected = HttpRequestModel(
        url: "api.apidash.dev/humanize/social",
        headers: [NameValueModel(name: "Authorization", value: "Bearer token")],
        params: [NameValueModel(name: "num", value: "8940000")],
      );
      expect(
        substituteHttpRequestModel(
          httpRequestModel,
          envMap,
          activeEnvironmentId,
        ),
        expected,
      );
    });

    test("Testing substituteHttpRequestModel with unavailable variables", () {
      const httpRequestModel = HttpRequestModel(
        url: "{{url1}}/humanize/social",
        headers: [
          NameValueModel(name: "Authorization", value: "Bearer {{token1}}"),
        ],
        params: [NameValueModel(name: "num", value: "{{num}}")],
      );
      Map<String?, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: globalVars,
        "activeEnvId": activeEnvVars,
      };
      String? activeEnvironmentId = "activeEnvId";
      const expected = HttpRequestModel(
        url: "{{url1}}/humanize/social",
        headers: [
          NameValueModel(name: "Authorization", value: "Bearer {{token1}}"),
        ],
        params: [NameValueModel(name: "num", value: "8940000")],
      );
      expect(
        substituteHttpRequestModel(
          httpRequestModel,
          envMap,
          activeEnvironmentId,
        ),
        expected,
      );
    });

    test(
      "Testing substituteHttpRequestModel with environment variables in body",
      () {
        const httpRequestModel = HttpRequestModel(
          url: "{{url}}/humanize/social",
          headers: [
            NameValueModel(name: "Authorization", value: "Bearer {{token}}"),
          ],
          params: [NameValueModel(name: "num", value: "{{num}}")],
          body: "The API key is {{token}} and the number is {{num}}",
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
          params: [NameValueModel(name: "num", value: "8940000")],
          body: "The API key is token and the number is 8940000",
        );
        expect(
          substituteHttpRequestModel(
            httpRequestModel,
            envMap,
            activeEnvironmentId,
          ),
          expected,
        );
      },
    );

    test(
      "Testing substituteHttpRequestModel with environment variables in form data names and values",
      () {
        const httpRequestModel = HttpRequestModel(
          url: "{{url}}/submit",
          bodyContentType: ContentType.formdata,
          formData: [
            FormDataModel(
              name: "{{header_name}}",
              value: "{{token}}",
              type: FormDataType.text,
            ),
            FormDataModel(
              name: "file_{{num}}",
              value: "/tmp/upload.txt",
              type: FormDataType.file,
            ),
          ],
        );

        Map<String?, List<EnvironmentVariableModel>> envMap = {
          kGlobalEnvironmentId: globalVars,
          "activeEnvId": activeEnvVars,
          "activeEnvId2": [
            const EnvironmentVariableModel(
              key: "header_name",
              value: "X-Token",
            ),
          ],
        };

        const activeEnvironmentId = "activeEnvId2";
        const expected = HttpRequestModel(
          url: "api.foss42.com/submit",
          bodyContentType: ContentType.formdata,
          formData: [
            FormDataModel(
              name: "X-Token",
              value: "token",
              type: FormDataType.text,
            ),
            FormDataModel(
              name: "file_5670000",
              value: "/tmp/upload.txt",
              type: FormDataType.file,
            ),
          ],
        );

        expect(
          substituteHttpRequestModel(
            httpRequestModel,
            envMap,
            activeEnvironmentId,
          ),
          expected,
        );
      },
    );
  });

  group("Testing getEnvironmentTriggerSuggestions function", () {
    test("Testing getEnvironmentTriggerSuggestion with empty envMap", () {
      const query = "u";
      Map<String, List<EnvironmentVariableModel>> envMap = {};
      const activeEnvironmentId = "";
      expect(
        getEnvironmentTriggerSuggestions(query, envMap, activeEnvironmentId),
        [],
      );
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
              key: "url",
              value: "api.apidash.dev",
            ),
          ),
          EnvironmentVariableSuggestion(
            environmentId: activeEnvironmentId,
            variable: EnvironmentVariableModel(key: "num", value: "8940000"),
          ),
          EnvironmentVariableSuggestion(
            environmentId: kGlobalEnvironmentId,
            variable: EnvironmentVariableModel(key: "token", value: "token"),
          ),
        ],
      );
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
        variable: EnvironmentVariableModel(key: "num", value: "5670000"),
      );
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
        variable: EnvironmentVariableModel(key: "num", value: "8940000"),
      );
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
        variable: EnvironmentVariableModel(key: query, value: "unknown"),
      );
      expect(getVariableStatus(query, envMap, activeEnvironmentId), expected);
    });

    test(
      "Testing getVariableStatus with activeEnvironmentId absent from envMap",
      () {
        const query = "num";
        Map<String, List<EnvironmentVariableModel>> envMap = {
          kGlobalEnvironmentId: globalVars,
        };
        const activeEnvironmentId = "missingEnvId";
        const expected = EnvironmentVariableSuggestion(
          environmentId: kGlobalEnvironmentId,
          variable: EnvironmentVariableModel(key: "num", value: "5670000"),
        );
        expect(getVariableStatus(query, envMap, activeEnvironmentId), expected);
      },
    );
  });

  group("Testing auth model environment variable substitution", () {
    test("Testing basic auth with environment variables", () {
      const httpRequestModel = HttpRequestModel(
        url: "{{url}}/test",
        authModel: AuthModel(
          type: APIAuthType.basic,
          basic: AuthBasicAuthModel(
            username: "{{basic_username}}admin",
            password: "{{token}}pass",
          ),
        ),
      );

      Map<String?, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: [
          EnvironmentVariableModel(key: "url", value: "api.apidash.dev"),
          EnvironmentVariableModel(key: "basic_username", value: "testuser"),
          EnvironmentVariableModel(key: "token", value: "secret"),
        ],
      };

      const activeEnvironmentId = null;
      final result = substituteHttpRequestModel(
        httpRequestModel,
        envMap,
        activeEnvironmentId,
      );

      expect(result.authModel?.basic?.username, "testuseradmin");
      expect(result.authModel?.basic?.password, "secretpass");
      expect(result.url, "api.apidash.dev/test");
    });

    test("Testing bearer auth with environment variables", () {
      const httpRequestModel = HttpRequestModel(
        url: "{{url}}/test",
        authModel: AuthModel(
          type: APIAuthType.bearer,
          bearer: AuthBearerModel(token: "{{bearer_token}}"),
        ),
      );

      Map<String?, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: [
          EnvironmentVariableModel(key: "url", value: "api.apidash.dev"),
          EnvironmentVariableModel(key: "bearer_token", value: "secret123"),
        ],
      };

      const activeEnvironmentId = null;
      final result = substituteHttpRequestModel(
        httpRequestModel,
        envMap,
        activeEnvironmentId,
      );

      expect(result.authModel?.bearer?.token, "secret123");
    });

    test("Testing API key auth with environment variables", () {
      const httpRequestModel = HttpRequestModel(
        url: "{{url}}/test",
        authModel: AuthModel(
          type: APIAuthType.apiKey,
          apikey: AuthApiKeyModel(
            key: "{{api_key}}",
            name: "{{header_name}}",
            location: "header",
          ),
        ),
      );

      Map<String?, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: [
          EnvironmentVariableModel(key: "url", value: "api.apidash.dev"),
          EnvironmentVariableModel(key: "api_key", value: "key123"),
          EnvironmentVariableModel(key: "header_name", value: "X-API-Key"),
        ],
      };

      const activeEnvironmentId = null;
      final result = substituteHttpRequestModel(
        httpRequestModel,
        envMap,
        activeEnvironmentId,
      );

      expect(result.authModel?.apikey?.key, "key123");
      expect(result.authModel?.apikey?.name, "X-API-Key");
    });

    test("Testing jwt auth with environment variables", () {
      const httpRequestModel = HttpRequestModel(
        url: "{{url}}/test",
        authModel: AuthModel(
          type: APIAuthType.jwt,
          jwt: AuthJwtModel(
            secret: "{{jwt_secret}}",
            privateKey: "{{jwt_private_key}}",
            payload: "{{jwt_payload}}",
            addTokenTo: "header",
            algorithm: "HS256",
            isSecretBase64Encoded: false,
            headerPrefix: "Bearer",
            queryParamKey: "token",
            header: "Authorization",
          ),
        ),
      );

      Map<String?, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: [
          EnvironmentVariableModel(key: "url", value: "api.apidash.dev"),
          EnvironmentVariableModel(key: "jwt_secret", value: "sec123"),
          EnvironmentVariableModel(key: "jwt_private_key", value: "pkey"),
          EnvironmentVariableModel(key: "jwt_payload", value: "payload123"),
        ],
      };

      final result = substituteHttpRequestModel(httpRequestModel, envMap, null);

      expect(result.authModel?.jwt?.secret, "sec123");
      expect(result.authModel?.jwt?.privateKey, "pkey");
      expect(result.authModel?.jwt?.payload, "payload123");
    });

    test("Testing jwt auth with null private key does not crash", () {
      const httpRequestModel = HttpRequestModel(
        url: "{{url}}/test",
        authModel: AuthModel(
          type: APIAuthType.jwt,
          jwt: AuthJwtModel(
            secret: "{{jwt_secret}}",
            privateKey: null,
            payload: "{{jwt_payload}}",
            addTokenTo: "header",
            algorithm: "HS256",
            isSecretBase64Encoded: false,
            headerPrefix: "Bearer",
            queryParamKey: "token",
            header: "Authorization",
          ),
        ),
      );

      Map<String?, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: [
          EnvironmentVariableModel(key: "url", value: "api.apidash.dev"),
          EnvironmentVariableModel(key: "jwt_secret", value: "sec123"),
          EnvironmentVariableModel(key: "jwt_payload", value: "payload123"),
        ],
      };

      final result = substituteHttpRequestModel(httpRequestModel, envMap, null);

      expect(result.authModel?.jwt?.secret, "sec123");
      expect(result.authModel?.jwt?.privateKey, null);
      expect(result.authModel?.jwt?.payload, "payload123");
    });

    test("Testing digest auth with environment variables", () {
      const httpRequestModel = HttpRequestModel(
        url: "{{url}}/test",
        authModel: AuthModel(
          type: APIAuthType.digest,
          digest: AuthDigestModel(
            algorithm: "",
            username: "{{user}}",
            password: "{{pass}}",
            realm: "{{realm}}",
            nonce: "{{nonce}}",
            qop: "{{qop}}",
            opaque: "{{opaque}}",
          ),
        ),
      );

      Map<String?, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: [
          EnvironmentVariableModel(key: "url", value: "api.apidash.dev"),
          EnvironmentVariableModel(key: "user", value: "digest_user"),
          EnvironmentVariableModel(key: "pass", value: "digest_pass"),
          EnvironmentVariableModel(key: "realm", value: "realm1"),
          EnvironmentVariableModel(key: "nonce", value: "nonce1"),
          EnvironmentVariableModel(key: "qop", value: "auth"),
          EnvironmentVariableModel(key: "opaque", value: "opaque1"),
        ],
      };

      final result = substituteHttpRequestModel(httpRequestModel, envMap, null);

      expect(result.authModel?.digest?.username, "digest_user");
      expect(result.authModel?.digest?.password, "digest_pass");
      expect(result.authModel?.digest?.realm, "realm1");
      expect(result.authModel?.digest?.nonce, "nonce1");
      expect(result.authModel?.digest?.qop, "auth");
      expect(result.authModel?.digest?.opaque, "opaque1");
    });

    test("Testing oauth1 auth with environment variables", () {
      const httpRequestModel = HttpRequestModel(
        url: "{{url}}/test",
        authModel: AuthModel(
          type: APIAuthType.oauth1,
          oauth1: AuthOAuth1Model(
            consumerKey: "{{consumer_key}}",
            consumerSecret: "{{consumer_secret}}",
            credentialsFilePath: "{{file_path}}",
            accessToken: "{{access_token}}",
            tokenSecret: "{{token_secret}}",
            parameterLocation: "{{param_loc}}",
            version: "{{version}}",
            realm: "{{realm}}",
            callbackUrl: "{{callback_url}}",
            verifier: "{{verifier}}",
            nonce: "{{nonce}}",
            timestamp: "{{timestamp}}",
          ),
        ),
      );

      Map<String?, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: [
          EnvironmentVariableModel(key: "url", value: "api.apidash.dev"),
          EnvironmentVariableModel(key: "consumer_key", value: "ckey"),
          EnvironmentVariableModel(key: "consumer_secret", value: "csec"),
          EnvironmentVariableModel(key: "file_path", value: "path1"),
          EnvironmentVariableModel(key: "access_token", value: "atoken"),
          EnvironmentVariableModel(key: "token_secret", value: "tsec"),
          EnvironmentVariableModel(key: "param_loc", value: "loc1"),
          EnvironmentVariableModel(key: "version", value: "v1"),
          EnvironmentVariableModel(key: "realm", value: "realm2"),
          EnvironmentVariableModel(key: "callback_url", value: "cburl"),
          EnvironmentVariableModel(key: "verifier", value: "ver1"),
          EnvironmentVariableModel(key: "nonce", value: "non2"),
          EnvironmentVariableModel(key: "timestamp", value: "ts1"),
        ],
      };

      final result = substituteHttpRequestModel(httpRequestModel, envMap, null);

      expect(result.authModel?.oauth1?.consumerKey, "ckey");
      expect(result.authModel?.oauth1?.consumerSecret, "csec");
      expect(result.authModel?.oauth1?.credentialsFilePath, "path1");
      expect(result.authModel?.oauth1?.accessToken, "atoken");
      expect(result.authModel?.oauth1?.tokenSecret, "tsec");
      expect(result.authModel?.oauth1?.parameterLocation, "loc1");
      expect(result.authModel?.oauth1?.version, "v1");
      expect(result.authModel?.oauth1?.realm, "realm2");
      expect(result.authModel?.oauth1?.callbackUrl, "cburl");
      expect(result.authModel?.oauth1?.verifier, "ver1");
      expect(result.authModel?.oauth1?.nonce, "non2");
      expect(result.authModel?.oauth1?.timestamp, "ts1");
    });

    test("Testing oauth2 auth with environment variables", () {
      const httpRequestModel = HttpRequestModel(
        url: "{{url}}/test",
        authModel: AuthModel(
          type: APIAuthType.oauth2,
          oauth2: AuthOAuth2Model(
            authorizationUrl: "{{auth_url}}",
            accessTokenUrl: "{{token_url}}",
            clientId: "{{client_id}}",
            clientSecret: "{{client_secret}}",
            credentialsFilePath: "{{file_path}}",
            redirectUrl: "{{redirect_url}}",
            scope: "{{scope}}",
            state: "{{state}}",
            codeChallengeMethod: "{{challenge_method}}",
            codeVerifier: "{{code_verifier}}",
            codeChallenge: "{{code_challenge}}",
            username: "{{username}}",
            password: "{{password}}",
            refreshToken: "{{refresh_token}}",
            identityToken: "{{identity_token}}",
            accessToken: "{{access_token}}",
          ),
        ),
      );

      Map<String?, List<EnvironmentVariableModel>> envMap = {
        kGlobalEnvironmentId: [
          EnvironmentVariableModel(key: "url", value: "api.apidash.dev"),
          EnvironmentVariableModel(key: "auth_url", value: "aurl"),
          EnvironmentVariableModel(key: "token_url", value: "turl"),
          EnvironmentVariableModel(key: "client_id", value: "cid"),
          EnvironmentVariableModel(key: "client_secret", value: "csec"),
          EnvironmentVariableModel(key: "file_path", value: "fpath"),
          EnvironmentVariableModel(key: "redirect_url", value: "rurl"),
          EnvironmentVariableModel(key: "scope", value: "sc1"),
          EnvironmentVariableModel(key: "state", value: "st1"),
          EnvironmentVariableModel(key: "challenge_method", value: "cm1"),
          EnvironmentVariableModel(key: "code_verifier", value: "cv1"),
          EnvironmentVariableModel(key: "code_challenge", value: "cc1"),
          EnvironmentVariableModel(key: "username", value: "uname"),
          EnvironmentVariableModel(key: "password", value: "upass"),
          EnvironmentVariableModel(key: "refresh_token", value: "rtok"),
          EnvironmentVariableModel(key: "identity_token", value: "itok"),
          EnvironmentVariableModel(key: "access_token", value: "atok"),
        ],
      };

      final result = substituteHttpRequestModel(httpRequestModel, envMap, null);

      expect(result.authModel?.oauth2?.authorizationUrl, "aurl");
      expect(result.authModel?.oauth2?.accessTokenUrl, "turl");
      expect(result.authModel?.oauth2?.clientId, "cid");
      expect(result.authModel?.oauth2?.clientSecret, "csec");
      expect(result.authModel?.oauth2?.credentialsFilePath, "fpath");
      expect(result.authModel?.oauth2?.redirectUrl, "rurl");
      expect(result.authModel?.oauth2?.scope, "sc1");
      expect(result.authModel?.oauth2?.state, "st1");
      expect(result.authModel?.oauth2?.codeChallengeMethod, "cm1");
      expect(result.authModel?.oauth2?.codeVerifier, "cv1");
      expect(result.authModel?.oauth2?.codeChallenge, "cc1");
      expect(result.authModel?.oauth2?.username, "uname");
      expect(result.authModel?.oauth2?.password, "upass");
      expect(result.authModel?.oauth2?.refreshToken, "rtok");
      expect(result.authModel?.oauth2?.identityToken, "itok");
      expect(result.authModel?.oauth2?.accessToken, "atok");
    });
  });
}
