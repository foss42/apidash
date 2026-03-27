import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/mobile/requests_page/request_response_page_bottombar.dart';
import 'package:apidash/screens/home_page/editor_pane/url_card.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../providers/helpers.dart';

void main() {
  setUp(() async {
    await testSetUpTempDirForHive();
  });

  Widget buildTestWidget(TabController tabController) {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: RequestResponsePageBottombar(
            requestTabController: tabController,
          ),
        ),
      ),
    );
  }

  group('RequestResponsePageBottombar Widget Tests', () {
    testWidgets('should render bottom bar layout correctly with all buttons',
        (tester) async {
      final tabController = TabController(length: 3, vsync: const TestVSync());
      await tester.pumpWidget(buildTestWidget(tabController));

      expect(find.byType(RequestResponsePageBottombar), findsOneWidget);
      // Finds 2 ADFilledButtons because SendRequestButton uses one internally
      expect(find.byType(ADFilledButton), findsNWidgets(2));
      expect(find.byType(SendRequestButton), findsOneWidget);
      expect(find.text(kLabelDashBot), findsOneWidget);
    });

    testWidgets('should toggle Dashbot label to Close when tapped',
        (tester) async {
      final tabController = TabController(length: 3, vsync: const TestVSync());
      await tester.pumpWidget(buildTestWidget(tabController));

      // Initially shows DashBot
      expect(find.text(kLabelDashBot), findsOneWidget);
      expect(find.text(kLabelClose), findsNothing);

      // Tap the DashBot button
      await tester.tap(find.text(kLabelDashBot));
      await tester.pump();

      // Label should change to Close
      expect(find.text(kLabelDashBot), findsNothing);
      expect(find.text(kLabelClose), findsOneWidget);
    });
  });
}
