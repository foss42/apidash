import 'dart:convert';

import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/grpc_request_model.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildGrpcMetadata (authModel -> gRPC metadata)', () {
    test('no authModel -> only user metadata table, keys lower-cased', () async {
      const model = GrpcRequestModel(
        url: 'localhost:50051',
        metadata: [NameValueModel(name: 'X-Trace', value: 'abc')],
      );

      final meta = await buildGrpcMetadata(model);

      expect(meta, {'x-trace': 'abc'});
    });

    test('bearer auth -> authorization: Bearer <token>', () async {
      const model = GrpcRequestModel(
        url: 'localhost:50051',
        authModel: AuthModel(
          type: APIAuthType.bearer,
          bearer: AuthBearerModel(token: 'tok123'),
        ),
      );

      final meta = await buildGrpcMetadata(model);

      expect(meta['authorization'], 'Bearer tok123');
    });

    test('basic auth -> authorization: Basic <base64>', () async {
      const model = GrpcRequestModel(
        url: 'localhost:50051',
        authModel: AuthModel(
          type: APIAuthType.basic,
          basic: AuthBasicAuthModel(username: 'user', password: 'pass'),
        ),
      );

      final meta = await buildGrpcMetadata(model);

      final expected = 'Basic ${base64Encode(utf8.encode('user:pass'))}';
      expect(meta['authorization'], expected);
    });

    test('api-key header auth -> configured header name/value', () async {
      const model = GrpcRequestModel(
        url: 'localhost:50051',
        authModel: AuthModel(
          type: APIAuthType.apiKey,
          apikey: AuthApiKeyModel(key: 'secret', name: 'X-Api-Key'),
        ),
      );

      final meta = await buildGrpcMetadata(model);

      expect(meta['x-api-key'], 'secret');
    });

    test('auth entry overrides manual metadata with the same key', () async {
      const model = GrpcRequestModel(
        url: 'localhost:50051',
        metadata: [NameValueModel(name: 'authorization', value: 'stale')],
        authModel: AuthModel(
          type: APIAuthType.bearer,
          bearer: AuthBearerModel(token: 'fresh'),
        ),
      );

      final meta = await buildGrpcMetadata(model);

      // Auth is the source of truth; the stale manual row is overridden.
      expect(meta['authorization'], 'Bearer fresh');
    });

    test('auth entries coexist with unrelated manual metadata', () async {
      const model = GrpcRequestModel(
        url: 'localhost:50051',
        metadata: [NameValueModel(name: 'x-tenant', value: 't1')],
        authModel: AuthModel(
          type: APIAuthType.bearer,
          bearer: AuthBearerModel(token: 'tok'),
        ),
      );

      final meta = await buildGrpcMetadata(model);

      expect(meta['x-tenant'], 't1');
      expect(meta['authorization'], 'Bearer tok');
    });

    test('APIAuthType.none -> no auth metadata added', () async {
      const model = GrpcRequestModel(
        url: 'localhost:50051',
        metadata: [NameValueModel(name: 'x-a', value: '1')],
        authModel: AuthModel(type: APIAuthType.none),
      );

      final meta = await buildGrpcMetadata(model);

      expect(meta, {'x-a': '1'});
    });
  });
}
