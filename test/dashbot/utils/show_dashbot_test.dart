import 'package:apidash/dashbot/providers/providers.dart';
import 'package:apidash/dashbot/utils/utils.dart';
import 'package:apidash/dashbot/dashbot_dashboard.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<(BuildContext, WidgetRef)> pumpHarness(
    WidgetTester tester, {
    List<Override>? overrides,
  }) async {
    late BuildContext ctx;
    late WidgetRef wRef;
    await tester.pumpWidget(ProviderScope(
      overrides: [
        // Empty current request (StateProvider override supplies initial value).
        selectedRequestModelProvider.overrideWith((ref) => null),
        if (overrides != null) ...overrides,
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Consumer(builder: (c, ref, _) {
            ctx = c;
            wRef = ref;
            return const SizedBox();
          }),
        ),
      ),
    ));
    // Enlarge window width to avoid Row overflow in header (actions + title)
    final notifier = wRef.read(dashbotWindowNotifierProvider.notifier);
    notifier.state = notifier.state.copyWith(width: 650);
    return (ctx, wRef);
  }

  group('showDashbotWindow', () {
    testWidgets('activates & inserts overlay when inactive & popped',
        (tester) async {
      final (ctx, ref) = await pumpHarness(tester);
      expect(ref.read(dashbotWindowNotifierProvider).isActive, isFalse);
      showDashbotWindow(ctx, ref);
      await tester.pump();
      // State toggled active
      expect(ref.read(dashbotWindowNotifierProvider).isActive, isTrue);
      // DashBot title text present (from DashbotWindow)
      expect(find.text('DashBot'), findsOneWidget);
    });

    testWidgets('early return when already active', (tester) async {
      final (ctx, ref) = await pumpHarness(tester);
      // Manually set active before calling util to hit early return.
      ref.read(dashbotWindowNotifierProvider.notifier).toggleActive();
      final before = ref.read(dashbotWindowNotifierProvider);
      showDashbotWindow(ctx, ref);
      await tester.pump();
      final after = ref.read(dashbotWindowNotifierProvider);
      expect(after.isActive, isTrue);
      // No duplicate activation toggling (remains same instance/state)
      expect(after.isActive, before.isActive);
    });

    testWidgets('early return when not popped', (tester) async {
      final (ctx, ref) = await pumpHarness(tester);
      // Toggle popped to false
      ref.read(dashbotWindowNotifierProvider.notifier).togglePopped();
      expect(ref.read(dashbotWindowNotifierProvider).isPopped, isFalse);
      showDashbotWindow(ctx, ref);
      await tester.pump();
      // Still inactive because not popped
      expect(ref.read(dashbotWindowNotifierProvider).isActive, isFalse);
      expect(find.byType(DashbotWindow), findsNothing);
    });

    testWidgets('pressing close button removes overlay & deactivates',
        (tester) async {
      final (ctx, ref) = await pumpHarness(tester);
      showDashbotWindow(ctx, ref);
      await tester.pump();
      expect(ref.read(dashbotWindowNotifierProvider).isActive, isTrue);
      // Tap the close (Icons.close)
      final closeFinder = find.byIcon(Icons.close);
      expect(closeFinder, findsOneWidget);
      await tester.tap(closeFinder);
      await tester.pump();
      expect(ref.read(dashbotWindowNotifierProvider).isActive, isFalse);
    });
  });
}
