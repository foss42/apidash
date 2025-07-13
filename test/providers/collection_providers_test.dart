import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_body.dart';
import 'package:apidash/widgets/editor.dart';
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
}
