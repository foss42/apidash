import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/mobile_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Mobile bottom Navbar tests',
    () {
      testWidgets(
        'Check if structure is maintained',
        (tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                bottomNavigationBar: ProviderScope(child: MobileBottomNavBar()),
              ),
            ),
          );

          // request, response, code text present
          expect(find.text("request"), findsOneWidget);
          expect(find.text("response"), findsOneWidget);
          expect(find.text("code"), findsOneWidget);

          // request, response, code icons present
          expect(
              find.byIcon(Icons.auto_awesome_mosaic_outlined), findsOneWidget);
          expect(find.byIcon(Icons.north_east_rounded), findsOneWidget);
          expect(find.byIcon(Icons.code), findsOneWidget);
        },
      );

      testWidgets(
        'Check provider value on tap',
        (tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                bottomNavigationBar: ProviderScope(child: MobileBottomNavBar()),
              ),
            ),
          );

          final element = tester.element(find.byType(MobileBottomNavBar));
          final container = ProviderScope.containerOf(element);

          // request
          await tester.tap(find.text("request"));
          expect(container.read(mobileBottomNavIndexStateProvider), 0);

          // response
          await tester.tap(find.text("response"));
          expect(container.read(mobileBottomNavIndexStateProvider), 1);

          // code
          await tester.tap(find.text("code"));
          expect(container.read(mobileBottomNavIndexStateProvider), 2);
        },
      );
    },
  );
}
