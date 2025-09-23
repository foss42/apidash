import 'package:better_networking/models/auth/api_auth_model.dart';
import 'package:better_networking/models/auth/auth_basic_model.dart';
import 'package:better_networking/models/auth/auth_bearer_model.dart';
import 'package:better_networking/models/auth/auth_api_key_model.dart';
import 'package:better_networking/models/auth/auth_jwt_model.dart';
import 'package:better_networking/models/auth/auth_digest_model.dart';
import 'package:better_networking/models/auth/auth_oauth1_model.dart';
import 'package:better_networking/models/auth/auth_oauth2_model.dart';
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

const authOAuth1Model1 = AuthOAuth1Model(
  consumerKey: 'oauth1-consumer-key-123',
  consumerSecret: 'oauth1-consumer-secret-456',
  credentialsFilePath: '/path/to/oauth1/credentials.json',
  accessToken: 'oauth1-access-token-789',
  tokenSecret: 'oauth1-token-secret-012',
  signatureMethod: OAuth1SignatureMethod.hmacSha1,
  parameterLocation: 'header',
  version: '1.0',
  realm: 'oauth1-realm',
  callbackUrl: 'https://example.com/callback',
  verifier: 'oauth1-verifier-345',
  nonce: 'oauth1-nonce-678',
  timestamp: '1640995200',
  includeBodyHash: false,
);

const authOAuth1Model2 = AuthOAuth1Model(
  consumerKey: 'different-consumer-key',
  consumerSecret: 'different-consumer-secret',
  credentialsFilePath: '/different/path/credentials.json',
  signatureMethod: OAuth1SignatureMethod.plaintext,
  parameterLocation: 'query',
  version: '1.0a',
  includeBodyHash: true,
);

const authOAuth2Model1 = AuthOAuth2Model(
  grantType: OAuth2GrantType.authorizationCode,
  authorizationUrl: 'https://oauth.example.com/authorize',
  accessTokenUrl: 'https://oauth.example.com/token',
  clientId: 'oauth2-client-id-123',
  clientSecret: 'oauth2-client-secret-456',
  credentialsFilePath: '/path/to/oauth2/credentials.json',
  redirectUrl: 'https://example.com/redirect',
  scope: 'read write admin',
  state: 'oauth2-state-789',
  codeChallengeMethod: 'S256',
  codeVerifier: 'oauth2-code-verifier-012',
  codeChallenge: 'oauth2-code-challenge-345',
  username: 'oauth2-username',
  password: 'oauth2-password',
  refreshToken: 'oauth2-refresh-token-678',
  identityToken: 'oauth2-identity-token-901',
  accessToken: 'oauth2-access-token-234',
);

const authOAuth2Model2 = AuthOAuth2Model(
  grantType: OAuth2GrantType.clientCredentials,
  authorizationUrl: 'https://different-oauth.example.com/auth',
  accessTokenUrl: 'https://different-oauth.example.com/token',
  clientId: 'different-client-id',
  clientSecret: 'different-client-secret',
  credentialsFilePath: '/different/oauth2/path.json',
  scope: 'api:read',
  codeChallengeMethod: 'plain',
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

const authModel6 = AuthModel(
  type: APIAuthType.oauth1,
  oauth1: authOAuth1Model1,
);

const authModel7 = AuthModel(
  type: APIAuthType.oauth2,
  oauth2: authOAuth2Model1,
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

final Map<String, dynamic> authOAuth1ModelJson1 = {
  "consumerKey": "oauth1-consumer-key-123",
  "consumerSecret": "oauth1-consumer-secret-456",
  "credentialsFilePath": "/path/to/oauth1/credentials.json",
  "accessToken": "oauth1-access-token-789",
  "tokenSecret": "oauth1-token-secret-012",
  "signatureMethod": "hmacSha1",
  "parameterLocation": "header",
  "version": "1.0",
  "realm": "oauth1-realm",
  "callbackUrl": "https://example.com/callback",
  "verifier": "oauth1-verifier-345",
  "nonce": "oauth1-nonce-678",
  "timestamp": "1640995200",
  "includeBodyHash": false,
};

final Map<String, dynamic> authOAuth2ModelJson1 = {
  "grantType": "authorizationCode",
  "authorizationUrl": "https://oauth.example.com/authorize",
  "accessTokenUrl": "https://oauth.example.com/token",
  "clientId": "oauth2-client-id-123",
  "clientSecret": "oauth2-client-secret-456",
  "credentialsFilePath": "/path/to/oauth2/credentials.json",
  "redirectUrl": "https://example.com/redirect",
  "scope": "read write admin",
  "state": "oauth2-state-789",
  "codeChallengeMethod": "S256",
  "codeVerifier": "oauth2-code-verifier-012",
  "codeChallenge": "oauth2-code-challenge-345",
  "username": "oauth2-username",
  "password": "oauth2-password",
  "refreshToken": "oauth2-refresh-token-678",
  "identityToken": "oauth2-identity-token-901",
  "accessToken": "oauth2-access-token-234",
};

final Map<String, dynamic> authModelJson1 = {
  "type": "basic",
  "apikey": null,
  "bearer": null,
  "basic": {"username": "john_doe", "password": "secure_password"},
  "jwt": null,
  "digest": null,
  "oauth1": null,
  "oauth2": null,
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
  "oauth1": null,
  "oauth2": null,
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
  "oauth1": null,
  "oauth2": null,
};

final Map<String, dynamic> authModelOAuth1Json = {
  "type": "oauth1",
  "apikey": null,
  "bearer": null,
  "basic": null,
  "jwt": null,
  "digest": null,
  "oauth1": {
    "consumerKey": "oauth1-consumer-key-123",
    "consumerSecret": "oauth1-consumer-secret-456",
    "credentialsFilePath": "/path/to/oauth1/credentials.json",
    "accessToken": "oauth1-access-token-789",
    "tokenSecret": "oauth1-token-secret-012",
    "signatureMethod": "hmacSha1",
    "parameterLocation": "header",
    "version": "1.0",
    "realm": "oauth1-realm",
    "callbackUrl": "https://example.com/callback",
    "verifier": "oauth1-verifier-345",
    "nonce": "oauth1-nonce-678",
    "timestamp": "1640995200",
    "includeBodyHash": false,
  },
  "oauth2": null,
};

final Map<String, dynamic> authModelOAuth2Json = {
  "type": "oauth2",
  "apikey": null,
  "bearer": null,
  "basic": null,
  "jwt": null,
  "digest": null,
  "oauth1": null,
  "oauth2": {
    "grantType": "authorizationCode",
    "authorizationUrl": "https://oauth.example.com/authorize",
    "accessTokenUrl": "https://oauth.example.com/token",
    "clientId": "oauth2-client-id-123",
    "clientSecret": "oauth2-client-secret-456",
    "credentialsFilePath": "/path/to/oauth2/credentials.json",
    "redirectUrl": "https://example.com/redirect",
    "scope": "read write admin",
    "state": "oauth2-state-789",
    "codeChallengeMethod": "S256",
    "codeVerifier": "oauth2-code-verifier-012",
    "codeChallenge": "oauth2-code-challenge-345",
    "username": "oauth2-username",
    "password": "oauth2-password",
    "refreshToken": "oauth2-refresh-token-678",
    "identityToken": "oauth2-identity-token-901",
    "accessToken": "oauth2-access-token-234",
  },
};

final Map<String, dynamic> authModelNoneJson = {
  "type": "none",
  "apikey": null,
  "bearer": null,
  "basic": null,
  "jwt": null,
  "digest": null,
  "oauth1": null,
  "oauth2": null,
};
