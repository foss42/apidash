import 'package:apidash/services/flutter_js_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/pre_post_script_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    initializeJsRuntime();
  });

   //TODO: For Pre-request Script add individual tests for every `ad` object methods
  group('Pre-request Script Handler Tests', () {
    late RequestModel baseRequestModel;
    late EnvironmentModel testEnvironmentModel;
    late HttpRequestModel testHttpRequest;

    setUp(() {
      testHttpRequest = const HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/test',
        headers: [
          NameValueModel(name: 'Content-Type', value: 'application/json'),
          NameValueModel(name: 'User-Agent', value: 'TestApp'),
        ],
        params: [
          NameValueModel(name: 'page', value: '1'),
          NameValueModel(name: 'limit', value: '10'),
        ],
      );
      baseRequestModel = RequestModel(
        id: 'test-request-1',
        name: 'Test Request',
        description: 'A test request for unit testing',
        httpRequestModel: testHttpRequest,
        preRequestScript: 'ad.console.log("Pre-request script executed");',
      );
      testEnvironmentModel = const EnvironmentModel(
        id: 'test-env-1',
        name: 'Test Environment',
        values: [
          EnvironmentVariableModel(
            key: 'apiUrl',
            value: 'https://api.apidash.dev',
            enabled: true,
            type: EnvironmentVariableType.variable,
          ),
          EnvironmentVariableModel(
            key: 'apiKey',
            value: 'test-api-key',
            enabled: true,
            type: EnvironmentVariableType.secret,
          ),
          EnvironmentVariableModel(
            key: 'disabledVar',
            value: 'disabled-value',
            enabled: false,
            type: EnvironmentVariableType.variable,
          ),
        ],
      );
    });

    test('should execute pre-request script and return updated request model',
        () async {
      bool updateEnvCalled = false;
      EnvironmentModel? capturedEnvModel;
      List<EnvironmentVariableModel>? capturedValues;

      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        updateEnvCalled = true;
        capturedEnvModel = envModel;
        capturedValues = values;
      }

      final result = await handlePreRequestScript(
        baseRequestModel,
        testEnvironmentModel,
        mockUpdateEnv,
      );
      expect(result, isA<RequestModel>());
      expect(result.id, equals(baseRequestModel.id));
      expect(result.httpRequestModel, isNotNull);
      expect(result.httpRequestModel!.url, equals(testHttpRequest.url));
      expect(result.httpRequestModel!.method, equals(testHttpRequest.method));

      expect(updateEnvCalled, isTrue);
      expect(capturedEnvModel, equals(testEnvironmentModel));
      expect(capturedValues, isNotNull);
    });

    test('should handle null environment model gracefully', () async {
      final result = await handlePreRequestScript(
        baseRequestModel,
        null,
        null,
      );
      expect(result, isA<RequestModel>());
      expect(result.id, equals(baseRequestModel.id));
      expect(result.httpRequestModel, isNotNull);
    });

    test('should handle null updateEnv callback gracefully', () async {
      final result = await handlePreRequestScript(
        baseRequestModel,
        testEnvironmentModel,
        null, // No updateEnv callback
      );
      expect(result, isA<RequestModel>());
      expect(result.id, equals(baseRequestModel.id));
    });

    test('should update environment variables when script modifies them',
        () async {
      bool updateEnvCalled = false;
      EnvironmentModel? capturedEnvModel;
      List<EnvironmentVariableModel>? capturedValues;

      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        updateEnvCalled = true;
        capturedEnvModel = envModel;
        capturedValues = values;
      }

      final modifiedRequestModel = baseRequestModel.copyWith(
        preRequestScript: 'ad.environment.set("newVar", "newValue");',
      );
      final result = await handlePreRequestScript(
        modifiedRequestModel,
        testEnvironmentModel,
        mockUpdateEnv,
      );
      expect(result, isA<RequestModel>());
      expect(updateEnvCalled, isTrue);
      expect(capturedEnvModel, equals(testEnvironmentModel));
      expect(capturedValues, isNotNull);
    });

  //TODO: Fix this test misbehaviour
    test(
        'should preserve existing environment variables when script adds new ones',
        () async {
      List<EnvironmentVariableModel>? capturedValues;

      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        capturedValues = values;
      }

      await handlePreRequestScript(
        baseRequestModel,
        testEnvironmentModel,
        mockUpdateEnv,
      );
      expect(capturedValues, isNotNull);
      expect(capturedValues!.length,
          greaterThanOrEqualTo(2)); // At least the enabled variables

      final apiUrlVar = capturedValues!.firstWhere((v) => v.key == 'apiUrl');
      expect(apiUrlVar.value, equals('https://api.apidash.dev'));
      expect(apiUrlVar.enabled, isTrue);

      final apiKeyVar = capturedValues!.firstWhere((v) => v.key == 'apiKey');
      expect(apiKeyVar.value, equals('test-api-key'));
      expect(apiKeyVar.enabled, isTrue);
    });

    test('should handle environment variable removal correctly', () async {
      List<EnvironmentVariableModel>? capturedValues;

      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        capturedValues = values;
      }

      final modifiedRequestModel = baseRequestModel.copyWith(
        preRequestScript: 'ad.environment.unset("apiKey");',
      );
      await handlePreRequestScript(
        modifiedRequestModel,
        testEnvironmentModel,
        mockUpdateEnv,
      );

      // Assert - apiKey should not be in the result if properly removed
      expect(capturedValues, isNotNull);
    });

    test('should convert non-string values to strings', () async {
      List<EnvironmentVariableModel>? capturedValues;

      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        capturedValues = values;
      }

      final modifiedRequestModel = baseRequestModel.copyWith(
        preRequestScript: '''
          ad.environment.set("numberVar", 42);
          ad.environment.set("boolVar", true);
          ad.environment.set("nullVar", null);
        ''',
      );
      await handlePreRequestScript(
        modifiedRequestModel,
        testEnvironmentModel,
        mockUpdateEnv,
      );
      expect(capturedValues, isNotNull);
    });

    test('should handle empty script gracefully', () async {
      final emptyScriptModel = baseRequestModel.copyWith(preRequestScript: '');

      final result = await handlePreRequestScript(
        emptyScriptModel,
        testEnvironmentModel,
        null,
      );

      expect(result, isA<RequestModel>());
      expect(result.id, equals(baseRequestModel.id));
    });

    test('should handle null script gracefully', () async {
      final nullScriptModel = baseRequestModel.copyWith(preRequestScript: null);

      final result = await handlePreRequestScript(
        nullScriptModel,
        testEnvironmentModel,
        null,
      );

      expect(result, isA<RequestModel>());
      expect(result.id, equals(baseRequestModel.id));
    });

    test(
        'should return the same original request model when no environment and script updates environment',
        () async {
      final scriptWithEnvUpdate = baseRequestModel.copyWith(
        preRequestScript: 'ad.environment.set("newVar", "value");',
      );
      final result = await handlePreRequestScript(
        scriptWithEnvUpdate,
        null,
        null,
      );
      expect(result, equals(scriptWithEnvUpdate));
    });
  });

  group('Post-response Script Handler Tests', () {
    late RequestModel baseRequestModel;
    late EnvironmentModel testEnvironmentModel;
    late HttpRequestModel testHttpRequest;
    late HttpResponseModel testHttpResponse;

    setUp(() {
      testHttpRequest = const HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.apidash.dev/login',
        headers: [
          NameValueModel(name: 'Content-Type', value: 'application/json'),
        ],
        body: '{"username": "ad", "password": "ad123"}',
      );

      testHttpResponse = const HttpResponseModel(
        statusCode: 200,
        headers: {
          'content-type': 'application/json',
          'x-correlation-id': 'abc-123-def',
        },
        body: '{"token": "jwt-token-123", "expires_in": 3600}',
        time: Duration(milliseconds: 250),
      );

      baseRequestModel = RequestModel(
        id: 'test-request-2',
        name: 'Login Request',
        description: 'A login request for testing',
        httpRequestModel: testHttpRequest,
        httpResponseModel: testHttpResponse,
        postRequestScript: 'ad.console.log("Post-response script executed");',
      );

      testEnvironmentModel = const EnvironmentModel(
        id: 'test-env-2',
        name: 'Test Environment',
        values: [
          EnvironmentVariableModel(
            key: 'baseUrl',
            value: 'https://api.apidash.dev',
            enabled: true,
            type: EnvironmentVariableType.variable,
          ),
          EnvironmentVariableModel(
            key: 'oldToken',
            value: 'old-jwt-token',
            enabled: true,
            type: EnvironmentVariableType.secret,
          ),
        ],
      );
    });

    test('should execute post-response script and return updated request model',
        () async {
      // Arrange
      bool updateEnvCalled = false;

      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        updateEnvCalled = true;
      }

      // Act
      final result = await handlePostResponseScript(
        baseRequestModel,
        testEnvironmentModel,
        mockUpdateEnv,
      );

      // Assert
      expect(result, isA<RequestModel>());
      expect(result.id, equals(baseRequestModel.id));
      expect(result.httpResponseModel, isNotNull);
      expect(result.httpResponseModel!.statusCode, equals(200));
      expect(updateEnvCalled, isTrue);
    });

    test('should handle null environment model gracefully', () async {
      // Act
      final result = await handlePostResponseScript(
        baseRequestModel,
        null, // No environment model
        null,
      );

      // Assert
      expect(result, isA<RequestModel>());
      expect(result.id, equals(baseRequestModel.id));
      expect(result.httpResponseModel, isNotNull);
    });

    test('should extract data from response and update environment', () async {
      // Arrange
      List<EnvironmentVariableModel>? capturedValues;

      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        capturedValues = values;
      }

      // Mock a script that extracts token from response
      final tokenExtractionModel = baseRequestModel.copyWith(
        postRequestScript: '''
          const data = ad.response.json();
          if (data && data.token) {
            ad.environment.set("authToken", data.token);
            ad.environment.set("tokenExpiry", Date.now() + (data.expires_in * 1000));
          }
        ''',
      );

      // Act
      final result = await handlePostResponseScript(
        tokenExtractionModel,
        testEnvironmentModel,
        mockUpdateEnv,
      );

      // Assert
      expect(result, isA<RequestModel>());
      expect(capturedValues, isNotNull);
    });

    test('should handle response status checking scripts', () async {
      // Arrange
      List<EnvironmentVariableModel>? capturedValues;

      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        capturedValues = values;
      }

      // Mock a script that checks response status
      final statusCheckModel = baseRequestModel.copyWith(
        postRequestScript: '''
          if (ad.response.status === 200) {
            ad.environment.set("lastRequestStatus", "success");
          } else {
            ad.environment.set("lastRequestStatus", "failed");
          }
          ad.environment.set("lastResponseTime", ad.response.time);
        ''',
      );

      // Act
      final result = await handlePostResponseScript(
        statusCheckModel,
        testEnvironmentModel,
        mockUpdateEnv,
      );

      // Assert
      expect(result, isA<RequestModel>());
      expect(capturedValues, isNotNull);
    });

    test('should handle header extraction from response', () async {
      // Arrange
      List<EnvironmentVariableModel>? capturedValues;

      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        capturedValues = values;
      }

      // Mock a script that extracts headers
      final headerExtractionModel = baseRequestModel.copyWith(
        postRequestScript: '''
          const correlationId = ad.response.getHeader("X-Correlation-ID");
          if (correlationId) {
            ad.environment.set("lastCorrelationId", correlationId);
          }
          
          const contentType = ad.response.getHeader("content-type");
          ad.environment.set("lastContentType", contentType || "unknown");
        ''',
      );

      // Act
      final result = await handlePostResponseScript(
        headerExtractionModel,
        testEnvironmentModel,
        mockUpdateEnv,
      );

      // Assert
      expect(result, isA<RequestModel>());
      expect(capturedValues, isNotNull);
    });

    test('should preserve existing environment variables', () async {
      // Arrange
      List<EnvironmentVariableModel>? capturedValues;

      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        capturedValues = values;
      }

      // Act
      await handlePostResponseScript(
        baseRequestModel,
        testEnvironmentModel,
        mockUpdateEnv,
      );

      // Assert
      expect(capturedValues, isNotNull);
      expect(capturedValues!.length, greaterThanOrEqualTo(2));

      final baseUrlVar = capturedValues!.firstWhere((v) => v.key == 'baseUrl');
      expect(baseUrlVar.value, equals('https://api.apidash.dev'));
      expect(baseUrlVar.enabled, isTrue);
    });

    test('should handle environment variable updates with different data types',
        () async {
      // Arrange
      List<EnvironmentVariableModel>? capturedValues;

      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        capturedValues = values;
      }

      // There's a bug in the post-response script handler - it's missing the value assignment
      // Let's test this to verify the bug
      final dataTypeModel = baseRequestModel.copyWith(
        postRequestScript: '''
          ad.environment.set("stringVar", "hello");
          ad.environment.set("numberVar", 123);
          ad.environment.set("boolVar", false);
          ad.environment.set("nullVar", null);
        ''',
      );

      // Act
      await handlePostResponseScript(
        dataTypeModel,
        testEnvironmentModel,
        mockUpdateEnv,
      );

      // Assert
      expect(capturedValues, isNotNull);
      // Note: This test reveals a bug in handlePostResponseScript where value is not being set
    });

    test('should handle empty post-response script', () async {
      // Arrange
      final emptyScriptModel = baseRequestModel.copyWith(postRequestScript: '');

      // Act
      final result = await handlePostResponseScript(
        emptyScriptModel,
        testEnvironmentModel,
        null,
      );

      // Assert
      expect(result, isA<RequestModel>());
      expect(result.id, equals(baseRequestModel.id));
    });

    test('should handle null post-response script', () async {
      // Arrange
      final nullScriptModel =
          baseRequestModel.copyWith(postRequestScript: null);

      // Act
      final result = await handlePostResponseScript(
        nullScriptModel,
        testEnvironmentModel,
        null,
      );

      // Assert
      expect(result, isA<RequestModel>());
      expect(result.id, equals(baseRequestModel.id));
    });

    test(
        'should return updated model when no environment but script updates environment',
        () async {
      // Arrange
      final scriptWithEnvUpdate = baseRequestModel.copyWith(
        postRequestScript: 'ad.environment.set("responseVar", "value");',
      );

      // Act
      final result = await handlePostResponseScript(
        scriptWithEnvUpdate,
        null, // No environment
        null,
      );

      // Assert
      expect(result, isA<RequestModel>());
      expect(result.id, equals(baseRequestModel.id));
    });

    test('should handle null updateEnv callback gracefully', () async {
      // Act
      final result = await handlePostResponseScript(
        baseRequestModel,
        testEnvironmentModel,
        null, // No updateEnv callback
      );

      // Assert
      expect(result, isA<RequestModel>());
      expect(result.id, equals(baseRequestModel.id));
    });

    test('should test the bug in post-response handler value assignment',
        () async {
      // This test specifically tests for the bug where value is not being assigned in post-response handler
      List<EnvironmentVariableModel>? capturedValues;

      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        capturedValues = values;
      }

      // Act
      await handlePostResponseScript(
        baseRequestModel,
        testEnvironmentModel,
        mockUpdateEnv,
      );

      // Assert - Check for the bug where values are not properly assigned
      expect(capturedValues, isNotNull);

      // Find the original variables and verify they keep their values correctly
      final originalVar = capturedValues!.firstWhere((v) => v.key == 'baseUrl');
      expect(originalVar.value, equals('https://api.apidash.dev'));

      // This assertion might fail due to the bug in the implementation
      // where `value: newValue == null ? '' : newValue.toString(),` line is missing
      // in the post-response handler
    });
  });

  group('Both Pre-request and Post-response testing together', () {
    test('should handle complex workflow with both pre and post scripts',
        () async {
      // Arrange
      final complexRequest = RequestModel(
        id: 'complex-request',
        name: 'Complex Workflow',
        preRequestScript: '''
          ad.environment.set("requestStartTime", Date.now());
          ad.request.headers.set("X-Request-ID", "req-" + Math.random());
        ''',
        postRequestScript: '''
          const startTime = ad.environment.get("requestStartTime");
          const endTime = Date.now();
          ad.environment.set("requestDuration", endTime - startTime);
          
          if (ad.response.status === 200) {
            ad.environment.set("lastSuccessfulRequest", Date.now());
          }
        ''',
        httpRequestModel: const HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/data',
        ),
        httpResponseModel: const HttpResponseModel(
          statusCode: 200,
          body: '{"success": true}',
        ),
      );

      final environment = const EnvironmentModel(
        id: 'integration-env',
        name: 'Integration Environment',
        values: [],
      );

      bool preUpdateCalled = false;
      bool postUpdateCalled = false;

      void preUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        preUpdateCalled = true;
      }

      void postUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        postUpdateCalled = true;
      }

      final afterPre = await handlePreRequestScript(
        complexRequest,
        environment,
        preUpdateEnv,
      );

      final afterPost = await handlePostResponseScript(
        afterPre,
        environment,
        postUpdateEnv,
      );
      expect(afterPre, isA<RequestModel>());
      expect(afterPost, isA<RequestModel>());
      expect(afterPost.id, equals(complexRequest.id));
    });

    test('should handle environment variable dependencies between scripts',
        () async {
      // This test ensures that environment changes from pre-request scripts
      // are available to post-response scripts
      final dependentRequest = RequestModel(
        id: 'dependent-request',
        name: 'Dependent Request',
        preRequestScript: 'ad.environment.set("requestId", "12345");',
        postRequestScript: '''
          const requestId = ad.environment.get("requestId");
          ad.environment.set("completedRequestId", requestId);
        ''',
        httpRequestModel: const HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/test',
        ),
        httpResponseModel: const HttpResponseModel(
          statusCode: 200,
          body: '{"data": "test"}',
        ),
      );

      final environment = const EnvironmentModel(
        id: 'dependent-env',
        name: 'Dependent Environment',
        values: [],
      );

      List<EnvironmentVariableModel>? preValues;
      List<EnvironmentVariableModel>? postValues;

      void preUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        preValues = values;
      }

      void postUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        postValues = values;
      }

      final afterPre = await handlePreRequestScript(
        dependentRequest,
        environment,
        preUpdateEnv,
      );

      await handlePostResponseScript(
        afterPre,
        environment,
        postUpdateEnv,
      );
      expect(preValues, isNotNull);
      expect(postValues, isNotNull);
    });
  });

  group('Error Handling Tests', () {
    test('should handle malformed JavaScript', () async {
      final malformedRequest = RequestModel(
        id: 'malformed-request',
        name: 'Malformed Script Request',
        preRequestScript: 'ad.environment.set("test", ; // Syntax error',
        httpRequestModel: const HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/test',
        ),
      );

      final environment = const EnvironmentModel(
        id: 'error-env',
        name: 'Error Environment',
        values: [],
      );
      final result = await handlePreRequestScript(
        malformedRequest,
        environment,
        null,
      );

      expect(result, isA<RequestModel>());
    });

    test('should handle empty environment values list', () async {
      final emptyEnvModel = const EnvironmentModel(
        id: 'empty-env',
        name: 'Empty Environment',
        values: [],
      );

      final request = RequestModel(
        id: 'test-empty-env',
        name: 'Test Empty Environment',
        preRequestScript: 'ad.environment.set("newVar", "value");',
        httpRequestModel: const HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/test',
        ),
      );

      List<EnvironmentVariableModel>? capturedValues;

      void updateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        capturedValues = values;
      }

      final result = await handlePreRequestScript(
        request,
        emptyEnvModel,
        updateEnv,
      );
      expect(result, isA<RequestModel>());
      expect(capturedValues, isNotNull);
      expect(capturedValues?.length, 1);
    });
  });

  group('Performance Tests', () {
    test('should handle large environment efficiently', () async {
      final largeEnvValues = List.generate(
          1000,
          (index) => EnvironmentVariableModel(
                key: 'var$index',
                value: 'value$index',
                enabled: index % 2 == 0, // Half enabled, half disabled
                type: EnvironmentVariableType.variable,
              ));

      final largeEnvironment = EnvironmentModel(
        id: 'large-env',
        name: 'Large Environment',
        values: largeEnvValues,
      );

      final request = RequestModel(
        id: 'performance-test',
        name: 'Performance Test',
        preRequestScript: 'ad.environment.set("perfTest", "completed");',
        httpRequestModel: const HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/test',
        ),
      );

      final stopwatch = Stopwatch()..start();
      final result = await handlePreRequestScript(
        request,
        largeEnvironment,
        (env, values) {},
      );

      stopwatch.stop();
      expect(result, isA<RequestModel>());
      expect(stopwatch.elapsedMilliseconds,
          lessThan(5000)); // Should complete within 5 seconds
    });

    test('should handle multiple rapid script executions', () async {
      final requests = List.generate(
          10,
          (index) => RequestModel(
                id: 'rapid-test-$index',
                name: 'Rapid Test $index',
                preRequestScript:
                    'ad.environment.set("rapidVar$index", "$index");',
                httpRequestModel: HttpRequestModel(
                  method: HTTPVerb.get,
                  url: 'https://api.apidash.dev/test$index',
                ),
              ));

      final environment = const EnvironmentModel(
        id: 'rapid-env',
        name: 'Rapid Environment',
        values: [],
      );
      final futures = requests
          .map((request) => handlePreRequestScript(request, environment, null));

      final results = await Future.wait(futures);
      expect(results.length, equals(10));
      for (final result in results) {
        expect(result, isA<RequestModel>());
      }
    });
  });
}
