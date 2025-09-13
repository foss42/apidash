import 'package:better_networking/models/auth/api_auth_model.dart';
import 'package:better_networking/models/auth/auth_basic_model.dart';
import 'package:better_networking/models/auth/auth_bearer_model.dart';
import 'package:better_networking/models/auth/auth_api_key_model.dart';
import 'package:better_networking/models/auth/auth_jwt_model.dart';
import 'package:better_networking/models/auth/auth_digest_model.dart';
import 'package:better_networking/consts.dart';

/// Auth models for testing

const authBasicModel1 = AuthBasicAuthModel(
  username: 'john_doe',
  password: 'secure_password',
);

const authBasicModel2 = AuthBasicAuthModel(
  username: 'jane_smith',
  password: 'another_password',
);

const authBearerModel1 = AuthBearerModel(
  token:
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c',
);

const authBearerModel2 = AuthBearerModel(token: 'different_bearer_token_value');

const authApiKeyModel1 = AuthApiKeyModel(
  key: 'ak-test-key-12345',
  location: 'header',
  name: 'x-api-key',
);

const authApiKeyModel2 = AuthApiKeyModel(
  key: 'query-api-key-67890',
  location: 'query',
  name: 'api_key',
);

const authJwtModel1 = AuthJwtModel(
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

const authJwtModel2 = AuthJwtModel(
  secret: 'different-jwt-secret',
  payload: '{"sub": "1234567890", "name": "John Doe", "iat": 1516239022}',
  addTokenTo: 'query',
  algorithm: 'HS256',
  isSecretBase64Encoded: false,
  headerPrefix: 'Bearer',
  queryParamKey: 'token',
  header: 'Authorization',
);

const authDigestModel1 = AuthDigestModel(
  username: 'digest_user',
  password: 'digest_pass',
  realm: 'protected-area',
  nonce: 'dcd98b7102dd2f0e8b11d0f600bfb0c093',
  algorithm: 'SHA-256',
  qop: 'auth-int',
  opaque: '5ccc069c403ebaf9f0171e9517f40e41',
);

const authDigestModel2 = AuthDigestModel(
  username: 'another_digest_user',
  password: 'another_digest_pass',
  realm: 'different-realm',
  nonce: 'abc12345678901234567890abcdef012',
  algorithm: 'MD5',
  qop: 'auth',
  opaque: 'fedcba0987654321098765432109876543',
);

const authModel1 = AuthModel(type: APIAuthType.basic, basic: authBasicModel1);

const authModel2 = AuthModel(
  type: APIAuthType.bearer,
  bearer: authBearerModel1,
);

const authModel3 = AuthModel(
  type: APIAuthType.apiKey,
  apikey: authApiKeyModel1,
);

const authModel4 = AuthModel(type: APIAuthType.jwt, jwt: authJwtModel1);

const authModel5 = AuthModel(
  type: APIAuthType.digest,
  digest: authDigestModel1,
);

const authModelNone = AuthModel(type: APIAuthType.none);

/// JSON representations for testing

final Map<String, dynamic> authBasicModelJson1 = {
  "username": "john_doe",
  "password": "secure_password",
};

final Map<String, dynamic> authBearerModelJson1 = {
  "token":
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c",
};

final Map<String, dynamic> authApiKeyModelJson1 = {
  "key": "ak-test-key-12345",
  "location": "header",
  "name": "x-api-key",
};

final Map<String, dynamic> authJwtModelJson1 = {
  "secret": "jwt-secret-key",
  "privateKey": '''-----BEGIN RSA PRIVATE KEY-----
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
  "payload": "{\"user_id\": 123, \"exp\": 1735689600}",
  "addTokenTo": "header",
  "algorithm": "RS256",
  "isSecretBase64Encoded": true,
  "headerPrefix": "JWT",
  "queryParamKey": "jwt_token",
  "header": "X-JWT-Token",
};

final Map<String, dynamic> authDigestModelJson1 = {
  "username": "digest_user",
  "password": "digest_pass",
  "realm": "protected-area",
  "nonce": "dcd98b7102dd2f0e8b11d0f600bfb0c093",
  "algorithm": "SHA-256",
  "qop": "auth-int",
  "opaque": "5ccc069c403ebaf9f0171e9517f40e41",
};

final Map<String, dynamic> authModelJson1 = {
  "type": "basic",
  "apikey": null,
  "bearer": null,
  "basic": {"username": "john_doe", "password": "secure_password"},
  "jwt": null,
  "digest": null,
};

final Map<String, dynamic> authModelJson2 = {
  "type": "bearer",
  "apikey": null,
  "bearer": {
    "token":
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c",
  },
  "basic": null,
  "jwt": null,
  "digest": null,
};

final Map<String, dynamic> authModelJson3 = {
  "type": "",
  "apikey": null,
  "bearer": {
    "token":
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c",
  },
  "basic": null,
  "jwt": null,
  "digest": null,
};

final Map<String, dynamic> authModelNoneJson = {
  "type": "none",
  "apikey": null,
  "bearer": null,
  "basic": null,
  "jwt": null,
  "digest": null,
};
