import 'package:apidash/models/models.dart';

import '../routes/dashbot_routes.dart';

/// Computes the base Dashbot route for a given request based on whether a
/// response exists.
/// - Returns [DashbotRoutes.dashbotHome] if the request has a response (either
///   statusCode or responseStatus present).
/// - Otherwise returns [DashbotRoutes.dashbotDefault].
String computeDashbotBaseRoute(RequestModel? req) {
  final hasResponse = (req?.httpResponseModel?.statusCode != null) ||
      (req?.responseStatus != null);
  return hasResponse ? DashbotRoutes.dashbotHome : DashbotRoutes.dashbotDefault;
}

/// Returns true if the route that should be shown for [req] differs from the
/// currently active [currentRoute].
/// This helper is pure and does not perform any side effects.
bool needsDashbotRouteChange(RequestModel? req, String currentRoute) {
  final target = computeDashbotBaseRoute(req);
  return target != currentRoute;
}
