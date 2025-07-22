import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:crypto/crypto.dart';

import '../../models/models.dart';

/// Generates a simple OAuth 1.0a Authorization header directly from model
String generateOAuth1AuthHeader(
  AuthOAuth1Model oauth1Model,
  HttpRequestModel request,
) {
  // Generate OAuth parameters
  final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
  final nonce = _generateNonce();

  // Build OAuth parameters map
  final oauthParams = <String, String>{
    'oauth_consumer_key': oauth1Model.consumerKey,
    'oauth_signature_method': "HMAC-SHA1",
    'oauth_timestamp': timestamp,
    'oauth_nonce': nonce,
    'oauth_version': oauth1Model.version,
  };

  // Add oauth_token if available
  if (oauth1Model.accessToken != null && oauth1Model.accessToken!.isNotEmpty) {
    oauthParams['oauth_token'] = oauth1Model.accessToken!;
  }

  // Create signature base string and signing key
  final method = request.method.name.toUpperCase();
  final uri = Uri.parse(request.url);
  final baseString = _createSignatureBaseString(method, uri, oauthParams);
  final signingKey =
      '${Uri.encodeComponent(oauth1Model.consumerSecret)}&'
      '${Uri.encodeComponent(oauth1Model.tokenSecret ?? '')}';

  // Generate signature using HMAC-SHA1
  final signature = _generateHmacSha1Signature(baseString, signingKey);
  oauthParams['oauth_signature'] = signature;

  // Build Authorization header
  final authParts = oauthParams.entries
      .map((e) => '${e.key}="${Uri.encodeComponent(e.value)}"')
      .join(',');

  return 'OAuth $authParts';
}

/// Helper function to clear saved OAuth 1.0 credentials
Future<void> clearOAuth1Credentials(File credentialsFile) async {
  if (await credentialsFile.exists()) {
    try {
      await credentialsFile.delete();
      log('Cleared OAuth 1.0 credentials');
    } catch (e) {
      log('Error clearing OAuth 1.0 credentials: $e');
    }
  }
}

/// Generates a random nonce for OAuth 1.0a
String _generateNonce() {
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = math.Random.secure();
  return String.fromCharCodes(
    Iterable.generate(
      16,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ),
  );
}

/// Creates the signature base string for OAuth 1.0a
String _createSignatureBaseString(
  String method,
  Uri uri,
  Map<String, String> parameters,
) {
  // Combine OAuth parameters with query parameters
  final allParameters = <String, String>{...parameters};

  // Add query parameters from the URI
  uri.queryParameters.forEach((key, value) {
    allParameters[key] = value;
  });

  // Sort parameters by key
  final sortedKeys = allParameters.keys.toList()..sort();

  // Create parameter string
  final paramString = sortedKeys
      .map(
        (key) =>
            '${Uri.encodeComponent(key)}=${Uri.encodeComponent(allParameters[key]!)}',
      )
      .join('&');

  // Create base URI (without query parameters)
  final baseUri = uri.replace(queryParameters: {}).toString();

  // Create signature base string
  return '${method.toUpperCase()}&'
      '${Uri.encodeComponent(baseUri)}&'
      '${Uri.encodeComponent(paramString)}';
}

/// Generates HMAC-SHA1 signature for OAuth 1.0a
String _generateHmacSha1Signature(String baseString, String key) {
  final keyBytes = utf8.encode(key);
  final messageBytes = utf8.encode(baseString);

  final hmac = Hmac(sha1, keyBytes);
  final digest = hmac.convert(messageBytes);

  return base64Encode(digest.bytes);
}
