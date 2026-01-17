import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/consts.dart';
import '../models/models.dart';

/// Resolves authentication credentials following the priority hierarchy:
/// Request > Environment > Global
///
/// Returns the resolved [AuthModel] or null if no authentication is configured
/// at any level.
AuthModel? resolveAuth(
  RequestModel request,
  String? activeEnvironmentId,
  Map<String, EnvironmentModel>? environments,
) {
  // Priority 1: Request-level authentication (highest priority)
  final requestAuth = request.httpRequestModel?.authModel;
  if (requestAuth != null && requestAuth.type != APIAuthType.none) {
    return requestAuth;
  }

  // Priority 2: Environment-level authentication
  if (activeEnvironmentId != null && environments != null) {
    final environment = environments[activeEnvironmentId];
    final environmentAuth = environment?.authModel;
    if (environmentAuth != null && environmentAuth.type != APIAuthType.none) {
      return environmentAuth;
    }
  }

  // Priority 3: Global-level authentication (lowest priority)
  if (environments != null) {
    final globalEnvironment = environments[kGlobalEnvironmentId];
    final globalAuth = globalEnvironment?.authModel;
    if (globalAuth != null && globalAuth.type != APIAuthType.none) {
      return globalAuth;
    }
  }

  // No authentication found at any level
  return null;
}
