import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/pages/pages.dart';
import 'package:apidash/dashbot/routes/dashbot_router.dart';
import 'package:apidash/dashbot/routes/dashbot_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Dashbot Router Tests', () {
    testWidgets('generateRoute for dashbotHome builds DashbotHomePage', (WidgetTester tester) async {
      final route = generateRoute(const RouteSettings(name: DashbotRoutes.dashbotHome)) as MaterialPageRoute;
      expect(route.settings.name, DashbotRoutes.dashbotHome);
      await tester.pumpWidget(Builder(builder: (context) {
        expect(route.builder(context), isA<DashbotHomePage>());
        return const SizedBox();
      }));
    });

    testWidgets('generateRoute for dashbotDefault builds DashbotDefaultPage', (WidgetTester tester) async {
      final route = generateRoute(const RouteSettings(name: DashbotRoutes.dashbotDefault)) as MaterialPageRoute;
      expect(route.settings.name, DashbotRoutes.dashbotDefault);
      await tester.pumpWidget(Builder(builder: (context) {
        expect(route.builder(context), isA<DashbotDefaultPage>());
        return const SizedBox();
      }));
    });

    testWidgets('generateRoute for dashbotChat with argument builds ChatScreen', (WidgetTester tester) async {
      final route = generateRoute(
          const RouteSettings(name: DashbotRoutes.dashbotChat, arguments: ChatMessageType.generateTest)) as MaterialPageRoute;
      expect(route.settings.name, DashbotRoutes.dashbotChat);
      await tester.pumpWidget(Builder(builder: (context) {
        expect(route.builder(context), isA<ChatScreen>());
        return const SizedBox();
      }));
    });

    testWidgets('generateRoute for dashbotChat without argument builds ChatScreen', (WidgetTester tester) async {
      final route = generateRoute(const RouteSettings(name: DashbotRoutes.dashbotChat)) as MaterialPageRoute;
      expect(route.settings.name, DashbotRoutes.dashbotChat);
      await tester.pumpWidget(Builder(builder: (context) {
        expect(route.builder(context), isA<ChatScreen>());
        return const SizedBox();
      }));
    });

    testWidgets('generateRoute for unknown route builds DashbotDefaultPage', (WidgetTester tester) async {
      final route = generateRoute(const RouteSettings(name: 'unknown_route')) as MaterialPageRoute;
      expect(route.settings.name, DashbotRoutes.dashbotDefault);
      await tester.pumpWidget(Builder(builder: (context) {
        expect(route.builder(context), isA<DashbotDefaultPage>());
        return const SizedBox();
      }));
    });
  });
}
