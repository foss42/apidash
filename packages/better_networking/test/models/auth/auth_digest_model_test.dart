import 'package:better_networking/models/auth/auth_digest_model.dart';
import 'package:test/test.dart';
import 'auth_models.dart';

void main() {
  group('Testing AuthDigestModel', () {
    test("Testing AuthDigestModel copyWith", () {
      var authDigestModel = authDigestModel1;
      final authDigestModelCopyWith = authDigestModel.copyWith(
        username: 'new_user',
        algorithm: 'MD5',
        qop: 'auth',
      );
      expect(authDigestModelCopyWith.username, 'new_user');
      expect(authDigestModelCopyWith.algorithm, 'MD5');
      expect(authDigestModelCopyWith.qop, 'auth');
      // original model unchanged
      expect(authDigestModel.username, 'digest_user');
      expect(authDigestModel.algorithm, 'SHA-256');
      expect(authDigestModel.qop, 'auth-int');
    });

    test("Testing AuthDigestModel toJson", () {
      var authDigestModel = authDigestModel1;
      expect(authDigestModel.toJson(), authDigestModelJson1);
    });

    test("Testing AuthDigestModel fromJson", () {
      var authDigestModel = authDigestModel1;
      final modelFromJson = AuthDigestModel.fromJson(authDigestModelJson1);
      expect(modelFromJson, authDigestModel);
      expect(modelFromJson.username, 'digest_user');
      expect(modelFromJson.password, 'digest_pass');
      expect(modelFromJson.realm, 'protected-area');
      expect(modelFromJson.algorithm, 'SHA-256');
    });

    test("Testing AuthDigestModel getters", () {
      var authDigestModel = authDigestModel1;
      expect(authDigestModel.username, 'digest_user');
      expect(authDigestModel.password, 'digest_pass');
      expect(authDigestModel.realm, 'protected-area');
      expect(authDigestModel.nonce, 'dcd98b7102dd2f0e8b11d0f600bfb0c093');
      expect(authDigestModel.algorithm, 'SHA-256');
      expect(authDigestModel.qop, 'auth-int');
      expect(authDigestModel.opaque, '5ccc069c403ebaf9f0171e9517f40e41');
    });

    test("Testing AuthDigestModel equality", () {
      const authDigestModel1Copy = AuthDigestModel(
        username: 'digest_user',
        password: 'digest_pass',
        realm: 'protected-area',
        nonce: 'dcd98b7102dd2f0e8b11d0f600bfb0c093',
        algorithm: 'SHA-256',
        qop: 'auth-int',
        opaque: '5ccc069c403ebaf9f0171e9517f40e41',
      );
      expect(authDigestModel1, authDigestModel1Copy);
      expect(authDigestModel1, isNot(authDigestModel2));
    });

    test("Testing AuthDigestModel with different configurations", () {
      expect(authDigestModel2.username, 'another_digest_user');
      expect(authDigestModel2.password, 'another_digest_pass');
      expect(authDigestModel2.realm, 'different-realm');
      expect(authDigestModel2.nonce, 'abc12345678901234567890abcdef012');
      expect(authDigestModel2.algorithm, 'MD5');
      expect(authDigestModel2.qop, 'auth');
      expect(authDigestModel2.opaque, 'fedcba0987654321098765432109876543');

      // Compare differences
      expect(authDigestModel1.username, isNot(authDigestModel2.username));
      expect(authDigestModel1.algorithm, isNot(authDigestModel2.algorithm));
      expect(authDigestModel1.qop, isNot(authDigestModel2.qop));
      expect(authDigestModel1.realm, isNot(authDigestModel2.realm));
    });

    test("Testing AuthDigestModel nonce and opaque values", () {
      var authDigestModel = authDigestModel1;
      expect(authDigestModel.nonce.length, 34);
      expect(authDigestModel.opaque.length, 32);
      expect(authDigestModel.nonce, matches(RegExp(r'^[a-f0-9]+$')));
      expect(authDigestModel.opaque, matches(RegExp(r'^[a-f0-9]+$')));
    });
  });
}
