import 'package:better_networking/better_networking.dart';

/// Resolves authentication model with cascading priority:
/// 1. Request-level auth (if defined and not 'none')
/// 2. Environment-level auth (if defined and not 'none')
/// 3. Global-level auth (if defined and not 'none')
/// 4. null (no authentication)
///
/// Returns the resolved AuthModel or null if no authentication is configured.
AuthModel? resolveAuth({
  AuthModel? requestAuth,
  AuthModel? environmentAuth,
  AuthModel? globalAuth,
}) {
  // Check request-level auth first
  if (requestAuth != null && requestAuth.type != APIAuthType.none) {
    return requestAuth;
  }

  // Fall back to environment-level auth
  if (environmentAuth != null && environmentAuth.type != APIAuthType.none) {
    return environmentAuth;
  }

  // Fall back to global-level auth
  if (globalAuth != null && globalAuth.type != APIAuthType.none) {
    return globalAuth;
  }

  // No authentication configured
  return null;
}
