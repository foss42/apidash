import 'dart:convert';
import 'dart:math' as math;
import 'package:crypto/crypto.dart';
import '../../models/models.dart';
import '../../consts.dart';

/// Generates a simple OAuth 1.0a Authorization header directly from AuthOAuth1Model model
///
/// This function supports two OAuth 1.0a signature methods:
/// - HMAC-SHA1: Most commonly used, requires consumer secret and optional token secret
/// - Plaintext: Simple concatenation, only use over HTTPS
///
/// The function automatically:
/// - Generates timestamp and nonce
/// - Creates the signature base string
/// - Signs using the specified method
/// - Formats the Authorization header
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
    'oauth_signature_method': oauth1Model.signatureMethod.displayType
        .toUpperCase(),
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

  // Generate signature based on signature method
  final signature = _generateSignature(
    oauth1Model.signatureMethod,
    baseString,
    oauth1Model,
  );
  oauthParams['oauth_signature'] = signature;

  // Build Authorization header
  final authParts = oauthParams.entries
      .map((e) => '${e.key}="${Uri.encodeComponent(e.value)}"')
      .join(',');

  return 'OAuth $authParts';
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

/// Percent-encodes the [param] following RFC 5849.
///
/// All characters except uppercase and lowercase letters, digits and the
/// characters `-_.~` are percent-encoded.
///
/// See https://oauth.net/core/1.0a/#encoding_parameters.
String _encodeParam(String param) {
  return Uri.encodeComponent(param)
      .replaceAll('!', '%21')
      .replaceAll('*', '%2A')
      .replaceAll("'", '%27')
      .replaceAll('(', '%28')
      .replaceAll(')', '%29');
}

/// Creates the signature base string for OAuth 1.0a
String _createSignatureBaseString(
  String method,
  Uri uri,
  Map<String, String> parameters,
) {
  // 1. Percent encode every key and value that will be signed
  final Map<String, String> encodedParams = <String, String>{};

  // Encode OAuth parameters
  parameters.forEach((String k, String v) {
    encodedParams[_encodeParam(k)] = _encodeParam(v);
  });

  // Add and encode query parameters from the URI
  uri.queryParameters.forEach((String k, String v) {
    encodedParams[_encodeParam(k)] = _encodeParam(v);
  });

  // Remove 'realm' parameter if present (not included in signature)
  encodedParams.remove('realm');

  // 2. Sort the list of parameters alphabetically by encoded key
  final List<String> sortedEncodedKeys = encodedParams.keys.toList()..sort();

  // 3-7. Create parameter string
  final String baseParams = sortedEncodedKeys
      .map((String k) {
        return '$k=${encodedParams[k]}';
      })
      .join('&');

  // Create base URI (origin + path)
  final baseUri = uri.origin + uri.path;

  // Create signature base string
  return '${method.toUpperCase()}&'
      '${Uri.encodeComponent(baseUri)}&'
      '${Uri.encodeComponent(baseParams)}';
}

/// Generates signature based on the specified signature method
///
/// Supports three OAuth 1.0a signature methods:
/// - HMAC-SHA1: Creates HMAC signature using SHA-1 hash (recommended)
/// - Plaintext: Returns the signing key directly (use only over HTTPS)
String _generateSignature(
  OAuth1SignatureMethod signatureMethod,
  String baseString,
  AuthOAuth1Model oauth1Model,
) {
  switch (signatureMethod) {
    case OAuth1SignatureMethod.hmacSha1:
      final signingKey =
          '${Uri.encodeComponent(oauth1Model.consumerSecret)}&'
          '${Uri.encodeComponent(oauth1Model.tokenSecret ?? '')}';
      return _generateHmacSha1Signature(baseString, signingKey);
    case OAuth1SignatureMethod.plaintext:
      final signingKey =
          '${Uri.encodeComponent(oauth1Model.consumerSecret)}&'
          '${Uri.encodeComponent(oauth1Model.tokenSecret ?? '')}';
      return signingKey;
  }
}

/// Generates HMAC-SHA1 signature for OAuth 1.0a
String _generateHmacSha1Signature(String text, String key) {
  final hmac = Hmac(sha1, utf8.encode(key));
  final digest = hmac.convert(utf8.encode(text)).bytes;

  return base64Encode(digest);
}
