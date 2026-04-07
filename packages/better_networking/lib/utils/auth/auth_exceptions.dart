class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class OAuth2ConfigurationException extends AuthException {
  const OAuth2ConfigurationException(super.message);
}

class OAuth2AuthorizationException extends AuthException {
  const OAuth2AuthorizationException(super.message);
}

class OAuth2CallbackHandlerRequiredException extends AuthException {
  OAuth2CallbackHandlerRequiredException({
    required String callbackUrlScheme,
    required String platformDescription,
  }) : super(
         'A custom callback handler is required for OAuth2 authorization on '
         '$platformDescription. Provide a handler capable of completing the '
         'redirect for the "$callbackUrlScheme" scheme.',
       );
}
