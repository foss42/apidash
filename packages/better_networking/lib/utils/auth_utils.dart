import 'dart:convert';
import 'dart:typed_data';
import 'package:better_networking/models/auth/auth_jwt_model.dart';
import 'package:crypto/crypto.dart';

String generateJWT(AuthJwtModel jwtAuth) {
  try {
    Map<String, dynamic> header;
    if (jwtAuth.header.isNotEmpty) {
      try {
        header = json.decode(jwtAuth.header) as Map<String, dynamic>;
      } catch (e) {
        header = {};
      }
    } else {
      header = {};
    }
    header['typ'] = header['typ'] ?? 'JWT';
    header['alg'] = jwtAuth.algorithm;
    Map<String, dynamic> payload;
    if (jwtAuth.payload.isNotEmpty) {
      try {
        payload = json.decode(jwtAuth.payload) as Map<String, dynamic>;
      } catch (e) {
        payload = {};
      }
    } else {
      payload = {};
    }
    if (!payload.containsKey('iat')) {
      payload['iat'] = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    }

    // Encode header and payload
    final encodedHeader = _base64UrlEncode(utf8.encode(json.encode(header)));
    final encodedPayload = _base64UrlEncode(utf8.encode(json.encode(payload)));

    // Create signature
    final signature = _createSignature(
      '$encodedHeader.$encodedPayload',
      jwtAuth.secret,
      jwtAuth.algorithm,
      jwtAuth.isSecretBase64Encoded,
    );

    return '$encodedHeader.$encodedPayload.$signature';
  } catch (e) {
    throw Exception('Failed to generate JWT: $e');
  }
}

String _createSignature(
    String data, String secret, String algorithm, bool isSecretBase64Encoded) {
  try {
    Uint8List secretBytes;
    if (isSecretBase64Encoded) {
      secretBytes = base64.decode(secret);
    } else {
      secretBytes = utf8.encode(secret);
    }

    final dataBytes = utf8.encode(data);

    switch (algorithm) {
      case 'HS256':
        final hmac = Hmac(sha256, secretBytes);
        final digest = hmac.convert(dataBytes);
        return _base64UrlEncode(digest.bytes);

      case 'HS384':
        final hmac = Hmac(sha384, secretBytes);
        final digest = hmac.convert(dataBytes);
        return _base64UrlEncode(digest.bytes);

      case 'HS512':
        final hmac = Hmac(sha512, secretBytes);
        final digest = hmac.convert(dataBytes);
        return _base64UrlEncode(digest.bytes);

      default:
        // Default to HS256
        final hmac = Hmac(sha256, secretBytes);
        final digest = hmac.convert(dataBytes);
        return _base64UrlEncode(digest.bytes);
    }
  } catch (e) {
    // Return placeholder signature if creation fails
    return _base64UrlEncode(utf8.encode('signature_generation_failed'));
  }
}

String _base64UrlEncode(List<int> bytes) {
  return base64Url.encode(bytes).replaceAll('=', '');
}
