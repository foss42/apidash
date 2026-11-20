import 'dart:convert';
import 'dart:io' as io;

import 'package:better_networking/better_networking.dart';
import 'package:test/test.dart';

class _CapturedTokenRequest {
  _CapturedTokenRequest(this.server, this.receivedBodies);

  final io.HttpServer server;
  final List<String> receivedBodies;

  String get tokenUrl => 'http://127.0.0.1:${server.port}/token';
}

Future<_CapturedTokenRequest> _startMockTokenServer(String accessToken) async {
  final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
  addTearDown(() async => server.close(force: true));

  final bodies = <String>[];
  server.listen((io.HttpRequest req) async {
    bodies.add(await utf8.decoder.bind(req).join());
    req.response.statusCode = io.HttpStatus.ok;
    req.response.headers.contentType = io.ContentType.json;
    req.response.write(
      jsonEncode({
        'access_token': accessToken,
        'token_type': 'bearer',
        'expires_in': 3600,
      }),
    );
    await req.response.close();
  });
  return _CapturedTokenRequest(server, bodies);
}

AuthModel _buildOAuth2Auth({
  required OAuth2GrantType grantType,
  required String tokenUrl,
  String authorizationUrl = '',
  String? username,
  String? password,
}) {
  return AuthModel(
    type: APIAuthType.oauth2,
    oauth2: AuthOAuth2Model(
      grantType: grantType,
      authorizationUrl: authorizationUrl,
      accessTokenUrl: tokenUrl,
      clientId: 'test-client',
      clientSecret: 'test-secret',
      username: username,
      password: password,
      redirectUrl: null,
    ),
  );
}

void main() {
  const sampleRequest = HttpRequestModel(
    method: HTTPVerb.get,
    url: 'https://api.example.com/resource',
  );

  group('handleAuth OAuth2 redirectUrl handling', () {
    test('clientCredentials succeeds when redirectUrl is null', () async {
      final mock = await _startMockTokenServer('mock-cc-token-123');
      final authModel = _buildOAuth2Auth(
        grantType: OAuth2GrantType.clientCredentials,
        tokenUrl: mock.tokenUrl,
      );

      final updated = await handleAuth(sampleRequest, authModel);

      expect(mock.receivedBodies, hasLength(1));
      expect(
        mock.receivedBodies.single,
        contains('grant_type=client_credentials'),
      );
      expect(
        updated.headers?.any(
          (h) =>
              h.name.toLowerCase() == 'authorization' &&
              h.value == 'Bearer mock-cc-token-123',
        ),
        isTrue,
      );
    });

    test('resourceOwnerPassword succeeds when redirectUrl is null', () async {
      final mock = await _startMockTokenServer('mock-ropc-token-456');
      final authModel = _buildOAuth2Auth(
        grantType: OAuth2GrantType.resourceOwnerPassword,
        tokenUrl: mock.tokenUrl,
        username: 'alice',
        password: 'secret',
      );

      final updated = await handleAuth(sampleRequest, authModel);

      expect(mock.receivedBodies, hasLength(1));
      expect(mock.receivedBodies.single, contains('grant_type=password'));
      expect(
        updated.headers?.any(
          (h) =>
              h.name.toLowerCase() == 'authorization' &&
              h.value == 'Bearer mock-ropc-token-456',
        ),
        isTrue,
      );
    });

    test('authorizationCode throws when redirectUrl is null', () async {
      final authModel = _buildOAuth2Auth(
        grantType: OAuth2GrantType.authorizationCode,
        authorizationUrl: 'http://127.0.0.1/authorize',
        tokenUrl: 'http://127.0.0.1/token',
      );

      await expectLater(
        handleAuth(sampleRequest, authModel),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('No Redirect URL found!'),
          ),
        ),
      );
    });
  });
}
