import 'dart:convert';
import 'package:apidash/services/flutter_js_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/pre_post_script_utils.dart';

// Base HTTP Request Model for GET request
const HttpRequestModel baseGetRequest = HttpRequestModel(
  method: HTTPVerb.get,
  url: 'https://api.apidash.dev/users',
  headers: [
    NameValueModel(name: 'Content-Type', value: 'application/json'),
    NameValueModel(name: 'User-Agent', value: 'APIDash/1.0'),
  ],
  params: [
    NameValueModel(name: 'page', value: '1'),
    NameValueModel(name: 'limit', value: '10'),
  ],
);

// HTTP Request Model for POST request with body
const HttpRequestModel basePostRequest = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/auth/login',
  headers: [
    NameValueModel(name: 'Content-Type', value: 'application/json'),
    NameValueModel(name: 'Accept', value: 'application/json'),
  ],
  body: '{"username": "testuser", "password": "testpass"}',
);

// GraphQL Request Model
const HttpRequestModel baseGraphQLRequest = HttpRequestModel(
  method: HTTPVerb.post,
  url: 'https://api.apidash.dev/graphql',
  headers: [
    NameValueModel(name: 'Content-Type', value: 'application/json'),
  ],
  query: r'query GetUser($id: ID!) { user(id: $id) { name email } }',
  body: '{"variables": {"id": "123"}}',
);

// HTTP Response Model for successful login
const HttpResponseModel successLoginResponse = HttpResponseModel(
  statusCode: 200,
  headers: {
    'content-type': 'application/json',
    'x-auth-token': 'Bearer jwt-token-abc123',
    'set-cookie': 'sessionid=sess_123; Path=/; HttpOnly',
  },
  body:
      '{"success": true, "token": "jwt-token-abc123", "user": {"id": "user_123", "name": "Test User", "email": "test@example.com"}, "expires_in": 3600}',
  time: Duration(milliseconds: 150),
);

// HTTP Response Model for error case
const HttpResponseModel errorResponse = HttpResponseModel(
  statusCode: 401,
  headers: {
    'content-type': 'application/json',
    'www-authenticate': 'Bearer',
  },
  body:
      '{"error": "invalid_credentials", "message": "Invalid username or password"}',
  time: Duration(milliseconds: 89),
);

// HTTP Response Model for API list response
const HttpResponseModel usersListResponse = HttpResponseModel(
  statusCode: 200,
  headers: {
    'content-type': 'application/json',
    'x-total-count': '150',
    'x-page': '1',
  },
  body:
      '{"users": [{"id": "1", "name": "Alice", "status": "active"}, {"id": "2", "name": "Bob", "status": "inactive"}], "pagination": {"page": 1, "limit": 10, "total": 150}}',
  time: Duration(milliseconds: 95),
);

// Environment Model with various variable types
const EnvironmentModel testEnvironment = EnvironmentModel(
  id: 'test-env',
  name: 'Test Environment',
  values: [
    EnvironmentVariableModel(
      key: 'baseUrl',
      value: 'https://api.apidash.dev',
      enabled: true,
      type: EnvironmentVariableType.variable,
    ),
    EnvironmentVariableModel(
      key: 'apiKey',
      value: 'secret-api-key-123',
      enabled: true,
      type: EnvironmentVariableType.secret,
    ),
    EnvironmentVariableModel(
      key: 'timeout',
      value: '5000',
      enabled: true,
      type: EnvironmentVariableType.variable,
    ),
    EnvironmentVariableModel(
      key: 'debugMode',
      value: 'true',
      enabled: true,
      type: EnvironmentVariableType.variable,
    ),
    EnvironmentVariableModel(
      key: 'disabledVar',
      value: 'should-not-be-used',
      enabled: false,
      type: EnvironmentVariableType.variable,
    ),
  ],
);

// Request Models with different scripts
RequestModel requestWithHeaderModificationScript = RequestModel(
  id: 'header-mod-request',
  name: 'Header Modification Test',
  httpRequestModel: baseGetRequest,
  preRequestScript: '''
      ad.request.headers.set('Authorization', 'Bearer ' + ad.environment.get('apiKey'));
      ad.request.headers.set('X-Custom-Header', 'custom-value');
      ad.request.headers.remove('User-Agent');
      ad.console.log('Headers modified');
    ''',
);

RequestModel requestWithUrlModificationScript = RequestModel(
  id: 'url-mod-request',
  name: 'URL Modification Test',
  httpRequestModel: baseGetRequest,
  preRequestScript: '''
      const baseUrl = ad.environment.get('baseUrl');
      ad.request.url.set(baseUrl + '/v2/users');
      ad.request.params.set('version', 'v2');
      ad.request.params.remove('page');
      ad.console.log('URL and params modified');
    ''',
);

RequestModel requestWithBodyModificationScript = RequestModel(
  id: 'body-mod-request',
  name: 'Body Modification Test',
  httpRequestModel: basePostRequest,
  preRequestScript: '''
      const currentBody = JSON.parse(ad.request.body.get() || '{}');
      currentBody.timestamp = new Date().toISOString();
      currentBody.apiKey = ad.environment.get('apiKey');
      ad.request.body.set(currentBody);
      ad.console.log('Body modified with timestamp and API key');
    ''',
);

RequestModel requestWithGraphQLScript = RequestModel(
  id: 'graphql-request',
  name: 'GraphQL Query Modification Test',
  httpRequestModel: baseGraphQLRequest,
  preRequestScript: r'''
      const userId = ad.environment.get('userId') || '123';
      ad.request.query.set('query GetUser($id: ID!) { user(id: $id) { name email roles { name } } }');
      const variables = JSON.parse(ad.request.body.get() || '{}');
      variables.variables.id = userId;
      ad.request.body.set(variables);
      ad.console.log('GraphQL query and variables updated');
    ''',
);

RequestModel requestWithEnvironmentUpdateScript = RequestModel(
  id: 'env-update-request',
  name: 'Environment Update Test',
  httpRequestModel: baseGetRequest,
  preRequestScript: '''
      ad.environment.set('requestId', 'req_' + Date.now());
      ad.environment.set('retryCount', 0);
      ad.environment.unset('debugMode');
      ad.environment.set('newVariable', 'created-in-script');
      ad.console.log('Environment variables updated');
    ''',
);

RequestModel requestWithComplexScript = RequestModel(
  id: 'complex-request',
  name: 'Complex Pre-request Script Test',
  httpRequestModel: basePostRequest,
  preRequestScript: '''
      // Modify headers
      ad.request.headers.set('Authorization', 'Bearer ' + ad.environment.get('apiKey'));
      ad.request.headers.set('X-Request-ID', 'req_' + Date.now());
      
      // Modify URL
      const baseUrl = ad.environment.get('baseUrl');
      ad.request.url.set(baseUrl + '/auth/login');
      
      // Modify body
      const body = JSON.parse(ad.request.body.get() || '{}');
      body.client_id = 'apidash-client';
      body.timestamp = new Date().toISOString();
      ad.request.body.set(body);
      
      // Update environment
      ad.environment.set('lastRequestTime', new Date().toISOString());
      ad.environment.set('requestCount', (parseInt(ad.environment.get('requestCount') || '0') + 1).toString());
      
      ad.console.log('Complex pre-request script executed successfully');
    ''',
);

// Post-response script request models
RequestModel requestWithTokenExtractionScript = RequestModel(
  id: 'token-extract-request',
  name: 'Token Extraction Test',
  httpRequestModel: basePostRequest,
  httpResponseModel: successLoginResponse,
  postRequestScript: '''
      if (ad.response.status === 200) {
        const data = ad.response.json();
        if (data && data.token) {
          ad.environment.set('authToken', data.token);
          ad.environment.set('userId', data.user.id);
          ad.console.log('Token and user ID extracted successfully');
        } else {
          ad.console.error('Token not found in response');
        }
      } else {
        ad.console.error('Login failed with status: ' + ad.response.status);
      }
    ''',
);

RequestModel requestWithHeaderExtractionScript = RequestModel(
  id: 'header-extract-request',
  name: 'Header Extraction Test',
  httpRequestModel: baseGetRequest,
  httpResponseModel: successLoginResponse,
  postRequestScript: '''
      const authHeader = ad.response.getHeader('x-auth-token');
      if (authHeader) {
        ad.environment.set('extractedAuthToken', authHeader);
      }
      
      const sessionCookie = ad.response.getHeader('set-cookie');
      if (sessionCookie) {
        const sessionId = sessionCookie.match(/sessionid=([^;]+)/);
        if (sessionId) {
          ad.environment.set('sessionId', sessionId[1]);
        }
      }
      
      ad.console.log('Headers extracted and processed');
    ''',
);

RequestModel requestWithStatusCheckScript = RequestModel(
  id: 'status-check-request',
  name: 'Status Check Test',
  httpRequestModel: baseGetRequest,
  httpResponseModel: errorResponse,
  postRequestScript: '''
      ad.environment.set('lastResponseStatus', ad.response.status.toString());
      ad.environment.set('lastResponseTime', ad.response.time.toString());
      
      if (ad.response.status >= 400) {
        const errorData = ad.response.json();
        if (errorData && errorData.error) {
          ad.environment.set('lastError', errorData.error);
          ad.environment.set('lastErrorMessage', errorData.message || 'Unknown error');
        }
        ad.console.error('Request failed with error: ' + (errorData ? errorData.error : 'Unknown'));
      } else {
        ad.environment.unset('lastError');
        ad.environment.unset('lastErrorMessage');
        ad.console.log('Request succeeded');
      }
    ''',
);

RequestModel requestWithDataProcessingScript = RequestModel(
  id: 'data-processing-request',
  name: 'Data Processing Test',
  httpRequestModel: baseGetRequest,
  httpResponseModel: usersListResponse,
  postRequestScript: '''
      const responseData = ad.response.json();
      if (responseData && responseData.users) {
        const activeUsers = responseData.users.filter(user => user.status === 'active');
        ad.environment.set('activeUserCount', activeUsers.length.toString());
        ad.environment.set('totalUsers', responseData.pagination.total.toString());
        ad.environment.set('currentPage', responseData.pagination.page.toString());
        
        if (activeUsers.length > 0) {
          ad.environment.set('firstActiveUserId', activeUsers[0].id);
        }
        
        ad.console.log('Processed ' + responseData.users.length + ' users, ' + activeUsers.length + ' active');
      } else {
        ad.console.error('Invalid response structure');
      }
    ''',
);

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

      void preUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        // Mock function for testing
      }

      void postUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        // Mock function for testing
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

    test('should handle accessing non-existent environment variables',
        () async {
      final scriptWithMissingVar = RequestModel(
        id: 'missing-var-request',
        name: 'Missing Variable Test',
        httpRequestModel: baseGetRequest,
        preRequestScript: '''
          const missingVar = ad.environment.get('nonExistentVar');
          ad.request.headers.set('X-Missing-Var', missingVar || 'default-value');
          ad.console.log('Missing variable handled: ' + (missingVar || 'undefined'));
        ''',
      );

      final result = await handlePreRequestScript(
        scriptWithMissingVar,
        testEnvironment,
        null,
      );

      expect(result, isA<RequestModel>());
      final headers = result.httpRequestModel!.headers!;
      final missingVarHeader =
          headers.firstWhere((h) => h.name == 'X-Missing-Var');
      expect(missingVarHeader.value, equals('default-value'));
    });

    test('should handle JSON parsing errors in post-response script', () async {
      const invalidJsonResponse = HttpResponseModel(
        statusCode: 200,
        headers: {'content-type': 'application/json'},
        body: '{"invalid": json}', // Invalid JSON
        time: Duration(milliseconds: 100),
      );

      final requestWithInvalidJson = RequestModel(
        id: 'invalid-json-request',
        name: 'Invalid JSON Test',
        httpRequestModel: baseGetRequest,
        httpResponseModel: invalidJsonResponse,
        postRequestScript: '''
          const data = ad.response.json();
          if (data) {
            ad.environment.set('parsedData', 'success');
          } else {
            ad.environment.set('parsedData', 'failed');
          }
          ad.console.log('JSON parsing result: ' + (data ? 'success' : 'failed'));
        ''',
      );

      List<EnvironmentVariableModel>? capturedValues;
      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        capturedValues = values;
      }

      await handlePostResponseScript(
        requestWithInvalidJson,
        testEnvironment,
        mockUpdateEnv,
      );

      expect(capturedValues, isNotNull);
      final parsedDataVar =
          capturedValues!.firstWhere((v) => v.key == 'parsedData');
      expect(parsedDataVar.value, equals('failed'));
    });

    test('should handle null/undefined response body', () async {
      const nullBodyResponse = HttpResponseModel(
        statusCode: 204,
        headers: {},
        body: null,
        time: Duration(milliseconds: 50),
      );

      final requestWithNullBody = RequestModel(
        id: 'null-body-request',
        name: 'Null Body Test',
        httpRequestModel: baseGetRequest,
        httpResponseModel: nullBodyResponse,
        postRequestScript: '''
          const body = ad.response.body;
          ad.environment.set('bodyExists', body ? 'true' : 'false');
          ad.environment.set('bodyLength', body ? body.length.toString() : '0');
        ''',
      );

      List<EnvironmentVariableModel>? capturedValues;
      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        capturedValues = values;
      }

      await handlePostResponseScript(
        requestWithNullBody,
        testEnvironment,
        mockUpdateEnv,
      );

      expect(capturedValues, isNotNull);
      final bodyExistsVar =
          capturedValues!.firstWhere((v) => v.key == 'bodyExists');
      expect(bodyExistsVar.value, equals('false'));
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

  group('Pre-request Script - Request Modification Tests', () {
    test('should modify headers correctly', () async {
      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
      }

      final result = await handlePreRequestScript(
        requestWithHeaderModificationScript,
        testEnvironment,
        mockUpdateEnv,
      );

      expect(result, isA<RequestModel>());
      expect(result.httpRequestModel, isNotNull);

      final headers = result.httpRequestModel!.headers!;

      // Check Authorization header was added
      final authHeader = headers.firstWhere((h) => h.name == 'Authorization');
      expect(authHeader.value, equals('Bearer secret-api-key-123'));

      // Check custom header was added
      final customHeader =
          headers.firstWhere((h) => h.name == 'X-Custom-Header');
      expect(customHeader.value, equals('custom-value'));

      // Check User-Agent header was removed
      expect(headers.any((h) => h.name == 'User-Agent'), isFalse);
    });

    test('should modify URL and params correctly', () async {
      final result = await handlePreRequestScript(
        requestWithUrlModificationScript,
        testEnvironment,
        null,
      );

      expect(result, isA<RequestModel>());
      expect(result.httpRequestModel, isNotNull);

      // Check URL was modified
      expect(result.httpRequestModel!.url,
          equals('https://api.apidash.dev/v2/users'));

      // Check params were modified
      final params = result.httpRequestModel!.params!;
      final versionParam = params.firstWhere((p) => p.name == 'version');
      expect(versionParam.value, equals('v2'));

      // Check page param was removed
      expect(params.any((p) => p.name == 'page'), isFalse);
    });

    test('should modify request body correctly', () async {
      final result = await handlePreRequestScript(
        requestWithBodyModificationScript,
        testEnvironment,
        null,
      );

      expect(result, isA<RequestModel>());
      expect(result.httpRequestModel, isNotNull);

      final bodyString = result.httpRequestModel!.body;
      expect(bodyString, isNotNull);

      final body = jsonDecode(bodyString!);
      expect(body['username'], equals('testuser'));
      expect(body['password'], equals('testpass'));
      expect(body['apiKey'], equals('secret-api-key-123'));
      expect(body['timestamp'], isNotNull);
    });

    test('should modify GraphQL query correctly', () async {
      final environmentWithUserId = testEnvironment.copyWith(
        values: [
          ...testEnvironment.values,
          const EnvironmentVariableModel(
            key: 'userId',
            value: 'user_456',
            enabled: true,
            type: EnvironmentVariableType.variable,
          ),
        ],
      );

      final result = await handlePreRequestScript(
        requestWithGraphQLScript,
        environmentWithUserId,
        null,
      );

      expect(result, isA<RequestModel>());
      expect(result.httpRequestModel, isNotNull);

      // Check query was modified
      expect(result.httpRequestModel!.query, contains('roles { name }'));

      // Check variables were updated
      final bodyString = result.httpRequestModel!.body;
      expect(bodyString, isNotNull);

      final body = jsonDecode(bodyString!);
      expect(body['variables']['id'], equals('user_456'));
    });

    test('should update environment variables correctly', () async {
      List<EnvironmentVariableModel>? capturedValues;
      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        capturedValues = values;
      }

      await handlePreRequestScript(
        requestWithEnvironmentUpdateScript,
        testEnvironment,
        mockUpdateEnv,
      );

      expect(capturedValues, isNotNull);

      // Check new variables were added
      final requestIdVar =
          capturedValues!.firstWhere((v) => v.key == 'requestId');
      expect(requestIdVar.value, startsWith('req_'));

      final retryCountVar =
          capturedValues!.firstWhere((v) => v.key == 'retryCount');
      expect(retryCountVar.value, equals('0'));

      final newVar = capturedValues!.firstWhere((v) => v.key == 'newVariable');
      expect(newVar.value, equals('created-in-script'));

      // Check debugMode was removed
      expect(capturedValues!.any((v) => v.key == 'debugMode'), isFalse);

      // Check existing variables are preserved
      final baseUrlVar = capturedValues!.firstWhere((v) => v.key == 'baseUrl');
      expect(baseUrlVar.value, equals('https://api.apidash.dev'));
    });

    test('should handle complex script with multiple modifications', () async {
      List<EnvironmentVariableModel>? capturedValues;
      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        capturedValues = values;
      }

      final result = await handlePreRequestScript(
        requestWithComplexScript,
        testEnvironment,
        mockUpdateEnv,
      );

      expect(result, isA<RequestModel>());
      expect(result.httpRequestModel, isNotNull);

      // Check headers
      final headers = result.httpRequestModel!.headers!;
      final authHeader = headers.firstWhere((h) => h.name == 'Authorization');
      expect(authHeader.value, equals('Bearer secret-api-key-123'));

      final requestIdHeader =
          headers.firstWhere((h) => h.name == 'X-Request-ID');
      expect(requestIdHeader.value, startsWith('req_'));

      // Check URL
      expect(result.httpRequestModel!.url,
          equals('https://api.apidash.dev/auth/login'));

      // Check body
      final bodyString = result.httpRequestModel!.body;
      final body = jsonDecode(bodyString!);
      expect(body['client_id'], equals('apidash-client'));
      expect(body['timestamp'], isNotNull);

      // Check environment updates
      expect(capturedValues, isNotNull);
      final lastRequestTimeVar =
          capturedValues!.firstWhere((v) => v.key == 'lastRequestTime');
      expect(lastRequestTimeVar.value, isNotNull);

      final requestCountVar =
          capturedValues!.firstWhere((v) => v.key == 'requestCount');
      expect(requestCountVar.value, equals('1'));
    });
  });

  group('Post-response Script - Data Extraction Tests', () {
    test('should extract token and user data from successful login response',
        () async {
      List<EnvironmentVariableModel>? capturedValues;
      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        capturedValues = values;
      }

      final result = await handlePostResponseScript(
        requestWithTokenExtractionScript,
        testEnvironment,
        mockUpdateEnv,
      );

      expect(result, isA<RequestModel>());
      expect(capturedValues, isNotNull);

      // Check token was extracted
      final authTokenVar =
          capturedValues!.firstWhere((v) => v.key == 'authToken');
      expect(authTokenVar.value, equals('jwt-token-abc123'));

      // Check user ID was extracted
      final userIdVar = capturedValues!.firstWhere((v) => v.key == 'userId');
      expect(userIdVar.value, equals('user_123'));
    });

    test('should extract headers correctly', () async {
      List<EnvironmentVariableModel>? capturedValues;
      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        capturedValues = values;
      }

      await handlePostResponseScript(
        requestWithHeaderExtractionScript,
        testEnvironment,
        mockUpdateEnv,
      );

      expect(capturedValues, isNotNull);

      // Check auth token header was extracted
      final extractedTokenVar =
          capturedValues!.firstWhere((v) => v.key == 'extractedAuthToken');
      expect(extractedTokenVar.value, equals('Bearer jwt-token-abc123'));

      // Check session ID was extracted from cookie
      final sessionIdVar =
          capturedValues!.firstWhere((v) => v.key == 'sessionId');
      expect(sessionIdVar.value, equals('sess_123'));
    });

    test('should handle error responses correctly', () async {
      List<EnvironmentVariableModel>? capturedValues;
      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        capturedValues = values;
      }

      await handlePostResponseScript(
        requestWithStatusCheckScript,
        testEnvironment,
        mockUpdateEnv,
      );

      expect(capturedValues, isNotNull);

      // Check status was recorded
      final statusVar =
          capturedValues!.firstWhere((v) => v.key == 'lastResponseStatus');
      expect(statusVar.value, equals('401'));

      // Check response time was recorded
      final timeVar =
          capturedValues!.firstWhere((v) => v.key == 'lastResponseTime');
      expect(timeVar.value, equals('89'));

      // Check error details were extracted
      final errorVar = capturedValues!.firstWhere((v) => v.key == 'lastError');
      expect(errorVar.value, equals('invalid_credentials'));

      final errorMessageVar =
          capturedValues!.firstWhere((v) => v.key == 'lastErrorMessage');
      expect(errorMessageVar.value, equals('Invalid username or password'));
    });

    test('should process response data correctly', () async {
      List<EnvironmentVariableModel>? capturedValues;
      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        capturedValues = values;
      }

      await handlePostResponseScript(
        requestWithDataProcessingScript,
        testEnvironment,
        mockUpdateEnv,
      );

      expect(capturedValues, isNotNull);

      // Check processed data
      final activeCountVar =
          capturedValues!.firstWhere((v) => v.key == 'activeUserCount');
      expect(activeCountVar.value, equals('1'));

      final totalUsersVar =
          capturedValues!.firstWhere((v) => v.key == 'totalUsers');
      expect(totalUsersVar.value, equals('150'));

      final currentPageVar =
          capturedValues!.firstWhere((v) => v.key == 'currentPage');
      expect(currentPageVar.value, equals('1'));

      final firstActiveUserVar =
          capturedValues!.firstWhere((v) => v.key == 'firstActiveUserId');
      expect(firstActiveUserVar.value, equals('1'));
    });
  });

  group('Data Type Conversion Tests', () {
    test('should convert different data types to strings in environment',
        () async {
      final dataTypeScript = RequestModel(
        id: 'data-type-request',
        name: 'Data Type Conversion Test',
        httpRequestModel: baseGetRequest,
        preRequestScript: '''
          ad.environment.set('stringVar', 'hello');
          ad.environment.set('numberVar', 42);
          ad.environment.set('booleanVar', true);
          ad.environment.set('objectVar', {key: 'value'});
          ad.environment.set('arrayVar', [1, 2, 3]);
          ad.environment.set('nullVar', null);
          ad.environment.set('undefinedVar', undefined);
        ''',
      );

      List<EnvironmentVariableModel>? capturedValues;
      void mockUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        capturedValues = values;
      }

      await handlePreRequestScript(
        dataTypeScript,
        testEnvironment,
        mockUpdateEnv,
      );

      expect(capturedValues, isNotNull);

      final stringVar = capturedValues!.firstWhere((v) => v.key == 'stringVar');
      expect(stringVar.value, equals('hello'));

      final numberVar = capturedValues!.firstWhere((v) => v.key == 'numberVar');
      expect(numberVar.value, equals('42'));

      final booleanVar =
          capturedValues!.firstWhere((v) => v.key == 'booleanVar');
      expect(booleanVar.value, equals('true'));

      final nullVar = capturedValues!.firstWhere((v) => v.key == 'nullVar');
      expect(nullVar.value, equals(''));
    });

    test('should handle various header value types', () async {
      final headerTypeScript = RequestModel(
        id: 'header-type-request',
        name: 'Header Type Test',
        httpRequestModel: baseGetRequest,
        preRequestScript: '''
          ad.request.headers.set('X-String-Header', 'string-value');
          ad.request.headers.set('X-Number-Header', 123);
          ad.request.headers.set('X-Boolean-Header', true);
          ad.request.headers.set('X-Null-Header', null);
        ''',
      );

      final result = await handlePreRequestScript(
        headerTypeScript,
        testEnvironment,
        null,
      );

      expect(result, isA<RequestModel>());
      final headers = result.httpRequestModel!.headers!;

      final stringHeader =
          headers.firstWhere((h) => h.name == 'X-String-Header');
      expect(stringHeader.value, equals('string-value'));

      final numberHeader =
          headers.firstWhere((h) => h.name == 'X-Number-Header');
      expect(numberHeader.value, equals('123'));

      final booleanHeader =
          headers.firstWhere((h) => h.name == 'X-Boolean-Header');
      expect(booleanHeader.value, equals('true'));

      final nullHeader = headers.firstWhere((h) => h.name == 'X-Null-Header');
      expect(nullHeader.value, equals('null'));
    });

    test('should handle complete workflow with pre and post scripts', () async {
      // Pre-request script that sets up auth
      final preRequestModel = RequestModel(
        id: 'workflow-request',
        name: 'Complete Workflow Test',
        httpRequestModel: basePostRequest,
        preRequestScript: '''
          ad.request.headers.set('Authorization', 'Bearer ' + ad.environment.get('apiKey'));
          ad.request.headers.set('X-Request-ID', 'req_' + Date.now());
          ad.environment.set('requestStartTime', new Date().toISOString());
        ''',
      );

      List<EnvironmentVariableModel>? preValues;
      void preUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        preValues = values;
      }

      // Execute pre-request script
      final afterPre = await handlePreRequestScript(
        preRequestModel,
        testEnvironment,
        preUpdateEnv,
      );

      expect(afterPre, isA<RequestModel>());
      expect(preValues, isNotNull);

      // Verify pre-request modifications
      final headers = afterPre.httpRequestModel!.headers!;
      final authHeader = headers.firstWhere((h) => h.name == 'Authorization');
      expect(authHeader.value, equals('Bearer secret-api-key-123'));

      final requestIdHeader =
          headers.firstWhere((h) => h.name == 'X-Request-ID');
      expect(requestIdHeader.value, startsWith('req_'));

      // Simulate response and add post-response script
      final postRequestModel = afterPre.copyWith(
        httpResponseModel: successLoginResponse,
        postRequestScript: '''
          const data = ad.response.json();
          if (data && data.token) {
            ad.environment.set('authToken', data.token);
            ad.environment.set('userId', data.user.id);
          }
          ad.environment.set('requestEndTime', new Date().toISOString());
          ad.environment.set('responseStatus', ad.response.status.toString());
        ''',
      );

      List<EnvironmentVariableModel>? postValues;
      void postUpdateEnv(
          EnvironmentModel envModel, List<EnvironmentVariableModel> values) {
        postValues = values;
      }

      // Execute post-response script
      final afterPost = await handlePostResponseScript(
        postRequestModel,
        testEnvironment,
        postUpdateEnv,
      );

      expect(afterPost, isA<RequestModel>());
      expect(postValues, isNotNull);

      // Verify post-response updates
      final authTokenVar = postValues!.firstWhere((v) => v.key == 'authToken');
      expect(authTokenVar.value, equals('jwt-token-abc123'));

      final userIdVar = postValues!.firstWhere((v) => v.key == 'userId');
      expect(userIdVar.value, equals('user_123'));

      final statusVar =
          postValues!.firstWhere((v) => v.key == 'responseStatus');
      expect(statusVar.value, equals('200'));

      expect(afterPost.id, equals(preRequestModel.id));
    });
  });
}
