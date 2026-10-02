import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';

import '../routes/dashbot_routes.dart';

/// Computes the base Dashbot route for a given request.
/// - For WebSocket requests, returns [DashbotRoutes.dashbotHome] once the
///   connection has been attempted/established at least once (lifecycle
///   events land in `messageHistory` on connect, so any connect attempt
///   populates it; `isStreaming` covers a live connection). This mirrors the
///   HTTP gate below: "sent" for WS means "connected at least once".
/// - Returns [DashbotRoutes.dashbotHome] if the request has a response (either
///   statusCode or responseStatus present).
/// - Otherwise returns [DashbotRoutes.dashbotDefault].
String computeDashbotBaseRoute(RequestModel? req) {
  if (req?.apiType == APIType.websocket) {
    final hasWsActivity =
        (req?.wsRequestModel?.messageHistory.isNotEmpty ?? false) ||
        (req?.isStreaming ?? false);
    return hasWsActivity
        ? DashbotRoutes.dashbotHome
        : DashbotRoutes.dashbotDefault;
  }
  if (req?.apiType == APIType.mqtt) {
    // MQTT gates exactly like WebSocket: task buttons appear only once the
    // connection has been attempted. Lifecycle events land in messageHistory
    // on connect, so any connect attempt populates it; isStreaming covers a
    // live connection.
    final hasMqttActivity =
        (req?.mqttRequestModel?.messageHistory.isNotEmpty ?? false) ||
        (req?.isStreaming ?? false);
    return hasMqttActivity
        ? DashbotRoutes.dashbotHome
        : DashbotRoutes.dashbotDefault;
  }
  final hasResponse =
      (req?.httpResponseModel?.statusCode != null) ||
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
