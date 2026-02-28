import 'package:apidash/dashbot/providers/providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/dashbot/routes/routes.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash_core/apidash_core.dart';

import '../../../providers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DashbotActiveRouteNotifier', () {
    test('initial state computes base route from null request', () {
      final container = createContainer(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => null),
        ],
      );

      final route = container.read(dashbotActiveRouteProvider);
      expect(route, DashbotRoutes.dashbotDefault); // null request -> default
    });

    test('initial state computes base route from request without response', () {
      const request = RequestModel(
        id: '1',
        name: 'Test Request',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.example.com/test',
        ),
      );

      final container = createContainer(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => request),
        ],
      );

      final route = container.read(dashbotActiveRouteProvider);
      expect(route, DashbotRoutes.dashbotDefault); // no response -> default
    });

    test('initial state computes base route from request with response', () {
      const request = RequestModel(
        id: '1',
        name: 'Test Request',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.example.com/test',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          headers: {},
          body: 'OK',
        ),
      );

      final container = createContainer(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => request),
        ],
      );

      final route = container.read(dashbotActiveRouteProvider);
      expect(route, DashbotRoutes.dashbotHome); // has response -> home
    });

    test('goToChat() sets route to chat and pins it', () {
      final container = createContainer(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => null),
        ],
      );

      final notifier = container.read(dashbotActiveRouteProvider.notifier);

      // Initially default route
      expect(container.read(dashbotActiveRouteProvider),
          DashbotRoutes.dashbotDefault);

      // Go to chat
      notifier.goToChat();
      expect(container.read(dashbotActiveRouteProvider),
          DashbotRoutes.dashbotChat);
    });

    test('goToChat() does nothing when already on chat route', () {
      final container = createContainer(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => null),
        ],
      );

      final notifier = container.read(dashbotActiveRouteProvider.notifier);

      // First go to chat
      notifier.goToChat();
      expect(container.read(dashbotActiveRouteProvider),
          DashbotRoutes.dashbotChat);

      // Call again - should return early
      final stateBefore = container.read(dashbotActiveRouteProvider);
      notifier.goToChat();
      final stateAfter = container.read(dashbotActiveRouteProvider);

      expect(stateAfter, stateBefore); // No change
      expect(stateAfter, DashbotRoutes.dashbotChat);
    });

    test('chat pinned state persists when request changes', () {
      const requestWithoutResponse = RequestModel(
        id: '1',
        name: 'Test Request',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.example.com/test',
        ),
      );

      const requestWithResponse = RequestModel(
        id: '2',
        name: 'Test Request 2',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.example.com/test2',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          headers: {},
          body: 'OK',
        ),
      );

      final requestProvider = StateProvider<RequestModel?>((ref) => null);

      final container = createContainer(
        overrides: [
          selectedRequestModelProvider
              .overrideWith((ref) => ref.watch(requestProvider)),
        ],
      );

      final notifier = container.read(dashbotActiveRouteProvider.notifier);

      // Start with request without response
      container.read(requestProvider.notifier).state = requestWithoutResponse;
      expect(container.read(dashbotActiveRouteProvider),
          DashbotRoutes.dashbotDefault);

      // Pin to chat
      notifier.goToChat();
      expect(container.read(dashbotActiveRouteProvider),
          DashbotRoutes.dashbotChat);

      // Change to request with response - should stay pinned to chat
      container.read(requestProvider.notifier).state = requestWithResponse;
      expect(container.read(dashbotActiveRouteProvider),
          DashbotRoutes.dashbotChat);
    });

    test('resetToBaseRoute() unpins chat and recalculates from current request',
        () {
      const requestWithResponse = RequestModel(
        id: '1',
        name: 'Test Request',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.example.com/test',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          headers: {},
          body: 'OK',
        ),
      );

      final container = createContainer(
        overrides: [
          selectedRequestModelProvider
              .overrideWith((ref) => requestWithResponse),
        ],
      );

      final notifier = container.read(dashbotActiveRouteProvider.notifier);

      // Initially home route (has response)
      expect(container.read(dashbotActiveRouteProvider),
          DashbotRoutes.dashbotHome);

      // Pin to chat
      notifier.goToChat();
      expect(container.read(dashbotActiveRouteProvider),
          DashbotRoutes.dashbotChat);

      // Reset to base route
      notifier.resetToBaseRoute();
      expect(container.read(dashbotActiveRouteProvider),
          DashbotRoutes.dashbotHome);
    });

    test('resetToBaseRoute() with null request returns default route', () {
      final container = createContainer(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => null),
        ],
      );

      final notifier = container.read(dashbotActiveRouteProvider.notifier);

      // Pin to chat
      notifier.goToChat();
      expect(container.read(dashbotActiveRouteProvider),
          DashbotRoutes.dashbotChat);

      // Reset to base route
      notifier.resetToBaseRoute();
      expect(container.read(dashbotActiveRouteProvider),
          DashbotRoutes.dashbotDefault);
    });

    test('setRoute() to chat delegates to goToChat()', () {
      final container = createContainer(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => null),
        ],
      );

      final notifier = container.read(dashbotActiveRouteProvider.notifier);

      // Initially default route
      expect(container.read(dashbotActiveRouteProvider),
          DashbotRoutes.dashbotDefault);

      // Set route to chat - should delegate to goToChat
      notifier.setRoute(DashbotRoutes.dashbotChat);
      expect(container.read(dashbotActiveRouteProvider),
          DashbotRoutes.dashbotChat);
    });

    test('setRoute() to non-chat route unpins chat and sets route', () {
      final container = createContainer(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => null),
        ],
      );

      final notifier = container.read(dashbotActiveRouteProvider.notifier);

      // Pin to chat first
      notifier.goToChat();
      expect(container.read(dashbotActiveRouteProvider),
          DashbotRoutes.dashbotChat);

      // Set route to home - should unpin and set directly
      notifier.setRoute(DashbotRoutes.dashbotHome);
      expect(container.read(dashbotActiveRouteProvider),
          DashbotRoutes.dashbotHome);
    });

    test('setRoute() to custom route works', () {
      final container = createContainer(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => null),
        ],
      );

      final notifier = container.read(dashbotActiveRouteProvider.notifier);

      // Set custom route
      notifier.setRoute('/custom-route');
      expect(container.read(dashbotActiveRouteProvider), '/custom-route');
    });

    test('request changes are reflected when chat is not pinned', () {
      const requestWithoutResponse = RequestModel(
        id: '1',
        name: 'Test Request',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.example.com/test',
        ),
      );

      const requestWithResponse = RequestModel(
        id: '2',
        name: 'Test Request 2',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.example.com/test2',
        ),
        httpResponseModel: HttpResponseModel(
          statusCode: 200,
          headers: {},
          body: 'OK',
        ),
      );

      final requestProvider =
          StateProvider<RequestModel?>((ref) => requestWithoutResponse);

      final container = createContainer(
        overrides: [
          selectedRequestModelProvider
              .overrideWith((ref) => ref.watch(requestProvider)),
        ],
      );

      // Initially default route (no response)
      expect(container.read(dashbotActiveRouteProvider),
          DashbotRoutes.dashbotDefault);

      // Change to request with response
      container.read(requestProvider.notifier).state = requestWithResponse;
      expect(container.read(dashbotActiveRouteProvider),
          DashbotRoutes.dashbotHome);

      // Change back to request without response
      container.read(requestProvider.notifier).state = requestWithoutResponse;
      expect(container.read(dashbotActiveRouteProvider),
          DashbotRoutes.dashbotDefault);
    });
  });
}
