import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashbotRouter', () {
    group('generateRoute', () {
      test('should return MaterialPageRoute for dashbotHome route', () {
        // Arrange
        const settings = RouteSettings(name: DashbotRoutes.dashbotHome);

        // Act
        final route = generateRoute(settings);

        // Assert
        expect(route, isA<MaterialPageRoute>());
        expect(route!.settings.name, equals(DashbotRoutes.dashbotHome));
      });

      test('should return MaterialPageRoute for dashbotDefault route', () {
        // Arrange
        const settings = RouteSettings(name: DashbotRoutes.dashbotDefault);

        // Act
        final route = generateRoute(settings);

        // Assert
        expect(route, isA<MaterialPageRoute>());
        expect(route!.settings.name, equals(DashbotRoutes.dashbotDefault));
      });

      test('should return MaterialPageRoute for dashbotChat route', () {
        // Arrange
        const settings = RouteSettings(name: DashbotRoutes.dashbotChat);

        // Act
        final route = generateRoute(settings);

        // Assert
        expect(route, isA<MaterialPageRoute>());
        expect(route!.settings.name, equals(DashbotRoutes.dashbotChat));
      });

      test(
          'should return MaterialPageRoute for dashbotChat route with ChatMessageType argument',
          () {
        // Arrange
        const initialTask = ChatMessageType.generateTest;
        const settings = RouteSettings(
          name: DashbotRoutes.dashbotChat,
          arguments: initialTask,
        );

        // Act
        final route = generateRoute(settings);

        // Assert
        expect(route, isA<MaterialPageRoute>());
        expect(route!.settings.name, equals(DashbotRoutes.dashbotChat));
      });

      test('should handle dashbotChat route with non-ChatMessageType argument',
          () {
        // Arrange
        const settings = RouteSettings(
          name: DashbotRoutes.dashbotChat,
          arguments: 'invalid_argument',
        );

        // Act
        final route = generateRoute(settings);

        // Assert
        expect(route, isA<MaterialPageRoute>());
        expect(route!.settings.name, equals(DashbotRoutes.dashbotChat));
      });

      test('should return default route for unknown route names', () {
        // Arrange
        const settings = RouteSettings(name: '/unknown_route');

        // Act
        final route = generateRoute(settings);

        // Assert
        expect(route, isA<MaterialPageRoute>());
        expect(route!.settings.name, equals(DashbotRoutes.dashbotDefault));
      });

      test('should return default route for null route name', () {
        // Arrange
        const settings = RouteSettings(name: null);

        // Act
        final route = generateRoute(settings);

        // Assert
        expect(route, isA<MaterialPageRoute>());
        expect(route!.settings.name, equals(DashbotRoutes.dashbotDefault));
      });

      test('should handle all ChatMessageType enum values as arguments', () {
        for (final messageType in ChatMessageType.values) {
          // Arrange
          final settings = RouteSettings(
            name: DashbotRoutes.dashbotChat,
            arguments: messageType,
          );

          // Act
          final route = generateRoute(settings);

          // Assert
          expect(route, isA<MaterialPageRoute>());
          expect(route!.settings.name, equals(DashbotRoutes.dashbotChat));
        }
      });

      test('should return correct route settings for each defined route', () {
        // Test all defined routes
        final routesToTest = [
          DashbotRoutes.dashbotHome,
          DashbotRoutes.dashbotDefault,
          DashbotRoutes.dashbotChat,
        ];

        for (final routeName in routesToTest) {
          // Arrange
          final settings = RouteSettings(name: routeName);

          // Act
          final route = generateRoute(settings);

          // Assert
          expect(route, isA<MaterialPageRoute>());
          expect(route!.settings.name, isNotNull);

          // Each route should have its respective name in settings
          if (routeName == DashbotRoutes.dashbotChat) {
            expect(route.settings.name, equals(DashbotRoutes.dashbotChat));
          } else if (routeName == DashbotRoutes.dashbotHome) {
            expect(route.settings.name, equals(DashbotRoutes.dashbotHome));
          } else {
            expect(route.settings.name, equals(DashbotRoutes.dashbotDefault));
          }
        }
      });

      test('should handle empty string route name', () {
        // Arrange
        const settings = RouteSettings(name: '');

        // Act
        final route = generateRoute(settings);

        // Assert
        expect(route, isA<MaterialPageRoute>());
        expect(route!.settings.name, equals(DashbotRoutes.dashbotDefault));
      });

      test('should handle route with arguments but different route name', () {
        // Arrange
        const settings = RouteSettings(
          name: DashbotRoutes.dashbotDefault,
          arguments: ChatMessageType.generateCode,
        );

        // Act
        final route = generateRoute(settings);

        // Assert
        expect(route, isA<MaterialPageRoute>());
        expect(route!.settings.name, equals(DashbotRoutes.dashbotDefault));
      });

      test('should ensure route is not null for all valid routes', () {
        // Test that generateRoute never returns null for defined routes
        final routesToTest = [
          DashbotRoutes.dashbotHome,
          DashbotRoutes.dashbotDefault,
          DashbotRoutes.dashbotChat,
          '/unknown_route',
          null,
          '',
        ];

        for (final routeName in routesToTest) {
          // Arrange
          final settings = RouteSettings(name: routeName);

          // Act
          final route = generateRoute(settings);

          // Assert
          expect(route, isNotNull,
              reason: 'Route should not be null for route name: $routeName');
          expect(route, isA<MaterialPageRoute>());
        }
      });

      test('should handle special characters in route names', () {
        // Test routes with special characters
        final specialRoutes = [
          '/route-with-dashes',
          '/route_with_underscores',
          '/route123',
          '/route/with/slashes',
        ];

        for (final routeName in specialRoutes) {
          // Arrange
          final settings = RouteSettings(name: routeName);

          // Act
          final route = generateRoute(settings);

          // Assert
          expect(route, isA<MaterialPageRoute>());
          expect(route!.settings.name, equals(DashbotRoutes.dashbotDefault));
        }
      });
    });
  });
}
