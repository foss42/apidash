import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import '../routes/dashbot_routes.dart';
import '../utils/dashbot_route_utils.dart';

/// A Notifier that exposes the current Dashbot active route.
///
/// Behavior:
/// - Default state is computed from the currently selected request using
///   [computeDashbotBaseRoute].
/// - Automatically updates when the selected request changes, *unless* the
///   route has been manually set to Chat (Chat acts as a user override).
/// - Public method [goToChat] pins the route to Chat.
/// - Public method [resetToBaseRoute] recalculates from the current request
///   (used after clearing chat, etc.).
class DashbotActiveRouteNotifier extends Notifier<String> {
  bool _chatPinned = false;

  @override
  String build() {
    // Watch current request for automatic base route computation.
    final req = ref.watch(selectedRequestModelProvider);
    ref.keepAlive();

    // If chat is pinned we always stay on chat regardless of request changes.
    if (_chatPinned) {
      return DashbotRoutes.dashbotChat;
    }
    // Otherwise compute the base route from the current request.
    return computeDashbotBaseRoute(req);
  }

  void goToChat() {
    if (state == DashbotRoutes.dashbotChat) return;
    _chatPinned = true;
    state = DashbotRoutes.dashbotChat;
  }

  void resetToBaseRoute() {
    _chatPinned = false;
    final req = ref.read(selectedRequestModelProvider);
    final target = computeDashbotBaseRoute(req);
    state = target;
  }

  /// Force set a specific route (used rarely; prefers semantic helpers).
  void setRoute(String route) {
    if (route == DashbotRoutes.dashbotChat) {
      goToChat();
      return;
    }
    _chatPinned = false;
    state = route;
  }
}

final dashbotActiveRouteProvider =
    NotifierProvider<DashbotActiveRouteNotifier, String>(
  () => DashbotActiveRouteNotifier(),
  name: 'dashbotActiveRouteProvider',
);
