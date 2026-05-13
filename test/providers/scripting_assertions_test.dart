import 'package:apidash/providers/providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tests for scripting assertions and testing patterns documented in the Scripting User Guide
/// 
/// This test file validates the examples provided in doc/user_guide/scripting_user_guide.md
/// under the "Testing and Assertions" section, ensuring they work as documented.

late ProviderContainer _testContainer;

Future<RequestModel> handlePostResponseScript(
  RequestModel requestModel,
  EnvironmentModel? originalEnvironmentModel,
  void Function(EnvironmentModel, List<EnvironmentVariableModel>)? updateEnv,
) async {
  return _testContainer
      .read(jsRuntimeNotifierProvider.notifier)
      .handlePostResponseScript(
        requestModel,
        originalEnvironmentModel,
        updateEnv,
      );
}

// Test HTTP Response Models
const HttpResponseModel successResponse200 = HttpResponseModel(
  statusCode: 200,
  headers: {
    'content-type': 'application/json',
    'access-control-allow-origin': '*',
  },
  body: '{"id": 1, "name": "John Doe", "email": "john@example.com", "createdAt": "2024-01-01T00:00:00Z"}',
  time: Duration(milliseconds: 250),
);

const HttpResponseModel successResponse201 = HttpResponseModel(
  statusCode: 201,
  headers: {
    'content-type': 'application/json',
  },
  body: '{"id": "user_123", "username": "testuser", "email": "test@example.com"}',
  time: Duration(milliseconds: 450),
);

const HttpResponseModel slowResponse = HttpResponseModel(
  statusCode: 200,
  headers: {
    'content-type': 'application/json',
  },
  body: '{"status": "ok"}',
  time: Duration(milliseconds: 1250),
);

const HttpResponseModel errorResponse400 = HttpResponseModel(
  statusCode: 400,
  headers: {
    'content-type': 'application/json',
  },
  body: '{"error": "validation_failed", "message": "Invalid input"}',
  time: Duration(milliseconds: 100),
);

const HttpResponseModel missingFieldsResponse = HttpResponseModel(
  statusCode: 200,
  headers: {
    'content-type': 'application/json',
  },
  body: '{"id": 1, "name": "John"}',
  time: Duration(milliseconds: 150),
);

const HttpResponseModel wrongTypesResponse = HttpResponseModel(
  statusCode: 200,
  headers: {
    'content-type': 'application/json',
  },
  body: '{"id": "not-a-number", "name": 123, "tags": "not-an-array"}',
  time: Duration(milliseconds: 150),
);

const HttpResponseModel invalidValuesResponse = HttpResponseModel(
  statusCode: 200,
  headers: {
    'content-type': 'application/json',
  },
  body: '{"age": -5, "price": -100, "email": "invalid-email"}',
  time: Duration(milliseconds: 150),
);

// Empty environment for tests
const EnvironmentModel emptyEnvironment = EnvironmentModel(
  id: 'test-env',
  name: 'Test Environment',
  values: [],
);

void main() {
  setUp(() {
    _testContainer = ProviderContainer();
  });

  tearDown(() {
    _testContainer.dispose();
  });

  group('Example 1: Check Status Codes', () {
    test('should pass when status is 200', () async {
      const httpRequest = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/test',
      );

      final requestModel = RequestModel(
        id: 'status-check-pass',
        name: 'Status Check Pass',
        httpRequestModel: httpRequest,
        httpResponseModel: successResponse200,
        postRequestScript: '''
          if (ad.response.status !== 200) {
            ad.console.error('Expected 200, got ' + ad.response.status);
            ad.environment.set("test_status", "FAILED");
            return;
          }
          
          ad.console.log("Status check passed");
          ad.environment.set("test_status", "PASSED");
        ''',
      );

      Map<String, dynamic> capturedEnvVars = {};
      
      void captureEnv(EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        for (var v in values) {
          capturedEnvVars[v.key] = v.value;
        }
      }

      await handlePostResponseScript(requestModel, emptyEnvironment, captureEnv);

      expect(capturedEnvVars['test_status'], equals('PASSED'));
    });

    test('should fail when status is not 200', () async {
      const httpRequest = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/test',
      );

      final requestModel = RequestModel(
        id: 'status-check-fail',
        name: 'Status Check Fail',
        httpRequestModel: httpRequest,
        httpResponseModel: errorResponse400,
        postRequestScript: '''
          if (ad.response.status !== 200) {
            ad.console.error('Expected 200, got ' + ad.response.status);
            ad.environment.set("test_status", "FAILED");
            return;
          }
          
          ad.console.log("Status check passed");
          ad.environment.set("test_status", "PASSED");
        ''',
      );

      Map<String, dynamic> capturedEnvVars = {};
      
      void captureEnv(EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        for (var v in values) {
          capturedEnvVars[v.key] = v.value;
        }
      }

      await handlePostResponseScript(requestModel, emptyEnvironment, captureEnv);

      expect(capturedEnvVars['test_status'], equals('FAILED'));
    });
  });

  group('Example 2: Verify Headers', () {
    test('should verify Content-Type header', () async {
      const httpRequest = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/test',
      );

      final requestModel = RequestModel(
        id: 'header-check',
        name: 'Header Check',
        httpRequestModel: httpRequest,
        httpResponseModel: successResponse200,
        postRequestScript: '''
          const contentType = ad.response.getHeader("Content-Type");
          if (!contentType || !contentType.includes("application/json")) {
            ad.console.error("Missing or wrong Content-Type header");
            ad.environment.set("header_check", "FAILED");
          } else {
            ad.environment.set("header_check", "PASSED");
          }
          
          const corsHeader = ad.response.getHeader("Access-Control-Allow-Origin");
          if (!corsHeader) {
            ad.console.warn("CORS header not found");
            ad.environment.set("cors_check", "MISSING");
          } else {
            ad.environment.set("cors_check", "PRESENT");
          }
        ''',
      );

      Map<String, dynamic> capturedEnvVars = {};
      
      void captureEnv(EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        for (var v in values) {
          capturedEnvVars[v.key] = v.value;
        }
      }

      await handlePostResponseScript(requestModel, emptyEnvironment, captureEnv);

      expect(capturedEnvVars['header_check'], equals('PASSED'));
      expect(capturedEnvVars['cors_check'], equals('PRESENT'));
    });
  });

  group('Example 3: Performance Checks', () {
    test('should detect fast response', () async {
      const httpRequest = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/test',
      );

      final requestModel = RequestModel(
        id: 'perf-check-fast',
        name: 'Performance Check Fast',
        httpRequestModel: httpRequest,
        httpResponseModel: successResponse200,
        postRequestScript: '''
          const maxTime = 500;
          
          if (ad.response.time > maxTime) {
            ad.console.warn('Slow response: ' + ad.response.time + 'ms');
            ad.environment.set("perf_status", "SLOW");
          } else {
            ad.console.log('Response time OK: ' + ad.response.time + 'ms');
            ad.environment.set("perf_status", "FAST");
          }
          
          ad.environment.set("last_response_time", ad.response.time);
        ''',
      );

      Map<String, dynamic> capturedEnvVars = {};
      
      void captureEnv(EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        for (var v in values) {
          capturedEnvVars[v.key] = v.value;
        }
      }

      await handlePostResponseScript(requestModel, emptyEnvironment, captureEnv);

      expect(capturedEnvVars['perf_status'], equals('FAST'));
      expect(capturedEnvVars['last_response_time'], equals('250'));
    });

    test('should detect slow response', () async {
      const httpRequest = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/test',
      );

      final requestModel = RequestModel(
        id: 'perf-check-slow',
        name: 'Performance Check Slow',
        httpRequestModel: httpRequest,
        httpResponseModel: slowResponse,
        postRequestScript: '''
          const maxTime = 500;
          
          if (ad.response.time > maxTime) {
            ad.console.warn('Slow response: ' + ad.response.time + 'ms');
            ad.environment.set("perf_status", "SLOW");
          } else {
            ad.console.log('Response time OK: ' + ad.response.time + 'ms');
            ad.environment.set("perf_status", "FAST");
          }
          
          ad.environment.set("last_response_time", ad.response.time);
        ''',
      );

      Map<String, dynamic> capturedEnvVars = {};
      
      void captureEnv(EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        for (var v in values) {
          capturedEnvVars[v.key] = v.value;
        }
      }

      await handlePostResponseScript(requestModel, emptyEnvironment, captureEnv);

      expect(capturedEnvVars['perf_status'], equals('SLOW'));
      expect(capturedEnvVars['last_response_time'], equals('1250'));
    });
  });

  group('Example 3b: Track Performance Over Time', () {
    test('should track response times across multiple runs', () async {
      const httpRequest = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/test',
      );

      final requestModel = RequestModel(
        id: 'perf-tracking',
        name: 'Performance Tracking',
        httpRequestModel: httpRequest,
        httpResponseModel: successResponse200,
        postRequestScript: '''
          const history = JSON.parse(ad.environment.get("response_time_history") || "[]");
          
          history.push({
            time: ad.response.time,
            timestamp: Date.now(),
            url: ad.request.url.get()
          });
          
          if (history.length > 10) {
            history.shift();
          }
          
          ad.environment.set("response_time_history", JSON.stringify(history));
          
          const avgTime = history.reduce((sum, h) => sum + h.time, 0) / history.length;
          ad.environment.set("avg_response_time", avgTime.toFixed(2));
          ad.console.log('Current: ' + ad.response.time + 'ms, Average: ' + avgTime.toFixed(2) + 'ms');
          
          if (ad.response.time > avgTime * 1.5) {
            ad.console.warn('Performance degradation detected! 50% slower than average');
            ad.environment.set("degradation_detected", "true");
          }
        ''',
      );

      Map<String, dynamic> capturedEnvVars = {};
      
      void captureEnv(EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        for (var v in values) {
          capturedEnvVars[v.key] = v.value;
        }
      }

      await handlePostResponseScript(requestModel, emptyEnvironment, captureEnv);

      expect(capturedEnvVars['response_time_history'], isNotNull);
      expect(capturedEnvVars['avg_response_time'], equals('250.00'));
    });
  });

  group('Example 4: Verify Required Fields', () {
    test('should pass when all required fields are present', () async {
      const httpRequest = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/test',
      );

      final requestModel = RequestModel(
        id: 'required-fields-check',
        name: 'Required Fields Check',
        httpRequestModel: httpRequest,
        httpResponseModel: successResponse200,
        postRequestScript: '''
          const data = ad.response.json();
          
          if (!data) {
            ad.console.error("Failed to parse JSON");
            ad.environment.set("field_check", "FAILED");
            return;
          }
          
          const required = ["id", "name", "email", "createdAt"];
          const missing = required.filter(field => !(field in data));
          
          if (missing.length > 0) {
            ad.console.error('Missing fields: ' + missing.join(", "));
            ad.environment.set("field_check", "FAILED");
            ad.environment.set("missing_fields", JSON.stringify(missing));
          } else {
            ad.console.log("All required fields found");
            ad.environment.set("field_check", "PASSED");
          }
        ''',
      );

      Map<String, dynamic> capturedEnvVars = {};
      
      void captureEnv(EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        for (var v in values) {
          capturedEnvVars[v.key] = v.value;
        }
      }

      await handlePostResponseScript(requestModel, emptyEnvironment, captureEnv);

      expect(capturedEnvVars['field_check'], equals('PASSED'));
    });

    test('should fail when required fields are missing', () async {
      const httpRequest = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/test',
      );

      final requestModel = RequestModel(
        id: 'missing-fields-check',
        name: 'Missing Fields Check',
        httpRequestModel: httpRequest,
        httpResponseModel: missingFieldsResponse,
        postRequestScript: '''
          const data = ad.response.json();
          
          if (!data) {
            ad.console.error("Failed to parse JSON");
            ad.environment.set("field_check", "FAILED");
            return;
          }
          
          const required = ["id", "name", "email", "createdAt"];
          const missing = required.filter(field => !(field in data));
          
          if (missing.length > 0) {
            ad.console.error('Missing fields: ' + missing.join(", "));
            ad.environment.set("field_check", "FAILED");
            ad.environment.set("missing_fields", JSON.stringify(missing));
          } else {
            ad.console.log("All required fields found");
            ad.environment.set("field_check", "PASSED");
          }
        ''',
      );

      Map<String, dynamic> capturedEnvVars = {};
      
      void captureEnv(EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        for (var v in values) {
          capturedEnvVars[v.key] = v.value;
        }
      }

      await handlePostResponseScript(requestModel, emptyEnvironment, captureEnv);

      expect(capturedEnvVars['field_check'], equals('FAILED'));
      expect(capturedEnvVars['missing_fields'], contains('email'));
      expect(capturedEnvVars['missing_fields'], contains('createdAt'));
    });
  });

  group('Example 5: Check Data Types', () {
    test('should validate correct data types', () async {
      const httpRequest = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/test',
      );

      final requestModel = RequestModel(
        id: 'type-check',
        name: 'Type Check',
        httpRequestModel: httpRequest,
        httpResponseModel: successResponse200,
        postRequestScript: '''
          const data = ad.response.json();
          let errors = 0;
          
          if (typeof data.id !== "number") {
            ad.console.error("id should be a number");
            errors++;
          }
          
          if (typeof data.name !== "string") {
            ad.console.error("name should be a string");
            errors++;
          }
          
          ad.environment.set("type_check", errors === 0 ? "PASSED" : "FAILED");
          ad.environment.set("type_errors", errors.toString());
        ''',
      );

      Map<String, dynamic> capturedEnvVars = {};
      
      void captureEnv(EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        for (var v in values) {
          capturedEnvVars[v.key] = v.value;
        }
      }

      await handlePostResponseScript(requestModel, emptyEnvironment, captureEnv);

      expect(capturedEnvVars['type_check'], equals('PASSED'));
      expect(capturedEnvVars['type_errors'], equals('0'));
    });
  });

  group('Example 7: Complete Test for an Endpoint', () {
    test('should run comprehensive test suite', () async {
      const httpRequest = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.apidash.dev/users',
      );

      final requestModel = RequestModel(
        id: 'complete-test',
        name: 'Complete Test',
        httpRequestModel: httpRequest,
        httpResponseModel: successResponse201,
        postRequestScript: '''
          const data = ad.response.json();
          let passed = 0;
          let failed = 0;
          
          function check(name, condition) {
            if (condition) {
              ad.console.log("✓ " + name);
              passed++;
            } else {
              ad.console.error("✗ " + name);
              failed++;
            }
          }
          
          check("Status is 201", ad.response.status === 201);
          check("Response under 1s", ad.response.time < 1000);
          check("Content-Type is JSON", 
            ad.response.getHeader("Content-Type")?.includes("application/json"));
          
          if (data) {
            check("Has id field", "id" in data);
            check("Has username field", "username" in data);
            check("Has email field", "email" in data);
            check("id is string", typeof data.id === "string");
            check("email format valid", /^[^\\\\s@]+@[^\\\\s@]+\\\\.[^\\\\s@]+/.test(data.email));
            check("password not exposed", !("password" in data));
            
            if (data.id) {
              ad.environment.set("user_id", data.id);
            }
          }
          
          const total = passed + failed;
          const rate = total > 0 ? Math.round((passed / total) * 100) : 0;
          ad.console.log('\\n' + passed + '/' + total + ' tests passed (' + rate + '%)');
          ad.environment.set("test_result", failed === 0 ? "PASSED" : "FAILED");
          ad.environment.set("tests_passed", passed.toString());
          ad.environment.set("tests_failed", failed.toString());
          ad.environment.set("pass_rate", rate.toString());
        ''',
      );

      Map<String, dynamic> capturedEnvVars = {};
      
      void captureEnv(EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        for (var v in values) {
          capturedEnvVars[v.key] = v.value;
        }
      }

      await handlePostResponseScript(requestModel, emptyEnvironment, captureEnv);

      expect(capturedEnvVars['test_result'], equals('PASSED'));
      expect(capturedEnvVars['tests_passed'], equals('9'));
      expect(capturedEnvVars['tests_failed'], equals('0'));
      expect(capturedEnvVars['pass_rate'], equals('100'));
      expect(capturedEnvVars['user_id'], equals('user_123'));
    });
  });
}
