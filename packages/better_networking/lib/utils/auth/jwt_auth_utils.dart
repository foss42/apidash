import 'dart:convert';
import 'package:better_networking/models/auth/auth_jwt_model.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

String generateJWT(AuthJwtModel jwtAuth) {
  try {
    // Parse header if provided
    Map<String, dynamic> headerMap = {};
    if (jwtAuth.header.isNotEmpty) {
      try {
        headerMap = json.decode(jwtAuth.header) as Map<String, dynamic>;
      } catch (e) {
        // If header parsing fails, use empty header
        headerMap = {};
      }
    }

    // Parse payload if provided
    Map<String, dynamic> payloadMap = {};
    if (jwtAuth.payload.isNotEmpty) {
      try {
        payloadMap = json.decode(jwtAuth.payload) as Map<String, dynamic>;
      } catch (e) {
        // If payload parsing fails, use empty payload
        payloadMap = {};
      }
    }

    // Add issued at time if not present
    if (!payloadMap.containsKey('iat')) {
      payloadMap['iat'] = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    }
    final jwt = JWT(payloadMap, header: headerMap);

    final key = _createKey(
      jwtAuth.secret,
      jwtAuth.algorithm,
      jwtAuth.isSecretBase64Encoded,
      jwtAuth.privateKey,
    );
    final token = jwt.sign(
      key,
      algorithm: JWTAlgorithm.fromName(jwtAuth.algorithm),
    );

    return token;
  } catch (e) {
    throw Exception('Failed to generate JSON Wweb Token: $e');
  }
}

JWTKey _createKey(
  String secret,
  String algorithm,
  bool isSecretBase64Encoded,
  String? privateKey,
) {
  if (algorithm.startsWith('HS')) {
    if (isSecretBase64Encoded) {
      final decodedSecret = base64.decode(secret);
      return SecretKey(String.fromCharCodes(decodedSecret));
    } else {
      return SecretKey(secret);
    }
  }
  if (algorithm.startsWith('RS') || algorithm.startsWith('PS')) {
    if (privateKey == null) {
      throw Exception(
        'Failed to generate JSON Wweb Token: Private Key not Found',
      );
    }
    return RSAPrivateKey(privateKey);
  }
  if (algorithm.startsWith('ES')) {
    if (privateKey == null) {
      throw Exception(
        'Failed to generate JSON Wweb Token: Private Key not Found',
      );
    }
    return ECPrivateKey(privateKey);
  }

  if (algorithm == 'EdDSA') {
    if (privateKey == null) {
      throw Exception(
        'Failed to generate JSON Wweb Token: Private Key not Found',
      );
    }
    return EdDSAPrivateKey.fromPEM(privateKey);
  }

  return SecretKey(secret, isBase64Encoded: isSecretBase64Encoded);
}
