import 'package:better_networking/models/auth/auth_jwt_model.dart';
import 'package:test/test.dart';
import 'auth_models.dart';

void main() {
  group('Testing AuthJwtModel', () {
    test("Testing AuthJwtModel copyWith", () {
      var authJwtModel = authJwtModel1;
      final authJwtModelCopyWith = authJwtModel.copyWith(
        secret: 'new_secret',
        algorithm: 'HS256',
        isSecretBase64Encoded: false,
      );
      expect(authJwtModelCopyWith.secret, 'new_secret');
      expect(authJwtModelCopyWith.algorithm, 'HS256');
      expect(authJwtModelCopyWith.isSecretBase64Encoded, false);
      // original model unchanged
      expect(authJwtModel.secret, 'jwt-secret-key');
      expect(authJwtModel.algorithm, 'RS256');
      expect(authJwtModel.isSecretBase64Encoded, true);
    });

    test("Testing AuthJwtModel toJson", () {
      var authJwtModel = authJwtModel1;
      expect(authJwtModel.toJson(), authJwtModelJson1);
    });

    test("Testing AuthJwtModel fromJson", () {
      var authJwtModel = authJwtModel1;
      final modelFromJson = AuthJwtModel.fromJson(authJwtModelJson1);
      expect(modelFromJson, authJwtModel);
      expect(modelFromJson.secret, 'jwt-secret-key');
      expect(modelFromJson.algorithm, 'RS256');
      expect(modelFromJson.isSecretBase64Encoded, true);
    });

    test("Testing AuthJwtModel getters", () {
      var authJwtModel = authJwtModel1;
      expect(authJwtModel.secret, 'jwt-secret-key');
      expect(
        authJwtModel.privateKey,
        startsWith('-----BEGIN RSA PRIVATE KEY-----'),
      );
      expect(authJwtModel.payload, '{"user_id": 123, "exp": 1735689600}');
      expect(authJwtModel.addTokenTo, 'header');
      expect(authJwtModel.algorithm, 'RS256');
      expect(authJwtModel.isSecretBase64Encoded, true);
      expect(authJwtModel.headerPrefix, 'JWT');
      expect(authJwtModel.queryParamKey, 'jwt_token');
      expect(authJwtModel.header, 'X-JWT-Token');
    });

    test("Testing AuthJwtModel equality", () {
      const authJwtModel1Copy = AuthJwtModel(
        secret: 'jwt-secret-key',
        privateKey: '''-----BEGIN RSA PRIVATE KEY-----
MIICWgIBAAKBgHa+iOFqaom/Eg1xlBapqu6JPDHMhsCLy06i4/yZ6KFTz8RWBDG8
rRdhqSTOWCGtLq+unK/A1lkexaYE3lHBbn/2dzDjaXA48G/B4s4R6ixigQDWnZJd
e4GVKuLOZx82tDSl0yLQOzOzUMygj8IRBgp7CaL4WBRo5DwGRXAON9A7AgMBAAEC
gYAlotZ3u+bwqeLq5+jsFfLbkBvIHO9I8AYMcoyYb5/QImRj8m955Ddohce6prxA
UEfP3yRCgHhv3tT+feSJPSnsbPIpWnmnvDdy+NLij6rYKjga8oYyskg8wpYKSsgO
nNTWI8jLDTM2TFGXAR+Pn+yQ120fmcdhMKsnshnxitHhAQJBAM58Tz/SKb+Hgojs
Le3WJfs1meK0ecEHVZr9p+8mXmn1qUWddG/Mi1m2Zr3ycef+JMDp8CKexa/dacSV
00D+G6ECQQCTN/tEBBia1+eMy3+GKYVH/M7jVSPxjcTQF3qnBnd752AJNqHUpaFO
af8d1omyRY8DdCgTs/JjfesveaL0Uz5bAkB+bVCctBKJye/b5DhO+qLwyCX70CMI
VHRO3Oa5IBYI7LiC/mBvn57nBC6uOMcTk+FvGQ3GNM632mrLSi06CxxhAkA92BeS
xBG+ApL//4DL0GdwDVCwCVU3JTIXpLVeswXApDsgw7WKCiZQNZD5bOWdYUEp10L6
u+5IQ15oLDX7Y3jfAkBtpWyAuhQwYLpiLPa82U9zus9IxYpfqohVBeiT5UasSssx
OUdMDWRxHzjEexN0nmD1nIPbKNJd0/rvj7jI82Kh
-----END RSA PRIVATE KEY-----''',
        payload: '{"user_id": 123, "exp": 1735689600}',
        addTokenTo: 'header',
        algorithm: 'RS256',
        isSecretBase64Encoded: true,
        headerPrefix: 'JWT',
        queryParamKey: 'jwt_token',
        header: 'X-JWT-Token',
      );
      expect(authJwtModel1, authJwtModel1Copy);
      expect(authJwtModel1, isNot(authJwtModel2));
    });

    test("Testing AuthJwtModel with different configurations", () {
      expect(authJwtModel2.secret, 'different-jwt-secret');
      expect(authJwtModel2.algorithm, 'HS256');
      expect(authJwtModel2.isSecretBase64Encoded, false);
      expect(authJwtModel2.addTokenTo, 'query');
      expect(authJwtModel2.headerPrefix, 'Bearer');
      expect(authJwtModel2.header, 'Authorization');

      // Compare differences
      expect(authJwtModel1.secret, isNot(authJwtModel2.secret));
      expect(authJwtModel1.algorithm, isNot(authJwtModel2.algorithm));
      expect(
        authJwtModel1.isSecretBase64Encoded,
        isNot(authJwtModel2.isSecretBase64Encoded),
      );
      expect(authJwtModel1.addTokenTo, isNot(authJwtModel2.addTokenTo));
    });

    test("Testing AuthJwtModel payload parsing", () {
      var authJwtModel = authJwtModel1;
      expect(authJwtModel.payload, contains('user_id'));
      expect(authJwtModel.payload, contains('exp'));

      var authJwtModel2Local = authJwtModel2;
      expect(authJwtModel2Local.payload, contains('sub'));
      expect(authJwtModel2Local.payload, contains('name'));
      expect(authJwtModel2Local.payload, contains('John Doe'));
    });
  });
}
