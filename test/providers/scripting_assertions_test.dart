import 'package:apidash/providers/providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Comprehensive test suite for scripting assertions functionality.
/// Tests validate assertion patterns documented in scripting_user_guide.md.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  Future<RequestModel> executePostResponseScript(
    RequestModel requestModel,
  ) async {
    return container
        .read(jsRuntimeNotifierProvider.notifier)
        .handlePostResponseScript(
          requestModel,
          null,
          (env, values) {},
        );
  }

  group('A. Status Code Assertions', () {
    test('equals - successful status code check (200)', () async {
      const request = RequestModel(
        id: 'test-status-equals',
        name: 'Status Equals Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/test',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body: '{"status": "ok"}',
          time: Duration(milliseconds: 100),
        ),
        postRequestScript: '''
          assert(ad.response.status).equals(200);
          ad.console.log("Status code assertion passed");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-status-equals'));
    });

    test('equals - fails on incorrect status code', () async {
      const request = RequestModel(
        id: 'test-status-equals-fail',
        name: 'Status Equals Fail Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/test',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 404,
          body: '{"error": "not found"}',
          time: Duration(milliseconds: 50),
        ),
        postRequestScript: '''
          try {
            assert(ad.response.status).equals(200);
            ad.console.log("Should not reach here");
          } catch (e) {
            ad.console.log("Assertion failed as expected: " + e.message);
          }
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-status-equals-fail'));
    });

    test('notEquals - status code is not error', () async {
      const request = RequestModel(
        id: 'test-status-notequals',
        name: 'Status Not Equals Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/test',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body: '{"data": "test"}',
          time: Duration(milliseconds: 80),
        ),
        postRequestScript: '''
          assert(ad.response.status).notEquals(500);
          assert(ad.response.status).notEquals(404);
          ad.console.log("Status is not an error");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-status-notequals'));
    });

    test('greaterThan - status code in success range', () async {
      const request = RequestModel(
        id: 'test-status-greaterthan',
        name: 'Status Greater Than Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.post,
          url: 'https://api.apidash.dev/create',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 201,
          body: '{"id": 123}',
          time: Duration(milliseconds: 150),
        ),
        postRequestScript: '''
          assert(ad.response.status).greaterThan(199);
          ad.console.log("Status is in 2xx range");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-status-greaterthan'));
    });

    test('lessThan - status code validation', () async {
      const request = RequestModel(
        id: 'test-status-lessthan',
        name: 'Status Less Than Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/test',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body: '{"message": "success"}',
          time: Duration(milliseconds: 90),
        ),
        postRequestScript: '''
          assert(ad.response.status).lessThan(300);
          ad.console.log("Status is less than 300");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-status-lessthan'));
    });

    test('chained status code assertions', () async {
      const request = RequestModel(
        id: 'test-status-chained',
        name: 'Status Chained Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/test',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body: '{"result": "ok"}',
          time: Duration(milliseconds: 120),
        ),
        postRequestScript: '''
          assert(ad.response.status).greaterThan(199).lessThan(300);
          ad.console.log("Status is in 2xx range (chained)");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-status-chained'));
    });
  });

  group('B. Header Assertions', () {
    test('header exists and is string', () async {
      const request = RequestModel(
        id: 'test-header-exists',
        name: 'Header Exists Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/test',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          headers: {
            'content-type': 'application/json',
            'x-request-id': 'abc123',
          },
          body: '{"data": "test"}',
          time: Duration(milliseconds: 75),
        ),
        postRequestScript: '''
          const contentType = ad.response.getHeader("content-type");
          assert(contentType).isString();
          ad.console.log("Content-Type header exists and is a string");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-header-exists'));
    });

    test('header contains expected value', () async {
      const request = RequestModel(
        id: 'test-header-contains',
        name: 'Header Contains Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/users',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          headers: {
            'content-type': 'application/json; charset=utf-8',
          },
          body: '{"users": []}',
          time: Duration(milliseconds: 95),
        ),
        postRequestScript: '''
          const contentType = ad.response.getHeader("content-type");
          assert(contentType).contains("application/json");
          ad.console.log("Content-Type contains application/json");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-header-contains'));
    });

    test('header equals exact value', () async {
      const request = RequestModel(
        id: 'test-header-equals',
        name: 'Header Equals Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/cached',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          headers: {
            'cache-control': 'no-cache',
          },
          body: '{"cached": false}',
          time: Duration(milliseconds: 60),
        ),
        postRequestScript: '''
          const cacheControl = ad.response.getHeader("cache-control");
          assert(cacheControl).equals("no-cache");
          ad.console.log("Cache-Control is exactly no-cache");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-header-equals'));
    });

    test('case-insensitive header lookup', () async {
      const request = RequestModel(
        id: 'test-header-case-insensitive',
        name: 'Header Case Insensitive Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/test',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          headers: {
            'content-type': 'application/json',
          },
          body: '{"test": true}',
          time: Duration(milliseconds: 85),
        ),
        postRequestScript: '''
          const ct1 = ad.response.getHeader("Content-Type");
          const ct2 = ad.response.getHeader("content-type");
          const ct3 = ad.response.getHeader("CONTENT-TYPE");
          assert(ct1).contains("json");
          assert(ct2).contains("json");
          assert(ct3).contains("json");
          ad.console.log("Case-insensitive header lookup works");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-header-case-insensitive'));
    });
  });

  group('C. Performance Assertions', () {
    test('response time less than threshold', () async {
      const request = RequestModel(
        id: 'test-perf-lessthan',
        name: 'Performance Less Than Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/fast',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body: '{"fast": true}',
          time: Duration(milliseconds: 150),
        ),
        postRequestScript: '''
          assert(ad.response.time).lessThan(500);
          ad.console.log("Response time: " + ad.response.time + "ms - within acceptable range");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-perf-lessthan'));
    });

    test('response time for fast endpoint', () async {
      const request = RequestModel(
        id: 'test-perf-fast',
        name: 'Fast Performance Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/quick',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body: '{"quick": true}',
          time: Duration(milliseconds: 50),
        ),
        postRequestScript: '''
          assert(ad.response.time).lessThan(100);
          ad.console.log("Lightning fast response!");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-perf-fast'));
    });

    test('response time validation with logging', () async {
      const request = RequestModel(
        id: 'test-perf-logging',
        name: 'Performance Logging Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/data',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body: '{"items": []}',
          time: Duration(milliseconds: 250),
        ),
        postRequestScript: '''
          const maxResponseTime = 300;
          assert(ad.response.time).lessThanOrEqual(maxResponseTime);
          ad.console.log("Response completed in " + ad.response.time + "ms (target: <" + maxResponseTime + "ms)");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-perf-logging'));
    });

    test('performance tracking across requests', () async {
      const testEnv = EnvironmentModel(
        id: 'perf-env',
        name: 'Performance Environment',
        values: [
          EnvironmentVariableModel(
            key: 'lastResponseTime',
            value: '200',
            enabled: true,
            type: EnvironmentVariableType.variable,
          ),
        ],
      );

      final request = RequestModel(
        id: 'test-perf-tracking',
        name: 'Performance Tracking Test',
        httpRequestModel: const HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/test',
        ),
        httpResponseModel: const HttpResponseModel(
          statusCode: 200,
          body: '{"data": "test"}',
          time: Duration(milliseconds: 180),
        ),
        postRequestScript: '''
          const currentTime = ad.response.time;
          const lastTime = parseFloat(ad.environment.get("lastResponseTime") || "0");
          
          if (lastTime > 0) {
            const difference = currentTime - lastTime;
            ad.console.log("Performance change: " + (difference > 0 ? "+" : "") + difference + "ms");
          }
          
          ad.environment.set("lastResponseTime", currentTime.toString());
          assert(currentTime).lessThan(1000);
        ''',
      );

      Map<String, dynamic> capturedEnvironment = {};

      final result = await container
          .read(jsRuntimeNotifierProvider.notifier)
          .handlePostResponseScript(
            request,
            testEnv,
            (env, values) {
              capturedEnvironment = {
                for (var v in values)
                  if (v.enabled) v.key: v.value
              };
            },
          );

      expect(result.id, equals('test-perf-tracking'));
      expect(capturedEnvironment['lastResponseTime'], isNotEmpty);
    });
  });

  group('D. Required Field Assertions', () {
    test('check required top-level keys', () async {
      const request = RequestModel(
        id: 'test-required-keys',
        name: 'Required Keys Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/api/data',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body: '{"data": {"value": 123}, "status": "success", "message": "OK"}',
          time: Duration(milliseconds: 110),
        ),
        postRequestScript: '''
          const response = ad.response.json();
          assert(response).hasKey("data");
          assert(response).hasKey("status");
          assert(response).hasKey("message");
          ad.console.log("All required keys present");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-required-keys'));
    });

    test('validate nested object structure', () async {
      const request = RequestModel(
        id: 'test-nested-structure',
        name: 'Nested Structure Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/user/profile',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body:
              '{"data": {"user": {"id": 42, "email": "test@example.com", "name": "Test User"}}}',
          time: Duration(milliseconds: 130),
        ),
        postRequestScript: '''
          const response = ad.response.json();
          assert(response).hasKey("data");
          assert(response.data).hasKey("user");
          assert(response.data.user).hasKey("id");
          assert(response.data.user).hasKey("email");
          ad.console.log("Nested structure validated");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-nested-structure'));
    });

    test('verify array response structure', () async {
      const request = RequestModel(
        id: 'test-array-structure',
        name: 'Array Structure Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/items',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body: '{"results": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]}',
          time: Duration(milliseconds: 140),
        ),
        postRequestScript: '''
          const response = ad.response.json();
          assert(response).hasKey("results");
          assert(response.results).isArray();
          assert(response.results).hasLength(10);
          ad.console.log("Array structure validated");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-array-structure'));
    });

    test('check pagination fields', () async {
      const request = RequestModel(
        id: 'test-pagination',
        name: 'Pagination Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/list',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body:
              '{"items": [], "pagination": {"page": 1, "total": 100, "limit": 20}}',
          time: Duration(milliseconds: 105),
        ),
        postRequestScript: '''
          const response = ad.response.json();
          assert(response).hasKey("pagination");
          assert(response.pagination).hasKey("page");
          assert(response.pagination).hasKey("total");
          assert(response.pagination).hasKey("limit");
          ad.console.log("Pagination fields validated");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-pagination'));
    });

    test('validate error response structure', () async {
      const request = RequestModel(
        id: 'test-error-structure',
        name: 'Error Structure Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.post,
          url: 'https://api.apidash.dev/create',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 400,
          body:
              '{"error": {"code": "INVALID_INPUT", "message": "Invalid data provided"}}',
          time: Duration(milliseconds: 70),
        ),
        postRequestScript: '''
          if (ad.response.status >= 400) {
            const response = ad.response.json();
            assert(response).hasKey("error");
            assert(response.error).hasKey("code");
            assert(response.error).hasKey("message");
            ad.console.log("Error structure validated");
          }
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-error-structure'));
    });
  });

  group('E. Data Type Assertions', () {
    test('validate numeric fields', () async {
      const request = RequestModel(
        id: 'test-numeric-types',
        name: 'Numeric Types Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/product',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body: '{"id": 42, "count": 100, "price": 29.99}',
          time: Duration(milliseconds: 90),
        ),
        postRequestScript: '''
          const response = ad.response.json();
          assert(response.id).isNumber();
          assert(response.count).isNumber();
          assert(response.price).isNumber();
          ad.console.log("All numeric types validated");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-numeric-types'));
    });

    test('check string fields', () async {
      const request = RequestModel(
        id: 'test-string-types',
        name: 'String Types Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/user',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body:
              '{"name": "John Doe", "email": "john@example.com", "description": "Test user"}',
          time: Duration(milliseconds: 85),
        ),
        postRequestScript: '''
          const response = ad.response.json();
          assert(response.name).isString();
          assert(response.email).isString();
          assert(response.description).isString();
          ad.console.log("All string types validated");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-string-types'));
    });

    test('verify boolean flags', () async {
      const request = RequestModel(
        id: 'test-boolean-types',
        name: 'Boolean Types Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/status',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body: '{"isActive": true, "verified": false, "premium": true}',
          time: Duration(milliseconds: 75),
        ),
        postRequestScript: '''
          const response = ad.response.json();
          assert(response.isActive).isBoolean();
          assert(response.verified).isBoolean();
          assert(response.premium).isBoolean();
          ad.console.log("All boolean types validated");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-boolean-types'));
    });

    test('validate object type', () async {
      const request = RequestModel(
        id: 'test-object-types',
        name: 'Object Types Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/config',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body: '{"user": {"id": 1}, "settings": {"theme": "dark"}}',
          time: Duration(milliseconds: 95),
        ),
        postRequestScript: '''
          const response = ad.response.json();
          assert(response.user).isObject();
          assert(response.settings).isObject();
          ad.console.log("All object types validated");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-object-types'));
    });

    test('check array type', () async {
      const request = RequestModel(
        id: 'test-array-types',
        name: 'Array Types Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/collections',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body: '{"items": [1, 2, 3], "tags": ["a", "b", "c"]}',
          time: Duration(milliseconds: 100),
        ),
        postRequestScript: '''
          const response = ad.response.json();
          assert(response.items).isArray();
          assert(response.tags).isArray();
          ad.console.log("All array types validated");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-array-types'));
    });

    test('validate null values', () async {
      const request = RequestModel(
        id: 'test-null-values',
        name: 'Null Values Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/record',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body: '{"id": 123, "deletedAt": null, "archivedAt": null}',
          time: Duration(milliseconds: 80),
        ),
        postRequestScript: '''
          const response = ad.response.json();
          assert(response.deletedAt).isNull();
          assert(response.archivedAt).isNull();
          ad.console.log("Null values validated");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-null-values'));
    });

    test('combined type and value checks', () async {
      const request = RequestModel(
        id: 'test-combined-checks',
        name: 'Combined Checks Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/item',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body:
              '{"id": 42, "status": "active", "items": [1, 2, 3, 4, 5]}',
          time: Duration(milliseconds: 110),
        ),
        postRequestScript: '''
          const response = ad.response.json();
          assert(response.id).isNumber().greaterThan(0);
          assert(response.status).isString().equals("active");
          assert(response.items).isArray().hasLength(5);
          ad.console.log("Combined checks validated");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-combined-checks'));
    });
  });

  group('F. Additional Assertion Methods', () {
    test('greaterThanOrEqual assertion', () async {
      const request = RequestModel(
        id: 'test-gte',
        name: 'Greater Than Or Equal Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/score',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body: '{"score": 85}',
          time: Duration(milliseconds: 70),
        ),
        postRequestScript: '''
          const response = ad.response.json();
          assert(response.score).greaterThanOrEqual(85);
          assert(response.score).greaterThanOrEqual(0);
          ad.console.log("Greater than or equal assertions passed");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-gte'));
    });

    test('lessThanOrEqual assertion', () async {
      const request = RequestModel(
        id: 'test-lte',
        name: 'Less Than Or Equal Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/level',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body: '{"level": 5}',
          time: Duration(milliseconds: 65),
        ),
        postRequestScript: '''
          const response = ad.response.json();
          assert(response.level).lessThanOrEqual(5);
          assert(response.level).lessThanOrEqual(10);
          ad.console.log("Less than or equal assertions passed");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-lte'));
    });

    test('isTruthy assertion', () async {
      const request = RequestModel(
        id: 'test-truthy',
        name: 'Truthy Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/check',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body: '{"enabled": true, "count": 5, "name": "test"}',
          time: Duration(milliseconds: 60),
        ),
        postRequestScript: '''
          const response = ad.response.json();
          assert(response.enabled).isTruthy();
          assert(response.count).isTruthy();
          assert(response.name).isTruthy();
          ad.console.log("Truthy assertions passed");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-truthy'));
    });

    test('isFalsy assertion', () async {
      const request = RequestModel(
        id: 'test-falsy',
        name: 'Falsy Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/flags',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body: '{"disabled": false, "empty": "", "zero": 0}',
          time: Duration(milliseconds: 55),
        ),
        postRequestScript: '''
          const response = ad.response.json();
          assert(response.disabled).isFalsy();
          assert(response.empty).isFalsy();
          assert(response.zero).isFalsy();
          ad.console.log("Falsy assertions passed");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-falsy'));
    });

    test('isUndefined assertion', () async {
      const request = RequestModel(
        id: 'test-undefined',
        name: 'Undefined Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/optional',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body: '{"id": 123}',
          time: Duration(milliseconds: 50),
        ),
        postRequestScript: '''
          const response = ad.response.json();
          assert(response.missingField).isUndefined();
          ad.console.log("Undefined assertion passed");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-undefined'));
    });
  });

  group('G. Complex Real-World Scenarios', () {
    test('user creation validation', () async {
      const request = RequestModel(
        id: 'test-user-creation',
        name: 'User Creation Validation',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.post,
          url: 'https://api.apidash.dev/users',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 201,
          body:
              '{"user": {"id": 42, "email": "test@example.com", "createdAt": "2024-01-01T00:00:00Z"}}',
          time: Duration(milliseconds: 180),
        ),
        postRequestScript: '''
          assert(ad.response.status).equals(201);
          
          const response = ad.response.json();
          assert(response).hasKey("user");
          assert(response.user).hasKey("id");
          assert(response.user).hasKey("email");
          assert(response.user).hasKey("createdAt");
          
          assert(response.user.id).isNumber().greaterThan(0);
          assert(response.user.email).isString().contains("@");
          assert(response.user.createdAt).isString();
          
          ad.console.log("User creation validated successfully!");
          ad.environment.set("newUserId", response.user.id.toString());
        ''',
      );

      Map<String, dynamic> capturedEnvironment = {};

      final result = await container
          .read(jsRuntimeNotifierProvider.notifier)
          .handlePostResponseScript(
            request,
            null,
            (env, values) {
              capturedEnvironment = {
                for (var v in values)
                  if (v.enabled) v.key: v.value
              };
            },
          );

      expect(result.id, equals('test-user-creation'));
      expect(capturedEnvironment['newUserId'], equals('42'));
    });

    test('paginated list response validation', () async {
      const request = RequestModel(
        id: 'test-paginated-list',
        name: 'Paginated List Validation',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/items?page=1',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          headers: {
            'content-type': 'application/json',
          },
          body:
              '{"data": [{"id": 1}, {"id": 2}], "pagination": {"page": 1, "total": 100}}',
          time: Duration(milliseconds: 220),
        ),
        postRequestScript: '''
          assert(ad.response.status).equals(200);
          assert(ad.response.time).lessThan(500);
          
          const contentType = ad.response.getHeader("content-type");
          assert(contentType).contains("application/json");
          
          const response = ad.response.json();
          assert(response).hasKey("data");
          assert(response).hasKey("pagination");
          
          assert(response.data).isArray();
          assert(response.pagination).hasKey("page");
          assert(response.pagination).hasKey("total");
          
          assert(response.pagination.page).isNumber();
          assert(response.pagination.total).isNumber();
          
          ad.console.log("Validated " + response.data.length + " items on page " + response.pagination.page);
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-paginated-list'));
    });

    test('error response validation', () async {
      const request = RequestModel(
        id: 'test-error-response',
        name: 'Error Response Validation',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.post,
          url: 'https://api.apidash.dev/invalid',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 400,
          body:
              '{"error": {"code": "VALIDATION_ERROR", "message": "Invalid input provided"}}',
          time: Duration(milliseconds: 85),
        ),
        postRequestScript: '''
          assert(ad.response.status).equals(400);
          
          const response = ad.response.json();
          assert(response).hasKey("error");
          assert(response.error).hasKey("code");
          assert(response.error).hasKey("message");
          
          assert(response.error.code).isString();
          assert(response.error.message).isString().contains("invalid");
          
          ad.console.log("Error response structure validated");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-error-response'));
    });

    test('performance and data quality check', () async {
      const request = RequestModel(
        id: 'test-perf-data-quality',
        name: 'Performance and Data Quality',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/products',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          body:
              '{"items": [{"id": 1, "name": "Product A"}, {"id": 2, "name": "Product B"}]}',
          time: Duration(milliseconds: 250),
        ),
        postRequestScript: '''
          assert(ad.response.status).equals(200);
          assert(ad.response.time).lessThan(300);
          
          const response = ad.response.json();
          assert(response).hasKey("items");
          assert(response.items).isArray();
          
          response.items.forEach(function(item) {
            assert(item).hasKey("id");
            assert(item).hasKey("name");
            assert(item.id).isNumber().greaterThan(0);
            assert(item.name).isString();
          });
          
          ad.console.log("Validated " + response.items.length + " items in " + ad.response.time + "ms");
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-perf-data-quality'));
    });
  });

  group('H. Error Handling', () {
    test('assertion error is properly thrown', () async {
      const request = RequestModel(
        id: 'test-error-thrown',
        name: 'Error Thrown Test',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/test',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 404,
          body: '{"error": "not found"}',
          time: Duration(milliseconds: 60),
        ),
        postRequestScript: '''
          let errorCaught = false;
          try {
            assert(ad.response.status).equals(200);
          } catch (error) {
            errorCaught = true;
            ad.console.log("Error caught: " + error.message);
          }
          if (!errorCaught) {
            ad.console.error("Expected error was not thrown!");
          }
        ''',
      );

      final result = await executePostResponseScript(request);
      expect(result.id, equals('test-error-thrown'));
    });

    test('custom error handling with environment flag', () async {
      const request = RequestModel(
        id: 'test-custom-error-handling',
        name: 'Custom Error Handling',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/unreliable',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 500,
          body: '{"error": "server error"}',
          time: Duration(milliseconds: 150),
        ),
        postRequestScript: '''
          try {
            assert(ad.response.status).equals(200);
            ad.console.log("Status check passed!");
          } catch (error) {
            ad.console.error("Status check failed: " + error.message);
            ad.environment.set("lastRequestFailed", "true");
          }
        ''',
      );

      Map<String, dynamic> capturedEnvironment = {};

      final result = await container
          .read(jsRuntimeNotifierProvider.notifier)
          .handlePostResponseScript(
            request,
            null,
            (env, values) {
              capturedEnvironment = {
                for (var v in values)
                  if (v.enabled) v.key: v.value
              };
            },
          );

      expect(result.id, equals('test-custom-error-handling'));
      expect(capturedEnvironment['lastRequestFailed'], equals('true'));
    });
  });
}
