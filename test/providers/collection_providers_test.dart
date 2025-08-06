import 'dart:io';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_body.dart';
import 'package:apidash/widgets/editor.dart';
import 'package:apidash/widgets/response_body.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'helpers.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    await testSetUpTempDirForHive();
  });

  testWidgets(
      'Request method changes from GET to POST when body is added and Snackbar is shown',
      (WidgetTester tester) async {
    // Set up the test environment
    final container = createContainer();
    final notifier = container.read(collectionStateNotifierProvider.notifier);

    // Ensure the initial request is a GET request with no body
    final id = notifier.state!.entries.first.key;
    expect(
        notifier.getRequestModel(id)!.httpRequestModel!.method, HTTPVerb.get);
    expect(notifier.getRequestModel(id)!.httpRequestModel!.body, isNull);

    // Build the EditRequestBody widget
    await tester.pumpWidget(
      ProviderScope(
        // ignore: deprecated_member_use
        parent: container,
        child: const MaterialApp(
          home: Scaffold(
            body: EditRequestBody(),
          ),
        ),
      ),
    );

    // Add a body to the request, which should trigger the method change
    await tester.enterText(find.byType(TextFieldEditor), 'new body added');
    await tester.pump(); // Process the state change

    // Verify that the request method changed to POST
    expect(
        notifier.getRequestModel(id)!.httpRequestModel!.method, HTTPVerb.post);

    // Verify that the Snackbar is shown
    expect(find.text('Switched to POST method'), findsOneWidget);
  }, skip: true);

  testWidgets('SSE Output is rendered correctly in UI',
      (WidgetTester tester) async {
    HttpOverrides.global = null; //enable networking in flutter_test

    final container = createContainer();
    final notifier = container.read(collectionStateNotifierProvider.notifier);

    const model = HttpRequestModel(
      url: 'https://sse-demo.netlify.app/sse',
      method: HTTPVerb.get,
    );

    notifier.addRequestModel(model, name: 'sseM');
    final id = notifier.state!.entries.last.key;

    //runAsync to enable user-code awaiting
    await tester.runAsync(() async {
      await notifier.sendRequest();
      await Future.delayed(const Duration(seconds: 3));
    });

    final rm = notifier.getRequestModel(id)!;
    cancelHttpRequest(rm.id);

    final sseOutput = (rm.httpResponseModel?.sseOutput ?? [])
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    expect(sseOutput, isNotEmpty, reason: 'No SSE Output found');

    // Render the widget
    await tester.pumpWidget(
      ProviderScope(
        // ignore: deprecated_member_use
        parent: container,
        child: MaterialApp(
          home: Scaffold(
            body: ResponseBody(selectedRequestModel: rm),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final textWidgets = tester.widgetList<Text>(find.byType(Text));
    final matchingTextCount = textWidgets
        .where((text) =>
            text.data != null &&
            text.data!.startsWith('data') &&
            sseOutput.contains(text.data!.trim()))
        .length;

    expect(
      matchingTextCount,
      sseOutput.length,
      reason: 'UI does not match all SSE output lines',
    );

    // Waits for all provider actions to complete before exit
    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 2));
    });
  });
  
  group('CollectionStateNotifier Auth Tests', () {
    late ProviderContainer container;
    late CollectionStateNotifier notifier;

    setUp(() {
      container = createContainer();
      notifier = container.read(collectionStateNotifierProvider.notifier);
    });

    test('should update request with basic authentication', () {
      final id = notifier.state!.entries.first.key;
      const basicAuth = AuthBasicAuthModel(
        username: 'testuser',
        password: 'testpass',
      );
      const authModel = AuthModel(
        type: APIAuthType.basic,
        basic: basicAuth,
      );

      notifier.update(id: id, authModel: authModel);

      final updatedRequest = notifier.getRequestModel(id);
      expect(
          updatedRequest?.httpRequestModel?.authModel?.type, APIAuthType.basic);
      expect(updatedRequest?.httpRequestModel?.authModel?.basic?.username,
          'testuser');
      expect(updatedRequest?.httpRequestModel?.authModel?.basic?.password,
          'testpass');
    });

    test('should update request with bearer authentication', () {
      final id = notifier.state!.entries.first.key;
      const bearerAuth = AuthBearerModel(token: 'bearer-token-123');
      const authModel = AuthModel(
        type: APIAuthType.bearer,
        bearer: bearerAuth,
      );

      notifier.update(id: id, authModel: authModel);

      final updatedRequest = notifier.getRequestModel(id);
      expect(updatedRequest?.httpRequestModel?.authModel?.type,
          APIAuthType.bearer);
      expect(updatedRequest?.httpRequestModel?.authModel?.bearer?.token,
          'bearer-token-123');
    });

    test('should update request with API key authentication', () {
      final id = notifier.state!.entries.first.key;
      const apiKeyAuth = AuthApiKeyModel(
        key: 'api-key-123',
        location: 'header',
        name: 'X-API-Key',
      );
      const authModel = AuthModel(
        type: APIAuthType.apiKey,
        apikey: apiKeyAuth,
      );

      notifier.update(id: id, authModel: authModel);

      final updatedRequest = notifier.getRequestModel(id);
      expect(updatedRequest?.httpRequestModel?.authModel?.type,
          APIAuthType.apiKey);
      expect(updatedRequest?.httpRequestModel?.authModel?.apikey?.key,
          'api-key-123');
      expect(updatedRequest?.httpRequestModel?.authModel?.apikey?.location,
          'header');
      expect(updatedRequest?.httpRequestModel?.authModel?.apikey?.name,
          'X-API-Key');
    });

    test('should update request with JWT authentication', () {
      final id = notifier.state!.entries.first.key;
      const jwtAuth = AuthJwtModel(
        secret: 'jwt-secret',
        payload: '{"sub": "1234567890"}',
        addTokenTo: 'header',
        algorithm: 'HS256',
        isSecretBase64Encoded: false,
        headerPrefix: 'Bearer',
        queryParamKey: 'token',
        header: 'Authorization',
      );
      const authModel = AuthModel(
        type: APIAuthType.jwt,
        jwt: jwtAuth,
      );

      notifier.update(id: id, authModel: authModel);

      final updatedRequest = notifier.getRequestModel(id);
      expect(
          updatedRequest?.httpRequestModel?.authModel?.type, APIAuthType.jwt);
      expect(updatedRequest?.httpRequestModel?.authModel?.jwt?.secret,
          'jwt-secret');
      expect(
          updatedRequest?.httpRequestModel?.authModel?.jwt?.algorithm, 'HS256');
      expect(
          updatedRequest
              ?.httpRequestModel?.authModel?.jwt?.isSecretBase64Encoded,
          false);
    });

    test('should update request with digest authentication', () {
      final id = notifier.state!.entries.first.key;
      const digestAuth = AuthDigestModel(
        username: 'digestuser',
        password: 'digestpass',
        realm: 'test-realm',
        nonce: 'test-nonce',
        algorithm: 'MD5',
        qop: 'auth',
        opaque: 'test-opaque',
      );
      const authModel = AuthModel(
        type: APIAuthType.digest,
        digest: digestAuth,
      );

      notifier.update(id: id, authModel: authModel);

      final updatedRequest = notifier.getRequestModel(id);
      expect(updatedRequest?.httpRequestModel?.authModel?.type,
          APIAuthType.digest);
      expect(updatedRequest?.httpRequestModel?.authModel?.digest?.username,
          'digestuser');
      expect(updatedRequest?.httpRequestModel?.authModel?.digest?.realm,
          'test-realm');
      expect(updatedRequest?.httpRequestModel?.authModel?.digest?.algorithm,
          'MD5');
    });

    test('should remove authentication when set to none', () {
      final id = notifier.state!.entries.first.key;

      // First add auth
      const basicAuth = AuthBasicAuthModel(
        username: 'testuser',
        password: 'testpass',
      );
      const authModel = AuthModel(
        type: APIAuthType.basic,
        basic: basicAuth,
      );
      notifier.update(id: id, authModel: authModel);

      // Then remove auth
      const noAuthModel = AuthModel(type: APIAuthType.none);
      notifier.update(id: id, authModel: noAuthModel);

      final updatedRequest = notifier.getRequestModel(id);
      expect(
          updatedRequest?.httpRequestModel?.authModel?.type, APIAuthType.none);
      expect(updatedRequest?.httpRequestModel?.authModel?.basic, isNull);
    });

    test('should preserve auth when duplicating request', () {
      final id = notifier.state!.entries.first.key;
      const basicAuth = AuthBasicAuthModel(
        username: 'testuser',
        password: 'testpass',
      );
      const authModel = AuthModel(
        type: APIAuthType.basic,
        basic: basicAuth,
      );

      notifier.update(id: id, authModel: authModel);
      notifier.duplicate(id: id);

      final sequence = container.read(requestSequenceProvider);
      final duplicatedId = sequence.firstWhere((element) => element != id);
      final duplicatedRequest = notifier.getRequestModel(duplicatedId);

      expect(duplicatedRequest?.httpRequestModel?.authModel?.type,
          APIAuthType.basic);
      expect(duplicatedRequest?.httpRequestModel?.authModel?.basic?.username,
          'testuser');
      expect(duplicatedRequest?.httpRequestModel?.authModel?.basic?.password,
          'testpass');
    });

    test('should not clear auth when clearing response', () {
      final id = notifier.state!.entries.first.key;
      const bearerAuth = AuthBearerModel(token: 'bearer-token-123');
      const authModel = AuthModel(
        type: APIAuthType.bearer,
        bearer: bearerAuth,
      );

      notifier.update(id: id, authModel: authModel);
      notifier.clearResponse(id: id);

      final updatedRequest = notifier.getRequestModel(id);
      // Auth should be preserved when clearing response
      expect(updatedRequest?.httpRequestModel?.authModel?.type,
          APIAuthType.bearer);
      expect(updatedRequest?.httpRequestModel?.authModel?.bearer?.token,
          'bearer-token-123');
    });

    test('should handle auth with special characters', () {
      final id = notifier.state!.entries.first.key;
      const basicAuth = AuthBasicAuthModel(
        username: 'user@domain.com',
        password: r'P@ssw0rd!@#$%^&*()',
      );
      const authModel = AuthModel(
        type: APIAuthType.basic,
        basic: basicAuth,
      );

      notifier.update(id: id, authModel: authModel);

      final updatedRequest = notifier.getRequestModel(id);
      expect(updatedRequest?.httpRequestModel?.authModel?.basic?.username,
          'user@domain.com');
      expect(updatedRequest?.httpRequestModel?.authModel?.basic?.password,
          r'P@ssw0rd!@#$%^&*()');
    });

    test('should handle multiple auth type changes', () {
      final id = notifier.state!.entries.first.key;

      // Start with basic auth
      const basicAuth = AuthBasicAuthModel(
        username: 'testuser',
        password: 'testpass',
      );
      const basicAuthModel = AuthModel(
        type: APIAuthType.basic,
        basic: basicAuth,
      );
      notifier.update(id: id, authModel: basicAuthModel);

      // Switch to bearer
      const bearerAuth = AuthBearerModel(token: 'bearer-token-123');
      const bearerAuthModel = AuthModel(
        type: APIAuthType.bearer,
        bearer: bearerAuth,
      );
      notifier.update(id: id, authModel: bearerAuthModel);

      // Switch to API key
      const apiKeyAuth = AuthApiKeyModel(
        key: 'api-key-123',
        location: 'query',
        name: 'apikey',
      );
      const apiKeyAuthModel = AuthModel(
        type: APIAuthType.apiKey,
        apikey: apiKeyAuth,
      );
      notifier.update(id: id, authModel: apiKeyAuthModel);

      final updatedRequest = notifier.getRequestModel(id);
      expect(updatedRequest?.httpRequestModel?.authModel?.type,
          APIAuthType.apiKey);
      expect(updatedRequest?.httpRequestModel?.authModel?.apikey?.key,
          'api-key-123');
      expect(updatedRequest?.httpRequestModel?.authModel?.apikey?.location,
          'query');
      expect(
          updatedRequest?.httpRequestModel?.authModel?.apikey?.name, 'apikey');
    });

    test('should handle empty auth values', () {
      final id = notifier.state!.entries.first.key;
      const basicAuth = AuthBasicAuthModel(
        username: '',
        password: '',
      );
      const authModel = AuthModel(
        type: APIAuthType.basic,
        basic: basicAuth,
      );

      notifier.update(id: id, authModel: authModel);

      final updatedRequest = notifier.getRequestModel(id);
      expect(
          updatedRequest?.httpRequestModel?.authModel?.type, APIAuthType.basic);
      expect(updatedRequest?.httpRequestModel?.authModel?.basic?.username, '');
      expect(updatedRequest?.httpRequestModel?.authModel?.basic?.password, '');
    });

    test('should save and load auth data correctly', () async {
      final notifier = container.read(collectionStateNotifierProvider.notifier);

      final id = notifier.state!.entries.first.key;
      const jwtAuth = AuthJwtModel(
        secret: 'jwt-secret',
        payload: '{"sub": "1234567890"}',
        addTokenTo: 'header',
        algorithm: 'HS256',
        isSecretBase64Encoded: false,
        headerPrefix: 'Bearer',
        queryParamKey: 'token',
        header: 'Authorization',
      );
      const authModel = AuthModel(
        type: APIAuthType.jwt,
        jwt: jwtAuth,
      );

      notifier.update(id: id, authModel: authModel);
      await notifier.saveData();

      // Create new container and load data
      late ProviderContainer newContainer;
      try {
        newContainer = ProviderContainer();

        // Wait for the container to initialize by accessing the provider
        final newNotifier =
            newContainer.read(collectionStateNotifierProvider.notifier);

        // Give some time for the microtask in the constructor to complete
        await Future.delayed(const Duration(milliseconds: 10));

        final loadedRequest = newNotifier.getRequestModel(id);

        expect(
            loadedRequest?.httpRequestModel?.authModel?.type, APIAuthType.jwt);
        expect(loadedRequest?.httpRequestModel?.authModel?.jwt?.secret,
            'jwt-secret');
        expect(loadedRequest?.httpRequestModel?.authModel?.jwt?.algorithm,
            'HS256');
      } finally {
        newContainer.dispose();
      }
    });

    test('should handle auth in addRequestModel', () {
      const basicAuth = AuthBasicAuthModel(
        username: 'testuser',
        password: 'testpass',
      );
      const authModel = AuthModel(
        type: APIAuthType.basic,
        basic: basicAuth,
      );

      final httpRequestModel = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.example.com/users',
        authModel: authModel,
      );

      notifier.addRequestModel(httpRequestModel, name: 'Test Request');

      final sequence = container.read(requestSequenceProvider);
      final addedRequest = notifier.getRequestModel(sequence.first);

      expect(
          addedRequest?.httpRequestModel?.authModel?.type, APIAuthType.basic);
      expect(addedRequest?.httpRequestModel?.authModel?.basic?.username,
          'testuser');
      expect(addedRequest?.httpRequestModel?.authModel?.basic?.password,
          'testpass');
    });

    test('should handle complex JWT configuration', () {
      final id = notifier.state!.entries.first.key;
      const complexPayload = '''
      {
        "sub": "1234567890",
        "name": "John Doe",
        "iat": 1516239022,
        "exp": 1516242622,
        "roles": ["admin", "user"],
        "permissions": {
          "read": true,
          "write": false
        }
      }
      ''';

      const jwtAuth = AuthJwtModel(
        secret: 'complex-secret',
        privateKey: 'private-key-content',
        payload: complexPayload,
        addTokenTo: 'query',
        algorithm: 'RS256',
        isSecretBase64Encoded: true,
        headerPrefix: 'JWT',
        queryParamKey: 'jwt_token',
        header: 'X-JWT-Token',
      );
      const authModel = AuthModel(
        type: APIAuthType.jwt,
        jwt: jwtAuth,
      );

      notifier.update(id: id, authModel: authModel);

      final updatedRequest = notifier.getRequestModel(id);
      expect(
          updatedRequest?.httpRequestModel?.authModel?.type, APIAuthType.jwt);
      expect(updatedRequest?.httpRequestModel?.authModel?.jwt?.payload,
          complexPayload);
      expect(updatedRequest?.httpRequestModel?.authModel?.jwt?.privateKey,
          'private-key-content');
      expect(
          updatedRequest?.httpRequestModel?.authModel?.jwt?.algorithm, 'RS256');
      expect(
          updatedRequest
              ?.httpRequestModel?.authModel?.jwt?.isSecretBase64Encoded,
          true);
      expect(updatedRequest?.httpRequestModel?.authModel?.jwt?.addTokenTo,
          'query');
    });

    test('should handle API key in different locations', () {
      final id = notifier.state!.entries.first.key;

      // Test header location
      const headerApiKey = AuthApiKeyModel(
        key: 'header-key',
        location: 'header',
        name: 'X-API-Key',
      );
      const headerAuthModel = AuthModel(
        type: APIAuthType.apiKey,
        apikey: headerApiKey,
      );
      notifier.update(id: id, authModel: headerAuthModel);

      var updatedRequest = notifier.getRequestModel(id);
      expect(updatedRequest?.httpRequestModel?.authModel?.apikey?.location,
          'header');
      expect(updatedRequest?.httpRequestModel?.authModel?.apikey?.name,
          'X-API-Key');

      // Test query location
      const queryApiKey = AuthApiKeyModel(
        key: 'query-key',
        location: 'query',
        name: 'apikey',
      );
      const queryAuthModel = AuthModel(
        type: APIAuthType.apiKey,
        apikey: queryApiKey,
      );
      notifier.update(id: id, authModel: queryAuthModel);

      updatedRequest = notifier.getRequestModel(id);
      expect(updatedRequest?.httpRequestModel?.authModel?.apikey?.location,
          'query');
      expect(
          updatedRequest?.httpRequestModel?.authModel?.apikey?.name, 'apikey');
    });

    test('should handle digest auth with different algorithms', () {
      final id = notifier.state!.entries.first.key;

      // Test MD5 algorithm
      const md5DigestAuth = AuthDigestModel(
        username: 'digestuser',
        password: 'digestpass',
        realm: 'test-realm',
        nonce: 'test-nonce',
        algorithm: 'MD5',
        qop: 'auth',
        opaque: 'test-opaque',
      );
      const md5AuthModel = AuthModel(
        type: APIAuthType.digest,
        digest: md5DigestAuth,
      );
      notifier.update(id: id, authModel: md5AuthModel);

      var updatedRequest = notifier.getRequestModel(id);
      expect(updatedRequest?.httpRequestModel?.authModel?.digest?.algorithm,
          'MD5');

      // Test SHA-256 algorithm
      const sha256DigestAuth = AuthDigestModel(
        username: 'digestuser',
        password: 'digestpass',
        realm: 'test-realm',
        nonce: 'test-nonce',
        algorithm: 'SHA-256',
        qop: 'auth-int',
        opaque: 'test-opaque',
      );
      const sha256AuthModel = AuthModel(
        type: APIAuthType.digest,
        digest: sha256DigestAuth,
      );
      notifier.update(id: id, authModel: sha256AuthModel);

      updatedRequest = notifier.getRequestModel(id);
      expect(updatedRequest?.httpRequestModel?.authModel?.digest?.algorithm,
          'SHA-256');
      expect(
          updatedRequest?.httpRequestModel?.authModel?.digest?.qop, 'auth-int');
    });

    test('should handle auth model copyWith functionality', () {
      final id = notifier.state!.entries.first.key;
      const originalAuth = AuthBasicAuthModel(
        username: 'original',
        password: 'original',
      );
      const originalAuthModel = AuthModel(
        type: APIAuthType.basic,
        basic: originalAuth,
      );

      notifier.update(id: id, authModel: originalAuthModel);

      // Update with copyWith
      const updatedAuth = AuthBasicAuthModel(
        username: 'updated',
        password: 'updated',
      );
      final updatedAuthModel = originalAuthModel.copyWith(
        basic: updatedAuth,
      );

      notifier.update(id: id, authModel: updatedAuthModel);

      final updatedRequest = notifier.getRequestModel(id);
      expect(updatedRequest?.httpRequestModel?.authModel?.basic?.username,
          'updated');
      expect(updatedRequest?.httpRequestModel?.authModel?.basic?.password,
          'updated');
    });

    test('should handle auth with very long tokens', () {
      final id = notifier.state!.entries.first.key;
      final longToken = 'a' * 5000; // Very long token

      final bearerAuth = AuthBearerModel(token: longToken);
      final authModel = AuthModel(
        type: APIAuthType.bearer,
        bearer: bearerAuth,
      );

      notifier.update(id: id, authModel: authModel);

      final updatedRequest = notifier.getRequestModel(id);
      expect(updatedRequest?.httpRequestModel?.authModel?.bearer?.token,
          longToken);
      expect(updatedRequest?.httpRequestModel?.authModel?.bearer?.token.length,
          5000);
    });

    test('should handle auth with Unicode characters', () {
      final id = notifier.state!.entries.first.key;
      const basicAuth = AuthBasicAuthModel(
        username: 'user_测试_тест_テスト',
        password: 'password_🔑_🚀_💻',
      );
      const authModel = AuthModel(
        type: APIAuthType.basic,
        basic: basicAuth,
      );

      notifier.update(id: id, authModel: authModel);

      final updatedRequest = notifier.getRequestModel(id);
      expect(updatedRequest?.httpRequestModel?.authModel?.basic?.username,
          'user_测试_тест_テスト');
      expect(updatedRequest?.httpRequestModel?.authModel?.basic?.password,
          'password_🔑_🚀_💻');
    });

    tearDown(() {
      container.dispose();
    });
  });

  group('CollectionStateNotifier Scripting Tests', () {
    late ProviderContainer container;
    late CollectionStateNotifier notifier;

    setUp(() {
      container = createContainer();
      notifier = container.read(collectionStateNotifierProvider.notifier);
    });

    test('should update request with pre-request script', () {
      final id = notifier.state!.entries.first.key;
      const preRequestScript = '''
        ad.request.headers.set('Authorization', 'Bearer ' + ad.environment.get('token'));
        ad.request.headers.set('X-Request-ID', 'req-' + Date.now());
        ad.console.log('Pre-request script executed');
      ''';

      notifier.update(id: id, preRequestScript: preRequestScript);

      final updatedRequest = notifier.getRequestModel(id);
      expect(updatedRequest?.preRequestScript, equals(preRequestScript));
    });

    test('should update request with post-response script', () {
      final id = notifier.state!.entries.first.key;
      const postResponseScript = '''
        if (ad.response.status === 200) {
          const data = ad.response.json();
          if (data && data.token) {
            ad.environment.set('authToken', data.token);
          }
        }
        ad.console.log('Post-response script executed');
      ''';

      notifier.update(id: id, postRequestScript: postResponseScript);

      final updatedRequest = notifier.getRequestModel(id);
      expect(updatedRequest?.postRequestScript, equals(postResponseScript));
    });

    test('should preserve scripts when duplicating request', () {
      final id = notifier.state!.entries.first.key;
      const preRequestScript = 'ad.console.log("Pre-request");';
      const postResponseScript = 'ad.console.log("Post-response");';

      notifier.update(
        id: id,
        preRequestScript: preRequestScript,
        postRequestScript: postResponseScript,
      );
      notifier.duplicate(id: id);

      final sequence = container.read(requestSequenceProvider);
      final duplicatedId = sequence.firstWhere((element) => element != id);
      final duplicatedRequest = notifier.getRequestModel(duplicatedId);

      expect(duplicatedRequest?.preRequestScript, equals(preRequestScript));
      expect(duplicatedRequest?.postRequestScript, equals(postResponseScript));
    });

    test('should clear scripts when set to empty strings', () {
      final id = notifier.state!.entries.first.key;

      // First add scripts
      notifier.update(
        id: id,
        preRequestScript: 'ad.console.log("test");',
        postRequestScript: 'ad.console.log("test");',
      );

      // Then clear scripts
      notifier.update(
        id: id,
        preRequestScript: '',
        postRequestScript: '',
      );

      final updatedRequest = notifier.getRequestModel(id);
      expect(updatedRequest?.preRequestScript, equals(''));
      expect(updatedRequest?.postRequestScript, equals(''));
    });

    test('should preserve scripts when clearing response', () {
      final id = notifier.state!.entries.first.key;
      const preRequestScript = 'ad.console.log("Pre-request");';
      const postResponseScript = 'ad.console.log("Post-response");';

      notifier.update(
        id: id,
        preRequestScript: preRequestScript,
        postRequestScript: postResponseScript,
      );
      notifier.clearResponse(id: id);

      final updatedRequest = notifier.getRequestModel(id);
      // Scripts should be preserved when clearing response
      expect(updatedRequest?.preRequestScript, equals(preRequestScript));
      expect(updatedRequest?.postRequestScript, equals(postResponseScript));
    });

    test('should handle scripts with special characters and multi-line', () {
      final id = notifier.state!.entries.first.key;
      const complexPreScript = '''
        // Pre-request script with special characters
        const apiKey = ad.environment.get('api-key');
        if (apiKey) {
          ad.request.headers.set('X-API-Key', apiKey);
        }
        
        const timestamp = new Date().toISOString();
        ad.request.headers.set('X-Timestamp', timestamp);
        
        // Handle Unicode and special characters
        ad.request.headers.set('X-Test-Header', '测试_тест_テスト_🚀');
        ad.console.log('Complex pre-request script executed ✅');
      ''';

      const complexPostScript = '''
        // Post-response script with JSON parsing
        try {
          const data = ad.response.json();
          if (data && data.access_token) {
            ad.environment.set('token', data.access_token);
            ad.console.log('Token extracted: ' + data.access_token.substring(0, 10) + '...');
          }
          
          // Handle different response codes
          if (ad.response.status >= 400) {
            ad.console.error('Request failed with status: ' + ad.response.status);
            ad.environment.set('lastError', 'HTTP ' + ad.response.status);
          } else {
            ad.environment.unset('lastError');
          }
        } catch (e) {
          ad.console.error('Script error: ' + e.message);
        }
      ''';

      notifier.update(
        id: id,
        preRequestScript: complexPreScript,
        postRequestScript: complexPostScript,
      );

      final updatedRequest = notifier.getRequestModel(id);
      expect(updatedRequest?.preRequestScript, equals(complexPreScript));
      expect(updatedRequest?.postRequestScript, equals(complexPostScript));
    });

    test('should handle empty and null scripts gracefully', () {
      final id = notifier.state!.entries.first.key;

      // Test with empty strings
      notifier.update(
        id: id,
        preRequestScript: '',
        postRequestScript: '',
      );

      var updatedRequest = notifier.getRequestModel(id);
      expect(updatedRequest?.preRequestScript, equals(''));
      expect(updatedRequest?.postRequestScript, equals(''));

      // Test with null values (should maintain existing values)
      notifier.update(
        id: id,
        preRequestScript: 'ad.console.log("test");',
        postRequestScript: 'ad.console.log("test");',
      );

      updatedRequest = notifier.getRequestModel(id);
      expect(
          updatedRequest?.preRequestScript, equals('ad.console.log("test");'));
      expect(
          updatedRequest?.postRequestScript, equals('ad.console.log("test");'));
    });

    test('should save and load scripts correctly', () async {
      final id = notifier.state!.entries.first.key;
      const preRequestScript = '''
        ad.request.headers.set('Authorization', 'Bearer test-token');
        ad.environment.set('requestStartTime', Date.now().toString());
      ''';
      const postResponseScript = '''
        const data = ad.response.json();
        if (data && data.user_id) {
          ad.environment.set('currentUserId', data.user_id);
        }
      ''';

      notifier.update(
        id: id,
        preRequestScript: preRequestScript,
        postRequestScript: postResponseScript,
      );
      await notifier.saveData();

      // Create new container and load data
      late ProviderContainer newContainer;
      try {
        newContainer = ProviderContainer();
        final newNotifier =
            newContainer.read(collectionStateNotifierProvider.notifier);

        // Give some time for the microtask in the constructor to complete
        await Future.delayed(const Duration(milliseconds: 10));

        final loadedRequest = newNotifier.getRequestModel(id);

        expect(loadedRequest?.preRequestScript, equals(preRequestScript));
        expect(loadedRequest?.postRequestScript, equals(postResponseScript));
      } finally {
        newContainer.dispose();
      }
    });

    test('should handle scripts in addRequestModel', () {
      const preRequestScript = 'ad.console.log("Added request pre-script");';
      const postResponseScript = 'ad.console.log("Added request post-script");';

      final httpRequestModel = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.apidash.dev/data',
        headers: const [
          NameValueModel(name: 'Content-Type', value: 'application/json'),
        ],
        body: '{"test": true}',
      );

      // Since addRequestModel takes HttpRequestModel, we'll test scripts through update
      notifier.addRequestModel(httpRequestModel, name: 'Test Request');

      final sequence = container.read(requestSequenceProvider);
      final addedId = sequence.first;

      notifier.update(
        id: addedId,
        preRequestScript: preRequestScript,
        postRequestScript: postResponseScript,
      );

      final addedRequest = notifier.getRequestModel(addedId);
      expect(addedRequest?.preRequestScript, equals(preRequestScript));
      expect(addedRequest?.postRequestScript, equals(postResponseScript));
    });

    test('should handle scripts with various JavaScript syntax', () {
      final id = notifier.state!.entries.first.key;

      const advancedPreScript = r'''
        // Advanced JavaScript features
        const config = {
          apiUrl: ad.environment.get('baseUrl') || 'https://api.apidash.dev/',
          timeout: 5000,
          retries: 3
        };
        
        // Arrow functions and template literals
        const generateId = () => 'req_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
        
        // Destructuring and modern syntax
        const apiUrl = config.apiUrl;
        const timeout = config.timeout;
        ad.request.url.set(apiUrl + '/v1/users');
        ad.request.headers.set('X-Request-ID', generateId());
        ad.request.headers.set('X-Timeout', timeout.toString());
        
        // Conditional logic
        if (ad.environment.has('debugMode')) {
          ad.request.headers.set('X-Debug', 'true');
          ad.console.log('Debug mode enabled');
        }
        
        // Array operations
        const requiredHeaders = ['Authorization', 'Content-Type'];
        requiredHeaders.forEach(function(header) {
          if (!ad.request.headers.has(header)) {
            ad.console.warn('Missing required header: ' + header);
          }
        });
      ''';

      const advancedPostScript = r'''
        // Advanced response processing
        try {
          const response = ad.response.json();
          
          // Object destructuring
          const responseData = response ? response.data : null;
          const meta = response ? response.meta : null;
          const errors = response ? response.errors : null;
          
          if (errors && Array.isArray(errors)) {
            errors.forEach(function(error, index) {
              ad.console.error('Error ' + (index + 1) + ': ' + error.message);
            });
            ad.environment.set('hasErrors', 'true');
          } else {
            ad.environment.unset('hasErrors');
          }
          
          // Handle pagination metadata
          if (meta && meta.pagination) {
            const page = meta.pagination.page;
            const total = meta.pagination.total;
            const hasNext = meta.pagination.hasNext;
            ad.environment.set('currentPage', page.toString());
            ad.environment.set('totalRecords', total.toString());
            ad.environment.set('hasNextPage', hasNext.toString());
          }
          
          // Extract nested data
          if (responseData && Array.isArray(responseData)) {
            const activeItems = responseData.filter(function(item) {
              return item.status === 'active';
            });
            ad.environment.set('activeItemCount', activeItems.length.toString());
            
            // Store first active item ID if available
            if (activeItems.length > 0) {
              ad.environment.set('firstActiveId', activeItems[0].id);
            }
          }
          
        } catch (parseError) {
          ad.console.error('Failed to parse response JSON: ' + parseError.message);
          ad.environment.set('parseError', parseError.message);
        }
        
        // Response timing analysis
        const responseTime = ad.response.time;
        if (responseTime) {
          ad.environment.set('lastResponseTime', responseTime.toString());
          
          if (responseTime > 2000) {
            ad.console.warn('Slow response detected: ' + responseTime + 'ms');
            ad.environment.set('slowResponse', 'true');
          } else {
            ad.environment.unset('slowResponse');
          }
        }
      ''';

      notifier.update(
        id: id,
        preRequestScript: advancedPreScript,
        postRequestScript: advancedPostScript,
      );

      final updatedRequest = notifier.getRequestModel(id);
      expect(updatedRequest?.preRequestScript, equals(advancedPreScript));
      expect(updatedRequest?.postRequestScript, equals(advancedPostScript));
    });

    test(
        'should handle script updates without affecting other request properties',
        () {
      final id = notifier.state!.entries.first.key;

      // First set up a complete request
      notifier.update(
        id: id,
        method: HTTPVerb.post,
        url: 'https://api.apidash.dev/test',
        headers: const [
          NameValueModel(name: 'Content-Type', value: 'application/json'),
          NameValueModel(name: 'Accept', value: 'application/json'),
        ],
        body: '{"test": "data"}',
        name: 'Test Request',
        description: 'A test request with scripts',
      );

      final beforeRequest = notifier.getRequestModel(id);

      // Now update only scripts
      const newPreScript = 'ad.console.log("Updated pre-script");';
      const newPostScript = 'ad.console.log("Updated post-script");';

      notifier.update(
        id: id,
        preRequestScript: newPreScript,
        postRequestScript: newPostScript,
      );

      final afterRequest = notifier.getRequestModel(id);

      // Verify scripts were updated
      expect(afterRequest?.preRequestScript, equals(newPreScript));
      expect(afterRequest?.postRequestScript, equals(newPostScript));

      // Verify other properties were preserved
      expect(afterRequest?.httpRequestModel?.method,
          equals(beforeRequest?.httpRequestModel?.method));
      expect(afterRequest?.httpRequestModel?.url,
          equals(beforeRequest?.httpRequestModel?.url));
      expect(afterRequest?.httpRequestModel?.headers,
          equals(beforeRequest?.httpRequestModel?.headers));
      expect(afterRequest?.httpRequestModel?.body,
          equals(beforeRequest?.httpRequestModel?.body));
      expect(afterRequest?.name, equals(beforeRequest?.name));
      expect(afterRequest?.description, equals(beforeRequest?.description));
    });

    test(
        'should not modify original state during script execution - only execution copy',
        () {
      final id = notifier.state!.entries.first.key;

      const preRequestScript = r'''
        // Script that modifies request properties
        ad.request.headers.set('X-Script-Modified', 'true');
        ad.request.headers.set('Authorization', 'Bearer script-token');
        ad.request.url.set('https://api.apidash.dev/');
        ad.request.params.set('scriptParam', 'scriptValue');
        ad.environment.set('scriptExecuted', 'true');
        ad.console.log('Pre-request script executed and modified request');
      ''';

      // Set up initial request properties
      notifier.update(
        id: id,
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/api',
        headers: const [
          NameValueModel(name: 'Content-Type', value: 'application/json'),
          NameValueModel(name: 'Accept', value: 'application/json'),
        ],
        params: const [
          NameValueModel(name: 'originalParam', value: 'originalValue'),
        ],
        preRequestScript: preRequestScript,
      );

      // Capture the original state before script execution simulation
      final originalRequest = notifier.getRequestModel(id);
      final originalHttpRequestModel = originalRequest!.httpRequestModel!;

      // Test the script execution isolation by simulating the copyWith pattern used in sendRequest
      final executionRequestModel = originalRequest.copyWith();

      // Verify that the execution copy is separate from original
      expect(executionRequestModel.id, equals(originalRequest.id));
      expect(executionRequestModel.httpRequestModel?.url,
          equals(originalRequest.httpRequestModel?.url));
      expect(executionRequestModel.httpRequestModel?.headers,
          equals(originalRequest.httpRequestModel?.headers));
      expect(executionRequestModel.httpRequestModel?.params,
          equals(originalRequest.httpRequestModel?.params));

      // Simulate script modifications on the execution copy
      final modifiedExecutionModel = executionRequestModel.copyWith(
        httpRequestModel: executionRequestModel.httpRequestModel?.copyWith(
          url: 'https://api.apidash.dev/',
          headers: [
            ...originalHttpRequestModel.headers ?? [],
            const NameValueModel(name: 'X-Script-Modified', value: 'true'),
            const NameValueModel(
                name: 'Authorization', value: 'Bearer script-token'),
          ],
          params: [
            ...originalHttpRequestModel.params ?? [],
            const NameValueModel(name: 'scriptParam', value: 'scriptValue'),
          ],
        ),
      );

      // Verify the execution copy has been modified
      expect(modifiedExecutionModel.httpRequestModel?.url,
          equals('https://api.apidash.dev/'));
      expect(
          modifiedExecutionModel.httpRequestModel?.headers?.length, equals(4));

      final hasScriptModifiedHeader = modifiedExecutionModel
              .httpRequestModel?.headers
              ?.any((header) => header.name == 'X-Script-Modified') ??
          false;
      expect(hasScriptModifiedHeader, isTrue);

      final hasAuthHeader = modifiedExecutionModel.httpRequestModel?.headers
              ?.any((header) => header.name == 'Authorization') ??
          false;
      expect(hasAuthHeader, isTrue);

      final hasScriptParam = modifiedExecutionModel.httpRequestModel?.params
              ?.any((param) => param.name == 'scriptParam') ??
          false;
      expect(hasScriptParam, isTrue);

      // Verify that the original request in the state remains completely unchanged
      final currentRequest = notifier.getRequestModel(id);

      expect(currentRequest?.httpRequestModel?.url,
          equals('https://api.apidash.dev/api'));
      expect(currentRequest?.httpRequestModel?.headers?.length, equals(2));
      expect(currentRequest?.httpRequestModel?.headers?[0].name,
          equals('Content-Type'));
      expect(currentRequest?.httpRequestModel?.headers?[0].value,
          equals('application/json'));
      expect(
          currentRequest?.httpRequestModel?.headers?[1].name, equals('Accept'));
      expect(currentRequest?.httpRequestModel?.headers?[1].value,
          equals('application/json'));
      expect(currentRequest?.httpRequestModel?.params?.length, equals(1));
      expect(currentRequest?.httpRequestModel?.params?[0].name,
          equals('originalParam'));
      expect(currentRequest?.httpRequestModel?.params?[0].value,
          equals('originalValue'));

      // Verify no script-modified headers are present in the original state
      final hasScriptModifiedHeaderInOriginal = currentRequest
              ?.httpRequestModel?.headers
              ?.any((header) => header.name == 'X-Script-Modified') ??
          false;
      expect(hasScriptModifiedHeaderInOriginal, isFalse);

      final hasAuthHeaderInOriginal = currentRequest?.httpRequestModel?.headers
              ?.any((header) => header.name == 'Authorization') ??
          false;
      expect(hasAuthHeaderInOriginal, isFalse);

      // Verify no script-modified params are present in the original state
      final hasScriptParamInOriginal = currentRequest?.httpRequestModel?.params
              ?.any((param) => param.name == 'scriptParam') ??
          false;
      expect(hasScriptParamInOriginal, isFalse);

      // Verify the script is preserved in the original
      expect(currentRequest?.preRequestScript, equals(preRequestScript));
    });

    tearDown(() {
      container.dispose();
    });
  });
}
