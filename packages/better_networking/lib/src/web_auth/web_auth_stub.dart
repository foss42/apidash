/// Stub for non-Flutter (CLI/server) environments.
/// OAuth2 browser-based flows are not supported headlessly.
class WebAuthClient {
  static Future<String> authenticate({
    required Uri url,
    required String callbackUrlScheme,
  }) async {
    throw UnsupportedError(
      'Browser-based OAuth2 is not supported in CLI mode. '
      'Use API key or token-based authentication instead.',
    );
  }
}
